Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0LHUAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:00:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:49116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab0LHUAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:00:34 -0500
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>
In-Reply-To: <4CFFC68D.30506@redhat.com>
References: <20101202144129.4357fe00@annuminas.surriel.com>
	 <20101202144423.3ad1908d@annuminas.surriel.com>
	 <1291382619.32004.2124.camel@laptop>  <4CFFC68D.30506@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 21:00:20 +0100
Message-ID: <1291838420.28378.159.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 12:55 -0500, Rik van Riel wrote:
> 
> 
> > Right, so another approach might be to simply swap the vruntime between
> > curr and p.
> 
> Doesn't that run into the same scale issue you described
> above?

Not really, but its tricky on SMP because vruntime only has meaning
within a cfs_rq.

The below is quickly cobbled together from a few patches I had laying
about dealing with similar issues.

The avg_vruntime() stuff takes the weighted average of the vruntimes on
a cfs runqueue, this weighted average corresponds to the 0-lag point,
that is the point where an ideal scheduler would have all tasks.

Using the 0-lag point you can compute the lag of a task, the lag is a
measure of service for a task, negative lag means the task is owed
services, positive lag means its got too much service (at least, thats
the sign convention used here, I always forget what the standard is).

What we do is, when @p the target task, is owed less service than
current, we flip lags such that p will become more eligible.

The trouble with all this is that computing the weighted average is
terribly expensive (it increases cost of all scheduler hot paths).

The dyn_vruntime stuff mixed in there is an attempt at computing
something similar, although its not used and I haven't tested the
quality of the approximation in a while.

Anyway, complete untested and such..

---
 include/linux/sched.h   |    2 +
 kernel/sched.c          |   39 ++++++++++
 kernel/sched_debug.c    |   31 ++++-----
 kernel/sched_fair.c     |  179 ++++++++++++++++++++++++++++++++++++++---------
 kernel/sched_features.h |    8 +--
 5 files changed, 203 insertions(+), 56 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b0fc8ee..538559e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1095,6 +1095,8 @@ struct sched_class {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
+
+	void (*yield_to) (struct task_struct *p);
 };
 
 struct load_weight {
diff --git a/kernel/sched.c b/kernel/sched.c
index 0debad9..fe0adb0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -313,6 +313,9 @@ struct cfs_rq {
 	struct load_weight load;
 	unsigned long nr_running;
 
+	s64 avg_vruntime;
+	u64 avg_load;
+
 	u64 exec_clock;
 	u64 min_vruntime;
 
@@ -5062,6 +5065,42 @@ SYSCALL_DEFINE0(sched_yield)
 	return 0;
 }
 
+void yield_to(struct task_struct *p)
+{
+	struct task_struct *curr = current;
+	struct rq *p_rq, *rq;
+	unsigned long flags;
+	int on_rq;
+
+	local_irq_save(flags);
+	rq = this_rq();
+again:
+	p_rq = task_rq(p);
+	double_rq_lock(rq, p_rq);
+	if (p_rq != task_rq(p)) {
+		double_rq_unlock(rq, p_rq);
+		goto again;
+	}
+
+	update_rq_clock(rq);
+	update_rq_clock(p_rq);
+
+	on_rq = p->se.on_rq;
+	if (on_rq)
+		dequeue_task(p_rq, p, 0);
+
+	ret = 0;
+	if (p->sched_class == curr->sched_class && curr->sched_class->yield_to)
+		curr->sched_class->yield_to(p);
+
+	if (on_rq)
+		enqueue_task(p_rq, p, 0);
+
+	double_rq_unlock(rq, p_rq);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(yield_to);
+
 static inline int should_resched(void)
 {
 	return need_resched() && !(preempt_count() & PREEMPT_ACTIVE);
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 1dfae3d..b5cc773 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -138,10 +138,9 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
-	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
-		spread, rq0_min_vruntime, spread0;
+	s64 left_vruntime = -1, min_vruntime, right_vruntime = -1, spread;
 	struct rq *rq = cpu_rq(cpu);
-	struct sched_entity *last;
+	struct sched_entity *last, *first;
 	unsigned long flags;
 
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
@@ -149,28 +148,26 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			SPLIT_NS(cfs_rq->exec_clock));
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
-	if (cfs_rq->rb_leftmost)
-		MIN_vruntime = (__pick_next_entity(cfs_rq))->vruntime;
+	first = __pick_first_entity(cfs_rq);
+	if (first)
+		left_vruntime = first->vruntime;
 	last = __pick_last_entity(cfs_rq);
 	if (last)
-		max_vruntime = last->vruntime;
+		right_vruntime = last->vruntime;
 	min_vruntime = cfs_rq->min_vruntime;
-	rq0_min_vruntime = cpu_rq(0)->cfs.min_vruntime;
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
-			SPLIT_NS(MIN_vruntime));
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "left_vruntime",
+			SPLIT_NS(left_vruntime));
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "min_vruntime",
 			SPLIT_NS(min_vruntime));
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "max_vruntime",
-			SPLIT_NS(max_vruntime));
-	spread = max_vruntime - MIN_vruntime;
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread",
-			SPLIT_NS(spread));
-	spread0 = min_vruntime - rq0_min_vruntime;
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread0",
-			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "avg_vruntime",
+			SPLIT_NS(avg_vruntime(cfs_rq)));
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "right_vruntime",
+			SPLIT_NS(right_vruntime));
+	spread = right_vruntime - left_vruntime;
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread", SPLIT_NS(spread));
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c886717..8689bcd 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -346,25 +346,90 @@ static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return se->vruntime - cfs_rq->min_vruntime;
 }
 
