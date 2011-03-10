Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1CJWZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:25:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:60960 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab1CJWZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:25:19 -0500
Date: Thu, 10 Mar 2011 22:24:53 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, ssp@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, namhyung@gmail.com,
        ssp@redhat.com
In-Reply-To: <1299584662-24421-1-git-send-email-namhyung@gmail.com>
References: <1299584662-24421-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, dumpstack: Correct stack dump info when frame pointer is available
Message-ID: <tip-074206a787e4dfdc4c290789ab6604c7f9e691ca@git.kernel.org>
Git-Commit-ID: 074206a787e4dfdc4c290789ab6604c7f9e691ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Mar 2011 22:24:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  074206a787e4dfdc4c290789ab6604c7f9e691ca
Gitweb:     http://git.kernel.org/tip/074206a787e4dfdc4c290789ab6604c7f9e691ca
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 8 Mar 2011 20:44:19 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 10 Mar 2011 23:20:30 +0100

x86, dumpstack: Correct stack dump info when frame pointer is available

Current stack dump code scans entire stack and checks each entry for a
pointer to kernel code. If CONFIG_FRAME_POINTER=y it could mark
whether the pointer is valid or not based on value of the frame
pointer. Invalid entries could be preceded by '?' sign.

However this was not going to happen because scan start point was
always higher than the frame pointer so that they could not meet.

Commit 9c0729dc8062 ("x86: Eliminate bp argument from the stack
tracing routines") delayed bp acquisition point, so the bp was
read in lower frame, thus all of the entries were marked invalid.

This patch fixes this by reverting above commit while retaining
stack_frame() helper as suggested by Frederic Weisbecker.
End result looks like below:

before:
[    3.508329] Call Trace:
[    3.508551]  [<ffffffff814f35c9>] ? panic+0x91/0x199
[    3.508662]  [<ffffffff814f3739>] ? printk+0x68/0x6a
[    3.508770]  [<ffffffff81a981b2>] ? mount_block_root+0x257/0x26e
[    3.508876]  [<ffffffff81a9821f>] ? mount_root+0x56/0x5a
[    3.508975]  [<ffffffff81a98393>] ? prepare_namespace+0x170/0x1a9
[    3.509216]  [<ffffffff81a9772b>] ? kernel_init+0x1d2/0x1e2
[    3.509335]  [<ffffffff81003894>] ? kernel_thread_helper+0x4/0x10
[    3.509442]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
[    3.509542]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
[    3.509641]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10

after:
[    3.522991] Call Trace:
[    3.523351]  [<ffffffff814f35b9>] panic+0x91/0x199
[    3.523468]  [<ffffffff814f3729>] ? printk+0x68/0x6a
[    3.523576]  [<ffffffff81a981b2>] mount_block_root+0x257/0x26e
[    3.523681]  [<ffffffff81a9821f>] mount_root+0x56/0x5a
[    3.523780]  [<ffffffff81a98393>] prepare_namespace+0x170/0x1a9
[    3.523885]  [<ffffffff81a9772b>] kernel_init+0x1d2/0x1e2
[    3.523987]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[    3.524228]  [<ffffffff814f6880>] ? restore_args+0x0/0x30
[    3.524345]  [<ffffffff81a97559>] ? kernel_init+0x0/0x1e2
[    3.524445]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Soren Sandmann <ssp@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1299584662-24421-1-git-send-email-namhyung@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/kdebug.h     |    2 +-
 arch/x86/include/asm/stacktrace.h |    6 +++---
 arch/x86/kernel/cpu/perf_event.c  |    2 +-
 arch/x86/kernel/dumpstack.c       |   14 ++++++++------
 arch/x86/kernel/dumpstack_32.c    |   15 ++++++++-------
 arch/x86/kernel/dumpstack_64.c    |   14 +++++++-------
 arch/x86/kernel/process.c         |    2 +-
 arch/x86/kernel/stacktrace.c      |    6 +++---
 8 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index ca242d3..e28ec43 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -27,7 +27,7 @@ extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
 extern void show_registers(struct pt_regs *regs);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
-		       unsigned long *sp);
+		       unsigned long *sp, unsigned long bp);
 extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index 52b5c7e..d7e89c8 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -47,7 +47,7 @@ struct stacktrace_ops {
 };
 
 void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
-		unsigned long *stack,
+		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data);
 
 #ifdef CONFIG_X86_32
@@ -86,11 +86,11 @@ stack_frame(struct task_struct *task, struct pt_regs *regs)
 
 extern void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *stack, char *log_lvl);
+		   unsigned long *stack, unsigned long bp, char *log_lvl);
 
 extern void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, char *log_lvl);
+		   unsigned long *sp, unsigned long bp, char *log_lvl);
 
 extern unsigned int code_bytes;
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9d977a2..d19cdc2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1710,7 +1710,7 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 
 	perf_callchain_store(entry, regs->ip);
 
-	dump_trace(NULL, regs, NULL, &backtrace_ops, entry);
+	dump_trace(NULL, regs, NULL, 0, &backtrace_ops, entry);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index df20723..c330160 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -175,21 +175,21 @@ static const struct stacktrace_ops print_trace_ops = {
 
 void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack, char *log_lvl)
