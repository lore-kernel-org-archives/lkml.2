Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab2GKS1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:27:35 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47918 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276Ab2GKS1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:27:20 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 06/11] x86: Exception hooks for userspace RCU extended QS
Date: Wed, 11 Jul 2012 20:26:35 +0200
Message-Id: <1342031200-22731-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
References: <1342031200-22731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add necessary hooks to x86 exception for userspace
RCU extended quiescent state support.

This includes traps, page fault, debug exceptions, etc...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/rcu.h |   20 ++++++++++++++++++++
 arch/x86/kernel/traps.c    |   30 ++++++++++++++++++++++--------
 arch/x86/mm/fault.c        |   13 +++++++++++--
 3 files changed, 53 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/include/asm/rcu.h

diff --git a/arch/x86/include/asm/rcu.h b/arch/x86/include/asm/rcu.h
new file mode 100644
index 0000000..439815b
--- /dev/null
+++ b/arch/x86/include/asm/rcu.h
@@ -0,0 +1,20 @@
+#ifndef _ASM_X86_RCU_H
+#define _ASM_X86_RCU_H
+
+#include <linux/rcupdate.h>
+#include <asm/ptrace.h>
+
+static inline void exception_enter(struct pt_regs *regs)
+{
+	rcu_user_exit();
+}
+
+static inline void exception_exit(struct pt_regs *regs)
+{
+#ifdef CONFIG_RCU_USER_QS
+	if (user_mode(regs))
+		rcu_user_enter();
+#endif
+}
+
+#endif
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 05b31d9..9b8195b 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -52,6 +52,7 @@
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/mce.h>
+#include <asm/rcu.h>
 
 #include <asm/mach_traps.h>
 
@@ -178,11 +179,15 @@ vm86_trap:
 #define DO_ERROR(trapnr, signr, str, name)				\
 dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
+	exception_enter(regs);						\
+	if (notify_die(DIE_TRAP, str, regs, error_code,			\
+			trapnr, signr) == NOTIFY_STOP) {		\
+		exception_exit(regs);					\
 		return;							\
+	}								\
 	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
+	exception_exit(regs);						\
 }
 
 #define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
@@ -193,11 +198,15 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 	info.si_errno = 0;						\
 	info.si_code = sicode;						\
 	info.si_addr = (void __user *)siaddr;				\
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-							== NOTIFY_STOP)	\
+	exception_enter(regs);						\
+	if (notify_die(DIE_TRAP, str, regs, error_code,			\
+			trapnr, signr) == NOTIFY_STOP) {		\
+		exception_exit(regs);					\
 		return;							\
+	}								\
 	conditional_sti(regs);						\
 	do_trap(trapnr, signr, str, regs, error_code, &info);		\
+	exception_exit(regs);						\
 }
 
 DO_ERROR_INFO(X86_TRAP_DE, SIGFPE, "divide error", divide_error, FPE_INTDIV,
@@ -311,6 +320,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	    ftrace_int3_handler(regs))
 		return;
 #endif
+	exception_enter(regs);
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
@@ -330,6 +340,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	do_trap(X86_TRAP_BP, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
+	exception_exit(regs);
 }
 
 #ifdef CONFIG_X86_64
@@ -390,6 +401,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	unsigned long dr6;
 	int si_code;
 
+	exception_enter(regs);
+
 	get_debugreg(dr6, 6);
 
 	/* Filter out all the reserved bits which are preset to 1 */
@@ -405,7 +418,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	/* Catch kmemcheck conditions first of all! */
 	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
-		return;
+		goto exit;
 
 	/* DR6 may or may not be cleared by the CPU */
 	set_debugreg(0, 6);
@@ -420,7 +433,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
 							SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto exit;
 
 	/*
 	 * Let others (NMI) know that the debug stack is in use
@@ -436,7 +449,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 					X86_TRAP_DB);
 		preempt_conditional_cli(regs);
 		debug_stack_usage_dec();
-		return;
+		goto exit;
 	}
 
 	/*
@@ -457,7 +470,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	preempt_conditional_cli(regs);
 	debug_stack_usage_dec();
 
-	return;
+exit:
+	exception_exit(regs);
 }
 
 /*
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 76dcd9d..7dde46d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -18,6 +18,7 @@
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
 #include <asm/fixmap.h>			/* VSYSCALL_START		*/
+#include <asm/rcu.h>			/* exception_enter(), ...	*/
 
 /*
  * Page fault error code bits:
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
+	exception_enter(regs);
+	__do_page_fault(regs, error_code);
+	exception_exit(regs);
+}
-- 
1.7.5.4

