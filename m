Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab0LTPZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:25:10 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:63472 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab0LTPZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:25:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mfXGPr3/ue5ExFWoZlkvV6FLMOCxzXtFuFwAuXHZ0PCXcqx/hdTgAEDAUKEQiKf6a2
         IaDCv1EM+rFTeNmnHjnLxsoBB31PUVTF85dAhB+/gGKjHthwcE+8JBx4xeEAo1s/oX84
         uXEbh1rVSM4y8zm80JYygsWaI9plyLCpR8Snw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [RFC PATCH 15/15] nohz_task: Procfs interface
Date: Mon, 20 Dec 2010 16:24:22 +0100
Message-Id: <1292858662-5650-16-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements the /proc/pid/nohz file that enables the
nohz attribute of a task.

Synchronization is enforced so that:

- A CPU can have only one nohz task
- A nohz task can be only affine to a single CPU

For now this is only possible to write on /proc/self but probably
allowing it from another task would be a good idea and wouldn't
increase so much the complexity of the code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 fs/proc/base.c           |   80 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h    |    1 +
 include/linux/tick.h     |    1 +
 kernel/sched.c           |   43 ++++++++++++++++++++++++
 kernel/time/Kconfig      |    6 ++--
 kernel/time/tick-sched.c |   12 +++++++
 6 files changed, 140 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1828451..9a01978 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -83,6 +83,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
+#include <linux/tick.h>
 #include "internal.h"
 
 /* NOTE:
@@ -1295,6 +1296,82 @@ static const struct file_operations proc_sessionid_operations = {
 };
 #endif
 
+#ifdef CONFIG_NO_HZ_TASK
+static ssize_t proc_nohz_read(struct file *file, char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	char buffer[PROC_NUMBUF];
+	int val = 0;
+	size_t len;
+
+	if (!task)
+		return -ESRCH;
+
+	if (test_tsk_thread_flag(task, TIF_NOHZ))
+		val = 1;
+
+	put_task_struct(task);
+
+	len = snprintf(buffer, sizeof(buffer), "%d\n", val);
+
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
+}
+
+
+static ssize_t proc_nohz_write(struct file *file, const char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF];
+	long val;
+	int err = 0;
+
+	memset(buffer, 0, sizeof(buffer));
+
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+
+	if (copy_from_user(buffer, buf, count)) {
+		err = -EFAULT;
+		goto out;
+	}
+
+	err = strict_strtol(strstrip(buffer), 0, &val);
+
+	if (err || (val != 0 && val != 1)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	rcu_read_lock();
+	task = pid_task(proc_pid(inode), PIDTYPE_PID);
+	if (task != current) {
+		rcu_read_unlock();
+		err = -EPERM;
+		goto out;
+	}
+	rcu_read_unlock();
+
+	if (val == 1)
+		err = tick_nohz_task_set();
+	else
+		tick_nohz_task_clear();
+
+out:
+	return err < 0 ? err : count;
+}
+
+
+static const struct file_operations proc_nohz_operations = {
+	.read		= proc_nohz_read,
+	.write		= proc_nohz_write,
+	.llseek		= generic_file_llseek,
+};
+#endif /* CONFIG_NO_HZ_TASK */
+
+
 #ifdef CONFIG_FAULT_INJECTION
 static ssize_t proc_fault_inject_read(struct file * file, char __user * buf,
 				      size_t count, loff_t *ppos)
@@ -2784,6 +2861,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
 #endif
+#ifdef CONFIG_NO_HZ_TASK
+	REG("nohz", S_IWUSR|S_IRUGO, proc_nohz_operations),
+#endif
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f80088a..0e2e5c9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2552,6 +2552,7 @@ extern void task_oncpu_function_call(struct task_struct *p,
 #ifdef CONFIG_NO_HZ_TASK
 extern void smp_send_update_nohz_task_cpu(int cpu);
 extern int nohz_task_can_stop_tick(void);
+extern int sched_task_set_nohz(void);
 #else
 static inline void smp_send_update_nohz_task_cpu(int cpu) { }
 static inline int nohz_task_can_stop_tick(void) { return 0; }
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 37af961..5364438 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -137,6 +137,7 @@ extern void tick_nohz_task_enter_kernel(void);
 extern void tick_nohz_task_exit_kernel(void);
 extern void tick_nohz_task_enter_exception(struct pt_regs *regs);
 extern void tick_nohz_task_exit_exception(struct pt_regs *regs);
+extern int tick_nohz_task_set(void);
 extern void tick_nohz_task_clear(void);
 extern int tick_nohz_task_mode(void);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index bd0a41f..d553a47 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2491,6 +2491,49 @@ void smp_send_update_nohz_task_cpu(int cpu)
 	smp_call_function_single(cpu, nohz_task_cpu_update,
 				 NULL, 0);
 }
+
+int sched_task_set_nohz(void)
+{
+	int cpu;
+	struct rq *rq;
+	int err = -EBUSY;
+	unsigned long flags;
+
+	get_online_cpus();
+
+	/* We need to serialize against set_cpus_allowed() */
+	rq = task_rq_lock(current, &flags);
+
+	/* A nohz task must be affine to a single cpu */
+	if (!cpumask_weight(&current->cpus_allowed) == 1)
+		goto out;
+
+	cpu = smp_processor_id();
+
+	if (!cpu_online(cpu))
+		goto out;
+
+	/* A CPU must have a single nohz task */
+	if (cpu_has_nohz_task(cpu))
+		goto out;
+
+	/*
+	 * We need to keep at least one CPU without nohz task
+	 * for several background jobs.
+	 */
+	if (cpumask_weight(cpu_online_mask) -
+	    cpumask_weight(cpu_has_nohz_task_mask) == 1)
+		goto out;
+
+	set_cpu_has_nohz_task(cpu, 1);
+	set_thread_flag(TIF_NOHZ);
+	err = 0;
+out:
+	task_rq_unlock(rq, &flags);
+	put_online_cpus();
+
+	return err;
+}
 #endif
 
 static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index a460cee..dfb10db 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -31,6 +31,6 @@ config NO_HZ_TASK
        bool "Tickless task"
        depends on HAVE_NO_HZ_TASK && NO_HZ && SMP && HIGH_RES_TIMERS
        help
-         When a task runs alone on a CPU and switches into this mode,
-         the timer interrupt will only trigger when it is strictly
-         needed.
+         This implements the /proc/self/nohz interface. When a task
+	 runs alone on a CPU and switches into this mode, the timer
+	 interrupt will only trigger when it is strictly needed.
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 06379eb..f408803 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -720,6 +720,18 @@ void tick_check_idle(int cpu)
 }
 
 #ifdef CONFIG_NO_HZ_TASK
+int tick_nohz_task_set(void)
+{
+	/*
+	 * Only current can set this from procfs, so no possible
+	 * race.
+	 */
+	if (test_thread_flag(TIF_NOHZ))
+		return 0;
+
+	return sched_task_set_nohz();
+}
+
 void tick_nohz_task_clear(void)
 {
 	int cpu = raw_smp_processor_id();
-- 
1.7.3.2

