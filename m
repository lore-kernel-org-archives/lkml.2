Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2EAAEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:04:52 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:41487 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2EAAEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:04:49 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 25/41] x86: Exception hooks for nohz cpusets
Date: Tue,  1 May 2012 01:54:59 +0200
Message-Id: <1335830115-14335-26-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add necessary hooks to x86 exception for nohz cpusets
support. It includes traps, page fault, debug exceptions,
etc...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig        |    1 +
 arch/x86/kernel/traps.c |   20 ++++++++++++++------
 arch/x86/mm/fault.c     |   13 +++++++++++--
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..0d3116c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -82,6 +82,7 @@ config X86
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
+	select HAVE_CPUSETS_NO_HZ
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4bbe04d..977d0b9 100644
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
@@ -301,15 +302,17 @@ gp_in_kernel:
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
 
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
-		return;
+		goto exit;
 
 	/*
 	 * Let others (NMI) know that the debug stack is in use
@@ -320,6 +323,8 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
+exit:
+	tick_nohz_exit_exception(regs);
 }
 
 #ifdef CONFIG_X86_64
@@ -380,6 +385,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	unsigned long dr6;
 	int si_code;
 
+	tick_nohz_enter_exception(regs);
+
 	get_debugreg(dr6, 6);
 
 	/* Filter out all the reserved bits which are preset to 1 */
@@ -395,7 +402,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	/* Catch kmemcheck conditions first of all! */
 	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
-		return;
+		goto exit;
 
 	/* DR6 may or may not be cleared by the CPU */
 	set_debugreg(0, 6);
@@ -410,7 +417,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
 							SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto exit;
 
 	/*
 	 * Let others (NMI) know that the debug stack is in use
@@ -426,7 +433,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 				error_code, 1);
 		preempt_conditional_cli(regs);
 		debug_stack_usage_dec();
-		return;
+		goto exit;
 	}
 
 	/*
@@ -447,7 +454,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
 
-	return;
+exit:
+	tick_nohz_exit_exception(regs);
 }
 
 /*
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f0b4caf..6c4c983 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -13,6 +13,7 @@
 #include <linux/perf_event.h>		/* perf_sw_event		*/
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
 #include <linux/prefetch.h>		/* prefetchw			*/
+#include <linux/tick.h>
 
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
@@ -1000,8 +1001,8 @@ static int fault_in_kernel_space(unsigned long address)
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
@@ -1209,3 +1210,11 @@ good_area:
 
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

