Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab2KCQKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:10:00 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57221 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2KCQJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:09:55 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/3] context_tracking: New context tracking susbsystem
Date: Sat,  3 Nov 2012 17:09:41 +0100
Message-Id: <1351958983-31355-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351958983-31355-1-git-send-email-fweisbec@gmail.com>
References: <1351958983-31355-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new subsystem that probes on kernel boundaries
to keep track of the transitions between level contexts
with two basic initial contexts: user or kernel.

This is an abstraction of some RCU code that use such tracking
to implement its userspace extended quiescent state.

We need to pull this up from RCU into this new level of indirection
because this tracking is also going to be used to implement an "on
demand" generic virtual cputime accounting. A necessary step to
shutdown the tick while still accounting the cputime.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/Kconfig                                       |   12 ++--
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/include/asm/{rcu.h => context_tracking.h} |   13 ++--
 arch/x86/kernel/entry_64.S                         |    2 +-
 arch/x86/kernel/ptrace.c                           |    8 +-
 arch/x86/kernel/signal.c                           |    5 +-
 arch/x86/kernel/traps.c                            |    2 +-
 arch/x86/mm/fault.c                                |    2 +-
 include/linux/context_tracking.h                   |   18 ++++
 include/linux/rcupdate.h                           |    2 -
 include/linux/sched.h                              |    8 --
 init/Kconfig                                       |   30 ++++----
 kernel/Makefile                                    |    1 +
 kernel/context_tracking.c                          |   83 ++++++++++++++++++++
 kernel/rcutree.c                                   |   64 +---------------
 kernel/sched/core.c                                |    9 +-
 16 files changed, 147 insertions(+), 114 deletions(-)
 rename arch/x86/include/asm/{rcu.h => context_tracking.h} (69%)
 create mode 100644 include/linux/context_tracking.h
 create mode 100644 kernel/context_tracking.c

diff --git a/arch/Kconfig b/arch/Kconfig
index 366ec06..3855e06 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -300,15 +300,15 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
-config HAVE_RCU_USER_QS
+config HAVE_CONTEXT_TRACKING
 	bool
 	help
-	  Provide kernel entry/exit hooks necessary for userspace
+	  Provide kernel/user boundaries probes necessary for userspace
 	  RCU extended quiescent state. Syscalls need to be wrapped inside
-	  rcu_user_exit()-rcu_user_enter() through the slow path using
-	  TIF_NOHZ flag. Exceptions handlers must be wrapped as well. Irqs
-	  are already protected inside rcu_irq_enter/rcu_irq_exit() but
-	  preemption or signal handling on irq exit still need to be protected.
+	  user_exit()-user_enter() through the slow path using TIF_NOHZ flag.
+	  Exceptions handlers must be wrapped as well. Irqs are already
+	  protected inside rcu_irq_enter/rcu_irq_exit() but preemption or
+	  signal handling on irq exit still need to be protected.
 
 config HAVE_VIRT_CPU_ACCOUNTING
 	bool
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..110cfad 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -106,7 +106,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
-	select HAVE_RCU_USER_QS if X86_64
+	select HAVE_CONTEXT_TRACKING if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select GENERIC_KERNEL_THREAD
 	select GENERIC_KERNEL_EXECVE
diff --git a/arch/x86/include/asm/rcu.h b/arch/x86/include/asm/context_tracking.h
similarity index 69%
rename from arch/x86/include/asm/rcu.h
rename to arch/x86/include/asm/context_tracking.h
index d1ac07a..4d5b661 100644
--- a/arch/x86/include/asm/rcu.h
+++ b/arch/x86/include/asm/context_tracking.h
@@ -1,21 +1,20 @@
-#ifndef _ASM_X86_RCU_H
-#define _ASM_X86_RCU_H
+#ifndef _ASM_X86_CONTEXT_TRACKING_H
+#define _ASM_X86_CONTEXT_TRACKING_H
 
 #ifndef __ASSEMBLY__
