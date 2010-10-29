Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab0J2G1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:27:18 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:19836 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753777Ab0J2G1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:27:14 -0400
Subject: [RFC][PATCH 02/22] sched: add extended scheduling interface
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wGJlSp8UM7OYuT98xXku"
Date: Fri, 29 Oct 2010 08:27:02 +0200
Message-ID: <1288333622.8661.141.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wGJlSp8UM7OYuT98xXku
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Add the interface bits needed for supporting scheduling algorithms
with extended parameters (e.g., SCHED_DEADLINE).

In general, it makes it possible to specify a periodic/sporadic task,
that executes for a given amount of runtime at each instance, and is
scheduled according to the urgency of their own timing constraints, i.e.:
 - a (maximum/typical) instance execution time,
 - a minimum interval between consecutive instances,
 - a time constraint by which each instance must be completed.

Thus, both the data structure that holds the scheduling parameters of
the tasks and the system calls dealing with it must be extended.
Unfortunately, modifying the existing struct sched_param would break
the ABI and result in potentially serious compatibility issues with
legacy binaries.

For these reasons, this patch:
 - defines the new struct sched_param_ex, containing all the fields
   that are necessary for specifying a task in the computational
   model described above;
 - defines and implements the new scheduling related syscalls that
   manipulate it, i.e., sched_setscheduler_ex(), sched_setparam_ex()
   and sched_getparam_ex().

Syscalls are introduced for x86 (32 and 64 bits) and ARM only, as a
proof of concept and for developing and testing purposes. Making them
available on other architectures is straightforward.

Since no "user" for these new parameters is introduced in this patch,
the implementation of the new system calls is just identical to their
already existing counterpart. Future patches that implement scheduling
policies able to exploit the new data structure must also take care of
modifying the *_ex() calls accordingly with their own purposes.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 arch/arm/include/asm/unistd.h      |    3 +
 arch/arm/kernel/calls.S            |    3 +
 arch/x86/ia32/ia32entry.S          |    3 +
 arch/x86/include/asm/unistd_32.h   |    5 +-
 arch/x86/include/asm/unistd_64.h   |    6 ++
 arch/x86/kernel/syscall_table_32.S |    3 +
 include/linux/sched.h              |   58 +++++++++++++++
 include/linux/syscalls.h           |    7 ++
 kernel/sched.c                     |  135 ++++++++++++++++++++++++++++++++=
+++-
 9 files changed, 219 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index c891eb7..6f18f72 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -396,6 +396,9 @@
 #define __NR_fanotify_init		(__NR_SYSCALL_BASE+367)
 #define __NR_fanotify_mark		(__NR_SYSCALL_BASE+368)
 #define __NR_prlimit64			(__NR_SYSCALL_BASE+369)
+#define __NR_sched_setscheduler_ex	(__NR_SYSCALL_BASE+370)
+#define __NR_sched_setparam_ex		(__NR_SYSCALL_BASE+371)
+#define __NR_sched_getparam_ex		(__NR_SYSCALL_BASE+372)
=20
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 5c26ecc..c131615 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -379,6 +379,9 @@
 		CALL(sys_fanotify_init)
 		CALL(sys_fanotify_mark)
 		CALL(sys_prlimit64)
+/* 370 */	CALL(sys_sched_setscheduler_ex)
+		CALL(sys_sched_setparam_ex)
+		CALL(sys_sched_getparam_ex)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 518bb99..0c6f451 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -851,4 +851,7 @@ ia32_sys_call_table:
 	.quad sys_fanotify_init
 	.quad sys32_fanotify_mark
 	.quad sys_prlimit64		/* 340 */
+	.quad sys_sched_setscheduler_ex
+	.quad sys_sched_setparam_ex
+	.quad sys_sched_getparam_ex
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd=
_32.h
index b766a5e..437383b 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -346,10 +346,13 @@
 #define __NR_fanotify_init	338
 #define __NR_fanotify_mark	339
 #define __NR_prlimit64		340
