Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366Ab0KRUqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:46:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:54083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759399Ab0KRUqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:46:10 -0500
Date: Thu, 18 Nov 2010 20:45:42 GMT
From: tip-bot for Soeren Sandmann Pedersen <sandmann@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, ssp@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, sandmann@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        sandmann@redhat.com, tglx@linutronix.de, ssp@redhat.com
In-Reply-To: <m3oc9rop28.fsf@dhcp-100-3-82.bos.redhat.com>>
References: <m3oc9rop28.fsf@dhcp-100-3-82.bos.redhat.com>>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Eliminate bp argument from the stack tracing routines
Message-ID: <tip-9c0729dc8062bed96189bd14ac6d4920f3958743@git.kernel.org>
Git-Commit-ID: 9c0729dc8062bed96189bd14ac6d4920f3958743
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 20:45:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c0729dc8062bed96189bd14ac6d4920f3958743
Gitweb:     http://git.kernel.org/tip/9c0729dc8062bed96189bd14ac6d4920f3958743
Author:     Soeren Sandmann Pedersen <sandmann@redhat.com>
AuthorDate: Fri, 5 Nov 2010 05:59:39 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 18 Nov 2010 14:37:34 +0100

x86: Eliminate bp argument from the stack tracing routines

The various stack tracing routines take a 'bp' argument in which the
caller is supposed to provide the base pointer to use, or 0 if doesn't
have one. Since bp is garbage whenever CONFIG_FRAME_POINTER is not
defined, this means all callers in principle should either always pass
0, or be conditional on CONFIG_FRAME_POINTER.

However, there are only really three use cases for stack tracing:

(a) Trace the current task, including IRQ stack if any
(b) Trace the current task, but skip IRQ stack
(c) Trace some other task

In all cases, if CONFIG_FRAME_POINTER is not defined, bp should just
be 0.  If it _is_ defined, then

- in case (a) bp should be gotten directly from the CPU's register, so
  the caller should pass NULL for regs,

- in case (b) the caller should should pass the IRQ registers to
  dump_trace(),

- in case (c) bp should be gotten from the top of the task's stack, so
  the caller should pass NULL for regs.

Hence, the bp argument is not necessary because the combination of
task and regs is sufficient to determine an appropriate value for bp.

This patch introduces a new inline function stack_frame(task, regs)
that computes the desired bp. This function is then called from the
two versions of dump_stack().

Signed-off-by: Soren Sandmann <ssp@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
LKML-Reference: <m3oc9rop28.fsf@dhcp-100-3-82.bos.redhat.com>>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/kdebug.h     |    2 +-
 arch/x86/include/asm/stacktrace.h |   33 ++++++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 arch/x86/kernel/dumpstack.c       |   12 ++++++------
 arch/x86/kernel/dumpstack_32.c    |   25 +++++++------------------
 arch/x86/kernel/dumpstack_64.c    |   24 +++++++-----------------
 arch/x86/kernel/process.c         |    3 +--
 arch/x86/kernel/stacktrace.c      |    8 ++++----
 arch/x86/mm/kmemcheck/error.c     |    2 +-
 arch/x86/oprofile/backtrace.c     |    2 +-
 include/linux/stacktrace.h        |    4 +++-
 11 files changed, 62 insertions(+), 55 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index 5bdfca8..f23eb25 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -28,7 +28,7 @@ extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_registers(struct pt_regs *regs);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
-		       unsigned long *sp, unsigned long bp);
+		       unsigned long *sp);
 extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 2b16a2a..52b5c7e 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -7,6 +7,7 @@
 #define _ASM_X86_STACKTRACE_H
 
 #include <linux/uaccess.h>
+#include <linux/ptrace.h>
 
 extern int kstack_depth_to_print;
 
@@ -46,7 +47,7 @@ struct stacktrace_ops {
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp,
+		unsigned long *stack,
 		const struct stacktrace_ops *ops, void *data);
 
 #ifdef CONFIG_X86_32
@@ -57,13 +58,39 @@ void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
 #define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
 #endif
 
