Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab2JXJy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:54:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54999 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab2JXJyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:54:55 -0400
Date: Wed, 24 Oct 2012 02:53:41 -0700
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-82958366cfea1a50e7e90907b2d55ae29ed69974@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <20120823141507.061208672@google.com>
References: <20120823141507.061208672@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Replace update_shares weight distribution with per-entity computation
Git-Commit-ID: 82958366cfea1a50e7e90907b2d55ae29ed69974
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:53:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82958366cfea1a50e7e90907b2d55ae29ed69974
Gitweb:     http://git.kernel.org/tip/82958366cfea1a50e7e90907b2d55ae29ed69974
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 4 Oct 2012 13:18:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:27:28 +0200

sched: Replace update_shares weight distribution with per-entity computation

Now that the machinery in place is in place to compute contributed load in a
bottom up fashion; replace the shares distribution code within update_shares()
accordingly.

Signed-off-by: Paul Turner <pjt@google.com>
Reviewed-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120823141507.061208672@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c |    8 ---
 kernel/sched/fair.c  |  157 ++++++++------------------------------------------
 kernel/sched/sched.h |   36 ++++--------
 3 files changed, 36 insertions(+), 165 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 71b0ea3..2cd3c1b 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -218,14 +218,6 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
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
index 873c9f5..57fae95 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -658,9 +658,6 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
-static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update);
-static void update_cfs_shares(struct cfs_rq *cfs_rq);
-
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -680,10 +677,6 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 
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
@@ -1490,7 +1396,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	update_cfs_load(cfs_rq, 0);
 	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 	account_entity_enqueue(cfs_rq, se);
 	update_cfs_shares(cfs_rq);
@@ -1587,7 +1492,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	se->on_rq = 0;
-	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
 
 	/*
@@ -1756,11 +1660,6 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
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
@@ -2005,18 +1904,9 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
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
 
@@ -2028,11 +1918,9 @@ static int tg_throttle_down(struct task_group *tg, void *data)
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
@@ -2630,7 +2518,6 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
 	}
@@ -2692,7 +2579,6 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 
-		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
 		update_entity_load_avg(se, 1);
 	}
@@ -3755,27 +3641,36 @@ next:
  */
 static int update_shares_cpu(struct task_group *tg, int cpu)
 {
+	struct sched_entity *se;
 	struct cfs_rq *cfs_rq;
 	unsigned long flags;
 	struct rq *rq;
 
-	if (!tg->se[cpu])
-		return 0;
-
 	rq = cpu_rq(cpu);
+	se = tg->se[cpu];
 	cfs_rq = tg->cfs_rq[cpu];
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
 	update_rq_clock(rq);
-	update_cfs_load(cfs_rq, 1);
 	update_cfs_rq_blocked_load(cfs_rq, 1);
 
-	/*
-	 * We need to update shares after updating tg->load_weight in
-	 * order to adjust the weight of groups with long running tasks.
-	 */
-	update_cfs_shares(cfs_rq);
+	if (se) {
+		update_entity_load_avg(se, 1);
+		/*
+		 * We pivot on our runnable average having decayed to zero for
+		 * list removal.  This generally implies that all our children
+		 * have also been removed (modulo rounding error or bandwidth
+		 * control); however, such cases are rare and we can fix these
+		 * at enqueue.
+		 *
+		 * TODO: fix up out-of-order children on enqueue.
+		 */
+		if (!se->avg.runnable_avg_sum && !cfs_rq->nr_running)
+			list_del_leaf_cfs_rq(cfs_rq);
+	} else {
+		update_rq_runnable_avg(rq, rq->nr_running);
+	}
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
@@ -5702,10 +5597,6 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 
 	cfs_rq->tg = tg;
 	cfs_rq->rq = rq;
-#ifdef CONFIG_SMP
-	/* allow initial update_cfs_load() to truncate */
-	cfs_rq->load_stamp = 1;
-#endif
 	init_cfs_rq_runtime(cfs_rq);
 
 	tg->cfs_rq[cpu] = cfs_rq;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d13bce7..0a75a43 100644
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
