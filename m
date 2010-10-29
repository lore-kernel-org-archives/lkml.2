Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0J2GfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:35:21 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:46967 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752520Ab0J2GfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:35:14 -0400
Subject: [RFC][PATCH 10/22] sched: add a syscall to wait for the next
 instance
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-I+watjJL1jD/t4a1Tbbe"
Date: Fri, 29 Oct 2010 08:35:04 +0200
Message-ID: <1288334104.8661.151.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-I+watjJL1jD/t4a1Tbbe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Introduce sched_wait_interval() syscall (and scheduling class
interface call). In general, this aims at providing each scheduling
class with a mean of making one of its own task sleep for some time
according to some specific rule of the scheduling class itself.

As of now, the sched_dl scheduling class is the only one that needs
this kind of service, and thus the only one that implements the
class-specific logic. For other classes, calling it will result in
the same effect than calling clock_nanosleep with CLOCK_MONOTONIC
clockid and the TIMER_ABSTIME flag on.

For -deadline task, the idea is to give them the possibility of
notifying the scheduler a periodic/sporadic instance just ended and
ask it to wake up them at the beginning of the next one, with:
 - fully replenished runtime and
 - the absolute deadline set just one relative deadline interval
   away from the wakeup time.
This is an effective mean of synchronizing the task's behaviour with
the scheduler one, which might be useful in some situations.

This patch:
 - adds the new syscall (x83-32, x86-64 and ARM, but extension to all
   archs is strightforward);
 - implements the class-specific logic for -deadline tasks, making it
   impossible for them to exploit this call to use more bandwidth than
   they are given.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 arch/arm/include/asm/unistd.h      |    1 +
 arch/arm/kernel/calls.S            |    1 +
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 +-
 arch/x86/include/asm/unistd_64.h   |    2 +
 arch/x86/kernel/syscall_table_32.S |    1 +
 include/linux/sched.h              |    2 +
 include/linux/syscalls.h           |    2 +
 kernel/sched.c                     |   39 ++++++++++++++++++++++
 kernel/sched_dl.c                  |   63 ++++++++++++++++++++++++++++++++=
++++
 10 files changed, 114 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 6f18f72..56513bb 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -399,6 +399,7 @@
 #define __NR_sched_setscheduler_ex	(__NR_SYSCALL_BASE+370)
 #define __NR_sched_setparam_ex		(__NR_SYSCALL_BASE+371)
 #define __NR_sched_getparam_ex		(__NR_SYSCALL_BASE+372)
+#define __NR_sched_wait_interval	(__NR_SYSCALL_BASE+373)
=20
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index c131615..c18e1e4 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -382,6 +382,7 @@
 /* 370 */	CALL(sys_sched_setscheduler_ex)
 		CALL(sys_sched_setparam_ex)
 		CALL(sys_sched_getparam_ex)
+		CALL(sys_sched_wait_interval)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 0c6f451..32821df 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -854,4 +854,5 @@ ia32_sys_call_table:
 	.quad sys_sched_setscheduler_ex
 	.quad sys_sched_setparam_ex
 	.quad sys_sched_getparam_ex
+	.quad sys_sched_wait_interval
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd=
_32.h
index 437383b..684bf79 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -349,10 +349,11 @@
 #define __NR_sched_setscheduler_ex	341
 #define __NR_sched_setparam_ex		342
 #define __NR_sched_getparam_ex		343
+#define __NR_sched_wait_interval	344
=20
 #ifdef __KERNEL__
=20
-#define NR_syscalls 344
+#define NR_syscalls 345
=20
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd=
_64.h
index fc4618b..932b094 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -675,6 +675,8 @@ __SYSCALL(__NR_sched_setscheduler_ex, sys_sched_setsche=
duler_ex)
 __SYSCALL(__NR_sched_setparam_ex, sys_sched_setparam_ex)
 #define __NR_sched_getparam_ex			305
 __SYSCALL(__NR_sched_getparam_ex, sys_sched_getparam_ex)
+#define __NR_sched_wait_interval		306
+__SYSCALL(__NR_sched_wait_interval, sys_sched_wait_interval)
=20
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_t=
able_32.S
index 7d4ed62..c77e82c 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -343,3 +343,4 @@ ENTRY(sys_call_table)
 	.long sys_sched_setscheduler_ex
 	.long sys_sched_setparam_ex
 	.long sys_sched_getparam_ex
