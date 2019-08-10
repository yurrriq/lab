# NOTE: https://stackoverflow.com/a/17550243
SHELL := bash

docker_run := docker run --rm -w /tmp -v $$PWD:/tmp


ifneq (,$(shell command -v emacs))
emacs := emacs
else
ifeq (,$(shell command -v docker))
$(error Please install Docker or Emacs)
else
emacs := ${docker_run} silex/emacs:26-alpine emacs
endif
endif


ifneq (,$(shell command -v shellcheck))
shellcheck := shellcheck
else
ifeq (,$(shell command -v docker))
$(error Please install Docker or ShellCheck)
else
shellcheck := ${docker_run} koalaman/shellcheck-alpine shellcheck
endif
endif


ifneq (,$(shell command -v shfmt))
shfmt := shfmt
else
ifeq (,$(shell command -v docker))
$(error Please install Docker or shfmt)
else
shfmt := ${docker_run} mvdan/shfmt
endif
endif


.DEFAULT: all


.PHONY: all tangle format lint


all: tangle format lint


tangle: README.org
	@ ${emacs} --batch \
		--quick \
		--load ob-tangle \
		--eval '(setq org-src-preserve-indentation t)' \
		--eval '(org-babel-tangle-file "$<")'


format: lab
	@ ${shfmt} -i 4 -w $^


lint: lab
	@ ${shellcheck} $^
