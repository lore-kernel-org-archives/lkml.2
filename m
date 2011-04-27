Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527Ab1D0QCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:02:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:59535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759364Ab1D0QCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:02:05 -0400
Date: Wed, 27 Apr 2011 16:01:52 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-uapziqny39601apdmmhoz7hk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Add stalled cycles accounting, prettify the resulting output
Git-Commit-ID: 481f988a016f7a0327a5537bde4794349fc4625c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:01:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  481f988a016f7a0327a5537bde4794349fc4625c
Gitweb:     http://git.kernel.org/tip/481f988a016f7a0327a5537bde4794349fc4625c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 04:34:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:56 +0200

perf stat: Add stalled cycles accounting, prettify the resulting output

Add stalled cycles accounting and use it to print the "cycles stalled per
instruction" value.

Also change the unit of the cycles output from M/sec to GHz - this is more
intuitive.

Prettify the output to:

 Performance counter stats for './loop_1b_instructions':

        239.775036 task-clock               #    0.997 CPUs utilized
       761,903,912 cycles                   #    3.178 GHz
       356,620,620 stalled-cycles           #   46.81% of all cycles are idle
     1,001,578,351 instructions             #    1.31  insns per cycle
                                            #    0.36  stalled cycles per insn
            14,782 cache-references         #    0.062 M/sec
             5,694 cache-misses             #   38.520 % of all cache refs

        0.240493656  seconds time elapsed

Also adjust the --repeat output to make the percentages align vertically:

 Performance counter stats for './loop_1b_instructions' (10 runs):

        236.096793 task-clock               #    0.997 CPUs utilized             ( +-   0.011% )
       756,553,086 cycles                   #    3.204 GHz                       ( +-   0.002% )
       354,942,692 stalled-cycles           #   46.92% of all cycles are idle    ( +-   0.008% )
     1,001,389,700 instructions             #    1.32  insns per cycle
                                            #    0.35  stalled cycles per insn   ( +-   0.000% )
            10,166 cache-references         #    0.043 M/sec                     ( +-   0.742% )
               468 cache-misses             #    4.608 % of all cache refs       ( +-  13.385% )

        0.236874136  seconds time elapsed   ( +- 0.01% )

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-uapziqny39601apdmmhoz7hk@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |   43 ++++++++++++++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e5e82f6..e881c20 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -156,6 +156,7 @@ static double stddev_stats(struct stats *stats)
 
 struct stats			runtime_nsecs_stats[MAX_NR_CPUS];
 struct stats			runtime_cycles_stats[MAX_NR_CPUS];
+struct stats			runtime_stalled_cycles_stats[MAX_NR_CPUS];
 struct stats			runtime_branches_stats[MAX_NR_CPUS];
 struct stats			runtime_cacherefs_stats[MAX_NR_CPUS];
 struct stats			walltime_nsecs_stats;
@@ -204,6 +205,8 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 		update_stats(&runtime_nsecs_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
 		update_stats(&runtime_cycles_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES))
+		update_stats(&runtime_stalled_cycles_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
 		update_stats(&runtime_branches_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_CACHE_REFERENCES))
@@ -412,8 +415,7 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 		return;
 
 	if (perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
-		fprintf(stderr, " # %10.3f CPUs",
-				avg / avg_stats(&walltime_nsecs_stats));
+		fprintf(stderr, " # %8.3f CPUs utilized          ", avg / avg_stats(&walltime_nsecs_stats));
 }
 
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
@@ -450,7 +452,15 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg / total;
 
-		fprintf(stderr, " # ( %4.2f instructions per cycle )", ratio);
+		fprintf(stderr, " #    %4.2f  insns per cycle", ratio);
+
+		total = avg_stats(&runtime_stalled_cycles_stats[cpu]);
+
+		if (total && avg) {
+			ratio = total / avg;
+			fprintf(stderr, "\n                                            #    %4.2f  stalled cycles per insn", ratio);
+		}
+
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
 			runtime_branches_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_branches_stats[cpu]);
@@ -458,7 +468,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg * 100 / total;
 
-		fprintf(stderr, " # %10.3f %%", ratio);
+		fprintf(stderr, " # %8.3f %% of all branches", ratio);
 
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CACHE_MISSES) &&
 			runtime_cacherefs_stats[cpu].n != 0) {
@@ -467,22 +477,29 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		if (total)
 			ratio = avg * 100 / total;
 
-		fprintf(stderr, " # %10.3f %%", ratio);
+		fprintf(stderr, " # %8.3f %% of all cache refs    ", ratio);
 
-	} else if (runtime_nsecs_stats[cpu].n != 0) {
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES)) {
+		total = avg_stats(&runtime_cycles_stats[cpu]);
+
+		if (total)
+			ratio = avg / total * 100.0;
+
+		fprintf(stderr, " #   %5.2f%% of all cycles are idle ", ratio);
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_CPU_CYCLES)) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
 		if (total)
-			ratio = 1000.0 * avg / total;
+			ratio = 1.0 * avg / total;
 
-		fprintf(stderr, " # %10.3f M/sec", ratio);
-	} else if (perf_evsel__match(evsel, HARDWARE, HW_STALLED_CYCLES)) {
-		total = avg_stats(&runtime_cycles_stats[cpu]);
+		fprintf(stderr, " # %8.3f GHz                    ", ratio);
+	} else if (runtime_nsecs_stats[cpu].n != 0) {
+		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
 		if (total)
-			ratio = avg / total * 100.0;
+			ratio = 1000.0 * avg / total;
 
-		fprintf(stderr, " # (%5.2f%% of all cycles )", ratio);
+		fprintf(stderr, " # %8.3f M/sec                  ", ratio);
 	}
 }
 
@@ -619,7 +636,7 @@ static void print_stat(int argc, const char **argv)
 		fprintf(stderr, " %18.9f  seconds time elapsed",
 				avg_stats(&walltime_nsecs_stats)/1e9);
 		if (run_count > 1) {
-			fprintf(stderr, "   ( +- %7.3f%% )",
+			fprintf(stderr, "   ( +-%5.2f%% )",
 				100*stddev_stats(&walltime_nsecs_stats) /
 				avg_stats(&walltime_nsecs_stats));
 		}
