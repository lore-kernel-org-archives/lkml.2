Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0J2GdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:33:24 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:7391 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753444Ab0J2GdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:33:20 -0400
Subject: [RFC][PATCH 08/22] sched: SCHED_DEADLINE avg_update accounting
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ljHEP1XuwxWmkwvaIrBc"
Date: Fri, 29 Oct 2010 08:33:10 +0200
Message-ID: <1288333990.8661.149.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ljHEP1XuwxWmkwvaIrBc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Make the core scheduler and load balancer aware of the load
produced by -deadline tasks, by updating the moving average
like for sched_rt.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 kernel/sched.c      |   13 ++++++++++++-
 kernel/sched_dl.c   |    2 ++
 kernel/sched_fair.c |    4 ++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 79e7c1c..7f0780c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -571,7 +571,7 @@ struct rq {
=20
 	unsigned long avg_load_per_task;
=20
-	u64 rt_avg;
+	u64 dl_avg, rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
 	u64 avg_idle;
@@ -1346,10 +1346,17 @@ static void sched_avg_update(struct rq *rq)
 		 */
 		asm("" : "+rm" (rq->age_stamp));
 		rq->age_stamp +=3D period;
+		rq->dl_avg /=3D 2;
 		rq->rt_avg /=3D 2;
 	}
 }
=20
+static void sched_dl_avg_update(struct rq *rq, u64 dl_delta)
+{
+	rq->dl_avg +=3D dl_delta;
+	sched_avg_update(rq);
+}
+
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
 	rq->rt_avg +=3D rt_delta;
@@ -1363,6 +1370,10 @@ static void resched_task(struct task_struct *p)
 	set_tsk_need_resched(p);
 }
=20
+static void sched_dl_avg_update(struct rq *rq, u64 dl_delta)
+{
+}
+
 static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
 }
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 26126a6..1bb4308 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -509,6 +509,8 @@ static void update_curr_dl(struct rq *rq)
 	curr->se.exec_start =3D rq->clock;
 	cpuacct_charge(curr, delta_exec);
=20
+	sched_dl_avg_update(rq, delta_exec);
+
 	dl_se->runtime -=3D delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 54c869c..2afe280 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2276,11 +2276,11 @@ unsigned long scale_rt_power(int cpu)
=20
 	total =3D sched_avg_period() + (rq->clock - rq->age_stamp);
=20
-	if (unlikely(total < rq->rt_avg)) {
+	if (unlikely(total < rq->dl_avg + rq->rt_avg)) {
 		/* Ensures that power won't end up being negative */
 		available =3D 0;
 	} else {
-		available =3D total - rq->rt_avg;
+		available =3D total - rq->dl_avg - rq->rt_avg;
 	}
=20
 	if (unlikely((s64)total < SCHED_LOAD_SCALE))
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-ljHEP1XuwxWmkwvaIrBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKaqYACgkQk4XaBE3IOsTQ7ACdGdaXji/sQG6Ju+UWwu0BZJhs
cG8An1Bj/pXXmIdumie3bBjrHVRCbvq9
=5jUT
-----END PGP SIGNATURE-----

--=-ljHEP1XuwxWmkwvaIrBc--