+#ifdef CONFIG_FRAME_POINTER
+static inline unsigned long
+stack_frame(struct task_struct *task, struct pt_regs *regs)
+{
+	unsigned long bp;
+
+	if (regs)
+		return regs->bp;
+
+	if (task == current) {
+		/* Grab bp right from our regs */
+		get_bp(bp);
+		return bp;
+	}
+
+	/* bp is the last reg pushed by switch_to */
+	return *(unsigned long *)task->thread.sp;
+}
+#else
+static inline unsigned long
+stack_frame(struct task_struct *task, struct pt_regs *regs)
+{
+	return 0;
+}
+#endif
+
 extern void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp, char *log_lvl);
+		   unsigned long *stack, char *log_lvl);
 
 extern void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *sp, unsigned long bp, char *log_lvl);
+		   unsigned long *sp, char *log_lvl);
 
 extern unsigned int code_bytes;
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed63101..461a85d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1666,7 +1666,7 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 
 	perf_callchain_store(entry, regs->ip);
 
-	dump_trace(NULL, regs, NULL, regs->bp, &backtrace_ops, entry);
+	dump_trace(NULL, regs, NULL, &backtrace_ops, entry);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 6e8752c..8474c99 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -175,21 +175,21 @@ static const struct stacktrace_ops print_trace_ops = {
 
 void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp, char *log_lvl)
+		unsigned long *stack, char *log_lvl)
 {
 	printk("%sCall Trace:\n", log_lvl);
-	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
+	dump_trace(task, regs, stack, &print_trace_ops, log_lvl);
 }
 
 void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp)
+		unsigned long *stack)
 {
-	show_trace_log_lvl(task, regs, stack, bp, "");
+	show_trace_log_lvl(task, regs, stack, "");
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
-	show_stack_log_lvl(task, NULL, sp, 0, "");
+	show_stack_log_lvl(task, NULL, sp, "");
 }
 
 /*
@@ -210,7 +210,7 @@ void dump_stack(void)
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	show_trace(NULL, NULL, &stack, bp);
+	show_trace(NULL, NULL, &stack);
 }
 EXPORT_SYMBOL(dump_stack);
 
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 1bc7f75..74cc1ed 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -17,11 +17,12 @@
 #include <asm/stacktrace.h>
 
 
-void dump_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp,
+void dump_trace(struct task_struct *task,
+		struct pt_regs *regs, unsigned long *stack,
 		const struct stacktrace_ops *ops, void *data)
 {
 	int graph = 0;
+	unsigned long bp;
 
 	if (!task)
 		task = current;
@@ -34,18 +35,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			stack = (unsigned long *)task->thread.sp;
 	}
 
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp) {
-		if (task == current) {
-			/* Grab bp right from our regs */
-			get_bp(bp);
-		} else {
-			/* bp is the last reg pushed by switch_to */
-			bp = *(unsigned long *) task->thread.sp;
-		}
-	}
-#endif
-
+	bp = stack_frame(task, regs);
 	for (;;) {
 		struct thread_info *context;
 
@@ -65,7 +55,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, unsigned long bp, char *log_lvl)
+		   unsigned long *sp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -87,7 +77,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		touch_nmi_watchdog();
 	}
 	printk(KERN_CONT "\n");
-	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+	show_trace_log_lvl(task, regs, sp, log_lvl);
 }
 
 
@@ -112,8 +102,7 @@ void show_registers(struct pt_regs *regs)
 		u8 *ip;
 
 		printk(KERN_EMERG "Stack:\n");
