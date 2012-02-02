Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2BBBph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:45:37 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37475 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab2BBBnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:43:22 -0500
Subject: [RFC PATCH 08/14] sched: normalize tg load contributions against
	runnable time
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 17:38:26 -0800
Message-ID: <20120202013826.20844.39042.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Entities of equal weight should receive equitable distribution of cpu time.
This is challenging in the case of a task_group's shares as execution may be
occurring on multiple cpus simultaneously.

To handle this we divide up the shares into weights proportionate with the load
on each cfs_rq.  This does not however, account for the fact that the sum of
the parts may be less than one cpu and so we need to normalize:
  load(tg) = min(runnable_avg(tg), 1) * tg->shares
Where runnable_avg is the aggregate time in which the task_group had runnable
children.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Ben Segall <bsegall@google.com>.
---
 kernel/sched/debug.c |    4 ++++
 kernel/sched/fair.c  |   34 ++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |    2 ++
 3 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index f6227c0..8d87796 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -232,6 +232,10 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			atomic64_read(&cfs_rq->tg->load_avg));
 	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
+	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
+			cfs_rq->tg_runnable_contrib);
+	SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
+			atomic_read(&cfs_rq->tg->runnable_avg));
 #endif
 
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6d8af5e..803c622 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1103,13 +1103,45 @@ static inline void __update_task_entity_contrib(struct sched_entity *se)
 					     se->avg.runnable_avg_period + 1);
 }
 
+/*
+ * Aggregate cfs_rq runnable averages into an equivalent task_group
+ * representation for computing load contributions.
+ */
+static inline void __update_tg_runnable_avg(struct sched_avg *sa,
+						  struct cfs_rq *cfs_rq)
+{
+	struct task_group *tg = cfs_rq->tg;
+	long contrib;
+
+	contrib = (sa->runnable_avg_sum << 12) / (sa->runnable_avg_period + 1);
+	contrib -= cfs_rq->tg_runnable_contrib;
+
+	if (abs(contrib) > cfs_rq->tg_runnable_contrib/64) {
+		atomic_add(contrib, &tg->runnable_avg);
+		cfs_rq->tg_runnable_contrib += contrib;
+	}
+}
+
 static inline void __update_group_entity_contrib(struct sched_entity *se)
 {
 	struct cfs_rq *cfs_rq = group_cfs_rq(se);
 	struct task_group *tg = cfs_rq->tg;
+	int runnable_avg;
 
 	se->avg.load_avg_contrib = (cfs_rq->tg_load_contrib * tg->shares);
 	se->avg.load_avg_contrib /= atomic64_read(&tg->load_avg) + 1;
+
+	/*
+	 * Unlike a task-entity, a group entity may be using >=1 cpu globally.
+	 * However, in the case that it's using <1 cpu we need to form a
+	 * correction term so that we contribute the same load as a task of
+	 * equal weight. (Global runnable time is taken as a fraction over 2^12.)
+	 */
+	runnable_avg = atomic_read(&tg->runnable_avg);
+	if (runnable_avg < (1<<12)) {
+		se->avg.load_avg_contrib *= runnable_avg;
+		se->avg.load_avg_contrib /= (1<<12);
+	}
 }
 
 /* Compute the current contribution to load_avg by se, return any delta */
@@ -1122,6 +1154,7 @@ static long __update_entity_load_avg_contrib(struct sched_entity *se)
 	} else {
 		if (!se->on_rq)
 			__synchronize_entity_decay(se);
+		__update_tg_runnable_avg(&se->avg, group_cfs_rq(se));
 		__update_group_entity_contrib(se);
 	}
 
@@ -1205,6 +1238,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
 	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
+	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
 }
 
 /* Add the load generated by se into cfs_rq's child load-average */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 17f99e7..57cc227 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -117,6 +117,7 @@ struct task_group {
 
 	atomic_t load_weight;
 	atomic64_t load_avg;
+	atomic_t runnable_avg;
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -272,6 +273,7 @@ struct cfs_rq {
 
 	unsigned long load_contribution;
 
+	u32 tg_runnable_contrib;
 	u64 runnable_load_avg, blocked_load_avg;
 	u64 tg_load_contrib;
 	atomic64_t decay_counter, removed_load;


