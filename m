Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab2KNEkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 23:40:00 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48240 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2KNEj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 23:39:59 -0500
X-AuditID: 9c930197-b7b45ae000000e9e-01-50a3209c4bef
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] perf tools: Don't check configuration on make clean
Date: Wed, 14 Nov 2012 13:39:50 +0900
Message-Id: <1352867990-658-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current perf build process checks various system configuration on
invocation to make.  But this is not needed just for cleaning.

To do that, move some of python related variables out of conditional
since 'clean' target needs them.  Normal path should not be affected
by this.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/Makefile |  2 ++
 tools/perf/Makefile               | 28 ++++++++++++++++------------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index ef6d22e879eb..f6e5901c8f5f 100644
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
index a7c6aa8d4a8b..128a448ede65 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -153,6 +153,7 @@ INSTALL = install
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
+ifneq ($(MAKECMDGOALS),clean)
 -include config/feature-tests.mak
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
@@ -178,6 +179,7 @@ ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 	BASIC_CFLAGS += -I.
 endif
+endif # MAKECMDGOALS != clean
 
 # Guard against environment variables
 BUILTIN_OBJS =
@@ -202,11 +204,19 @@ endif
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
@@ -482,6 +492,7 @@ PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 #
 # Platform specific tweaks
 #
+ifneq ($(MAKECMDGOALS),clean)
 
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
@@ -679,7 +690,7 @@ disable-python = $(eval $(disable-python_code))
 define disable-python_code
   BASIC_CFLAGS += -DNO_LIBPYTHON
   $(if $(1),$(warning No $(1) was found))
-  $(warning Python support won't be built)
+  $(warning Python support will not be built)
 endef
 
 override PYTHON := \
@@ -687,19 +698,10 @@ override PYTHON := \
 
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
@@ -815,6 +817,8 @@ ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
 
+endif # MAKECMDGOALS != clean
+
 # Shell quote (do not use $(call) to accommodate ancient setups);
 
 ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
-- 
1.7.11.7

