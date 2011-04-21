Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab1DUJXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:23:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:41885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab1DUJXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:23:04 -0400
Date: Thu, 21 Apr 2011 09:22:54 GMT
From: tip-bot for Michael Witten <mfwitten@gmail.com>
Message-ID: <tip-ced465c400b23656ef2c4fbfb4add0e5b92e3d97@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, mfwitten@gmail.com, rprabhu@wnohang.net,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, mfwitten@gmail.com, rprabhu@wnohang.net,
        tglx@linutronix.de
In-Reply-To: <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
References: <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Makefile: PYTHON{,_CONFIG} to bandage Python 3 incompatibility
Git-Commit-ID: ced465c400b23656ef2c4fbfb4add0e5b92e3d97
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Apr 2011 09:22:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ced465c400b23656ef2c4fbfb4add0e5b92e3d97
Gitweb:     http://git.kernel.org/tip/ced465c400b23656ef2c4fbfb4add0e5b92e3d97
Author:     Michael Witten <mfwitten@gmail.com>
AuthorDate: Sat, 2 Apr 2011 21:46:09 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Apr 2011 08:18:36 -0300

perf tools: Makefile: PYTHON{,_CONFIG} to bandage Python 3 incompatibility

Currently, Python 3 is not supported by perf's code; this
can cause the build to fail for systems that have Python 3
installed as the default python:

  python{,-config}

The Correct Solution is to write compatibility code so that
Python 3 works out-of-the-box.

However, users often have an ancillary Python 2 installed:

  python2{,-config}

Therefore, a quick fix is to allow the user to specify those
ancillary paths as the python binaries that Makefile should
use, thereby avoiding Python 3 altogether; as an added benefit,
the Python binaries may be installed in non-standard locations
without the need for updating any PATH variable.

This commit adds the ability to set PYTHON and/or PYTHON_CONFIG
either as environment variables or as make variables on the
command line; the paths may be relative, and usually only PYTHON
is necessary in order for PYTHON_CONFIG to be defined implicitly.
Some rudimentary error checking is performed when the user
explicitly specifies a value for any of these variables.

In addition, this commit introduces significantly robust makefile
infrastructure for working with paths and communicating with the
shell; it's currently only used for handling Python, but I hope
it will prove useful in refactoring the makefiles.

Thanks to:

  Raghavendra D Prabhu <rprabhu@wnohang.net>

for motivating this patch.

Acked-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
Link: http://lkml.kernel.org/r/e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com
Signed-off-by: Michael Witten <mfwitten@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |   97 +++++++++++++++++-----
 tools/perf/config/utilities.mak |  180 +++++++++++++++++++++++++++++++++++++++
 tools/perf/feature-tests.mak    |    8 ++-
 3 files changed, 264 insertions(+), 21 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index aaf4dd3..b5276c7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -5,6 +5,8 @@ endif
 # The default target of this Makefile is...
 all:
 
+include config/utilities.mak
+
 ifneq ($(OUTPUT),)
 # check that the output directory actually exists
 OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
@@ -13,6 +15,12 @@ endif
 
 # Define V to have a more verbose compile.
 #
+# Define PYTHON to point to the python binary if the default
+# `python' is not correct; for example: PYTHON=python2
+#
+# Define PYTHON_CONFIG to point to the python-config binary if
+# the default `$(PYTHON)-config' is not correct.
+#
 # Define ASCIIDOC8 if you want to format documentation with AsciiDoc 8
 #
 # Define DOCBOOK_XSL_172 if you want to format man pages with DocBook XSL v1.72.
@@ -165,7 +173,7 @@ grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
-	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' python util/setup.py \
+	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
 	  --quiet build_ext \
 	  --build-lib='$(OUTPUT)python' \
 	  --build-temp='$(OUTPUT)python/temp'
@@ -473,24 +481,74 @@ else
 	endif
 endif
 
