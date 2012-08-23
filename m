Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053Ab2HWORH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:17:07 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:47442 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab2HWOPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:15:31 -0400
Message-Id: <20120823141506.585389902@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 07:14:26 -0700
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
Subject: [patch 04/16] sched: maintain the load contribution of blocked entities
References: <20120823141422.444396696@google.com>
Content-Disposition: inline; filename=sched-cfs_rq_blocked_load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Turner <pjt@google.com>

We are currently maintaining:
  runnable_load(cfs_rq) = \Sum task_load(t)

For all running children t of cfs_rq.  While this can be naturally updated for
tasks in a runnable state (as they are scheduled); this does not account for
the load contributed by blocked task entities.

This can be solved by introducing a separate accounting for blocked load:
  blocked_load(cfs_rq) = \Sum runnable(b) * weight(b)

Obviously we do not want to iterate over all blocked entities to account for
their decay, we instead observe that:
  runnable_load(t) = \Sum p_i*y^i

and that to account for an additional idle period we only need to compute:
  y*runnable_load(t).

This means that we can compute all blocked entities at once by evaluating:
  blocked_load(cfs_rq)` = y * blocked_load(cfs_rq)

Finally we maintain a decay counter so that when a sleeping entity re-awakens
we can determine how much of its load should be removed from the blocked sum.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
---
 include/linux/sched.h |    1 
 kernel/sched/core.c   |    1 
 kernel/sched/debug.c  |    3 +
 kernel/sched/fair.c   |  124 ++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h  |    4 +-
 5 files changed, 118 insertions(+), 15 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 943a60d..7406249 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1147,6 +1147,7 @@ struct sched_avg {
 	 */
 	u32 runnable_avg_sum, runnable_avg_period;
 	u64 last_runnable_update;
+	s64 decay_count;
 	unsigned long load_avg_contrib;
 };
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fcc3cad..33e6fe1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1560,7 +1560,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
 #endif
-
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index c953a89..2d2e2b3 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -95,6 +95,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 	P(se->avg.runnable_avg_sum);
 	P(se->avg.runnable_avg_period);
 	P(se->avg.load_avg_contrib);
+	P(se->avg.decay_count);
 #endif
 #undef PN
 #undef P
@@ -227,6 +228,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			atomic_read(&cfs_rq->tg->load_weight));
 	SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
 			cfs_rq->runnable_load_avg);
+	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
+			cfs_rq->blocked_load_avg);
 #endif
 
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f1151f9..0ce8d91 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1080,6 +1080,20 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 	return decayed;
 }
 
+/* Synchronize an entity's decay with its parenting cfs_rq.*/
+static inline void __synchronize_entity_decay(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 decays = atomic64_read(&cfs_rq->decay_counter);
+
+	decays -= se->avg.decay_count;
+	if (!decays)
+		return;
+
+	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
+	se->avg.decay_count = 0;
+}
+
 /* Compute the current contribution to load_avg by se, return any delta */
 static long __update_entity_load_avg_contrib(struct sched_entity *se)
 {
@@ -1095,8 +1109,18 @@ static long __update_entity_load_avg_contrib(struct sched_entity *se)
 	return se->avg.load_avg_contrib - old_contrib;
 }
 
+static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
+						 long load_contrib)
+{
+	if (likely(load_contrib < cfs_rq->blocked_load_avg))
+		cfs_rq->blocked_load_avg -= load_contrib;
+	else
+		cfs_rq->blocked_load_avg = 0;
+}
+
 /* Update a sched_entity's runnable average */
-static inline void update_entity_load_avg(struct sched_entity *se)
+static inline void update_entity_load_avg(struct sched_entity *se,
+					  int update_cfs_rq)
 {
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 	long contrib_delta;
@@ -1106,8 +1130,34 @@ static inline void update_entity_load_avg(struct sched_entity *se)
 		return;
 
 	contrib_delta = __update_entity_load_avg_contrib(se);
+
+	if (!update_cfs_rq)
+		return;
+
 	if (se->on_rq)
 		cfs_rq->runnable_load_avg += contrib_delta;
+	else
+		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
+}
+
+/*
+ * Decay the load contributed by all blocked children and account this so that
+ * their contribution may appropriately discounted when they wake up.
+ */
+static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq)
+{
+	u64 now = rq_of(cfs_rq)->clock_task >> 20;
+	u64 decays;
+
+	decays = now - cfs_rq->last_decay;
+	if (!decays)
+		return;
+
+	cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
+					      decays);
+	atomic64_add(decays, &cfs_rq->decay_counter);
+
+	cfs_rq->last_decay = now;
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
@@ -1117,26 +1167,53 @@ static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 
 /* Add the load generated by se into cfs_rq's child load-average */
 static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
-						  struct sched_entity *se)
+						  struct sched_entity *se,
+						  int wakeup)
 {
-	update_entity_load_avg(se);
+	/* we track migrations using entity decay_count == 0 */
+	if (unlikely(!se->avg.decay_count)) {
+		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
+		wakeup = 0;
+	} else {
+		__synchronize_entity_decay(se);
+	}
+
+	if (wakeup)
+		subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
+
+	update_entity_load_avg(se, 0);
 	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
+	update_cfs_rq_blocked_load(cfs_rq);
 }
 
-/* Remove se's load from this cfs_rq child load-average */
+/*
+ * Remove se's load from this cfs_rq child load-average, if the entity is
+ * transitioning to a blocked state we track its projected decay using
+ * blocked_load_avg.
+ */
 static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
-						  struct sched_entity *se)
+						  struct sched_entity *se,
+						  int sleep)
 {
-	update_entity_load_avg(se);
+	update_entity_load_avg(se, 1);
+
 	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
+	if (sleep) {
+		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
+		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
+	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
 }
 #else
-static inline void update_entity_load_avg(struct sched_entity *se) {}
+static inline void update_entity_load_avg(struct sched_entity *se,
+					  int update_cfs_rq) {}
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
 static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
-						  struct sched_entity *se) {}
+					   struct sched_entity *se,
+					   int wakeup) {}
 static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
-						  struct sched_entity *se) {}
+					   struct sched_entity *se,
+					   int sleep) {}
+static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq) {}
 #endif
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -1265,7 +1342,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	update_curr(cfs_rq);
 	update_cfs_load(cfs_rq, 0);
-	enqueue_entity_load_avg(cfs_rq, se);
+	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
 
@@ -1340,7 +1417,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	dequeue_entity_load_avg(cfs_rq, se);
+	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
@@ -1511,7 +1588,7 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
 		/* in !on_rq case, update occurred at dequeue */
-		update_entity_load_avg(prev);
+		update_entity_load_avg(prev, 1);
 	}
 	cfs_rq->curr = NULL;
 }
@@ -1527,7 +1604,8 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	/*
 	 * Ensure that runnable average is periodically updated.
 	 */
-	update_entity_load_avg(curr);
+	update_entity_load_avg(curr, 1);
+	update_cfs_rq_blocked_load(cfs_rq);
 
 	/*
 	 * Update share accounting for long-running entities.
@@ -2386,6 +2464,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
+		update_entity_load_avg(se, 1);
 	}
 
 	if (!se) {
@@ -2447,6 +2526,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
+		update_entity_load_avg(se, 1);
 	}
 
 	if (!se) {
@@ -3483,6 +3563,7 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 
 	update_rq_clock(rq);
 	update_cfs_load(cfs_rq, 1);
+	update_cfs_rq_blocked_load(cfs_rq);
 
 	/*
 	 * We need to update shares after updating tg->load_weight in
@@ -5220,6 +5301,20 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 		place_entity(cfs_rq, se, 0);
 		se->vruntime -= cfs_rq->min_vruntime;
 	}
+
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+	/*
+	* Remove our load from contribution when we leave sched_fair
+	* and ensure we don't carry in an old decay_count if we
+	* switch back.
+	*/
+	if (p->se.avg.decay_count) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
+		__synchronize_entity_decay(&p->se);
+		subtract_blocked_load_contrib(cfs_rq,
+				p->se.avg.load_avg_contrib);
+	}
+#endif
 }
 
 /*
@@ -5266,6 +5361,9 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
 #endif
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+	atomic64_set(&cfs_rq->decay_counter, 1);
+#endif
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7e35ae0..1df06e9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -229,7 +229,9 @@ struct cfs_rq {
 	 * This allows for the description of both thread and group usage (in
 	 * the FAIR_GROUP_SCHED case).
 	 */
-	u64 runnable_load_avg;
+	u64 runnable_load_avg, blocked_load_avg;
+	atomic64_t decay_counter;
+	u64 last_decay;
 #endif
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */


