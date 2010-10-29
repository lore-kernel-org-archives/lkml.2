Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab0J2Gmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:42:44 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:29551 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755140Ab0J2Gmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:42:37 -0400
Subject: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline tasks
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PXi92fUBdKcC4cs8Tst9"
Date: Fri, 29 Oct 2010 08:42:26 +0200
Message-ID: <1288334546.8661.161.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PXi92fUBdKcC4cs8Tst9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The bandwidth enforcing mechanism implemented inside the
SCHED_DEADLINE policy ensures that overrunning tasks are slowed
down without interfering with well behaving ones.
This, however, comes at the price of limiting the capability of
a task to exploit more bandwidth than it is asigned.

The current implementation always stops a task that is trying
to use more than its runtime (every deadline). Something else that
could be done is to let it continue running, but with a "decreased
priority". This way, we can exploit full CPU bandwidth and still
avoid interferences.

In order of "decreasing the priority" of a deadline task, we can:
 - let it stay SCHED_DEADLINE and postpone its deadline. This way it
   will always be scheduled before -rt and -other tasks but it
   won't affect other -deadline tasks;
 - put it in SCHED_FIFO with some priority. This way it will always
   be scheduled before -other tasks but it won't affect -deadline
   tasks, nor other -rt tasks with higher priority;
 - put it in SCHED_OTHER.

Notice also that this can be done on a per-task basis, e.g., each
task can specify what kind of reclaiming mechanism it wants to use
by means of the sched_flags field of sched_param_ex.

Therefore, this patch:
 - adds the flags for specyfing DEADLINE, RT or OTHER reclaiming
   behaviour;
 - adds the logic that changes the scheduling class of a task when
   it overruns, according to the requested policy.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |   25 ++++++++++++++
 kernel/hrtimer.c      |    2 +-
 kernel/sched.c        |   86 ++++++++++++++++++++++++++++++++-------------=
----
 kernel/sched_debug.c  |    2 +-
 kernel/sched_dl.c     |   44 +++++++++++++++++++++++--
 5 files changed, 123 insertions(+), 36 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b729f83..8806c1f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -172,10 +172,26 @@ struct sched_param_ex {
  *                      a runtime overrun occurs;
  *  @SF_SIG_DMISS       tells us the task wants to be notified whenever
  *                      a scheduling deadline is missed.
+ *  @SF_BWRECL_DL       tells us that the task doesn't stop when exhaustin=
g
+ *                      its runtime, and it remains a -deadline task, even
+ *                      though its deadline is postponed. This means it
+ *                      won't affect the scheduling of the other -deadline
+ *                      tasks, but if it is a CPU-hog, lower scheduling
+ *                      classes will starve!
+ *  @SF_BWRECL_RT       tells us that the task doesn't stop when exhaustin=
g
+ *                      its runtime, and it becomes a -rt task, with the
+ *                      priority specified in the sched_priority field of
+ *                      struct shced_param_ex.
+ *  @SF_BWRECL_OTH      tells us that the task doesn't stop when exhaustin=
g
+ *                      its runtime, and it becomes a normal task, with
+ *                      default priority.
  */
 #define SF_HEAD		1
 #define SF_SIG_RORUN	2
 #define SF_SIG_DMISS	4
+#define SF_BWRECL_DL	8
+#define SF_BWRECL_RT	16
+#define SF_BWRECL_NR	32
=20
 struct exec_domain;
 struct futex_pi_state;
@@ -1694,6 +1710,15 @@ static inline int dl_task(struct task_struct *p)
 	return dl_prio(p->prio);
 }
