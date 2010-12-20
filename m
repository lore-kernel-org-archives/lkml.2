Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0LTPZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:25:01 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:42508 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab0LTPYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:24:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QEiPG2lDIkAbiDMkN+RGDAa+vzmEEOWsHZ5MVYXVo3eT6ycM4kQ1ZNSCUHUWiS7i8y
         fZRhUysJ/iX28m/H0ZSflNeVNXqXUH/Bl0+tZbkHOgkxaBmrUsmsCfHORiOU+TQgd4MM
         qHTeGXBD3BsDDGNDpogK5sJOt7KuMpOWhDswc=
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
Subject: [RFC PATCH 10/15] nohz_task: Enter in extended quiescent state when in userspace
Date: Mon, 20 Dec 2010 16:24:17 +0100
Message-Id: <1292858662-5650-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A nohz task can safely enter into extended quiescent state when
it goes into userspace, this avoids a remote cpu to force the
nohz task to be interrupted in order to notify quiescent states.

We enter into an extended quiescent state when:

- A nohz task resumes to userspace and is alone running on the
CPU (we check if the local cpu is in nohz mode, which means
no other task compete on that CPU). If the tick is still running
then entering into extended QS will be done later from the second
case:

- When the tick stops and verify the current task is a nohz one,
is alone running on the CPU and runs in userspace.

We exit the extended quiescent state when:

- A nohz task enters the kernel and is alone running on the CPU.
Again we check if the local cpu is in nohz mode for that. If
the tick is still running then it means we are not in an extended
QS and we don't do anything.

- The tick restarts because a new task is enqueued.

Whether the nohz task is in userspace or not is tracked by the
per cpu nohz_task_ext_qs variable.

Architectures need to provide some backend to notify userspace
exit/entry in order to support this mode.
It needs to implement the TIF_NOHZ flag that switches to slow
path syscall mode and to notify exceptions entry/exit.

We don't need to handle irqs or nmis as those are already handled
by RCU through rcu_enter_irq/nmi helpers.

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
 arch/Kconfig             |    4 +++
 include/linux/tick.h     |   16 ++++++++++-
 kernel/sched.c           |    3 ++
 kernel/time/tick-sched.c |   61 +++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index e631791..d1ebea3 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -177,5 +177,9 @@ config HAVE_ARCH_JUMP_LABEL
 
 config HAVE_NO_HZ_TASK
 	bool
+	help
+	  Features necessary hooks for a task wanting to enter nohz
+	  while running alone on a CPU: thread flag for syscall hooks
+	  and exceptions entry/exit hooks.
 
 source "kernel/gcov/Kconfig"
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 7465a47..a704bb7 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -8,6 +8,7 @@
 
 #include <linux/clockchips.h>
 #include <linux/percpu-defs.h>
+#include <asm/ptrace.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
@@ -130,10 +131,21 @@ extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 
 #ifdef CONFIG_NO_HZ_TASK
 DECLARE_PER_CPU(int, task_nohz_mode);
+DECLARE_PER_CPU(int, nohz_task_ext_qs);
+
+extern void tick_nohz_task_enter_kernel(void);
+extern void tick_nohz_task_exit_kernel(void);
+extern void tick_nohz_task_enter_exception(struct pt_regs *regs);
+extern void tick_nohz_task_exit_exception(struct pt_regs *regs);
 extern int tick_nohz_task_mode(void);
-#else
+
+#else /* !NO_HZ_TASK */
+static inline void tick_nohz_task_enter_kernel(void) { }
+static inline void tick_nohz_task_exit_kernel(void) { }
+static inline void tick_nohz_task_enter_exception(struct pt_regs *regs) { }
+static inline void tick_nohz_task_exit_exception(struct pt_regs *regs) { }
 static inline int tick_nohz_task_mode(void) { return 0; }
-#endif
+#endif /* !NO_HZ_TASK */
 
 # else /* !NO_HZ */
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
diff --git a/kernel/sched.c b/kernel/sched.c
index b99f192..4412493 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2464,6 +2464,9 @@ static void nohz_task_cpu_update(void *unused)
 	if (rq->nr_running > 1 || rcu_pending(cpu) || rcu_needs_cpu(cpu)) {
 		__get_cpu_var(task_nohz_mode) = 0;
 		tick_nohz_restart_sched_tick();
+
+		if (__get_cpu_var(nohz_task_ext_qs))
+			rcu_exit_nohz();
 	}
 }
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 88011b9..9a4aa39 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -720,6 +720,62 @@ void tick_check_idle(int cpu)
 }
 
 #ifdef CONFIG_NO_HZ_TASK
+DEFINE_PER_CPU(int, nohz_task_ext_qs);
+
+void tick_nohz_task_exit_kernel(void)
+{
+	unsigned long flags;
+
+	if (!test_thread_flag(TIF_NOHZ))
+		return;
+
+	local_irq_save(flags);
+
+	__get_cpu_var(nohz_task_ext_qs) = 1;
+	/*
+	 * Only enter extended QS if the tick is not running.
+	 * Otherwise the tick will handle that later when it
+	 * will decide to stop.
+	 */
+	if (__get_cpu_var(task_nohz_mode))
+		rcu_enter_nohz();
+
+	local_irq_restore(flags);
+}
+
+void tick_nohz_task_enter_kernel(void)
+{
+	unsigned long flags;
+
+	if (!test_thread_flag(TIF_NOHZ))
+		return;
+
+	local_irq_save(flags);
+
+	__get_cpu_var(nohz_task_ext_qs) = 0;
+	/*
+	 * If the tick was running, then we weren't in
+	 * rcu extended period. Only exit extended QS
+	 * if we were in such state.
+	 */
+	if (__get_cpu_var(task_nohz_mode))
+		rcu_exit_nohz();
+
+	local_irq_restore(flags);
+}
+
+void tick_nohz_task_enter_exception(struct pt_regs *regs)
+{
+	if (user_mode(regs))
+		tick_nohz_task_enter_kernel();
+}
+
+void tick_nohz_task_exit_exception(struct pt_regs *regs)
+{
+	if (user_mode(regs))
+		tick_nohz_task_exit_kernel();
+}
+
 int tick_nohz_task_mode(void)
 {
 	return __get_cpu_var(task_nohz_mode);
@@ -730,8 +786,11 @@ static void tick_nohz_task_stop_tick(void)
 	if (!test_thread_flag(TIF_NOHZ) || __get_cpu_var(task_nohz_mode))
 		return;
 
-	if (nohz_task_can_stop_tick())
+	if (nohz_task_can_stop_tick()) {
 		__get_cpu_var(task_nohz_mode) = 1;
+		if (__get_cpu_var(nohz_task_ext_qs))
+			rcu_enter_nohz();
+	}
 }
 #else
 static void tick_nohz_task_stop_tick(void) { }
-- 
1.7.3.2

