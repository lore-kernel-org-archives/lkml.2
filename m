Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0J2Gac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:30:32 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:53975 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754177Ab0J2Ga0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:30:26 -0400
Subject: [RFC][PATCH 05/22] sched: SCHED_DEADLINE policy implementation
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333128.8661.137.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2bSpOfLDQAhEKgF++YcF"
Date: Fri, 29 Oct 2010 08:30:14 +0200
Message-ID: <1288333814.8661.146.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2bSpOfLDQAhEKgF++YcF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


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
task to run for at most the its runtime every (relative) deadline
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
Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
---
 kernel/sched.c          |   67 +++++-
 kernel/sched_dl.c       |  643 +++++++++++++++++++++++++++++++++++++++++++=
++++
 kernel/sched_fair.c     |    2 +-
 kernel/sched_rt.c       |    5 +
 kernel/sched_stoptask.c |    2 +-
 5 files changed, 711 insertions(+), 8 deletions(-)
 create mode 100644 kernel/sched_dl.c

diff --git a/kernel/sched.c b/kernel/sched.c
index b11e888..208fa08 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1928,6 +1928,12 @@ static void dec_nr_running(struct rq *rq)
=20
 static void set_load_weight(struct task_struct *p)
 {
+	if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
+		p->se.load.weight =3D 0;
+		p->se.load.inv_weight =3D WMULT_CONST;
+		return;
+	}
+
 	/*
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
@@ -2072,6 +2078,7 @@ static void sched_irq_time_avg_update(struct rq *rq, =
u64 curr_irq_time) { }
 #include "sched_idletask.c"
 #include "sched_fair.c"
 #include "sched_rt.c"
+#include "sched_dl.c"
 #include "sched_stoptask.c"
 #ifdef CONFIG_SCHED_DEBUG
 # include "sched_debug.c"
@@ -2750,7 +2757,11 @@ void sched_fork(struct task_struct *p, int clone_fla=
gs)
 	 */
 	p->prio =3D current->normal_prio;
=20
-	if (!rt_prio(p->prio))
+	if (dl_prio(p->prio))
+		p->sched_class =3D &dl_sched_class;
+	else if (rt_prio(p->prio))
+		p->sched_class =3D &rt_sched_class;
+	else
 		p->sched_class =3D &fair_sched_class;
=20
 	if (p->sched_class->task_fork)
@@ -4530,8 +4541,6 @@ long __sched sleep_on_timeout(wait_queue_head_t *q, l=
ong timeout)
 }
 EXPORT_SYMBOL(sleep_on_timeout);
=20
-static const struct sched_class dl_sched_class;
-
 #ifdef CONFIG_RT_MUTEXES
