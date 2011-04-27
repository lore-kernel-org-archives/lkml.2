Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab1D0QEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:04:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:59626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759502Ab1D0QEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:04:35 -0400
Date: Wed, 27 Apr 2011 16:04:11 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-cxs98quixs3qyvdqx3goojc4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Add -d/--detailed flag to run with a lot of events
Git-Commit-ID: c6264deff7ea6125492b442edad885e5429679af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:04:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6264deff7ea6125492b442edad885e5429679af
Gitweb:     http://git.kernel.org/tip/c6264deff7ea6125492b442edad885e5429679af
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 13:50:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 21:03:16 +0200

perf stat: Add -d/--detailed flag to run with a lot of events

Add the new -d/--detailed flag, which generates a pretty detailed event list:

 Performance counter stats for './hackbench 10' (10 runs):

       1514.287888 task-clock               #   10.897 CPUs utilized            ( +-  3.05% )
            39,698 context-switches         #    0.026 M/sec                    ( +- 12.19% )
             8,147 CPU-migrations           #    0.005 M/sec                    ( +- 16.55% )
            17,918 page-faults              #    0.012 M/sec                    ( +-  0.37% )
     2,944,504,050 cycles                   #    1.944 GHz                      ( +-  3.89% )  (32.60%)
     1,043,971,283 stalled-cycles           #   35.45% of all cycles are idle   ( +-  5.22% )  (44.48%)
     1,655,906,768 instructions             #    0.56  insns per cycle
                                            #    0.63  stalled cycles per insn  ( +-  1.95% )  (55.09%)
       338,832,373 branches                 #  223.757 M/sec                    ( +-  1.96% )  (64.47%)
         3,892,416 branch-misses            #    1.15% of all branches          ( +-  5.49% )  (73.12%)
       606,410,482 L1-dcache-loads          #  400.459 M/sec                    ( +-  1.29% )  (71.21%)
        31,204,395 L1-dcache-load-misses    #    5.15% of all L1-dcache hits    ( +-  3.04% )  (60.43%)
         3,922,751 LLC-loads                #    2.590 M/sec                    ( +-  6.80% )  (46.87%)
         5,037,288 LLC-load-misses          #    3.327 M/sec                    ( +-  3.56% )  (13.00%)

        0.138966828  seconds time elapsed  ( +-  4.11% )

This can be used "at a glance" for narrower analysis.

-d can also be used in addition to other -e events, to further expand an event list.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-cxs98quixs3qyvdqx3goojc4@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |   68 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 03bac6a..6959fde 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -73,6 +73,47 @@ static struct perf_event_attr default_attrs[] = {
 
 };
 
+/*
+ * Detailed stats:
+ */
+static struct perf_event_attr detailed_attrs[] = {
+
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK		},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES	},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CPU_MIGRATIONS		},
+  { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_PAGE_FAULTS		},
+
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_CPU_CYCLES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_STALLED_CYCLES		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_INSTRUCTIONS		},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_INSTRUCTIONS	},
+  { .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_BRANCH_MISSES		},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_L1D		<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_LL			<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_ACCESS	<< 16)				},
+
+  { .type = PERF_TYPE_HW_CACHE,
+    .config =
+	 PERF_COUNT_HW_CACHE_LL			<<  0  |
+	(PERF_COUNT_HW_CACHE_OP_READ		<<  8) |
+	(PERF_COUNT_HW_CACHE_RESULT_MISS	<< 16)				},
+};
+
 struct perf_evlist		*evsel_list;
 
 static bool			system_wide			=  false;
@@ -86,6 +127,7 @@ static pid_t			target_pid			= -1;
 static pid_t			target_tid			= -1;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
+static bool			detailed_run			=  false;
 static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
 static const char		*cpu_list;
@@ -550,7 +592,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_L1D |
 					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
 					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
-			runtime_branches_stats[cpu].n != 0) {
+			runtime_l1_dcache_stats[cpu].n != 0) {
 		print_l1_dcache_misses(cpu, evsel, avg);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CACHE_MISSES) &&
 			runtime_cacherefs_stats[cpu].n != 0) {
@@ -625,8 +667,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 		avg_enabled = avg_stats(&ps->res_stats[1]);
 		avg_running = avg_stats(&ps->res_stats[2]);
 
-		fprintf(stderr, "  (scaled from %.2f%%)",
-				100 * avg_running / avg_enabled);
+		fprintf(stderr, "  (%.2f%%)", 100 * avg_running / avg_enabled);
 	}
 	fprintf(stderr, "\n");
 }
@@ -668,10 +709,8 @@ static void print_counter(struct perf_evsel *counter)
 		if (!csv_output) {
 			print_noise(counter, 1.0);
 
-			if (run != ena) {
-				fprintf(stderr, "  (scaled from %.2f%%)",
-					100.0 * run / ena);
-			}
+			if (run != ena)
+				fprintf(stderr, "  (%.2f%%)", 100.0 * run / ena);
 		}
 		fputc('\n', stderr);
 	}
@@ -778,6 +817,8 @@ static const struct option options[] = {
 		    "repeat command and print average + stddev (max: 100)"),
 	OPT_BOOLEAN('n', "null", &null_run,
 		    "null run - dont start any counters"),
+	OPT_BOOLEAN('d', "detailed", &detailed_run,
+		    "detailed run - start a lot of events"),
 	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
 			   "print large numbers with thousands\' separators",
 			   stat__set_big_num),
@@ -839,7 +880,18 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	}
 
 	/* Set attrs and nr_counters if no event is selected and !null_run */
-	if (!null_run && !evsel_list->nr_entries) {
+	if (detailed_run) {
+		size_t c;
+
+		for (c = 0; c < ARRAY_SIZE(detailed_attrs); ++c) {
+			pos = perf_evsel__new(&detailed_attrs[c], c);
+			if (pos == NULL)
+				goto out;
+			perf_evlist__add(evsel_list, pos);
+		}
+	}
+	/* Set attrs and nr_counters if no event is selected and !null_run */
+	if (!detailed_run && !null_run && !evsel_list->nr_entries) {
 		size_t c;
 
 		for (c = 0; c < ARRAY_SIZE(default_attrs); ++c) {
