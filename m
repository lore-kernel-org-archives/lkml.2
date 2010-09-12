Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab0ILMpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 08:45:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:39521 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0ILMpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 08:45:06 -0400
Subject: Re: [RFC patch 0/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100911173732.551632040@efficios.com>
References: <20100911173732.551632040@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 12 Sep 2010 14:44:48 +0200
Message-ID: <1284295488.2275.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You found improved latencies with something like the below as well,
right? Except your proglet needs timers to be special too iirc.

Thomas objected to 'special' wakeups, and I can fully appreciate why,
but maybe we could try it anyway, its only a reasonably soft hint
anyway.

( full series with changelogs at:
  programming.kicks-ass.net/sekrit/sched-patches.tar.bz2 )

I'm currently running it on my laptop, and while spread is reasonably
controlled, interactivity isn't too sucky, but its not too hot either.

(I did lower my min_gran to like 1/5th of latency)

---
 drivers/input/evdev.c   |    2 +
 include/linux/sched.h   |   22 +++++--
 kernel/sched.c          |    8 +-
 kernel/sched_debug.c    |    2 -
 kernel/sched_fair.c     |  160 +++++++++++++++++++++++------------------------
 kernel/sched_features.h |   13 ++---
 7 files changed, 107 insertions(+), 102 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 5808731..1c5b626 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -84,6 +84,7 @@ static void evdev_event(struct input_handle *handle,
 	event.code = code;
 	event.value = value;
 
+	sched_wake_interactive_enable();
 	rcu_read_lock();
 
 	client = rcu_dereference(evdev->grab);
@@ -96,6 +97,7 @@ static void evdev_event(struct input_handle *handle,
 	rcu_read_unlock();
 
 	wake_up_interruptible(&evdev->wait);
+	sched_wake_interactive_disable();
 }
 
 static int evdev_fasync(int fd, struct file *file, int on)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53eb33c..dd40801 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1097,7 +1097,6 @@ struct sched_statistics {
 	u64			block_start;
 	u64			block_max;
 	u64			exec_max;
-	u64			slice_max;
 
 	u64			nr_migrations_cold;
 	u64			nr_failed_migrations_affine;
@@ -1121,7 +1120,8 @@ struct sched_entity {
 	struct load_weight	load;		/* for load-balancing */
 	struct rb_node		run_node;
 	struct list_head	group_node;
-	unsigned int		on_rq;
+	unsigned int		on_rq       : 1,
+				interactive : 1;
 
 	u64			exec_start;
 	u64			sum_exec_runtime;
@@ -1239,11 +1239,11 @@ struct task_struct {
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
-	unsigned in_iowait:1;
 
-
-	/* Revert to default priority/policy when forking */
-	unsigned sched_reset_on_fork:1;
+	unsigned sched_in_iowait       :1; /* Called io_schedule() */
+	unsigned sched_reset_on_fork   :1; /* Revert to default priority/policy
+					    * on fork */
+	unsigned sched_wake_interactive:4; /* User driven wakeup */
 
 	pid_t pid;
 	pid_t tgid;
@@ -1506,6 +1506,16 @@ struct task_struct {
 #endif
 };
 
+static inline void sched_wake_interactive_enable(void)
+{
+	current->sched_wake_interactive++;
+}
+
+static inline void sched_wake_interactive_disable(void)
+{
+	current->sched_wake_interactive--;
+}
+
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 1ab8394..89ff2c3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5125,9 +5125,9 @@ void __sched io_schedule(void)
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
-	current->in_iowait = 1;
+	current->sched_in_iowait = 1;
 	schedule();
-	current->in_iowait = 0;
+	current->sched_in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 }
@@ -5140,9 +5140,9 @@ long __sched io_schedule_timeout(long timeout)
 
 	delayacct_blkio_start();
 	atomic_inc(&rq->nr_iowait);
-	current->in_iowait = 1;
+	current->sched_in_iowait = 1;
 	ret = schedule_timeout(timeout);
-	current->in_iowait = 0;
+	current->sched_in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 	return ret;
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 2e1b0d1..c301164 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -76,7 +76,6 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu,
 	PN(se->statistics.sleep_max);
 	PN(se->statistics.block_max);
 	PN(se->statistics.exec_max);
-	PN(se->statistics.slice_max);
 	PN(se->statistics.wait_max);
 	PN(se->statistics.wait_sum);
 	P(se->statistics.wait_count);
@@ -408,7 +407,6 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.statistics.sleep_max);
 	PN(se.statistics.block_max);
 	PN(se.statistics.exec_max);
-	PN(se.statistics.slice_max);
 	PN(se.statistics.wait_max);
 	PN(se.statistics.wait_sum);
 	P(se.statistics.wait_count);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9b5b4f8..a1ad97d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -301,27 +301,6 @@ static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return se->vruntime - cfs_rq->min_vruntime;
 }
 
-static void update_min_vruntime(struct cfs_rq *cfs_rq)
-{
-	u64 vruntime = cfs_rq->min_vruntime;
-
-	if (cfs_rq->curr)
-		vruntime = cfs_rq->curr->vruntime;
-
-	if (cfs_rq->rb_leftmost) {
-		struct sched_entity *se = rb_entry(cfs_rq->rb_leftmost,
-						   struct sched_entity,
-						   run_node);
-
-		if (!cfs_rq->curr)
-			vruntime = se->vruntime;
-		else
-			vruntime = min_vruntime(vruntime, se->vruntime);
-	}
-
-	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
-}
-
 /*
  * Enqueue an entity into the rb-tree:
  */
@@ -495,6 +474,30 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
+static void update_min_vruntime(struct cfs_rq *cfs_rq, unsigned long delta_exec)
+{
+	struct sched_entity *left = __pick_next_entity(cfs_rq);
+	struct sched_entity *curr = cfs_rq->curr;
+	u64 new_vruntime, vruntime;
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
+	new_vruntime = cfs_rq->min_vruntime;
+	if (sched_feat(DYN_MIN_VRUNTIME) && delta_exec) {
+		new_vruntime += calc_delta_mine(delta_exec, NICE_0_LOAD,
+						&cfs_rq->load);
+	}
+
+	cfs_rq->min_vruntime = max_vruntime(new_vruntime, vruntime);
+}
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -513,7 +516,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 
 	curr->vruntime += delta_exec_weighted;
-	update_min_vruntime(cfs_rq);
+	update_min_vruntime(cfs_rq, delta_exec);
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -688,7 +691,7 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
-			if (tsk->in_iowait) {
+			if (tsk->sched_in_iowait) {
 				se->statistics.iowait_sum += delta;
 				se->statistics.iowait_count++;
 				trace_sched_stat_iowait(tsk, delta);
@@ -708,6 +711,7 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		}
 	}
 #endif
+	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
 static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -718,7 +722,7 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	if (d < 0)
 		d = -d;
 
-	if (d > 3*sysctl_sched_latency)
+	if (d > 3*cfs_rq->nr_running*sysctl_sched_latency)
 		schedstat_inc(cfs_rq, nr_spread_over);
 #endif
 }
@@ -738,7 +742,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 		vruntime += sched_vslice(cfs_rq, se);
 
 	/* sleeps up to a single latency don't count. */
-	if (!initial) {
+	if (sched_feat(FAIR_SLEEPERS) && !initial) {
 		unsigned long thresh = sysctl_sched_latency;
 
 		/*
@@ -752,9 +756,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	}
 
 	/* ensure we never gain time by being placed backwards. */
-	vruntime = max_vruntime(se->vruntime, vruntime);
-
-	se->vruntime = vruntime;
+	se->vruntime = max_vruntime(se->vruntime, vruntime);
 }
 
 static void
@@ -826,7 +828,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
-	update_min_vruntime(cfs_rq);
+	update_min_vruntime(cfs_rq, 0);
 
 	/*
 	 * Normalize the entity after updating the min_vruntime because the
@@ -837,44 +839,34 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		se->vruntime -= cfs_rq->min_vruntime;
 }
 
+static int
+wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
+
 /*
  * Preempt the current task with a newly woken task if needed:
  */
 static void
 check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
-	unsigned long ideal_runtime, delta_exec;
+	unsigned long slice = sched_slice(cfs_rq, curr);
+
+	if (curr->sum_exec_runtime - curr->prev_sum_exec_runtime < slice) {
+		struct sched_entity *pse = __pick_next_entity(cfs_rq);
+
+		if (pse && wakeup_preempt_entity(curr, pse) == 1)
+			goto preempt;
 
-	ideal_runtime = sched_slice(cfs_rq, curr);
-	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	if (delta_exec > ideal_runtime) {
-		resched_task(rq_of(cfs_rq)->curr);
-		/*
-		 * The current task ran long enough, ensure it doesn't get
-		 * re-elected due to buddy favours.
-		 */
-		clear_buddies(cfs_rq, curr);
 		return;
 	}
 
 	/*
-	 * Ensure that a task that missed wakeup preemption by a
-	 * narrow margin doesn't have to wait for a full slice.
-	 * This also mitigates buddy induced latencies under load.
+	 * The current task ran long enough, ensure it doesn't get
+	 * re-elected due to buddy favours.
 	 */
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
-
-	if (delta_exec < sysctl_sched_min_granularity)
-		return;
+	clear_buddies(cfs_rq, curr);
 
-	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se = __pick_next_entity(cfs_rq);
-		s64 delta = curr->vruntime - se->vruntime;
-
-		if (delta > ideal_runtime)
-			resched_task(rq_of(cfs_rq)->curr);
-	}
+preempt:
+	resched_task(rq_of(cfs_rq)->curr);
 }
 
 static void
@@ -893,36 +885,21 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	update_stats_curr_start(cfs_rq, se);
 	cfs_rq->curr = se;
-#ifdef CONFIG_SCHEDSTATS
-	/*
-	 * Track our maximum slice length, if the CPU's load is at
-	 * least twice that of our own weight (i.e. dont track it
-	 * when there are only lesser-weight tasks around):
-	 */
-	if (rq_of(cfs_rq)->load.weight >= 2*se->load.weight) {
-		se->statistics.slice_max = max(se->statistics.slice_max,
-			se->sum_exec_runtime - se->prev_sum_exec_runtime);
-	}
-#endif
-	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
-static int
-wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
-
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
 	struct sched_entity *left = se;
 
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
-		se = cfs_rq->next;
+	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
+		se = cfs_rq->last;
 
 	/*
-	 * Prefer last buddy, try to return the CPU to a preempted task.
+	 * Prefer the next buddy, only set through the interactivity logic.
 	 */
-	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
-		se = cfs_rq->last;
+	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
+		se = cfs_rq->next;
 
 	clear_buddies(cfs_rq, se);
 
@@ -931,6 +908,13 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
+	unsigned long slice = sched_slice(cfs_rq, prev);
+
+	prev->interactive = 0;
+
+	if (prev->sum_exec_runtime - prev->prev_sum_exec_runtime >= slice)
+		prev->prev_sum_exec_runtime += slice;
+
 	/*
 	 * If still on the runqueue then deactivate_task()
 	 * was not called and update_curr() has to be done:
@@ -1652,7 +1636,11 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
-	int scale = cfs_rq->nr_running >= sched_nr_latency;
+	/*
+	 * The buddy logic doesn't work well when there's not actually enough
+	 * tasks for there to be buddies.
+	 */
+	int buddies = (cfs_rq->nr_running >= 2);
 
 	if (unlikely(rt_prio(p->prio)))
 		goto preempt;
@@ -1663,8 +1651,16 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (unlikely(se == pse))
 		return;
 
-	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK))
+	if ((se->interactive || curr->sched_wake_interactive) &&
+			!p->sched_in_iowait)
+		pse->interactive = 1;
+
+	if (!(wake_flags & WF_FORK) && pse->interactive) {
+		clear_buddies(cfs_rq, NULL);
 		set_next_buddy(pse);
+		update_curr(cfs_rq);
+		goto preempt;
+	}
 
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
@@ -1709,7 +1705,7 @@ preempt:
 	if (unlikely(!se->on_rq || curr == rq->idle))
 		return;
 