-static void update_min_vruntime(struct cfs_rq *cfs_rq)
+/*
+ * Compute virtual time from the per-task service numbers:
+ *
+ * Fair schedulers conserve lag: \Sum lag_i = 0
+ *
+ * lag_i = S_i - s_i = w_i * (V - v_i)
+ *
+ * \Sum lag_i = 0 -> \Sum w_i * (V - v_i) = V * \Sum w_i - \Sum w_i * v_i = 0
+ *
+ * From which we solve V:
+ *
+ *     \Sum v_i * w_i
+ * V = --------------
+ *        \Sum w_i
+ *
+ * However, since v_i is u64, and the multiplcation could easily overflow
+ * transform it into a relative form that uses smaller quantities:
+ *
+ * Substitute: v_i == (v_i - v) + v
+ *
+ *     \Sum ((v_i - v) + v) * w_i   \Sum (v_i - v) * w_i
+ * V = -------------------------- = -------------------- + v
+ *              \Sum w_i                   \Sum w_i
+ *
+ * min_vruntime = v
+ * avg_vruntime = \Sum (v_i - v) * w_i
+ * cfs_rq->load = \Sum w_i
+ *
+ * Since min_vruntime is a monotonic increasing variable that closely tracks
+ * the per-task service, these deltas: (v_i - v), will be in the order of the
+ * maximal (virtual) lag induced in the system due to quantisation.
+ */
+static void
+avg_vruntime_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	u64 vruntime = cfs_rq->min_vruntime;
+	s64 key = entity_key(cfs_rq, se);
+	cfs_rq->avg_vruntime += key * se->load.weight;
+	cfs_rq->avg_load += se->load.weight;
+}
 
-	if (cfs_rq->curr)
-		vruntime = cfs_rq->curr->vruntime;
+static void
+avg_vruntime_sub(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	s64 key = entity_key(cfs_rq, se);
+	cfs_rq->avg_vruntime -= key * se->load.weight;
+	cfs_rq->avg_load -= se->load.weight;
+}
+
+static inline
+void avg_vruntime_update(struct cfs_rq *cfs_rq, s64 delta)
+{
+	/*
+	 * v' = v + d ==> avg_vruntime' = avg_runtime - d*avg_load
+	 */
+	cfs_rq->avg_vruntime -= cfs_rq->avg_load * delta;
+}
 
