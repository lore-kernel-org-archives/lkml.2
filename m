Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0KDPjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:39:36 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41989 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0KDPj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:29 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 11/20] perf: Move rbtree to library
Date: Thu,  4 Nov 2010 16:36:47 +0100
Message-Id: <1288885016-18295-12-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is generic code anyway and will be needed by other utils so move it
to a generic library.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/Makefile                  |    5 +++++
 tools/lib/lk/rbtree.h                  |    1 +
 tools/perf/Makefile                    |    6 ------
 tools/perf/builtin-annotate.c          |    2 +-
 tools/perf/builtin-kmem.c              |    2 +-
 tools/perf/builtin-report.c            |    2 +-
 tools/perf/builtin-timechart.c         |    2 +-
 tools/perf/builtin-top.c               |    2 +-
 tools/perf/util/callchain.h            |    2 +-
 tools/perf/util/include/linux/rbtree.h |    1 -
 tools/perf/util/map.h                  |    2 +-
 tools/perf/util/session.h              |    2 +-
 tools/perf/util/sort.h                 |    2 +-
 tools/perf/util/strlist.h              |    2 +-
 tools/perf/util/symbol.h               |    2 +-
 tools/perf/util/thread.h               |    2 +-
 tools/perf/util/ui/browser.c           |    2 +-
 tools/perf/util/ui/browsers/hists.c    |    2 +-
 18 files changed, 20 insertions(+), 21 deletions(-)
 create mode 100644 tools/lib/lk/rbtree.h
 delete mode 100644 tools/perf/util/include/linux/rbtree.h

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 985214a..32cf118 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -8,12 +8,15 @@ LIB_H += debugfs.h
 LIB_H += util.h
 LIB_H += types.h
 LIB_H += cpumap.h
+LIB_H += ../../../include/linux/rbtree.h
+LIB_H += rbtree.h
 
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
 LIB_OBJS += util.o
 LIB_OBJS += cpumap.o
 LIB_OBJS += ctype.o
+LIB_OBJS += rbtree.o
 
 LIBFILE = $(LIB_OUTPUT)lklib.a
 
@@ -29,6 +32,8 @@ $(LIBFILE): $(LIB_OBJS)
 
 $(LIB_OBJS): $(LIB_H)
 
+rbtree.o: ../../../lib/rbtree.c
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -I../../../include $<
 %.o: %.c
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
 %.s: %.c
diff --git a/tools/lib/lk/rbtree.h b/tools/lib/lk/rbtree.h
new file mode 100644
index 0000000..965901d
--- /dev/null
+++ b/tools/lib/lk/rbtree.h
@@ -0,0 +1 @@
+#include "../../../include/linux/rbtree.h"
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6d06417..2c82537 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -331,7 +331,6 @@ LIB_FILE=$(OUTPUT)libperf.a
 EXTRA_LIB_FILES=$(LIB_OUTPUT)libparsevent.a $(LIB_OUTPUT)lklib.a $(LIB_OUTPUT)lkperflib.a
 
 LIB_H += ../../include/linux/perf_event.h
-LIB_H += ../../include/linux/rbtree.h
 LIB_H += ../../include/linux/list.h
 LIB_H += ../../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
@@ -344,7 +343,6 @@ LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/module.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
-LIB_H += util/include/linux/rbtree.h
 LIB_H += util/include/linux/string.h
 LIB_H += util/include/linux/types.h
 LIB_H += util/include/asm/asm-offsets.h
@@ -398,7 +396,6 @@ LIB_OBJS += $(OUTPUT)util/levenshtein.o
 LIB_OBJS += $(OUTPUT)util/parse-options.o
 LIB_OBJS += $(OUTPUT)util/parse-events.o
 LIB_OBJS += $(OUTPUT)util/path.o
-LIB_OBJS += $(OUTPUT)util/rbtree.o
 LIB_OBJS += $(OUTPUT)util/bitmap.o
 LIB_OBJS += $(OUTPUT)util/hweight.o
 LIB_OBJS += $(OUTPUT)util/run-command.o
@@ -958,9 +955,6 @@ $(OUTPUT)util/ui/browsers/hists.o: util/ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/ui/browsers/map.o: util/ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
-$(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 19f2751..7f9983b 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -12,7 +12,7 @@
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include "util/symbol.h"
 
 #include "perf.h"
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 95901eb..f157a9c 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -13,7 +13,7 @@
 
 #include "util/debug.h"
 
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 
 struct alloc_stat;
 typedef int (*sort_fn_t)(struct alloc_stat *, struct alloc_stat *);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f8564f9..76e6967 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -12,7 +12,7 @@
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include "util/symbol.h"
 #include "util/callchain.h"
 #include "util/strlist.h"
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index fe79fc6..aa9e4fc 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -19,7 +19,7 @@
 #include "util/color.h"
 #include <linux/list.h>
 #include "util/cache.h"
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include "util/symbol.h"
 #include "util/callchain.h"
 #include "util/strlist.h"
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 773676f..3727a5c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -53,7 +53,7 @@
 #include <lk/cpumap.h>
 #include <perf/mmap.h>
 
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include <linux/unistd.h>
 #include <linux/types.h>
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 6de4313..e0d0dfb 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -3,7 +3,7 @@
 
 #include "../perf.h"
 #include <linux/list.h>
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include "event.h"
 #include "symbol.h"
 
diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
deleted file mode 100644
index 7a243a1..0000000
--- a/tools/perf/util/include/linux/rbtree.h
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../../../include/linux/rbtree.h"
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 729469e..4219466 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -3,7 +3,7 @@
 
 #include <linux/compiler.h>
 #include <linux/list.h>
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include <stdio.h>
 #include <stdbool.h>
 #include <lk/types.h>
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 9fa0fc2..6f2af58 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -6,7 +6,7 @@
 #include "header.h"
 #include "symbol.h"
 #include "thread.h"
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include "../../../include/linux/perf_event.h"
 
 struct sample_queue;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 0c68709..4c015e9 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -7,7 +7,7 @@
 #include "color.h"
 #include <linux/list.h>
 #include "cache.h"
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include "symbol.h"
 #include "string.h"
 #include "callchain.h"
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
index 3ba8390..649eae3 100644
--- a/tools/perf/util/strlist.h
+++ b/tools/perf/util/strlist.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_STRLIST_H
 #define __PERF_STRLIST_H
 
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include <stdbool.h>
 
 struct str_node {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ea95c27..adc7211 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -6,7 +6,7 @@
 #include <stdint.h>
 #include "map.h"
 #include <linux/list.h>
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include <stdio.h>
 
 #ifdef HAVE_CPLUS_DEMANGLE
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 688500f..1a70f60 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_THREAD_H
 #define __PERF_THREAD_H
 
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include <unistd.h>
 #include "symbol.h"
 
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 66f2d58..638a545 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -12,7 +12,7 @@
 #endif
 #include <slang.h>
 #include <linux/list.h>
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 #include <stdlib.h>
 #include <sys/ttydefaults.h>
 #include "browser.h"
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 6866aa4..1d4ee98 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -5,7 +5,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <newt.h>
-#include <linux/rbtree.h>
+#include <lk/rbtree.h>
 
 #include "../../hist.h"
 #include "../../pstack.h"
-- 
1.7.3.1

