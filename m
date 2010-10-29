Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab0J2GhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:37:01 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:47311 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753444Ab0J2Ggz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:36:55 -0400
Subject: [RFC][PATCH 12/22] sched: add runtime reporting for -deadline tasks
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4b7mjbDTaqZHnBYKYbuJ"
Date: Fri, 29 Oct 2010 08:36:42 +0200
Message-ID: <1288334202.8661.153.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4b7mjbDTaqZHnBYKYbuJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Make it available for the user-space the total amount of runtime
time it has used from since it became a -deadline task.

This is something that is typically useful for monitoring from
user-space the task CPU usage, and maybe implementing at that level
some more sophisticated scheduling behaviour.

One example is feedback scheduling, where you try to adapt the
scheduling parameters of a task by looking at its behaviour in
a certain interval of time, applying concepts coming from control
engineering.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |    7 +++----
 kernel/sched.c        |    3 +++
 kernel/sched_debug.c  |    1 +
 kernel/sched_dl.c     |    1 +
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8ae947b..b6f0635 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1242,14 +1242,15 @@ struct sched_rt_entity {
 #endif
 };
=20
-#ifdef CONFIG_SCHEDSTATS
 struct sched_stats_dl {
+#ifdef CONFIG_SCHEDSTATS
 	u64			last_dmiss;
 	u64			last_rorun;
 	u64			dmiss_max;
 	u64			rorun_max;
-};
 #endif
+	u64			tot_rtime;
+};
=20
 struct sched_dl_entity {
 	struct rb_node	rb_node;
@@ -1292,9 +1293,7 @@ struct sched_dl_entity {
 	 */
 	struct hrtimer dl_timer;
=20
-#ifdef CONFIG_SCHEDSTATS
 	struct sched_stats_dl stats;
-#endif
 };
=20
 struct rcu_node;
diff --git a/kernel/sched.c b/kernel/sched.c
index 63a33f6..19c8c25 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4799,6 +4799,8 @@ __setparam_dl(struct task_struct *p, const struct sch=
ed_param_ex *param_ex)
 	dl_se->flags =3D param_ex->sched_flags;
 	dl_se->dl_throttled =3D 0;
 	dl_se->dl_new =3D 1;
+
+	dl_se->stats.tot_rtime =3D 0;
 }
=20
 static void
@@ -4812,6 +4814,7 @@ __getparam_dl(struct task_struct *p, struct sched_par=
am_ex *param_ex)
 	param_ex->sched_period =3D ns_to_timespec(dl_se->dl_period);
 	param_ex->sched_flags =3D dl_se->flags;
 	param_ex->curr_runtime =3D ns_to_timespec(dl_se->runtime);
+	param_ex->used_runtime =3D ns_to_timespec(dl_se->stats.tot_rtime);
 	param_ex->curr_deadline =3D ns_to_timespec(dl_se->deadline);
 }
=20
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index f685f18..9bec524 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -472,6 +472,7 @@ void proc_sched_show_task(struct task_struct *p, struct=
 seq_file *m)
 		PN(dl.stats.dmiss_max);
 		PN(dl.stats.last_rorun);
 		PN(dl.stats.rorun_max);
+		PN(dl.stats.tot_rtime);
 	}
=20
 	{
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index b01aa2a..c4091c9 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -535,6 +535,7 @@ static void update_curr_dl(struct rq *rq)
=20
 	sched_dl_avg_update(rq, delta_exec);
=20
+	dl_se->stats.tot_rtime +=3D delta_exec;
 	dl_se->runtime -=3D delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-4b7mjbDTaqZHnBYKYbuJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKa3oACgkQk4XaBE3IOsRDoQCgpWDX58Q4ah2bB/aQx+GY9DlF
TtkAoJ+nID36aeJ/CHj+HkXy0soap+aA
=1rqq
-----END PGP SIGNATURE-----

--=-4b7mjbDTaqZHnBYKYbuJ--

