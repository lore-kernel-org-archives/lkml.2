Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab2LTJGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:06:42 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:34364 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2LTJGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:06:37 -0500
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qin@gmail.com>, David Ahern <dsahern@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@taobao.com>
Subject: [PATCH 3/5] perf tools: Add bitmap filed to thread_map to support new threads aware.
Date: Thu, 20 Dec 2012 17:06:21 +0800
Message-Id: <1355994381-13661-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During a target thread's life cycle, it may be fork many threads. But in the
current version of 'perf top{record} -p $pid', the new forked threads can not be
apperceived by perf. The content of thread_map and other related structures
need to be refreshed on-the-fly to apperceive the threads' fork and exit. A
pre-allocate large array with a bitmap to record which position can be used is a
simple way. This patch add a bitmap field into struct thread_map and modify the
related code in thread_map.c & evsel.c.
But in this patch, the bitmap mechanism cannot yet be used up, because the
interface of evlist and evsel have not been modified.

Cc: David Ahern <dsahern@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
---
 tools/perf/util/evsel.c      |   19 ++++-
 tools/perf/util/thread_map.c |  171 ++++++++++++++++++++++--------------------
 tools/perf/util/thread_map.h |    8 ++
 3 files changed, 116 insertions(+), 82 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1b16dd1..a34167f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -790,11 +790,21 @@ static struct {
 	.cpus	= { -1, },
 };
 
+/*
+ * while we use empty_thread_map, we should clear the empty_thread_bitmap,
+ * and set the first bit.
+ */
+static DECLARE_BITMAP(empty_thread_bitmap, PID_MAX_DEFAULT);
+
 static struct {
 	struct thread_map map;
 	int threads[1];
 } empty_thread_map = {
-	.map.nr	 = 1,
+	.map = {
+		.max_nr = MAX_THREADS_NR_DEFAULT,
+		.nr = 1,
+		.bitmap = empty_thread_bitmap,
+	},
 	.threads = { -1, },
 };
 
@@ -806,8 +816,11 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		cpus = &empty_cpu_map.map;
 	}
 
-	if (threads == NULL)
+	if (threads == NULL) {
 		threads = &empty_thread_map.map;
+		bitmap_zero(threads->bitmap, PID_MAX_DEFAULT);
+		set_bit(0, threads->bitmap);
+	}
 
 	return __perf_evsel__open(evsel, cpus, threads);
 }
@@ -815,6 +828,8 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
 			     struct cpu_map *cpus)
 {
+	bitmap_zero(empty_thread_map.map.bitmap, PID_MAX_DEFAULT);
+	set_bit(0, empty_thread_map.map.bitmap);
 	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map);
 }
 
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 9b5f856..7966f3f 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -9,6 +9,8 @@
 #include "strlist.h"
 #include <string.h>
 #include "thread_map.h"
+#include <linux/bitmap.h>
+#include "debug.h"
 
 /* Skip "." and ".." directories */
 static int filter(const struct dirent *dir)
