Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab2HWOPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:15:44 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62202 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab2HWOPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:15:31 -0400
Message-Id: <20120823141506.930124292@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 07:14:31 -0700
From: pjt@google.com
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [patch 09/16] sched: normalize tg load contributions against runnable time
References: <20120823141422.444396696@google.com>
Content-Disposition: inline; filename=sched-normalize_runnable_shares.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

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
Reviewed-by: Ben Segall <bsegall@google.com>.
---
 kernel/sched/debug.c |    4 ++++
 kernel/sched/fair.c  |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |    2 ++
 3 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2908923..71b0ea3 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -234,6 +234,10 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
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
index 92ef5f1..47a7998 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1112,19 +1112,73 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 	}
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
+	/* The fraction of a cpu used by this cfs_rq */
+	contrib = div_u64(sa->runnable_avg_sum << NICE_0_SHIFT,
+			  sa->runnable_avg_period + 1);
+	contrib -= cfs_rq->tg_runnable_contrib;
+
+	if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
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
+
 	u64 contrib;
 
 	contrib = cfs_rq->tg_load_contrib * tg->shares;
 	se->avg.load_avg_contrib = div64_u64(contrib,
 					     atomic64_read(&tg->load_avg) + 1);
+
+	/*
+	 * For group entities we need to compute a correction term in the case
+	 * that they are consuming <1 cpu so that we would contribute the same
+	 * load as a task of equal weight.
+	 *
+	 * Explicitly co-ordinating this measurement would be expensive, but
+	 * fortunately the sum of each cpus contribution forms a usable
+	 * lower-bound on the true value.
+	 *
+	 * Consider the aggregate of 2 contributions.  Either they are disjoint
+	 * (and the sum represents true value) or they are disjoint and we are
+	 * understating by the aggregate of their overlap.
+	 *
+	 * Extending this to N cpus, for a given overlap, the maximum amount we
+	 * understand is then n_i(n_i+1)/2 * w_i where n_i is the number of
+	 * cpus that overlap for this interval and w_i is the interval width.
+	 *
+	 * On a small machine; the first term is well-bounded which bounds the
+	 * total error since w_i is a subset of the period.  Whereas on a
+	 * larger machine, while this first term can be larger, if w_i is the
+	 * of consequential size guaranteed to see n_i*w_i quickly converge to
+	 * our upper bound of 1-cpu.
+	 */
+	runnable_avg = atomic_read(&tg->runnable_avg);
+	if (runnable_avg < NICE_0_LOAD) {
+		se->avg.load_avg_contrib *= runnable_avg;
+		se->avg.load_avg_contrib >>= NICE_0_SHIFT;
+	}
 }
 #else
 static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 						 int force_update) {}
+static inline void __update_tg_runnable_avg(struct sched_avg *sa,
+						  struct cfs_rq *cfs_rq) {}
 static inline void __update_group_entity_contrib(struct sched_entity *se) {}
 #endif
 
@@ -1146,6 +1200,7 @@ static long __update_entity_load_avg_contrib(struct sched_entity *se)
 	if (entity_is_task(se)) {
 		__update_task_entity_contrib(se);
 	} else {
+		__update_tg_runnable_avg(&se->avg, group_cfs_rq(se));
 		__update_group_entity_contrib(se);
 	}
 
@@ -1214,6 +1269,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
 	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
+	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
 }
 
 /* Add the load generated by se into cfs_rq's child load-average */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0c453e7..1474bf2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -113,6 +113,7 @@ struct task_group {
 
 	atomic_t load_weight;
 	atomic64_t load_avg;
+	atomic_t runnable_avg;
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -234,6 +235,7 @@ struct cfs_rq {
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	u32 tg_runnable_contrib;
 	u64 tg_load_contrib;
 #endif
 #endif


