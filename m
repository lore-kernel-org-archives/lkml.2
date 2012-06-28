Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab2F1C7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:59:34 -0400
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55777 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138Ab2F1C4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:56:25 -0400
Subject: [PATCH 11/16] sched: replace update_shares weight distribution with
	per-entity computation
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
Date: Wed, 27 Jun 2012 19:24:15 -0700
Message-ID: <20120628022415.30496.65099.stgit@kitami.mtv.corp.google.com>
In-Reply-To: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the machinery in place is in place to compute contributed load in a
bottom up fashion; replace the shares distribution code within update_shares()
accordingly.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/debug.c |    8 ---
 kernel/sched/fair.c  |  152 +++++++-------------------------------------------
 kernel/sched/sched.h |   36 ++++--------
 3 files changed, 32 insertions(+), 164 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 9334c68..fbd1517 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -221,14 +221,6 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "load_avg",
-			SPLIT_NS(cfs_rq->load_avg));
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "load_period",
-			SPLIT_NS(cfs_rq->load_period));
-	SEQ_printf(m, "  .%-30s: %ld\n", "load_contrib",
-			cfs_rq->load_contribution);
-	SEQ_printf(m, "  .%-30s: %d\n", "load_tg",
-			atomic_read(&cfs_rq->tg->load_weight));
 	SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b78d03e..4a9a828 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -654,9 +654,6 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
-static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update);
-static void update_cfs_shares(struct cfs_rq *cfs_rq);
-
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -676,10 +673,6 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 
 	curr->vruntime += delta_exec_weighted;
 	update_min_vruntime(cfs_rq);
-
-#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
-	cfs_rq->load_unacc_exec_time += delta_exec;
-#endif
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -806,72 +799,7 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-/* we need this in update_cfs_load and load-balance functions below */
-static inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
 # ifdef CONFIG_SMP
-static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
-					    int global_update)
-{
-	struct task_group *tg = cfs_rq->tg;
-	long load_avg;
-
-	load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
-	load_avg -= cfs_rq->load_contribution;
-
-	if (global_update || abs(load_avg) > cfs_rq->load_contribution / 8) {
-		atomic_add(load_avg, &tg->load_weight);
-		cfs_rq->load_contribution += load_avg;
-	}
-}
-
-static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
-{
-	u64 period = sysctl_sched_shares_window;
-	u64 now, delta;
-	unsigned long load = cfs_rq->load.weight;
-
-	if (cfs_rq->tg == &root_task_group || throttled_hierarchy(cfs_rq))
-		return;
-
-	now = rq_of(cfs_rq)->clock_task;
-	delta = now - cfs_rq->load_stamp;
-
-	/* truncate load history at 4 idle periods */
-	if (cfs_rq->load_stamp > cfs_rq->load_last &&
-	    now - cfs_rq->load_last > 4 * period) {
-		cfs_rq->load_period = 0;
-		cfs_rq->load_avg = 0;
-		delta = period - 1;
-	}
-
-	cfs_rq->load_stamp = now;
-	cfs_rq->load_unacc_exec_time = 0;
-	cfs_rq->load_period += delta;
-	if (load) {
-		cfs_rq->load_last = now;
-		cfs_rq->load_avg += delta * load;
-	}
-
-	/* consider updating load contribution on each fold or truncate */
-	if (global_update || cfs_rq->load_period > period
-	    || !cfs_rq->load_period)
-		update_cfs_rq_load_contribution(cfs_rq, global_update);
-
-	while (cfs_rq->load_period > period) {
-		/*
-		 * Inline assembly required to prevent the compiler
-		 * optimising this loop into a divmod call.
-		 * See __iter_div_u64_rem() for another example of this.
-		 */
-		asm("" : "+rm" (cfs_rq->load_period));
-		cfs_rq->load_period /= 2;
-		cfs_rq->load_avg /= 2;
-	}
-
-	if (!cfs_rq->curr && !cfs_rq->nr_running && !cfs_rq->load_avg)
-		list_del_leaf_cfs_rq(cfs_rq);
-}
-
 static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 {
 	long tg_weight;
@@ -881,8 +809,8 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 	 * to gain a more accurate current total weight. See
 	 * update_cfs_rq_load_contribution().
 	 */
-	tg_weight = atomic_read(&tg->load_weight);
-	tg_weight -= cfs_rq->load_contribution;
+	tg_weight = atomic64_read(&tg->load_avg);
+	tg_weight -= cfs_rq->tg_load_contrib;
 	tg_weight += cfs_rq->load.weight;
 
 	return tg_weight;
@@ -906,27 +834,11 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 
 	return shares;
 }
-
-static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
-{
-	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
-		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq);
-	}
-}
 # else /* CONFIG_SMP */
-static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
-{
-}
-
 static inline long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 {
 	return tg->shares;
 }
-
-static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
-{
-}
 # endif /* CONFIG_SMP */
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
@@ -944,6 +856,8 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 		account_entity_enqueue(cfs_rq, se);
 }
 
+static inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
+
 static void update_cfs_shares(struct cfs_rq *cfs_rq)
 {
 	struct task_group *tg;
@@ -963,17 +877,9 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq)
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
-static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
-{
-}
-
 static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 {
 }