@@ -21,7 +23,7 @@ static int filter(const struct dirent *dir)
 
 struct thread_map *thread_map__new_by_pid(pid_t pid)
 {
-	struct thread_map *threads;
+	struct thread_map *threads = NULL;
 	char name[256];
 	int items;
 	struct dirent **namelist = NULL;
@@ -32,11 +34,12 @@ struct thread_map *thread_map__new_by_pid(pid_t pid)
 	if (items <= 0)
 		return NULL;
 
-	threads = malloc(sizeof(*threads) + sizeof(pid_t) * items);
-	if (threads != NULL) {
-		for (i = 0; i < items; i++)
-			threads->map[i] = atoi(namelist[i]->d_name);
-		threads->nr = items;
+	for (i = 0; i < items; i++) {
+		bool re_alloc;
+
+		if (thread_map__update(&threads, atoi(namelist[i]->d_name),
+				       &re_alloc) < 0)
+			return NULL;
 	}
 
 	for (i=0; i<items; i++)
@@ -48,12 +51,11 @@ struct thread_map *thread_map__new_by_pid(pid_t pid)
 
 struct thread_map *thread_map__new_by_tid(pid_t tid)
 {
-	struct thread_map *threads = malloc(sizeof(*threads) + sizeof(pid_t));
+	struct thread_map *threads = NULL;
+	bool re_alloc;
 
-	if (threads != NULL) {
-		threads->map[0] = tid;
-		threads->nr	= 1;
-	}
+	if (thread_map__update(&threads, tid, &re_alloc) < 0)
+		return NULL;
 
 	return threads;
 }
@@ -61,23 +63,17 @@ struct thread_map *thread_map__new_by_tid(pid_t tid)
 struct thread_map *thread_map__new_by_uid(uid_t uid)
 {
 	DIR *proc;
-	int max_threads = 32, items, i;
+	int items, i;
 	char path[256];
 	struct dirent dirent, *next, **namelist = NULL;
-	struct thread_map *threads = malloc(sizeof(*threads) +
-					    max_threads * sizeof(pid_t));
-	if (threads == NULL)
-		goto out;
+	struct thread_map *threads = NULL;
 
 	proc = opendir("/proc");
 	if (proc == NULL)
-		goto out_free_threads;
-
-	threads->nr = 0;
+		goto out;
 
 	while (!readdir_r(proc, &dirent, &next) && next) {
 		char *end;
-		bool grow = false;
 		struct stat st;
 		pid_t pid = strtol(dirent.d_name, &end, 10);
 
@@ -97,30 +93,17 @@ struct thread_map *thread_map__new_by_uid(uid_t uid)
 		if (items <= 0)
 			goto out_free_closedir;
 
-		while (threads->nr + items >= max_threads) {
-			max_threads *= 2;
-			grow = true;
-		}
-
-		if (grow) {
-			struct thread_map *tmp;
+		for (i = 0; i < items; i++) {
+			bool re_alloc;
 
-			tmp = realloc(threads, (sizeof(*threads) +
-						max_threads * sizeof(pid_t)));
-			if (tmp == NULL)
+			if (thread_map__update(&threads,
+					       atoi(namelist[i]->d_name),
+					       &re_alloc) < 0)
 				goto out_free_namelist;
-
-			threads = tmp;
 		}
 
 		for (i = 0; i < items; i++)
-			threads->map[threads->nr + i] = atoi(namelist[i]->d_name);
-
-		for (i = 0; i < items; i++)
 			free(namelist[i]);
 		free(namelist);
-
-		threads->nr += items;
 	}
 
 out_closedir:
@@ -128,17 +111,13 @@ out_closedir:
 out:
 	return threads;
 
-out_free_threads:
-	free(threads);
-	return NULL;
-
 out_free_namelist:
 	for (i = 0; i < items; i++)
 		free(namelist[i]);
 	free(namelist);
 
 out_free_closedir:
-	free(threads);
+	thread_map__delete(threads);
 	threads = NULL;
 	goto out_closedir;
 }
@@ -154,13 +133,61 @@ struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid)
 	return thread_map__new_by_tid(tid);
 }
 
+int thread_map__update(struct thread_map **threads, pid_t tid,
+			bool *need_realloc)
+{
+	struct thread_map *nt = NULL;
+	bool init_threads = false;
+	int max_nr, thread_nr;
+
+	*need_realloc = false;
+
+	if ((*threads) == NULL)
+		init_threads = true;
+
+	if (init_threads || ((*threads)->nr + 1 == (*threads)->max_nr)) {
+		if (init_threads)
+			max_nr = MAX_THREADS_NR_DEFAULT;
+		else {
+			max_nr = (*threads)->max_nr * 2;
+			*need_realloc = true;
+		}
+
+		nt = realloc(*threads, sizeof(**threads) +
+			     sizeof(pid_t) * max_nr);
+		if (nt == NULL) {
+			ui__error("Oops: realloc failed\n");
+			goto out;
+		}
+
+		*threads = nt;
+		(*threads)->max_nr = max_nr;
+		if (init_threads) {
+			(*threads)->nr = 0;
+			(*threads)->bitmap = zalloc(PID_MAX_DEFAULT /
+						    BITS_PER_BYTE);
+			if ((*threads)->bitmap == NULL)
+				goto out_free_threads;
+		}
+	}
+
+	thread_nr = find_first_zero_bit((*threads)->bitmap, PID_MAX_DEFAULT);
+	(*threads)->map[thread_nr] = tid;
+	set_bit(thread_nr, (*threads)->bitmap);
+	(*threads)->nr++;
+
+	return thread_nr;
+out_free_threads:
+	free(threads);
+out:
+	return -1;
+}
+
 static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 {
-	struct thread_map *threads = NULL, *nt;
+	struct thread_map *threads = NULL;
 	char name[256];
-	int items, total_tasks = 0;
+	int items;
 	struct dirent **namelist = NULL;
-	int i, j = 0;
+	int i;
 	pid_t pid, prev_pid = INT_MAX;
 	char *end_ptr;
 	struct str_node *pos;
@@ -184,19 +211,15 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 		if (items <= 0)
 			goto out_free_threads;
 
-		total_tasks += items;
-		nt = realloc(threads, (sizeof(*threads) +
-				       sizeof(pid_t) * total_tasks));
-		if (nt == NULL)
-			goto out_free_namelist;
+		for (i = 0; i < items; i++) {
+			bool re_alloc;
 
-		threads = nt;
+			if (thread_map__update(&threads,
+					       atoi(namelist[i]->d_name),
+					       &re_alloc) < 0)
+				goto out_free_threads;
 
-		for (i = 0; i < items; i++) {
-			threads->map[j++] = atoi(namelist[i]->d_name);
 			free(namelist[i]);
 		}
-		threads->nr = total_tasks;
 		free(namelist);
 	}
 
@@ -204,21 +227,15 @@ out:
 	strlist__delete(slist);
 	return threads;
 
-out_free_namelist:
-	for (i = 0; i < items; i++)
-		free(namelist[i]);
-	free(namelist);
-
 out_free_threads:
-	free(threads);
+	thread_map__delete(threads);
 	threads = NULL;
 	goto out;
 }
 
 static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 {
-	struct thread_map *threads = NULL, *nt;
-	int ntasks = 0;
+	struct thread_map *threads = NULL;
 	pid_t tid, prev_tid = INT_MAX;
 	char *end_ptr;
 	struct str_node *pos;
@@ -226,11 +243,11 @@ static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 
 	/* perf-stat expects threads to be generated even if tid not given */
 	if (!tid_str) {
-		threads = malloc(sizeof(*threads) + sizeof(pid_t));
-		if (threads != NULL) {
-			threads->map[0] = -1;
-			threads->nr	= 1;
-		}
+		bool re_alloc;
+
+		if (thread_map__update(&threads, -1, &re_alloc) < 0)
+			return NULL;
+
 		return threads;
 	}
 
@@ -239,6 +256,7 @@ static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 		return NULL;
 
 	strlist__for_each(pos, slist) {
+		bool re_alloc;
 		tid = strtol(pos->s, &end_ptr, 10);
 
 		if (tid == INT_MIN || tid == INT_MAX ||
@@ -248,27 +266,19 @@ static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 		if (tid == prev_tid)
 			continue;
 
-		ntasks++;
-		nt = realloc(threads, sizeof(*threads) + sizeof(pid_t) * ntasks);
-
-		if (nt == NULL)
-			goto out_free_threads;
-
-		threads = nt;
-		threads->map[ntasks - 1] = tid;
-		threads->nr		 = ntasks;
+		if (thread_map__update(&threads, tid, &re_alloc) < 0)
+			return NULL;
 	}
 out:
 	return threads;
 
 out_free_threads:
-	free(threads);
+	thread_map__delete(threads);
 	threads = NULL;
 	goto out;
 }
 
-struct thread_map *thread_map__new_str(const char *pid, const char *tid,
-				       uid_t uid)
+struct thread_map *thread_map__new_str(const char *pid, const char *tid,
+					uid_t uid)
 {
 	if (pid)
 		return thread_map__new_by_pid_str(pid);
@@ -281,6 +291,7 @@ struct thread_map *thread_map__new_str(const char *pid, const char *tid,
 
 void thread_map__delete(struct thread_map *threads)
 {
+	free(threads->bitmap);
 	free(threads);
 }
 
@@ -289,7 +300,7 @@ size_t thread_map__fprintf(struct thread_map *threads, FILE *fp)
 	int i;
 	size_t printed = fprintf(fp, "%d thread%s: ",
 				 threads->nr, threads->nr > 1 ? "s" : "");
-	for (i = 0; i < threads->nr; ++i)
+	for_each_set_bit(i, threads->bitmap, PID_MAX_DEFAULT)
 		printed += fprintf(fp, "%s%d", i ? ", " : "", threads->map[i]);
 
 	return printed + fprintf(fp, "\n");
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index f718df8..08c2b44 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -3,9 +3,15 @@
 
 #include <sys/types.h>
 #include <stdio.h>
+#include <stdbool.h>
+#include <linux/bitops.h>
+
+#define MAX_THREADS_NR_DEFAULT 32
 
 struct thread_map {
+	int max_nr;
 	int nr;
+	BITMAP *bitmap;
 	pid_t map[];
 };
 
@@ -17,6 +23,8 @@ struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid);
 struct thread_map *thread_map__new_str(const char *pid,
 		const char *tid, uid_t uid);
 
+int thread_map__update(struct thread_map **threads, pid_t tid, bool *realloc);
+
 void thread_map__delete(struct thread_map *threads);
 
 size_t thread_map__fprintf(struct thread_map *threads, FILE *fp);
-- 
1.7.9.5

