Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab1DWQaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:30:24 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40205 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab1DWQaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:30:18 -0400
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
Subject: [PATCH 13/18] perf: Export evsel.[ch]
Date: Sat, 23 Apr 2011 18:28:15 +0200
Message-Id: <1303576100-425-14-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is needed by other tools dealing with perf events. Pull in
xyarray.[ch] with it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/Makefile                        |    6 +++++-
 tools/lib/lk/Makefile                 |    3 +++
 tools/{perf/util => lib/lk}/xyarray.c |    0
 tools/{perf/util => lib/lk}/xyarray.h |    6 +++---
 tools/lib/{lk => perf}/Makefile       |   24 +++++++-----------------
 tools/{perf/util => lib/perf}/evsel.c |    2 +-
 tools/{perf/util => lib/perf}/evsel.h |   14 +++++++-------
 tools/lib/trace/event-info.c          |    2 +-
 tools/perf/Makefile                   |    8 +-------
 tools/perf/builtin-annotate.c         |    2 +-
 tools/perf/builtin-evlist.c           |    2 +-
 tools/perf/builtin-record.c           |    2 +-
 tools/perf/builtin-report.c           |    2 +-
 tools/perf/builtin-script.c           |    2 +-
 tools/perf/builtin-stat.c             |    2 +-
 tools/perf/builtin-test.c             |    2 +-
 tools/perf/builtin-top.c              |    4 ++--
 tools/perf/util/cgroup.c              |    2 +-
 tools/perf/util/evlist.c              |    2 +-
 tools/perf/util/header.c              |    2 +-
 tools/perf/util/parse-events.c        |    2 +-
 tools/perf/util/python.c              |    2 +-
 tools/perf/util/session.c             |    2 +-
 tools/perf/util/setup.py              |    4 ++--
 tools/perf/util/top.c                 |    2 +-
 tools/perf/util/ui/browsers/hists.c   |    2 +-
 26 files changed, 47 insertions(+), 56 deletions(-)
 rename tools/{perf/util => lib/lk}/xyarray.c (100%)
 rename tools/{perf/util => lib/lk}/xyarray.h (81%)
 copy tools/lib/{lk => perf}/Makefile (69%)
 rename tools/{perf/util => lib/perf}/evsel.c (99%)
 rename tools/{perf/util => lib/perf}/evsel.h (96%)

diff --git a/tools/Makefile b/tools/Makefile
index f302177..60993bf 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -12,7 +12,7 @@ export BASIC_CFLAGS
 PYRF_OBJS =
 export PYRF_OBJS
 
-perf: libtrace liblk .FORCE
+perf: libtrace liblkperf liblk .FORCE
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1)
 
 firewire: .FORCE
@@ -21,6 +21,9 @@ firewire: .FORCE
 liblk: .FORCE
 	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1)
 
+liblkperf: .FORCE
+	$(QUIET_SUBDIR0)lib/perf/ $(QUIET_SUBDIR1)
+
 libtrace: .FORCE
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1)
 
@@ -43,6 +46,7 @@ clean:
 	$(QUIET_SUBDIR0)perf/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)firewire/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)lib/lk/ $(QUIET_SUBDIR1) clean
+	$(QUIET_SUBDIR0)lib/perf/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)lib/trace/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)slub/ $(QUIET_SUBDIR1) clean
 	$(QUIET_SUBDIR0)power/x86/turbostat/ $(QUIET_SUBDIR1) clean
diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index e3c5282..228b033 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -9,16 +9,19 @@ LIB_H += util.h
 LIB_H += types.h
 LIB_H += cpumap.h
 LIB_H += thread_map.h
+LIB_H += xyarray.h
 
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
 LIB_OBJS += util.o
 LIB_OBJS += cpumap.o
 LIB_OBJS += thread_map.o
+LIB_OBJS += xyarray.o
 
 PYRF_OBJS += util.o
 PYRF_OBJS += cpumap.o
 PYRF_OBJS += thread_map.o
+PYRF_OBJS += xyarray.o
 
 LIBFILE = $(LIB_OUTPUT)liblk.a
 
