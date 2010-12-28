Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0L1Kz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 05:55:57 -0500
Received: from ms01.sssup.it ([193.205.80.99]:56241 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753084Ab0L1Kz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 05:55:56 -0500
Subject: [PATCH resend] Reading POSIX CPU timer from outside the process.
From: Dario Faggioli <raistlin@linux.it>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        oleg <oleg@redhat.com>, john.stultz@linaro.org, roland@redhat.com,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <1293121303.3390.185.camel@Palantir>
References: <1293121303.3390.185.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hYqsFq3P+KifBzEvCZob"
Date: Tue, 28 Dec 2010 11:55:42 +0100
Message-ID: <1293533742.2899.1028.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hYqsFq3P+KifBzEvCZob
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Trying to call clock_getcpuclockid (and then clock_gettime) on a thread
from outside the process that spawned it results in this:
  ### Testing tid 24207: CPU-time clock for PID 24207 is 1.132371729 second=
s
  ### Testing tid 24209: clock_getcpuclockid: Success

OTOH, if full-fledged processes are involved, the behaviour is this:
  ### Testing tid 24218: CPU-time clock for PID 24218 is 0.001059305 second=
s
  ### Testing tid 24220: CPU-time clock for PID 24220 is 1.044057391 second=
s

Test programs available here: http://gitorious.org/clockid

All that because clock_getcpuclockid forbids accessing thread
specific CPU-time clocks from outside the thread group, but this is not
requested (e.g., by POSIX), or at least no indication that it should fail
can be found in `man clock_getcpuclockid' and alike.
Moreover, having such capability could be useful, if you want to monitor
the execution of a bunch of thread from some kind of "manager" which might
not be part of the same process. A typical example is the JACK graph-manage=
r.

Therefore, this commit makes clock_getcpuclockid behave as follows:
 - if it's called on a tid which is also a PID (i.e., the thread is
   a thread group leader), it returns the CLOCK_PROCESS_CPUTIME_ID of
   the process;
 - if it's called on a tid of a non-group leader, it returns the
   CLOCK_THREAD_CPUTIME_ID of such specific thread.

This enables the following behaviour, for the threaded and process-based
scenarios, respectively:

  ### Testing tid 24704: CPU-time clock for PID 24704 is 1.049570008 second=
s
  ### Testing tid 24706: CPU-time clock for PID 24706 is 1.028650801 second=
s

  ### Testing tid 24715: CPU-time clock for PID 24715 is 0.000957685 second=
s
  ### Testing tid 24717: CPU-time clock for PID 24717 is 1.045351509 second=
s

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 kernel/posix-cpu-timers.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 05bb717..ddbbabc 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -39,10 +39,9 @@ static int check_clock(const clockid_t which_clock)
=20
 	rcu_read_lock();
 	p =3D find_task_by_vpid(pid);
-	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
-		   same_thread_group(p, current) : has_group_leader_pid(p))) {
+	if (!p || (CPUCLOCK_PERTHREAD(which_clock) &&
+		   same_thread_group(p, current) && !has_group_leader_pid(p)))
 		error =3D -EINVAL;
-	}
 	rcu_read_unlock();
=20
 	return error;
@@ -349,11 +348,9 @@ int posix_cpu_clock_get(const clockid_t which_clock, s=
truct timespec *tp)
 		rcu_read_lock();
 		p =3D find_task_by_vpid(pid);
 		if (p) {
-			if (CPUCLOCK_PERTHREAD(which_clock)) {
-				if (same_thread_group(p, current)) {
-					error =3D cpu_clock_sample(which_clock,
-								 p, &rtn);
-				}
+			if (CPUCLOCK_PERTHREAD(which_clock) ||
+			    !thread_group_leader(p)) {
+				error =3D cpu_clock_sample(which_clock, p, &rtn);
 			} else {
 				read_lock(&tasklist_lock);
 				if (thread_group_leader(p) && p->sighand) {
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-hYqsFq3P+KifBzEvCZob
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0Zwi4ACgkQk4XaBE3IOsQmYQCgiU0A06P/Vs5L3T+FAE0mTmdy
Ff4An28oBkwpx3urdAKNGgl2HFsU8/KQ
=F+2T
-----END PGP SIGNATURE-----

--=-hYqsFq3P+KifBzEvCZob--

