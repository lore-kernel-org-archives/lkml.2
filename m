Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0J2G2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:28:16 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:4966 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753777Ab0J2G2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:28:11 -0400
Subject: [RFC][PATCH 03/22] sched: SCHED_DEADLINE data structures.
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-B+C9p8ffolI/jbBtWsTV"
Date: Fri, 29 Oct 2010 08:28:00 +0200
Message-ID: <1288333680.8661.142.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B+C9p8ffolI/jbBtWsTV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Introduce the data structures, constants and symbols needed for
SCHED_DEADLINE implementation.

Core data structure of SCHED_DEADLINE are defined, along with their
initializers. Hooks for checking if a task belong to the new policy
are also added where they are needed.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |   68 ++++++++++++++++++++++++++++++++++++++++++-
 kernel/hrtimer.c      |    2 +-
 kernel/sched.c        |   78 ++++++++++++++++++++++++++++++++++++++++++---=
----
 3 files changed, 135 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cf20084..c72a132 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -38,6 +38,7 @@
 #define SCHED_BATCH		3
 /* SCHED_ISO: reserved but not implemented yet */
 #define SCHED_IDLE		5
+#define SCHED_DEADLINE		6
 /* Can be ORed in to make sure the process is reverted back to SCHED_NORMA=
L on fork */
 #define SCHED_RESET_ON_FORK     0x40000000
