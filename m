Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab2F1C42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:56:28 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:54019 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab2F1C4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:56:24 -0400
Subject: [PATCH 04/16] sched: maintain the load contribution of blocked
	entities
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 27 Jun 2012 19:24:14 -0700
Message-ID: <20120628022414.30496.4580.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Ben Segall <bsegall@google.com>
---
 include/linux/sched.h |    1 
 kernel/sched/core.c   |    3 +
 kernel/sched/debug.c  |    3 +
 kernel/sched/fair.c   |  130 ++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched/sched.h  |    4 +-
 5 files changed, 126 insertions(+), 15 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0c54ce0..842c4df 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1139,6 +1139,7 @@ struct load_weight {
 struct sched_avg {
 	u32 runnable_avg_sum, runnable_avg_period;
 	u64 last_runnable_update;
+	s64 decay_count;
 	unsigned long load_avg_contrib;
 };
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9bb7d28..aeb8e56 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1713,6 +1713,9 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+	p->se.avg.decay_count = 0;
+#endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index aeb74e3..2aa60cf 100644
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
@@ -230,6 +231,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			atomic_read(&cfs_rq->tg->load_weight));
 	SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
 			cfs_rq->runnable_load_avg);
+	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
+			cfs_rq->blocked_load_avg);
 #endif
 
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8229766..6200d20 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1085,6 +1085,20 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
 	return decayed;
 }
 
+/* Synchronize an entity's decay with its parentin cfs_rq.*/
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
+	se->avg.decay_count += decays;
+}
+
 /* Compute the current contribution to load_avg by se, return any delta */
 static long __update_entity_load_avg_contrib(struct sched_entity *se)
 {
@@ -1100,8 +1114,18 @@ static long __update_entity_load_avg_contrib(struct sched_entity *se)
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
@@ -1111,8 +1135,34 @@ static inline void update_entity_load_avg(struct sched_entity *se)
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
+ * they their contribution may appropriately discounted when they wake up.
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
@@ -1122,26 +1172,56 @@ static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 
 /* Add the load generated by se into cfs_rq's child load-average */
 static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
-						  struct sched_entity *se)
-{
-	update_entity_load_avg(se);
+						  struct sched_entity *se,
+						  int wakeup)
+{
+	/* we track migrations using entity decay_count == 0 */
+	if (unlikely(!se->avg.decay_count)) {
+		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
+		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
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
+	} else {
+		se->avg.decay_count = 0;
+	}
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
@@ -1270,7 +1350,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	update_curr(cfs_rq);
 	update_cfs_load(cfs_rq, 0);
-	enqueue_entity_load_avg(cfs_rq, se);
+	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
 
@@ -1345,7 +1425,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	dequeue_entity_load_avg(cfs_rq, se);
+	dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
@@ -1516,7 +1596,7 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
 		/* in !on_rq case, update occurred at dequeue */
-		update_entity_load_avg(prev);
+		update_entity_load_avg(prev, 1);
 	}
 	cfs_rq->curr = NULL;
 }
@@ -1532,7 +1612,8 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	/*
 	 * Ensure that runnable average is periodically updated.
 	 */
-	update_entity_load_avg(curr);
+	update_entity_load_avg(curr, 1);
+	update_cfs_rq_blocked_load(cfs_rq);
 
 	/*
 	 * Update share accounting for long-running entities.
@@ -2391,6 +2472,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
+		update_entity_load_avg(se, 1);
 	}
 
 	if (!se) {
@@ -2452,6 +2534,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
+		update_entity_load_avg(se, 1);
 	}
 
 	if (!se) {
@@ -3557,6 +3640,7 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
 
 	update_rq_clock(rq);
 	update_cfs_load(cfs_rq, 1);
+	update_cfs_rq_blocked_load(cfs_rq);
 
 	/*
 	 * We need to update shares after updating tg->load_weight in
@@ -5379,6 +5463,21 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
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
+		p->se.avg.decay_count = 0;
+	}
+#endif
 }
 
 /*
@@ -5425,6 +5524,9 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
 #endif
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
+	atomic64_set(&cfs_rq->decay_counter, 1);
+#endif
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 26cc36f..a96adf1 100644
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


