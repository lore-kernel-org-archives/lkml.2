Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab1ADIZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:25:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:59210 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab1ADIZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:25:54 -0500
Date: Tue, 4 Jan 2011 08:25:13 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Use {cpu,thread}_map to shorten list of parameters
Message-ID: <tip-86bd5e8603b00b06189328c6d7034d2dc434d6bb@git.kernel.org>
Git-Commit-ID: 86bd5e8603b00b06189328c6d7034d2dc434d6bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:25:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86bd5e8603b00b06189328c6d7034d2dc434d6bb
Gitweb:     http://git.kernel.org/tip/86bd5e8603b00b06189328c6d7034d2dc434d6bb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 3 Jan 2011 23:09:46 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 4 Jan 2011 00:24:36 -0200

perf evsel: Use {cpu,thread}_map to shorten list of parameters

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
 tools/perf/util/evsel.c   |   24 +++++++++++++-----------
 tools/perf/util/evsel.h   |   11 +++++++----
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 6b9146c..02b2d80 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -166,7 +166,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, cpus->nr, cpus->map);
+		return perf_evsel__open_per_cpu(evsel, cpus);
 
 	attr->inherit = !no_inherit;
 	if (target_pid == -1 && target_tid == -1) {
@@ -174,7 +174,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, threads->nr, threads->map);
+	return perf_evsel__open_per_thread(evsel, threads);
 }
 
 /*
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e62cc5e..e44be52 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1,6 +1,8 @@
 #include "evsel.h"
 #include "../perf.h"
 #include "util.h"
+#include "cpumap.h"
+#include "thread.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
@@ -123,13 +125,13 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	return 0;
 }
 
-int perf_evsel__open_per_cpu(struct perf_evsel *evsel, int ncpus, int *cpu_map)
+int perf_evsel__open_per_cpu(struct perf_evsel *evsel, struct cpu_map *cpus)
 {
 	int cpu;
 
-	for (cpu = 0; cpu < ncpus; cpu++) {
+	for (cpu = 0; cpu < cpus->nr; cpu++) {
 		FD(evsel, cpu, 0) = sys_perf_event_open(&evsel->attr, -1,
-							cpu_map[cpu], -1, 0);
+							cpus->map[cpu], -1, 0);
 		if (FD(evsel, cpu, 0) < 0)
 			goto out_close;
 	}
@@ -144,13 +146,13 @@ out_close:
 	return -1;
 }
 
-int perf_evsel__open_per_thread(struct perf_evsel *evsel, int nthreads, int *thread_map)
+int perf_evsel__open_per_thread(struct perf_evsel *evsel, struct thread_map *threads)
 {
 	int thread;
 
-	for (thread = 0; thread < nthreads; thread++) {
+	for (thread = 0; thread < threads->nr; thread++) {
 		FD(evsel, 0, thread) = sys_perf_event_open(&evsel->attr,
-							   thread_map[thread], -1, -1, 0);
+							   threads->map[thread], -1, -1, 0);
 		if (FD(evsel, 0, thread) < 0)
 			goto out_close;
 	}
@@ -165,11 +167,11 @@ out_close:
 	return -1;
 }
 
-int perf_evsel__open(struct perf_evsel *evsel, int ncpus, int nthreads,
-		     int *cpu_map, int *thread_map)
+int perf_evsel__open(struct perf_evsel *evsel, 
+		     struct cpu_map *cpus, struct thread_map *threads)
 {
-	if (nthreads < 0)
-		return perf_evsel__open_per_cpu(evsel, ncpus, cpu_map);
+	if (threads == NULL)
+		return perf_evsel__open_per_cpu(evsel, cpus);
 
-	return perf_evsel__open_per_thread(evsel, nthreads, thread_map);
+	return perf_evsel__open_per_thread(evsel, threads);
 }
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a62fb55..863d78d 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -34,6 +34,9 @@ struct perf_evsel {
 	void			*priv;
 };
 
+struct cpu_map;
+struct thread_map;
+
 struct perf_evsel *perf_evsel__new(u32 type, u64 config, int idx);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
@@ -42,10 +45,10 @@ int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
-int perf_evsel__open_per_cpu(struct perf_evsel *evsel, int ncpus, int *cpu_map);
-int perf_evsel__open_per_thread(struct perf_evsel *evsel, int nthreads, int *thread_map);
-int perf_evsel__open(struct perf_evsel *evsel, int ncpus, int nthreads,
-		     int *cpu_map, int *thread_map);
+int perf_evsel__open_per_cpu(struct perf_evsel *evsel, struct cpu_map *cpus);
+int perf_evsel__open_per_thread(struct perf_evsel *evsel, struct thread_map *threads);
+int perf_evsel__open(struct perf_evsel *evsel, 
+		     struct cpu_map *cpus, struct thread_map *threads);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
