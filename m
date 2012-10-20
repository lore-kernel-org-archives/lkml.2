Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab2JTBKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:10:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36384 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab2JTBKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:10:34 -0400
Date: Fri, 19 Oct 2012 18:10:16 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@infradead.org>
Message-ID: <tip-45bff41a9a6f22af28e4ba22f83c87f619e573a8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, acme@infradead.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, acme@infradead.org, tglx@linutronix.de,
        namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf python: Properly link with libtraceevent
Git-Commit-ID: 45bff41a9a6f22af28e4ba22f83c87f619e573a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 18:10:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45bff41a9a6f22af28e4ba22f83c87f619e573a8
Gitweb:     http://git.kernel.org/tip/45bff41a9a6f22af28e4ba22f83c87f619e573a8
Author:     Arnaldo Carvalho de Melo <acme@infradead.org>
AuthorDate: Thu, 18 Oct 2012 11:38:35 -0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 20 Oct 2012 02:43:08 +0200

perf python: Properly link with libtraceevent

Namhyung Kim reported that the build fails with:

  GEN python/perf.so
  gcc: error: python_ext_build/tmp//../../libtraceevent.a: No such file or directory
  error: command 'gcc' failed with exit status 1
  cp: cannot stat `python_ext_build/lib/perf.so': No such file or directory
  make: *** [python/perf.so] Error 1

We need to propagate the TE_PATH variable to the setup.py file.

Reported-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/n/tip-8umiPbm4sxpknKivbjgykhut@git.kernel.org
[ Fixed superfluous variable build error. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Makefile      |   24 +++++++++++++-----------
 tools/perf/util/python.c |    2 --
 tools/perf/util/setup.py |    3 ++-
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f7c968a..00deed4d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -184,9 +184,22 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
+TRACE_EVENT_DIR = ../lib/traceevent/
+
+ifneq ($(OUTPUT),)
+	TE_PATH=$(OUTPUT)
+else
+	TE_PATH=$(TRACE_EVENT_DIR)
+endif
+
+LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
+TE_LIB := -L$(TE_PATH) -ltraceevent
+
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
 PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py
 
+export LIBTRACEEVENT
+
 $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
 	  --quiet build_ext; \
@@ -198,17 +211,6 @@ $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 
 SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 
-TRACE_EVENT_DIR = ../lib/traceevent/
-
-ifneq ($(OUTPUT),)
-	TE_PATH=$(OUTPUT)
-else
-	TE_PATH=$(TRACE_EVENT_DIR)
-endif
-
-LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
-TE_LIB := -L$(TE_PATH) -ltraceevent
-
 #
 # Single 'perf' binary right now:
 #
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a2657fd..9181bf2 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1015,8 +1015,6 @@ PyMODINIT_FUNC initperf(void)
 	    pyrf_cpu_map__setup_types() < 0)
 		return;
 
-	page_size = sysconf(_SC_PAGE_SIZE);
-
 	Py_INCREF(&pyrf_evlist__type);
 	PyModule_AddObject(module, "evlist", (PyObject*)&pyrf_evlist__type);
 
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 09c3cea..73d5102 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -23,6 +23,7 @@ cflags += getenv('CFLAGS', '').split()
 
 build_lib = getenv('PYTHON_EXTBUILD_LIB')
 build_tmp = getenv('PYTHON_EXTBUILD_TMP')
+libtraceevent = getenv('LIBTRACEEVENT')
 
 ext_sources = [f.strip() for f in file('util/python-ext-sources')
 				if len(f.strip()) > 0 and f[0] != '#']
@@ -31,7 +32,7 @@ perf = Extension('perf',
 		  sources = ext_sources,
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
-		  extra_objects = [build_tmp + '/../../libtraceevent.a'],
+		  extra_objects = [libtraceevent],
                  )
 
 setup(name='perf',
