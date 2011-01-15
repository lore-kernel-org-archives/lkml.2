Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1AOPm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:42:56 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52683 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1AOPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:41:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 03/16] perf evsel: Support event groups
Date: Sat, 15 Jan 2011 13:40:32 -0200
Message-Id: <1295106045-31192-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295106045-31192-1-git-send-email-acme@infradead.org>
References: <1295106045-31192-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The perf_evsel__open now have an extra boolean argument specifying if
event grouping is desired.

The first file descriptor created on a CPU becomes the group leader.

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
 tools/perf/builtin-stat.c |    4 ++--
 tools/perf/builtin-test.c |    4 ++--
 tools/perf/util/evsel.c   |   27 +++++++++++++++++----------
 tools/perf/util/evsel.h   |   10 ++++++----
 4 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ab3f745..453c4e9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -169,7 +169,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, cpus);
+		return perf_evsel__open_per_cpu(evsel, cpus, false);
 
 	attr->inherit = !no_inherit;
 	if (target_pid == -1 && target_tid == -1) {
@@ -177,7 +177,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, threads);
+	return perf_evsel__open_per_thread(evsel, threads, false);
 }
 
 /*
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index ed56961..1dd02c0 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -289,7 +289,7 @@ static int test__open_syscall_event(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open_per_thread(evsel, threads) < 0) {
+	if (perf_evsel__open_per_thread(evsel, threads, false) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -370,7 +370,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 		goto out_cpu_free;
 	}
 
-	if (perf_evsel__open(evsel, cpus, threads) < 0) {
+	if (perf_evsel__open(evsel, cpus, threads, false) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f5cfed6..da473ec 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -128,7 +128,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 }
 
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-			      struct thread_map *threads)
+			      struct thread_map *threads, bool group)
 {
 	int cpu, thread;
 
@@ -137,12 +137,18 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		return -1;
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
+		int group_fd = -1;
+
 		for (thread = 0; thread < threads->nr; thread++) {
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     threads->map[thread],
-								     cpus->map[cpu], -1, 0);
+								     cpus->map[cpu],
+								     group_fd, 0);
 			if (FD(evsel, cpu, thread) < 0)
 				goto out_close;
+
+			if (group && group_fd == -1)
+				group_fd = FD(evsel, cpu, thread);
 		}
 	}
 
@@ -175,10 +181,9 @@ static struct {
 	.threads = { -1, },
 };
 
-int perf_evsel__open(struct perf_evsel *evsel,
-		     struct cpu_map *cpus, struct thread_map *threads)
+int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
+		     struct thread_map *threads, bool group)
 {
-
 	if (cpus == NULL) {
 		/* Work around old compiler warnings about strict aliasing */
 		cpus = &empty_cpu_map.map;
@@ -187,15 +192,17 @@ int perf_evsel__open(struct perf_evsel *evsel,
 	if (threads == NULL)
 		threads = &empty_thread_map.map;
 
-	return __perf_evsel__open(evsel, cpus, threads);
+	return __perf_evsel__open(evsel, cpus, threads, group);
 }
 
-int perf_evsel__open_per_cpu(struct perf_evsel *evsel, struct cpu_map *cpus)
+int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
+			     struct cpu_map *cpus, bool group)
 {
-	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map);
+	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group);
 }
 
-int perf_evsel__open_per_thread(struct perf_evsel *evsel, struct thread_map *threads)
+int perf_evsel__open_per_thread(struct perf_evsel *evsel,
+				struct thread_map *threads, bool group)
 {
-	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads);
+	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group);
 }
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index b2d755f..0962b50 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -45,10 +45,12 @@ int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
-int perf_evsel__open_per_cpu(struct perf_evsel *evsel, struct cpu_map *cpus);
-int perf_evsel__open_per_thread(struct perf_evsel *evsel, struct thread_map *threads);
-int perf_evsel__open(struct perf_evsel *evsel, 
-		     struct cpu_map *cpus, struct thread_map *threads);
+int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
+			     struct cpu_map *cpus, bool group);
+int perf_evsel__open_per_thread(struct perf_evsel *evsel,
+				struct thread_map *threads, bool group);
+int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
+		     struct thread_map *threads, bool group);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
-- 
1.6.2.5