-		show_stack_log_lvl(NULL, regs, &regs->sp,
-				0, KERN_EMERG);
+		show_stack_log_lvl(NULL, regs, &regs->sp, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 6a34048..6410133 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -139,8 +139,8 @@ fixup_bp_irq_link(unsigned long bp, unsigned long *stack,
  * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
  */
 
-void dump_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp,
+void dump_trace(struct task_struct *task,
+		struct pt_regs *regs, unsigned long *stack,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
@@ -149,6 +149,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	unsigned used = 0;
 	struct thread_info *tinfo;
 	int graph = 0;
+	unsigned long bp;
 
 	if (!task)
 		task = current;
@@ -160,18 +161,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			stack = (unsigned long *)task->thread.sp;
 	}
 
-#ifdef CONFIG_FRAME_POINTER
-	if (!bp) {
-		if (task == current) {
-			/* Grab bp right from our regs */
-			get_bp(bp);
-		} else {
-			/* bp is the last reg pushed by switch_to */
-			bp = *(unsigned long *) task->thread.sp;
-		}
-	}
-#endif
-
+	bp = stack_frame(task, regs);
 	/*
 	 * Print function call entries in all stacks, starting at the
 	 * current stack address. If the stacks consist of nested
@@ -235,7 +225,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, unsigned long bp, char *log_lvl)
+		   unsigned long *sp, char *log_lvl)
 {
 	unsigned long *irq_stack_end;
 	unsigned long *irq_stack;
@@ -279,7 +269,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	preempt_enable();
 
 	printk(KERN_CONT "\n");
-	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+	show_trace_log_lvl(task, regs, sp, log_lvl);
 }
 
 void show_registers(struct pt_regs *regs)
@@ -308,7 +298,7 @@ void show_registers(struct pt_regs *regs)
 
 		printk(KERN_EMERG "Stack:\n");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
-				regs->bp, KERN_EMERG);
+				   KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 57d1868..96ed1aa 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -91,8 +91,7 @@ void exit_thread(void)
 void show_regs(struct pt_regs *regs)
 {
 	show_registers(regs);
-	show_trace(NULL, regs, (unsigned long *)kernel_stack_pointer(regs),
-		   regs->bp);
+	show_trace(NULL, regs, (unsigned long *)kernel_stack_pointer(regs));
 }
 
 void show_regs_common(void)
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index b53c525..938c8e1 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -73,22 +73,22 @@ static const struct stacktrace_ops save_stack_ops_nosched = {
  */
 void save_stack_trace(struct stack_trace *trace)
 {
-	dump_trace(current, NULL, NULL, 0, &save_stack_ops, trace);
+	dump_trace(current, NULL, NULL, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 EXPORT_SYMBOL_GPL(save_stack_trace);
 
-void save_stack_trace_bp(struct stack_trace *trace, unsigned long bp)
+void save_stack_trace_regs(struct stack_trace *trace, struct pt_regs *regs)
 {
-	dump_trace(current, NULL, NULL, bp, &save_stack_ops, trace);
+	dump_trace(current, regs, NULL, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
-	dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
+	dump_trace(tsk, NULL, NULL, &save_stack_ops_nosched, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
diff --git a/arch/x86/mm/kmemcheck/error.c b/arch/x86/mm/kmemcheck/error.c
index af3b6c8..704a37c 100644
--- a/arch/x86/mm/kmemcheck/error.c
+++ b/arch/x86/mm/kmemcheck/error.c
@@ -185,7 +185,7 @@ void kmemcheck_error_save(enum kmemcheck_shadow state,
 	e->trace.entries = e->trace_entries;
 	e->trace.max_entries = ARRAY_SIZE(e->trace_entries);
 	e->trace.skip = 0;
-	save_stack_trace_bp(&e->trace, regs->bp);
+	save_stack_trace_regs(&e->trace, regs);
 
 	/* Round address down to nearest 16 bytes */
 	shadow_copy = kmemcheck_shadow_lookup(address
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 2d49d4e..72cbec1 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -126,7 +126,7 @@ x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 	if (!user_mode_vm(regs)) {
 		unsigned long stack = kernel_stack_pointer(regs);
 		if (depth)
-			dump_trace(NULL, regs, (unsigned long *)stack, 0,
+			dump_trace(NULL, regs, (unsigned long *)stack,
 				   &backtrace_ops, &depth);
 		return;
 	}
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 51efbef..25310f1 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -2,6 +2,7 @@
 #define __LINUX_STACKTRACE_H
 
 struct task_struct;
+struct pt_regs;
 
 #ifdef CONFIG_STACKTRACE
 struct task_struct;
@@ -13,7 +14,8 @@ struct stack_trace {
 };
 
 extern void save_stack_trace(struct stack_trace *trace);
-extern void save_stack_trace_bp(struct stack_trace *trace, unsigned long bp);
+extern void save_stack_trace_regs(struct stack_trace *trace,
+				  struct pt_regs *regs);
 extern void save_stack_trace_tsk(struct task_struct *tsk,
 				struct stack_trace *trace);
 
