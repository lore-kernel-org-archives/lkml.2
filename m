Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab1D0QAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:00:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:59387 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab1D0QAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:00:07 -0400
Date: Wed, 27 Apr 2011 15:59:47 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-axm28f43x439bl41zkvfzd63@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Print cache misses as percentage
Git-Commit-ID: d58f4c82fed69fdd4a79fa54fe17fd14d98c27aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 15:59:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d58f4c82fed69fdd4a79fa54fe17fd14d98c27aa
Gitweb:     http://git.kernel.org/tip/d58f4c82fed69fdd4a79fa54fe17fd14d98c27aa
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 03:42:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:54 +0200

perf stat: Print cache misses as percentage

Before:

       113,393,041 cache-references         #     83.636 M/sec
         7,052,454 cache-misses             #      5.202 M/sec

After:

       112,589,441 cache-references         #     87.925 M/sec
         6,556,354 cache-misses             #      5.823 %

misses/hits percentages are more expressive than absolute numbers
or rates.

(Also prettify the CPUs printout line to not have a trailing whitespace.)

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-axm28f43x439bl41zkvfzd63@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3a29041..0de3a20 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -157,6 +157,7 @@ static double stddev_stats(struct stats *stats)
 struct stats			runtime_nsecs_stats[MAX_NR_CPUS];
 struct stats			runtime_cycles_stats[MAX_NR_CPUS];
 struct stats			runtime_branches_stats[MAX_NR_CPUS];
+struct stats			runtime_cacherefs_stats[MAX_NR_CPUS];
 struct stats			walltime_nsecs_stats;
 
 static int create_perf_stat_counter(struct perf_evsel *evsel)
@@ -219,10 +220,12 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	 */
 	if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
 		update_stats(&runtime_nsecs_stats[0], count[0]);
-	if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
+	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
 		update_stats(&runtime_cycles_stats[0], count[0]);
-	if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
+	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
 		update_stats(&runtime_branches_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_CACHE_REFERENCES))
+		update_stats(&runtime_cacherefs_stats[0], count[0]);
 
 	return 0;
 }
@@ -404,7 +407,7 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 		return;
 
 	if (perf_evsel__match(evsel, SOFTWARE, SW_TASK_CLOCK))
-		fprintf(stderr, " # %10.3f CPUs ",
+		fprintf(stderr, " # %10.3f CPUs",
 				avg / avg_stats(&walltime_nsecs_stats));
 }
 
@@ -452,6 +455,15 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 
 		fprintf(stderr, " # %10.3f %%", ratio);
 
+	} else if (perf_evsel__match(evsel, HARDWARE, HW_CACHE_MISSES) &&
+			runtime_cacherefs_stats[cpu].n != 0) {
+		total = avg_stats(&runtime_cacherefs_stats[cpu]);
+
+		if (total)
+			ratio = avg * 100 / total;
+
+		fprintf(stderr, " # %10.3f %%", ratio);
+
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