+	.long sys_sched_wait_interval
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 83fa2b5..e301eea 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1116,6 +1116,8 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*yield_task) (struct rq *rq);
+	long (*wait_interval) (struct task_struct *p, struct timespec *rqtp,
+			       struct timespec __user *rmtp);
=20
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int fla=
gs);
=20
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 46b461e..b6e04db 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -339,6 +339,8 @@ asmlinkage long sys_sched_setaffinity(pid_t pid, unsign=
ed int len,
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_yield(void);
+asmlinkage long sys_sched_wait_interval(const struct timespec __user *rqtp=
,
+					struct timespec *rmtp);
 asmlinkage long sys_sched_get_priority_max(int policy);
 asmlinkage long sys_sched_get_priority_min(int policy);
 asmlinkage long sys_sched_rr_get_interval(pid_t pid,
diff --git a/kernel/sched.c b/kernel/sched.c
index 4491f7d..619d091 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5504,6 +5504,45 @@ SYSCALL_DEFINE0(sched_yield)
 	return 0;
 }
=20
+/**
+ * sys_sched_wait_interval - sleep according to the scheduling class rules=
.
+ *
+ * This function is implemented inside each scheduling class, in case it
+ * wants to provide its tasks a mean of waiting a specific instant in
+ * time, while also honouring some specific rule of itself.
+ */
+SYSCALL_DEFINE2(sched_wait_interval,
+	const struct timespec __user *, rqtp,
+	struct timespec __user *, rmtp)
+{
+	struct timespec lrq, lrm;
+	int ret;
+
+	if (rqtp !=3D NULL) {
+		if (copy_from_user(&lrq, rqtp, sizeof(struct timespec)))
+			return -EFAULT;
+		if (!timespec_valid(&lrq))
+			return -EINVAL;
+	}
+
+	if (current->sched_class->wait_interval)
+		ret =3D current->sched_class->wait_interval(current,
+							  rqtp ? &lrq : NULL,
+							  &lrm);
+	else {
+		if (!rqtp)
+			return -EINVAL;
+
+		ret =3D hrtimer_nanosleep(&lrq, &lrm, HRTIMER_MODE_ABS,
+					CLOCK_MONOTONIC);
+	}
+
+	if (rmtp && copy_to_user(rmtp, &lrm, sizeof(struct timespec)))
+		return -EFAULT;
+
+	return ret;
+}
+
 static inline int should_resched(void)
 {
 	return need_resched() && !(preempt_count() & PREEMPT_ACTIVE);
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 31fb771..c8eb304 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -724,6 +724,68 @@ static void dequeue_task_dl(struct rq *rq, struct task=
_struct *p, int flags)
 }
=20
 /*
+ * This function makes the task sleep until at least the absolute time
+ * instant specified in @rqtp.
+ * In fact, since we want to wake up the task with its full runtime,
+ * @rqtp might be too early (or the task might already have overrun
+ * its runtime when calling this), the sleeping time may  be longer
+ * than asked.
+ *
+ * This is intended to be used at the end of a periodic -deadline task
+ * instance, or any time a task want to be sure it'll wake up with
+ * its full runtime.
+ */
+static long wait_interval_dl(struct task_struct *p, struct timespec *rqtp,
+			     struct timespec *rmtp)
+{
+	unsigned long flags;
+	struct sched_dl_entity *dl_se =3D &p->dl;
+	struct rq *rq =3D task_rq_lock(p, &flags);
+	struct timespec lrqtp;
+	u64 wakeup;
+
+	/*
+	 * If no wakeup time is provided, sleep at least up to the
+	 * next activation period. This guarantee the budget will
+	 * be renewed.
+	 */
+	if (!rqtp) {
+		wakeup =3D dl_se->deadline +
+			 dl_se->dl_period - dl_se->dl_deadline;
+		goto unlock;
+	}
+
+	/*
+	 * If the tasks wants to wake up _before_ its absolute deadline
+	 * we must be sure that reusing its (actual) runtime and deadline
+	 * at that time _would_ overcome its bandwidth limitation, so
+	 * that we know it will be given new parameters.
+	 *
+	 * If this is not true, we postpone the wake-up time up to the right
+	 * instant. This involves a division (to calculate the reverse of the
+	 * task's bandwidth), but it is worth to notice that it is quite
+	 * unlikely that we get into here very often.
+	 */
+	wakeup =3D timespec_to_ns(rqtp);
+	if (dl_time_before(wakeup, dl_se->deadline) &&
+	    !dl_entity_overflow(dl_se, wakeup)) {
+		u64 ibw =3D (u64)dl_se->runtime * dl_se->dl_period;
+
+		ibw =3D div_u64(ibw, dl_se->dl_runtime);
+		wakeup =3D dl_se->deadline - ibw;
+	}
+
+unlock:
+	task_rq_unlock(rq, &flags);
+
+	lrqtp =3D ns_to_timespec(wakeup);
+	dl_se->dl_new =3D 1;
+
+	return hrtimer_nanosleep(&lrqtp, rmtp, HRTIMER_MODE_ABS,
+				 CLOCK_MONOTONIC);
+}
+
+/*
  * Yield task semantic for -deadline tasks is:
  *
  *   get off from the CPU until our next instance, with
@@ -1483,6 +1545,7 @@ static const struct sched_class dl_sched_class =3D {
 	.enqueue_task		=3D enqueue_task_dl,
 	.dequeue_task		=3D dequeue_task_dl,
 	.yield_task		=3D yield_task_dl,
+	.wait_interval		=3D wait_interval_dl,
=20
 	.check_preempt_curr	=3D check_preempt_curr_dl,
=20
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-I+watjJL1jD/t4a1Tbbe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKaxgACgkQk4XaBE3IOsQFMwCfd6h7jyD6wxd5TPXAhkx3b/jr
L9cAnjb5Uv50vQe9Bi3aAFJr2Lyw4kpT
=GddI
-----END PGP SIGNATURE-----

--=-I+watjJL1jD/t4a1Tbbe--