-
-#include <linux/rcupdate.h>
+#include <linux/context_tracking.h>
 #include <asm/ptrace.h>
 
 static inline void exception_enter(struct pt_regs *regs)
 {
-	rcu_user_exit();
+	user_exit();
 }
 
 static inline void exception_exit(struct pt_regs *regs)
 {
-#ifdef CONFIG_RCU_USER_QS
+#ifdef CONFIG_CONTEXT_TRACKING
 	if (user_mode(regs))
-		rcu_user_enter();
+		user_enter();
 #endif
 }
 
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b51b2c7..1a1c2ba 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -56,7 +56,7 @@
 #include <asm/ftrace.h>
 #include <asm/percpu.h>
 #include <asm/asm.h>
-#include <asm/rcu.h>
+#include <asm/context_tracking.h>
 #include <asm/smap.h>
 #include <linux/err.h>
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index eff5b8c..65b88a5 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,7 +21,7 @@
 #include <linux/signal.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
-#include <linux/rcupdate.h>
+#include <linux/context_tracking.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -1461,7 +1461,7 @@ long syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
-	rcu_user_exit();
+	user_exit();
 
 	/*
 	 * If we stepped into a sysenter/syscall insn, it trapped in
@@ -1516,7 +1516,7 @@ void syscall_trace_leave(struct pt_regs *regs)
 	 * or do_notify_resume(), in which case we can be in RCU
 	 * user mode.
 	 */
-	rcu_user_exit();
+	user_exit();
 
 	audit_syscall_exit(regs);
 
@@ -1534,5 +1534,5 @@ void syscall_trace_leave(struct pt_regs *regs)
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, step);
 
-	rcu_user_enter();
+	user_enter();
 }
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 70b27ee..fbbb604 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -22,6 +22,7 @@
 #include <linux/uaccess.h>
 #include <linux/user-return-notifier.h>
 #include <linux/uprobes.h>
+#include <linux/context_tracking.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
@@ -816,7 +817,7 @@ static void do_signal(struct pt_regs *regs)
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
-	rcu_user_exit();
+	user_exit();
 
 #ifdef CONFIG_X86_MCE
 	/* notify userspace of pending MCEs */
@@ -838,7 +839,7 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
 		fire_user_return_notifiers();
 
-	rcu_user_enter();
+	user_enter();
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8276dc6..eb85866 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -55,7 +55,7 @@
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/mce.h>
-#include <asm/rcu.h>
+#include <asm/context_tracking.h>
 
 #include <asm/mach_traps.h>
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8e13ecb..b0b1f1d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -18,7 +18,7 @@
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
 #include <asm/fixmap.h>			/* VSYSCALL_START		*/
-#include <asm/rcu.h>			/* exception_enter(), ...	*/
+#include <asm/context_tracking.h>		/* exception_enter(), ...	*/
 
 /*
  * Page fault error code bits:
diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
new file mode 100644
index 0000000..e24339c
--- /dev/null
+++ b/include/linux/context_tracking.h
@@ -0,0 +1,18 @@
+#ifndef _LINUX_CONTEXT_TRACKING_H
+#define _LINUX_CONTEXT_TRACKING_H
+
+#ifdef CONFIG_CONTEXT_TRACKING
+#include <linux/sched.h>
+
+extern void user_enter(void);
+extern void user_exit(void);
+extern void context_tracking_task_switch(struct task_struct *prev,
+					 struct task_struct *next);
+#else
+static inline void user_enter(void) { }
+static inline void user_exit(void) { }
+static inline void context_tracking_task_switch(struct task_struct *prev,
+						struct task_struct *next) { }
+#endif /* !CONFIG_CONTEXT_TRACKING */
+
+#endif
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 7c968e4..f5034f2 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -197,8 +197,6 @@ extern void rcu_user_enter(void);
 extern void rcu_user_exit(void);
 extern void rcu_user_enter_after_irq(void);
 extern void rcu_user_exit_after_irq(void);
-extern void rcu_user_hooks_switch(struct task_struct *prev,
-				  struct task_struct *next);
 #else
 static inline void rcu_user_enter(void) { }
 static inline void rcu_user_exit(void) { }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e1581a0..6c13fe3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1866,14 +1866,6 @@ static inline void rcu_copy_process(struct task_struct *p)
 
 #endif
 
