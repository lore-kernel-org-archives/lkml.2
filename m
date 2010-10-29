Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab0J2Ghq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:37:46 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:24630 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753248Ab0J2Ghk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:37:40 -0400
Subject: [RFC][PATCH 13/22] sched: add resource limits for -deadline tasks
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-a2O5WNCtspMKW9AkfmKD"
Date: Fri, 29 Oct 2010 08:37:30 +0200
Message-ID: <1288334250.8661.154.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a2O5WNCtspMKW9AkfmKD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Add resource limits for non-root tasks in using the SCHED_DEADLINE
policy, very similarly to what already exists for RT policies.

In fact, this patch:
 - adds the resource limit RLIMIT_DLDLINE, which is the minimum value
   a user task can use as its own deadline;
 - adds the resource limit RLIMIT_DLRTIME, which is the maximum value
   a user task can use as it own runtime.

Notice that to exploit these, a modified version of the ulimit
utility and a modified resource.h header file are needed. They
both will be available on the website of the project.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 include/asm-generic/resource.h |    7 ++++++-
 kernel/sched.c                 |   25 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.=
h
index 587566f..4a1d0e2 100644
--- a/include/asm-generic/resource.h
+++ b/include/asm-generic/resource.h
@@ -45,7 +45,10 @@
 					   0-39 for nice level 19 .. -20 */
 #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
 #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
-#define RLIM_NLIMITS		16
+
+#define RLIMIT_DLDLINE		16	/* minimum deadline in us */
+#define RLIMIT_DLRTIME		17	/* maximum runtime in us */
+#define RLIM_NLIMITS		18
=20
 /*
  * SuS says limits have to be unsigned.
@@ -87,6 +90,8 @@
 	[RLIMIT_NICE]		=3D { 0, 0 },				\
 	[RLIMIT_RTPRIO]		=3D { 0, 0 },				\
 	[RLIMIT_RTTIME]		=3D {  RLIM_INFINITY,  RLIM_INFINITY },	\
+	[RLIMIT_DLDLINE]	=3D { ULONG_MAX, ULONG_MAX },		\
+	[RLIMIT_DLRTIME]	=3D { 0, 0 },				\
 }
=20
 #endif	/* __KERNEL__ */
diff --git a/kernel/sched.c b/kernel/sched.c
index 19c8c25..9165c5e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4903,6 +4903,31 @@ recheck:
 	 * Allow unprivileged RT tasks to decrease priority:
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
+		if (dl_policy(policy)) {
+			u64 rlim_dline, rlim_rtime;
+			u64 dline, rtime;
+
+			if (!lock_task_sighand(p, &flags))
+				return -ESRCH;
+			rlim_dline =3D p->signal->rlim[RLIMIT_DLDLINE].rlim_cur;
+			rlim_rtime =3D p->signal->rlim[RLIMIT_DLRTIME].rlim_cur;
+			unlock_task_sighand(p, &flags);
+
+			/* can't set/change -deadline policy */
+			if (policy !=3D p->policy && !rlim_rtime)
+				return -EPERM;
+
+			/* can't decrease the deadline */
+			rlim_dline *=3D NSEC_PER_USEC;
+			dline =3D timespec_to_ns(&param_ex->sched_deadline);
+			if (dline < p->dl.dl_deadline && dline < rlim_dline)
+				return -EPERM;
+			/* can't increase the runtime */
+			rlim_rtime *=3D NSEC_PER_USEC;
+			rtime =3D timespec_to_ns(&param_ex->sched_runtime);
+			if (rtime > p->dl.dl_runtime && rtime > rlim_rtime)
+				return -EPERM;
+		}
 		if (rt_policy(policy)) {
 			unsigned long rlim_rtprio =3D
 					task_rlimit(p, RLIMIT_RTPRIO);
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-a2O5WNCtspMKW9AkfmKD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKa6oACgkQk4XaBE3IOsRMXQCeKTq+Rj2ANAGBJvervnbdSlNF
auIAn2Dmbb0/xkDgl33YgaEaa0ecEa73
=B9M3
-----END PGP SIGNATURE-----

--=-a2O5WNCtspMKW9AkfmKD--

