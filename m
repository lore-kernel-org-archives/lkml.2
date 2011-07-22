Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab1GVLd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 07:33:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab1GVLdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 07:33:24 -0400
Date: Fri, 22 Jul 2011 13:33:07 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] perf tools: Add support to install perf python extension
Message-ID: <20110722113307.GA1931@jolsa.brq.redhat.com>
References: <1311266726-20655-1-git-send-email-jolsa@redhat.com>
 <20110721171148.GB24324@ghostprotocols.net>
 <20110721184715.GA2425@jolsa.Belkin>
 <20110721190407.GC24324@ghostprotocols.net>
 <20110721194150.GB2425@jolsa.Belkin>
 <20110721211610.GE24324@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721211610.GE24324@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 06:16:10PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jul 21, 2011 at 09:41:50PM +0200, Jiri Olsa escreveu:
> > On Thu, Jul 21, 2011 at 04:04:07PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Thu, Jul 21, 2011 at 08:47:15PM +0200, Jiri Olsa escreveu:
> > > > nope, I added install-python_ext since it installs to the
> > > > python system lib area, and it could break standard install
> 
> > > But where is that it picks the binaries built? The problem I was
> > > experiencing was that it wasn't obeying O=, just using the source dir
>  
> > I haven't checked the 'O=' that much.. will do :)
>  
> > > as the build dir, effectively building it again, in a different place.
>  
> > I dont have that much experince with python, but here's what I found:
> > (might be missing something..)
> 
> <SNIP>
>  
> > Also there might be a way to overload distutils class and put our
> > specific options to this new class..
>  
> > As I checked some of python extension packages, some of them
> > do not use distutils at all.. can't imagine why ;)
> 
> Ok, we're on the same page with that ';)' ;)
> 
> I'd love to use what is 'pythonic', i.e. whatever the python people
> think we should use and don't bother with all the module
> build/install details, but since we want to have O= working...

attached new version, working for me with the O= settings

jirka


---
Subject: [PATCH] perf tools: Add support to install perf python extension

Adding install-python_ext target to install python extension
related files.  Installation directory is governed by python
distutils package and follows the DESTDIR variable settings.

Also moving python extension build output into '$(O)python_ext_build'
directory and making it configurable via PYTHON_EXTBUILD variable.

Keeping the '$(O)python/perf.so' file, so it could be used
for testing as of until now.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile      |   19 +++++++++++++------
 tools/perf/util/setup.py |   21 ++++++++++++++++++++-
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 940257b..2b44a53 100644
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
@@ -504,9 +504,13 @@ else
 
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
@@ -863,6 +867,9 @@ install: all
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
1.7.1

