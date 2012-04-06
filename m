Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2DFHPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:15:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47661 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2DFHPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:15:37 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: [PATCH 13/16] sched: drafted deadline inheritance logic.
Date: Fri,  6 Apr 2012 09:14:38 +0200
Message-Id: <1333696481-3433-14-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

Some method to deal with rt-mutexes and make sched_dl interact with
the current PI-coded is needed, raising all but trivial issues, that
needs (according to us) to be solved with some restructuring of
the pi-code (i.e., going toward a proxy execution-ish implementation).

This is under development, in the meanwhile, as a temporary solution,
what this commits does is:
 - ensure a pi-lock owner with waiters is never throttled down. Instead,
   when it runs out of runtime, it immediately gets replenished and it's
   deadline is postponed;
 - the scheduling parameters (relative deadline and default runtime)
   used for that replenishments --during the whole period it holds the
   pi-lock-- are the ones of the waiting task with earliest deadline.

Acting this way, we provide some kind of boosting to the lock-owner,
still by using the existing (actually, slightly modified by the previous
commit) pi-architecture.

We would stress the fact that this is only a surely needed, all but
clean solution to the problem. In the end it's only a way to re-start
discussion within the community. So, as always, comments, ideas, rants,
etc.. are welcome! :-)

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 include/linux/sched.h |    9 +++++-
 kernel/fork.c         |    1 +
 kernel/rtmutex.c      |   13 +++++++-
 kernel/sched.c        |   34 ++++++++++++++++++---
 kernel/sched_dl.c     |   77 +++++++++++++++++++++++++++++++++---------------
 5 files changed, 102 insertions(+), 32 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5ef7bb6..ca45db4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1309,8 +1309,12 @@ struct sched_dl_entity {
 	 * @dl_new tells if a new instance arrived. If so we must
 	 * start executing it with full runtime and reset its absolute
 	 * deadline;
+	 *
+	 * @dl_boosted tells if we are boosted due to DI. If so we are
+	 * outside bandwidth enforcement mechanism (but only until we
+	 * exit the critical section).
 	 */
-	int dl_throttled, dl_new;
+	int dl_throttled, dl_new, dl_boosted;
 
 	/*
 	 * Bandwidth enforcement timer. Each -deadline task has its
@@ -1556,6 +1560,8 @@ struct task_struct {
 	struct rb_node *pi_waiters_leftmost;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
+	/* Top pi_waiters task */
+	struct task_struct *pi_top_task;
 #endif
 
 #ifdef CONFIG_DEBUG_MUTEXES
@@ -2236,6 +2242,7 @@ extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
+extern struct task_struct *rt_mutex_get_top_task(struct task_struct *task);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 344e0b4..b8b0dff 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1036,6 +1036,7 @@ static void rt_mutex_init_task(struct task_struct *p)
 	p->pi_waiters = RB_ROOT;
 	p->pi_waiters_leftmost = NULL;
 	p->pi_blocked_on = NULL;
+	p->pi_top_task = NULL;
 #endif
 }
 
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 6234c0e..cf155ba 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -217,6 +217,14 @@ int rt_mutex_getprio(struct task_struct *task)
 		   task->normal_prio);
 }
 
