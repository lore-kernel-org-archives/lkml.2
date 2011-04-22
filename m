Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1DVXEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:04:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21689 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab1DVXEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:04:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=D/cy6O9KAyvk45e65xPHLLbWoHMENRI1tQXnJlV/+xl1kO2HqpNavzy1XQLaNXG0G
	KfOVO0wMV+orXwBr0gFvA==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jiaying Zhang <jiayingz@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 1/2] trace: Add trap entry/exit tracepoints
Date: Fri, 22 Apr 2011 16:03:57 -0700
Message-Id: <1303513438-26519-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiaying Zhang <jiayingz@google.com>

Add an enum for trap definitions and add entry/exit tracepoints for
traps in the system.

$ echo 1 > debug/tracing/events/trap/enable
run gdb to genrate some trap events
$ cat debug/tracing/trace
          <...>-13619 [003]   917.726602: trap_entry: number=3
          <...>-13619 [003]   917.726612: trap_exit: number=3
          <...>-13619 [003]   917.747263: trap_entry: number=1
          <...>-13619 [003]   917.747272: trap_exit: number=1
          <...>-13619 [003]   917.747567: trap_entry: number=3
          <...>-13619 [003]   917.747570: trap_exit: number=3
          <...>-13619 [003]   917.748101: trap_entry: number=1
          <...>-13619 [003]   917.748103: trap_exit: number=1

$ echo 1 > tracing_enabled; ~/trap pagefault; echo 0 > tracing_enabled
$ cat trace | grep "trap-" | grep number=14 | head
       trap-12528 [003]  1159.755792: trap_entry: number=14
       trap-12528 [003]  1159.755801: trap_entry: number=14
       trap-12528 [003]  1159.755804: trap_entry: number=14
       trap-12528 [003]  1159.755807: trap_entry: number=14
       trap-12528 [003]  1159.755810: trap_entry: number=14
       trap-12528 [003]  1159.755817: trap_entry: number=14
       trap-12528 [003]  1159.755819: trap_entry: number=14
       trap-12528 [003]  1159.755821: trap_entry: number=14
       trap-12528 [003]  1159.755824: trap_entry: number=14
       trap-12528 [003]  1159.755826: trap_entry: number=14
$ cat trace | grep "trap-" | grep number=7 | head
       trap-12528 [003]  1159.756283: trap_entry: number=7
       trap-12529 [003]  1159.757427: trap_entry: number=7
       trap-12530 [003]  1159.758277: trap_entry: number=7
       trap-12531 [003]  1159.759172: trap_entry: number=7
       trap-12532 [003]  1159.768643: trap_entry: number=7
       trap-12533 [003]  1159.778195: trap_entry: number=7
       trap-15026 [001]  1557.877722: trap_entry: number=7
       trap-15253 [001]  1621.395067: trap_entry: number=7

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 arch/x86/kernel/ptrace.c    |    4 +++
 arch/x86/kernel/traps.c     |   16 ++++++++++++++
 arch/x86/mm/fault.c         |   13 ++++++++++-
 include/trace/events/trap.h |   47 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/trap.h

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 45892dc..d788752 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -22,6 +22,8 @@
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
 
+#include <trace/events/trap.h>
+
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -1330,8 +1332,10 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 	struct siginfo info;
 
 	fill_sigtrap_info(tsk, regs, error_code, si_code, &info);
+	trace_trap_entry(tsk->thread.trap_no);
 	/* Send us the fake SIGTRAP */
 	force_sig_info(SIGTRAP, &info, tsk);
+	trace_trap_exit(tsk->thread.trap_no);
 }
 
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4857ff6..d450349 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -33,6 +33,9 @@
 #include <linux/io.h>
 #include <trace/events/irq.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/trap.h>
+
 #ifdef CONFIG_EISA
 #include <linux/ioport.h>
 #include <linux/eisa.h>
