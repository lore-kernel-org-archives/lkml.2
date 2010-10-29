Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab0J2GjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:39:10 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:28957 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753634Ab0J2GjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:39:05 -0400
Subject: [RFC][PATCH 15/22] sched: add traceporints for -deadline tasks
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-L40OSqIGViIiEH6pG1Av"
Date: Fri, 29 Oct 2010 08:38:54 +0200
Message-ID: <1288334334.8661.156.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-L40OSqIGViIiEH6pG1Av
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Add tracepoints for the most notable events related to -deadline
tasks scheduling (new task arrival, context switch, runtime accounting,
bandwidth enforcement timer, etc.).

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Harald Gustafsson <harald.gustafsson@ericsson.com>
---
 include/trace/events/sched.h |  203 ++++++++++++++++++++++++++++++++++++++=
+++-
 kernel/sched.c               |    2 +
 kernel/sched_dl.c            |   21 +++++
 3 files changed, 225 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index f633478..03baa17 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -304,7 +304,6 @@ DECLARE_EVENT_CLASS(sched_stat_template,
 			(unsigned long long)__entry->delay)
 );
=20
-
 /*
  * Tracepoint for accounting wait time (time the task is runnable
  * but not actually running due to scheduler contention).
@@ -363,6 +362,208 @@ TRACE_EVENT(sched_stat_runtime,
 );
=20
 /*
+ * Tracepoint for task switches involving -deadline tasks:
+ */
+TRACE_EVENT(sched_switch_dl,
+
+	TP_PROTO(u64 clock,
+		 struct task_struct *prev,
+		 struct task_struct *next),
+
+	TP_ARGS(clock, prev, next),
+
+	TP_STRUCT__entry(
+		__array(	char,	prev_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	prev_pid			)
+		__field(	u64,	clock				)
+		__field(	s64,	prev_rt				)
+		__field(	u64,	prev_dl				)
+		__field(	long,	prev_state			)
+		__array(	char,	next_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	next_pid			)
+		__field(	s64,	next_rt				)
+		__field(	u64,	next_dl				)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+		__entry->prev_pid	=3D prev->pid;
+		__entry->clock		=3D clock;
+		__entry->prev_rt	=3D prev->dl.runtime;
+		__entry->prev_dl	=3D prev->dl.deadline;
+		__entry->prev_state	=3D __trace_sched_switch_state(prev);
+		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
+		__entry->next_pid	=3D next->pid;
+		__entry->next_rt	=3D next->dl.runtime;
+		__entry->next_dl	=3D next->dl.deadline;
+	),
+
+	TP_printk("prev_comm=3D%s prev_pid=3D%d prev_rt=3D%Ld [ns] prev_dl=3D%Lu =
[ns] prev_state=3D%s =3D=3D> "
+		  "next_comm=3D%s next_pid=3D%d next_rt=3D%Ld [ns] next_dl=3D%Lu [ns] cl=
ock=3D%Lu [ns]",
+		  __entry->prev_comm, __entry->prev_pid, (long long)__entry->prev_rt,
+		  (unsigned long long)__entry->prev_dl, __entry->prev_state ?
+		    __print_flags(__entry->prev_state, "|",
+				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
+				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
+				{ 128, "W" }) : "R",
+		  __entry->next_comm, __entry->next_pid, (long long)__entry->next_rt,
+		  (unsigned long long)__entry->next_dl, (unsigned long long)__entry->clo=
ck)
+);
+
+/*
+ * Tracepoint for starting of the throttling timer of a -deadline task:
+ */
+TRACE_EVENT(sched_start_timer_dl,
+
+	TP_PROTO(struct task_struct *p, u64 clock,
+		 s64 now, s64 act, unsigned long range),
+
+	TP_ARGS(p, clock, now, act, range),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	u64,	clock			)
+		__field(	s64,	now			)
+		__field(	s64,	act			)
+		__field(	unsigned long,	range		)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		=3D p->pid;
+		__entry->clock		=3D clock;
+		__entry->now		=3D now;
+		__entry->act		=3D act;
+		__entry->range		=3D range;
+	),
+
+	TP_printk("comm=3D%s pid=3D%d clock=3D%Lu [ns] now=3D%Ld [ns] soft=3D%Ld =
[ns] range=3D%lu",
+		  __entry->comm, __entry->pid, (unsigned long long)__entry->clock,
+		  (long long)__entry->now, (long long)__entry->act,
+		  (unsigned long)__entry->range)
+);
+
+/*
+ * Tracepoint for the throttling timer of a -deadline task:
+ */
+TRACE_EVENT(sched_timer_dl,
+
+	TP_PROTO(struct task_struct *p, u64 clock, int on_rq, int running),
+
+	TP_ARGS(p, clock, on_rq, running),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	u64,	clock			)
+		__field(	int,	on_rq			)
+		__field(	int,	running			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		=3D p->pid;
+		__entry->clock		=3D clock;
+		__entry->on_rq		=3D on_rq;
+		__entry->running	=3D running;
+	),
+
+	TP_printk("comm=3D%s pid=3D%d clock=3D%Lu_rq=3D%d running=3D%d",
+		  __entry->comm, __entry->pid, (unsigned long long)__entry->clock,
+		  __entry->on_rq, __entry->running)
+);
+
+/*
+ * sched_stat tracepoints for -deadline tasks:
+ */
+DECLARE_EVENT_CLASS(sched_stat_template_dl,
+
+	TP_PROTO(struct task_struct *p, u64 clock, int flags),
+
+	TP_ARGS(p, clock, flags),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	u64,	clock			)
+		__field(	s64,	rt			)
+		__field(	u64,	dl			)
+		__field(	int,	flags			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		=3D p->pid;
+		__entry->clock		=3D clock;
+		__entry->rt		=3D p->dl.runtime;
+		__entry->dl		=3D p->dl.deadline;
+		__entry->flags		=3D flags;
+	),
+
+	TP_printk("comm=3D%s pid=3D%d clock=3D%Lu [ns] rt=3D%Ld dl=3D%Lu [ns] fla=
gs=3D0x%x",
+		  __entry->comm, __entry->pid, (unsigned long long)__entry->clock,
+		  (long long)__entry->rt, (unsigned long long)__entry->dl,
+		  __entry->flags)
+);
+
+/*
+ * Tracepoint for a new instance of a -deadline task:
+ */
+DEFINE_EVENT(sched_stat_template_dl, sched_stat_new_dl,
+	     TP_PROTO(struct task_struct *tsk, u64 clock, int flags),
+	     TP_ARGS(tsk, clock, flags));
+
+/*
+ * Tracepoint for a replenishment of a -deadline task:
+ */
+DEFINE_EVENT(sched_stat_template_dl, sched_stat_repl_dl,
+	     TP_PROTO(struct task_struct *tsk, u64 clock, int flags),
+	     TP_ARGS(tsk, clock, flags));
+
+/*
+ * Tracepoint for parameters recalculation of -deadline tasks:.
+ */
+DEFINE_EVENT(sched_stat_template_dl, sched_stat_updt_dl,
+	     TP_PROTO(struct task_struct *tsk, u64 clock, int flags),
+	     TP_ARGS(tsk, clock, flags));
+
+/*
+ * Tracepoint for accounting stats of -deadline tasks:.
+ */
+TRACE_EVENT(sched_stat_runtime_dl,
+
+	TP_PROTO(struct task_struct *p, u64 clock, u64 last),
+
+	TP_ARGS(p, clock, last),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	u64,	clock			)
+		__field(	u64,	last			)
+		__field(	s64,	rt			)
+		__field(	u64,	dl			)
+		__field(	u64,	start			)
+        ),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		=3D p->pid;
+		__entry->clock		=3D clock;
+		__entry->last		=3D last;
+		__entry->rt		=3D p->dl.runtime - last;
+		__entry->dl		=3D p->dl.deadline;
+		__entry->start		=3D p->se.exec_start;
+	),
+
+	TP_printk("comm=3D%s pid=3D%d clock=3D%Lu [ns] delta_exec=3D%Lu [ns] rt=
=3D%Ld [ns] dl=3D%Lu [ns] exec_start=3D%Lu [ns]",
+		  __entry->comm, __entry->pid, (unsigned long long)__entry->clock,
+		  (unsigned long long)__entry->last, (long long)__entry->rt,
+		  (unsigned long long)__entry->dl, (unsigned long long)__entry->start)
+);
+
+/*
  * Tracepoint for showing priority inheritance modifying a tasks
  * priority.
  */
