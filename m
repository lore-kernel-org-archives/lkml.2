Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2DFHS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:18:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47661 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab2DFHPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:15:21 -0400
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
Subject: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
Date: Fri,  6 Apr 2012 09:14:30 +0200
Message-Id: <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

Add a scheduling class, in sched_dl.c and a new policy called
SCHED_DEADLINE. It is an implementation of the Earliest Deadline
First (EDF) scheduling algorithm, augmented with a mechanism (called
Constant Bandwidth Server, CBS) that makes it possible to isolate
the behaviour of tasks between each other.

The typical -deadline task will be made up of a computation phase
(instance) which is activated on a periodic or sporadic fashion. The
expected (maximum) duration of such computation is called the task's
runtime; the time interval by which each instance need to be completed
is called the task's relative deadline. The task's absolute deadline
is dynamically calculated as the time instant a task (better, an
instance) activates plus the relative deadline.

The EDF algorithms selects the task with the smallest absolute
deadline as the one to be executed first, while the CBS ensures each
task to run for at most its runtime every (relative) deadline
length time interval, avoiding any interference between different
tasks (bandwidth isolation).
Thanks to this feature, also tasks that do not strictly comply with
the computational model sketched above can effectively use the new
policy.

This patch:
 - implements the core logic of the scheduling algorithm in the new
   scheduling class file;
 - provides all the glue code between the new scheduling class and
   the core scheduler and refines the interactions between sched_dl
   and the other existing scheduling classes.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 include/linux/sched.h   |    2 +-
 kernel/fork.c           |    4 +-
 kernel/sched.c          |   67 +++++-
 kernel/sched_dl.c       |  655 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_rt.c       |    1 +
 kernel/sched_stoptask.c |    2 +-
 6 files changed, 719 insertions(+), 12 deletions(-)
 create mode 100644 kernel/sched_dl.c

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6eb72b6..416ce99 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2323,7 +2323,7 @@ extern void wake_up_new_task(struct task_struct *tsk);
 #else
  static inline void kick_process(struct task_struct *tsk) { }
 #endif