+		unsigned long *stack, unsigned long bp, char *log_lvl)
 {
 	printk("%sCall Trace:\n", log_lvl);
-	dump_trace(task, regs, stack, &print_trace_ops, log_lvl);
+	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
 }
 
 void show_trace(struct task_struct *task, struct pt_regs *regs,
-		unsigned long *stack)
+		unsigned long *stack, unsigned long bp)
 {
-	show_trace_log_lvl(task, regs, stack, "");
+	show_trace_log_lvl(task, regs, stack, bp, "");
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
-	show_stack_log_lvl(task, NULL, sp, "");
+	show_stack_log_lvl(task, NULL, sp, 0, "");
 }
 
 /*
@@ -197,14 +197,16 @@ void show_stack(struct task_struct *task, unsigned long *sp)
  */
 void dump_stack(void)
 {
+	unsigned long bp;
 	unsigned long stack;
 
+	bp = stack_frame(current, NULL);
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	show_trace(NULL, NULL, &stack);
+	show_trace(NULL, NULL, &stack, bp);
 }
 EXPORT_SYMBOL(dump_stack);
 
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 74cc1ed..3b97a80 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -17,12 +17,11 @@
 #include <asm/stacktrace.h>
 
 
-void dump_trace(struct task_struct *task,
-		struct pt_regs *regs, unsigned long *stack,
+void dump_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
 {
 	int graph = 0;
-	unsigned long bp;
 
 	if (!task)
 		task = current;
@@ -35,7 +34,9 @@ void dump_trace(struct task_struct *task,
 			stack = (unsigned long *)task->thread.sp;
 	}
 
-	bp = stack_frame(task, regs);
+	if (!bp)
+		bp = stack_frame(task, regs);
+
 	for (;;) {
 		struct thread_info *context;
 
@@ -55,7 +56,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, char *log_lvl)
+		   unsigned long *sp, unsigned long bp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -77,7 +78,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		touch_nmi_watchdog();
 	}
 	printk(KERN_CONT "\n");
-	show_trace_log_lvl(task, regs, sp, log_lvl);
+	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
 
@@ -102,7 +103,7 @@ void show_registers(struct pt_regs *regs)
 		u8 *ip;
 
 		printk(KERN_EMERG "Stack:\n");
-		show_stack_log_lvl(NULL, regs, &regs->sp, KERN_EMERG);
+		show_stack_log_lvl(NULL, regs, &regs->sp, 0, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index a6b6fcf..e71c98d 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -139,8 +139,8 @@ fixup_bp_irq_link(unsigned long bp, unsigned long *stack,
  * severe exception (double fault, nmi, stack fault, debug, mce) hardware stack
  */
 
-void dump_trace(struct task_struct *task,
-		struct pt_regs *regs, unsigned long *stack,
+void dump_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
@@ -150,7 +150,6 @@ void dump_trace(struct task_struct *task,
 	struct thread_info *tinfo;
 	int graph = 0;
 	unsigned long dummy;
-	unsigned long bp;
 
 	if (!task)
 		task = current;
@@ -161,7 +160,8 @@ void dump_trace(struct task_struct *task,
 			stack = (unsigned long *)task->thread.sp;
 	}
 
-	bp = stack_frame(task, regs);
+	if (!bp)
+		bp = stack_frame(task, regs);
 	/*
 	 * Print function call entries in all stacks, starting at the
 	 * current stack address. If the stacks consist of nested
@@ -225,7 +225,7 @@ EXPORT_SYMBOL(dump_trace);
 
 void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, char *log_lvl)
+		   unsigned long *sp, unsigned long bp, char *log_lvl)
 {
 	unsigned long *irq_stack_end;
 	unsigned long *irq_stack;
@@ -269,7 +269,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	preempt_enable();
 
 	printk(KERN_CONT "\n");
-	show_trace_log_lvl(task, regs, sp, log_lvl);
+	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
 void show_registers(struct pt_regs *regs)
@@ -298,7 +298,7 @@ void show_registers(struct pt_regs *regs)
 
 		printk(KERN_EMERG "Stack:\n");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
-				   KERN_EMERG);
+				   0, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ff45541..f4c6cc4 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -87,7 +87,7 @@ void exit_thread(void)
 void show_regs(struct pt_regs *regs)
 {
 	show_registers(regs);
-	show_trace(NULL, regs, (unsigned long *)kernel_stack_pointer(regs));
+	show_trace(NULL, regs, (unsigned long *)kernel_stack_pointer(regs), 0);
 }
 
 void show_regs_common(void)
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 938c8e1..6515733 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -73,7 +73,7 @@ static const struct stacktrace_ops save_stack_ops_nosched = {
  */
 void save_stack_trace(struct stack_trace *trace)
 {
-	dump_trace(current, NULL, NULL, &save_stack_ops, trace);
+	dump_trace(current, NULL, NULL, 0, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
@@ -81,14 +81,14 @@ EXPORT_SYMBOL_GPL(save_stack_trace);
 
 void save_stack_trace_regs(struct stack_trace *trace, struct pt_regs *regs)
 {
-	dump_trace(current, regs, NULL, &save_stack_ops, trace);
+	dump_trace(current, regs, NULL, 0, &save_stack_ops, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 
 void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 {
-	dump_trace(tsk, NULL, NULL, &save_stack_ops_nosched, trace);
+	dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