=20
 /*
@@ -4760,6 +4769,40 @@ __setscheduler(struct rq *rq, struct task_struct *p,=
 int policy, int prio)
 }
=20
 /*
+ * This function initializes the sched_dl_entity of a newly becoming
+ * SCHED_DEADLINE task.
+ *
+ * Only the static values are considered here, the actual runtime and the
+ * absolute deadline will be properly calculated when the task is enqueued
+ * for the first time with its new policy.
+ */
+static void
+__setparam_dl(struct task_struct *p, const struct sched_param_ex *param_ex=
)
+{
+	struct sched_dl_entity *dl_se =3D &p->dl;
+
+	init_dl_task_timer(dl_se);
+	dl_se->dl_runtime =3D timespec_to_ns(&param_ex->sched_runtime);
+	dl_se->dl_deadline =3D timespec_to_ns(&param_ex->sched_deadline);
+	dl_se->flags =3D param_ex->sched_flags;
+	dl_se->dl_throttled =3D 0;
+	dl_se->dl_new =3D 1;
+}
+
+static void
+__getparam_dl(struct task_struct *p, struct sched_param_ex *param_ex)
+{
+	struct sched_dl_entity *dl_se =3D &p->dl;
+
+	param_ex->sched_priority =3D p->rt_priority;
+	param_ex->sched_runtime =3D ns_to_timespec(dl_se->dl_runtime);
+	param_ex->sched_deadline =3D ns_to_timespec(dl_se->dl_deadline);
+	param_ex->sched_flags =3D dl_se->flags;
+	param_ex->curr_runtime =3D ns_to_timespec(dl_se->runtime);
+	param_ex->curr_deadline =3D ns_to_timespec(dl_se->deadline);
+}
+
+/*
  * This function validates the new parameters of a -deadline task.
  * We ask for the deadline not being zero, and greater or equal
  * than the runtime.
@@ -4922,7 +4965,11 @@ recheck:
=20
 	oldprio =3D p->prio;
 	prev_class =3D p->sched_class;
-	__setscheduler(rq, p, policy, param->sched_priority);
+	if (dl_policy(policy)) {
+		__setparam_dl(p, param_ex);
+		__setscheduler(rq, p, policy, param_ex->sched_priority);
+	} else
+		__setscheduler(rq, p, policy, param->sched_priority);
=20
 	if (running)
 		p->sched_class->set_curr_task(rq);
@@ -5043,7 +5090,10 @@ do_sched_setscheduler_ex(pid_t pid, int policy, unsi=
gned len,
 	retval =3D -ESRCH;
 	p =3D find_process_by_pid(pid);
 	if (p !=3D NULL) {
-		lparam.sched_priority =3D lparam_ex.sched_priority;
+		if (dl_policy(policy))
+			lparam.sched_priority =3D 0;
+		else
+			lparam.sched_priority =3D lparam_ex.sched_priority;
 		retval =3D sched_setscheduler_ex(p, policy, &lparam, &lparam_ex);
 	}
 	rcu_read_unlock();
@@ -5197,7 +5247,10 @@ SYSCALL_DEFINE3(sched_getparam_ex, pid_t, pid, unsig=
ned, len,
 	if (retval)
 		goto out_unlock;
=20
-	lp.sched_priority =3D p->rt_priority;
+	if (task_has_dl_policy(p))
+		__getparam_dl(p, &lp);
+	else
+		lp.sched_priority =3D p->rt_priority;
 	rcu_read_unlock();
=20
 	retval =3D copy_to_user(param_ex, &lp, len) ? -EFAULT : 0;
@@ -5523,6 +5576,7 @@ SYSCALL_DEFINE1(sched_get_priority_max, int, policy)
 	case SCHED_RR:
 		ret =3D MAX_USER_RT_PRIO-1;
 		break;
+	case SCHED_DEADLINE:
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
@@ -5548,6 +5602,7 @@ SYSCALL_DEFINE1(sched_get_priority_min, int, policy)
 	case SCHED_RR:
 		ret =3D 1;
 		break;
+	case SCHED_DEADLINE:
 	case SCHED_NORMAL:
 	case SCHED_BATCH:
 	case SCHED_IDLE:
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
new file mode 100644
index 0000000..9d0443e
--- /dev/null
+++ b/kernel/sched_dl.c
@@ -0,0 +1,643 @@
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
+ *                    Michael Trimarchi <trimarchimichael@yahoo.it>,
+ *                    Fabio Checconi <fabio@gandalf.sssup.it>
+ */
+
+static inline int dl_time_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
+static inline struct task_struct *dl_task_of(struct sched_dl_entity *dl_se=
)
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
+	struct task_struct *p =3D dl_task_of(dl_se);
+	struct rq *rq =3D task_rq(p);
+
+	return &rq->dl;
+}
+
+static inline int on_dl_rq(struct sched_dl_entity *dl_se)
+{
+	return !RB_EMPTY_NODE(&dl_se->rb_node);
+}
+
+static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flag=
s);
+static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int fl=
ags);
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
+ * entity wants to (try to!) synchronize its behaviour with the scheduler'=
s
+ * one, and to (try to!) reconcile itself with its own scheduling
+ * parameters.
+ */
+static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_dl_rq(dl_rq);
+
+	WARN_ON(!dl_se->dl_new || dl_se->dl_throttled);
+
+	dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
+	dl_se->runtime =3D dl_se->dl_runtime;
+	dl_se->dl_new =3D 0;
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
+ * This function deals exactly with that, and ensures that when the runtim=
e
+ * of a entity is replenished, its deadline is also postponed. That ensure=
s
+ * the overrunning entity can't interfere with other entity in the system =
and
+ * can't make them miss their deadlines. Reasons why this kind of overruns
+ * could happen are, typically, a entity voluntarily trying to overcume it=
s
+ * runtime, or it just underestimated it during sched_setscheduler_ex().
+ */
+static void replenish_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_dl_rq(dl_rq);
+
+	/*
+	 * We Keep moving the deadline away until we get some
+	 * available runtime for the entity. This ensures correct
+	 * handling of situations where the runtime overrun is
+	 * arbitrary large.
+	 */
+	while (dl_se->runtime <=3D 0) {
+		dl_se->deadline +=3D dl_se->dl_deadline;
+		dl_se->runtime +=3D dl_se->dl_runtime;
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
+		dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
+		dl_se->runtime =3D dl_se->dl_runtime;
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
+	left =3D dl_se->dl_deadline * dl_se->runtime;
+	right =3D (dl_se->deadline - t) * dl_se->dl_runtime;
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
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_dl_rq(dl_rq);
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
+		dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
+		dl_se->runtime =3D dl_se->dl_runtime;
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
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+	struct rq *rq =3D rq_of_dl_rq(dl_rq);
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
+	act =3D ns_to_ktime(dl_se->deadline);
+	now =3D hrtimer_cb_get_time(&dl_se->dl_timer);
+	delta =3D ktime_to_ns(now) - rq->clock;
+	act =3D ktime_add_ns(act, delta);
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
+	soft =3D hrtimer_get_softexpires(&dl_se->dl_timer);
+	hard =3D hrtimer_get_expires(&dl_se->dl_timer);
+	range =3D ktime_to_ns(ktime_sub(hard, soft));
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
+ * replenishment and add the task back to the dl_rq; in the latter, we jus=
t
+ * do nothing but clearing dl_throttled, so that runtime and deadline
+ * updating (and the queueing back to dl_rq) will be done by the
+ * next call to enqueue_task_dl().
+ */
+static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
+{
+	unsigned long flags;
+	struct sched_dl_entity *dl_se =3D container_of(timer,
+						     struct sched_dl_entity,
+						     dl_timer);
+	struct task_struct *p =3D dl_task_of(dl_se);
+	struct rq *rq =3D task_rq_lock(p, &flags);
+
+	/*
+	 * We need to take care of a possible races here. In fact, the
+	 * task might have changed its scheduling policy to something
+	 * different from SCHED_DEADLINE (through sched_setscheduler()).
+	 */
+	if (!dl_task(p))
+		goto unlock;
+
+	dl_se->dl_throttled =3D 0;
+	if (p->se.on_rq) {
+		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
+		check_preempt_curr_dl(rq, p, 0);
+	}
+unlock:
+	task_rq_unlock(rq, &flags);
+
+	return HRTIMER_NORESTART;
+}
+
+static void init_dl_task_timer(struct sched_dl_entity *dl_se)
+{
+	struct hrtimer *timer =3D &dl_se->dl_timer;
+
+	if (hrtimer_active(timer)) {
+		hrtimer_try_to_cancel(timer);
+		return;
+	}
+
+	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	timer->function =3D dl_task_timer;
+}
+
+static
+int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
+{
+	int dmiss =3D dl_time_before(dl_se->deadline, rq->clock);
+	int rorun =3D dl_se->runtime <=3D 0;
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
+		dl_se->runtime =3D rorun ? dl_se->runtime : 0;
+		dl_se->runtime -=3D rq->clock - dl_se->deadline;
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
+	struct task_struct *curr =3D rq->curr;
+	struct sched_dl_entity *dl_se =3D &curr->dl;
+	u64 delta_exec;
+
+	if (!dl_task(curr) || !on_dl_rq(dl_se))
+		return;
+
+	delta_exec =3D rq->clock - curr->se.exec_start;
+	if (unlikely((s64)delta_exec < 0))
+		delta_exec =3D 0;
+
+	schedstat_set(curr->se.statistics.exec_max,
+		      max(curr->se.statistics.exec_max, delta_exec));
+
+	curr->se.sum_exec_runtime +=3D delta_exec;
+	account_group_exec_runtime(curr, delta_exec);
+
+	curr->se.exec_start =3D rq->clock;
+	cpuacct_charge(curr, delta_exec);
+
+	dl_se->runtime -=3D delta_exec;
+	if (dl_runtime_exceeded(rq, dl_se)) {
+		__dequeue_task_dl(rq, curr, 0);
+		if (likely(start_dl_timer(dl_se)))
+			dl_se->dl_throttled =3D 1;
+		else
+			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
+
+		resched_task(curr);
+	}
+}
+
+static void __enqueue_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+	struct rb_node **link =3D &dl_rq->rb_root.rb_node;
+	struct rb_node *parent =3D NULL;
+	struct sched_dl_entity *entry;
+	int leftmost =3D 1;
+
+	BUG_ON(!RB_EMPTY_NODE(&dl_se->rb_node));
+
+	while (*link) {
+		parent =3D *link;
+		entry =3D rb_entry(parent, struct sched_dl_entity, rb_node);
+		if (dl_time_before(dl_se->deadline, entry->deadline))
+			link =3D &parent->rb_left;
+		else {
+			link =3D &parent->rb_right;
+			leftmost =3D 0;
+		}
+	}
+
+	if (leftmost)
+		dl_rq->rb_leftmost =3D &dl_se->rb_node;
+
+	rb_link_node(&dl_se->rb_node, parent, link);
+	rb_insert_color(&dl_se->rb_node, &dl_rq->rb_root);
+
+	dl_rq->dl_nr_running++;
+}
+
+static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
+{
+	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
+
+	if (RB_EMPTY_NODE(&dl_se->rb_node))
+		return;
+
+	if (dl_rq->rb_leftmost =3D=3D &dl_se->rb_node) {
+		struct rb_node *next_node;
+
+		next_node =3D rb_next(&dl_se->rb_node);
+		dl_rq->rb_leftmost =3D next_node;
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
+static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flag=
s)
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
+static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int fl=
ags)
+{
+	dequeue_dl_entity(&p->dl);
+}
+
+static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int flag=
s)
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
+	struct task_struct *p =3D rq->curr;
+
+	/*
+	 * We make the task go to sleep until its current deadline by
+	 * forcing its runtime to zero. This way, update_curr_dl() stops
+	 * it and the bandwidth timer will wake it up and will give it
+	 * new scheduling parameters (thanks to dl_new=3D1).
+	 */
+	if (p->dl.runtime > 0) {
+		rq->curr->dl.dl_new =3D 1;
+		p->dl.runtime =3D 0;
+	}
+	update_curr_dl(rq);
+}
+
+static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
+				  int flags)
+{
+	if (!dl_task(rq->curr) || (dl_task(p) &&
+	    dl_time_before(p->dl.deadline, rq->curr->dl.deadline)))
+		resched_task(rq->curr);
+}
+
+#ifdef CONFIG_SCHED_HRTICK
+static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
+{
+	s64 delta =3D p->dl.dl_runtime - p->dl.runtime;
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
+	struct rb_node *left =3D dl_rq->rb_leftmost;
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
+	dl_rq =3D &rq->dl;
+
+	if (unlikely(!dl_rq->dl_nr_running))
+		return NULL;
+
+	dl_se =3D pick_next_dl_entity(rq, dl_rq);
+	BUG_ON(!dl_se);
+
+	p =3D dl_task_of(dl_se);
+	p->se.exec_start =3D rq->clock;
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
+	p->se.exec_start =3D 0;
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
+	 * The child of a -deadline task will be SCHED_DEADLINE, but
+	 * as a throttled task. This means the parent (or someone else)
+	 * must call sched_setscheduler_ex() on it, or it won't even
+	 * start.
+	 */
+	p->dl.dl_throttled =3D 1;
+	p->dl.dl_new =3D 0;
+}
+
+static void task_dead_dl(struct task_struct *p)
+{
+	/*
+	 * We are not holding any lock here, so it is safe to
+	 * wait for the bandwidth timer to be removed.
+	 */
+	hrtimer_cancel(&p->dl.dl_timer);
+}
+
+static void set_curr_task_dl(struct rq *rq)
+{
+	struct task_struct *p =3D rq->curr;
+
+	p->se.exec_start =3D rq->clock;
+}
+
+static void switched_from_dl(struct rq *rq, struct task_struct *p,
+			     int running)
+{
+	if (hrtimer_active(&p->dl.dl_timer))
+		hrtimer_try_to_cancel(&p->dl.dl_timer);
+}
+
+static void switched_to_dl(struct rq *rq, struct task_struct *p,
+			   int running)
+{
+	/*
+	 * If p is throttled, don't consider the possibility
+	 * of preempting rq->curr, the check will be done right
+	 * after its runtime will get replenished.
+	 */
+	if (unlikely(p->dl.dl_throttled))
+		return;
+
+	if (!running)
+		check_preempt_curr_dl(rq, p, 0);
+}
+
+static void prio_changed_dl(struct rq *rq, struct task_struct *p,
+			    int oldprio, int running)
+{
+	switched_to_dl(rq, p, running);
+}
+
+#ifdef CONFIG_SMP
+static int
+select_task_rq_dl(struct rq *rq, struct task_struct *p, int sd_flag, int f=
lags)
+{
+	return task_cpu(p);
+}
+
+static void set_cpus_allowed_dl(struct task_struct *p,
+				const struct cpumask *new_mask)
+{
+	int weight =3D cpumask_weight(new_mask);
+
+	BUG_ON(!dl_task(p));
+
+	cpumask_copy(&p->cpus_allowed, new_mask);
+	p->dl.nr_cpus_allowed =3D weight;
+}
+#endif
+
+static const struct sched_class dl_sched_class =3D {
+	.next			=3D &rt_sched_class,
+	.enqueue_task		=3D enqueue_task_dl,
+	.dequeue_task		=3D dequeue_task_dl,
+	.yield_task		=3D yield_task_dl,
+
+	.check_preempt_curr	=3D check_preempt_curr_dl,
+
+	.pick_next_task		=3D pick_next_task_dl,
+	.put_prev_task		=3D put_prev_task_dl,
+
+#ifdef CONFIG_SMP
+	.select_task_rq		=3D select_task_rq_dl,
+
+	.set_cpus_allowed       =3D set_cpus_allowed_dl,
+#endif
+
+	.set_curr_task		=3D set_curr_task_dl,
+	.task_tick		=3D task_tick_dl,
+	.task_fork              =3D task_fork_dl,
+	.task_dead		=3D task_dead_dl,
+
+	.prio_changed           =3D prio_changed_dl,
+	.switched_from		=3D switched_from_dl,
+	.switched_to		=3D switched_to_dl,
+};
+
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f4f6a83..54c869c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1654,7 +1654,7 @@ static void check_preempt_wakeup(struct rq *rq, struc=
t task_struct *p, int wake_
 	struct cfs_rq *cfs_rq =3D task_cfs_rq(curr);
 	int scale =3D cfs_rq->nr_running >=3D sched_nr_latency;
=20
-	if (unlikely(rt_prio(p->prio)))
+	if (unlikely(dl_prio(p->prio) || rt_prio(p->prio)))
 		goto preempt;
=20
 	if (unlikely(p->sched_class !=3D &fair_sched_class))
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index bea7d79..56c00fa 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1014,6 +1014,11 @@ static void check_preempt_equal_prio(struct rq *rq, =
struct task_struct *p)
  */
 static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, in=
t flags)
 {
+	/*
+	 * Since MAX_DL_PRIO is less than any possible RT
+	 * prio, this also guarantees that all -deadline tasks
+	 * preempt -rt ones.
+	 */
 	if (p->prio < rq->curr->prio) {
 		resched_task(rq->curr);
 		return;
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 45bddc0..25624df 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -81,7 +81,7 @@ get_rr_interval_stop(struct rq *rq, struct task_struct *t=
ask)
  * Simple, special scheduling class for the per-CPU stop tasks:
  */
 static const struct sched_class stop_sched_class =3D {
-	.next			=3D &rt_sched_class,
+	.next			=3D &dl_sched_class,
=20
 	.enqueue_task		=3D enqueue_task_stop,
 	.dequeue_task		=3D dequeue_task_stop,
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-2bSpOfLDQAhEKgF++YcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKafYACgkQk4XaBE3IOsSPLwCfSZewK7EQOS6I908ERPntPiMW
rFQAn2OvR122+jQYWe82NjLR2sDf+Jkl
=5hg8
-----END PGP SIGNATURE-----

--=-2bSpOfLDQAhEKgF++YcF--

