Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab0J2Gnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:43:55 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:10114 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756240Ab0J2Gnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:43:49 -0400
Subject: [RFC][PATCH 20/22] sched: drafted deadline inheritance logic
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4atOaPA2Ym/bpj62sjka"
Date: Fri, 29 Oct 2010 08:43:38 +0200
Message-ID: <1288334618.8661.162.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4atOaPA2Ym/bpj62sjka
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Some method to deal with rt-mutexes and make sched_dl interact with
the current PI-coded is needed, raising all but trivial issues, that
needs (according to us) to be solved with some restructuring of
the pi-code (i.e., going toward a proxy execution-ish implementation).

This is under development, in the meanwhile, as a temporary solution,
what this commits does is:
 - ensure a pi-lock owner with waiters is never throttled down. Instead,
   when it runs out of runtime, it immediately gets replenished and it's
   deadline is postponed (as in SF_BWRECL_DL reclaiming policy);
 - the scheduling parameters (relative deadline and default runtime)
   used for that replenishments --during the whole period it holds the
   pi-lock-- are the ones of the waiting task with earliest deadline.

Acting this way, we provide some kind of boosting to the lock-owner,
still by using the existing (actually, slightly modified by the previous
commit) pi-architecture.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |    3 ++
 kernel/fork.c         |    1 +
 kernel/rtmutex.c      |   13 ++++++++-
 kernel/sched.c        |    3 +-
 kernel/sched_dl.c     |   65 +++++++++++++++++++++++++++++++--------------=
----
 5 files changed, 58 insertions(+), 27 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c3d1f17b..7cf78e2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1535,6 +1535,8 @@ struct task_struct {
 	struct rb_node *pi_waiters_leftmost;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
+	/* */
+	struct task_struct *pi_top_task;
 #endif
=20
 #ifdef CONFIG_DEBUG_MUTEXES
@@ -2118,6 +2120,7 @@ extern unsigned int sysctl_sched_compat_yield;
=20
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
+extern struct task_struct *rt_mutex_get_top_task(struct task_struct *task)=
;
 extern void rt_mutex_setprio(struct task_struct *p, int prio);
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 #else
diff --git a/kernel/fork.c b/kernel/fork.c
index aceb248..c8f2555 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -938,6 +938,7 @@ static void rt_mutex_init_task(struct task_struct *p)
 	p->pi_waiters =3D RB_ROOT;
 	p->pi_waiters_leftmost =3D NULL;
 	p->pi_blocked_on =3D NULL;
+	p->pi_top_task =3D NULL;
 #endif
 }
=20
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 2e9c0dc..84ea165 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -196,6 +196,14 @@ int rt_mutex_getprio(struct task_struct *task)
 		   task->normal_prio);
 }
=20
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
@@ -205,7 +213,7 @@ static void __rt_mutex_adjust_prio(struct task_struct *=
task)
 {
 	int prio =3D rt_mutex_getprio(task);
=20
-	if (task->prio !=3D prio)
+	if (task->prio !=3D prio || dl_prio(prio))
 		rt_mutex_setprio(task, prio);
 }
=20
@@ -671,7 +679,8 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
=20
 	waiter =3D task->pi_blocked_on;
-	if (!waiter || waiter->task->prio =3D=3D task->prio) {
+	if (!waiter || (waiter->task->prio =3D=3D task->prio &&
+	    !dl_prio(task->prio))) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index 853473a..97db370 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4611,10 +4611,11 @@ void rt_mutex_setprio(struct task_struct *p, int pr=
io)
 	unsigned long flags;
 	struct rq *rq;
=20
-	BUG_ON(prio < 0 || prio > MAX_PRIO);
+	BUG_ON(prio > MAX_PRIO);
=20
 	rq =3D task_rq_lock(p, &flags);
 	trace_sched_pi_setprio(p, prio);
+	p->pi_top_task =3D rt_mutex_get_top_task(p);
 	__setprio(rq, p, prio);
 	task_rq_unlock(rq, &flags);
 }
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 4d24109..991a4f2 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -223,15 +223,16 @@ static int push_dl_task(struct rq *rq);
  * one, and to (try to!) reconcile itself with its own scheduling
  * parameters.
  */