+struct task_struct *rt_mutex_get_top_task(struct task_struct *task)
+{
+	if (likely(!task_has_pi_waiters(task)))
+		return NULL;
+
+	return task_top_pi_waiter(task)->task;
+}
+
 /*
  * Adjust the priority of a task, after its pi_waiters got modified.
  *
@@ -226,7 +234,7 @@ static void __rt_mutex_adjust_prio(struct task_struct *task)
 {
 	int prio = rt_mutex_getprio(task);
 
-	if (task->prio != prio)
+	if (task->prio != prio || dl_prio(prio))
 		rt_mutex_setprio(task, prio);
 }
 
@@ -712,7 +720,8 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 
 	waiter = task->pi_blocked_on;
 	if (!rt_mutex_real_waiter(waiter) ||
-	    waiter->task->prio == task->prio) {
+	    (waiter->task->prio == task->prio &&
+	    !dl_prio(task->prio))) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index 00e69a0..3963e4e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5238,7 +5238,7 @@ EXPORT_SYMBOL(sleep_on_timeout);
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
-	int oldprio, on_rq, running;
+	int oldprio, on_rq, running, enqueue_flag = 0;
 	struct rq *rq;
 	const struct sched_class *prev_class;
 
@@ -5265,6 +5265,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	}
 
 	trace_sched_pi_setprio(p, prio);
+	p->pi_top_task = rt_mutex_get_top_task(p);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
 	on_rq = p->on_rq;
@@ -5274,19 +5275,42 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	if (dl_prio(prio))
+	/*
+	 * Boosting condition are:
+	 * 1. -rt task is running and holds mutex A
+	 *      --> -dl task blocks on mutex A
+	 *
+	 * 2. -dl task is running and holds mutex A
+	 *      --> -dl task blocks on mutex A and could preempt the
+	 *          running task
+	 */
+	if (dl_prio(prio)) {
+		if (!dl_prio(p->normal_prio) || (p->pi_top_task &&
+			dl_entity_preempt(&p->pi_top_task->dl, &p->dl))) {
+			p->dl.dl_boosted = 1;
+			p->dl.dl_throttled = 0;
+			enqueue_flag = ENQUEUE_REPLENISH;
+		} else
+			p->dl.dl_boosted = 0;
 		p->sched_class = &dl_sched_class;
-	else if (rt_prio(prio))
+	} else if (rt_prio(prio)) {
+		if (dl_prio(oldprio))
+			p->dl.dl_boosted = 0;
+		if (oldprio < prio)
+			enqueue_flag = ENQUEUE_HEAD;
 		p->sched_class = &rt_sched_class;
-	else
+	} else {
+		if (dl_prio(oldprio))
+			p->dl.dl_boosted = 0;
 		p->sched_class = &fair_sched_class;
+	}
 
 	p->prio = prio;
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
+		enqueue_task(rq, p, enqueue_flag);
 
 	check_class_changed(rq, p, prev_class, oldprio);
 out_unlock:
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 05140bb..e393292 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -224,15 +224,16 @@ static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
  * one, and to (try to!) reconcile itself with its own scheduling
  * parameters.
  */
-static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
+static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se,
+				       struct sched_dl_entity *pi_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
 	WARN_ON(!dl_se->dl_new || dl_se->dl_throttled);
 
-	dl_se->deadline = rq->clock + dl_se->dl_deadline;
-	dl_se->runtime = dl_se->dl_runtime;
+	dl_se->deadline = rq->clock + pi_se->dl_deadline;
+	dl_se->runtime = pi_se->dl_runtime;
 	dl_se->dl_new = 0;
 }
 
@@ -254,11 +255,23 @@ static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
  * could happen are, typically, a entity voluntarily trying to overcume its
  * runtime, or it just underestimated it during sched_setscheduler_ex().
  */
-static void replenish_dl_entity(struct sched_dl_entity *dl_se)
+static void replenish_dl_entity(struct sched_dl_entity *dl_se,
+				struct sched_dl_entity *pi_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
+	BUG_ON(pi_se->dl_runtime <= 0);
+
+	/*
+	 * This could be the case for a !-dl task that is boosted.
+	 * Just go with full inherited parameters.
+	 */
+	if (dl_se->dl_deadline == 0) {
+		dl_se->deadline = rq->clock + pi_se->dl_deadline;
+		dl_se->runtime = pi_se->dl_runtime;
+	}
+
 	/*
 	 * We Keep moving the deadline away until we get some
 	 * available runtime for the entity. This ensures correct
@@ -266,8 +279,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <= 0) {
-		dl_se->deadline += dl_se->dl_period;
-		dl_se->runtime += dl_se->dl_runtime;
+		dl_se->deadline += pi_se->dl_period;
+		dl_se->runtime += pi_se->dl_runtime;
 	}
 
 	/*
@@ -281,8 +294,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
 	 */
 	if (dl_time_before(dl_se->deadline, rq->clock)) {
 		WARN_ON_ONCE(1);
-		dl_se->deadline = rq->clock + dl_se->dl_deadline;
-		dl_se->runtime = dl_se->dl_runtime;
+		dl_se->deadline = rq->clock + pi_se->dl_deadline;
+		dl_se->runtime = pi_se->dl_runtime;
 	}
 }
 
@@ -299,7 +312,8 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se)
  * task with deadline equal to period this is the same of using
  * dl_deadline instead of dl_period in the equation above.
  */
-static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
+static bool dl_entity_overflow(struct sched_dl_entity *dl_se,
+			       struct sched_dl_entity *pi_se, u64 t)
 {
 	u64 left, right;
 
@@ -316,8 +330,8 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 	 * to the (absolute) deadline. Therefore, overflowing the u64
 	 * type is very unlikely to occur in both cases.
 	 */
-	left = dl_se->dl_period * dl_se->runtime;
-	right = (dl_se->deadline - t) * dl_se->dl_runtime;
+	left = pi_se->dl_deadline * dl_se->runtime;
+	right = (dl_se->deadline - t) * pi_se->dl_runtime;
 
 	return dl_time_before(right, left);
 }
