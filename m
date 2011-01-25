Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1AYR0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:26:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab1AYRWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:11 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 27/29] perf threads: Move thread_map to separate file
Date: Tue, 25 Jan 2011 15:21:50 -0200
Message-Id: <1295976112-2796-28-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To untangle it from struct thread handling, that is tied to symbols, etc.

Right now in the python bindings I'm working on I need just a subset of
the util/ files, untangling it allows me to do that.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile          |    2 +
 tools/perf/builtin-record.c  |    1 +
 tools/perf/builtin-stat.c    |    1 +
 tools/perf/builtin-test.c    |    2 +-
 tools/perf/builtin-top.c     |    1 +
 tools/perf/util/evsel.c      |    2 +-
 tools/perf/util/thread.c     |   55 ------------------------------------
 tools/perf/util/thread.h     |   14 ---------
 tools/perf/util/thread_map.c |   64 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/thread_map.h |   15 ++++++++++
 10 files changed, 86 insertions(+), 71 deletions(-)
 create mode 100644 tools/perf/util/thread_map.c
 create mode 100644 tools/perf/util/thread_map.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f20bc6f..638e8e1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -426,6 +426,7 @@ LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
+LIB_H += util/thread_map.h
 LIB_H += util/trace-event.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
@@ -471,6 +472,7 @@ LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/thread.o
+LIB_OBJS += $(OUTPUT)util/thread_map.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
 LIB_OBJS += $(OUTPUT)util/trace-event-read.o
 LIB_OBJS += $(OUTPUT)util/trace-event-info.o
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1346d42..d788630 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -24,6 +24,7 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/cpumap.h"
+#include "util/thread_map.h"
 
 #include <unistd.h>
 #include <sched.h>
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e2a2d02..8906adf 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -49,6 +49,7 @@
 #include "util/header.h"
 #include "util/cpumap.h"
 #include "util/thread.h"
+#include "util/thread_map.h"
 
 #include <sys/prctl.h>
 #include <math.h>
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 4fd3453..dc91ee0 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -12,7 +12,7 @@
 #include "util/parse-events.h"
 #include "util/session.h"
 #include "util/symbol.h"
-#include "util/thread.h"
+#include "util/thread_map.h"
 
 static long page_size;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 31fbaf3..d0b16d9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -26,6 +26,7 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
+#include "util/thread_map.h"
 #include "util/util.h"
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ee49035..9a6d942 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -3,7 +3,7 @@
 #include "../perf.h"
 #include "util.h"
 #include "cpumap.h"
-#include "thread.h"
+#include "thread_map.h"
 
 #include <unistd.h>
 #include <sys/mman.h>
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 00f4ead..d5d3b22 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -7,61 +7,6 @@
 #include "util.h"
 #include "debug.h"
 
-/* Skip "." and ".." directories */
-static int filter(const struct dirent *dir)
-{
-	if (dir->d_name[0] == '.')
-		return 0;
-	else
-		return 1;
-}
-
-struct thread_map *thread_map__new_by_pid(pid_t pid)
-{
-	struct thread_map *threads;
-	char name[256];
-	int items;
-	struct dirent **namelist = NULL;
-	int i;
-
-	sprintf(name, "/proc/%d/task", pid);
-	items = scandir(name, &namelist, filter, NULL);
-	if (items <= 0)
-                return NULL;
-
-	threads = malloc(sizeof(*threads) + sizeof(pid_t) * items);
-	if (threads != NULL) {
-		for (i = 0; i < items; i++)
-			threads->map[i] = atoi(namelist[i]->d_name);
-		threads->nr = items;
-	}
-
-	for (i=0; i<items; i++)
-		free(namelist[i]);
-	free(namelist);
-
-	return threads;
-}
-
-struct thread_map *thread_map__new_by_tid(pid_t tid)
-{
-	struct thread_map *threads = malloc(sizeof(*threads) + sizeof(pid_t));
-
-	if (threads != NULL) {
-		threads->map[0] = tid;
-		threads->nr	= 1;
-	}
-
-	return threads;
-}
-
-struct thread_map *thread_map__new(pid_t pid, pid_t tid)
-{
-	if (pid != -1)
-		return thread_map__new_by_pid(pid);
-	return thread_map__new_by_tid(tid);
-}
-
 static struct thread *thread__new(pid_t pid)
 {
 	struct thread *self = zalloc(sizeof(*self));
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index d757410..e5f2401 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -18,24 +18,10 @@ struct thread {
 	int			comm_len;
 };
 
-struct thread_map {
-	int nr;
-	int map[];
-};
-
 struct perf_session;
 
 void thread__delete(struct thread *self);
 
-struct thread_map *thread_map__new_by_pid(pid_t pid);
-struct thread_map *thread_map__new_by_tid(pid_t tid);
-struct thread_map *thread_map__new(pid_t pid, pid_t tid);
-
-static inline void thread_map__delete(struct thread_map *threads)
-{
-	free(threads);
-}
-
 int thread__set_comm(struct thread *self, const char *comm);
 int thread__comm_len(struct thread *self);
 struct thread *perf_session__findnew(struct perf_session *self, pid_t pid);
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
new file mode 100644
index 0000000..a5df131
--- /dev/null
+++ b/tools/perf/util/thread_map.c
@@ -0,0 +1,64 @@
+#include <dirent.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include "thread_map.h"
+
+/* Skip "." and ".." directories */
+static int filter(const struct dirent *dir)
+{
+	if (dir->d_name[0] == '.')
+		return 0;
+	else
+		return 1;
+}
+
+struct thread_map *thread_map__new_by_pid(pid_t pid)
+{
+	struct thread_map *threads;
+	char name[256];
+	int items;
+	struct dirent **namelist = NULL;
+	int i;
+
+	sprintf(name, "/proc/%d/task", pid);
+	items = scandir(name, &namelist, filter, NULL);
+	if (items <= 0)
+                return NULL;
+
+	threads = malloc(sizeof(*threads) + sizeof(pid_t) * items);
+	if (threads != NULL) {
+		for (i = 0; i < items; i++)
+			threads->map[i] = atoi(namelist[i]->d_name);
+		threads->nr = items;
+	}
+
+	for (i=0; i<items; i++)
+		free(namelist[i]);
+	free(namelist);
+
+	return threads;
+}
+
+struct thread_map *thread_map__new_by_tid(pid_t tid)
+{
+	struct thread_map *threads = malloc(sizeof(*threads) + sizeof(pid_t));
+
+	if (threads != NULL) {
+		threads->map[0] = tid;
+		threads->nr	= 1;
+	}
+
+	return threads;
+}
+
+struct thread_map *thread_map__new(pid_t pid, pid_t tid)
+{
+	if (pid != -1)
+		return thread_map__new_by_pid(pid);
+	return thread_map__new_by_tid(tid);
+}
+
+void thread_map__delete(struct thread_map *threads)
+{
+	free(threads);
+}
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
new file mode 100644
index 0000000..3cb9073
--- /dev/null
+++ b/tools/perf/util/thread_map.h
@@ -0,0 +1,15 @@
+#ifndef __PERF_THREAD_MAP_H
+#define __PERF_THREAD_MAP_H
+
+#include <sys/types.h>
+
+struct thread_map {
+	int nr;
+	int map[];
+};
+
+struct thread_map *thread_map__new_by_pid(pid_t pid);
+struct thread_map *thread_map__new_by_tid(pid_t tid);
+struct thread_map *thread_map__new(pid_t pid, pid_t tid);
+void thread_map__delete(struct thread_map *threads);
+#endif	/* __PERF_THREAD_MAP_H */
-- 
1.6.2.5

