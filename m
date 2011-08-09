Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1HITnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:43:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:50061 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HITnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:43:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf tools: Add support to install perf python extension
Date: Tue,  9 Aug 2011 16:43:05 -0300
Message-Id: <1312918988-24146-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1312918988-24146-1-git-send-email-acme@infradead.org>
References: <1312918988-24146-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding install-python_ext target to install python extension related
files.  Installation directory is governed by python distutils package
and follows the DESTDIR variable settings.

Also moving python extension build output into '$(O)python_ext_build'
directory and making it configurable via PYTHON_EXTBUILD variable.

Keeping the '$(O)python/perf.so' file, so it could be used for testing
as of until now.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110722113307.GA1931@jolsa.brq.redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |   19 +++++++++++++------
 tools/perf/util/setup.py |   21 ++++++++++++++++++++-
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5bf48fc..822f967 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -178,9 +178,9 @@ strip-libs = $(filter-out -l%,$(1))
 
 $(OUTPUT)python/perf.so: $(PYRF_OBJS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
-	  --quiet build_ext \
-	  --build-lib='$(OUTPUT)python' \
-	  --build-temp='$(OUTPUT)python/temp'
+	  --quiet build_ext; \
+	mkdir -p $(OUTPUT)python && \
+	cp $(PYTHON_EXTBUILD_LIB)perf.so $(OUTPUT)python/
 #
 # No Perl scripts right now:
 #
@@ -506,9 +506,13 @@ else
 
   PYTHON_WORD := $(call shell-wordify,$(PYTHON))
 
-  python-clean := $(PYTHON_WORD) util/setup.py clean \
-    --build-lib='$(OUTPUT)python' \
-    --build-temp='$(OUTPUT)python/temp'
+  # python extension build directories
+  PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
+  PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
+  PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
+  export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
+
+  python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
 
   ifdef NO_LIBPYTHON
     $(call disable-python)
@@ -865,6 +869,9 @@ install: all
 	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
 	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
 
+install-python_ext:
+	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
+
 install-doc:
 	$(MAKE) -C Documentation install
 
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index bbc982f..95d3700 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -3,9 +3,27 @@
 from distutils.core import setup, Extension
 from os import getenv
 
+from distutils.command.build_ext   import build_ext   as _build_ext
+from distutils.command.install_lib import install_lib as _install_lib
+
+class build_ext(_build_ext):
+    def finalize_options(self):
+        _build_ext.finalize_options(self)
+        self.build_lib  = build_lib
+        self.build_temp = build_tmp
+
+class install_lib(_install_lib):
+    def finalize_options(self):
+        _install_lib.finalize_options(self)
+        self.build_dir = build_lib
+
+
 cflags = ['-fno-strict-aliasing', '-Wno-write-strings']
 cflags += getenv('CFLAGS', '').split()
 
+build_lib = getenv('PYTHON_EXTBUILD_LIB')
+build_tmp = getenv('PYTHON_EXTBUILD_TMP')
+
 perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
 			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
@@ -21,4 +39,5 @@ setup(name='perf',
       author_email='acme@redhat.com',
       license='GPLv2',
       url='http://perf.wiki.kernel.org',
-      ext_modules=[perf])
+      ext_modules=[perf],
+      cmdclass={'build_ext': build_ext, 'install_lib': install_lib})
-- 
1.6.2.5

