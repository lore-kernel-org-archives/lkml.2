Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab0LTPY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:24:59 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:54867 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab0LTPY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OXdPJL1VmGir2QWVgC+7Xs7SyJMngaWVTJU6Y6QxO0yLGhfvN693Ys0tlItXQ9AqAu
         UGetlrQf1MVSlYKk+xCraEtQryqFK9zqAJpBpburuvLF0IpvKCwwHNthBS5c96a9HKns
         D7rYufejR5WRKBZb0OiGzukGX6opWJunB2Qs8=
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
Subject: [RFC PATCH 11/15] x86: Nohz task support
Date: Mon, 20 Dec 2010 16:24:18 +0100
Message-Id: <1292858662-5650-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the thread flag, syscalls and exception hooks for
nohz task support.

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
 arch/x86/Kconfig                   |    1 +
 arch/x86/include/asm/thread_info.h |   10 +++++++---
 arch/x86/kernel/ptrace.c           |   10 ++++++++++
 arch/x86/kernel/traps.c            |   22 +++++++++++++++-------
 arch/x86/mm/fault.c                |   13 +++++++++++--
 5 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e330da2..37f59f2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -65,6 +65,7 @@ config X86
 	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
+	select HAVE_NO_HZ_TASK
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index f0b6e5d..eb6784c 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -87,6 +87,7 @@ struct thread_info {
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
+#define TIF_NOHZ		19	/* in nohz userspace mode */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
@@ -110,6 +111,7 @@ struct thread_info {
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
+#define _TIF_NOHZ		(1 << TIF_NOHZ)
 #define _TIF_DEBUG		(1 << TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
@@ -121,12 +123,13 @@ struct thread_info {
 /* work to do in syscall_trace_enter() */
 #define _TIF_WORK_SYSCALL_ENTRY	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
-	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT)
+	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT |	\
+	 _TIF_NOHZ)
 
 /* work to do in syscall_trace_leave() */
 #define _TIF_WORK_SYSCALL_EXIT	\
 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP |	\
-	 _TIF_SYSCALL_TRACEPOINT)
+	 _TIF_SYSCALL_TRACEPOINT | _TIF_NOHZ)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK							\
@@ -136,7 +139,8 @@ struct thread_info {
 
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK						\
-	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT)
+	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT |	\
+	_TIF_NOHZ)
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 45892dc..b8b1c38 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/signal.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -1351,6 +1352,9 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
+	/* Notify nohz task syscall early so the rest can use rcu */
+	tick_nohz_task_enter_kernel();
+
 	/*
 	 * If we stepped into a sysenter/syscall insn, it trapped in
 	 * kernel mode; do_debug() cleared TF and set TIF_SINGLESTEP.
@@ -1412,4 +1416,10 @@ asmregparm void syscall_trace_leave(struct pt_regs *regs)
 			!test_thread_flag(TIF_SYSCALL_EMU);
 	if (step || test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, step);
+
+	/*
+	 * Notify nohz task exit syscall at last so the rest can
+	 * use rcu.
+	 */
+	tick_nohz_task_exit_kernel();
 }
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index cb838ca..b531c52 100644
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
@@ -459,24 +460,28 @@ void restart_nmi(void)
 /* May run on IST stack. */
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
+	tick_nohz_task_enter_exception(regs);
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
+	tick_nohz_task_exit_exception(regs);
 }
 
 #ifdef CONFIG_X86_64
@@ -537,6 +542,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	unsigned long dr6;
 	int si_code;
 
+	tick_nohz_task_enter_exception(regs);
+
 	get_debugreg(dr6, 6);
 
 	/* Filter out all the reserved bits which are preset to 1 */
@@ -552,7 +559,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	/* Catch kmemcheck conditions first of all! */
 	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
-		return;
+		goto exit;
 
 	/* DR6 may or may not be cleared by the CPU */
 	set_debugreg(0, 6);
@@ -567,7 +574,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 
 	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
 							SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto exit;
 
 	/* It's safe to allow irq's after DR6 has been saved */
 	preempt_conditional_sti(regs);
@@ -576,7 +583,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
 				error_code, 1);
 		preempt_conditional_cli(regs);
-		return;
+		goto exit;
 	}
 
 	/*
@@ -596,7 +603,8 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
 
-	return;
+exit:
+	tick_nohz_task_exit_exception(regs);
 }
 
 /*
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7d90ceb..2b23b22 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -12,6 +12,7 @@
 #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
 #include <linux/perf_event.h>		/* perf_sw_event		*/
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
+#include <linux/tick.h>
 
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
@@ -949,8 +950,8 @@ static int fault_in_kernel_space(unsigned long address)
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
@@ -1158,3 +1159,11 @@ good_area:
 
 	up_read(&mm->mmap_sem);
 }
+
+dotraplinkage void __kprobes
+do_page_fault(struct pt_regs *regs, unsigned long error_code)
+{
+	tick_nohz_task_enter_exception(regs);
+	__do_page_fault(regs, error_code);
+	tick_nohz_task_exit_exception(regs);
+}
-- 
1.7.3.2

