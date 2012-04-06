Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2DFHPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:15:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47661 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab2DFHPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:15:17 -0400
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
Subject: [PATCH 03/16] sched: SCHED_DEADLINE data structures.
Date: Fri,  6 Apr 2012 09:14:28 +0200
Message-Id: <1333696481-3433-4-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

Introduce the data structures, constants and symbols needed for
SCHED_DEADLINE implementation.

Core data structure of SCHED_DEADLINE are defined, along with their
initializers. Hooks for checking if a task belong to the new policy
are also added where they are needed.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 include/linux/sched.h |   68 +++++++++++++++++++++++++++++++++++++++++++++-
 kernel/hrtimer.c      |    2 +-
 kernel/sched.c        |   73 +++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 132 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3e67d30..a7a4276 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -39,6 +39,7 @@
 #define SCHED_BATCH		3
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
+#define SCHED_DEADLINE		6
 /* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
 #define SCHED_RESET_ON_FORK     0x40000000
 
@@ -133,6 +134,10 @@ struct sched_param {
  * timing constraints.
  *
  * @__unused		padding to allow future expansion without ABI issues
+ *
+ * As of now, the SCHED_DEADLINE policy (sched_dl scheduling class) is the
+ * only user of this new interface. More information about the algorithm
+ * available in the scheduling class file or in Documentation/.
  */
 struct sched_param2 {
 	int sched_priority;
@@ -1130,6 +1135,7 @@ struct sched_domain;
 #else
 #define ENQUEUE_WAKING		0
 #endif
+#define ENQUEUE_REPLENISH	8
 
 #define DEQUEUE_SLEEP		1
 
@@ -1261,6 +1267,47 @@ struct sched_rt_entity {
 #endif
 };
 
+struct sched_dl_entity {
+	struct rb_node	rb_node;
+	int nr_cpus_allowed;
+
+	/*
+	 * Original scheduling parameters. Copied here from sched_param2
+	 * during sched_setscheduler2(), they will remain the same until
+	 * the next sched_setscheduler2().
+	 */
+	u64 dl_runtime;		/* maximum runtime for each instance	*/
+	u64 dl_deadline;	/* relative deadline of each instance	*/
+
+	/*
+	 * Actual scheduling parameters. Initialized with the values above,
+	 * they are continously updated during task execution. Note that
+	 * the remaining runtime could be < 0 in case we are in overrun.
+	 */
+	s64 runtime;		/* remaining runtime for this instance	*/
+	u64 deadline;		/* absolute deadline for this instance	*/
+	unsigned int flags;	/* specifying the scheduler behaviour	*/
+
+	/*
+	 * Some bool flags:
+	 *
+	 * @dl_throttled tells if we exhausted the runtime. If so, the
+	 * task has to wait for a replenishment to be performed at the
+	 * next firing of dl_timer.
+	 *
+	 * @dl_new tells if a new instance arrived. If so we must
+	 * start executing it with full runtime and reset its absolute
+	 * deadline;
+	 */
+	int dl_throttled, dl_new;
+
+	/*
+	 * Bandwidth enforcement timer. Each -deadline task has its
+	 * own bandwidth to be enforced, thus we need one timer per task.
+	 */
+	struct hrtimer dl_timer;
+};
+
 struct rcu_node;
 
 enum perf_event_task_context {
@@ -1289,6 +1336,7 @@ struct task_struct {
 	const struct sched_class *sched_class;
 	struct sched_entity se;
 	struct sched_rt_entity rt;
+	struct sched_dl_entity dl;
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
@@ -1681,6 +1729,10 @@ static inline bool pagefault_disabled(void)
  * user-space.  This allows kernel threads to set their
  * priority to a value higher than any user task. Note:
  * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
+ *
+ * SCHED_DEADLINE tasks has negative priorities, reflecting
+ * the fact that any of them has higher prio than RT and
+ * NORMAL/BATCH tasks.
  */
 
 #define MAX_USER_RT_PRIO	100
@@ -1689,9 +1741,23 @@ static inline bool pagefault_disabled(void)
 #define MAX_PRIO		(MAX_RT_PRIO + 40)
 #define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
 
+#define MAX_DL_PRIO		0
+
+static inline int dl_prio(int prio)
+{
+	if (unlikely(prio < MAX_DL_PRIO))
+		return 1;
+	return 0;
+}
+
+static inline int dl_task(struct task_struct *p)
+{
+	return dl_prio(p->prio);
+}
+
 static inline int rt_prio(int prio)
 {
-	if (unlikely(prio < MAX_RT_PRIO))
+	if (unlikely(prio >= MAX_DL_PRIO && prio < MAX_RT_PRIO))
 		return 1;
 	return 0;
 }
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3991464..246842e 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1764,7 +1764,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 	unsigned long slack;
 
 	slack = current->timer_slack_ns;
-	if (rt_task(current))
+	if (dl_task(current) || rt_task(current))
 		slack = 0;
 
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
diff --git a/kernel/sched.c b/kernel/sched.c
index eed5133..ea67240 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -133,11 +133,23 @@ static inline int rt_policy(int policy)
 	return 0;
 }
 
+static inline int dl_policy(int policy)
+{
+	if (unlikely(policy == SCHED_DEADLINE))
+		return 1;
+	return 0;
+}
+
 static inline int task_has_rt_policy(struct task_struct *p)
 {
 	return rt_policy(p->policy);
 }
 
+static inline int task_has_dl_policy(struct task_struct *p)
+{
+	return dl_policy(p->policy);
+}
+
 /*
  * This is the priority-queue data structure of the RT scheduling class:
  */
@@ -549,6 +561,15 @@ struct rt_rq {
 #endif
 };
 
+/* Deadline class' related fields in a runqueue */
+struct dl_rq {
+	/* runqueue is an rbtree, ordered by deadline */
+	struct rb_root rb_root;
+	struct rb_node *rb_leftmost;
+
+	unsigned long dl_nr_running;
+};
+
 #ifdef CONFIG_SMP
 
 /*
@@ -614,6 +635,7 @@ struct rq {
 
 	struct cfs_rq cfs;
 	struct rt_rq rt;
+	struct dl_rq dl;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
@@ -1911,6 +1933,7 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 }
 
 static const struct sched_class rt_sched_class;
+static const struct sched_class dl_sched_class;
 
 #define sched_class_highest (&stop_sched_class)
 #define for_each_class(class) \
@@ -2257,7 +2280,9 @@ static inline int normal_prio(struct task_struct *p)
 {
 	int prio;
 
-	if (task_has_rt_policy(p))
+	if (task_has_dl_policy(p))
+		prio = MAX_DL_PRIO-1;
+	else if (task_has_rt_policy(p))
 		prio = MAX_RT_PRIO-1 - p->rt_priority;
 	else
 		prio = __normal_prio(p);
@@ -2965,6 +2990,12 @@ static void __sched_fork(struct task_struct *p)
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
 
+	RB_CLEAR_NODE(&p->dl.rb_node);
+	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	p->dl.dl_runtime = p->dl.runtime = 0;
+	p->dl.dl_deadline = p->dl.deadline = 0;
+	p->dl.flags = 0;
+
 	INIT_LIST_HEAD(&p->rt.run_list);
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
@@ -2997,7 +3028,7 @@ void sched_fork(struct task_struct *p)
 	 * Revert to default priority/policy on fork if requested.
 	 */
 	if (unlikely(p->sched_reset_on_fork)) {
-		if (task_has_rt_policy(p)) {
+		if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
 			p->policy = SCHED_NORMAL;
 			p->static_prio = NICE_TO_PRIO(0);
 			p->rt_priority = 0;
@@ -5202,7 +5233,9 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
-	if (rt_prio(prio))
+	if (dl_prio(prio))
+		p->sched_class = &dl_sched_class;
+	else if (rt_prio(prio))
 		p->sched_class = &rt_sched_class;
 	else
 		p->sched_class = &fair_sched_class;
@@ -5236,9 +5269,9 @@ void set_user_nice(struct task_struct *p, long nice)
 	 * The RT priorities are set via sched_setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
 	 * it wont have any effect on scheduling until the task is
-	 * SCHED_FIFO/SCHED_RR:
+	 * SCHED_DEADLINE, SCHED_FIFO or SCHED_RR:
 	 */
-	if (task_has_rt_policy(p)) {
+	if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
@@ -5394,7 +5427,9 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 	p->normal_prio = normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio = rt_mutex_getprio(p);
-	if (rt_prio(p->prio))
+	if (dl_prio(p->prio))
+		p->sched_class = &dl_sched_class;
+	else if (rt_prio(p->prio))
 		p->sched_class = &rt_sched_class;
 	else
 		p->sched_class = &fair_sched_class;
@@ -5402,6 +5437,18 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 }
 
 /*
+ * This function validates the new parameters of a -deadline task.
+ * We ask for the deadline not being zero, and greater or equal
+ * than the runtime.
+ */
+static bool
+__checkparam_dl(const struct sched_param2 *prm)
+{
+	return prm && (&prm->sched_deadline) != 0 &&
+	       (s64)(&prm->sched_deadline - &prm->sched_runtime) >= 0;
+}
+
+/*
  * check the target process has a UID that matches the current process's
  */
 static bool check_same_owner(struct task_struct *p)
@@ -5441,7 +5488,8 @@ recheck:
 		reset_on_fork = !!(policy & SCHED_RESET_ON_FORK);
 		policy &= ~SCHED_RESET_ON_FORK;
 
-		if (policy != SCHED_FIFO && policy != SCHED_RR &&
+		if (policy != SCHED_DEADLINE &&
+				policy != SCHED_FIFO && policy != SCHED_RR &&
 				policy != SCHED_NORMAL && policy != SCHED_BATCH &&
 				policy != SCHED_IDLE)
 			return -EINVAL;
@@ -5456,7 +5504,8 @@ recheck:
 	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
 	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
 		return -EINVAL;
-	if (rt_policy(policy) != (param->sched_priority != 0))
+	if ((dl_policy(policy) && !__checkparam_dl(param)) ||
+	    (rt_policy(policy) != (param->sched_priority != 0)))
 		return -EINVAL;
 
 	/*
@@ -8437,6 +8486,11 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
 }
 
+static void init_dl_rq(struct dl_rq *dl_rq, struct rq *rq)
+{
+	dl_rq->rb_root = RB_ROOT;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 				struct sched_entity *se, int cpu,
@@ -8568,6 +8622,7 @@ void __init sched_init(void)
 		rq->calc_load_update = jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs);
 		init_rt_rq(&rq->rt, rq);
+		init_dl_rq(&rq->dl, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		root_task_group.shares = root_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
@@ -8755,7 +8810,7 @@ void normalize_rt_tasks(void)
 		p->se.statistics.block_start	= 0;
 #endif
 
-		if (!rt_task(p)) {
+		if (!dl_task(p) && !rt_task(p)) {
 			/*
 			 * Renice negative nice level userspace
 			 * tasks back to 0:
-- 
1.7.5.4

