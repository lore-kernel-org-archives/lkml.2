Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab1ADDtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 22:49:06 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44169 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1ADDsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 22:48:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 06/11] perf evsel: Introduce per cpu and per thread open helpers
Date: Tue,  4 Jan 2011 01:48:20 -0200
Message-Id: <1294112905-25325-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294112905-25325-1-git-send-email-acme@infradead.org>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Abstracting away the loops needed to create the various event fd handlers.

The users have to pass a confiruged perf->evsel.attr field, which is already
usable after perf_evsel__new (constructor) time, using defaults.

Comes out of the ad-hoc routines in builtin-stat, that now uses it.

Fixed a small silly bug where we were die()ing before killing our
children, dysfunctional family this one 8-)

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |   84 ++++++++++++++-------------------------------
 tools/perf/util/evsel.c   |   52 ++++++++++++++++++++++++++++
 tools/perf/util/evsel.h   |    5 +++
 3 files changed, 83 insertions(+), 58 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a8b00b4..065e79e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -53,8 +53,6 @@
 #include <math.h>
 #include <locale.h>
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-
 #define DEFAULT_SEPARATOR	" "
 
 static struct perf_event_attr default_attrs[] = {
@@ -160,56 +158,24 @@ struct stats			runtime_cycles_stats[MAX_NR_CPUS];
 struct stats			runtime_branches_stats[MAX_NR_CPUS];
 struct stats			walltime_nsecs_stats;
 
-#define ERR_PERF_OPEN \
-"counter %d, sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information."
-
-static int create_perf_stat_counter(struct perf_evsel *evsel, bool *perm_err)
+static int create_perf_stat_counter(struct perf_evsel *evsel)
 {
 	struct perf_event_attr *attr = &evsel->attr;
-	int thread;
-	int ncreated = 0;
 
 	if (scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
 
-	if (system_wide) {
-		int cpu;
-
-		for (cpu = 0; cpu < nr_cpus; cpu++) {
-			FD(evsel, cpu, 0) = sys_perf_event_open(attr,
-					-1, cpumap[cpu], -1, 0);
-			if (FD(evsel, cpu, 0) < 0) {
-				if (errno == EPERM || errno == EACCES)
-					*perm_err = true;
-				error(ERR_PERF_OPEN, evsel->idx,
-					FD(evsel, cpu, 0), strerror(errno));
-			} else {
-				++ncreated;
-			}
-		}
-	} else {
-		attr->inherit = !no_inherit;
-		if (target_pid == -1 && target_tid == -1) {
-			attr->disabled = 1;
-			attr->enable_on_exec = 1;
-		}
-		for (thread = 0; thread < thread_num; thread++) {
-			FD(evsel, 0, thread) = sys_perf_event_open(attr,
-				all_tids[thread], -1, -1, 0);
-			if (FD(evsel, 0, thread) < 0) {
-				if (errno == EPERM || errno == EACCES)
-					*perm_err = true;
-				error(ERR_PERF_OPEN, evsel->idx,
-					FD(evsel, 0, thread),
-					 strerror(errno));
-			} else {
-				++ncreated;
-			}
-		}
+	if (system_wide)
+		return perf_evsel__open_per_cpu(evsel, nr_cpus, cpumap);
+
+	attr->inherit = !no_inherit;
+	if (target_pid == -1 && target_tid == -1) {
+		attr->disabled = 1;
+		attr->enable_on_exec = 1;
 	}
 
-	return ncreated;
+	return perf_evsel__open_per_thread(evsel, thread_num, all_tids);
 }
 
 /*
@@ -289,9 +255,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 	unsigned long long t0, t1;
 	struct perf_evsel *counter;
 	int status = 0;
-	int ncreated = 0;
 	int child_ready_pipe[2], go_pipe[2];
-	bool perm_err = false;
 	const bool forks = (argc > 0);
 	char buf;
 
@@ -349,19 +313,23 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
-	list_for_each_entry(counter, &evsel_list, node)
-		ncreated += create_perf_stat_counter(counter, &perm_err);
-
-	if (ncreated < nr_counters) {
-		if (perm_err)
-			error("You may not have permission to collect %sstats.\n"
-			      "\t Consider tweaking"
-			      " /proc/sys/kernel/perf_event_paranoid or running as root.",
-			      system_wide ? "system-wide " : "");
-		die("Not all events could be opened.\n");
-		if (child_pid != -1)
-			kill(child_pid, SIGTERM);
-		return -1;
+	list_for_each_entry(counter, &evsel_list, node) {
+		if (create_perf_stat_counter(counter) < 0) {
+			if (errno == -EPERM || errno == -EACCES) {
+				error("You may not have permission to collect %sstats.\n"
+				      "\t Consider tweaking"
+				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
+				      system_wide ? "system-wide " : "");
+			} else {
+				error("open_counter returned with %d (%s). "
+				      "/bin/dmesg may provide additional information.\n",
+				       errno, strerror(errno));
+			}
+			if (child_pid != -1)
+				kill(child_pid, SIGTERM);
+			die("Not all events could be opened.\n");
+			return -1;
+		}
 	}
 
 	/*
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 3f5de51..e62cc5e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1,4 +1,5 @@
 #include "evsel.h"
+#include "../perf.h"
 #include "util.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
@@ -121,3 +122,54 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 
 	return 0;
 }
+
+int perf_evsel__open_per_cpu(struct perf_evsel *evsel, int ncpus, int *cpu_map)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < ncpus; cpu++) {
+		FD(evsel, cpu, 0) = sys_perf_event_open(&evsel->attr, -1,
+							cpu_map[cpu], -1, 0);
+		if (FD(evsel, cpu, 0) < 0)
+			goto out_close;
+	}
+
+	return 0;
+
+out_close:
+	while (--cpu >= 0) {
+		close(FD(evsel, cpu, 0));
+		FD(evsel, cpu, 0) = -1;
+	}
+	return -1;
+}
+
+int perf_evsel__open_per_thread(struct perf_evsel *evsel, int nthreads, int *thread_map)
+{
+	int thread;
+
+	for (thread = 0; thread < nthreads; thread++) {
+		FD(evsel, 0, thread) = sys_perf_event_open(&evsel->attr,
+							   thread_map[thread], -1, -1, 0);
+		if (FD(evsel, 0, thread) < 0)
+			goto out_close;
+	}
+
+	return 0;
+
+out_close:
+	while (--thread >= 0) {
+		close(FD(evsel, 0, thread));
+		FD(evsel, 0, thread) = -1;
+	}
+	return -1;
+}
+
+int perf_evsel__open(struct perf_evsel *evsel, int ncpus, int nthreads,
+		     int *cpu_map, int *thread_map)
+{
+	if (nthreads < 0)
+		return perf_evsel__open_per_cpu(evsel, ncpus, cpu_map);
+
+	return perf_evsel__open_per_thread(evsel, nthreads, thread_map);
+}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 8b48ef1..a62fb55 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -42,6 +42,11 @@ int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
+int perf_evsel__open_per_cpu(struct perf_evsel *evsel, int ncpus, int *cpu_map);
+int perf_evsel__open_per_thread(struct perf_evsel *evsel, int nthreads, int *thread_map);
+int perf_evsel__open(struct perf_evsel *evsel, int ncpus, int nthreads,
+		     int *cpu_map, int *thread_map);
+
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
 	 evsel->attr.config == PERF_COUNT_##c)
-- 
1.6.2.5

