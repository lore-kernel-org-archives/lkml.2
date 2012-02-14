Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab2BNByN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:54:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42599 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715Ab2BNBx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:53:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/16] perf tools: Fix build dependency of perf python extension
Date: Mon, 13 Feb 2012 23:52:42 -0200
Message-Id: <1329184375-27911-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1329184375-27911-1-git-send-email-acme@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

The perf python extention (perf.so) file lacks its dependencies in the
Makefile so that it cannot be refreshed if one of source files it depends
is changed. Fix it by putting them in a separate file and processing it in
both of Makefile and setup.py.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1329043524-12470-1-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                |    5 ++++-
 tools/perf/util/python-ext-sources |   17 +++++++++++++++++
 tools/perf/util/setup.py           |    8 ++++----
 3 files changed, 25 insertions(+), 5 deletions(-)
 create mode 100644 tools/perf/util/python-ext-sources

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 64df5de..8359fa1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -183,7 +183,10 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-$(OUTPUT)python/perf.so: $(PYRF_OBJS)
+PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
+PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py
+
+$(OUTPUT)python/perf.so: $(PYRF_OBJS) $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
 	  --quiet build_ext; \
 	mkdir -p $(OUTPUT)python && \
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
new file mode 100644
index 0000000..ff606f4
--- /dev/null
+++ b/tools/perf/util/python-ext-sources
@@ -0,0 +1,17 @@
+#
+# List of files needed by perf python extention
+#
+# Each source file must be placed on its own line so that it can be
+# processed by Makefile and util/setup.py accordingly.
+#
+
+util/python.c
+util/ctype.c
+util/evlist.c
+util/evsel.c
+util/cpumap.c
+util/thread_map.c
+util/util.c
+util/xyarray.c
+util/cgroup.c
+util/debugfs.c
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 36d4c56..d0f9f29 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -24,11 +24,11 @@ cflags += getenv('CFLAGS', '').split()
 build_lib = getenv('PYTHON_EXTBUILD_LIB')
 build_tmp = getenv('PYTHON_EXTBUILD_TMP')
 
+ext_sources = [f.strip() for f in file('util/python-ext-sources')
+				if len(f.strip()) > 0 and f[0] != '#']
+
 perf = Extension('perf',
-		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
-			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
-			     'util/util.c', 'util/xyarray.c', 'util/cgroup.c',
-			     'util/debugfs.c'],
+		  sources = ext_sources,
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
                  )
-- 
1.7.9.123.g65da0

