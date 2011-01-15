Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1AOPnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:43:10 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52681 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1AOPlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:41:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 04/16] perf evsel: Allow specifying if the inherit bit should be set
Date: Sat, 15 Jan 2011 13:40:33 -0200
Message-Id: <1295106045-31192-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295106045-31192-1-git-send-email-acme@infradead.org>
References: <1295106045-31192-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As this is a per-cpu attribute, we can't set it up in advance and use it
for all the calls.

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
 tools/perf/util/evsel.c   |   16 +++++++++-------
 tools/perf/util/evsel.h   |    6 +++---
 4 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 453c4e9..d151eaa 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -169,7 +169,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, cpus, false);
+		return perf_evsel__open_per_cpu(evsel, cpus, false, false);
 
 	attr->inherit = !no_inherit;
 	if (target_pid == -1 && target_tid == -1) {
@@ -177,7 +177,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, threads, false);
+	return perf_evsel__open_per_thread(evsel, threads, false, false);
 }
 
 /*
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1dd02c0..419ce20 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -289,7 +289,7 @@ static int test__open_syscall_event(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open_per_thread(evsel, threads, false) < 0) {
+	if (perf_evsel__open_per_thread(evsel, threads, false, false) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -370,7 +370,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 		goto out_cpu_free;
 	}
 
-	if (perf_evsel__open(evsel, cpus, threads, false) < 0) {
+	if (perf_evsel__open(evsel, cpus, threads, false, false) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index da473ec..82a0053 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -128,7 +128,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 }
 
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-			      struct thread_map *threads, bool group)
+			      struct thread_map *threads, bool group, bool inherit)
 {
 	int cpu, thread;
 
@@ -139,6 +139,8 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		int group_fd = -1;
 
+		evsel->attr.inherit = (cpus->map[cpu] < 0) && inherit;
+
 		for (thread = 0; thread < threads->nr; thread++) {
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     threads->map[thread],
@@ -182,7 +184,7 @@ static struct {
 };
 
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group)
+		     struct thread_map *threads, bool group, bool inherit)
 {
 	if (cpus == NULL) {
 		/* Work around old compiler warnings about strict aliasing */
@@ -192,17 +194,17 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	if (threads == NULL)
 		threads = &empty_thread_map.map;
 
-	return __perf_evsel__open(evsel, cpus, threads, group);
+	return __perf_evsel__open(evsel, cpus, threads, group, inherit);
 }
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group)
+			     struct cpu_map *cpus, bool group, bool inherit)
 {
-	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group);
+	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group, inherit);
 }
 
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group)
+				struct thread_map *threads, bool group, bool inherit)
 {
-	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group);
+	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group, inherit);
 }
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 0962b50..1594696 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -46,11 +46,11 @@ void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group);
+			     struct cpu_map *cpus, bool group, bool inherit);
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group);
+				struct thread_map *threads, bool group, bool inherit);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group);
+		     struct thread_map *threads, bool group, bool inherit);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
-- 
1.6.2.5