=20
+/*
+ * We might have temporarily dropped -deadline policy,
+ * but still be a -deadline task!
+ */
+static inline int __dl_task(struct task_struct *p)
+{
+	return dl_task(p) || p->policy =3D=3D SCHED_DEADLINE;
+}
+
 static inline int rt_prio(int prio)
 {
 	if (unlikely(prio >=3D MAX_DL_PRIO && prio < MAX_RT_PRIO))
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 9cd8564..54277be 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1574,7 +1574,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct =
timespec __user *rmtp,
 	unsigned long slack;
=20
 	slack =3D current->timer_slack_ns;
-	if (dl_task(current) || rt_task(current))
+	if (__dl_task(current) || rt_task(current))
 		slack =3D 0;
=20
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
diff --git a/kernel/sched.c b/kernel/sched.c
index 79cac6e..4d291e3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2235,7 +2235,7 @@ void set_task_cpu(struct task_struct *p, unsigned int=
 new_cpu)
 #endif
=20
 	trace_sched_migrate_task(p, new_cpu);
-	if (unlikely(dl_task(p)))
+	if (unlikely(__dl_task(p)))
 		trace_sched_migrate_task_dl(p, task_rq(p)->clock,
 					    new_cpu, cpu_rq(new_cpu)->clock);
=20
@@ -2983,6 +2983,16 @@ static void finish_task_switch(struct rq *rq, struct=
 task_struct *prev)
 			prev->sched_class->task_dead(prev);
=20
 		/*
+		 * If we are a -deadline task, dieing while
+		 * hanging out in a different scheduling class
+		 * we need to manually call our own cleanup function,
+		 * at least to stop the bandwidth timer.
+		 */
+		if (unlikely(task_has_dl_policy(prev) &&
+		    prev->sched_class !=3D &dl_sched_class))
+			dl_sched_class.task_dead(prev);
+
+		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
 		 */
@@ -3064,7 +3074,7 @@ context_switch(struct rq *rq, struct task_struct *pre=
v,
=20
 	prepare_task_switch(rq, prev, next);
 	trace_sched_switch(prev, next);
-	if (unlikely(dl_task(prev) || dl_task(next)))
+	if (unlikely(__dl_task(prev) || __dl_task(next)))
 		trace_sched_switch_dl(rq->clock, prev, next);
 	mm =3D next->mm;
 	oldmm =3D prev->active_mm;
@@ -4554,34 +4564,13 @@ long __sched sleep_on_timeout(wait_queue_head_t *q,=
 long timeout)
 }
 EXPORT_SYMBOL(sleep_on_timeout);
=20
-#ifdef CONFIG_RT_MUTEXES
-
-/*
- * rt_mutex_setprio - set the current priority of a task
- * @p: task
- * @prio: prio value (kernel-internal form)
- *
- * This function changes the 'effective' priority of a task. It does
- * not touch ->normal_prio like __setscheduler().
- *
- * Used by the rt_mutex code to implement priority inheritance logic.
- */
-void rt_mutex_setprio(struct task_struct *p, int prio)
+static void __setprio(struct rq *rq, struct task_struct *p, int prio)
 {
-	unsigned long flags;
-	int oldprio, on_rq, running;
-	struct rq *rq;
-	const struct sched_class *prev_class;
-
-	BUG_ON(prio < 0 || prio > MAX_PRIO);
+	int oldprio =3D p->prio;
+	const struct sched_class *prev_class =3D p->sched_class;
+	int running =3D task_current(rq, p);
+	int on_rq =3D p->se.on_rq;
=20
-	rq =3D task_rq_lock(p, &flags);
-
-	trace_sched_pi_setprio(p, prio);
-	oldprio =3D p->prio;
-	prev_class =3D p->sched_class;
-	on_rq =3D p->se.on_rq;
-	running =3D task_current(rq, p);
 	if (on_rq)
 		dequeue_task(rq, p, 0);
 	if (running)
@@ -4603,6 +4592,30 @@ void rt_mutex_setprio(struct task_struct *p, int pri=
o)
=20
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
+}
+
+#ifdef CONFIG_RT_MUTEXES
+
+/*
+ * rt_mutex_setprio - set the current priority of a task
+ * @p: task
+ * @prio: prio value (kernel-internal form)
+ *
+ * This function changes the 'effective' priority of a task. It does
+ * not touch ->normal_prio like __setscheduler().
+ *
+ * Used by the rt_mutex code to implement priority inheritance logic.
+ */
+void rt_mutex_setprio(struct task_struct *p, int prio)
+{
+	unsigned long flags;
+	struct rq *rq;
+
+	BUG_ON(prio < 0 || prio > MAX_PRIO);
+
+	rq =3D task_rq_lock(p, &flags);
+	trace_sched_pi_setprio(p, prio);
+	__setprio(rq, p, prio);
 	task_rq_unlock(rq, &flags);
 }
=20
@@ -4909,19 +4922,32 @@ recheck:
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
 		if (dl_policy(policy)) {
-			u64 rlim_dline, rlim_rtime;
+			u64 rlim_dline, rlim_rtime, rlim_rtprio;
 			u64 dline, rtime;
=20
 			if (!lock_task_sighand(p, &flags))
 				return -ESRCH;
 			rlim_dline =3D p->signal->rlim[RLIMIT_DLDLINE].rlim_cur;
 			rlim_rtime =3D p->signal->rlim[RLIMIT_DLRTIME].rlim_cur;
+			rlim_rtprio =3D p->signal->rlim[RLIMIT_RTPRIO].rlim_cur;
 			unlock_task_sighand(p, &flags);
=20
 			/* can't set/change -deadline policy */
 			if (policy !=3D p->policy && !rlim_rtime)
 				return -EPERM;
=20
+			/* can't set/change reclaiming policy to -deadline */
+			if ((param_ex->sched_flags & SF_BWRECL_DL) !=3D
+			    (p->dl.flags & SF_BWRECL_DL))
+				return -EPERM;
+
+			/* can't set/increase -rt reclaiming priority */
+			if (param_ex->sched_flags & SF_BWRECL_RT &&
+			    (param_ex->sched_priority <=3D 0 ||
+			     (param_ex->sched_priority > p->rt_priority &&
+			      param_ex->sched_priority > rlim_rtprio)))
+				return -EPERM;
+
 			/* can't decrease the deadline */
 			rlim_dline *=3D NSEC_PER_USEC;
 			dline =3D timespec_to_ns(&param_ex->sched_deadline);
@@ -8596,7 +8622,7 @@ void normalize_rt_tasks(void)
 		p->se.statistics.block_start	=3D 0;
 #endif
=20
-		if (!dl_task(p) && !rt_task(p)) {
+		if (!__dl_task(p) && !rt_task(p)) {
 			/*
 			 * Renice negative nice level userspace
 			 * tasks back to 0:
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 4949a21..2bf4e72 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -467,7 +467,7 @@ void proc_sched_show_task(struct task_struct *p, struct=
 seq_file *m)
 	P(se.statistics.nr_wakeups_affine_attempts);
 	P(se.statistics.nr_wakeups_passive);
 	P(se.statistics.nr_wakeups_idle);
-	if (dl_task(p)) {
+	if (__dl_task(p)) {
 		P(dl.stats.dmiss);
 		PN(dl.stats.last_dmiss);
 		PN(dl.stats.dmiss_max);
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index eff183a..4d24109 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -15,6 +15,8 @@
  *                    Fabio Checconi <fabio@gandalf.sssup.it>
  */
=20
+static const struct sched_class dl_sched_class;
+
 static inline int dl_time_before(u64 a, u64 b)
 {
 	return (s64)(a - b) < 0;
@@ -382,6 +384,17 @@ static int start_dl_timer(struct sched_dl_entity *dl_s=
e)
 	s64 delta;
=20
 	/*
+	 * If the task wants to stay -deadline even if it exhausted
+	 * its runtime we allow that by not starting the timer.
+	 * update_curr_dl() will thus queue it back after replenishment
+	 * and deadline postponing.
+	 * This won't affect the other -deadline tasks, but if we are
+	 * a CPU-hog, lower scheduling classes will starve!
+	 */
+	if (dl_se->flags & SF_BWRECL_DL)
+		return 0;
+
+	/*
 	 * We want the timer to fire at the deadline, but considering
 	 * that it is actually coming from rq->clock and not from
 	 * hrtimer's time base reading.
@@ -414,6 +427,8 @@ static int start_dl_timer(struct sched_dl_entity *dl_se=
)
 	return hrtimer_active(&dl_se->dl_timer);
 }
=20
+static void __setprio(struct rq *rq, struct task_struct *p, int prio);
+
 /*
  * This is the bandwidth enforcement timer callback. If here, we know
  * a task is not on its dl_rq, since the fact that the timer was running
@@ -440,12 +455,18 @@ static enum hrtimer_restart dl_task_timer(struct hrti=
mer *timer)
 	 * We need to take care of a possible races here. In fact, the
 	 * task might have changed its scheduling policy to something
 	 * different from SCHED_DEADLINE (through sched_setscheduler()).
+	 * However, if we changed scheduling class for reclaiming, it
+	 * is correct to handle this replenishment, since this is what
+	 * will put us back into the -deadline scheduling class.
 	 */
-	if (!dl_task(p))
+	if (!__dl_task(p))
 		goto unlock;
=20
 	trace_sched_timer_dl(p, rq->clock, p->se.on_rq, task_current(rq, p));
=20
+	if (unlikely(p->sched_class !=3D &dl_sched_class))
+		__setprio(rq, p, MAX_DL_PRIO-1);
+
 	dl_se->dl_throttled =3D 0;
 	if (p->se.on_rq) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
@@ -530,6 +551,16 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl=
_entity *dl_se)
 	return 1;
 }
=20
+static inline void throttle_curr_dl(struct rq *rq, struct task_struct *cur=
r)
+{
+	curr->dl.dl_throttled =3D 1;
+
+	if (curr->dl.flags & SF_BWRECL_RT)
+		__setprio(rq, curr, MAX_RT_PRIO-1 - curr->rt_priority);
+	else if (curr->dl.flags & SF_BWRECL_NR)
+		__setprio(rq, curr, DEFAULT_PRIO);
+}
+
 /*
  * Update the current task's runtime statistics (provided it is still
  * a -deadline task and has not been removed from the dl_rq).
@@ -565,7 +596,7 @@ static void update_curr_dl(struct rq *rq)
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
 		if (likely(start_dl_timer(dl_se)))
-			dl_se->dl_throttled =3D 1;
+			throttle_curr_dl(rq, curr);
 		else
 			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
=20
@@ -765,8 +796,10 @@ static void __dequeue_task_dl(struct rq *rq, struct ta=
sk_struct *p, int flags)
=20
 static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int flag=
s)
 {
-	update_curr_dl(rq);
-	__dequeue_task_dl(rq, p, flags);
+	if (likely(!p->dl.dl_throttled)) {
+		update_curr_dl(rq);
+		__dequeue_task_dl(rq, p, flags);
+	}
 }
=20
 /*
@@ -1000,6 +1033,9 @@ struct task_struct *pick_next_task_dl(struct rq *rq)
=20
 static void put_prev_task_dl(struct rq *rq, struct task_struct *p)
 {
+	if (unlikely(p->dl.dl_throttled))
+		return;
+
 	update_curr_dl(rq);
 	p->se.exec_start =3D 0;
=20
--=20
1.7.2.3



--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-PXi92fUBdKcC4cs8Tst9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKbNIACgkQk4XaBE3IOsRpmgCgk6rwlhw5GCahKAyg/51Y2B7B
K90An15VgecEtzvA7yra0K85rOcBqOIe
=eZwE
-----END PGP SIGNATURE-----

--=-PXi92fUBdKcC4cs8Tst9--