-ifdef NO_LIBPYTHON
-	BASIC_CFLAGS += -DNO_LIBPYTHON
+disable-python = $(eval $(disable-python_code))
+define disable-python_code
+  BASIC_CFLAGS += -DNO_LIBPYTHON
+  $(if $(1),$(warning No $(1) was found))
+  $(warning Python support won't be built)
+endef
+
+override PYTHON := \
+  $(call get-executable-or-default,PYTHON,python)
+
+ifndef PYTHON
+  $(call disable-python,python interpreter)
+  python-clean :=
 else
-       PYTHON_EMBED_LDOPTS = $(shell python-config --ldflags 2>/dev/null)
-       PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
-       PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
-	PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
-	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
-	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
-		msg := $(warning No Python.h found, install python-dev[el] to have python support in 'perf script' and to build the python bindings)
-		BASIC_CFLAGS += -DNO_LIBPYTHON
-	else
-               ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
-               EXTLIBS += $(PYTHON_EMBED_LIBADD)
-		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
-		LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
-		LANG_BINDINGS += $(OUTPUT)python/perf.so
-	endif
+
+  PYTHON_WORD := $(call shell-wordify,$(PYTHON))
+
+  python-clean := $(PYTHON_WORD) util/setup.py clean \
+    --build-lib='$(OUTPUT)python' \
+    --build-temp='$(OUTPUT)python/temp'
+
+  ifdef NO_LIBPYTHON
+    $(call disable-python)
+  else
+
+    override PYTHON_CONFIG := \
+      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
+
+    ifndef PYTHON_CONFIG
+      $(call disable-python,python-config tool)
+    else
+
+      PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
+
+      PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+      PYTHON_EMBED_LDFLAGS := $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+      PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
+      PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+      FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+
+      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
+        $(call disable-python,Python.h (for Python 2.x))
+      else
+
+        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED)),y)
+          $(warning Python 3 is not yet supported; please set)
+          $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
+          $(warning If you also have Python 2 installed, then)
+          $(warning try something like:)
+          $(warning $(and ,))
+          $(warning $(and ,)  make PYTHON=python2)
+          $(warning $(and ,))
+          $(warning Otherwise, disable Python support entirely:)
+          $(warning $(and ,))
+          $(warning $(and ,)  make NO_LIBPYTHON=1)
+          $(warning $(and ,))
+          $(error   $(and ,))
+        else
+          ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
+          EXTLIBS += $(PYTHON_EMBED_LIBADD)
+          LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
+          LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
+          LANG_BINDINGS += $(OUTPUT)python/perf.so
+        endif
+
+      endif
+    endif
+  endif
 endif
 
 ifdef NO_DEMANGLE