-static inline void rcu_switch(struct task_struct *prev,
-			      struct task_struct *next)
-{
-#ifdef CONFIG_RCU_USER_QS
-	rcu_user_hooks_switch(prev, next);
-#endif
-}
-
 static inline void tsk_restore_flags(struct task_struct *task,
 				unsigned long orig_flags, unsigned long flags)
 {
diff --git a/init/Kconfig b/init/Kconfig
index 6fdd6e3..15e44e7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -436,6 +436,19 @@ config TASK_IO_ACCOUNTING
 
 endmenu # "CPU/Task time and stats accounting"
 
+config CONTEXT_TRACKING
+       bool
+
+config CONTEXT_TRACKING_FORCE
+	bool "Force context tracking"
+	depends on CONTEXT_TRACKING
+	help
+	  Probe on user/kernel boundaries by default in order to
+	  test the features that rely on it such as userspace RCU extended
+	  quiescent states.
+	  This test is there for debugging until we have a real user like a
+	  full adaptive nohz option.
+
 menu "RCU Subsystem"
 
 choice
@@ -488,7 +501,8 @@ config PREEMPT_RCU
 
 config RCU_USER_QS
 	bool "Consider userspace as in RCU extended quiescent state"
-	depends on HAVE_RCU_USER_QS && SMP
+	depends on HAVE_CONTEXT_TRACKING && SMP
+	select CONTEXT_TRACKING
 	help
 	  This option sets hooks on kernel / userspace boundaries and
 	  puts RCU in extended quiescent state when the CPU runs in
@@ -502,20 +516,6 @@ config RCU_USER_QS
 
 	  If unsure say N
 
-config RCU_USER_QS_FORCE
-	bool "Force userspace extended QS by default"
-	depends on RCU_USER_QS
-	help
-	  Set the hooks in user/kernel boundaries by default in order to
-	  test this feature that treats userspace as an extended quiescent
-	  state until we have a real user like a full adaptive nohz option.
-
-	  Unless you want to hack and help the development of the full
-	  tickless feature, you shouldn't enable this option. It adds
-	  unnecessary overhead.
-
-	  If unsure say N
-
 config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
diff --git a/kernel/Makefile b/kernel/Makefile
index 0dfeca4..f90bbfc 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
+obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
new file mode 100644
index 0000000..d7983ea
--- /dev/null
+++ b/kernel/context_tracking.c
@@ -0,0 +1,83 @@
+#include <linux/context_tracking.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
+
+struct context_tracking {
+	/*
+	 * When active is false, hooks are not set to
+	 * minimize overhead: TIF flags are cleared
+	 * and calls to user_enter/exit are ignored. This
+	 * may be further optimized using static keys.
+	 */
+	bool active;
+	enum {
+		IN_KERNEL = 0,
+		IN_USER,
+	} state;
+};
+
+DEFINE_PER_CPU(struct context_tracking, context_tracking) = {
+#ifdef CONFIG_CONTEXT_TRACKING_FORCE
+	.active = true,
+#endif
+};
+
+void user_enter(void)
+{
+	unsigned long flags;
+
+	/*
+	 * Some contexts may involve an exception occuring in an irq,
+	 * leading to that nesting:
+	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
+	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
+	 * helpers are enough to protect RCU uses inside the exception. So
+	 * just return immediately if we detect we are in an IRQ.
+	 */
+	if (in_interrupt())
+		return;
+
+	WARN_ON_ONCE(!current->mm);
+
+	local_irq_save(flags);
+	if (__this_cpu_read(context_tracking.active) &&
+	    __this_cpu_read(context_tracking.state) != IN_USER) {
+		__this_cpu_write(context_tracking.state, IN_USER);
+		rcu_user_enter();
+	}
+	local_irq_restore(flags);
+}
+
+void user_exit(void)
+{
+	unsigned long flags;
+
+	/*
+	 * Some contexts may involve an exception occuring in an irq,
+	 * leading to that nesting:
+	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
+	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
+	 * helpers are enough to protect RCU uses inside the exception. So
+	 * just return immediately if we detect we are in an IRQ.
+	 */
+	if (in_interrupt())
+		return;
+
+	local_irq_save(flags);
+	if (__this_cpu_read(context_tracking.state) == IN_USER) {
+		__this_cpu_write(context_tracking.state, IN_KERNEL);
+		rcu_user_exit();
+	}
+	local_irq_restore(flags);
+}
+
+void context_tracking_task_switch(struct task_struct *prev,
+			     struct task_struct *next)
+{
+	if (__this_cpu_read(context_tracking.active)) {
+		clear_tsk_thread_flag(prev, TIF_NOHZ);
+		set_tsk_thread_flag(next, TIF_NOHZ);
+	}
+}
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 74df86b..d3700a4 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -207,9 +207,6 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
 	.dynticks = ATOMIC_INIT(1),
-#if defined(CONFIG_RCU_USER_QS) && !defined(CONFIG_RCU_USER_QS_FORCE)
-	.ignore_user_qs = true,
-#endif
 };
 
 static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
