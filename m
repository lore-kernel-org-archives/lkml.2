Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab2BQJpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:45:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2BQJpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:45:15 -0500
Date: Fri, 17 Feb 2012 01:44:39 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-6a5c13aff49ac9b3fea38d5f84b436718cb2780d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1329043524-12470-1-git-send-email-namhyung@gmail.com>
References: <1329043524-12470-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix build dependency of perf python extension
Git-Commit-ID: 6a5c13aff49ac9b3fea38d5f84b436718cb2780d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:44:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a5c13aff49ac9b3fea38d5f84b436718cb2780d
Gitweb:     http://git.kernel.org/tip/6a5c13aff49ac9b3fea38d5f84b436718cb2780d
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Sun, 12 Feb 2012 19:45:24 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 18:01:25 -0200

perf tools: Fix build dependency of perf python extension

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
