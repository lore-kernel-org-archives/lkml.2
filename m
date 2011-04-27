Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521Ab1D0QBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:01:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:59516 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759430Ab1D0QBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:01:45 -0400
Date: Wed, 27 Apr 2011 16:01:29 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-9uc55z3g88r47exde7zxjm6p@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Factor our shadow stats
Git-Commit-ID: dcd9936a5a6d89512b5323c1145647f2dbe0236f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:01:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dcd9936a5a6d89512b5323c1145647f2dbe0236f
Gitweb:     http://git.kernel.org/tip/dcd9936a5a6d89512b5323c1145647f2dbe0236f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 04:36:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:56 +0200

perf stat: Factor our shadow stats

Create update_shadow_stats() which is then used in both read_counter_aggr()
and read_counter().

This not only simplifies the code but also fixes a bug: HW_CACHE_REFERENCES
was not updated in read_counter().

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-9uc55z3g88r47exde7zxjm6p@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 0de3a20..e5e82f6 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -194,6 +194,23 @@ static inline int nsec_counter(struct perf_evsel *evsel)
 }
 
 /*
+ * Update various tracking values we maintain to print
+ * more semantic information such as miss/hit ratios,
+ * instruction rates, etc:
+ */
+static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
+{
+	if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
+		update_stats(&runtime_nsecs_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
+		update_stats(&runtime_cycles_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
+		update_stats(&runtime_branches_stats[0], count[0]);
+	else if (perf_evsel__match(counter, HARDWARE, HW_CACHE_REFERENCES))
+		update_stats(&runtime_cacherefs_stats[0], count[0]);
+}
+
+/*
  * Read out the results of a single counter:
  * aggregate counts across CPUs in system-wide mode
  */
@@ -218,14 +235,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	/*
 	 * Save the full runtime - to allow normalization during printout:
 	 */
-	if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
-		update_stats(&runtime_nsecs_stats[0], count[0]);
-	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
-		update_stats(&runtime_cycles_stats[0], count[0]);
-	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
-		update_stats(&runtime_branches_stats[0], count[0]);
-	else if (perf_evsel__match(counter, HARDWARE, HW_CACHE_REFERENCES))
-		update_stats(&runtime_cacherefs_stats[0], count[0]);
+	update_shadow_stats(counter, count);
 
 	return 0;
 }
@@ -245,12 +255,7 @@ static int read_counter(struct perf_evsel *counter)
 
 		count = counter->counts->cpu[cpu].values;
 
-		if (perf_evsel__match(counter, SOFTWARE, SW_TASK_CLOCK))
-			update_stats(&runtime_nsecs_stats[cpu], count[0]);
-		if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
-			update_stats(&runtime_cycles_stats[cpu], count[0]);
-		if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
-			update_stats(&runtime_branches_stats[cpu], count[0]);
+		update_shadow_stats(counter, count);
 	}
 
 	return 0;