@@ -831,8 +889,7 @@ clean:
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(MAKE) -C Documentation/ clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
-	@python util/setup.py clean --build-lib='$(OUTPUT)python' \
-				   --build-temp='$(OUTPUT)python/temp'
+	$(python-clean)
 
 .PHONY: all install clean strip
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
new file mode 100644
index 0000000..6d8ff88
--- /dev/null
+++ b/tools/perf/config/utilities.mak
@@ -0,0 +1,180 @@
+# This allows us to work with the newline character:
+define newline
+
+
+endef
+newline := $(newline)
+
+# nl-escape
+#
+# Usage: escape = $(call nl-escape[,escape])
+#
+# This is used as the common way to specify
+# what should replace a newline when escaping
+# newlines; the default is a bizarre string.
+#
+nl-escape = $(or $(1),m822df3020w6a44id34bt574ctac44eb9f4n)
+
+# escape-nl
+#
+# Usage: escaped-text = $(call escape-nl,text[,escape])
+#
+# GNU make's $(shell ...) function converts to a
+# single space each newline character in the output
+# produced during the expansion; this may not be
+# desirable.
+#
+# The only solution is to change each newline into
+# something that won't be converted, so that the
+# information can be recovered later with
+# $(call unescape-nl...)
+#
+escape-nl = $(subst $(newline),$(call nl-escape,$(2)),$(1))
+
+# unescape-nl
+#
+# Usage: text = $(call unescape-nl,escaped-text[,escape])
+#
+# See escape-nl.
+#
+unescape-nl = $(subst $(call nl-escape,$(2)),$(newline),$(1))
+
+# shell-escape-nl
+#
+# Usage: $(shell some-command | $(call shell-escape-nl[,escape]))
+#
+# Use this to escape newlines from within a shell call;
+# the default escape is a bizarre string.
+#
+# NOTE: The escape is used directly as a string constant
+#       in an `awk' program that is delimited by shell
+#       single-quotes, so be wary of the characters
+#       that are chosen.
+#
+define shell-escape-nl
+awk 'NR==1 {t=$$0} NR>1 {t=t "$(nl-escape)" $$0} END {printf t}'
+endef
+
+# shell-unescape-nl
+#
+# Usage: $(shell some-command | $(call shell-unescape-nl[,escape]))
+#
+# Use this to unescape newlines from within a shell call;
+# the default escape is a bizarre string.
+#
+# NOTE: The escape is used directly as an extended regular
+#       expression constant in an `awk' program that is
+#       delimited by shell single-quotes, so be wary
+#       of the characters that are chosen.
+#
+# (The bash shell has a bug where `{gsub(...),...}' is
+#  misinterpreted as a brace expansion; this can be
+#  overcome by putting a space between `{' and `gsub').
+#
+define shell-unescape-nl
+awk 'NR==1 {t=$$0} NR>1 {t=t "\n" $$0} END { gsub(/$(nl-escape)/,"\n",t); printf t }'
+endef
+
+# escape-for-shell-sq
+#
+# Usage: embeddable-text = $(call escape-for-shell-sq,text)
+#
+# This function produces text that is suitable for
+# embedding in a shell string that is delimited by
+# single-quotes.
+#
+escape-for-shell-sq =  $(subst ','\'',$(1))
+
+# shell-sq
+#
+# Usage: single-quoted-and-escaped-text = $(call shell-sq,text)
+#
+shell-sq = '$(escape-for-shell-sq)'
+
+# shell-wordify
+#
+# Usage: wordified-text = $(call shell-wordify,text)
+#
+# For instance:
+#
+#  |define text
+#  |hello
+#  |world
+#  |endef
+#  |
+#  |target:
+#  |	echo $(call shell-wordify,$(text))
+#
+# At least GNU make gets confused by expanding a newline
+# within the context of a command line of a makefile rule
+# (this is in constrast to a `$(shell ...)' function call,
+# which can handle it just fine).
+#
+# This function avoids the problem by producing a string
+# that works as a shell word, regardless of whether or
+# not it contains a newline.
+#
+# If the text to be wordified contains a newline, then
+# an intrictate shell command substitution is constructed
+# to render the text as a single line; when the shell
+# processes the resulting escaped text, it transforms
+# it into the original unescaped text.
+#
+# If the text does not contain a newline, then this function
+# produces the same results as the `$(shell-sq)' function.
+#
+shell-wordify = $(if $(findstring $(newline),$(1)),$(_sw-esc-nl),$(shell-sq))
+define _sw-esc-nl
+"$$(echo $(call escape-nl,$(shell-sq),$(2)) | $(call shell-unescape-nl,$(2)))"
+endef
+
+# is-absolute
+#
+# Usage: bool-value = $(call is-absolute,path)
+#
+is-absolute = $(shell echo $(shell-sq) | grep ^/ -q && echo y)
+
+# lookup
+#
+# Usage: absolute-executable-path-or-empty = $(call lookup,path)
+#
+# (It's necessary to use `sh -c' because GNU make messes up by
+#  trying too hard and getting things wrong).
+#
+lookup = $(call unescape-nl,$(shell sh -c $(_l-sh)))
+_l-sh = $(call shell-sq,command -v $(shell-sq) | $(call shell-escape-nl,))
+
+# is-executable
+#
+# Usage: bool-value = $(call is-executable,path)
+#
+# (It's necessary to use `sh -c' because GNU make messes up by
+#  trying too hard and getting things wrong).
+#
+is-executable = $(call _is-executable-helper,$(shell-sq))
+_is-executable-helper = $(shell sh -c $(_is-executable-sh))
+_is-executable-sh = $(call shell-sq,test -f $(1) -a -x $(1) && echo y)
+
+# get-executable
+#
+# Usage: absolute-executable-path-or-empty = $(call get-executable,path)
+#
+# The goal is to get an absolute path for an executable;
+# the `command -v' is defined by POSIX, but it's not
+# necessarily very portable, so it's only used if
+# relative path resolution is requested, as determined
+# by the presence of a leading `/'.
+#
+get-executable = $(if $(1),$(if $(is-absolute),$(_ge-abspath),$(lookup)))
+_ge-abspath = $(if $(is-executable),$(1))
+
+# get-supplied-or-default-executable
+#
+# Usage: absolute-executable-path-or-empty = $(call get-executable-or-default,variable,default)
+#
+define get-executable-or-default
+$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
+endef
+_ge_attempt = $(or $(get-executable),$(_gea_warn),$(call _gea_err,$(2)))
+_gea_warn = $(warning The path '$(1)' is not executable.)
+_gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index b041ca6..1b33420 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -79,9 +79,15 @@ endef
 endif
 
 ifndef NO_LIBPYTHON
+define SOURCE_PYTHON_VERSION
+#include <Python.h>
+#if PY_VERSION_HEX >= 0x03000000
+	#error
+#endif
+int main(void){}
+endef
 define SOURCE_PYTHON_EMBED
 #include <Python.h>
-
 int main(void)
 {
 	Py_Initialize();
