Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0J2GZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:25:36 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:4525 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752888Ab0J2GZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:25:30 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2010 02:25:30 EDT
Subject: [RFC][PATCH 01/22] sched: add sched_class->task_dead.
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-piHor+w3npKhyNfJuYFH"
Date: Fri, 29 Oct 2010 08:25:20 +0200
Message-ID: <1288333520.8661.139.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-piHor+w3npKhyNfJuYFH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Add a new function to the scheduling class interface. It is called
at the end of a context switch, if the prev task is in TASK_DEAD state.

It might be useful for the scheduling classes that want to be notified
when one of their task dies, e.g. to perform some cleanup actions.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b3d07df..6053b4b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1068,6 +1068,7 @@ struct sched_class {
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_fork) (struct task_struct *p);
+	void (*task_dead) (struct task_struct *p);
=20
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
 			       int running);
diff --git a/kernel/sched.c b/kernel/sched.c
index 41f1869..07f5a0c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2891,6 +2891,9 @@ static void finish_task_switch(struct rq *rq, struct =
task_struct *prev)
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state =3D=3D TASK_DEAD)) {
+		if (prev->sched_class->task_dead)
+			prev->sched_class->task_dead(prev);
+
 		/*
 		 * Remove function-return probe instances associated with this
 		 * task and put them back on the free list.
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-piHor+w3npKhyNfJuYFH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKaNAACgkQk4XaBE3IOsRlowCeMZBDBRcrWbes5RjduLcxqJIJ
jckAniOqwzc+RTr1/FkddPgdytiTqarG
=y+Ca
-----END PGP SIGNATURE-----

--=-piHor+w3npKhyNfJuYFH--