@@ -123,6 +126,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 {
 	struct task_struct *tsk = current;
 
+	trace_trap_entry(trapnr);
 #ifdef CONFIG_X86_32
 	if (regs->flags & X86_VM_MASK) {
 		/*
@@ -169,6 +173,7 @@ trap_signal:
 		force_sig_info(signr, info, tsk);
 	else
 		force_sig(signr, tsk);
+	trace_trap_exit(trapnr);
 	return;
 
 kernel_trap:
@@ -177,6 +182,7 @@ kernel_trap:
 		tsk->thread.trap_no = trapnr;
 		die(str, regs, error_code);
 	}
+	trace_trap_exit(trapnr);
 	return;
 
 #ifdef CONFIG_X86_32
@@ -184,6 +190,7 @@ vm86_trap:
 	if (handle_vm86_trap((struct kernel_vm86_regs *) regs,
 						error_code, trapnr))
 		goto trap_signal;
+	trace_trap_exit(trapnr);
 	return;
 #endif
 }
@@ -286,7 +293,9 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		printk("\n");
 	}
 
+	trace_trap_entry(tsk->thread.trap_no);
 	force_sig(SIGSEGV, tsk);
+	trace_trap_exit(tsk->thread.trap_no);
 	return;
 
 #ifdef CONFIG_X86_32
@@ -683,7 +692,9 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 		 */
 		return;		/* Spurious trap, no error */
 	}
+	trace_trap_entry(task->thread.trap_no);
 	force_sig_info(SIGFPE, &info, task);
+	trace_trap_exit(task->thread.trap_no);
 }
 
 dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
@@ -704,11 +715,13 @@ do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 dotraplinkage void
 do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 {
+	trace_trap_entry(15);
 	conditional_sti(regs);
 #if 0
 	/* No need to warn about this any longer. */
 	printk(KERN_INFO "Ignoring P6 Local APIC Spurious Interrupt Bug...\n");
 #endif
+	trace_trap_exit(15);
 }
 
 asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
@@ -780,6 +793,7 @@ EXPORT_SYMBOL_GPL(math_state_restore);
 dotraplinkage void __kprobes
 do_device_not_available(struct pt_regs *regs, long error_code)
 {
+	trace_trap_entry(7);
 #ifdef CONFIG_MATH_EMULATION
 	if (read_cr0() & X86_CR0_EM) {
 		struct math_emu_info info = { };
@@ -788,6 +802,7 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 
 		info.regs = regs;
 		math_emulate(&info);
+		trace_trap_exit(7);
 		return;
 	}
 #endif
@@ -795,6 +810,7 @@ do_device_not_available(struct pt_regs *regs, long error_code)
 #ifdef CONFIG_X86_32
 	conditional_sti(regs);
 #endif
+	trace_trap_exit(7);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 20e3f87..55bdd31 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -11,6 +11,7 @@
 #include <linux/kprobes.h>		/* __kprobes, ...		*/
 #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
 #include <linux/perf_event.h>		/* perf_sw_event		*/
+#include <trace/events/trap.h>		/* trap trace events		*/
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
 
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
@@ -955,8 +956,8 @@ static int fault_in_kernel_space(unsigned long address)
  * and the problem, and then passes it off to one of the appropriate
  * routines.
  */
-dotraplinkage void __kprobes
-do_page_fault(struct pt_regs *regs, unsigned long error_code)
+static __always_inline void
+__do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
@@ -1164,3 +1165,11 @@ good_area:
 
 	up_read(&mm->mmap_sem);
 }
+
+dotraplinkage void __kprobes
+do_page_fault(struct pt_regs *regs, unsigned long error_code)
+{
+	trace_trap_entry(14);
+	__do_page_fault(regs, error_code);
+	trace_trap_exit(14);
+}
diff --git a/include/trace/events/trap.h b/include/trace/events/trap.h
new file mode 100644
index 0000000..1519b62
--- /dev/null
+++ b/include/trace/events/trap.h
@@ -0,0 +1,47 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM trap
+
+#if !defined(_TRACE_TRAP_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TRAP_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(trap_entry,
+
+	TP_PROTO(int id),
+
+	TP_ARGS(id),
+
+	TP_STRUCT__entry(
+		__field(	int,	id	)
+	),
+
+	TP_fast_assign(
+		__entry->id = id;
+	),
+
+	TP_printk("number=%d", __entry->id)
+);
+
+TRACE_EVENT(trap_exit,
+
+	TP_PROTO(int id),
+
+	TP_ARGS(id),
+
+	TP_STRUCT__entry(
+		__field(	int,	id	)
+	),
+
+	TP_fast_assign(
+		__entry->id = id;
+	),
+
+	TP_printk("number=%d", __entry->id)
+);
+
+#endif /* _TRACE_TRAP_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
-- 
1.7.3.1

