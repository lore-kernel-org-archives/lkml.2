Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab2CPVkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:40:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758065Ab2CPVkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:40:21 -0400
From: Richard Weinberger <richard@nod.at>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, josh@joshtriplett.org,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH v2] x86: Merge x86_32 and x86_64 cpu_idle()
Date: Fri, 16 Mar 2012 22:40:10 +0100
Message-Id: <1331934010-24740-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <4F63AF10.9030101@zytor.com>
References: <4F63AF10.9030101@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both functions are mostly identical, so we can merge them.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/include/asm/idle.h  |    1 +
 arch/x86/kernel/process.c    |  114 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c |   60 ----------------------
 arch/x86/kernel/process_64.c |  109 ----------------------------------------
 4 files changed, 115 insertions(+), 169 deletions(-)

diff --git a/arch/x86/include/asm/idle.h b/arch/x86/include/asm/idle.h
index f49253d7..c5d1785 100644
--- a/arch/x86/include/asm/idle.h
+++ b/arch/x86/include/asm/idle.h
@@ -14,6 +14,7 @@ void exit_idle(void);
 #else /* !CONFIG_X86_64 */
 static inline void enter_idle(void) { }
 static inline void exit_idle(void) { }
+static inline void __exit_idle(void) { }
 #endif /* CONFIG_X86_64 */
 
 void amd_e400_remove_cpu(int cpu);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 15763af..11a2c29 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -12,6 +12,9 @@
 #include <linux/user-return-notifier.h>
 #include <linux/dmi.h>
 #include <linux/utsname.h>
+#include <linux/stackprotector.h>
+#include <linux/tick.h>
+#include <linux/cpuidle.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
 #include <asm/cpu.h>
@@ -22,6 +25,24 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/debugreg.h>
+#include <asm/nmi.h>
+
+#ifdef CONFIG_X86_64
+static DEFINE_PER_CPU(unsigned char, is_idle);
+static ATOMIC_NOTIFIER_HEAD(idle_notifier);
+
+void idle_notifier_register(struct notifier_block *n)
+{
+	atomic_notifier_chain_register(&idle_notifier, n);
+}
+EXPORT_SYMBOL_GPL(idle_notifier_register);
+
+void idle_notifier_unregister(struct notifier_block *n)
+{
+	atomic_notifier_chain_unregister(&idle_notifier, n);
+}
+EXPORT_SYMBOL_GPL(idle_notifier_unregister);
+#endif
 
 struct kmem_cache *task_xstate_cachep;
 EXPORT_SYMBOL_GPL(task_xstate_cachep);
@@ -370,6 +391,99 @@ static inline int hlt_use_halt(void)
 }
 #endif
 