+#define __NR_sched_setscheduler_ex	341
+#define __NR_sched_setparam_ex		342
+#define __NR_sched_getparam_ex		343
=20
 #ifdef __KERNEL__
=20
-#define NR_syscalls 341
+#define NR_syscalls 344
=20
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd=
_64.h
index 363e9b8..fc4618b 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -669,6 +669,12 @@ __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 #define __NR_prlimit64				302
 __SYSCALL(__NR_prlimit64, sys_prlimit64)
+#define __NR_sched_setscheduler_ex		303
+__SYSCALL(__NR_sched_setscheduler_ex, sys_sched_setscheduler_ex)
+#define __NR_sched_setparam_ex			304
+__SYSCALL(__NR_sched_setparam_ex, sys_sched_setparam_ex)
+#define __NR_sched_getparam_ex			305
+__SYSCALL(__NR_sched_getparam_ex, sys_sched_getparam_ex)
=20
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_t=
able_32.S
index b35786d..7d4ed62 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -340,3 +340,6 @@ ENTRY(sys_call_table)
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64		/* 340 */
+	.long sys_sched_setscheduler_ex
+	.long sys_sched_setparam_ex
+	.long sys_sched_getparam_ex
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6053b4b..cf20084 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -94,6 +94,61 @@ struct sched_param {
=20
 #include <asm/processor.h>
=20
+/*
+ * Extended scheduling parameters data structure.
+ *
+ * This is needed because the original struct sched_param can not be
+ * altered without introducing ABI issues with legacy applications
+ * (e.g., in sched_getparam()).
+ *
+ * However, the possibility of specifying more than just a priority for
+ * the tasks may be useful for a wide variety of application fields, e.g.,
+ * multimedia, streaming, automation and control, and many others.
+ *
+ * This variant (sched_param_ex) is meant at describing a so-called
+ * sporadic time-constrained task. In such model a task is specified by:
+ *  - the activation period or minimum instance inter-arrival time;
+ *  - the maximum (or average, depending on the actual scheduling
+ *    discipline) computation time of all instances, a.k.a. runtime;
+ *  - the deadline (relative to the actual activation time) of each
+ *    instance.
+ * Very briefly, a periodic (sporadic) task asks for the execution of
+ * some specific computation --which is typically called an instance--
+ * (at most) every period. Moreover, each instance typically lasts no more
+ * than the runtime and must be completed by time instant t equal to
+ * the instance activation time + the deadline.
+ *
+ * This is reflected by the actual fields of the sched_param_ex structure:
+ *
+ *  @sched_priority     task's priority (might still be useful)
+ *  @sched_deadline     representative of the task's deadline
+ *  @sched_runtime      representative of the task's runtime
+ *  @sched_period       representative of the task's period
+ *  @sched_flags        for customizing the scheduler behaviour
+ *
+ * There are other fields, which may be useful for implementing (in
+ * user-space) advanced scheduling behaviours, e.g., feedback scheduling:
+ *
+ *  @curr_runtime       task's currently available runtime
+ *  @used_runtime       task's totally used runtime
+ *  @curr_deadline      task's current absolute deadline
+ *
+ * Given this task model, there are a multiplicity of scheduling algorithm=
s
+ * and policies, that can be used to ensure all the tasks will make their
+ * timing constraints.
+ */
+struct sched_param_ex {
+	int sched_priority;
+	struct timespec sched_runtime;
+	struct timespec sched_deadline;
+	struct timespec sched_period;
+	unsigned int sched_flags;
+
+	struct timespec curr_runtime;
+	struct timespec used_runtime;
+	struct timespec curr_deadline;
+};
+
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
@@ -1950,6 +2005,9 @@ extern int sched_setscheduler(struct task_struct *, i=
nt,
 			      const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
+extern int sched_setscheduler_ex(struct task_struct *, int,
+				 const struct sched_param *,
+				 const struct sched_param_ex *);
 extern struct task_struct *idle_task(int cpu);
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index cacc27a..46b461e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -38,6 +38,7 @@ struct rlimit;
 struct rlimit64;
 struct rusage;
 struct sched_param;
+struct sched_param_ex;
 struct sel_arg_struct;
 struct semaphore;
 struct sembuf;
@@ -322,11 +323,17 @@ asmlinkage long sys_clock_nanosleep(clockid_t which_c=
lock, int flags,
 asmlinkage long sys_nice(int increment);
 asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setscheduler_ex(pid_t pid, int policy, unsigned =
len,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setparam_ex(pid_t pid, unsigned len,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_getscheduler(pid_t pid);
 asmlinkage long sys_sched_getparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_getparam_ex(pid_t pid, unsigned len,
+					struct sched_param_ex __user *param);
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
diff --git a/kernel/sched.c b/kernel/sched.c
index 07f5a0c..76f1bc6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4704,7 +4704,9 @@ static bool check_same_owner(struct task_struct *p)
 }
=20
 static int __sched_setscheduler(struct task_struct *p, int policy,
-				const struct sched_param *param, bool user)
+				const struct sched_param *param,
+				const struct sched_param_ex *param_ex,
+				bool user)
 {
 	int retval, oldprio, oldpolicy =3D -1, on_rq, running;
 	unsigned long flags;
@@ -4861,10 +4863,18 @@ recheck:
 int sched_setscheduler(struct task_struct *p, int policy,
 		       const struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, true);
+	return __sched_setscheduler(p, policy, param, NULL, true);
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler);
=20
+int sched_setscheduler_ex(struct task_struct *p, int policy,
+			  const struct sched_param *param,
+			  const struct sched_param_ex *param_ex)
+{
+	return __sched_setscheduler(p, policy, param, param_ex, true);
+}
+EXPORT_SYMBOL_GPL(sched_setscheduler_ex);
+
 /**
  * sched_setscheduler_nocheck - change the scheduling policy and/or RT pri=
ority of a thread from kernelspace.
  * @p: the task in question.
@@ -4879,7 +4889,7 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 			       const struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, false);
+	return __sched_setscheduler(p, policy, param, NULL, false);
 }
=20
 static int
@@ -4904,6 +4914,56 @@ do_sched_setscheduler(pid_t pid, int policy, struct =
sched_param __user *param)
 	return retval;
 }
=20
+/*
+ * Notice that, to extend sched_param_ex in the future without causing ABI
+ * issues, the user-space is asked to pass to this (and the other *_ex())
+ * function(s) the actual size of the data structure it has been compiled
+ * against.
+ *
+ * What we do is the following:
+ *  - if the user data structure is bigger than our one we fail, since thi=
s
+ *    means we wouldn't be able of providing some of the features that
+ *    are expected;
+ *  - if the user data structure is smaller than our one we can continue,
+ *    we just initialize to default all the fielld of the kernel-side
+ *    sched_param_ex and copy from the user the available values. This
+ *    obviously assume that such data structure can only grow and that
+ *    positions and meaning of the existing fields will not be altered.
+ *
+ * The issue can be addressed also adding a "version" field to the data
+ * structure itself (which would also remove the fixed position & meaning
+ * requirement)... Comments about the best way to go are welcome!
+ */
+static int
+do_sched_setscheduler_ex(pid_t pid, int policy, unsigned len,
+			 struct sched_param_ex __user *param_ex)
+{
+	struct sched_param lparam;
+	struct sched_param_ex lparam_ex;
+	struct task_struct *p;
+	int retval;
+
+	if (!param_ex || pid < 0)
+		return -EINVAL;
+	if (len > sizeof(lparam_ex))
+		return -EINVAL;
+
+	memset(&lparam_ex, 0, sizeof(lparam_ex));
+	if (copy_from_user(&lparam_ex, param_ex, len))
+		return -EFAULT;
+
+	rcu_read_lock();
+	retval =3D -ESRCH;
+	p =3D find_process_by_pid(pid);
+	if (p !=3D NULL) {
+		lparam.sched_priority =3D lparam_ex.sched_priority;
+		retval =3D sched_setscheduler_ex(p, policy, &lparam, &lparam_ex);
+	}
+	rcu_read_unlock();
+
+	return retval;
+}
+
 /**
  * sys_sched_setscheduler - set/change the scheduler policy and RT priorit=
y
  * @pid: the pid in question.
@@ -4921,6 +4981,22 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int,=
 policy,
 }
=20
 /**
+ * sys_sched_setscheduler_ex - same as above, but with extended sched_para=
m
+ * @pid: the pid in question.
+ * @policy: new policy (could use extended sched_param).
+ * @len: size of data pointed by param_ex.
+ * @param: structure containg the extended parameters.
+ */
+SYSCALL_DEFINE4(sched_setscheduler_ex, pid_t, pid, int, policy,
+		unsigned, len, struct sched_param_ex __user *, param_ex)
+{
+	if (policy < 0)
+		return -EINVAL;
+
+	return do_sched_setscheduler_ex(pid, policy, len, param_ex);
+}
+
+/**
  * sys_sched_setparam - set/change the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the new RT priority.
@@ -4931,6 +5007,18 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct s=
ched_param __user *, param)
 }
=20
 /**
+ * sys_sched_setparam_ex - same as above, but with extended sched_param
+ * @pid: the pid in question.
+ * @len: size of data pointed by param_ex.
+ * @param_ex: structure containing the extended parameters.
+ */
+SYSCALL_DEFINE3(sched_setparam_ex, pid_t, pid, unsigned, len,
+		struct sched_param_ex __user *, param_ex)
+{
+	return do_sched_setscheduler_ex(pid, -1, len, param_ex);
+}
+
+/**
  * sys_sched_getscheduler - get the policy (scheduling class) of a thread
  * @pid: the pid in question.
  */
@@ -4994,6 +5082,47 @@ out_unlock:
 	return retval;
 }
=20
+/**
+ * sys_sched_getparam_ex - same as above, but with extended sched_param
+ * @pid: the pid in question.
+ * @len: size of data pointed by param_ex.
+ * @param_ex: structure containing the extended parameters.
+ */
+SYSCALL_DEFINE3(sched_getparam_ex, pid_t, pid, unsigned, len,
+		struct sched_param_ex __user *, param_ex)
+{
+	struct sched_param_ex lp;
+	struct task_struct *p;
+	int retval;
+
+	if (!param_ex || pid < 0)
+		return -EINVAL;
+	if (len > sizeof(lp))
+		return -EINVAL;
+
+	rcu_read_lock();
+	p =3D find_process_by_pid(pid);
+	retval =3D -ESRCH;
+	if (!p)
+		goto out_unlock;
+
+	retval =3D security_task_getscheduler(p);
+	if (retval)
+		goto out_unlock;
+
+	lp.sched_priority =3D p->rt_priority;
+	rcu_read_unlock();
+
+	retval =3D copy_to_user(param_ex, &lp, len) ? -EFAULT : 0;
+
+	return retval;
+
+out_unlock:
+	rcu_read_unlock();
+	return retval;
+
+}
+
 long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 {
 	cpumask_var_t cpus_allowed, new_mask;
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-wGJlSp8UM7OYuT98xXku
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKaTYACgkQk4XaBE3IOsTY2QCfWjbboUTIPFJncNeng+Sb9A+0
M2AAn2MPeDXPqZnfaRk8kEac6Vv2pI1j
=R5F7
-----END PGP SIGNATURE-----

--=-wGJlSp8UM7OYuT98xXku--

