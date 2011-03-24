Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab1CXOBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:01:44 -0400
Received: from ms01.sssup.it ([193.205.80.99]:43114 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753430Ab1CXOBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:01:43 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 10:01:43 EDT
Subject: [PATCH] sched: leave sched_setscheduler earlier if possible.
From: Dario Faggioli <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gregory Haskins <ghaskins@novell.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-axY1EIqemCSNa54lUm4Q"
Date: Thu, 24 Mar 2011 14:00:18 +0100
Message-ID: <1300971618.3960.82.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-axY1EIqemCSNa54lUm4Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

sched_setscheduler (in sched.c) is called in order of changing the
scheduling policy and/or the real-time priority of a task. Thus,
if we find out that neither of those are actually being modified, it
is possible to return earlier and save the overhead of a full
deactivate+activate cycle of the task in question.

Beside that, if we have more than one SCHED_FIFO task with the same
priority on the same rq (which means they share the same priority queue)
having one of them changing its position in the priority queue because of
a sched_setscheduler (as it happens by means of the deactivate+activate)
that does not actually change the priority violates POSIX which states,
for SCHED_FIFO:

"If a thread whose policy or priority has been modified by
pthread_setschedprio() is a running thread or is runnable, the effect on
its position in the thread list depends on the direction of the
modification, as follows: a. <...> b. If the priority is unchanged, the
thread does not change position in the thread list. c. <...>"

(http://pubs.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.htm=
l)

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 kernel/sched.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c5ae6bc..d73bbc5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4998,6 +4998,16 @@ recheck:
 		return -EINVAL;
 	}
=20
+	/*
+	 * If not changing anything there's no need to proceed further
+	 */
+	if (unlikely(policy =3D=3D p->policy && (!rt_policy(policy) ||
+	    param->sched_priority =3D=3D p->rt_priority))) {
+			__task_rq_unlock(rq);
+			raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+			return 0;
+	}
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (user) {
 		/*
--=20
1.7.4.1

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org


--=-axY1EIqemCSNa54lUm4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk2LQGIACgkQk4XaBE3IOsRQOgCgi/B/nB8jdXORA7tfIdeuI27t
Tz0AnRdSNXRKbBjdDzbQzsPm/ssIWueo
=DBWs
-----END PGP SIGNATURE-----

--=-axY1EIqemCSNa54lUm4Q--

