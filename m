Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2BLKpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 05:45:33 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43671 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2BLKpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 05:45:32 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, fweisbec@gmail.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: Fix build dependency of perf python extension
Date: Sun, 12 Feb 2012 19:45:24 +0900
Message-Id: <1329043524-12470-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.8.2
In-Reply-To: <20120210142821.GH2526@infradead.org>
References: <20120210142821.GH2526@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf python extention (perf.so) file lacks its dependencies in the
Makefile so that it cannot be refreshed if one of source files it depends
is changed. Fix it by putting them in a separate file and processing it in
both of Makefile and setup.py.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
Hello, Arnaldo.

This is my attempt to fix the problem you said. I used a separate file to
track the dependency and it was used by both Makefile and setup.py. It
seemed work well for me. Please let me know if I missed something.

Thanks.

 tools/perf/Makefile                |    5 ++++-
 tools/perf/util/python-ext-sources |   17 +++++++++++++++++
 tools/perf/util/setup.py           |    8 ++++----
 3 files changed, 25 insertions(+), 5 deletions(-)
 create mode 100644 tools/perf/util/python-ext-sources

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 64df5de12ca8..8359fa140d2d 100644
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
index 000000000000..ff606f482a7c
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
index 36d4c5619575..d0f9f29cf181 100644
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
1.7.8.2

