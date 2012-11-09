Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2KIBvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 20:51:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066Ab2KIBvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 20:51:37 -0500
Date: Thu, 8 Nov 2012 19:51:13 -0600
From: Clark Williams <williams@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2] sched: add a tuning knob to allow changing RR tmeslice
Message-ID: <20121108195113.2dd51d43@redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pO7WSUl+BFUNZ_qvNRWh/6y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pO7WSUl+BFUNZ_qvNRWh/6y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


This version stores the user-input value in a separate location from
the jiffies values used by the scheduler, to prevent a race condition.

Subject: [PATCH v2] sched: add a tuning knob to allow changing RR
timeslice

User wanted a facility simliar to the ability on Solaris to adjust
the SCHED_RR timeslice value. Add a /proc/sys/kernel scheduler knob
named sched_rr_timeslice_ms which allows global changing of the SCHED_RR
timeslice value. User visable value is in milliseconds but is stored as
jiffies.  Setting to 0 (zero) resets to the default (currently 100ms).

Patch against tip/master, currently 3.7-rc3.

Signed-off-by: Clark Williams <williams@redhat.com>
---
 include/linux/sched.h |  7 ++++++-
 kernel/sched/core.c   | 30 ++++++++++++++++++++++++++++++
 kernel/sched/rt.c     |  4 ++--
 kernel/sysctl.c       |  7 +++++++
 4 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 03be150..1e2f38a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2071,11 +2071,16 @@ static inline unsigned int
get_sysctl_timer_migration(void) #endif /* CONFIG_SCHED_DEBUG */
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
-
+extern int sysctl_sched_rr_timeslice_ms;
+extern int sched_rr_timeslice;
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
=20
+int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern unsigned int sysctl_sched_autogroup_enabled;
=20
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c2e077c..318f617 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -288,6 +288,17 @@ __read_mostly int scheduler_running;
 int sysctl_sched_rt_runtime =3D 950000;
=20
=20
+/*
+ * SCHED_RR timeslice in jiffies
+ *
+ */
+int sched_rr_timeslice =3D RR_TIMESLICE;
+int sysctl_sched_rr_timeslice_ms;
+
+static inline void init_rr_timeslice()
+{
+	sysctl_sched_rr_timeslice_ms =3D msecs_to_jiffies(RR_TIMESLICE);
+}
=20
 /*
  * __task_rq_lock - lock the rq @p resides on.
@@ -6863,6 +6874,8 @@ void __init sched_init(void)
 	init_rt_bandwidth(&def_rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
=20
+	init_rr_timeslice();
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	init_rt_bandwidth(&root_task_group.rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
@@ -7543,6 +7556,23 @@ int sched_rt_handler(struct ctl_table *table,
int write, return ret;
 }
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
+	/* make sure we maintain jiffies internally */
+	if (!ret && write)
+		sched_rr_timeslice =3D (sysctl_sched_rr_timeslice_ms <=3D
0) ?
+			RR_TIMESLICE :
msecs_to_jiffies(sysctl_sched_rr_timeslice_ms);
+	mutex_unlock(&mutex);
+	return ret;
+}
+
 #ifdef CONFIG_CGROUP_SCHED
=20
 /* return corresponding task_group object of a cgroup */
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..71aa6d0 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2010,7 +2010,7 @@ static void task_tick_rt(struct rq *rq, struct
task_struct *p, int queued) if (--p->rt.time_slice)
 		return;
=20
-	p->rt.time_slice =3D RR_TIMESLICE;
+	p->rt.time_slice =3D sched_rr_timeslice;
=20
 	/*
 	 * Requeue to the end of queue if we (and all of our
ancestors) are the @@ -2041,7 +2041,7 @@ static unsigned int
get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 	 * Time slice is 0 for SCHED_FIFO tasks
 	 */
 	if (task->policy =3D=3D SCHED_RR)
-		return RR_TIMESLICE;
+		return sched_rr_timeslice;
 	else
 		return 0;
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b769d25..9fa0885 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -403,6 +403,13 @@ static struct ctl_table kern_table[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D sched_rt_handler,
 	},
+	{
+		.procname	=3D "sched_rr_timeslice_ms",
+		.data		=3D &sysctl_sched_rr_timeslice_ms,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D sched_rr_handler,
+	},
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	=3D "sched_autogroup_enabled",
--=20
1.7.11.7


--Sig_/pO7WSUl+BFUNZ_qvNRWh/6y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAlCcYZEACgkQHyuj/+TTEp1MdgCgofISpWr2WOryOfc3bKxieO2s
fHEAnjHLU72id97bZI4BCt9Xo/Nte8C8
=h2cg
-----END PGP SIGNATURE-----

--Sig_/pO7WSUl+BFUNZ_qvNRWh/6y--
