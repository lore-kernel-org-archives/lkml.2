Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0J2GeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:34:25 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:49022 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753958Ab0J2GeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:34:21 -0400
Subject: [RFC][PATCH 09/22] sched: add period support for -deadline tasks
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YDZIp87j2AVq6JNyAIpg"
Date: Fri, 29 Oct 2010 08:34:10 +0200
Message-ID: <1288334050.8661.150.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YDZIp87j2AVq6JNyAIpg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Make it possible to specify a period (different or equal than
deadline) for -deadline tasks.

Signed-off-by: Harald Gustafsson <harald.gustafsson@ericsson.com>
Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   12 +++++++++++-
 kernel/sched_dl.c     |    8 ++++++--
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f25d3a6..83fa2b5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1251,6 +1251,7 @@ struct sched_dl_entity {
 	 */
 	u64 dl_runtime;		/* maximum runtime for each instance 	*/
 	u64 dl_deadline;	/* relative deadline of each instance	*/
+	u64 dl_period;		/* separation of two instances (period) */
=20
 	/*
 	 * Actual scheduling parameters. Initialized with the values above,
diff --git a/kernel/sched.c b/kernel/sched.c
index 7f0780c..4491f7d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2708,6 +2708,7 @@ static void __sched_fork(struct task_struct *p)
 	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	p->dl.dl_runtime =3D p->dl.runtime =3D 0;
 	p->dl.dl_deadline =3D p->dl.deadline =3D 0;
+	p->dl.dl_period =3D 0;
 	p->dl.flags =3D 0;
=20
 	INIT_LIST_HEAD(&p->rt.run_list);
@@ -4789,6 +4790,10 @@ __setparam_dl(struct task_struct *p, const struct sc=
hed_param_ex *param_ex)
 	init_dl_task_timer(dl_se);
 	dl_se->dl_runtime =3D timespec_to_ns(&param_ex->sched_runtime);
 	dl_se->dl_deadline =3D timespec_to_ns(&param_ex->sched_deadline);
+	if (timespec_to_ns(&param_ex->sched_period) !=3D 0)
+		dl_se->dl_period =3D timespec_to_ns(&param_ex->sched_period);
+	else
+		dl_se->dl_period =3D dl_se->dl_deadline;
 	dl_se->flags =3D param_ex->sched_flags;
 	dl_se->dl_throttled =3D 0;
 	dl_se->dl_new =3D 1;
@@ -4802,6 +4807,7 @@ __getparam_dl(struct task_struct *p, struct sched_par=
am_ex *param_ex)
 	param_ex->sched_priority =3D p->rt_priority;
 	param_ex->sched_runtime =3D ns_to_timespec(dl_se->dl_runtime);
 	param_ex->sched_deadline =3D ns_to_timespec(dl_se->dl_deadline);
+	param_ex->sched_period =3D ns_to_timespec(dl_se->dl_period);
 	param_ex->sched_flags =3D dl_se->flags;
 	param_ex->curr_runtime =3D ns_to_timespec(dl_se->runtime);
 	param_ex->curr_deadline =3D ns_to_timespec(dl_se->deadline);
@@ -4810,7 +4816,8 @@ __getparam_dl(struct task_struct *p, struct sched_par=
am_ex *param_ex)
 /*
  * This function validates the new parameters of a -deadline task.
  * We ask for the deadline not being zero, and greater or equal
- * than the runtime.
+ * than the runtime, as well as the period of being zero or
+ * not greater than deadline.
  */
 static bool
 __checkparam_dl(const struct sched_param_ex *prm, bool kthread)
@@ -4822,6 +4829,9 @@ __checkparam_dl(const struct sched_param_ex *prm, boo=
l kthread)
 		return kthread;
=20
 	return timespec_to_ns(&prm->sched_deadline) !=3D 0 &&
+	       (timespec_to_ns(&prm->sched_period) =3D=3D 0 ||
+		timespec_compare(&prm->sched_period,
+				 &prm->sched_deadline) >=3D 0) &&
 	       timespec_compare(&prm->sched_deadline,
 				&prm->sched_runtime) >=3D 0;
 }
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 1bb4308..31fb771 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -263,7 +263,7 @@ static void replenish_dl_entity(struct sched_dl_entity =
*dl_se)
 	 * arbitrary large.
 	 */
 	while (dl_se->runtime <=3D 0) {
-		dl_se->deadline +=3D dl_se->dl_deadline;
+		dl_se->deadline +=3D dl_se->dl_period;
 		dl_se->runtime +=3D dl_se->dl_runtime;
 	}
=20
@@ -290,7 +290,11 @@ static void replenish_dl_entity(struct sched_dl_entity=
 *dl_se)
  * assigned (function returns true if it can).
  *
  * For this to hold, we must check if:
- *   runtime / (deadline - t) < dl_runtime / dl_deadline .
+ *   runtime / (deadline - t) < dl_runtime / dl_period .
+ *
+ * Notice that the bandwidth check is done against the period. For
+ * task with deadline equal to period this is the same of using
+ * dl_deadline instead of dl_period in the equation above.
  */
 static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
 {
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-YDZIp87j2AVq6JNyAIpg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKauIACgkQk4XaBE3IOsShfgCffonUJRqs2QvkuoIvS4KNEEEW
yd8AoIZ579L1VVQVYRxMR2XQ2orgAQ25
=wZdJ
-----END PGP SIGNATURE-----

--=-YDZIp87j2AVq6JNyAIpg--

