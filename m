Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2FMQUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:20:55 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40424 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2FMQU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:20:29 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: [PATCH 7/7] x86: Exception hooks for adaptive tickless
Date: Wed, 13 Jun 2012 18:19:57 +0200
Message-Id: <1339604397-8758-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add necessary hooks to x86 exception for adaptive nohz
support so that the time spent on exceptions handling is
considered as system cputime.

This includes traps, page fault, debug exceptions, etc...

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
 arch/x86/kernel/traps.c |   14 ++++++++++----
 arch/x86/mm/fault.c     |   13 +++++++++++--
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c70684f..af77028 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -95,6 +95,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select HAVE_NO_HZ_FULL
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 05b31d9..196e641 100644
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
@@ -311,6 +312,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	    ftrace_int3_handler(regs))
 		return;
 #endif
+	tick_nohz_enter_exception(regs);
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
@@ -330,6 +332,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	do_trap(X86_TRAP_BP, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
+	tick_nohz_exit_exception(regs);
 }
 
 #ifdef CONFIG_X86_64
@@ -390,6 +393,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	unsigned long dr6;
 	int si_code;
 
+	tick_nohz_enter_exception(regs);
+
 	get_debugreg(dr6, 6);
 
 	/* Filter out all the reserved bits which are preset to 1 */
@@ -405,7 +410,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	/* Catch kmemcheck conditions first of all! */
 	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
-		return;
+		goto exit;
 
 	/* DR6 may or may not be cleared by the CPU */
 	set_debugreg(0, 6);
@@ -420,7 +425,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
 							SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto exit;
 
 	/*
 	 * Let others (NMI) know that the debug stack is in use
@@ -436,7 +441,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 					X86_TRAP_DB);
 		preempt_conditional_cli(regs);
 		debug_stack_usage_dec();
-		return;
+		goto exit;
 	}
 
 	/*
@@ -457,7 +462,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
 
-	return;
+exit:
+	tick_nohz_exit_exception(regs);
 }
 
 /*
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 76dcd9d..6b1ee80 100644
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