-extern void sched_fork(struct task_struct *p);
+extern int sched_fork(struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 extern void proc_caches_init(void);
diff --git a/kernel/fork.c b/kernel/fork.c
index e3db0cb..b263c69 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1241,7 +1241,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
-	sched_fork(p);
+	retval = sched_fork(p);
+	if (retval)
+		goto bad_fork_cleanup_policy;
 
 	retval = perf_event_init_task(p);
 	if (retval)
diff --git a/kernel/sched.c b/kernel/sched.c
index fd23c67..1a38ad1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1964,9 +1964,6 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
-static const struct sched_class rt_sched_class;
-static const struct sched_class dl_sched_class;
-
 #define sched_class_highest (&stop_sched_class)
 #define for_each_class(class) \
    for (class = sched_class_highest; class; class = class->next)
@@ -2257,6 +2254,7 @@ static int irqtime_account_si_update(void)
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_dl.c"
 #include "sched_autogroup.c"
 #include "sched_stoptask.c"
 #ifdef CONFIG_SCHED_DEBUG
@@ -3038,7 +3036,7 @@ static void __sched_fork(struct task_struct *p)
 /*
  * fork()/clone()-time setup:
  */
-void sched_fork(struct task_struct *p)
+int sched_fork(struct task_struct *p)
 {
 	unsigned long flags;
 	int cpu = get_cpu();
@@ -3077,8 +3075,14 @@ void sched_fork(struct task_struct *p)
 		p->sched_reset_on_fork = 0;
 	}
 
-	if (!rt_prio(p->prio))
+	if (dl_prio(p->prio)) {
+		put_cpu();
+		return -EAGAIN;
+	} else if (rt_prio(p->prio)) {
+		p->sched_class = &rt_sched_class;
+	} else {
 		p->sched_class = &fair_sched_class;
+	}
 
 	if (p->sched_class->task_fork)
 		p->sched_class->task_fork(p);
@@ -3111,6 +3115,7 @@ void sched_fork(struct task_struct *p)
 #endif
 
 	put_cpu();
+	return 0;
 }
 
 /*
@@ -5234,7 +5239,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	struct rq *rq;
 	const struct sched_class *prev_class;
 
-	BUG_ON(prio < 0 || prio > MAX_PRIO);
+	BUG_ON(prio > MAX_PRIO);
 
 	rq = __task_rq_lock(p);
 
@@ -5470,6 +5475,38 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 }
 
 /*
+ * This function initializes the sched_dl_entity of a newly becoming
+ * SCHED_DEADLINE task.
+ *
+ * Only the static values are considered here, the actual runtime and the
+ * absolute deadline will be properly calculated when the task is enqueued
+ * for the first time with its new policy.
+ */
+static void
+__setparam_dl(struct task_struct *p, const struct sched_param2 *param2)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	init_dl_task_timer(dl_se);
+	dl_se->dl_runtime = param2->sched_runtime;
+	dl_se->dl_deadline = param2->sched_deadline;
+	dl_se->flags = param2->sched_flags;
+	dl_se->dl_throttled = 0;
+	dl_se->dl_new = 1;
+}
+
+static void
+__getparam_dl(struct task_struct *p, struct sched_param2 *param2)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	param2->sched_priority = p->rt_priority;
+	param2->sched_runtime = dl_se->dl_runtime;
+	param2->sched_deadline = dl_se->dl_deadline;
+	param2->sched_flags = dl_se->flags;
+}
+
+/*
  * This function validates the new parameters of a -deadline task.
  * We ask for the deadline not being zero, and greater or equal
  * than the runtime.
@@ -5643,7 +5680,11 @@ recheck:
 
 	oldprio = p->prio;
 	prev_class = p->sched_class;
-	__setscheduler(rq, p, policy, param->sched_priority);
+	if (dl_policy(policy)) {
+		__setparam_dl(p, param);
+		__setscheduler(rq, p, policy, param->sched_priority);
+	} else
+		__setscheduler(rq, p, policy, param->sched_priority);
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
@@ -5743,8 +5784,11 @@ do_sched_setscheduler2(pid_t pid, int policy,
 	rcu_read_lock();
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
-	if (p != NULL)
+	if (p != NULL) {
+		if (dl_policy(policy))
+			lparam2.sched_priority = 0;
 		retval = sched_setscheduler2(p, policy, &lparam2);
+	}
 	rcu_read_unlock();
 
 	return retval;
@@ -5891,7 +5935,10 @@ SYSCALL_DEFINE2(sched_getparam2, pid_t, pid,
 	if (retval)
 		goto out_unlock;
 
-	lp.sched_priority = p->rt_priority;
+	if (task_has_dl_policy(p))
+		__getparam_dl(p, &lp);
+	else
+		lp.sched_priority = p->rt_priority;
 	rcu_read_unlock();
 
 	retval = copy_to_user(param2, &lp,
@@ -6290,6 +6337,7 @@ SYSCALL_DEFINE1(sched_get_priority_max, int, policy)
 	case SCHED_RR:
 		ret = MAX_USER_RT_PRIO-1;
 		break;
+	case SCHED_DEADLINE:
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
@@ -6315,6 +6363,7 @@ SYSCALL_DEFINE1(sched_get_priority_min, int, policy)
 	case SCHED_RR:
 		ret = 1;
 		break;
+	case SCHED_DEADLINE:
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
new file mode 100644
index 0000000..604e2bc
--- /dev/null
+++ b/kernel/sched_dl.c
@@ -0,0 +1,655 @@
+/*
+ * Deadline Scheduling Class (SCHED_DEADLINE)
+ *
+ * Earliest Deadline First (EDF) + Constant Bandwidth Server (CBS).
+ *
+ * Tasks that periodically executes their instances for less than their
+ * runtime won't miss any of their deadlines.
+ * Tasks that are not periodic or sporadic or that tries to execute more
+ * than their reserved bandwidth will be slowed down (and may potentially
+ * miss some of their deadlines), and won't affect any other task.
+ *
+ * Copyright (C) 2010 Dario Faggioli <raistlin@linux.it>,
+ *                    Michael Trimarchi <michael@amarulasolutions.com>,
+ *                    Fabio Checconi <fabio@gandalf.sssup.it>
+ */
+static const struct sched_class dl_sched_class;
+
+static inline int dl_time_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
+static inline struct task_struct *dl_task_of(struct sched_dl_entity *dl_se)
+{
+	return container_of(dl_se, struct task_struct, dl);
+}
+
+static inline struct rq *rq_of_dl_rq(struct dl_rq *dl_rq)
+{
+	return container_of(dl_rq, struct rq, dl);
+}
+
+static inline struct dl_rq *dl_rq_of_se(struct sched_dl_entity *dl_se)
+{
+	struct task_struct *p = dl_task_of(dl_se);
+	struct rq *rq = task_rq(p);
+
+	return &rq->dl;
+}
+
+static inline int on_dl_rq(struct sched_dl_entity *dl_se)
+{
+	return !RB_EMPTY_NODE(&dl_se->rb_node);
+}
+
+static inline int is_leftmost(struct task_struct *p, struct dl_rq *dl_rq)
+{
+	struct sched_dl_entity *dl_se = &p->dl;
+
+	return dl_rq->rb_leftmost == &dl_se->rb_node;
+}
+
+static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags);
+static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags);
+static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
+				  int flags);
+
+/*
+ * We are being explicitly informed that a new instance is starting,
+ * and this means that:
+ *  - the absolute deadline of the entity has to be placed at
+ *    current time + relative deadline;
+ *  - the runtime of the entity has to be set to the maximum value.
+ *
+ * The capability of specifying such event is useful whenever a -deadline
+ * entity wants to (try to!) synchronize its behaviour with the scheduler's
+ * one, and to (try to!) reconcile itself with its own scheduling
+ * parameters.
+ */
+static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+	struct rq *rq = rq_of_dl_rq(dl_rq);
+
+	WARN_ON(!dl_se->dl_new || dl_se->dl_throttled);
+
+	dl_se->deadline = rq->clock + dl_se->dl_deadline;
+	dl_se->runtime = dl_se->dl_runtime;
+	dl_se->dl_new = 0;
+}
+
+/*
+ * Pure Earliest Deadline First (EDF) scheduling does not deal with the
+ * possibility of a entity lasting more than what it declared, and thus
+ * exhausting its runtime.
+ *
+ * Here we are interested in making runtime overrun possible, but we do
+ * not want a entity which is misbehaving to affect the scheduling of all
+ * other entities.
+ * Therefore, a budgeting strategy called Constant Bandwidth Server (CBS)
+ * is used, in order to confine each entity within its own bandwidth.
+ *
+ * This function deals exactly with that, and ensures that when the runtime
+ * of a entity is replenished, its deadline is also postponed. That ensures
+ * the overrunning entity can't interfere with other entity in the system and
+ * can't make them miss their deadlines. Reasons why this kind of overruns
+ * could happen are, typically, a entity voluntarily trying to overcume its
+ * runtime, or it just underestimated it during sched_setscheduler_ex().
+ */
+static void replenish_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+	struct rq *rq = rq_of_dl_rq(dl_rq);
+
+	/*
+	 * We Keep moving the deadline away until we get some
+	 * available runtime for the entity. This ensures correct
+	 * handling of situations where the runtime overrun is
+	 * arbitrary large.
+	 */
+	while (dl_se->runtime <= 0) {
+		dl_se->deadline += dl_se->dl_deadline;
+		dl_se->runtime += dl_se->dl_runtime;
+	}
+
+	/*
+	 * At this point, the deadline really should be "in
+	 * the future" with respect to rq->clock. If it's
+	 * not, we are, for some reason, lagging too much!
+	 * Anyway, after having warn userspace abut that,
+	 * we still try to keep the things running by
+	 * resetting the deadline and the budget of the
+	 * entity.
+	 */
+	if (dl_time_before(dl_se->deadline, rq->clock)) {
+		WARN_ON_ONCE(1);
+		dl_se->deadline = rq->clock + dl_se->dl_deadline;
+		dl_se->runtime = dl_se->dl_runtime;
+	}
+}
+
+/*
+ * Here we check if --at time t-- an entity (which is probably being
+ * [re]activated or, in general, enqueued) can use its remaining runtime
+ * and its current deadline _without_ exceeding the bandwidth it is
+ * assigned (function returns true if it can).
+ *
+ * For this to hold, we must check if:
+ *   runtime / (deadline - t) < dl_runtime / dl_deadline .
+ */
+static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
+{
+	u64 left, right;
+
+	/*
+	 * left and right are the two sides of the equation above,
+	 * after a bit of shuffling to use multiplications instead
+	 * of divisions.
+	 *
+	 * Note that none of the time values involved in the two
+	 * multiplications are absolute: dl_deadline and dl_runtime
+	 * are the relative deadline and the maximum runtime of each
+	 * instance, runtime is the runtime left for the last instance
+	 * and (deadline - t), since t is rq->clock, is the time left
+	 * to the (absolute) deadline. Therefore, overflowing the u64
+	 * type is very unlikely to occur in both cases.
+	 */
+	left = dl_se->dl_deadline * dl_se->runtime;
+	right = (dl_se->deadline - t) * dl_se->dl_runtime;
+
+	return dl_time_before(right, left);
+}
+
+/*
+ * When a -deadline entity is queued back on the runqueue, its runtime and
+ * deadline might need updating.
+ *
+ * The policy here is that we update the deadline of the entity only if:
+ *  - the current deadline is in the past,
+ *  - using the remaining runtime with the current deadline would make
+ *    the entity exceed its bandwidth.
+ */
+static void update_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+	struct rq *rq = rq_of_dl_rq(dl_rq);
+
+	/*
+	 * The arrival of a new instance needs special treatment, i.e.,
+	 * the actual scheduling parameters have to be "renewed".
+	 */
+	if (dl_se->dl_new) {
+		setup_new_dl_entity(dl_se);
+		return;
+	}
+
+	if (dl_time_before(dl_se->deadline, rq->clock) ||
+	    dl_entity_overflow(dl_se, rq->clock)) {
+		dl_se->deadline = rq->clock + dl_se->dl_deadline;
+		dl_se->runtime = dl_se->dl_runtime;
+	}
+}
+
+/*
+ * If the entity depleted all its runtime, and if we want it to sleep
+ * while waiting for some new execution time to become available, we
+ * set the bandwidth enforcement timer to the replenishment instant
+ * and try to activate it.
+ *
+ * Notice that it is important for the caller to know if the timer
+ * actually started or not (i.e., the replenishment instant is in
+ * the future or in the past).
+ */
+static int start_dl_timer(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+	struct rq *rq = rq_of_dl_rq(dl_rq);
+	ktime_t now, act;
+	ktime_t soft, hard;
+	unsigned long range;
+	s64 delta;
+
+	/*
+	 * We want the timer to fire at the deadline, but considering
+	 * that it is actually coming from rq->clock and not from
+	 * hrtimer's time base reading.
+	 */
+	act = ns_to_ktime(dl_se->deadline);
+	now = hrtimer_cb_get_time(&dl_se->dl_timer);
+	delta = ktime_to_ns(now) - rq->clock;
+	act = ktime_add_ns(act, delta);
+
+	/*
+	 * If the expiry time already passed, e.g., because the value
+	 * chosen as the deadline is too small, don't even try to
+	 * start the timer in the past!
+	 */
+	if (ktime_us_delta(act, now) < 0)
+		return 0;
+
+	hrtimer_set_expires(&dl_se->dl_timer, act);
+
+	soft = hrtimer_get_softexpires(&dl_se->dl_timer);
+	hard = hrtimer_get_expires(&dl_se->dl_timer);
+	range = ktime_to_ns(ktime_sub(hard, soft));
+	__hrtimer_start_range_ns(&dl_se->dl_timer, soft,
+				 range, HRTIMER_MODE_ABS, 0);
+
+	return hrtimer_active(&dl_se->dl_timer);
+}
+
+/*
+ * This is the bandwidth enforcement timer callback. If here, we know
+ * a task is not on its dl_rq, since the fact that the timer was running
+ * means the task is throttled and needs a runtime replenishment.
+ *
+ * However, what we actually do depends on the fact the task is active,
+ * (it is on its rq) or has been removed from there by a call to
+ * dequeue_task_dl(). In the former case we must issue the runtime
+ * replenishment and add the task back to the dl_rq; in the latter, we just
+ * do nothing but clearing dl_throttled, so that runtime and deadline
+ * updating (and the queueing back to dl_rq) will be done by the
+ * next call to enqueue_task_dl().
+ */
+static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
+{
+	unsigned long flags;
+	struct sched_dl_entity *dl_se = container_of(timer,
+						     struct sched_dl_entity,
+						     dl_timer);
+	struct task_struct *p = dl_task_of(dl_se);
+	struct rq *rq = task_rq_lock(p, &flags);
+
+	/*
+	 * We need to take care of a possible races here. In fact, the
+	 * task might have changed its scheduling policy to something
+	 * different from SCHED_DEADLINE (through sched_setscheduler()).
+	 */
+	if (!dl_task(p))
+		goto unlock;
+
+	dl_se->dl_throttled = 0;
+	if (p->on_rq) {
+		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
+		if (task_has_dl_policy(rq->curr))
+			check_preempt_curr_dl(rq, p, 0);
+		else
+			resched_task(rq->curr);
+	}
+unlock:
+	task_rq_unlock(rq, p, &flags);
+
+	return HRTIMER_NORESTART;
+}
+
+static void init_dl_task_timer(struct sched_dl_entity *dl_se)
+{
+	struct hrtimer *timer = &dl_se->dl_timer;
+
+	if (hrtimer_active(timer)) {
+		hrtimer_try_to_cancel(timer);
+		return;
+	}
+
+	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	timer->function = dl_task_timer;
+	timer->irqsafe = 1;
+}
+
+static
+int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
+{
+	int dmiss = dl_time_before(dl_se->deadline, rq->clock);
+	int rorun = dl_se->runtime <= 0;
+
+	if (!rorun && !dmiss)
+		return 0;
+
+	/*
+	 * If we are beyond our current deadline and we are still
+	 * executing, then we have already used some of the runtime of
+	 * the next instance. Thus, if we do not account that, we are
+	 * stealing bandwidth from the system at each deadline miss!
+	 */
+	if (dmiss) {
+		dl_se->runtime = rorun ? dl_se->runtime : 0;
+		dl_se->runtime -= rq->clock - dl_se->deadline;
+	}
+
+	return 1;
+}
+
+/*
+ * Update the current task's runtime statistics (provided it is still
+ * a -deadline task and has not been removed from the dl_rq).
+ */
+static void update_curr_dl(struct rq *rq)
+{
+	struct task_struct *curr = rq->curr;
+	struct sched_dl_entity *dl_se = &curr->dl;
+	u64 delta_exec;
+
+	if (!dl_task(curr) || !on_dl_rq(dl_se))
+		return;
+
+	delta_exec = rq->clock_task - curr->se.exec_start;
+	if (unlikely((s64)delta_exec < 0))
+		delta_exec = 0;
+
+	schedstat_set(curr->se.statistics.exec_max,
+		      max(curr->se.statistics.exec_max, delta_exec));
+
+	curr->se.sum_exec_runtime += delta_exec;
+	account_group_exec_runtime(curr, delta_exec);
+
+	curr->se.exec_start = rq->clock;
+	cpuacct_charge(curr, delta_exec);
+
+	dl_se->runtime -= delta_exec;
+	if (dl_runtime_exceeded(rq, dl_se)) {
+		__dequeue_task_dl(rq, curr, 0);
+		if (likely(start_dl_timer(dl_se)))
+			dl_se->dl_throttled = 1;
+		else
+			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
+
+		if (!is_leftmost(curr, &rq->dl))
+			resched_task(curr);
+	}
+}
+
+static void __enqueue_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+	struct rb_node **link = &dl_rq->rb_root.rb_node;
+	struct rb_node *parent = NULL;
+	struct sched_dl_entity *entry;
+	int leftmost = 1;
+
+	BUG_ON(!RB_EMPTY_NODE(&dl_se->rb_node));
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct sched_dl_entity, rb_node);
+		if (dl_time_before(dl_se->deadline, entry->deadline))
+			link = &parent->rb_left;
+		else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		dl_rq->rb_leftmost = &dl_se->rb_node;
+
+	rb_link_node(&dl_se->rb_node, parent, link);
+	rb_insert_color(&dl_se->rb_node, &dl_rq->rb_root);
+
+	dl_rq->dl_nr_running++;
+}
+
+static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
+
+	if (RB_EMPTY_NODE(&dl_se->rb_node))
+		return;
+
+	if (dl_rq->rb_leftmost == &dl_se->rb_node) {
+		struct rb_node *next_node;
+
+		next_node = rb_next(&dl_se->rb_node);
+		dl_rq->rb_leftmost = next_node;
+	}
+
+	rb_erase(&dl_se->rb_node, &dl_rq->rb_root);
+	RB_CLEAR_NODE(&dl_se->rb_node);
+
+	dl_rq->dl_nr_running--;
+}
+
+static void
+enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
+{
+	BUG_ON(on_dl_rq(dl_se));
+
+	/*
+	 * If this is a wakeup or a new instance, the scheduling
+	 * parameters of the task might need updating. Otherwise,
+	 * we want a replenishment of its runtime.
+	 */
+	if (!dl_se->dl_new && flags & ENQUEUE_REPLENISH)
+		replenish_dl_entity(dl_se);
+	else
+		update_dl_entity(dl_se);
+
+	__enqueue_dl_entity(dl_se);
+}
+
+static void dequeue_dl_entity(struct sched_dl_entity *dl_se)
+{
+	__dequeue_dl_entity(dl_se);
+}
+
+static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
+{
+	/*
+	 * If p is throttled, we do nothing. In fact, if it exhausted
+	 * its budget it needs a replenishment and, since it now is on
+	 * its rq, the bandwidth timer callback (which clearly has not
+	 * run yet) will take care of this.
+	 */
+	if (p->dl.dl_throttled)
+		return;
+
+	enqueue_dl_entity(&p->dl, flags);
+}
+
+static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
+{
+	dequeue_dl_entity(&p->dl);
+}
+
+static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
+{
+	update_curr_dl(rq);
+	__dequeue_task_dl(rq, p, flags);
+}
+
+/*
+ * Yield task semantic for -deadline tasks is:
+ *
+ *   get off from the CPU until our next instance, with
+ *   a new runtime.
+ */
+static void yield_task_dl(struct rq *rq)
+{
+	struct task_struct *p = rq->curr;
+
+	/*
+	 * We make the task go to sleep until its current deadline by
+	 * forcing its runtime to zero. This way, update_curr_dl() stops
+	 * it and the bandwidth timer will wake it up and will give it
+	 * new scheduling parameters (thanks to dl_new=1).
+	 */
+	if (p->dl.runtime > 0) {
+		rq->curr->dl.dl_new = 1;
+		p->dl.runtime = 0;
+	}
+	update_curr_dl(rq);
+}
+
+/*
+ * Only called when both the current and waking task are -deadline
+ * tasks.
+ */
+static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
+				  int flags)
+{
+	if (dl_time_before(p->dl.deadline, rq->curr->dl.deadline))
+		resched_task(rq->curr);
+}
+
+#ifdef CONFIG_SCHED_HRTICK
+static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
+{
+	s64 delta = p->dl.dl_runtime - p->dl.runtime;
+
+	if (delta > 10000)
+		hrtick_start(rq, delta);
+}
+#else
+static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
+{
+}
+#endif
+
+static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
+						   struct dl_rq *dl_rq)
+{
+	struct rb_node *left = dl_rq->rb_leftmost;
+
+	if (!left)
+		return NULL;
+
+	return rb_entry(left, struct sched_dl_entity, rb_node);
+}
+
+struct task_struct *pick_next_task_dl(struct rq *rq)
+{
+	struct sched_dl_entity *dl_se;
+	struct task_struct *p;
+	struct dl_rq *dl_rq;
+
+	dl_rq = &rq->dl;
+
+	if (unlikely(!dl_rq->dl_nr_running))
+		return NULL;
+
+	dl_se = pick_next_dl_entity(rq, dl_rq);
+	BUG_ON(!dl_se);
+
+	p = dl_task_of(dl_se);
+	p->se.exec_start = rq->clock;
+#ifdef CONFIG_SCHED_HRTICK
+	if (hrtick_enabled(rq))
+		start_hrtick_dl(rq, p);
+#endif
+	return p;
+}
+
+static void put_prev_task_dl(struct rq *rq, struct task_struct *p)
+{
+	update_curr_dl(rq);
+	p->se.exec_start = 0;
+}
+
+static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
+{
+	update_curr_dl(rq);
+
+#ifdef CONFIG_SCHED_HRTICK
+	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
+		start_hrtick_dl(rq, p);
+#endif
+}
+
+static void task_fork_dl(struct task_struct *p)
+{
+	/*
+	 * SCHED_DEADLINE tasks cannot fork and this is achieved through
+	 * sched_fork()
+	 */
+}
+
+static void task_dead_dl(struct task_struct *p)
+{
+	struct hrtimer *timer = &p->dl.dl_timer;
+
+	if (hrtimer_active(timer))
+		hrtimer_try_to_cancel(timer);
+}
+
+static void set_curr_task_dl(struct rq *rq)
+{
+	struct task_struct *p = rq->curr;
+
+	p->se.exec_start = rq->clock;
+}
+
+static void switched_from_dl(struct rq *rq, struct task_struct *p)
+{
+	if (hrtimer_active(&p->dl.dl_timer))
+		hrtimer_try_to_cancel(&p->dl.dl_timer);
+}
+
+static void switched_to_dl(struct rq *rq, struct task_struct *p)
+{
+	/*
+	 * If p is throttled, don't consider the possibility
+	 * of preempting rq->curr, the check will be done right
+	 * after its runtime will get replenished.
+	 */
+	if (unlikely(p->dl.dl_throttled))
+		return;
+
+	if (!p->on_rq || rq->curr != p) {
+		if (task_has_dl_policy(rq->curr))
+			check_preempt_curr_dl(rq, p, 0);
+		else
+			resched_task(rq->curr);
+	}
+}
+
+static void prio_changed_dl(struct rq *rq, struct task_struct *p,
+			    int oldprio)
+{
+	switched_to_dl(rq, p);
+}
+
+#ifdef CONFIG_SMP
+static int
+select_task_rq_dl(struct task_struct *p, int sd_flag, int flags)
+{
+	return task_cpu(p);
+}
+
+static void set_cpus_allowed_dl(struct task_struct *p,
+				const struct cpumask *new_mask)
+{
+	int weight = cpumask_weight(new_mask);
+
+	BUG_ON(!dl_task(p));
+
+	cpumask_copy(&p->cpus_allowed, new_mask);
+	p->dl.nr_cpus_allowed = weight;
+}
+#endif
+
+static const struct sched_class dl_sched_class = {
+	.next			= &rt_sched_class,
+	.enqueue_task		= enqueue_task_dl,
+	.dequeue_task		= dequeue_task_dl,
+	.yield_task		= yield_task_dl,
+
+	.check_preempt_curr	= check_preempt_curr_dl,
+
+	.pick_next_task		= pick_next_task_dl,
+	.put_prev_task		= put_prev_task_dl,
+
+#ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_dl,
+
+	.set_cpus_allowed       = set_cpus_allowed_dl,
+#endif
+
+	.set_curr_task		= set_curr_task_dl,
+	.task_tick		= task_tick_dl,
+	.task_fork              = task_fork_dl,
+	.task_dead		= task_dead_dl,
+
+	.prio_changed           = prio_changed_dl,
+	.switched_from		= switched_from_dl,
+	.switched_to		= switched_to_dl,
+};
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index c108b9c..4b09704 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -2,6 +2,7 @@
  * Real-Time Scheduling Class (mapped to the SCHED_FIFO and SCHED_RR
  * policies)
  */
+static const struct sched_class rt_sched_class;
 
 #ifdef CONFIG_RT_GROUP_SCHED
 
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 8b44e7f..4270a36 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -81,7 +81,7 @@ get_rr_interval_stop(struct rq *rq, struct task_struct *task)
  * Simple, special scheduling class for the per-CPU stop tasks:
  */
 static const struct sched_class stop_sched_class = {
-	.next			= &rt_sched_class,
+	.next			= &dl_sched_class,
 
 	.enqueue_task		= enqueue_task_stop,
 	.dequeue_task		= dequeue_task_stop,
-- 
1.7.5.4

