Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2DFHPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:15:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47661 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab2DFHPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:15:15 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: [PATCH 02/16] sched: add extended scheduling interface.
Date: Fri,  6 Apr 2012 09:14:27 +0200
Message-Id: <1333696481-3433-3-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dario Faggioli <raistlin@linux.it>

Add the interface bits needed for supporting scheduling algorithms
with extended parameters (e.g., SCHED_DEADLINE).

In general, it makes possible to specify a periodic/sporadic task,
that executes for a given amount of runtime at each instance, and is
scheduled according to the urgency of their own timing constraints,
i.e.:
 - a (maximum/typical) instance execution time,
 - a minimum interval between consecutive instances,
 - a time constraint by which each instance must be completed.

Thus, both the data structure that holds the scheduling parameters of
the tasks and the system calls dealing with it must be extended.
Unfortunately, modifying the existing struct sched_param would break
the ABI and result in potentially serious compatibility issues with
legacy binaries.

For these reasons, this patch:
 - defines the new struct sched_param2, containing all the fields
   that are necessary for specifying a task in the computational
   model described above;
 - defines and implements the new scheduling related syscalls that
   manipulate it, i.e., sched_setscheduler2(), sched_setparam2()
   and sched_getparam2().

Syscalls are introduced for x86 (32 and 64 bits) and ARM only, as a
proof of concept and for developing and testing purposes. Making them
available on other architectures is straightforward.

Since no "user" for these new parameters is introduced in this patch,
the implementation of the new system calls is just identical to their
already existing counterpart. Future patches that implement scheduling
policies able to exploit the new data structure must also take care of
modifying the *2() calls accordingly with their own purposes.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 arch/arm/include/asm/unistd.h      |    3 +
 arch/arm/kernel/calls.S            |    3 +
 arch/x86/ia32/ia32entry.S          |    3 +
 arch/x86/include/asm/unistd_32.h   |    5 +-
 arch/x86/include/asm/unistd_64.h   |    6 ++
 arch/x86/kernel/syscall_table_32.S |    3 +
 include/linux/sched.h              |   50 ++++++++++++++++
 include/linux/syscalls.h           |    7 ++
 kernel/sched.c                     |  110 +++++++++++++++++++++++++++++++++++-
 9 files changed, 186 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 4a11237..66fb25b 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -404,6 +404,9 @@
 #define __NR_setns			(__NR_SYSCALL_BASE+375)
 #define __NR_process_vm_readv		(__NR_SYSCALL_BASE+376)
 #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
+#define __NR_sched_setscheduler2	(__NR_SYSCALL_BASE+378)
+#define __NR_sched_setparam2		(__NR_SYSCALL_BASE+379)
+#define __NR_sched_getparam2		(__NR_SYSCALL_BASE+380)
 
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 463ff4a..be174eb 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -387,6 +387,9 @@
 /* 375 */	CALL(sys_setns)
 		CALL(sys_process_vm_readv)
 		CALL(sys_process_vm_writev)
+		CALL(sys_sched_setscheduler2)
+		CALL(sys_sched_setparam2)
+/* 380 */	CALL(sys_sched_getparam2)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a6253ec..7a502fd 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -852,4 +852,7 @@ ia32_sys_call_table:
 	.quad sys_setns
 	.quad compat_sys_process_vm_readv
 	.quad compat_sys_process_vm_writev
+	.quad sys_sched_setscheduler2
+	.quad sys_sched_setparam2	/* 350 */
+	.quad sys_sched_getparam2
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 599c77d..5658de0 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -354,10 +354,13 @@
 #define __NR_setns		346
 #define __NR_process_vm_readv	347
 #define __NR_process_vm_writev	348
+#define __NR_sched_setscheduler2	349
+#define __NR_sched_setparam2		350
+#define __NR_sched_getparam2		351
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 349
+#define NR_syscalls 352
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 0431f19..b7a4347 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -686,6 +686,12 @@ __SYSCALL(__NR_getcpu, sys_getcpu)
 __SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
 #define __NR_process_vm_writev			311
 __SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
+#define __NR_sched_setscheduler2		312
+__SYSCALL(__NR_sched_setscheduler2, sys_sched_setscheduler2)
+#define __NR_sched_setparam2			313
+__SYSCALL(__NR_sched_setparam2, sys_sched_setparam2)
+#define __NR_sched_getparam2			314
+__SYSCALL(__NR_sched_getparam2, sys_sched_getparam2)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 9a0e312..b9b37b5 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -348,3 +348,6 @@ ENTRY(sys_call_table)
 	.long sys_setns
 	.long sys_process_vm_readv
 	.long sys_process_vm_writev
