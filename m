Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab1DWQa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:30:26 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40219 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab1DWQaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:30:19 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 15/18] perf: Export evlist.[ch]
Date: Sat, 23 Apr 2011 18:28:17 +0200
Message-Id: <1303576100-425-16-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Export for other tools to use too. Also, add a weak ui_warning version
when using evlist outside of perf.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/perf/Makefile                  |    3 +++
 tools/lib/perf/cgroup.c                  |    6 +++---
 tools/{perf/util => lib/perf}/evlist.c   |   11 ++++++++++-
 tools/{perf/util => lib/perf}/evlist.h   |    4 ++--
 tools/lib/perf/evsel.c                   |    2 +-
 tools/perf/Makefile                      |    3 ---
 tools/perf/builtin-annotate.c            |    2 +-
 tools/perf/builtin-evlist.c              |    2 +-
 tools/perf/builtin-record.c              |    2 +-
 tools/perf/builtin-report.c              |    2 +-
 tools/perf/builtin-script.c              |    2 +-
 tools/perf/builtin-stat.c                |    2 +-
 tools/perf/builtin-test.c                |    2 +-
 tools/perf/builtin-top.c                 |    2 +-
 tools/perf/util/header.c                 |    2 +-
 tools/perf/util/include/linux/compiler.h |    1 +
 tools/perf/util/parse-events.c           |    2 +-
 tools/perf/util/python.c                 |    2 +-
 tools/perf/util/session.c                |    2 +-
 tools/perf/util/setup.py                 |    2 +-
 tools/perf/util/top.c                    |    2 +-
 tools/perf/util/ui/browsers/hists.c      |    2 +-
 tools/perf/util/ui/browsers/top.c        |    2 +-
 23 files changed, 36 insertions(+), 26 deletions(-)
 rename tools/{perf/util => lib/perf}/evlist.c (98%)
 rename tools/{perf/util => lib/perf}/evlist.h (96%)

diff --git a/tools/lib/perf/Makefile b/tools/lib/perf/Makefile
index e43008d..1e5c857 100644
--- a/tools/lib/perf/Makefile
+++ b/tools/lib/perf/Makefile
@@ -6,11 +6,14 @@ LIB_OBJS=
 
 LIB_H += evsel.h
 LIB_H += cgroup.h
+LIB_H += evlist.h
 
 LIB_OBJS += evsel.o
 LIB_OBJS += cgroup.o
+LIB_OBJS += evlist.o
 
 PYRF_OBJS += evsel.o
+PYRF_OBJS += evlist.o
 
 LIBFILE = $(LIB_OUTPUT)liblkperf.a
 
diff --git a/tools/lib/perf/cgroup.c b/tools/lib/perf/cgroup.c
index 5c9c554..8181353 100644
--- a/tools/lib/perf/cgroup.c
+++ b/tools/lib/perf/cgroup.c
@@ -1,10 +1,10 @@
 #include <lk/util.h>
+#include <lk/debugfs.h> /* MAX_PATH, STR() */
 #include "../../perf/perf.h"
 #include "../../perf/util/parse-options.h"
-#include <perf/evsel.h>
+#include "evsel.h"
 #include "cgroup.h"
-#include <lk/debugfs.h> /* MAX_PATH, STR() */
-#include "../../perf/util/evlist.h"
+#include "evlist.h"
 
 int nr_cgroups;
 
diff --git a/tools/perf/util/evlist.c b/tools/lib/perf/evlist.c
similarity index 98%
rename from tools/perf/util/evlist.c
rename to tools/lib/perf/evlist.c
index eb728d0..ccbcf04 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/lib/perf/evlist.c
@@ -11,7 +11,7 @@
 #include <lk/thread_map.h>
 #include "evlist.h"
 #include <perf/evsel.h>
-#include "debug.h"
+#include "../../perf/util/debug.h"
 #include <lk/util.h>
 
 #include <sys/mman.h>