diff --git a/kernel/sched.c b/kernel/sched.c
index 9165c5e..060d0c9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3061,6 +3061,8 @@ context_switch(struct rq *rq, struct task_struct *pre=
v,
=20
 	prepare_task_switch(rq, prev, next);
 	trace_sched_switch(prev, next);
+	if (unlikely(dl_task(prev) || dl_task(next)))
+		trace_sched_switch_dl(rq->clock, prev, next);
 	mm =3D next->mm;
 	oldmm =3D prev->active_mm;
 	/*
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index c4091c9..229814a 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -231,6 +231,9 @@ static inline void setup_new_dl_entity(struct sched_dl_=
entity *dl_se)
 	dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
 	dl_se->runtime =3D dl_se->dl_runtime;
 	dl_se->dl_new =3D 0;
+#ifdef CONFIG_SCHEDSTATS
+	trace_sched_stat_new_dl(dl_task_of(dl_se), rq->clock, dl_se->flags);
+#endif
 }
=20
 /*
@@ -255,6 +258,7 @@ static void replenish_dl_entity(struct sched_dl_entity =
*dl_se)
 {
 	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
 	struct rq *rq =3D rq_of_dl_rq(dl_rq);
+	int reset =3D 0;
=20
 	/*
 	 * We Keep moving the deadline away until we get some
@@ -280,7 +284,11 @@ static void replenish_dl_entity(struct sched_dl_entity=
 *dl_se)
 		WARN_ON_ONCE(1);
 		dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
 		dl_se->runtime =3D dl_se->dl_runtime;
+		reset =3D 1;
 	}
+#ifdef CONFIG_SCHEDSTATS
+	trace_sched_stat_repl_dl(dl_task_of(dl_se), rq->clock, reset);
+#endif
 }
=20
 /*
@@ -332,6 +340,7 @@ static void update_dl_entity(struct sched_dl_entity *dl=
_se)
 {
 	struct dl_rq *dl_rq =3D dl_rq_of_se(dl_se);
 	struct rq *rq =3D rq_of_dl_rq(dl_rq);
+	int overflow =3D 0;
=20
 	/*
 	 * The arrival of a new instance needs special treatment, i.e.,
@@ -346,7 +355,11 @@ static void update_dl_entity(struct sched_dl_entity *d=
l_se)
 	    dl_entity_overflow(dl_se, rq->clock)) {
 		dl_se->deadline =3D rq->clock + dl_se->dl_deadline;
 		dl_se->runtime =3D dl_se->dl_runtime;
+		overflow =3D 1;
 	}
+#ifdef CONFIG_SCHEDSTATS
+	trace_sched_stat_updt_dl(dl_task_of(dl_se), rq->clock, overflow);
+#endif
 }
=20
 /*
@@ -394,6 +407,10 @@ static int start_dl_timer(struct sched_dl_entity *dl_s=
e)
 	__hrtimer_start_range_ns(&dl_se->dl_timer, soft,
 				 range, HRTIMER_MODE_ABS, 0);
=20
+	trace_sched_start_timer_dl(dl_task_of(dl_se), rq->clock,
+				   ktime_to_ns(now), ktime_to_ns(soft),
+				   range);
+
 	return hrtimer_active(&dl_se->dl_timer);
 }
=20
@@ -427,6 +444,8 @@ static enum hrtimer_restart dl_task_timer(struct hrtime=
r *timer)
 	if (!dl_task(p))
 		goto unlock;
=20
+	trace_sched_timer_dl(p, rq->clock, p->se.on_rq, task_current(rq, p));
+
 	dl_se->dl_throttled =3D 0;
 	if (p->se.on_rq) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
@@ -439,6 +458,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtime=
r *timer)
 		if (rq->dl.overloaded)
 			push_dl_task(rq);
 	}
+
 unlock:
 	task_rq_unlock(rq, &flags);
=20
@@ -529,6 +549,7 @@ static void update_curr_dl(struct rq *rq)
 	curr->se.sum_exec_runtime +=3D delta_exec;
 	schedstat_add(&rq->dl, exec_clock, delta_exec);
 	account_group_exec_runtime(curr, delta_exec);
+	trace_sched_stat_runtime_dl(curr, rq->clock, delta_exec);
=20
 	curr->se.exec_start =3D rq->clock;
 	cpuacct_charge(curr, delta_exec);
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-L40OSqIGViIiEH6pG1Av
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKa/4ACgkQk4XaBE3IOsSpWgCfeNIAmCcTIuarLQ99t7+8C2Vi
z78AnRwjQO+ZPK2DYMuo/NOBn4KE0OaM
=CyTU
-----END PGP SIGNATURE-----

--=-L40OSqIGViIiEH6pG1Av--

