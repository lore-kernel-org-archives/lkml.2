Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0J2Gbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:31:31 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:40346 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752946Ab0J2Gb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:31:27 -0400
Subject: [RFC][PATCH 06/22] sched: SCHED_DEADLINE handles spacial kthreads
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gM0z6f7W5z0qZCyq7EDM"
Date: Fri, 29 Oct 2010 08:31:16 +0200
Message-ID: <1288333876.8661.147.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gM0z6f7W5z0qZCyq7EDM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


There sometimes is the need of executing a task as if it would
have the maximum possible priority in the entire system, i.e.,
whenever it gets ready it must run! This is for example the case
for some maintainance kernel thread like migration and (sometimes)
watchdog or ksoftirq.

Since SCHED_DEADLINE is now the highest priority scheduling class
these tasks have to be handled therein, but it is not obvious how
to choose a runtime and a deadline that guarantee what explained
above. Therefore, we need a mean of recognizing system tasks inside
the -deadline class and always run them as soon as possible, without
any kind of runtime and bandwidth limitation.

This patch:
 - adds the SF_HEAD flag, which identify a special task that need
   absolute prioritization among any other task;
 - ensures that special tasks always preempt everyone else (and,
   obviously, are not preempted by non special tasks);
 - disables runtime and bandwidth checking for such tasks, hoping
   that the interference they cause is small enough.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |   13 ++++++++++
 kernel/sched.c        |   59 ++++++++++++++++++++++++++++++++++++++-------=
---
 kernel/sched_dl.c     |   27 ++++++++++++++++++++--
 kernel/softirq.c      |    6 +----
 kernel/watchdog.c     |    3 +-
 5 files changed, 85 insertions(+), 23 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f94da51..f25d3a6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -154,6 +154,18 @@ struct sched_param_ex {
 	struct timespec curr_deadline;
 };
=20
+/*
+ * Scheduler flags.
+ *
+ *  @SF_HEAD    tells us that the task has to be considered one of the
+ *              maximum priority tasks in the system. This means it
+ *              always enqueued with maximum priority in the runqueue
+ *              of the highest priority scheduling class. In case it
+ *              it sched_deadline, the task also ignore runtime and
+ *              bandwidth limitations.
+ */
+#define SF_HEAD		1
+
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
@@ -2072,6 +2084,7 @@ extern int sched_setscheduler(struct task_struct *, i=
nt,
 			      const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
+extern void setscheduler_dl_special(struct task_struct *);
 extern int sched_setscheduler_ex(struct task_struct *, int,
 				 const struct sched_param *,
 				 const struct sched_param_ex *);
diff --git a/kernel/sched.c b/kernel/sched.c
index 208fa08..79e7c1c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2086,19 +2086,13 @@ static void sched_irq_time_avg_update(struct rq *rq=
, u64 curr_irq_time) { }
=20
 void sched_set_stop_task(int cpu, struct task_struct *stop)
 {
-	struct sched_param param =3D { .sched_priority =3D MAX_RT_PRIO - 1 };
 	struct task_struct *old_stop =3D cpu_rq(cpu)->stop;
=20
 	if (stop) {
 		/*
-		 * Make it appear like a SCHED_FIFO task, its something
-		 * userspace knows about and won't get confused about.
-		 *
-		 * Also, it will make PI more or less work without too
-		 * much confusion -- but then, stop work should not
-		 * rely on PI working anyway.
+		 * Make it appear like a SCHED_DEADLINE task.
 		 */
-		sched_setscheduler_nocheck(stop, SCHED_FIFO, &param);
+		setscheduler_dl_special(stop);
=20
 		stop->sched_class =3D &stop_sched_class;
 	}
@@ -2110,7 +2104,7 @@ void sched_set_stop_task(int cpu, struct task_struct =
*stop)
 		 * Reset it back to a normal scheduling class so that
 		 * it can die in pieces.
 		 */
-		old_stop->sched_class =3D &rt_sched_class;
+		old_stop->sched_class =3D &dl_sched_class;
 	}
 }
=20
@@ -4808,9 +4802,15 @@ __getparam_dl(struct task_struct *p, struct sched_pa=
ram_ex *param_ex)
  * than the runtime.
  */
 static bool
-__checkparam_dl(const struct sched_param_ex *prm)
+__checkparam_dl(const struct sched_param_ex *prm, bool kthread)
 {
-	return prm && timespec_to_ns(&prm->sched_deadline) !=3D 0 &&
+	if (!prm)
+		return false;
+
+	if (prm->sched_flags & SF_HEAD)
+		return kthread;
+
+	return timespec_to_ns(&prm->sched_deadline) !=3D 0 &&
 	       timespec_compare(&prm->sched_deadline,
 				&prm->sched_runtime) >=3D 0;
 }
@@ -4869,7 +4869,7 @@ recheck:
 	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
 	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
 		return -EINVAL;