-static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
+static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se,
+				       struct sched_dl_entity *pi_se)
 {
 	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
 	struct rq *rq =3D rq_of_dl_rq(dl_rq);
=20
 	WARN_ON(!dl_se->dl_new || dl_se->dl_throttled);
=20
-	dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
-	dl_se->runtime =3D dl_se->dl_runtime;
+	dl_se->deadline =3D rq->clock + pi_se->dl_deadline;
+	dl_se->runtime =3D pi_se->dl_runtime;
 	dl_se->dl_new =3D 0;
 #ifdef CONFIG_SCHEDSTATS
 	trace_sched_stat_new_dl(dl_task_of(dl_se), rq->clock, dl_se->flags);
@@ -256,7 +257,8 @@ static inline void setup_new_dl_entity(struct sched_dl_=
entity *dl_se)
  * could happen are, typically, a entity voluntarily trying to overcume it=
s
  * runtime, or it just underestimated it during sched_setscheduler_ex().
  */
-static void replenish_dl_entity(struct sched_dl_entity *dl_se)
+static void replenish_dl_entity(struct sched_dl_entity *dl_se,
+				struct sched_dl_entity *pi_se)
 {
 	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
 	struct rq *rq =3D rq_of_dl_rq(dl_rq);
@@ -269,8 +271,8 @@ static void replenish_dl_entity(struct sched_dl_entity =
*dl_se)
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <=3D 0) {
-		dl_se->deadline +=3D dl_se->dl_period;
-		dl_se->runtime +=3D dl_se->dl_runtime;
+		dl_se->deadline +=3D pi_se->dl_period;
+		dl_se->runtime +=3D pi_se->dl_runtime;
 	}
=20
 	/*
@@ -284,8 +286,8 @@ static void replenish_dl_entity(struct sched_dl_entity =
*dl_se)
 	 */
 	if (dl_time_before(dl_se->deadline, rq->clock)) {
 		WARN_ON_ONCE(1);
-		dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
-		dl_se->runtime =3D dl_se->dl_runtime;
+		dl_se->deadline =3D rq->clock + pi_se->dl_deadline;
+		dl_se->runtime =3D pi_se->dl_runtime;
 		reset =3D 1;
 	}
 #ifdef CONFIG_SCHEDSTATS
@@ -306,7 +308,8 @@ static void replenish_dl_entity(struct sched_dl_entity =
*dl_se)
  * task with deadline equal to period this is the same of using
  * dl_deadline instead of dl_period in the equation above.
  */
-static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
+static bool dl_entity_overflow(struct sched_dl_entity *dl_se,
+			       struct sched_dl_entity *pi_se, u64 t)
 {
 	u64 left, right;
=20
@@ -323,8 +326,8 @@ static bool dl_entity_overflow(struct sched_dl_entity *=
dl_se, u64 t)
 	 * to the (absolute) deadline. Therefore, overflowing the u64
 	 * type is very unlikely to occur in both cases.
 	 */
-	left =3D dl_se->dl_deadline * dl_se->runtime;
-	right =3D (dl_se->deadline - t) * dl_se->dl_runtime;
+	left =3D pi_se->dl_deadline * dl_se->runtime;
+	right =3D (dl_se->deadline - t) * pi_se->dl_runtime;
=20
 	return dl_time_before(right, left);
 }
@@ -338,7 +341,8 @@ static bool dl_entity_overflow(struct sched_dl_entity *=
dl_se, u64 t)
  *  - using the remaining runtime with the current deadline would make
  *    the entity exceed its bandwidth.
  */
-static void update_dl_entity(struct sched_dl_entity *dl_se)
+static void update_dl_entity(struct sched_dl_entity *dl_se,
+			     struct sched_dl_entity *pi_se)
 {
 	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
 	struct rq *rq =3D rq_of_dl_rq(dl_rq);
@@ -349,14 +353,14 @@ static void update_dl_entity(struct sched_dl_entity *=
dl_se)
 	 * the actual scheduling parameters have to be "renewed".
 	 */
 	if (dl_se->dl_new) {
-		setup_new_dl_entity(dl_se);
+		setup_new_dl_entity(dl_se, pi_se);
 		return;
 	}
=20
 	if (dl_time_before(dl_se->deadline, rq->clock) ||
-	    dl_entity_overflow(dl_se, rq->clock)) {
-		dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
-		dl_se->runtime =3D dl_se->dl_runtime;
+	    dl_entity_overflow(dl_se, pi_se, rq->clock)) {
+		dl_se->deadline =3D rq->clock + pi_se->dl_deadline;
+		dl_se->runtime =3D pi_se->dl_runtime;
 		overflow =3D 1;
 	}
 #ifdef CONFIG_SCHEDSTATS
@@ -374,7 +378,7 @@ static void update_dl_entity(struct sched_dl_entity *dl=
_se)
  * actually started or not (i.e., the replenishment instant is in
  * the future or in the past).
  */
-static int start_dl_timer(struct sched_dl_entity *dl_se)
+static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
 {
 	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
 	struct rq *rq =3D rq_of_dl_rq(dl_rq);
@@ -391,7 +395,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se=
)
 	 * This won't affect the other -deadline tasks, but if we are
 	 * a CPU-hog, lower scheduling classes will starve!
 	 */
-	if (dl_se->flags & SF_BWRECL_DL)
+	if (boosted || dl_se->flags & SF_BWRECL_DL)
 		return 0;
=20
 	/*
@@ -595,7 +599,7 @@ static void update_curr_dl(struct rq *rq)
 	dl_se->runtime -=3D delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
-		if (likely(start_dl_timer(dl_se)))
+		if (likely(start_dl_timer(dl_se, !!curr->pi_top_task)))
 			throttle_curr_dl(rq, curr);
 		else
 			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
@@ -749,7 +753,8 @@ static void __dequeue_dl_entity(struct sched_dl_entity =
*dl_se)
 }
=20
 static void
-enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
+enqueue_dl_entity(struct sched_dl_entity *dl_se,
+		  struct sched_dl_entity *pi_se, int flags)
 {
 	BUG_ON(on_dl_rq(dl_se));
=20
@@ -759,9 +764,9 @@ enqueue_dl_entity(struct sched_dl_entity *dl_se, int fl=
ags)
 	 * we want a replenishment of its runtime.
 	 */
 	if (!dl_se->dl_new && flags & ENQUEUE_REPLENISH)
-		replenish_dl_entity(dl_se);
+		replenish_dl_entity(dl_se, pi_se);
 	else
-		update_dl_entity(dl_se);
+		update_dl_entity(dl_se, pi_se);
=20
 	__enqueue_dl_entity(dl_se);
 }
@@ -773,6 +778,18 @@ static void dequeue_dl_entity(struct sched_dl_entity *=
dl_se)
=20
 static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flag=
s)
 {
+	struct task_struct *pi_task =3D p->pi_top_task;
+	struct sched_dl_entity *pi_se =3D &p->dl;
+
+	/*
+	 * Use the scheduling parameters of the top pi-waiter
+	 * task if we have one and its (relative) deadline is
+	 * smaller than our one... OTW we keep our runtime and
+	 * deadline.
+	 */
+	if (pi_task && dl_entity_preempt(&pi_task->dl, &p->dl))
+		pi_se =3D &pi_task->dl;
+
 	/*
 	 * If p is throttled, we do nothing. In fact, if it exhausted
 	 * its budget it needs a replenishment and, since it now is on
@@ -782,7 +799,7 @@ static void enqueue_task_dl(struct rq *rq, struct task_=
struct *p, int flags)
 	if (p->dl.dl_throttled)
 		return;
=20
-	enqueue_dl_entity(&p->dl, flags);
+	enqueue_dl_entity(&p->dl, pi_se, flags);
=20
 	if (!task_current(rq, p) && p->dl.nr_cpus_allowed > 1)
 		enqueue_pushable_dl_task(rq, p);
@@ -847,7 +864,7 @@ static long wait_interval_dl(struct task_struct *p, str=
uct timespec *rqtp,
 	 */
 	wakeup =3D timespec_to_ns(rqtp);
 	if (dl_time_before(wakeup, dl_se->deadline) &&
-	    !dl_entity_overflow(dl_se, wakeup)) {
+	    !dl_entity_overflow(dl_se, dl_se, wakeup)) {
 		u64 ibw =3D (u64)dl_se->runtime * dl_se->dl_period;
=20
 		ibw =3D div_u64(ibw, dl_se->dl_runtime);
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-4atOaPA2Ym/bpj62sjka
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKbRoACgkQk4XaBE3IOsS16wCgn2wDs6HYr7q3uXlhBOa+ALr8
W7gAn122L3HN2xBwK8ggjFYDDJHBicFL
=vTcD
-----END PGP SIGNATURE-----

--=-4atOaPA2Ym/bpj62sjka--

