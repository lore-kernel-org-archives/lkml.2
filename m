Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2LKWsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:48:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43755 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab2LKWse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/37] perf tools: Don't check configuration on make clean
Date: Tue, 11 Dec 2012 19:47:50 -0300
Message-Id: <1355266103-17238-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current perf build process checks various system configuration on
invocation to make.  But this is not needed just for cleaning.

To do that, move some of python related variables out of conditional
since 'clean' target needs them.  Normal path should not be affected by
this.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352867990-658-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile |    2 ++
 tools/perf/Makefile               |   28 ++++++++++++++++------------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index ef6d22e..f6e5901 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -222,10 +222,12 @@ install-pdf: pdf
 #install-html: html
 #	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
 
+ifneq ($(MAKECMDGOALS),clean)
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) $(OUTPUT)PERF-VERSION-FILE
 
 -include $(OUTPUT)PERF-VERSION-FILE
+endif
 
 #
 # Determine "include::" file references in asciidoc files.
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8fca560..08da9fc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -153,6 +153,7 @@ INSTALL = install
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
+ifneq ($(MAKECMDGOALS),clean)
 -include config/feature-tests.mak
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
@@ -206,6 +207,7 @@ ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 	BASIC_CFLAGS += -I.
 endif
+endif # MAKECMDGOALS != clean
 
 # Guard against environment variables
 BUILTIN_OBJS =
@@ -230,11 +232,19 @@ endif
 LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
 TE_LIB := -L$(TE_PATH) -ltraceevent
 
+export LIBTRACEEVENT
+
+# python extension build directories
+PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
+PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
+PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
+export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
+
+python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
+
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
 PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py
 
-export LIBTRACEEVENT
-
 $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
 	  --quiet build_ext; \
@@ -514,6 +524,7 @@ PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 #
 # Platform specific tweaks
 #
+ifneq ($(MAKECMDGOALS),clean)
 
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
@@ -703,7 +714,7 @@ disable-python = $(eval $(disable-python_code))
 define disable-python_code
   BASIC_CFLAGS += -DNO_LIBPYTHON
   $(if $(1),$(warning No $(1) was found))
-  $(warning Python support won't be built)
+  $(warning Python support will not be built)
 endef
 
 override PYTHON := \
@@ -711,19 +722,10 @@ override PYTHON := \
 
 ifndef PYTHON
   $(call disable-python,python interpreter)
-  python-clean :=
 else
 
   PYTHON_WORD := $(call shell-wordify,$(PYTHON))
 
-  # python extension build directories
-  PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
-  PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
-  PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
-  export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
-
-  python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
-
   ifdef NO_LIBPYTHON
     $(call disable-python)
   else
@@ -839,6 +841,8 @@ ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
 
+endif # MAKECMDGOALS != clean
+
 # Shell quote (do not use $(call) to accommodate ancient setups);
 
 ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
-- 
1.7.9.2.358.g22243