=20
@@ -136,6 +137,10 @@ struct sched_param {
  * Given this task model, there are a multiplicity of scheduling algorithm=
s
  * and policies, that can be used to ensure all the tasks will make their
  * timing constraints.
+ *
+ * As of now, the SCHED_DEADLINE policy (sched_dl scheduling class) is the
+ * only user of this new interface. More information about the algorithm
+ * available in the scheduling class file or in Documentation/.
  */
 struct sched_param_ex {
 	int sched_priority;
@@ -1089,6 +1094,7 @@ struct sched_domain;
 #define ENQUEUE_WAKEUP		1
 #define ENQUEUE_WAKING		2
 #define ENQUEUE_HEAD		4
+#define ENQUEUE_REPLENISH	8
=20
 #define DEQUEUE_SLEEP		1
=20
@@ -1222,6 +1228,47 @@ struct sched_rt_entity {
 #endif
 };
=20
+struct sched_dl_entity {
+	struct rb_node	rb_node;
+	int nr_cpus_allowed;
+
+	/*
+	 * Original scheduling parameters. Copied here from sched_param_ex
+	 * during sched_setscheduler_ex(), they will remain the same until
+	 * the next sched_setscheduler_ex().
+	 */
+	u64 dl_runtime;		/* maximum runtime for each instance 	*/
+	u64 dl_deadline;	/* relative deadline of each instance	*/
+
+	/*
+	 * Actual scheduling parameters. Initialized with the values above,
+	 * they are continously updated during task execution. Note that
+	 * the remaining runtime could be < 0 in case we are in overrun.
+	 */
+	s64 runtime;		/* remaining runtime for this instance	*/
+	u64 deadline;		/* absolute deadline for this instance	*/
+	unsigned int flags;	/* specifying the scheduler behaviour   */
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
=20
 enum perf_event_task_context {
@@ -1251,6 +1298,7 @@ struct task_struct {
 	const struct sched_class *sched_class;
 	struct sched_entity se;
 	struct sched_rt_entity rt;
+	struct sched_dl_entity dl;
=20
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
@@ -1580,6 +1628,10 @@ struct task_struct {
  * user-space.  This allows kernel threads to set their
  * priority to a value higher than any user task. Note:
  * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
+ *
+ * SCHED_DEADLINE tasks has negative priorities, reflecting
+ * the fact that any of them has higher prio than RT and
+ * NORMAL/BATCH tasks.
  */
=20
 #define MAX_USER_RT_PRIO	100
@@ -1588,9 +1640,23 @@ struct task_struct {
 #define MAX_PRIO		(MAX_RT_PRIO + 40)
 #define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
=20
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
+	if (unlikely(prio >=3D MAX_DL_PRIO && prio < MAX_RT_PRIO))
 		return 1;
 	return 0;
 }
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 72206cf..9cd8564 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1574,7 +1574,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct =
timespec __user *rmtp,
 	unsigned long slack;
=20
 	slack =3D current->timer_slack_ns;
-	if (rt_task(current))
+	if (dl_task(current) || rt_task(current))
 		slack =3D 0;
=20
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
diff --git a/kernel/sched.c b/kernel/sched.c
index 76f1bc6..d157358 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -128,11 +128,23 @@ static inline int rt_policy(int policy)
 	return 0;
 }
=20
+static inline int dl_policy(int policy)
+{
+	if (unlikely(policy =3D=3D SCHED_DEADLINE))
+		return 1;
+	return 0;
+}
+
 static inline int task_has_rt_policy(struct task_struct *p)
 {
 	return rt_policy(p->policy);
 }
=20
+static inline int task_has_dl_policy(struct task_struct *p)
+{
+	return dl_policy(p->policy);
+}
+
 /*
  * This is the priority-queue data structure of the RT scheduling class:
  */
@@ -405,6 +417,15 @@ struct rt_rq {
 #endif
 };
=20
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
=20
 /*
@@ -469,6 +490,7 @@ struct rq {
=20
 	struct cfs_rq cfs;
 	struct rt_rq rt;
+	struct dl_rq dl;
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
@@ -1852,8 +1874,6 @@ static inline void __set_task_cpu(struct task_struct =
*p, unsigned int cpu)
 #endif
 }
=20
-static const struct sched_class rt_sched_class;
-
 #define sched_class_highest (&stop_sched_class)
 #define for_each_class(class) \
    for (class =3D sched_class_highest; class; class =3D class->next)
@@ -2070,7 +2090,9 @@ static inline int normal_prio(struct task_struct *p)
 {
 	int prio;
=20
-	if (task_has_rt_policy(p))
+	if (task_has_dl_policy(p))
+		prio =3D MAX_DL_PRIO-1;
+	else if (task_has_rt_policy(p))
 		prio =3D MAX_RT_PRIO-1 - p->rt_priority;
 	else
 		prio =3D __normal_prio(p);
@@ -2634,6 +2656,12 @@ static void __sched_fork(struct task_struct *p)
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
=20
+	RB_CLEAR_NODE(&p->dl.rb_node);
+	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	p->dl.dl_runtime =3D p->dl.runtime =3D 0;
+	p->dl.dl_deadline =3D p->dl.deadline =3D 0;
+	p->dl.flags =3D 0;
+
 	INIT_LIST_HEAD(&p->rt.run_list);
 	p->se.on_rq =3D 0;
 	INIT_LIST_HEAD(&p->se.group_node);
@@ -2662,7 +2690,8 @@ void sched_fork(struct task_struct *p, int clone_flag=
s)
 	 * Revert to default priority/policy on fork if requested.
 	 */
 	if (unlikely(p->sched_reset_on_fork)) {
-		if (p->policy =3D=3D SCHED_FIFO || p->policy =3D=3D SCHED_RR) {
+		if (p->policy =3D=3D SCHED_DEADLINE ||
+		    p->policy =3D=3D SCHED_FIFO || p->policy =3D=3D SCHED_RR) {
 			p->policy =3D SCHED_NORMAL;
 			p->normal_prio =3D p->static_prio;
 		}
@@ -4464,6 +4493,8 @@ long __sched sleep_on_timeout(wait_queue_head_t *q, l=
ong timeout)
 }
 EXPORT_SYMBOL(sleep_on_timeout);
=20
+static const struct sched_class dl_sched_class;
+
 #ifdef CONFIG_RT_MUTEXES
=20
 /*
@@ -4497,7 +4528,9 @@ void rt_mutex_setprio(struct task_struct *p, int prio=
)
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
=20
-	if (rt_prio(prio))
+	if (dl_prio(prio))
+		p->sched_class =3D &dl_sched_class;
+	else if (rt_prio(prio))
 		p->sched_class =3D &rt_sched_class;
 	else
 		p->sched_class =3D &fair_sched_class;
@@ -4533,9 +4566,9 @@ void set_user_nice(struct task_struct *p, long nice)
 	 * The RT priorities are set via sched_setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
 	 * it wont have any effect on scheduling until the task is
-	 * SCHED_FIFO/SCHED_RR:
+	 * SCHED_DEADLINE, SCHED_FIFO or SCHED_RR:
 	 */
-	if (task_has_rt_policy(p)) {
+	if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
 		p->static_prio =3D NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
@@ -4680,7 +4713,9 @@ __setscheduler(struct rq *rq, struct task_struct *p, =
int policy, int prio)
 	p->normal_prio =3D normal_prio(p);
 	/* we are holding p->pi_lock already */
 	p->prio =3D rt_mutex_getprio(p);
-	if (rt_prio(p->prio))
+	if (dl_prio(p->prio))
+		p->sched_class =3D &dl_sched_class;
+	else if (rt_prio(p->prio))
 		p->sched_class =3D &rt_sched_class;
 	else
 		p->sched_class =3D &fair_sched_class;
@@ -4688,6 +4723,19 @@ __setscheduler(struct rq *rq, struct task_struct *p,=
 int policy, int prio)
 }
=20
 /*
+ * This function validates the new parameters of a -deadline task.
+ * We ask for the deadline not being zero, and greater or equal
+ * than the runtime.
+ */
+static bool
+__checkparam_dl(const struct sched_param_ex *prm)
+{
+	return prm && timespec_to_ns(&prm->sched_deadline) !=3D 0 &&
+	       timespec_compare(&prm->sched_deadline,
+				&prm->sched_runtime) >=3D 0;
+}
+
+/*
  * check the target process has a UID that matches the current process's
  */
 static bool check_same_owner(struct task_struct *p)
@@ -4725,7 +4773,8 @@ recheck:
 		reset_on_fork =3D !!(policy & SCHED_RESET_ON_FORK);
 		policy &=3D ~SCHED_RESET_ON_FORK;
=20
-		if (policy !=3D SCHED_FIFO && policy !=3D SCHED_RR &&
+		if (policy !=3D SCHED_DEADLINE &&
+				policy !=3D SCHED_FIFO && policy !=3D SCHED_RR &&
 				policy !=3D SCHED_NORMAL && policy !=3D SCHED_BATCH &&
 				policy !=3D SCHED_IDLE)
 			return -EINVAL;
@@ -4740,7 +4789,8 @@ recheck:
 	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
 	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
 		return -EINVAL;
-	if (rt_policy(policy) !=3D (param->sched_priority !=3D 0))
+	if ((dl_policy(policy) && !__checkparam_dl(param_ex)) ||
+	    (rt_policy(policy) !=3D (param->sched_priority !=3D 0)))
 		return -EINVAL;
=20
 	/*
@@ -7980,6 +8030,11 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct r=
q *rq)
 #endif
 }
=20
+static void init_dl_rq(struct dl_rq *dl_rq, struct rq *rq)
+{
+	dl_rq->rb_root =3D RB_ROOT;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq=
,
 				struct sched_entity *se, int cpu, int add,
@@ -8111,6 +8166,7 @@ void __init sched_init(void)
 		rq->calc_load_update =3D jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
+		init_dl_rq(&rq->dl, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.shares =3D init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
@@ -8301,7 +8357,7 @@ void normalize_rt_tasks(void)
 		p->se.statistics.block_start	=3D 0;
 #endif
=20
-		if (!rt_task(p)) {
+		if (!dl_task(p) && !rt_task(p)) {
 			/*
 			 * Renice negative nice level userspace
 			 * tasks back to 0:
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-B+C9p8ffolI/jbBtWsTV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKaXAACgkQk4XaBE3IOsQSgACdENR8v1gz3E1EJJ67TZBNpkEr
dGMAoJmRsm7LIXWo79jloE4BMgClpVHL
=2y6F
-----END PGP SIGNATURE-----

--=-B+C9p8ffolI/jbBtWsTV--