-	if (sched_feat(LAST_BUDDY) && scale && entity_is_task(se))
+	if (sched_feat(LAST_BUDDY) && buddies && entity_is_task(se))
 		set_last_buddy(se);
 }
 
@@ -3404,11 +3400,13 @@ static void nohz_balancer_kick(int cpu)
 	}
 
 	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
-		struct call_single_data *cp;
-
 		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
-		cp = &per_cpu(remote_sched_softirq_cb, cpu);
-		__smp_call_function_single(ilb_cpu, cp, 0);
+
+		if (ilb_cpu != cpu) {
+			struct call_single_data *cp;
+			cp = &per_cpu(remote_sched_softirq_cb, cpu);
+			__smp_call_function_single(ilb_cpu, cp, 0);
+		}
 	}
 	return;
 }
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 83c66e8..33b81f9 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -3,13 +3,14 @@
  * them to run sooner, but does not allow tons of sleepers to
  * rip the spread apart.
  */
+SCHED_FEAT(FAIR_SLEEPERS, 0)
 SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 
 /*
  * Place new tasks ahead so that they do not starve already running
  * tasks
  */
-SCHED_FEAT(START_DEBIT, 1)
+SCHED_FEAT(START_DEBIT, 0)
 
 /*
  * Should wakeups try to preempt running tasks.
@@ -25,13 +26,6 @@ SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
 
 /*
- * Prefer to schedule the task we woke last (assuming it failed
- * wakeup-preemption), since its likely going to consume data we
- * touched, increases cache locality.
- */
-SCHED_FEAT(NEXT_BUDDY, 0)
-
-/*
  * Prefer to schedule the task that ran last (when we did
  * wake-preempt) as that likely will touch the same data, increases
  * cache locality.
@@ -55,6 +49,9 @@ SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(LB_SHARES_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 
+SCHED_FEAT(DYN_MIN_VRUNTIME, 1)
+SCHED_FEAT(INTERACTIVE, 1)
+
 /*
  * Spin-wait on mutex acquisition when the mutex owner is running on
  * another cpu -- assumes that when the owner is running, it will soon

