Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab1ADDtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 22:49:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:43467 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1ADDsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 22:48:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 02/11] perf evsel: Adopt MATCH_EVENT macro from 'stat'
Date: Tue,  4 Jan 2011 01:48:16 -0200
Message-Id: <1294112905-25325-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294112905-25325-1-git-send-email-acme@infradead.org>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 tools/perf/builtin-stat.c |   37 ++++++++++++++++---------------------
 tools/perf/util/evsel.h   |    4 ++++
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 511ebaf..3e5f356 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -170,10 +170,6 @@ struct stats			runtime_cycles_stats[MAX_NR_CPUS];
 struct stats			runtime_branches_stats[MAX_NR_CPUS];
 struct stats			walltime_nsecs_stats;
 
-#define MATCH_EVENT(t, c, evsel)			\
-	(evsel->attr.type == PERF_TYPE_##t &&	\
-	 evsel->attr.config == PERF_COUNT_##c)
-
 #define ERR_PERF_OPEN \
 "counter %d, sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information."
 
@@ -229,10 +225,10 @@ static int create_perf_stat_counter(struct perf_evsel *evsel, bool *perm_err)
 /*
  * Does the counter have nsecs as a unit?
  */
-static inline int nsec_counter(struct perf_evsel *counter)
+static inline int nsec_counter(struct perf_evsel *evsel)
 {
-	if (MATCH_EVENT(SOFTWARE, SW_CPU_CLOCK, counter) ||
-	    MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
+	if (perf_evsel__match(evsel, SOFTWARE, SW_CPU_CLOCK) ||
+	    perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
 		return 1;
 
 	return 0;
@@ -300,11 +296,11 @@ static void read_counter_aggr(struct perf_evsel *counter)
 	/*
 	 * Save the full runtime - to allow normalization during printout:
 	 */
-	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
+	if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
 		update_stats(&runtime_nsecs_stats[0], count[0]);
-	if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
+	if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
 		update_stats(&runtime_cycles_stats[0], count[0]);
-	if (MATCH_EVENT(HARDWARE, HW_BRANCH_INSTRUCTIONS, counter))
+	if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
 		update_stats(&runtime_branches_stats[0], count[0]);
 }
 
@@ -347,11 +343,11 @@ static void read_counter(struct perf_evsel *counter)
 		cpu_counts[cpu].ena = count[1];
 		cpu_counts[cpu].run = count[2];
 
-		if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter))
+		if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
 			update_stats(&runtime_nsecs_stats[cpu], count[0]);
-		if (MATCH_EVENT(HARDWARE, HW_CPU_CYCLES, counter))
+		if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
 			update_stats(&runtime_cycles_stats[cpu], count[0]);
-		if (MATCH_EVENT(HARDWARE, HW_BRANCH_INSTRUCTIONS, counter))
+		if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
 			update_stats(&runtime_branches_stats[cpu], count[0]);
 	}
 }
@@ -474,7 +470,7 @@ static void print_noise(struct perf_evsel *evsel, double avg)
 			100 * stddev_stats(&ps->res_stats[0]) / avg);
 }
 
-static void nsec_printout(int cpu, struct perf_evsel *counter, double avg)
+static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double msecs = avg / 1e6;
 	char cpustr[16] = { '\0', };
@@ -485,18 +481,17 @@ static void nsec_printout(int cpu, struct perf_evsel *counter, double avg)
 			csv_output ? 0 : -4,
 			cpumap[cpu], csv_sep);
 
-	fprintf(stderr, fmt, cpustr, msecs, csv_sep, event_name(counter));
+	fprintf(stderr, fmt, cpustr, msecs, csv_sep, event_name(evsel));
 
 	if (csv_output)
 		return;
 
-	if (MATCH_EVENT(SOFTWARE, SW_TASK_CLOCK, counter)) {
+	if (perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
 		fprintf(stderr, " # %10.3f CPUs ",
 				avg / avg_stats(&walltime_nsecs_stats));
-	}
 }
 
-static void abs_printout(int cpu, struct perf_evsel *counter, double avg)
+static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double total, ratio = 0.0;
 	char cpustr[16] = { '\0', };
@@ -516,19 +511,19 @@ static void abs_printout(int cpu, struct perf_evsel *counter, double avg)
 	else
 		cpu = 0;
 
-	fprintf(stderr, fmt, cpustr, avg, csv_sep, event_name(counter));
+	fprintf(stderr, fmt, cpustr, avg, csv_sep, event_name(evsel));
 
 	if (csv_output)
 		return;
 
-	if (MATCH_EVENT(HARDWARE, HW_INSTRUCTIONS, counter)) {
+	if (perf_evsel__match(evsel, HARDWARE, HW_INSTRUCTIONS)) {
 		total = avg_stats(&runtime_cycles_stats[cpu]);
 
 		if (total)
 			ratio = avg / total;
 
 		fprintf(stderr, " # %10.3f IPC  ", ratio);
-	} else if (MATCH_EVENT(HARDWARE, HW_BRANCH_MISSES, counter) &&
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
 			runtime_branches_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_branches_stats[cpu]);
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3eb3989..8a5cfb6 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -21,4 +21,8 @@ void perf_evsel__delete(struct perf_evsel *evsel);
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 void perf_evsel__free_fd(struct perf_evsel *evsel);
 
+#define perf_evsel__match(evsel, t, c)		\
+	(evsel->attr.type == PERF_TYPE_##t &&	\
+	 evsel->attr.config == PERF_COUNT_##c)
+
 #endif /* __PERF_EVSEL_H */
-- 
1.6.2.5

