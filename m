Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0KELRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 07:17:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab0KELRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 07:17:07 -0400
From: =?UTF-8?q?S=C3=B8ren=20Sandmann=20Pedersen?= <ssp@redhat.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?S=C3=B8ren=20Sandmann=20Pedersen?= <ssp@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] x86: Eliminate bp argument from the stack tracing routines
Date: Fri,  5 Nov 2010 07:14:34 -0400
Message-Id: <1288955674-2744-2-git-send-email-ssp@redhat.com>
In-Reply-To: <ye8ljj3mlj5.fsf@camel16.daimi.au.dk>
References: <ye8ljj3mlj5.fsf@camel16.daimi.au.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various stack tracing routines take a 'bp' argument in which the
caller is supposed to provide the base pointer to use, or 0 if doesn't
have one. Since bp is garbage whenever CONFIG_FRAME_POINTER is not
defined, this means all callers in principle should either always pass
0, or be conditional on CONFIG_FRAME_POINTER.

However, there are only really three use cases for stack tracing and
in all cases, dump_trace can figure out the desired bp for itself.

(a) Trace the current task, including IRQ stack if any
(b) Trace the current task, but skip IRQ stack
(c) Trace some other task

In all cases, if CONFIG_FRAME_POINTER is not defined, just use 0 for
bp.  If it _is_ defined, then

- in case (a) bp should be gotten directly from the CPU's register, so
  the caller should pass NULL for regs,

- in case (b) the caller should should pass the IRQ registers to
  dump_trace(),

- in case (c) bp should be gotten from the top of the task's stack, so
  the caller should pass NULL for regs.

Hence, the bp argument is not necessary because the combination of
task and regs is sufficient to determine an appropriate value for bp.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Soren Sandmann <ssp@redhat.com>
---
 arch/x86/include/asm/kdebug.h     |    2 +-
 arch/x86/include/asm/stacktrace.h |    6 +++---
 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 arch/x86/kernel/dumpstack.c       |   12 ++++++------
 arch/x86/kernel/dumpstack_32.c    |   18 +++++++++++-------
 arch/x86/kernel/dumpstack_64.c    |   17 +++++++++++------
 arch/x86/kernel/process.c         |    3 +--
 arch/x86/kernel/stacktrace.c      |    8 ++++----
 arch/x86/mm/kmemcheck/error.c     |    2 +-
 arch/x86/oprofile/backtrace.c     |    2 +-
 include/linux/stacktrace.h        |    4 +++-
 11 files changed, 43 insertions(+), 33 deletions(-)

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
index 2b16a2a..f918c82 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -46,7 +46,7 @@ struct stacktrace_ops {
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
-		unsigned long *stack, unsigned long bp,
+		unsigned long *stack,
 		const struct stacktrace_ops *ops, void *data);
 
 #ifdef CONFIG_X86_32
@@ -59,11 +59,11 @@ void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
 
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
index 1bc7f75..6d92b37 100644
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
@@ -35,7 +36,9 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	}
 
 #ifdef CONFIG_FRAME_POINTER
-	if (!bp) {
+	if (regs) {
+		bp = regs->bp;
+	} else {
 		if (task == current) {
 			/* Grab bp right from our regs */
 			get_bp(bp);
@@ -44,6 +47,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			bp = *(unsigned long *) task->thread.sp;
 		}
 	}
+#else
+	bp = 0;
 #endif
 
 	for (;;) {
@@ -65,7 +70,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, unsigned long bp, char *log_lvl)
+		   unsigned long *sp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -87,7 +92,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		touch_nmi_watchdog();
 	}
 	printk(KERN_CONT "\n");
-	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+	show_trace_log_lvl(task, regs, sp, log_lvl);
 }
 
 
@@ -112,8 +117,7 @@ void show_registers(struct pt_regs *regs)
 		u8 *ip;
 
 		printk(KERN_EMERG "Stack:\n");
-		show_stack_log_lvl(NULL, regs, &regs->sp,
-				0, KERN_EMERG);
+		show_stack_log_lvl(NULL, regs, &regs->sp, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 6a34048..d00afc1 100644
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
@@ -161,7 +162,9 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	}
 
 #ifdef CONFIG_FRAME_POINTER
-	if (!bp) {
+	if (regs) {
+		bp = regs->bp;
+	} else {
 		if (task == current) {
 			/* Grab bp right from our regs */
 			get_bp(bp);
@@ -170,6 +173,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			bp = *(unsigned long *) task->thread.sp;
 		}
 	}
+#else
+	bp = 0;
 #endif
 
 	/*
@@ -235,7 +240,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, unsigned long bp, char *log_lvl)
+		   unsigned long *sp, char *log_lvl)
 {
 	unsigned long *irq_stack_end;
 	unsigned long *irq_stack;
@@ -279,7 +284,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	preempt_enable();
 
 	printk(KERN_CONT "\n");
-	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
+	show_trace_log_lvl(task, regs, sp, log_lvl);
 }
 
 void show_registers(struct pt_regs *regs)
@@ -308,7 +313,7 @@ void show_registers(struct pt_regs *regs)
 
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
 
-- 
1.7.3.1

