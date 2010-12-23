Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0LWQV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 11:21:56 -0500
Received: from ms01.sssup.it ([193.205.80.99]:36870 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752846Ab0LWQVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 11:21:55 -0500
Subject: [PATCH] Read THREAD_CPUTIME clock from other  processes.
From: Dario Faggioli <raistlin@linux.it>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, torbenh <torbenh@gmx.de>,
        oleg <oleg@redhat.com>, john.stultz@linaro.org, roland@redhat.com,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-40XQ9HkjWZVkE7tABX7f"
Date: Thu, 23 Dec 2010 17:21:43 +0100
Message-ID: <1293121303.3390.185.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-40XQ9HkjWZVkE7tABX7f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Trying to read CLOCK_THREAD_CPUTIME_ID of a thread from outside
the process that spawned it with this code:

        if (clock_getcpuclockid(tid, &clockid) !=3D 0) {
                perror("clock_getcpuclockid");
                exit(EXIT_FAILURE);
        }

results in this:
  ### Testing tid 24207: CPU-time clock for PID 24207 is 1.132371729 second=
s
  ### Testing tid 24209: clock_getcpuclockid: Success

OTH, if full-fledged processes are involved, the behaviour is this:
  ### Testing tid 24218: CPU-time clock for PID 24218 is 0.001059305 second=
s
  ### Testing tid 24220: CPU-time clock for PID 24220 is 1.044057391 second=
s

Test programs available here: http://gitorious.org/clockid.

This is because clock_getcpuclockid forbids accessing thread
specific CPU-time clocks from outside the thread group. This is
not requested (e.g., by POSIX) to be like this, or at least no
indication that such operation should fail can be found in
`man clock_getcpuclockid' and alike.

However, having such capability could be useful, if you want
to monitor the execution of a bunch of thread from some kind of
"manager" which might not be part of the same process. A typical
example that could benefit from this could be the JACK graph-manager.

Therefore, this patch removes such limitation and enables the
following behaviour, for the threaded and process-based case,
respectively:

  ### Testing tid 24704: CPU-time clock for PID 24704 is 1.049570008 second=
s
  ### Testing tid 24706: CPU-time clock for PID 24706 is 1.028650801seconds

  ### Testing tid 24715: CPU-time clock for PID 24715 is 0.000957685 second=
s
  ### Testing tid 24717: CPU-time clock for PID 24717 is 1.045351509 second=
s

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 kernel/posix-cpu-timers.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 05bb717..b0ed8cf 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -39,10 +39,8 @@ static int check_clock(const clockid_t which_clock)
=20
 	rcu_read_lock();
 	p =3D find_task_by_vpid(pid);
-	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
-		   same_thread_group(p, current) : has_group_leader_pid(p))) {
+	if (!p)
 		error =3D -EINVAL;
-	}
 	rcu_read_unlock();
=20
 	return error;
@@ -349,18 +347,21 @@ int posix_cpu_clock_get(const clockid_t which_clock, =
struct timespec *tp)
 		rcu_read_lock();
 		p =3D find_task_by_vpid(pid);
 		if (p) {
-			if (CPUCLOCK_PERTHREAD(which_clock)) {
-				if (same_thread_group(p, current)) {
-					error =3D cpu_clock_sample(which_clock,
-								 p, &rtn);
-				}
+
+			if (CPUCLOCK_PERTHREAD(which_clock) &&
+			    same_thread_group(p, current)) {
+				error =3D cpu_clock_sample(which_clock,
+							 p, &rtn);
 			} else {
 				read_lock(&tasklist_lock);
-				if (thread_group_leader(p) && p->sighand) {
+				if (!CPUCLOCK_PERTHREAD(which_clock) &&
+				    thread_group_leader(p) && p->sighand)
 					error =3D
 					    cpu_clock_sample_group(which_clock,
-							           p, &rtn);
-				}
+								   p, &rtn);
+				else
+					error =3D cpu_clock_sample(which_clock,
+								 p, &rtn);
 				read_unlock(&tasklist_lock);
 			}
 		}
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-40XQ9HkjWZVkE7tABX7f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0TdxcACgkQk4XaBE3IOsTLOQCgi0wjdcNzarCz4DF3HSSedNVQ
bp4AmQHcOZnEBCm2nQDKHDpdFFIV5XVE
=IAEm
-----END PGP SIGNATURE-----

--=-40XQ9HkjWZVkE7tABX7f--

