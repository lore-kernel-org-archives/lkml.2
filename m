Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab2KHU1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:27:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624Ab2KHU1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:27:41 -0500
Date: Thu, 8 Nov 2012 14:27:19 -0600
From: Clark Williams <williams@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] sched: add a tuning knob to allow changing RR tmeslice
Message-ID: <20121108142719.1e0dfc24@redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XnCY1vx3b=+WN5sOpPHLxI9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XnCY1vx3b=+WN5sOpPHLxI9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Subject: [PATCH] sched: add a tuning knob to allow changing RR timeslice

User wanted a facility simliar to the ability on Solaris to adjust
the SCHED_RR timeslice value. Add a /proc/sys/kernel scheduler knob
named sched_rr_timeslice_ms which allows global changing of the SCHED_RR
timeslice value. User visable value is in milliseconds but is stored as
jiffies.  Setting to 0 (zero) resets to the default (currently 100ms).

Patch against tip/master, currently 3.7-rc3.

Signed-off-by: Clark Williams <williams@redhat.com>
---
 include/linux/sched.h |  6 +++++-
 kernel/sched.c        | 19 +++++++++++++++++++
 kernel/sched_rt.c     |  4 ++--
 kernel/sysctl.c       |  8 ++++++++
 4 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 12317b6..214bf27 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2097,11 +2097,15 @@ static inline unsigned int get_sysctl_timer_migrati=
on(void)
 #endif
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
-
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
=20
+extern int sched_rr_timeslice;
+extern int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern unsigned int sysctl_sched_autogroup_enabled;
=20
diff --git a/kernel/sched.c b/kernel/sched.c
index cdf9484..c63c3a4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -120,6 +120,7 @@
  * Timeslices get refilled after they expire.
  */
 #define DEF_TIMESLICE		(100 * HZ / 1000)
+int sched_rr_timeslice =3D DEF_TIMESLICE;
=20
 /*
  * single value that denotes runtime =3D=3D period, ie unlimited time.
@@ -9614,6 +9615,24 @@ static int sched_rt_global_constraints(void)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
=20
+int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+	static DEFINE_MUTEX(mutex);
+
+	mutex_lock(&mutex);
+	ret =3D proc_dointvec(table, write, buffer, lenp, ppos);
+	/* make sure that internally we keep jiffies */
+	/* also, writing zero resets timeslice to default */
+	if (!ret && write)=20
+		sched_rr_timeslice =3D sched_rr_timeslice <=3D 0 ?=20
+			DEF_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
+	mutex_unlock(&mutex);
+	return ret;
+}
+
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index c108b9c..799dd09 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1791,7 +1791,7 @@ static void task_tick_rt(struct rq *rq, struct task_s=
truct *p, int queued)
 	if (--p->rt.time_slice)
 		return;
=20
-	p->rt.time_slice =3D DEF_TIMESLICE;
+	p->rt.time_slice =3D sched_rr_timeslice;
=20
 	/*
 	 * Requeue to the end of queue if we are not the only element
@@ -1819,7 +1819,7 @@ static unsigned int get_rr_interval_rt(struct rq *rq,=
 struct task_struct *task)
 	 * Time slice is 0 for SCHED_FIFO tasks
 	 */
 	if (task->policy =3D=3D SCHED_RR)
-		return DEF_TIMESLICE;
+		return sched_rr_timeslice;
 	else
 		return 0;
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ea7ec7f..10b1129 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -362,6 +362,14 @@ static struct ctl_table kern_table[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D sched_rt_handler,
 	},
+	{
+		.procname	=3D "sched_rr_timeslice_ms",
+		.data		=3D &sched_rr_timeslice,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D sched_rr_handler,
+	},
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	=3D "sched_autogroup_enabled",
--=20
1.7.11.7


--Sig_/XnCY1vx3b=+WN5sOpPHLxI9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAlCcFacACgkQHyuj/+TTEp2GyACdGbY/CF9fH69jUzeCgh66KiVr
MK0AmgOFPNwTEqbtFcZhKd++Z2tpeMxQ
=+Zv5
-----END PGP SIGNATURE-----

--Sig_/XnCY1vx3b=+WN5sOpPHLxI9--