-	if (cfs_rq->rb_leftmost) {
-		struct sched_entity *se = rb_entry(cfs_rq->rb_leftmost,
-						   struct sched_entity,
-						   run_node);
+static u64 avg_vruntime(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *se = cfs_rq->curr;
+	s64 lag = cfs_rq->avg_vruntime;
+	long load = cfs_rq->avg_load;
 
-		if (!cfs_rq->curr)
-			vruntime = se->vruntime;
-		else
-			vruntime = min_vruntime(vruntime, se->vruntime);
+	if (se) {
+		lag += entity_key(cfs_rq, se) * se->load.weight;
+		load += se->load.weight;
 	}
 
-	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+	if (load)
+		lag = div_s64(lag, load);
+
+	return cfs_rq->min_vruntime + lag;
+}
+
+static void __update_min_vruntime(struct cfs_rq *cfs_rq, u64 vruntime)
+{
+	/*
+	 * open coded max_vruntime() to allow updating avg_vruntime
+	 */
+	s64 delta = (s64)(vruntime - cfs_rq->min_vruntime);
+	if (delta > 0) {
+		avg_vruntime_update(cfs_rq, delta);
+		cfs_rq->min_vruntime = vruntime;
+	}
 }
 
 /*
@@ -378,6 +443,8 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	s64 key = entity_key(cfs_rq, se);
 	int leftmost = 1;
 
+	avg_vruntime_add(cfs_rq, se);
+
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -417,9 +484,10 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	}
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	avg_vruntime_sub(cfs_rq, se);
 }
 
-static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
+static struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
 
@@ -542,6 +610,33 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update);
 static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta);
 
+static void update_min_vruntime(struct cfs_rq *cfs_rq, unsigned long delta_exec)
+{
+	struct sched_entity *left = __pick_first_entity(cfs_rq);
+	struct sched_entity *curr = cfs_rq->curr;
+	u64 vruntime;
+
+	if (left && curr)
+		vruntime = min_vruntime(left->vruntime, curr->vruntime);
+	else if (left)
+		vruntime = left->vruntime;
+	else if (curr)
+		vruntime = curr->vruntime;
+	else
+		return;
+
+	if (sched_feat(DYN_MIN_VRUNTIME)) {
+		u64 new_vruntime = cfs_rq->min_vruntime;
+		if (delta_exec) {
+			new_vruntime += calc_delta_mine(delta_exec,
+					NICE_0_LOAD, &cfs_rq->load);
+		}
+		vruntime = max_vruntime(new_vruntime, vruntime);
+	}
+
+	__update_min_vruntime(cfs_rq, vruntime);
+}
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -560,7 +655,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 
 	curr->vruntime += delta_exec_weighted;
-	update_min_vruntime(cfs_rq);
+	update_min_vruntime(cfs_rq, delta_exec);
 
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->load_unacc_exec_time += delta_exec;
@@ -895,16 +990,7 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
-	u64 vruntime = cfs_rq->min_vruntime;
-
-	/*
-	 * The 'current' period is already promised to the current tasks,
-	 * however the extra weight of the new task will slow them down a
-	 * little, place the new task so that it fits in the slot that
-	 * stays open at the end.
-	 */
-	if (initial && sched_feat(START_DEBIT))
-		vruntime += sched_vslice(cfs_rq, se);
+	u64 vruntime = avg_vruntime(cfs_rq);
 
 	/* sleeps up to a single latency don't count. */
 	if (!initial) {
@@ -934,7 +1020,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * through callig update_curr().
 	 */
 	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_WAKING))
