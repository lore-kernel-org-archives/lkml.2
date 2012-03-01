Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab2CAXES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 18:04:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab2CAXEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 18:04:16 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=yI9-BmeOcKgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=Na1Fp-Us39FuZ5W3R_EA:9 a=GggXKpsbeSOzKrpV4vgA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330643053.25686.244.camel@gandalf.stny.rr.com>
Subject: [PATCH] tracing: Track preempt disabling
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 01 Mar 2012 18:04:13 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I've been maintaining your PREEMPT_TRACE patch from the old latency
tracer for a long time. It some how was dropped from the -rt patchset
that Thomas maintains. Recently it came in very handy debugging some of
the hotplug issues that I was dealing with in the -rt patch, and I was
thinking, why isn't this in mainline?

I'm not the author of it, but I have modified it to keep it working all
these years, and even updated some of the documentation/comments. But it
is your patch, and I was wondering if you would please add it to your
tree for 3.4 merge window. Feel free to modify it, if there's something
you don't like about it. Like I said, it is your patch ;-)

Thanks,

-- Steve


From: Ingo Molnar <mingo@elte.hu>

tracing: Track preempt disabling

Add a new config PREEMPT_TRACE that tracks when preemption is disabled
and enabled. This is useful for debugging scheduling while atomic bugs
because it is not always obvious where preemption was last disabled.

If a function disabled preemption but never enabled it, the task can
later get a warning when it schedules out, as preemption is still
disabled. This feature, when enabled, will show where the task had
disabled preemption.

Added some comments and forward ported from the old Real-Time patch
latency tracer by Steven Rostedt.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>

---
 arch/arm/kernel/traps.c      |    1 +
 arch/x86/kernel/dumpstack.c  |    1 +
 include/linux/preempt.h      |    3 ++-
 include/linux/sched.h        |   11 +++++++++++
 kernel/sched.c               |   17 +++++++++++++++--
 kernel/trace/Kconfig         |    8 ++++++++
 kernel/trace/Makefile        |    2 ++
 kernel/trace/preempt-trace.c |   30 ++++++++++++++++++++++++++++++
 8 files changed, 70 insertions(+), 3 deletions(-)