@@ -416,29 +413,7 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
  */
 void rcu_user_enter(void)
 {
-	unsigned long flags;
-	struct rcu_dynticks *rdtp;
-
-	/*
-	 * Some contexts may involve an exception occuring in an irq,
-	 * leading to that nesting:
-	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
-	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
-	 * helpers are enough to protect RCU uses inside the exception. So
-	 * just return immediately if we detect we are in an IRQ.
-	 */
-	if (in_interrupt())
-		return;
-
-	WARN_ON_ONCE(!current->mm);
-
-	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (!rdtp->ignore_user_qs && !rdtp->in_user) {
-		rdtp->in_user = true;
-		rcu_eqs_enter(true);
-	}
-	local_irq_restore(flags);
+	rcu_eqs_enter(1);
 }
 
 /**
@@ -575,27 +550,7 @@ EXPORT_SYMBOL_GPL(rcu_idle_exit);
  */
 void rcu_user_exit(void)
 {
-	unsigned long flags;
-	struct rcu_dynticks *rdtp;
-
-	/*
-	 * Some contexts may involve an exception occuring in an irq,
-	 * leading to that nesting:
-	 * rcu_irq_enter() rcu_user_exit() rcu_user_exit() rcu_irq_exit()
-	 * This would mess up the dyntick_nesting count though. And rcu_irq_*()
-	 * helpers are enough to protect RCU uses inside the exception. So
-	 * just return immediately if we detect we are in an IRQ.
-	 */
-	if (in_interrupt())
-		return;
-
-	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (rdtp->in_user) {
-		rdtp->in_user = false;
-		rcu_eqs_exit(true);
-	}
-	local_irq_restore(flags);
+	rcu_eqs_exit(1);
 }
 
 /**
@@ -718,21 +673,6 @@ int rcu_is_cpu_idle(void)
 }
 EXPORT_SYMBOL(rcu_is_cpu_idle);
 
-#ifdef CONFIG_RCU_USER_QS
-void rcu_user_hooks_switch(struct task_struct *prev,
-			   struct task_struct *next)
-{
-	struct rcu_dynticks *rdtp;
-
-	/* Interrupts are disabled in context switch */
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (!rdtp->ignore_user_qs) {
-		clear_tsk_thread_flag(prev, TIF_NOHZ);
-		set_tsk_thread_flag(next, TIF_NOHZ);
-	}
-}
-#endif /* #ifdef CONFIG_RCU_USER_QS */
-
 #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5dae0d2..e0d02ab 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -72,6 +72,7 @@
 #include <linux/slab.h>
 #include <linux/init_task.h>
 #include <linux/binfmts.h>
+#include <linux/context_tracking.h>
 
 #include <asm/switch_to.h>
 #include <asm/tlb.h>
@@ -1897,8 +1898,8 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
 #endif
 
+	context_tracking_task_switch(prev, next);
 	/* Here we just switch the register state and the stack. */
-	rcu_switch(prev, next);
 	switch_to(prev, next, prev);
 
 	barrier();
@@ -2931,9 +2932,9 @@ asmlinkage void __sched schedule_user(void)
 	 * we haven't yet exited the RCU idle mode. Do it here manually until
 	 * we find a better solution.
 	 */
-	rcu_user_exit();
+	user_exit();
 	schedule();
-	rcu_user_enter();
+	user_enter();
 }
 #endif
 
@@ -3038,7 +3039,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	/* Catch callers which need to be fixed */
 	BUG_ON(ti->preempt_count || !irqs_disabled());
 
-	rcu_user_exit();
+	user_exit();
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
-- 
1.7.5.4

