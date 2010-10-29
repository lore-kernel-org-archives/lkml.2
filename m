Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0J2G3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:29:23 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:28216 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753777Ab0J2G3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:29:17 -0400
Subject: [RFC][PATCH 04/22] sched: SCHED_DEADLINE SMP-related data
 structures
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9t7ChZ+c2iMJm8agd8zx"
Date: Fri, 29 Oct 2010 08:29:06 +0200
Message-ID: <1288333746.8661.144.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9t7ChZ+c2iMJm8agd8zx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Introduce data structures relevant for implementing dynamic
migration of -deadline tasks.

Mainly, this is the logic for checking if runqueues are
overloaded with -deadline tasks and for choosing where
a task should migrate, when it is the case.

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   58 +++++++++++++++++++++++++++++++++++++++++++++=
+++-
 2 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c72a132..f94da51 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1336,6 +1336,7 @@ struct task_struct {
=20
 	struct list_head tasks;
 	struct plist_node pushable_tasks;
+	struct rb_node pushable_dl_tasks;
=20
 	struct mm_struct *mm, *active_mm;
 #if defined(SPLIT_RSS_COUNTING)
diff --git a/kernel/sched.c b/kernel/sched.c
index d157358..b11e888 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -424,6 +424,35 @@ struct dl_rq {
 	struct rb_node *rb_leftmost;
=20
 	unsigned long dl_nr_running;
+
+#ifdef CONFIG_SMP
+	/*
+	 * Deadline values of the currently executing and the
+	 * earliest ready task on this rq. Caching these facilitates
+	 * the decision wether or not a ready but not running task
+	 * should migrate somewhere else.
+	 */
+	struct {
+		u64 curr;
+		u64 next;
+	} earliest_dl;
+
+	unsigned long dl_nr_migratory;
+	unsigned long dl_nr_total;
+	int overloaded;
+
+	/*
+	 * Tasks on this rq that can be pushed away. They are kept in
+	 * an rb-tree, ordered by tasks' deadlines, with caching
+	 * of the leftmost (earliest deadline) element.
+	 */
+	struct rb_root pushable_dl_tasks_root;
+	struct rb_node *pushable_dl_tasks_leftmost;
+#endif
+
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+	struct rq *rq;
+#endif
 };
=20
 #ifdef CONFIG_SMP
@@ -442,6 +471,13 @@ struct root_domain {
 	cpumask_var_t online;
=20
 	/*
+	 * The bit corresponding to a CPU gets set here if such CPU has more
+	 * than one runnable -deadline task (as it is below for RT tasks).
+	 */
+	cpumask_var_t dlo_mask;
+	atomic_t dlo_count;
+
+	/*
 	 * The "RT overload" flag: it gets set if a CPU has more than
 	 * one runnable RT task.
 	 */
@@ -2742,6 +2778,7 @@ void sched_fork(struct task_struct *p, int clone_flag=
s)
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count =3D 1;
 #endif
+	RB_CLEAR_NODE(&p->pushable_dl_tasks);
 	plist_node_init(&p->pushable_tasks, MAX_PRIO);
=20
 	put_cpu();
@@ -5804,6 +5841,7 @@ again:
 		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
 		cpumask_copy(&p->cpus_allowed, new_mask);
+		p->dl.nr_cpus_allowed =3D cpumask_weight(new_mask);
 		p->rt.nr_cpus_allowed =3D cpumask_weight(new_mask);
 	}
=20
@@ -6551,6 +6589,7 @@ static void free_rootdomain(struct root_domain *rd)
=20
 	cpupri_cleanup(&rd->cpupri);
=20
+	free_cpumask_var(rd->dlo_mask);
 	free_cpumask_var(rd->rto_mask);
 	free_cpumask_var(rd->online);
 	free_cpumask_var(rd->span);
@@ -6602,8 +6641,10 @@ static int init_rootdomain(struct root_domain *rd)
 		goto out;
 	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
 		goto free_span;
-	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&rd->dlo_mask, GFP_KERNEL))
 		goto free_online;
+	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
+		goto free_dlo_mask;
=20
 	if (cpupri_init(&rd->cpupri) !=3D 0)
 		goto free_rto_mask;
@@ -6611,6 +6652,8 @@ static int init_rootdomain(struct root_domain *rd)
=20
 free_rto_mask:
 	free_cpumask_var(rd->rto_mask);
+free_dlo_mask:
+	free_cpumask_var(rd->dlo_mask);
 free_online:
 	free_cpumask_var(rd->online);
 free_span:
@@ -8033,6 +8076,19 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct r=
q *rq)
 static void init_dl_rq(struct dl_rq *dl_rq, struct rq *rq)
 {
 	dl_rq->rb_root =3D RB_ROOT;
+
+#ifdef CONFIG_SMP
+	/* zero means no -deadline tasks */
+	dl_rq->earliest_dl.curr =3D dl_rq->earliest_dl.next =3D 0;
+
+	dl_rq->dl_nr_migratory =3D 0;
+	dl_rq->overloaded =3D 0;
+	dl_rq->pushable_dl_tasks_root =3D RB_ROOT;
+#endif
+
+#ifdef CONFIG_DEADLINE_GROUP_SCHED
+	dl_rq->rq =3D rq;
+#endif
 }
=20
 #ifdef CONFIG_FAIR_GROUP_SCHED
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-9t7ChZ+c2iMJm8agd8zx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKabIACgkQk4XaBE3IOsQTOACfbObOl17ev/1ZIZU8lahj/h1T
PPoAoJLMc7IYe97xA5XiTsBFta5SKBf0
=CTcw
-----END PGP SIGNATURE-----

--=-9t7ChZ+c2iMJm8agd8zx--

