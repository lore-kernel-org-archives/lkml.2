Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1C1XcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:32:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43305 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1C1XcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:date:from:to:cc:message-id:in-reply-to:references
         :mime-version;
        b=SSBeEGA3eBD6DSd0V9PUOgqHYUmSukG6YqRZcXp8w0TVyCftBun5erEk332SVg4e1L
         OCoNNmq6gxWBgSZfyuyjKBrXX2gb7B1B9LCyt3wfYWVTVe/xw2mD8SFX+UtvIyOboNyR
         UaUim+fs2mDxrVUlwGtDXAs+DCrHD9dYKMT88=
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
Date: Mon, 28 Mar 2011 22:36:02 +0000
From: Michael Witten <mfwitten@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, linux-kernel@vger.kernel.org
Message-ID: <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
In-Reply-To: <20110328144721.GB17872@ghostprotocols.net>
References: <20110326224408.GA1336@Xye>
            <20110328144721.GB17872@ghostprotocols.net>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 17:44, Raghavendra D Prabhu <rprabhu@wnohang.net> wrote:
> On systems with python{2,3} installed, perf build can break
> which can be fixed by exporting PYTHON to the right value.
> Added support for PYTHON in the Makefile.

Yes, I too have run into this problem; my distribution, Arch Linux,
installs python3 as the main python:

  /usr/bin/python{,-config}

and python2 as an ancillary, versioned python:

  /usr/bin/python2{,-config}

The real problem here is not so much that perf's Makefile
hardcodes the program names `python' and `python-config';
rather, the problem is that perf's python code (both .c
and probably .py) is incompatible with python3, thereby
causing the build to break.

The Correct Solution (for the most part) is to make perf's
python code compatible with both versions of python
(I was hoping somebody who knows these things better would
do it, which is why I never submitted a patch for
changing the hardcoded values).

In any case, Raghavendra's patch is a pretty darn good
bandage that will allow people to keep working; however,
$(PYTHON) can be used in a few other places, and the
assignment of its value can be error-checked more thoroughly.

The following is a patch that does a bit more; you can save
this email to `path/to/email' and then apply the patch
by running:

  git am --scissors path/to/email

8<--------8<--------8<--------8<--------8<--------8<--------8<
Subject: [PATCH] perf tools: Makefile: PYTHON{,_CONFIG} to bandage python3 incompatibility
Currently, python3 is not supported by perf's code; this
can cause the build to fail for systems that have python3
installed as the default python:

  python{,-config}

The Correct Solution is to write compatibility code so that
python3 works out-of-the-box.

However, users often have an ancillary python2 installed:

  python2{,-config}

Therefore, a quick fix is to allow the user to specify those
ancillary paths as the python binaries that Makefile should
use, thereby avoiding python3 altogether.

This commit adds the ability to set PYTHON and/or PYTHON_CONFIG
either as environment variables or as make variables on the
command line; the paths may be relative, and usually only
PYTHON is necessary in order for PYTHON_CONFIG to be defined
implicitly.

Thanks to:

  Raghavendra D Prabhu <rprabhu@wnohang.net>

for motivating this patch.

See:

  Message-ID: <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>

Signed-off-by: Michael Witten <mfwitten@gmail.com>
---
 tools/perf/Makefile          |   22 +++++++++++++++++---
 tools/perf/feature-tests.mak |   44 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 158c30e..b468383 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -13,6 +13,12 @@ endif
 
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
@@ -165,7 +171,7 @@ grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
-	$(QUIET_GEN)python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
+	$(QUIET_GEN)$(PYTHON) util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
 						--build-temp='$(OUTPUT)python/temp'
 #
 # No Perl scripts right now:
@@ -474,10 +480,18 @@ endif
 ifdef NO_LIBPYTHON
 	BASIC_CFLAGS += -DNO_LIBPYTHON
 else
+        override PYTHON := \
+            $(or $(call get-supplied-or-default-executable,$(PYTHON),python),\
+                 $(error Please set PYTHON appropriately))
+
+        override PYTHON_CONFIG := \
+            $(or $(call get-supplied-or-default-executable,$(PYTHON_CONFIG),$(PYTHON)-config),\
+                 $(error Please set PYTHON_CONFIG appropriately))
+
-       PYTHON_EMBED_LDOPTS = $(shell python-config --ldflags 2>/dev/null)
+       PYTHON_EMBED_LDOPTS = $(shell $(PYTHON_CONFIG) --ldflags 2>/dev/null)
        PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
        PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
-	PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
+	PYTHON_EMBED_CCOPTS = $(shell $(PYTHON_CONFIG) --cflags 2>/dev/null)
 	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
 		msg := $(warning No Python.h found, install python-dev[el] to have python support in 'perf script' and to build the python bindings)
@@ -829,7 +843,7 @@ clean:
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(MAKE) -C Documentation/ clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
-	@python util/setup.py clean --build-lib='$(OUTPUT)python' \
+	@$(PYTHON) util/setup.py clean --build-lib='$(OUTPUT)python' \
 				   --build-temp='$(OUTPUT)python/temp'
 
 .PHONY: all install clean strip
diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
index b041ca6..8d677f4 100644
--- a/tools/perf/feature-tests.mak
+++ b/tools/perf/feature-tests.mak
@@ -128,3 +128,47 @@ try-cc = $(shell sh -c						  \
 	 echo "$(1)" |						  \
 	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
 	 rm -f "$$TMP"')
+
+# is-absolute
+# Usage: bool-value = $(call is-absolute,path)
+#
+define is-absolute
+$(shell sh -c "echo '$(1)' | grep ^/")
+endef
+
+# lookup
+# Usage: absolute-executable-path-or-empty = $(call lookup,path)
+#
+define lookup
+$(shell sh -c "command -v '$(1)'")
+endef
+
+# is-executable
+# Usage: bool-value = $(call is-executable,path)
+#
+define is-executable
+$(shell sh -c "test -f '$(1)' -a -x '$(1)' && echo y")
+endef
+
+# get-executable
+# Usage: absolute-executable-path-or-empty = $(call get-executable,path)
+#
+# The goal is to get an absolute path for an executable;
+# the `command -v' is defined by POSIX, but it's not
+# necessarily very portable, so it's only used if
+# relative path resolution is requested, as determined
+# by the presence of a leading `/'.
+#
+define get-executable
+$(if $(1),$(if $(call is-absolute,$(1)),$(if $(call is-executable,$(1)),$(1)),$(call lookup,$(1))))
+endef
+
+# get-supplied-or-default-executable
+# Usage: absolute-executable-path-or-empty = $(call get-supplied-or-default-executable,path,default)
+#
+define get-supplied-or-default-executable
+$(if $(1),$(call _attempt,$(1)),$(call _attempt,$(2)))
+endef
+define _attempt
+$(or $(call get-executable,$(1)),$(warning The path '$(1)' is not executable.))
+endef
-- 
1.7.4.18.g68fe8

