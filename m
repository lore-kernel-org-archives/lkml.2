Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab1ESNt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:49:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:53044 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab1ESNt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:49:57 -0400
Date: Thu, 19 May 2011 13:49:26 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-lkhwxsevdbd9a8nymx0vxc3y@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Add more cache-miss percentage printouts
Git-Commit-ID: c3305257cd4df63e03e21e331a0140ae9c0faccc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 May 2011 13:49:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3305257cd4df63e03e21e331a0140ae9c0faccc
Gitweb:     http://git.kernel.org/tip/c3305257cd4df63e03e21e331a0140ae9c0faccc
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 19 May 2011 14:01:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 May 2011 14:30:50 +0200

perf stat: Add more cache-miss percentage printouts

Print out the cache-miss percentage as well if the cache refs were
collected, for all the generic cache event types.

Before:

   11,103,723,230 dTLB-loads                #  622.471 M/sec                    ( +-  0.30% )
       87,065,337 dTLB-load-misses          #    4.881 M/sec                    ( +-  0.90% )

After:

   11,353,713,242 dTLB-loads                #  626.020 M/sec                    ( +-  0.35% )
      113,393,472 dTLB-load-misses          #    1.00% of all dTLB cache hits   ( +-  0.49% )

Also ASCII color highlight too high percentages, them when it's executed on the console.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-lkhwxsevdbd9a8nymx0vxc3y@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |  138 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a89fc08..a9f0671 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -261,6 +261,10 @@ struct stats			runtime_stalled_cycles_back_stats[MAX_NR_CPUS];
 struct stats			runtime_branches_stats[MAX_NR_CPUS];
 struct stats			runtime_cacherefs_stats[MAX_NR_CPUS];
 struct stats			runtime_l1_dcache_stats[MAX_NR_CPUS];
+struct stats			runtime_l1_icache_stats[MAX_NR_CPUS];
+struct stats			runtime_ll_cache_stats[MAX_NR_CPUS];
+struct stats			runtime_itlb_cache_stats[MAX_NR_CPUS];
+struct stats			runtime_dtlb_cache_stats[MAX_NR_CPUS];
 struct stats			walltime_nsecs_stats;
 
 static int create_perf_stat_counter(struct perf_evsel *evsel)
@@ -317,6 +321,14 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 		update_stats(&runtime_cacherefs_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_L1D))
 		update_stats(&runtime_l1_dcache_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_L1I))
+		update_stats(&runtime_l1_icache_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_LL))
+		update_stats(&runtime_ll_cache_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_DTLB))
+		update_stats(&runtime_dtlb_cache_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_ITLB))
+		update_stats(&runtime_itlb_cache_stats[0], count[0]);
 }
 
 /*
@@ -630,6 +642,98 @@ static void print_l1_dcache_misses(int cpu, struct perf_evsel *evsel __used, dou
 	fprintf(stderr, " of all L1-dcache hits  ");
 }
 
+static void print_l1_icache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_l1_icache_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 20.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " of all L1-icache hits  ");
+}
+
+static void print_dtlb_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_dtlb_cache_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 20.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " of all dTLB cache hits ");
+}
+
+static void print_itlb_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_itlb_cache_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 20.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " of all iTLB cache hits ");
+}
+
+static void print_ll_cache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_ll_cache_stats[cpu]);
+
+	if (total)
+		ratio = avg / total * 100.0;
+
+	color = PERF_COLOR_NORMAL;
+	if (ratio > 20.0)
+		color = PERF_COLOR_RED;
+	else if (ratio > 10.0)
+		color = PERF_COLOR_MAGENTA;
+	else if (ratio > 5.0)
+		color = PERF_COLOR_YELLOW;
+
+	fprintf(stderr, " #  ");
+	color_fprintf(stderr, color, "%6.2f%%", ratio);
+	fprintf(stderr, " of all LL-cache hits   ");
+}
+
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double total, ratio = 0.0;
@@ -684,6 +788,34 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
 			runtime_l1_dcache_stats[cpu].n != 0) {
 		print_l1_dcache_misses(cpu, evsel, avg);
+	} else if (
+		evsel->attr.type == PERF_TYPE_HW_CACHE &&
+		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_L1I |
+					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
+					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
+			runtime_l1_icache_stats[cpu].n != 0) {
+		print_l1_icache_misses(cpu, evsel, avg);
+	} else if (
+		evsel->attr.type == PERF_TYPE_HW_CACHE &&
+		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_DTLB |
+					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
+					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
+			runtime_dtlb_cache_stats[cpu].n != 0) {
+		print_dtlb_cache_misses(cpu, evsel, avg);
+	} else if (
+		evsel->attr.type == PERF_TYPE_HW_CACHE &&
+		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_ITLB |
+					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
+					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
+			runtime_itlb_cache_stats[cpu].n != 0) {
+		print_itlb_cache_misses(cpu, evsel, avg);
+	} else if (
+		evsel->attr.type == PERF_TYPE_HW_CACHE &&
+		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_LL |
+					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
+					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
+			runtime_ll_cache_stats[cpu].n != 0) {
+		print_ll_cache_misses(cpu, evsel, avg);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CACHE_MISSES) &&
 			runtime_cacherefs_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_cacherefs_stats[cpu]);
@@ -842,10 +974,12 @@ static void print_stat(int argc, const char **argv)
 	}
 
 	if (!csv_output) {
-		fprintf(stderr, "\n");
-		fprintf(stderr, " %18.9f  seconds time elapsed",
+		if (!null_run)
+			fprintf(stderr, "\n");
+		fprintf(stderr, " %17.9f seconds time elapsed",
 				avg_stats(&walltime_nsecs_stats)/1e9);
 		if (run_count > 1) {
+			fprintf(stderr, "                                        ");
 			print_noise_pct(stddev_stats(&walltime_nsecs_stats),
 					avg_stats(&walltime_nsecs_stats));
 		}