diff --git a/tools/perf/util/xyarray.c b/tools/lib/lk/xyarray.c
similarity index 100%
rename from tools/perf/util/xyarray.c
rename to tools/lib/lk/xyarray.c
diff --git a/tools/perf/util/xyarray.h b/tools/lib/lk/xyarray.h
similarity index 81%
rename from tools/perf/util/xyarray.h
rename to tools/lib/lk/xyarray.h
index c488a07..9029f38 100644
--- a/tools/perf/util/xyarray.h
+++ b/tools/lib/lk/xyarray.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_XYARRAY_H_
-#define _PERF_XYARRAY_H_ 1
+#ifndef __LK_XYARRAY_H_
+#define __LK_XYARRAY_H_ 1
 
 #include <sys/types.h>
 
@@ -17,4 +17,4 @@ static inline void *xyarray__entry(struct xyarray *xy, int x, int y)
 	return &xy->contents[x * xy->row_size + y * xy->entry_size];
 }
 
-#endif /* _PERF_XYARRAY_H_ */
+#endif /* __LK_XYARRAY_H_ */
diff --git a/tools/lib/lk/Makefile b/tools/lib/perf/Makefile
similarity index 69%
copy from tools/lib/lk/Makefile
copy to tools/lib/perf/Makefile
index e3c5282..8b7b288 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/perf/Makefile
@@ -4,23 +4,13 @@ include ../../scripts/Makefile.lib
 LIB_H=
 LIB_OBJS=
 
-LIB_H += debugfs.h
-LIB_H += util.h
-LIB_H += types.h
-LIB_H += cpumap.h
-LIB_H += thread_map.h
-
-LIB_OBJS += debugfs.o
-LIB_OBJS += usage.o
-LIB_OBJS += util.o
-LIB_OBJS += cpumap.o
-LIB_OBJS += thread_map.o
-
-PYRF_OBJS += util.o
-PYRF_OBJS += cpumap.o
-PYRF_OBJS += thread_map.o
-
-LIBFILE = $(LIB_OUTPUT)liblk.a
+LIB_H += evsel.h
+
+LIB_OBJS += evsel.o
+
+PYRF_OBJS += evsel.o
+
+LIBFILE = $(LIB_OUTPUT)liblkperf.a
 
 CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
diff --git a/tools/perf/util/evsel.c b/tools/lib/perf/evsel.c
similarity index 99%
rename from tools/perf/util/evsel.c
rename to tools/lib/perf/evsel.c
index 3a63422..a66501c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/lib/perf/evsel.c
@@ -8,7 +8,7 @@
  */
 
 #include "evsel.h"
-#include "evlist.h"
+#include "../../perf/util/evlist.h"
 #include <lk/util.h>
 #include <lk/cpumap.h>
 #include <lk/thread_map.h>
diff --git a/tools/perf/util/evsel.h b/tools/lib/perf/evsel.h
similarity index 96%
rename from tools/perf/util/evsel.h
rename to tools/lib/perf/evsel.h
index 526deed..48e5906 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/lib/perf/evsel.h
@@ -5,10 +5,10 @@
 #include <stdbool.h>
 #include "../../../include/linux/perf_event.h"
 #include <lk/types.h>
