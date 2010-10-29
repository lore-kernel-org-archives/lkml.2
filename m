Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab0J2Gjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:39:53 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:11915 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753634Ab0J2Gjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:39:49 -0400
Subject: [RFC][PATCH 16/22] sched: add SMP traceporints for -deadline tasks
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/xqP11Ag6YOsQz01rA2K"
Date: Fri, 29 Oct 2010 08:39:37 +0200
Message-ID: <1288334377.8661.157.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/xqP11Ag6YOsQz01rA2K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Add tracepoints for the events involved in -deadline task migration
(mainly push, pull and migrate-task).

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/trace/events/sched.h |  109 ++++++++++++++++++++++++++++++++++++++=
++++
 kernel/sched.c               |    3 +
 kernel/sched_dl.c            |    7 +++
 3 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 03baa17..f1d805f 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -475,6 +475,115 @@ TRACE_EVENT(sched_timer_dl,
 );
=20
 /*
+ *
+ */
+TRACE_EVENT(sched_push_task_dl,
+
+	TP_PROTO(struct task_struct *n, u64 clock, int later_cpu),
+
+	TP_ARGS(n, clock, later_cpu),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	u64,	clock			)
+		__field(	s64,	rt			)
+		__field(	u64,	dl			)
+		__field(	int,	cpu			)
+		__field(	int,	later_cpu		)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, n->comm, TASK_COMM_LEN);
+		__entry->pid		=3D n->pid;
+		__entry->clock		=3D clock;
+		__entry->rt		=3D n->dl.runtime;
+		__entry->dl		=3D n->dl.deadline;
+		__entry->cpu		=3D task_cpu(n);
+		__entry->later_cpu	=3D later_cpu;
+	),
+
+	TP_printk("comm=3D%s pid=3D%d rt=3D%Ld [ns] dl=3D%Lu [ns] clock=3D%Lu [ns=
] cpu=3D%d later_cpu=3D%d",
+		  __entry->comm, __entry->pid, (long long)__entry->rt,
+		  (unsigned long long)__entry->dl, (unsigned long long)__entry->clock,
+		  __entry->cpu, __entry->later_cpu)
+);
+
+/*
+ *
+ */
+TRACE_EVENT(sched_pull_task_dl,
+
+	TP_PROTO(struct task_struct *p, u64 clock, int src_cpu),
+
+	TP_ARGS(p, clock, src_cpu),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	u64,	clock			)
+		__field(	s64,	rt			)
+		__field(	u64,	dl			)
+		__field(	int,	cpu			)
+		__field(	int,	src_cpu			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		=3D p->pid;
+		__entry->clock		=3D clock;
+		__entry->rt		=3D p->dl.runtime;
+		__entry->dl		=3D p->dl.deadline;
+		__entry->cpu		=3D task_cpu(p);
+		__entry->src_cpu	=3D src_cpu;
+	),
+
+	TP_printk("comm=3D%s pid=3D%d rt=3D%Ld [ns] dl=3D%Lu [ns] clock=3D%Lu [ns=
] cpu=3D%d later_cpu=3D%d",
+		  __entry->comm, __entry->pid, (long long)__entry->rt,
+		  (unsigned long long)__entry->dl, (unsigned long long)__entry->clock,
+		  __entry->cpu, __entry->src_cpu)
+);
+
+/*
+ * Tracepoint for migrations involving -deadline tasks:
+ */
+TRACE_EVENT(sched_migrate_task_dl,
+
+	TP_PROTO(struct task_struct *p, u64 clock, int dest_cpu, u64 dclock),
+
+	TP_ARGS(p, clock, dest_cpu, dclock),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+		__field(	u64,	clock			)
+		__field(	s64,	rt			)
+		__field(	u64,	dl			)
+		__field(	int,	orig_cpu		)
+		__field(	int,	dest_cpu		)
+		__field(	u64,	dclock			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		=3D p->pid;
+		__entry->clock		=3D clock;
+		__entry->rt		=3D p->dl.runtime;
+		__entry->dl		=3D p->dl.deadline;
+		__entry->orig_cpu	=3D task_cpu(p);
+		__entry->dest_cpu	=3D dest_cpu;
+		__entry->dclock		=3D dclock;
+	),
+
+	TP_printk("comm=3D%s pid=3D%d rt=3D%Ld [ns] dl=3D%Lu [ns] orig_cpu=3D%d o=
rig_clock=3D%Lu [ns] "
+		  "dest_cpu=3D%d dest_clock=3D%Lu [ns]",
+		  __entry->comm, __entry->pid, (long long)__entry->rt,
+		  (unsigned long long)__entry->dl, __entry->orig_cpu,
+		  (unsigned long long)__entry->clock, __entry->dest_cpu,
+		  (unsigned long long)__entry->dclock)
+);
+
+/*
  * sched_stat tracepoints for -deadline tasks:
  */
 DECLARE_EVENT_CLASS(sched_stat_template_dl,
diff --git a/kernel/sched.c b/kernel/sched.c
index 060d0c9..79cac6e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2235,6 +2235,9 @@ void set_task_cpu(struct task_struct *p, unsigned int=
 new_cpu)
 #endif
=20
 	trace_sched_migrate_task(p, new_cpu);
+	if (unlikely(dl_task(p)))
+		trace_sched_migrate_task_dl(p, task_rq(p)->clock,
+					    new_cpu, cpu_rq(new_cpu)->clock);
=20
 	if (task_cpu(p) !=3D new_cpu) {
 		p->se.nr_migrations++;
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 229814a..cc87949 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -1294,6 +1294,10 @@ retry:
=20
 	/* Will lock the rq it'll find */
 	later_rq =3D find_lock_later_rq(next_task, rq);
+
+	trace_sched_push_task_dl(next_task, rq->clock,
+				 later_rq ? later_rq->cpu : -1);
+
 	if (!later_rq) {
 		struct task_struct *task;
=20
@@ -1378,6 +1382,9 @@ static int pull_dl_task(struct rq *this_rq)
 			goto skip;
=20
 		p =3D pick_next_earliest_dl_task(src_rq, this_cpu);
+		if (p)
+			trace_sched_pull_task_dl(p, this_rq->clock,
+						 src_rq->cpu);
=20
 		/*
 		 * We found a task to be pulled if:
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-/xqP11Ag6YOsQz01rA2K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKbCkACgkQk4XaBE3IOsTtRQCgji+zme3pknzB147Trw+A6yBt
kcMAnjjAH0Ra7tN8V71EzfS+3AXftnLx
=eePr
-----END PGP SIGNATURE-----

--=-/xqP11Ag6YOsQz01rA2K--