-
-static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
-{
-}
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_SMP
@@ -1473,7 +1379,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	update_cfs_load(cfs_rq, 0);
 	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
@@ -1570,7 +1475,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	se->on_rq = 0;
-	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 
 	/*
@@ -1739,11 +1643,6 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	update_entity_load_avg(curr, 1);
 	update_cfs_rq_blocked_load(cfs_rq, 1);
 
-	/*
-	 * Update share accounting for long-running entities.
-	 */
-	update_entity_shares_tick(cfs_rq);
-
 #ifdef CONFIG_SCHED_HRTICK
 	/*
 	 * queued ticks are scheduled to match the slice, so don't bother
@@ -1988,18 +1887,9 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 	cfs_rq->throttle_count--;
 #ifdef CONFIG_SMP
 	if (!cfs_rq->throttle_count) {
-		u64 delta = rq->clock_task - cfs_rq->load_stamp;
-
-		/* leaving throttled state, advance shares averaging windows */
-		cfs_rq->load_stamp += delta;
-		cfs_rq->load_last += delta;
-
 		/* adjust cfs_rq_clock_task() */
 		cfs_rq->throttled_clock_task_time += rq->clock_task -
 					     cfs_rq->throttled_clock_task;
-
-		/* update entity weight now that we are on_rq again */
-		update_cfs_shares(cfs_rq);
 	}
 #endif
 
@@ -2011,11 +1901,9 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 	struct rq *rq = data;
 	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu_of(rq)];
 
-	/* group is entering throttled state, record last load */
-	if (!cfs_rq->throttle_count) {
-		update_cfs_load(cfs_rq, 0);
+	/* group is entering throttled state, stop time */
+	if (!cfs_rq->throttle_count)
 		cfs_rq->throttled_clock_task = rq->clock_task;
-	}
 	cfs_rq->throttle_count++;
 
 	return 0;
@@ -2613,7 +2501,6 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
 	}
@@ -2675,7 +2562,6 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
 	}
@@ -3794,27 +3680,33 @@ out:
  */
 static int update_shares_cpu(struct task_group *tg, int cpu)
 {
+	struct sched_entity *se;
 	struct cfs_rq *cfs_rq;
 	unsigned long flags;
 	struct rq *rq;
 
-	if (!tg->se[cpu])
-		return 0;
 
 	rq = cpu_rq(cpu);
+	se = tg->se[cpu];
 	cfs_rq = tg->cfs_rq[cpu];
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
-	update_cfs_load(cfs_rq, 1);
 	update_cfs_rq_blocked_load(cfs_rq, 1);
+	update_entity_load_avg(tg->se[cpu], 1);
 
-	/*
-	 * We need to update shares after updating tg->load_weight in
-	 * order to adjust the weight of groups with long running tasks.
-	 */
-	update_cfs_shares(cfs_rq);
+	if (se) {
+		/*
+		 * We can pivot on the runnable average decaying to zero for
+		 * list removal since the parent average will always be >=
+		 * child.
+		 */
+		if (se->avg.runnable_avg_sum)
+			update_cfs_shares(cfs_rq);
+		else
+			list_del_leaf_cfs_rq(cfs_rq);
+	}
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
@@ -5830,10 +5722,6 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 
 	cfs_rq->tg = tg;
 	cfs_rq->rq = rq;
-#ifdef CONFIG_SMP
-	/* allow initial update_cfs_load() to truncate */
-	cfs_rq->load_stamp = 1;
-#endif
 	init_cfs_rq_runtime(cfs_rq);
 
 	tg->cfs_rq[cpu] = cfs_rq;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 60c0935..67cc5e1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -234,11 +234,21 @@ struct cfs_rq {
 	u64 runnable_load_avg, blocked_load_avg;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	u32 tg_runnable_contrib;
 	u64 tg_load_contrib;
-#endif
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
+	/*
+	 *   h_load = weight * f(tg)
+	 *
+	 * Where f(tg) is the recursive weight fraction assigned to
+	 * this group.
+	 */
+	unsigned long h_load;
+#endif /* CONFIG_SMP */
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
 
@@ -254,28 +264,6 @@ struct cfs_rq {
 	struct list_head leaf_cfs_rq_list;
 	struct task_group *tg;	/* group that "owns" this runqueue */
 
-#ifdef CONFIG_SMP
-	/*
-	 *   h_load = weight * f(tg)
-	 *
-	 * Where f(tg) is the recursive weight fraction assigned to
-	 * this group.
-	 */
-	unsigned long h_load;
-
-	/*
-	 * Maintaining per-cpu shares distribution for group scheduling
-	 *
-	 * load_stamp is the last time we updated the load average
-	 * load_last is the last time we updated the load average and saw load
-	 * load_unacc_exec_time is currently unaccounted execution time
-	 */
-	u64 load_avg;
-	u64 load_period;
-	u64 load_stamp, load_last, load_unacc_exec_time;
-
-	unsigned long load_contribution;
-#endif /* CONFIG_SMP */
 #ifdef CONFIG_CFS_BANDWIDTH
 	int runtime_enabled;
 	u64 runtime_expires;


