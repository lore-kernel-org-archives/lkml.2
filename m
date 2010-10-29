Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab0J2GgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:36:11 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:6680 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754762Ab0J2GgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:36:06 -0400
Subject: [RFC][PATCH 11/22] sched: add schedstats for -deadline tasks
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-E1LEhD8pWNpvixpz0CBg"
Date: Fri, 29 Oct 2010 08:35:53 +0200
Message-ID: <1288334153.8661.152.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E1LEhD8pWNpvixpz0CBg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Add some typical sched-debug output to dl_rq(s) and some
schedstats to -deadline tasks.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |   13 +++++++++++++
 kernel/sched.c        |    2 ++
 kernel/sched_debug.c  |   43 +++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_dl.c     |   42 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e301eea..8ae947b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1242,6 +1242,15 @@ struct sched_rt_entity {
 #endif
 };
=20
+#ifdef CONFIG_SCHEDSTATS
+struct sched_stats_dl {
+	u64			last_dmiss;
+	u64			last_rorun;
+	u64			dmiss_max;
+	u64			rorun_max;
+};
+#endif
+
 struct sched_dl_entity {
 	struct rb_node	rb_node;
 	int nr_cpus_allowed;
@@ -1282,6 +1291,10 @@ struct sched_dl_entity {
 	 * own bandwidth to be enforced, thus we need one timer per task.
 	 */
 	struct hrtimer dl_timer;
+
+#ifdef CONFIG_SCHEDSTATS
+	struct sched_stats_dl stats;
+#endif
 };
=20
 struct rcu_node;
diff --git a/kernel/sched.c b/kernel/sched.c
index 619d091..63a33f6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -425,6 +425,8 @@ struct dl_rq {
=20
 	unsigned long dl_nr_running;
=20
+	u64 exec_clock;
+
 #ifdef CONFIG_SMP
 	/*
 	 * Deadline values of the currently executing and the
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 2e1b0d1..f685f18 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -243,6 +243,42 @@ void print_rt_rq(struct seq_file *m, int cpu, struct r=
t_rq *rt_rq)
 #undef P
 }
=20
+void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
+{
+	s64 min_deadline =3D -1, max_deadline =3D -1;
+	struct rq *rq =3D cpu_rq(cpu);
+	struct sched_dl_entity *last;
+	unsigned long flags;
+
+	SEQ_printf(m, "\ndl_rq[%d]:\n", cpu);
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	if (dl_rq->rb_leftmost)
+		min_deadline =3D (rb_entry(dl_rq->rb_leftmost,
+					 struct sched_dl_entity,
+					 rb_node))->deadline;
+	last =3D __pick_dl_last_entity(dl_rq);
+	if (last)
+		max_deadline =3D last->deadline;
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+
+#define P(x) \
+	SEQ_printf(m, "  .%-30s: %Ld\n", #x, (long long)(dl_rq->x))
+#define __PN(x) \
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(x))
+#define PN(x) \
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(dl_rq->x))
+
+	P(dl_nr_running);
+	PN(exec_clock);
+	__PN(min_deadline);
+	__PN(max_deadline);
+
+#undef PN
+#undef __PN
+#undef P
+}
+
 static void print_cpu(struct seq_file *m, int cpu)
 {
 	struct rq *rq =3D cpu_rq(cpu);
@@ -302,6 +338,7 @@ static void print_cpu(struct seq_file *m, int cpu)
 #endif
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
+	print_dl_stats(m, cpu);
=20
 	print_rq(m, rq, cpu);
 }
@@ -430,6 +467,12 @@ void proc_sched_show_task(struct task_struct *p, struc=
t seq_file *m)
 	P(se.statistics.nr_wakeups_affine_attempts);
 	P(se.statistics.nr_wakeups_passive);
 	P(se.statistics.nr_wakeups_idle);
+	if (dl_task(p)) {
+		PN(dl.stats.last_dmiss);
+		PN(dl.stats.dmiss_max);
+		PN(dl.stats.last_rorun);
+		PN(dl.stats.rorun_max);
+	}
=20
 	{
 		u64 avg_atom, avg_per_cpu;
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index c8eb304..b01aa2a 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -465,6 +465,25 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl=
_entity *dl_se)
 	int rorun =3D dl_se->runtime <=3D 0;
=20
 	/*
+	 * Record statistics about last and maximum deadline
+	 * misses and runtime overruns.
+	 */
+	if (dmiss) {
+		u64 damount =3D rq->clock - dl_se->deadline;
+
+		schedstat_set(dl_se->stats.last_dmiss, damount);
+		schedstat_set(dl_se->stats.dmiss_max,
+			      max(dl_se->stats.dmiss_max, damount));
+	}
+	if (rorun) {
+		u64 ramount =3D -dl_se->runtime;
+
+		schedstat_set(dl_se->stats.last_rorun, ramount);
+		schedstat_set(dl_se->stats.rorun_max,
+			      max(dl_se->stats.rorun_max, ramount));
+	}
+
+	/*
 	 * No need for checking if it's time to enforce the
 	 * bandwidth for the tasks that are:
 	 *  - maximum priority (SF_HEAD),
@@ -508,6 +527,7 @@ static void update_curr_dl(struct rq *rq)
 		      max(curr->se.statistics.exec_max, delta_exec));
=20
 	curr->se.sum_exec_runtime +=3D delta_exec;
+	schedstat_add(&rq->dl, exec_clock, delta_exec);
 	account_group_exec_runtime(curr, delta_exec);
=20
 	curr->se.exec_start =3D rq->clock;
@@ -898,6 +918,16 @@ static void start_hrtick_dl(struct rq *rq, struct task=
_struct *p)
 }
 #endif
=20
+static struct sched_dl_entity *__pick_dl_last_entity(struct dl_rq *dl_rq)
+{
+	struct rb_node *last =3D rb_last(&dl_rq->rb_root);
+
+	if (!last)
+		return NULL;
+
+	return rb_entry(last, struct sched_dl_entity, rb_node);
+}
+
 static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
 						   struct dl_rq *dl_rq)
 {
@@ -1573,3 +1603,15 @@ static const struct sched_class dl_sched_class =3D {
 	.switched_to		=3D switched_to_dl,
 };
=20
+#ifdef CONFIG_SCHED_DEBUG
+extern void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq);
+
+static void print_dl_stats(struct seq_file *m, int cpu)
+{
+	struct dl_rq *dl_rq =3D &cpu_rq(cpu)->dl;
+
+	rcu_read_lock();
+	print_dl_rq(m, cpu, dl_rq);
+	rcu_read_unlock();
+}
+#endif /* CONFIG_SCHED_DEBUG */
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-E1LEhD8pWNpvixpz0CBg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKa0kACgkQk4XaBE3IOsTKvgCeJxdyH9g5jKEWyn6tzfjGhkTA
pDAAniLcO1GvJGD+/j7miNEga8esv1MT
=gNRK
-----END PGP SIGNATURE-----

--=-E1LEhD8pWNpvixpz0CBg--

