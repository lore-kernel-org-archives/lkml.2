Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab2CZPbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:31:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52735 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab2CZPbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:31:42 -0400
Date: Mon, 26 Mar 2012 08:31:16 -0700
From: tip-bot for Richard Weinberger <richard@nod.at>
Message-ID: <tip-90e240142bd31ff10aeda5a280a53153f4eff004@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, richard@nod.at, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, richard@nod.at, tglx@linutronix.de
In-Reply-To: <1332709204-22496-1-git-send-email-richard@nod.at>
References: <1332709204-22496-1-git-send-email-richard@nod.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Merge the x86_32 and x86_64 cpu_idle()
  functions
Git-Commit-ID: 90e240142bd31ff10aeda5a280a53153f4eff004
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 26 Mar 2012 08:31:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90e240142bd31ff10aeda5a280a53153f4eff004
Gitweb:     http://git.kernel.org/tip/90e240142bd31ff10aeda5a280a53153f4eff004
Author:     Richard Weinberger <richard@nod.at>
AuthorDate: Sun, 25 Mar 2012 23:00:04 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 26 Mar 2012 03:16:07 +0200

x86: Merge the x86_32 and x86_64 cpu_idle() functions

Both functions are mostly identical.
The differences are:

- x86_32's cpu_idle() makes use of check_pgt_cache(), which is a
  nop on both x86_32 and x86_64.

- x86_64's cpu_idle() uses enter/__exit_idle/(), on x86_32 these
  function are a nop.

- In contrast to x86_32, x86_64 calls rcu_idle_enter/exit() in
  the innermost loop because idle notifications need RCU.
  Calling these function on x86_32 also in the innermost loop
  does not hurt.

So we can merge both functions.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulmck@linux.vnet.ibm.com
Cc: josh@joshtriplett.org
Cc: tj@kernel.org
Link: http://lkml.kernel.org/r/1332709204-22496-1-git-send-email-richard@nod.at
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/idle.h  |    1 +
 arch/x86/kernel/process.c    |  114 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c |   58 ---------------------
 arch/x86/kernel/process_64.c |  107 ---------------------------------------
 4 files changed, 115 insertions(+), 165 deletions(-)

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
index 14baf78..29309c4 100644
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
@@ -23,6 +26,24 @@
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
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
@@ -371,6 +392,99 @@ static inline int hlt_use_halt(void)
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
index 9d7d484..ea207c2 100644
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
@@ -58,7 +55,6 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
-#include <asm/nmi.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -70,60 +66,6 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
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
-		schedule_preempt_disabled();
-	}
-}
-
 void __show_regs(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 292da13..ce5e34f 100644
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
@@ -52,114 +49,10 @@
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
-		schedule_preempt_disabled();
-	}
-}
 
 /* Prints also some state that isn't saved in the pt_regs */
 void __show_regs(struct pt_regs *regs, int all)
