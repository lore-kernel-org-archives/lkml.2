Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1HOPy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:54:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46598 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1HOPyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:54:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 30/32] x86: Exception hooks for nohz cpusets
Date: Mon, 15 Aug 2011 17:52:27 +0200
Message-Id: <1313423549-27093-31-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add necessary hooks to x86 exception for nohz cpusets
support. It includes traps, page fault, debug exceptions,
etc...

TODO: handle do_notify_resume(). Not an exception but
it's executed at the end of the syscall/irq path so
it's beyond our hooks but shouldn't be considered as
userspace code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 arch/x86/Kconfig        |    1 +
 arch/x86/kernel/traps.c |   22 +++++++++++++++-------
 arch/x86/mm/fault.c     |   13 +++++++++++--
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 67979f4..1b12b1a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -69,6 +69,7 @@ config X86
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if (X86_64 && NET)
+	select HAVE_CPUSETS_NO_HZ
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b9b6716..d98f2f4 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -26,6 +26,7 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/init.h>
+#include <linux/tick.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/mm.h>
@@ -456,24 +457,28 @@ void restart_nmi(void)
 /* May run on IST stack. */
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
+	tick_nohz_enter_exception(regs);
+
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
-		return;
+		goto exit;
 #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 #ifdef CONFIG_KPROBES
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
-		return;
+		goto exit;
 #else
 	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
-		return;
+		goto exit;
 #endif
 
 	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
+exit:
+	tick_nohz_exit_exception(regs);
 }
 
 #ifdef CONFIG_X86_64
@@ -534,6 +539,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	unsigned long dr6;
 	int si_code;
 
+	tick_nohz_enter_exception(regs);
+
 	get_debugreg(dr6, 6);
 
 	/* Filter out all the reserved bits which are preset to 1 */
@@ -549,7 +556,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	/* Catch kmemcheck conditions first of all! */
 	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
-		return;
+		goto exit;
 
 	/* DR6 may or may not be cleared by the CPU */
 	set_debugreg(0, 6);
@@ -564,7 +571,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
 							SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto exit;
 
 	/* It's safe to allow irq's after DR6 has been saved */
 	preempt_conditional_sti(regs);
@@ -573,7 +580,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
 				error_code, 1);
 		preempt_conditional_cli(regs);
-		return;
+		goto exit;
 	}
 
 	/*
@@ -593,7 +600,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
 
-	return;
+exit:
+	tick_nohz_exit_exception(regs);
 }
 
 /*
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 4d09df0..aa2e2e3 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -13,6 +13,7 @@
 #include <linux/perf_event.h>		/* perf_sw_event		*/
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
 #include <linux/prefetch.h>		/* prefetchw			*/
+#include <linux/tick.h>
 
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
@@ -971,8 +972,8 @@ static int fault_in_kernel_space(unsigned long address)
  * and the problem, and then passes it off to one of the appropriate
  * routines.
  */
-dotraplinkage void __kprobes
-do_page_fault(struct pt_regs *regs, unsigned long error_code)
+static void __kprobes
+__do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
@@ -1180,3 +1181,11 @@ good_area:
 
 	up_read(&mm->mmap_sem);
 }
+
+dotraplinkage void __kprobes
+do_page_fault(struct pt_regs *regs, unsigned long error_code)
+{
+	tick_nohz_enter_exception(regs);
+	__do_page_fault(regs, error_code);
+	tick_nohz_exit_exception(regs);
+}
-- 
1.7.5.4