Index: linux-trace.git/arch/arm/kernel/traps.c
===================================================================
--- linux-trace.git.orig/arch/arm/kernel/traps.c
+++ linux-trace.git/arch/arm/kernel/traps.c
@@ -422,6 +422,7 @@ asmlinkage void do_unexp_fiq (struct pt_
 {
 	printk("Hmm.  Unexpected FIQ received, but trying to continue\n");
 	printk("You may have a hardware problem...\n");
+	print_preempt_trace(current);
 }
 
 /*
Index: linux-trace.git/include/linux/preempt.h
===================================================================
--- linux-trace.git.orig/include/linux/preempt.h
+++ linux-trace.git/include/linux/preempt.h
@@ -10,7 +10,8 @@
 #include <linux/linkage.h>
 #include <linux/list.h>
 
-#if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
+#if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER) || \
+	defined(CONFIG_PREEMPT_TRACE)
   extern void add_preempt_count(int val);
   extern void sub_preempt_count(int val);
 #else
Index: linux-trace.git/include/linux/sched.h
===================================================================
--- linux-trace.git.orig/include/linux/sched.h
+++ linux-trace.git/include/linux/sched.h
@@ -1461,6 +1461,14 @@ struct task_struct {
 	int softirqs_enabled;
 	int softirq_context;
 #endif
+
+#define MAX_PREEMPT_TRACE 25
+#define MAX_LOCK_STACK	MAX_PREEMPT_TRACE
+#ifdef CONFIG_PREEMPT_TRACE
+	unsigned long preempt_trace_eip[MAX_PREEMPT_TRACE];
+	unsigned long preempt_trace_parent_eip[MAX_PREEMPT_TRACE];
+#endif
+
 #ifdef CONFIG_LOCKDEP
 # define MAX_LOCK_DEPTH 48UL
 	u64 curr_chain_key;
@@ -2782,6 +2790,12 @@ static inline unsigned long rlimit_max(u
 	return task_rlimit_max(current, limit);
 }
 
+#ifdef CONFIG_PREEMPT_TRACE
+void print_preempt_trace(struct task_struct *tsk);
+#else
+static inline void print_preempt_trace(struct task_struct *tsk) { }
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux-trace.git/kernel/sched/core.c
===================================================================
--- linux-trace.git.orig/kernel/sched/core.c
+++ linux-trace.git/kernel/sched/core.c
@@ -3018,10 +3018,14 @@ notrace unsigned long get_parent_ip(unsi
 }
 
 #if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
-				defined(CONFIG_PREEMPT_TRACER))
+				defined(CONFIG_PREEMPT_TRACER) || \
+				defined(CONFIG_PREEMPT_TRACE))
 
 void __kprobes add_preempt_count(int val)
 {
+	unsigned long eip = CALLER_ADDR0;
+	unsigned long parent_eip = get_parent_ip(CALLER_ADDR1);
+
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Underflow?
@@ -3030,6 +3034,15 @@ void __kprobes add_preempt_count(int val
 		return;
 #endif
 	preempt_count() += val;
+#ifdef CONFIG_PREEMPT_TRACE
+	if (val <= 10) {
+		unsigned int idx = preempt_count() & PREEMPT_MASK;
+		if (idx < MAX_PREEMPT_TRACE) {
+			current->preempt_trace_eip[idx] = eip;
+			current->preempt_trace_parent_eip[idx] = parent_eip;
+		}
+	}
+#endif
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Spinlock count overflowing soon?
@@ -3038,7 +3051,7 @@ void __kprobes add_preempt_count(int val
 				PREEMPT_MASK - 10);
 #endif
 	if (preempt_count() == val)
-		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+		trace_preempt_off(eip, parent_eip);
 }
 EXPORT_SYMBOL(add_preempt_count);
 
Index: linux-trace.git/kernel/trace/Kconfig
===================================================================
--- linux-trace.git.orig/kernel/trace/Kconfig
+++ linux-trace.git/kernel/trace/Kconfig
@@ -487,6 +487,22 @@ config RING_BUFFER_BENCHMARK
 
 	  If unsure, say N.
 
+config PREEMPT_TRACE
+	bool "Keep a record of preempt disabled locations"
+	depends on DEBUG_KERNEL
+	depends on PREEMPT
+	select TRACING
+	help
+	  When enabled, it keeps track of the last 25 locations that disabled
+	  preemption. This is useful to debug a "scheduling while atomic" error.
+	  Sometimes it is hard to find what left preemption disabled, and this
+	  utility can help.
+
+	  Saying yes to this will introduce an overhead, as all preempt disabled
+	  calls are being tracked.
+
+	  If unsure, say N.
+
 endif # FTRACE
 
 endif # TRACING_SUPPORT
Index: linux-trace.git/kernel/trace/Makefile
===================================================================
--- linux-trace.git.orig/kernel/trace/Makefile
+++ linux-trace.git/kernel/trace/Makefile
@@ -62,4 +62,6 @@ ifeq ($(CONFIG_TRACING),y)
 obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
 endif
 
+obj-$(CONFIG_PREEMPT_TRACE) += preempt-trace.o
+
 libftrace-y := ftrace.o
Index: linux-trace.git/kernel/trace/preempt-trace.c
===================================================================
--- /dev/null
+++ linux-trace.git/kernel/trace/preempt-trace.c
@@ -0,0 +1,30 @@
+#include <linux/sched.h>
+#include <linux/hardirq.h>
+#include <linux/kallsyms.h>
+
+void print_preempt_trace(struct task_struct *task)
+{
+	unsigned int count;
+	unsigned int i, lim;
+
+	if (!task)
+		task = current;
+
+	count = task_thread_info(task)->preempt_count;
+	lim = count & PREEMPT_MASK;
+
+	if (lim >= MAX_PREEMPT_TRACE)
+		lim = MAX_PREEMPT_TRACE-1;
+	printk("---------------------------\n");
+	printk("| preempt count: %08x ]\n", count);
+	printk("| %d-level deep critical section nesting:\n", lim);
+	printk("----------------------------------------\n");
+	for (i = 1; i <= lim; i++) {
+		printk(".. [<%08lx>] .... ", task->preempt_trace_eip[i]);
+		print_symbol("%s\n", task->preempt_trace_eip[i]);
+		printk(".....[<%08lx>] ..   ( <= ",
+				task->preempt_trace_parent_eip[i]);
+		print_symbol("%s)\n", task->preempt_trace_parent_eip[i]);
+	}
+	printk("\n");
+}
Index: linux-trace.git/arch/x86/kernel/dumpstack.c
===================================================================
--- linux-trace.git.orig/arch/x86/kernel/dumpstack.c
+++ linux-trace.git/arch/x86/kernel/dumpstack.c
@@ -163,6 +163,7 @@ show_trace_log_lvl(struct task_struct *t
 {
 	printk("%sCall Trace:\n", log_lvl);
 	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
+	print_preempt_trace(task);
 }
 
 void show_trace(struct task_struct *task, struct pt_regs *regs,


