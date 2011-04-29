Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab1D2MrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 08:47:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:60602 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab1D2MrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 08:47:23 -0400
Date: Fri, 29 Apr 2011 12:47:09 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-7y40wib8n003io7hjpn1dsrm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Analyze front-end and back-end stall counts
Git-Commit-ID: d3d1e86da07b4565815e3dbcd082f53017d215f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Apr 2011 12:47:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3d1e86da07b4565815e3dbcd082f53017d215f8
Gitweb:     http://git.kernel.org/tip/d3d1e86da07b4565815e3dbcd082f53017d215f8
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 Apr 2011 13:49:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Apr 2011 14:35:55 +0200

perf stat: Analyze front-end and back-end stall counts

Sample output:

 Performance counter stats for './loop_1b':

        873.691065 task-clock               #    1.000 CPUs utilized
                 1 context-switches         #    0.000 M/sec
                 1 CPU-migrations           #    0.000 M/sec
                96 page-faults              #    0.000 M/sec
     2,012,637,222 cycles                   #    2.304 GHz                      (66.58%)
     1,001,397,911 stalled-cycles-frontend  #   49.76% frontend cycles idle     (66.58%)
         7,523,398 stalled-cycles-backend   #    0.37%  backend cycles idle     (66.76%)
     2,004,551,046 instructions             #    1.00  insns per cycle
                                            #    0.50  stalled cycles per insn  (66.80%)
     1,001,304,992 branches                 # 1146.063 M/sec                    (66.76%)
            39,453 branch-misses            #    0.00% of all branches          (66.64%)

        0.874046121  seconds time elapsed

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n003io7hjpn1dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c      |   41 ++++++++++++++++++++++++++++++++++-----
 tools/perf/util/parse-events.c |    7 +++--
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 6a4a8a3..e454499 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -201,7 +201,8 @@ static double stddev_stats(struct stats *stats)
 
 struct stats			runtime_nsecs_stats[MAX_NR_CPUS];
 struct stats			runtime_cycles_stats[MAX_NR_CPUS];
-struct stats			runtime_stalled_cycles_stats[MAX_NR_CPUS];
+struct stats			runtime_stalled_cycles_front_stats[MAX_NR_CPUS];
+struct stats			runtime_stalled_cycles_back_stats[MAX_NR_CPUS];
 struct stats			runtime_branches_stats[MAX_NR_CPUS];
 struct stats			runtime_cacherefs_stats[MAX_NR_CPUS];
 struct stats			runtime_l1_dcache_stats[MAX_NR_CPUS];
@@ -251,8 +252,10 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 		update_stats(&runtime_nsecs_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
 		update_stats(&runtime_cycles_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_FRONTEND))
+		update_stats(&runtime_stalled_cycles_front_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_BACKEND))
-		update_stats(&runtime_stalled_cycles_stats[0], count[0]);
+		update_stats(&runtime_stalled_cycles_back_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
 		update_stats(&runtime_branches_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_CACHE_REFERENCES))
@@ -478,7 +481,30 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 		fprintf(stderr, " # %8.3f CPUs utilized          ", avg / avg_stats(&walltime_nsecs_stats));
 }
 
-static void print_stalled_cycles(int cpu, struct perf_evsel *evsel __used, double avg)
+static void print_stalled_cycles_frontend(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_cycles_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 75.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 50.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 20.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #   ");
+	color_fprintf(stderr, color, "%5.2f%%", ratio);
+	fprintf(stderr, " frontend cycles idle   ");
+}
+
+static void print_stalled_cycles_backend(int cpu, struct perf_evsel *evsel __used, double avg)
 {
 	double total, ratio = 0.0;
 	const char *color;
@@ -498,7 +524,7 @@ static void print_stalled_cycles(int cpu, struct perf_evsel *evsel __used, doubl
 
 	fprintf(stderr, " #   ");
 	color_fprintf(stderr, color, "%5.2f%%", ratio);
-	fprintf(stderr, " of all cycles are idle ");
+	fprintf(stderr, "  backend cycles idle   ");
 }
 
 static void print_branch_misses(int cpu, struct perf_evsel *evsel __used, double avg)
@@ -583,7 +609,8 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 		fprintf(stderr, " #    %4.2f  insns per cycle        ", ratio);
 
-		total = avg_stats(&runtime_stalled_cycles_stats[cpu]);
+		total = avg_stats(&runtime_stalled_cycles_front_stats[cpu]);
+		total = max(total, avg_stats(&runtime_stalled_cycles_back_stats[cpu]));
 
 		if (total && avg) {
 			ratio = total / avg;
@@ -609,8 +636,10 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 		fprintf(stderr, " # %8.3f %% of all cache refs    ", ratio);
 
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES_FRONTEND)) {
+		print_stalled_cycles_frontend(cpu, evsel, avg);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES_BACKEND)) {
-		print_stalled_cycles(cpu, evsel, avg);
+		print_stalled_cycles_backend(cpu, evsel, avg);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CPU_CYCLES)) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 04d2f0a..8a407f3 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -60,7 +60,7 @@ static struct event_symbol event_symbols[] = {
 #define PERF_EVENT_TYPE(config)		__PERF_EVENT_FIELD(config, TYPE)
 #define PERF_EVENT_ID(config)		__PERF_EVENT_FIELD(config, EVENT)
 
-static const char *hw_event_names[] = {
+static const char *hw_event_names[PERF_COUNT_HW_MAX] = {
 	"cycles",
 	"instructions",
 	"cache-references",
@@ -68,10 +68,11 @@ static const char *hw_event_names[] = {
 	"branches",
 	"branch-misses",
 	"bus-cycles",
-	"stalled-cycles",
+	"stalled-cycles-frontend",
+	"stalled-cycles-backend",
 };
 
-static const char *sw_event_names[] = {
+static const char *sw_event_names[PERF_COUNT_SW_MAX] = {
 	"cpu-clock",
 	"task-clock",
 	"page-faults",