@@ -331,7 +345,8 @@ static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
  *  - using the remaining runtime with the current deadline would make
  *    the entity exceed its bandwidth.
  */
-static void update_dl_entity(struct sched_dl_entity *dl_se)
+static void update_dl_entity(struct sched_dl_entity *dl_se,
+			     struct sched_dl_entity *pi_se)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
@@ -341,14 +356,14 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
 	 * the actual scheduling parameters have to be "renewed".
 	 */
 	if (dl_se->dl_new) {
-		setup_new_dl_entity(dl_se);
+		setup_new_dl_entity(dl_se, pi_se);
 		return;
 	}
 
 	if (dl_time_before(dl_se->deadline, rq->clock) ||
-	    dl_entity_overflow(dl_se, rq->clock)) {
-		dl_se->deadline = rq->clock + dl_se->dl_deadline;
-		dl_se->runtime = dl_se->dl_runtime;
+	    dl_entity_overflow(dl_se, pi_se, rq->clock)) {
+		dl_se->deadline = rq->clock + pi_se->dl_deadline;
+		dl_se->runtime = pi_se->dl_runtime;
 	}
 }
 
@@ -362,7 +377,7 @@ static void update_dl_entity(struct sched_dl_entity *dl_se)
  * actually started or not (i.e., the replenishment instant is in
  * the future or in the past).
  */
-static int start_dl_timer(struct sched_dl_entity *dl_se)
+static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
 {
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
@@ -371,6 +386,8 @@ static int start_dl_timer(struct sched_dl_entity *dl_se)
 	unsigned long range;
 	s64 delta;
 
+	if (boosted)
+		return 0;
 	/*
 	 * We want the timer to fire at the deadline, but considering
 	 * that it is actually coming from rq->clock and not from
@@ -540,7 +557,7 @@ static void update_curr_dl(struct rq *rq)
 	dl_se->runtime -= delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
-		if (likely(start_dl_timer(dl_se)))
+		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
 			dl_se->dl_throttled = 1;
 		else
 			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
@@ -695,7 +712,8 @@ static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
 }
 
 static void
-enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
+enqueue_dl_entity(struct sched_dl_entity *dl_se,
+		  struct sched_dl_entity *pi_se, int flags)
 {
 	BUG_ON(on_dl_rq(dl_se));
 
@@ -705,9 +723,9 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
 	 * we want a replenishment of its runtime.
 	 */
 	if (!dl_se->dl_new && flags & ENQUEUE_REPLENISH)
-		replenish_dl_entity(dl_se);
+		replenish_dl_entity(dl_se, pi_se);
 	else
-		update_dl_entity(dl_se);
+		update_dl_entity(dl_se, pi_se);
 
 	__enqueue_dl_entity(dl_se);
 }
@@ -719,6 +737,18 @@ static void dequeue_dl_entity(struct sched_dl_entity *dl_se)
 
 static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 {
+	struct task_struct *pi_task = p->pi_top_task;
+	struct sched_dl_entity *pi_se = &p->dl;
+
+	/*
+	 * Use the scheduling parameters of the top pi-waiter
+	 * task if we have one and its (relative) deadline is
+	 * smaller than our one... OTW we keep our runtime and
+	 * deadline.
+	 */
+	if (pi_task && p->dl.dl_boosted && dl_prio(pi_task->normal_prio))
+		pi_se = &pi_task->dl;
+
 	/*
 	 * If p is throttled, we do nothing. In fact, if it exhausted
 	 * its budget it needs a replenishment and, since it now is on
@@ -728,7 +758,7 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 	if (p->dl.dl_throttled)
 		return;
 
-	enqueue_dl_entity(&p->dl, flags);
+	enqueue_dl_entity(&p->dl, pi_se, flags);
 
 	if (!task_current(rq, p) && p->dl.nr_cpus_allowed > 1)
 		enqueue_pushable_dl_task(rq, p);
@@ -962,8 +992,7 @@ static void task_dead_dl(struct task_struct *p)
 {
 	struct hrtimer *timer = &p->dl.dl_timer;
 
-	if (hrtimer_active(timer))
-		hrtimer_try_to_cancel(timer);
+	hrtimer_try_to_cancel(timer);
 }
 
 static void set_curr_task_dl(struct rq *rq)
-- 
1.7.5.4

