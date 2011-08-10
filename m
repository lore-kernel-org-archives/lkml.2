Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1HJI1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:27:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:50590 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1HJI11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:27:27 -0400
Date: Wed, 10 Aug 2011 08:27:08 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-9941c96ad869d10f7e34e03990ce450ab8fcb83d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110722113307.GA1931@jolsa.brq.redhat.com>
References: <20110722113307.GA1931@jolsa.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Add support to install perf python extension
Git-Commit-ID: 9941c96ad869d10f7e34e03990ce450ab8fcb83d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Aug 2011 08:27:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9941c96ad869d10f7e34e03990ce450ab8fcb83d
Gitweb:     http://git.kernel.org/tip/9941c96ad869d10f7e34e03990ce450ab8fcb83d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 22 Jul 2011 13:33:07 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Aug 2011 12:54:26 -0300

perf tools: Add support to install perf python extension

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