+	.long sys_sched_setscheduler2
+	.long sys_sched_setparam2	/* 350 */
+	.long sys_sched_getparam2
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ddfc4dc..3e67d30 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -96,6 +96,54 @@ struct sched_param {
 
 #include <asm/processor.h>
 
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
+ * This variant (sched_param2) is meant at describing a so-called
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
+ * This is reflected by the actual fields of the sched_param2 structure:
+ *
+ *  @sched_priority     task's priority (might still be useful)
+ *  @sched_deadline     representative of the task's deadline
+ *  @sched_runtime      representative of the task's runtime
+ *  @sched_period       representative of the task's period
+ *  @sched_flags        for customizing the scheduler behaviour
+ *
+ * Given this task model, there are a multiplicity of scheduling algorithms
+ * and policies, that can be used to ensure all the tasks will make their
+ * timing constraints.
+ *
+ * @__unused		padding to allow future expansion without ABI issues
+ */
+struct sched_param2 {
+	int sched_priority;
+	unsigned int sched_flags;
+	u64 sched_runtime;
+	u64 sched_deadline;
+	u64 sched_period;
+
+	u64 __unused[12];
+};
+
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
@@ -2133,6 +2181,8 @@ extern int sched_setscheduler(struct task_struct *, int,
 			      const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
+extern int sched_setscheduler2(struct task_struct *, int,
+				 const struct sched_param2 *);
 extern struct task_struct *idle_task(int cpu);
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 86a24b1..11449ae 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -38,6 +38,7 @@ struct rlimit;
 struct rlimit64;
 struct rusage;
 struct sched_param;
+struct sched_param2;
 struct sel_arg_struct;
 struct semaphore;
 struct sembuf;
@@ -327,11 +328,17 @@ asmlinkage long sys_clock_nanosleep(clockid_t which_clock, int flags,
 asmlinkage long sys_nice(int increment);
 asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setscheduler2(pid_t pid, int policy,
+					struct sched_param2 __user *param);
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setparam2(pid_t pid,
+					struct sched_param2 __user *param);
 asmlinkage long sys_sched_getscheduler(pid_t pid);
 asmlinkage long sys_sched_getparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_getparam2(pid_t pid,
+					struct sched_param2 __user *param);
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
diff --git a/kernel/sched.c b/kernel/sched.c
index 4c8d1c3..eed5133 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5421,7 +5421,8 @@ static bool check_same_owner(struct task_struct *p)
 }
 
 static int __sched_setscheduler(struct task_struct *p, int policy,
-				const struct sched_param *param, bool user)
+				const struct sched_param2 *param,
+				bool user)
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	unsigned long flags;
@@ -5586,10 +5587,20 @@ recheck:
 int sched_setscheduler(struct task_struct *p, int policy,
 		       const struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, true);
+	struct sched_param2 param2 = {
+		.sched_priority = param->sched_priority
+	};
+	return __sched_setscheduler(p, policy, &param2, true);
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler);
 
+int sched_setscheduler2(struct task_struct *p, int policy,
+			  const struct sched_param2 *param2)
+{
+	return __sched_setscheduler(p, policy, param2, true);
+}
+EXPORT_SYMBOL_GPL(sched_setscheduler2);
+
 /**
  * sched_setscheduler_nocheck - change the scheduling policy and/or RT priority of a thread from kernelspace.
  * @p: the task in question.
@@ -5604,7 +5615,10 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 			       const struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, false);
+	struct sched_param2 param2 = {
+		.sched_priority = param->sched_priority
+	};
+	return __sched_setscheduler(p, policy, &param2, false);
 }
 
 static int
@@ -5629,6 +5643,31 @@ do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
 	return retval;
 }
 
+static int
+do_sched_setscheduler2(pid_t pid, int policy,
+			 struct sched_param2 __user *param2)
+{
+	struct sched_param2 lparam2;
+	struct task_struct *p;
+	int retval;
+
+	if (!param2 || pid < 0)
+		return -EINVAL;
+
+	memset(&lparam2, 0, sizeof(struct sched_param2));
+	if (copy_from_user(&lparam2, param2, sizeof(struct sched_param2)))
+		return -EFAULT;
+
+	rcu_read_lock();
+	retval = -ESRCH;
+	p = find_process_by_pid(pid);
+	if (p != NULL)
+		retval = sched_setscheduler2(p, policy, &lparam2);
+	rcu_read_unlock();
+
+	return retval;
+}
+
 /**
  * sys_sched_setscheduler - set/change the scheduler policy and RT priority
  * @pid: the pid in question.
@@ -5646,6 +5685,21 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
 }
 
 /**
+ * sys_sched_setscheduler2 - same as above, but with extended sched_param
+ * @pid: the pid in question.
+ * @policy: new policy (could use extended sched_param).
+ * @param: structure containg the extended parameters.
+ */
+SYSCALL_DEFINE3(sched_setscheduler2, pid_t, pid, int, policy,
+		struct sched_param2 __user *, param2)
+{
+	if (policy < 0)
+		return -EINVAL;
+
+	return do_sched_setscheduler2(pid, policy, param2);
+}
+
+/**
  * sys_sched_setparam - set/change the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the new RT priority.
@@ -5656,6 +5710,17 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 }
 
 /**
+ * sys_sched_setparam2 - same as above, but with extended sched_param
+ * @pid: the pid in question.
+ * @param2: structure containing the extended parameters.
+ */
+SYSCALL_DEFINE2(sched_setparam2, pid_t, pid,
+		struct sched_param2 __user *, param2)
+{
+	return do_sched_setscheduler2(pid, -1, param2);
+}
+
+/**
  * sys_sched_getscheduler - get the policy (scheduling class) of a thread
  * @pid: the pid in question.
  */
@@ -5719,6 +5784,45 @@ out_unlock:
 	return retval;
 }
 
+/**
+ * sys_sched_getparam2 - same as above, but with extended sched_param
+ * @pid: the pid in question.
+ * @param2: structure containing the extended parameters.
+ */
+SYSCALL_DEFINE2(sched_getparam2, pid_t, pid,
+		struct sched_param2 __user *, param2)
+{
+	struct sched_param2 lp;
+	struct task_struct *p;
+	int retval;
+
+	if (!param2 || pid < 0)
+		return -EINVAL;
+
+	rcu_read_lock();
+	p = find_process_by_pid(pid);
+	retval = -ESRCH;
+	if (!p)
+		goto out_unlock;
+
+	retval = security_task_getscheduler(p);
+	if (retval)
+		goto out_unlock;
+
+	lp.sched_priority = p->rt_priority;
+	rcu_read_unlock();
+
+	retval = copy_to_user(param2, &lp,
+			sizeof(struct sched_param2)) ? -EFAULT : 0;
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
-- 
1.7.5.4