-#include "xyarray.h"
-#include "cgroup.h"
-#include "hist.h"
- 
+#include <lk/xyarray.h>
+#include "../../perf/util/cgroup.h"
+#include "../../perf/util/hist.h"
+
 struct perf_counts_values {
 	union {
 		struct {
@@ -21,7 +21,7 @@ struct perf_counts_values {
 };
 
 struct perf_counts {
-	s8		   	  scaled;
+	s8			  scaled;
 	struct perf_counts_values aggr;
 	struct perf_counts_values cpu[];
 };
@@ -33,8 +33,8 @@ struct perf_evsel;
  * more than one entry in the evlist.
  */
 struct perf_sample_id {
-	struct hlist_node 	node;
-	u64		 	id;
+	struct hlist_node	node;
+	u64			id;
 	struct perf_evsel	*evsel;
 };
 
diff --git a/tools/lib/trace/event-info.c b/tools/lib/trace/event-info.c
index dbc6ba9..9da00af 100644
--- a/tools/lib/trace/event-info.c
+++ b/tools/lib/trace/event-info.c
@@ -40,7 +40,7 @@
 #include "../../perf/perf.h"
 #include "trace-event.h"
 #include <lk/debugfs.h>
-#include "../perf/util/evsel.h"
+#include <perf/evsel.h>
 
 #define VERSION "0.5"
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 05c4eef..af2bd00 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -175,7 +175,7 @@ export PERL_PATH
 
 LIB_FILE=$(OUTPUT)libperf.a
 
-EXTRA_LIBS=$(LIB_OUTPUT)libtrace.a $(LIB_OUTPUT)liblk.a
+EXTRA_LIBS=$(LIB_OUTPUT)libtrace.a $(LIB_OUTPUT)liblk.a $(LIB_OUTPUT)liblkperf.a
 
 LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/rbtree.h
@@ -212,7 +212,6 @@ LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
 LIB_H += util/event.h
-LIB_H += util/evsel.h
 LIB_H += util/evlist.h
 LIB_H += util/exec_cmd.h
 LIB_H += util/levenshtein.h
@@ -220,7 +219,6 @@ LIB_H += util/map.h
 LIB_H += util/parse-options.h
 LIB_H += util/parse-events.h
 LIB_H += util/quote.h
-LIB_H += util/xyarray.h
 LIB_H += util/header.h
 LIB_H += util/help.h
 LIB_H += util/session.h
@@ -252,7 +250,6 @@ LIB_OBJS += $(OUTPUT)util/ctype.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
 LIB_OBJS += $(OUTPUT)util/evlist.o
-LIB_OBJS += $(OUTPUT)util/evsel.o
 LIB_OBJS += $(OUTPUT)util/exec_cmd.o
 LIB_OBJS += $(OUTPUT)util/help.o
 LIB_OBJS += $(OUTPUT)util/levenshtein.o
@@ -287,7 +284,6 @@ LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
-LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cgroup.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
@@ -331,9 +327,7 @@ PERFLIBS = $(LIB_FILE) $(EXTRA_LIBS)
 
 PYRF_OBJS += $(OUTPUT)util/ctype.o
 PYRF_OBJS += $(OUTPUT)util/evlist.o
-PYRF_OBJS += $(OUTPUT)util/evsel.o
 PYRF_OBJS += $(OUTPUT)util/python.o
-PYRF_OBJS += $(OUTPUT)util/xyarray.o
 
 #
 # Platform specific tweaks
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 2003f27..6386254 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -20,7 +20,7 @@
 #include "util/debug.h"
 
 #include "util/evlist.h"
-#include "util/evsel.h"
+#include <perf/evsel.h>
 #include "util/annotate.h"
 #include "util/event.h"
 #include "util/parse-options.h"
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 356573c..3619582 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -9,7 +9,7 @@
 
 #include "perf.h"
 #include "util/evlist.h"
-#include "util/evsel.h"
+#include <perf/evsel.h>
 #include "util/parse-events.h"
 #include "util/parse-options.h"
 #include "util/session.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7011ef3..77ffcc5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -19,7 +19,7 @@
 #include "util/header.h"
 #include "util/event.h"
 #include "util/evlist.h"
-#include "util/evsel.h"
+#include <perf/evsel.h>
 #include "util/debug.h"
 #include "util/session.h"
 #include "util/symbol.h"
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 876d3e2..0700778 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -22,7 +22,7 @@
 #include "perf.h"
 #include "util/debug.h"
 #include "util/evlist.h"
-#include "util/evsel.h"
+#include <perf/evsel.h>
 #include "util/header.h"
 #include "util/session.h"
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 8ff8e1b..65583d8 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -13,7 +13,7 @@
 #include "util/parse-options.h"
 #include <lk/util.h>
 #include "util/evlist.h"
-#include "util/evsel.h"
+#include <perf/evsel.h>
 
 static char const		*script_name;
 static char const		*generate_script_lang;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e2d57dd..58374af 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -44,7 +44,7 @@
 #include "util/parse-events.h"
 #include "util/event.h"
 #include "util/evlist.h"
-#include "util/evsel.h"
+#include <perf/evsel.h>
 #include "util/debug.h"
 #include "util/header.h"
 #include <lk/cpumap.h>
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index e471fe9..12feeb4 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -236,7 +236,7 @@ out:
 }
 
 #include <lk/cpumap.h>
-#include "util/evsel.h"
+#include <perf/evsel.h>
 #include <sys/types.h>
 
 static int trace_event__id(const char *evname)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2cd2e8c..0d778aa 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -24,7 +24,7 @@
 #include "util/cache.h"
 #include "util/color.h"
 #include "util/evlist.h"
-#include "util/evsel.h"
+#include <perf/evsel.h>
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
@@ -35,7 +35,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include <lk/cpumap.h>
-#include "util/xyarray.h"
+#include <lk/xyarray.h>
 
 #include "util/debug.h"
 
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index 99267b3..eae7d6b 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -1,7 +1,7 @@
 #include <lk/util.h>
 #include "../perf.h"
 #include "parse-options.h"
-#include "evsel.h"
+#include <perf/evsel.h>
 #include "cgroup.h"
 #include <lk/debugfs.h> /* MAX_PATH, STR() */
 #include "evlist.h"
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1f35fec..eb728d0 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -10,7 +10,7 @@
 #include <lk/cpumap.h>
 #include <lk/thread_map.h>
 #include "evlist.h"
-#include "evsel.h"
+#include <perf/evsel.h>
 #include "debug.h"
 #include <lk/util.h>
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4c89af6..8fc4d21 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 
 #include "evlist.h"
-#include "evsel.h"
+#include <perf/evsel.h>
 #include <lk/util.h>
 #include "header.h"
 #include "../perf.h"
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 18f2d1c..9acaab1 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -2,7 +2,7 @@
 #include <lk/util.h>
 #include "../perf.h"
 #include "evlist.h"
-#include "evsel.h"
+#include <perf/evsel.h>
 #include "parse-options.h"
 #include "parse-events.h"
 #include "exec_cmd.h"
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 756f50c..c049b9a 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -3,7 +3,7 @@
 #include <inttypes.h>
 #include <poll.h>
 #include "evlist.h"
-#include "evsel.h"
+#include <perf/evsel.h>
 #include "event.h"
 #include <lk/cpumap.h>
 #include <lk/thread_map.h>
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 46c80de..445a6b9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -8,7 +8,7 @@
 #include <sys/mman.h>
 
 #include "evlist.h"
-#include "evsel.h"
+#include <perf/evsel.h>
 #include "session.h"
 #include "sort.h"
 #include <lk/util.h>
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 32d8049..c8d0d8d 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -8,8 +8,8 @@ cflags += getenv('CFLAGS', '').split()
 
 perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
-			     'util/evsel.c', '../lib/lk/cpumap.c', '../lib/lk/thread_map.c',
-			     '../lib/lk/util.c', 'util/xyarray.c', 'util/cgroup.c'],
+			     '../lib/perf/evsel.c', '../lib/lk/cpumap.c', '../lib/lk/thread_map.c',
+			     '../lib/lk/util.c', '../lib/lk/xyarray.c', 'util/cgroup.c'],
 		  include_dirs = ['util/include', '../lib'],
 		  extra_compile_args = cflags,
                  )
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 0b027aa..7fb9658 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -9,7 +9,7 @@
 #include <lk/cpumap.h>
 #include "event.h"
 #include "evlist.h"
-#include "evsel.h"
+#include <perf/evsel.h>
 #include "parse-events.h"
 #include "symbol.h"
 #include "top.h"
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 453aad2..c4f424b 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -7,7 +7,7 @@
 #include <newt.h>
 #include <linux/rbtree.h>
 
-#include "../../evsel.h"
+#include <perf/evsel.h>
 #include "../../evlist.h"
 #include "../../hist.h"
 #include "../../pstack.h"
-- 
1.7.4.rc2