@@ -248,6 +248,15 @@ int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
+void __weak ui__warning(const char *format, ...)
+{
+	va_list params;
+
+	va_start(params, format);
+	warning(format, params);
+	va_end(params);
+}
+
 static int __perf_evlist__mmap(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			       int cpu, int prot, int mask, int fd)
 {
diff --git a/tools/perf/util/evlist.h b/tools/lib/perf/evlist.h
similarity index 96%
rename from tools/perf/util/evlist.h
rename to tools/lib/perf/evlist.h
index 8b1cb7a..9480b1d 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/lib/perf/evlist.h
@@ -2,8 +2,8 @@
 #define __PERF_EVLIST_H 1
 
 #include <linux/list.h>
-#include "../perf.h"
-#include "event.h"
+#include "../../perf/perf.h"
+#include "../../perf/util/event.h"
 
 struct pollfd;
 struct thread_map;
diff --git a/tools/lib/perf/evsel.c b/tools/lib/perf/evsel.c
index a66501c..3a63422 100644
--- a/tools/lib/perf/evsel.c
+++ b/tools/lib/perf/evsel.c
@@ -8,7 +8,7 @@
  */
 
 #include "evsel.h"
-#include "../../perf/util/evlist.h"
+#include "evlist.h"
 #include <lk/util.h>
 #include <lk/cpumap.h>
 #include <lk/thread_map.h>
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d134897..2edfa70 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -212,7 +212,6 @@ LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
 LIB_H += util/event.h
-LIB_H += util/evlist.h
 LIB_H += util/exec_cmd.h
 LIB_H += util/levenshtein.h
 LIB_H += util/map.h
@@ -248,7 +247,6 @@ LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
-LIB_OBJS += $(OUTPUT)util/evlist.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
 LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
@@ -324,7 +322,6 @@ PERFLIBS = $(LIB_FILE) $(EXTRA_LIBS)
 # tools/perf/util/setup.py
 
 PYRF_OBJS += $(OUTPUT)util/ctype.o
-PYRF_OBJS += $(OUTPUT)util/evlist.o
 PYRF_OBJS += $(OUTPUT)util/python.o
 
 #
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6386254..da5bd09 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -19,7 +19,7 @@
 #include "perf.h"
 #include "util/debug.h"
 
-#include "util/evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 #include "util/annotate.h"
 #include "util/event.h"
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 3619582..0f869cc 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -8,7 +8,7 @@
 #include <linux/list.h>
 
 #include "perf.h"
-#include "util/evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 #include "util/parse-events.h"
 #include "util/parse-options.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 77ffcc5..5f1b66a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -18,7 +18,7 @@
 
 #include "util/header.h"
 #include "util/event.h"
-#include "util/evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 #include "util/debug.h"
 #include "util/session.h"
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0700778..07568f4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -21,7 +21,7 @@
 
 #include "perf.h"
 #include "util/debug.h"
-#include "util/evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 #include "util/header.h"
 #include "util/session.h"
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 65583d8..9c95a72 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -12,7 +12,7 @@
 #include <trace/trace-event.h>
 #include "util/parse-options.h"
 #include <lk/util.h>
-#include "util/evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 
 static char const		*script_name;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 58374af..b56dc56 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -43,7 +43,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/event.h"
-#include "util/evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 #include "util/debug.h"
 #include "util/header.h"
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 12feeb4..f045eb0 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -7,7 +7,7 @@
 
 #include "util/cache.h"
 #include "util/debug.h"
-#include "util/evlist.h"
+#include <perf/evlist.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/symbol.h"
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0d778aa..16d94be 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -23,7 +23,7 @@
 #include "util/annotate.h"
 #include "util/cache.h"
 #include "util/color.h"
-#include "util/evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 #include "util/session.h"
 #include "util/symbol.h"
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 8fc4d21..1948c88 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -8,7 +8,7 @@
 #include <linux/list.h>
 #include <linux/kernel.h>
 
-#include "evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 #include <lk/util.h>
 #include "header.h"
diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index 791f9dd..62165bc 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -8,5 +8,6 @@
 #define __attribute_const__
 
 #define __used		__attribute__((__unused__))
+#define __weak		__attribute__((weak))
 
 #endif
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9acaab1..05e8e65 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,7 +1,7 @@
 #include "../../../include/linux/hw_breakpoint.h"
 #include <lk/util.h>
 #include "../perf.h"
-#include "evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 #include "parse-options.h"
 #include "parse-events.h"
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index c049b9a..4f2745e 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -2,7 +2,7 @@
 #include <structmember.h>
 #include <inttypes.h>
 #include <poll.h>
-#include "evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 #include "event.h"
 #include <lk/cpumap.h>
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 445a6b9..a81bb60 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -7,7 +7,7 @@
 #include <sys/types.h>
 #include <sys/mman.h>
 
-#include "evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 #include "session.h"
 #include "sort.h"
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index c8d0d8d..7172967 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -7,7 +7,7 @@ cflags = ['-fno-strict-aliasing', '-Wno-write-strings']
 cflags += getenv('CFLAGS', '').split()
 
 perf = Extension('perf',
-		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
+		  sources = ['util/python.c', 'util/ctype.c', '../lib/perf/evlist.c',
 			     '../lib/perf/evsel.c', '../lib/lk/cpumap.c', '../lib/lk/thread_map.c',
 			     '../lib/lk/util.c', '../lib/lk/xyarray.c', 'util/cgroup.c'],
 		  include_dirs = ['util/include', '../lib'],
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 7fb9658..5d939b6 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -8,7 +8,7 @@
 
 #include <lk/cpumap.h>
 #include "event.h"
-#include "evlist.h"
+#include <perf/evlist.h>
 #include <perf/evsel.h>
 #include "parse-events.h"
 #include "symbol.h"
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index c4f424b..d9dae5d 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -8,7 +8,7 @@
 #include <linux/rbtree.h>
 
 #include <perf/evsel.h>
-#include "../../evlist.h"
+#include <perf/evlist.h>
 #include "../../hist.h"
 #include "../../pstack.h"
 #include "../../sort.h"
diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
index 5a06538..ba59d3d 100644
--- a/tools/perf/util/ui/browsers/top.c
+++ b/tools/perf/util/ui/browsers/top.c
@@ -11,7 +11,7 @@
 #include "../helpline.h"
 #include "../libslang.h"
 #include "../util.h"
-#include "../../evlist.h"
+#include <perf/evlist.h>
 #include "../../hist.h"
 #include "../../sort.h"
 #include "../../symbol.h"
-- 
1.7.4.rc2