-		se->vruntime += cfs_rq->min_vruntime;
+		se->vruntime += avg_vruntime(cfs_rq);
 
 	/*
 	 * Update run-time statistics of the 'current'.
@@ -1003,7 +1089,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	se->on_rq = 0;
 	update_cfs_load(cfs_rq, 0);
 	account_entity_dequeue(cfs_rq, se);
-	update_min_vruntime(cfs_rq);
+	update_min_vruntime(cfs_rq, 0);
 	update_cfs_shares(cfs_rq, 0);
 
 	/*
@@ -1012,7 +1098,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * movement in our normalized position.
 	 */
 	if (!(flags & DEQUEUE_SLEEP))
-		se->vruntime -= cfs_rq->min_vruntime;
+		se->vruntime -= avg_vruntime(cfs_rq);
 }
 
 /*
@@ -1090,7 +1176,7 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = __pick_next_entity(cfs_rq);
+	struct sched_entity *se = __pick_first_entity(cfs_rq);
 	struct sched_entity *left = se;
 
 	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
@@ -1326,7 +1412,7 @@ static void task_waking_fair(struct rq *rq, struct task_struct *p)
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-	se->vruntime -= cfs_rq->min_vruntime;
+	se->vruntime -= avg_vruntime(cfs_rq);
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -4025,7 +4111,7 @@ static void task_fork_fair(struct task_struct *p)
 		resched_task(rq->curr);
 	}
 
-	se->vruntime -= cfs_rq->min_vruntime;
+	se->vruntime -= avg_vruntime(cfs_rq);
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
@@ -4096,10 +4182,10 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * fair sleeper stuff for the first placement, but who cares.
 	 */
 	if (!on_rq)
-		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
+		p->se.vruntime -= avg_vruntime(cfs_rq_of(&p->se));
 	set_task_rq(p, task_cpu(p));
 	if (!on_rq)
-		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
+		p->se.vruntime += avg_vruntime(cfs_rq_of(&p->se));
 }
 #endif
 
@@ -4118,6 +4204,31 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	return rr_interval;
 }
 
+static void yield_to_fair(struct task_stuct *p)
+{
+	struct sched_entity *se = &current->se;
+	struct sched_entity *p_se = &p->se;
+	u64 lag0, p_lag0;
+	s64 lag, p_lag;
+
+	lag0 = avg_vruntime(cfs_rq_of(se));
+	p_lag0 = avg_vruntime(cfs_rq_of(p_se));
+
+	lag = se->vruntime - avg_vruntime(cfs_rq);
+	p_lag = p_se->vruntime - avg_vruntime(p_cfs_rq);
+
+	if (p_lag > lag) { /* if P is owed less service */
+		se->vruntime = lag0 + p_lag;
+		p_se->vruntime = p_lag + lag;
+	}
+
+	/*
+	 * XXX try something smarter here
+	 */
+	resched_task(p);
+	resched_task(current);
+}
+
 /*
  * All the scheduling class methods:
  */
@@ -4150,6 +4261,8 @@ static const struct sched_class fair_sched_class = {
 
 	.get_rr_interval	= get_rr_interval_fair,
 
+	.yield_to		= yield_to_fair,
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.task_move_group	= task_move_group_fair,
 #endif
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 68e69ac..feda9b8 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -6,12 +6,6 @@
 SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 
 /*
- * Place new tasks ahead so that they do not starve already running
- * tasks
- */
-SCHED_FEAT(START_DEBIT, 1)
-
-/*
  * Should wakeups try to preempt running tasks.
  */
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
@@ -53,6 +47,8 @@ SCHED_FEAT(HRTICK, 0)
 SCHED_FEAT(DOUBLE_TICK, 0)
 SCHED_FEAT(LB_BIAS, 1)
 
+SCHED_FEAT(DYN_MIN_VRUNTIME, 0)
+
 /*
  * Spin-wait on mutex acquisition when the mutex owner is running on
  * another cpu -- assumes that when the owner is running, it will soon