-	if ((dl_policy(policy) && !__checkparam_dl(param_ex)) ||
+	if ((dl_policy(policy) && !__checkparam_dl(param_ex, !p->mm)) ||
 	    (rt_policy(policy) !=3D (param->sched_priority !=3D 0)))
 		return -EINVAL;
=20
@@ -5133,6 +5133,39 @@ SYSCALL_DEFINE4(sched_setscheduler_ex, pid_t, pid, i=
nt, policy,
 	return do_sched_setscheduler_ex(pid, policy, len, param_ex);
 }
=20
+/*
+ * These functions make the task one of the highest priority task in
+ * the system. This means it will always run as soon as it gets ready,
+ * and it won't be preempted by any other task, independently from their
+ * scheduling policy, deadline, priority, etc. (provided they're not
+ * 'special tasks' as well).
+ */
+static void __setscheduler_dl_special(struct rq *rq, struct task_struct *p=
)
+{
+	p->dl.dl_runtime =3D 0;
+	p->dl.dl_deadline =3D 0;
+	p->dl.flags =3D SF_HEAD;
+	p->dl.dl_new =3D 1;
+
+	__setscheduler(rq, p, SCHED_DEADLINE, MAX_RT_PRIO-1);
+}
+
+void setscheduler_dl_special(struct task_struct *p)
+{
+	struct sched_param param;
+	struct sched_param_ex param_ex;
+
+	param.sched_priority =3D 0;
+
+	param_ex.sched_priority =3D MAX_RT_PRIO-1;
+	param_ex.sched_runtime =3D ns_to_timespec(0);
+	param_ex.sched_deadline =3D ns_to_timespec(0);
+	param_ex.sched_flags =3D SF_HEAD;
+
+	__sched_setscheduler(p, SCHED_DEADLINE, &param, &param_ex, false);
+}
+EXPORT_SYMBOL(setscheduler_dl_special);
+
 /**
  * sys_sched_setparam - set/change the RT priority of a thread
  * @pid: the pid in question.
@@ -6071,7 +6104,7 @@ void sched_idle_next(void)
 	 */
 	raw_spin_lock_irqsave(&rq->lock, flags);
=20
-	__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
+	__setscheduler_dl_special(rq, p);
=20
 	activate_task(rq, p, 0);
=20
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 9d0443e..17973aa 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -19,6 +19,21 @@ static inline int dl_time_before(u64 a, u64 b)
 	return (s64)(a - b) < 0;
 }
=20
+/*
+ * Tells if entity @a should preempt entity @b.
+ */
+static inline
+int dl_entity_preempt(struct sched_dl_entity *a, struct sched_dl_entity *b=
)
+{
+	/*
+	 * A system task marked with SF_HEAD flag will always
+	 * preempt a non 'special' one.
+	 */
+	return a->flags & SF_HEAD ||
+	       (!(b->flags & SF_HEAD) &&
+		dl_time_before(a->deadline, b->deadline));
+}
+
 static inline struct task_struct *dl_task_of(struct sched_dl_entity *dl_se=
)
 {
 	return container_of(dl_se, struct task_struct, dl);
@@ -291,7 +306,13 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl=
_entity *dl_se)
 	int dmiss =3D dl_time_before(dl_se->deadline, rq->clock);
 	int rorun =3D dl_se->runtime <=3D 0;
=20
-	if (!rorun && !dmiss)
+	/*
+	 * No need for checking if it's time to enforce the
+	 * bandwidth for the tasks that are:
+	 *  - maximum priority (SF_HEAD),
+	 *  - not overrunning nor missing a deadline.
+	 */
+	if (dl_se->flags & SF_HEAD || (!rorun && !dmiss))
 		return 0;
=20
 	/*
@@ -359,7 +380,7 @@ static void __enqueue_dl_entity(struct sched_dl_entity =
*dl_se)
 	while (*link) {
 		parent =3D *link;
 		entry =3D rb_entry(parent, struct sched_dl_entity, rb_node);
-		if (dl_time_before(dl_se->deadline, entry->deadline))
+		if (dl_entity_preempt(dl_se, entry))
 			link =3D &parent->rb_left;
 		else {
 			link =3D &parent->rb_right;
@@ -471,7 +492,7 @@ static void check_preempt_curr_dl(struct rq *rq, struct=
 task_struct *p,
 				  int flags)
 {
 	if (!dl_task(rq->curr) || (dl_task(p) &&
-	    dl_time_before(p->dl.deadline, rq->curr->dl.deadline)))
+	    dl_entity_preempt(&p->dl, &rq->curr->dl)))
 		resched_task(rq->curr);
 }
=20
diff --git a/kernel/softirq.c b/kernel/softirq.c
index d4d918a..9c4c967 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -853,13 +853,9 @@ static int __cpuinit cpu_callback(struct notifier_bloc=
k *nfb,
 			     cpumask_any(cpu_online_mask));
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN: {
-		static struct sched_param param =3D {
-			.sched_priority =3D MAX_RT_PRIO-1
-		};
-
 		p =3D per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) =3D NULL;
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
+		setscheduler_dl_special(p);
 		kthread_stop(p);
 		takeover_tasklets(hotcpu);
 		break;
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 94ca779..2b7f259 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -307,10 +307,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct h=
rtimer *hrtimer)
  */
 static int watchdog(void *unused)
 {
-	static struct sched_param param =3D { .sched_priority =3D MAX_RT_PRIO-1 }=
;
 	struct hrtimer *hrtimer =3D &__raw_get_cpu_var(watchdog_hrtimer);
=20
-	sched_setscheduler(current, SCHED_FIFO, &param);
+	setscheduler_dl_special(current);
=20
 	/* initialize timestamp */
 	__touch_watchdog();
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-gM0z6f7W5z0qZCyq7EDM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKajQACgkQk4XaBE3IOsRJFwCfT8cd1mr6yvS9M41iR4Z/819E
a2sAoJjo9C0PJ5wMeya3jBJiSYxiZ/gi
=82Ox
-----END PGP SIGNATURE-----

--=-gM0z6f7W5z0qZCyq7EDM--