+#ifndef CONFIG_SMP
+static inline void play_dead(void)
+{
+	BUG();
+}
+#endif
+
+#ifdef CONFIG_X86_64
+void enter_idle(void)
+{
+	percpu_write(is_idle, 1);
+	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
+}
+
+static void __exit_idle(void)
+{
+	if (x86_test_and_clear_bit_percpu(0, is_idle) == 0)
+		return;
+	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
+}
+
+/* Called from interrupts to signify idle end */
+void exit_idle(void)
+{
+	/* idle loop has pid 0 */
+	if (current->pid)
+		return;
+	__exit_idle();
+}
+#endif
+
+/*
+ * The idle thread. There's no useful work to be
+ * done, so just try to conserve power and have a
+ * low exit latency (ie sit in a loop waiting for
+ * somebody to say that they'd like to reschedule)
+ */
+void cpu_idle(void)
+{
+	/*
+	 * If we're the non-boot CPU, nothing set the stack canary up
+	 * for us.  CPU0 already has it initialized but no harm in
+	 * doing it again.  This is a good place for updating it, as
+	 * we wont ever return from this function (so the invalid
+	 * canaries already on the stack wont ever trigger).
+	 */
+	boot_init_stack_canary();
+	current_thread_info()->status |= TS_POLLING;
+
+	while (1) {
+		tick_nohz_idle_enter();
+
+		while (!need_resched()) {
+			rmb();
+
+			if (cpu_is_offline(smp_processor_id()))
+				play_dead();
+
+			/*
+			 * Idle routines should keep interrupts disabled
+			 * from here on, until they go to idle.
+			 * Otherwise, idle callbacks can misfire.
+			 */
+			local_touch_nmi();
+			local_irq_disable();
+
+			enter_idle();
+
+			/* Don't trace irqs off for idle */
+			stop_critical_timings();
+
+			/* enter_idle() needs rcu for notifiers */
+			rcu_idle_enter();
+
+			if (cpuidle_idle_call())
+				pm_idle();
+
+			rcu_idle_exit();
+			start_critical_timings();
+
+			/* In many cases the interrupt that ended idle
+			   has already called exit_idle. But some idle
+			   loops can be woken up without interrupt. */
+			__exit_idle();
+		}
+
+		tick_nohz_idle_exit();
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
+	}
+}
+
 /*
  * We use this if we don't have any better
  * idle routine..
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index c08d1ff..9bf7c10 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -9,7 +9,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -31,14 +30,12 @@
 #include <linux/kallsyms.h>
 #include <linux/ptrace.h>
 #include <linux/personality.h>
-#include <linux/tick.h>
 #include <linux/percpu.h>
 #include <linux/prctl.h>
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/kdebug.h>
-#include <linux/cpuidle.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -57,7 +54,6 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
-#include <asm/nmi.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -69,62 +65,6 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 	return ((unsigned long *)tsk->thread.sp)[3];
 }
 
-#ifndef CONFIG_SMP
-static inline void play_dead(void)
-{
-	BUG();
-}
-#endif
-
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	int cpu = smp_processor_id();
-
-	/*
-	 * If we're the non-boot CPU, nothing set the stack canary up
-	 * for us.  CPU0 already has it initialized but no harm in
-	 * doing it again.  This is a good place for updating it, as
-	 * we wont ever return from this function (so the invalid
-	 * canaries already on the stack wont ever trigger).
-	 */
-	boot_init_stack_canary();
-
-	current_thread_info()->status |= TS_POLLING;
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched()) {
-
-			check_pgt_cache();
-			rmb();
-
-			if (cpu_is_offline(cpu))
-				play_dead();
-
-			local_touch_nmi();
-			local_irq_disable();
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-			if (cpuidle_idle_call())
-				pm_idle();
-			start_critical_timings();
-		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
-}
-
 void __show_regs(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index cfa5c90..4f862d7 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -14,7 +14,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -32,12 +31,10 @@
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
-#include <linux/tick.h>
 #include <linux/prctl.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
-#include <linux/cpuidle.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -51,116 +48,10 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
-#include <asm/nmi.h>
 
 asmlinkage extern void ret_from_fork(void);
 
 DEFINE_PER_CPU(unsigned long, old_rsp);
-static DEFINE_PER_CPU(unsigned char, is_idle);
-
-static ATOMIC_NOTIFIER_HEAD(idle_notifier);
-
-void idle_notifier_register(struct notifier_block *n)
-{
-	atomic_notifier_chain_register(&idle_notifier, n);
-}
-EXPORT_SYMBOL_GPL(idle_notifier_register);
-
-void idle_notifier_unregister(struct notifier_block *n)
-{
-	atomic_notifier_chain_unregister(&idle_notifier, n);
-}
-EXPORT_SYMBOL_GPL(idle_notifier_unregister);
-
-void enter_idle(void)
-{
-	percpu_write(is_idle, 1);
-	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
-}
-
-static void __exit_idle(void)
-{
-	if (x86_test_and_clear_bit_percpu(0, is_idle) == 0)
-		return;
-	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
-}
-
-/* Called from interrupts to signify idle end */
-void exit_idle(void)
-{
-	/* idle loop has pid 0 */
-	if (current->pid)
-		return;
-	__exit_idle();
-}
-
-#ifndef CONFIG_SMP
-static inline void play_dead(void)
-{
-	BUG();
-}
-#endif
-
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	current_thread_info()->status |= TS_POLLING;
-
-	/*
-	 * If we're the non-boot CPU, nothing set the stack canary up
-	 * for us.  CPU0 already has it initialized but no harm in
-	 * doing it again.  This is a good place for updating it, as
-	 * we wont ever return from this function (so the invalid
-	 * canaries already on the stack wont ever trigger).
-	 */
-	boot_init_stack_canary();
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		while (!need_resched()) {
-
-			rmb();
-
-			if (cpu_is_offline(smp_processor_id()))
-				play_dead();
-			/*
-			 * Idle routines should keep interrupts disabled
-			 * from here on, until they go to idle.
-			 * Otherwise, idle callbacks can misfire.
-			 */
-			local_touch_nmi();
-			local_irq_disable();
-			enter_idle();
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-
-			/* enter_idle() needs rcu for notifiers */
-			rcu_idle_enter();
-
-			if (cpuidle_idle_call())
-				pm_idle();
-
-			rcu_idle_exit();
-			start_critical_timings();
-
-			/* In many cases the interrupt that ended idle
-			   has already called exit_idle. But some idle
-			   loops can be woken up without interrupt. */
-			__exit_idle();
-		}
-
-		tick_nohz_idle_exit();
-		preempt_enable_no_resched();
-		schedule();
-		preempt_disable();
-	}
-}
 
 /* Prints also some state that isn't saved in the pt_regs */
 void __show_regs(struct pt_regs *regs, int all)
-- 
1.7.7.3

