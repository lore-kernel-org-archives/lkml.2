Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab1D0QEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:04:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:59603 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759364Ab1D0QD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:03:58 -0400
Date: Wed, 27 Apr 2011 16:03:45 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-54gmz0zymaid84zcs7joq02p@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Print out miss/hit ratio for L1 data-cache events
Git-Commit-ID: 8bb6c79f24e66538f606076915e918242c02ec7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:03:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bb6c79f24e66538f606076915e918242c02ec7c
Gitweb:     http://git.kernel.org/tip/8bb6c79f24e66538f606076915e918242c02ec7c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 13:25:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:32:24 +0200

perf stat: Print out miss/hit ratio for L1 data-cache events

Print out this kind of l1-dcache-misses percentage:

 Performance counter stats for './bw_tcp localhost':

    29,956,262,201 cycles                   #    3.002 GHz                      (scaled from 85.14%)
     8,255,209,558 stalled-cycles           #   27.56% of all cycles are idle   (scaled from 86.56%)
     1,206,130,308 l1-dcache-misses         #   40.49% of all L1-dcache hits    (scaled from 86.30%)
     2,978,756,779 l1-dcache-refs           #  298.512 M/sec                    (scaled from 70.02%)
     8,861,956,159 instructions             #    0.30  insns per cycle
                                            #    0.93  stalled cycles per insn  (scaled from 84.27%)
     1,644,306,068 branches                 #  164.782 M/sec                    (scaled from 86.43%)
        74,778,443 branch-misses            #    4.55% of all branches          (scaled from 70.69%)
       9978.695711 task-clock               #    0.693 CPUs utilized

       14.404347983  seconds time elapsed

And color the result depending on the severity of cache-trashing.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-54gmz0zymaid84zcs7joq02p@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5d4e1b9..03bac6a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -159,6 +159,7 @@ struct stats			runtime_cycles_stats[MAX_NR_CPUS];
 struct stats			runtime_stalled_cycles_stats[MAX_NR_CPUS];
 struct stats			runtime_branches_stats[MAX_NR_CPUS];
 struct stats			runtime_cacherefs_stats[MAX_NR_CPUS];
+struct stats			runtime_l1_dcache_stats[MAX_NR_CPUS];
 struct stats			walltime_nsecs_stats;
 
 static int create_perf_stat_counter(struct perf_evsel *evsel)
@@ -211,6 +212,8 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 		update_stats(&runtime_branches_stats[0], count[0]);
 	else if (perf_evsel__match(counter, HARDWARE, HW_CACHE_REFERENCES))
 		update_stats(&runtime_cacherefs_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HW_CACHE, HW_CACHE_L1D))
+		update_stats(&runtime_l1_dcache_stats[0], count[0]);
 }
 
 /*
@@ -473,6 +476,29 @@ static void print_branch_misses(int cpu, struct perf_evsel *evsel __used, double
 	fprintf(stderr, " of all branches        ");
 }
 
+static void print_l1_dcache_misses(int cpu, struct perf_evsel *evsel __used, double avg)
+{
+	double total, ratio = 0.0;
+	const char *color;
+
+	total = avg_stats(&runtime_l1_dcache_stats[cpu]);
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
+	fprintf(stderr, " #   ");
+	color_fprintf(stderr, color, "%5.2f%%", ratio);
+	fprintf(stderr, " of all L1-dcache hits  ");
+}
+
 static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 {
 	double total, ratio = 0.0;
@@ -519,6 +545,13 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_BRANCH_MISSES) &&
 			runtime_branches_stats[cpu].n != 0) {
 		print_branch_misses(cpu, evsel, avg);
+	} else if (
+		evsel->attr.type == PERF_TYPE_HW_CACHE &&
+		evsel->attr.config ==  ( PERF_COUNT_HW_CACHE_L1D |
+					((PERF_COUNT_HW_CACHE_OP_READ) << 8) |
+					((PERF_COUNT_HW_CACHE_RESULT_MISS) << 16)) &&
+			runtime_branches_stats[cpu].n != 0) {
+		print_l1_dcache_misses(cpu, evsel, avg);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CACHE_MISSES) &&
 			runtime_cacherefs_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_cacherefs_stats[cpu]);
