Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab2EWVoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:44:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51227 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2EWVod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:44:33 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
Subject: [PATCH 04/15] sched: add extended scheduling interface.
Date: Wed, 23 May 2012 23:42:44 +0200
Message-Id: <1337809375-24295-5-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
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
 arch/arm/include/asm/unistd.h    |    3 ++
 arch/arm/kernel/calls.S          |    3 ++
 arch/x86/syscalls/syscall_32.tbl |    3 ++
 arch/x86/syscalls/syscall_64.tbl |    3 ++
 include/linux/sched.h            |   50 +++++++++++++++++
 include/linux/syscalls.h         |    7 +++
 kernel/sched/core.c              |  110 ++++++++++++++++++++++++++++++++++++--
 7 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 512cd14..2529fbf 100644
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
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index 29f9f05..251f197 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -355,3 +355,6 @@
 346	i386	setns			sys_setns
 347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
+349	i386	sched_setparam2		sys_sched_setparam2
+350	i386	sched_getparam2		sys_sched_getparam2
+351	i386	sched_setscheduler2	sys_sched_setscheduler2
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index dd29a9e..74fefa1 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -318,6 +318,9 @@
 309	common	getcpu			sys_getcpu
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
+312	common	sched_setparam2		sys_sched_setparam2
+313	common	sched_getparam2		sys_sched_getparam2
+314	common	sched_setscheduler2	sys_sched_setscheduler2
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
 # for native 64-bit operation.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6f66117..6d0c098 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -93,6 +93,54 @@ struct sched_param {
 
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
@@ -2084,6 +2132,8 @@ extern int sched_setscheduler(struct task_struct *, int,
 			      const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
+extern int sched_setscheduler2(struct task_struct *, int,
+				 const struct sched_param2 *);
 extern struct task_struct *idle_task(int cpu);
 /**
  * is_idle_task - is the specified task an idle task?
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3de3acb..5f7309d 100644
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
@@ -328,11 +329,17 @@ asmlinkage long sys_clock_nanosleep(clockid_t which_clock, int flags,
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
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a622f78..0a27ec6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4076,7 +4076,8 @@ static bool check_same_owner(struct task_struct *p)
 }
 
 static int __sched_setscheduler(struct task_struct *p, int policy,
-				const struct sched_param *param, bool user)
+				const struct sched_param2 *param,
+				bool user)
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	unsigned long flags;
@@ -4241,10 +4242,20 @@ recheck:
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
@@ -4259,7 +4270,10 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
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
@@ -4284,6 +4298,31 @@ do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
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
@@ -4301,6 +4340,21 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
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
@@ -4311,6 +4365,17 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
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
@@ -4374,6 +4439,45 @@ out_unlock:
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
1.7.9.5

