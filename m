Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935043Ab0GOXgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 19:36:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49781 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935014Ab0GOXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 19:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=I4ryr54Pam0GclvssCldFunDak7nN+Q/HDIQjaWNRYiPA+4MIFU2vZZzb3e5XBREJa
         ruZtAfoTf2Y7/RzCtmoVeJxpvGh3yCbZ/M9nchZw24xdU1eXjxSwI+COMxWaGCQS1XoW
         l4q14kIn1nLrLX1c85eoRKgn+UprwkHjsxOrw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Soeren Sandmann <sandmann@daimi.au.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCH 1/2] tracing: Remove sysprof ftrace plugin
Date: Fri, 16 Jul 2010 01:36:42 +0200
Message-Id: <1279237003-31354-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1279237003-31354-1-git-send-regression-fweisbec@gmail.com>
References: <1279237003-31354-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysprof ftrace plugin doesn't seem to be seriously used
somewhere. There is a branch in the sysprof tree that makes
an interface to it, but the real sysprof tool uses either its
own module or perf events.

Drop the sysprof ftrace plugin then, as it's mostly useless.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig          |    9 -
 kernel/trace/Makefile         |    1 -
 kernel/trace/trace.c          |    3 -
 kernel/trace/trace.h          |    3 -
 kernel/trace/trace_selftest.c |   32 ----
 kernel/trace/trace_sysprof.c  |  330 -----------------------------------------
 6 files changed, 0 insertions(+), 378 deletions(-)
 delete mode 100644 kernel/trace/trace_sysprof.c

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index f5306cb..c7683fd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -194,15 +194,6 @@ config PREEMPT_TRACER
 	  enabled. This option and the irqs-off timing option can be
 	  used together or separately.)
 
-config SYSPROF_TRACER
-	bool "Sysprof Tracer"
-	depends on X86
-	select GENERIC_TRACER
-	select CONTEXT_SWITCH_TRACER
-	help
-	  This tracer provides the trace needed by the 'Sysprof' userspace
-	  tool.
-
 config SCHED_TRACER
 	bool "Scheduling Latency Tracer"
 	select GENERIC_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 84b2c99..438e84a 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -30,7 +30,6 @@ obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
-obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
 obj-$(CONFIG_IRQSOFF_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_PREEMPT_TRACER) += trace_irqsoff.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8683dec..78a49e6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4354,9 +4354,6 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
 #endif
-#ifdef CONFIG_SYSPROF_TRACER
-	init_tracer_sysprof_debugfs(d_tracer);
-#endif
 
 	create_trace_options_dir();
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 84d3f12..2114b4c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -296,7 +296,6 @@ struct dentry *trace_create_file(const char *name,
 				 const struct file_operations *fops);
 
 struct dentry *tracing_init_dentry(void);
-void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
 
 struct ring_buffer_event;
 
@@ -428,8 +427,6 @@ extern int trace_selftest_startup_nop(struct tracer *trace,
 					 struct trace_array *tr);
 extern int trace_selftest_startup_sched_switch(struct tracer *trace,
 					       struct trace_array *tr);
-extern int trace_selftest_startup_sysprof(struct tracer *trace,
-					       struct trace_array *tr);
 extern int trace_selftest_startup_branch(struct tracer *trace,
 					 struct trace_array *tr);
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 39a5ca4..6ed05ee 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -690,38 +690,6 @@ trace_selftest_startup_sched_switch(struct tracer *trace, struct trace_array *tr
 }
 #endif /* CONFIG_CONTEXT_SWITCH_TRACER */
 
-#ifdef CONFIG_SYSPROF_TRACER
-int
-trace_selftest_startup_sysprof(struct tracer *trace, struct trace_array *tr)
-{
-	unsigned long count;
-	int ret;
-
-	/* start the tracing */
-	ret = tracer_init(trace, tr);
-	if (ret) {
-		warn_failed_init_tracer(trace, ret);
-		return ret;
-	}
-
-	/* Sleep for a 1/10 of a second */
-	msleep(100);
-	/* stop the tracing. */
-	tracing_stop();
-	/* check the trace buffer */
-	ret = trace_test_buffer(tr, &count);
-	trace->reset(tr);
-	tracing_start();
-
-	if (!ret && !count) {
-		printk(KERN_CONT ".. no entries found ..");
-		ret = -1;
-	}
-
-	return ret;
-}
-#endif /* CONFIG_SYSPROF_TRACER */
-
 #ifdef CONFIG_BRANCH_TRACER
 int
 trace_selftest_startup_branch(struct tracer *trace, struct trace_array *tr)
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
deleted file mode 100644
index c080956..0000000
--- a/kernel/trace/trace_sysprof.c
+++ /dev/null
@@ -1,330 +0,0 @@
-/*
- * trace stack traces
- *
- * Copyright (C) 2004-2008, Soeren Sandmann
- * Copyright (C) 2007 Steven Rostedt <srostedt@redhat.com>
- * Copyright (C) 2008 Ingo Molnar <mingo@redhat.com>
- */
-#include <linux/kallsyms.h>
-#include <linux/debugfs.h>
-#include <linux/hrtimer.h>
-#include <linux/uaccess.h>
-#include <linux/ftrace.h>
-#include <linux/module.h>
-#include <linux/irq.h>
-#include <linux/fs.h>
-
-#include <asm/stacktrace.h>
-
-#include "trace.h"
-
-static struct trace_array	*sysprof_trace;
-static int __read_mostly	tracer_enabled;
-
-/*
- * 1 msec sample interval by default:
- */
-static unsigned long sample_period = 1000000;
-static const unsigned int sample_max_depth = 512;
-
-static DEFINE_MUTEX(sample_timer_lock);
-/*
- * Per CPU hrtimers that do the profiling:
- */
-static DEFINE_PER_CPU(struct hrtimer, stack_trace_hrtimer);
-
-struct stack_frame_user {
-	const void __user	*next_fp;
-	unsigned long		return_address;
-};
-
-static int
-copy_stack_frame(const void __user *fp, struct stack_frame_user *frame)
-{
-	int ret;
-
-	if (!access_ok(VERIFY_READ, fp, sizeof(*frame)))
-		return 0;
-
-	ret = 1;
-	pagefault_disable();
-	if (__copy_from_user_inatomic(frame, fp, sizeof(*frame)))
-		ret = 0;
-	pagefault_enable();
-
-	return ret;
-}
-
-struct backtrace_info {
-	struct trace_array_cpu	*data;
-	struct trace_array	*tr;
-	int			pos;
-};
-
-static void
-backtrace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	/* Ignore warnings */
-}
-
-static void backtrace_warning(void *data, char *msg)
-{
-	/* Ignore warnings */
-}
-
-static int backtrace_stack(void *data, char *name)
-{
-	/* Don't bother with IRQ stacks for now */
-	return -1;
-}
-
-static void backtrace_address(void *data, unsigned long addr, int reliable)
-{
-	struct backtrace_info *info = data;
-
-	if (info->pos < sample_max_depth && reliable) {
-		__trace_special(info->tr, info->data, 1, addr, 0);
-
-		info->pos++;
-	}
-}
-
-static const struct stacktrace_ops backtrace_ops = {
-	.warning		= backtrace_warning,
-	.warning_symbol		= backtrace_warning_symbol,
-	.stack			= backtrace_stack,
-	.address		= backtrace_address,
-	.walk_stack		= print_context_stack,
-};
-
-static int
-trace_kernel(struct pt_regs *regs, struct trace_array *tr,
-	     struct trace_array_cpu *data)
-{
-	struct backtrace_info info;
-	unsigned long bp;
-	char *stack;
-
-	info.tr = tr;
-	info.data = data;
-	info.pos = 1;
-
-	__trace_special(info.tr, info.data, 1, regs->ip, 0);
-
-	stack = ((char *)regs + sizeof(struct pt_regs));
-#ifdef CONFIG_FRAME_POINTER
-	bp = regs->bp;
-#else
-	bp = 0;
-#endif
-
-	dump_trace(NULL, regs, (void *)stack, bp, &backtrace_ops, &info);
-
-	return info.pos;
-}
-
-static void timer_notify(struct pt_regs *regs, int cpu)
-{
-	struct trace_array_cpu *data;
-	struct stack_frame_user frame;
-	struct trace_array *tr;
-	const void __user *fp;
-	int is_user;
-	int i;
-
-	if (!regs)
-		return;
-
-	tr = sysprof_trace;
-	data = tr->data[cpu];
-	is_user = user_mode(regs);
-
-	if (!current || current->pid == 0)
-		return;
-
-	if (is_user && current->state != TASK_RUNNING)
-		return;
-
-	__trace_special(tr, data, 0, 0, current->pid);
-
-	if (!is_user)
-		i = trace_kernel(regs, tr, data);
-	else
-		i = 0;
-
-	/*
-	 * Trace user stack if we are not a kernel thread
-	 */
-	if (current->mm && i < sample_max_depth) {
-		regs = (struct pt_regs *)current->thread.sp0 - 1;
-
-		fp = (void __user *)regs->bp;
-
-		__trace_special(tr, data, 2, regs->ip, 0);
-
-		while (i < sample_max_depth) {
-			frame.next_fp = NULL;
-			frame.return_address = 0;
-			if (!copy_stack_frame(fp, &frame))
-				break;
-			if ((unsigned long)fp < regs->sp)
-				break;
-
-			__trace_special(tr, data, 2, frame.return_address,
-					(unsigned long)fp);
-			fp = frame.next_fp;
-
-			i++;
-		}
-
-	}
-
-	/*
-	 * Special trace entry if we overflow the max depth:
-	 */
-	if (i == sample_max_depth)
-		__trace_special(tr, data, -1, -1, -1);
-
-	__trace_special(tr, data, 3, current->pid, i);
-}
-
-static enum hrtimer_restart stack_trace_timer_fn(struct hrtimer *hrtimer)
-{
-	/* trace here */
-	timer_notify(get_irq_regs(), smp_processor_id());
-
-	hrtimer_forward_now(hrtimer, ns_to_ktime(sample_period));
-
-	return HRTIMER_RESTART;
-}
-
-static void start_stack_timer(void *unused)
-{
-	struct hrtimer *hrtimer = &__get_cpu_var(stack_trace_hrtimer);
-
-	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtimer->function = stack_trace_timer_fn;
-
-	hrtimer_start(hrtimer, ns_to_ktime(sample_period),
-		      HRTIMER_MODE_REL_PINNED);
-}
-
-static void start_stack_timers(void)
-{
-	on_each_cpu(start_stack_timer, NULL, 1);
-}
-
-static void stop_stack_timer(int cpu)
-{
-	struct hrtimer *hrtimer = &per_cpu(stack_trace_hrtimer, cpu);
-
-	hrtimer_cancel(hrtimer);
-}
-
-static void stop_stack_timers(void)
-{
-	int cpu;
-
-	for_each_online_cpu(cpu)
-		stop_stack_timer(cpu);
-}
-
-static void stop_stack_trace(struct trace_array *tr)
-{
-	mutex_lock(&sample_timer_lock);
-	stop_stack_timers();
-	tracer_enabled = 0;
-	mutex_unlock(&sample_timer_lock);
-}
-
-static int stack_trace_init(struct trace_array *tr)
-{
-	sysprof_trace = tr;
-
-	tracing_start_cmdline_record();
-
-	mutex_lock(&sample_timer_lock);
-	start_stack_timers();
-	tracer_enabled = 1;
-	mutex_unlock(&sample_timer_lock);
-	return 0;
-}
-
-static void stack_trace_reset(struct trace_array *tr)
-{
-	tracing_stop_cmdline_record();
-	stop_stack_trace(tr);
-}
-
-static struct tracer stack_trace __read_mostly =
-{
-	.name		= "sysprof",
-	.init		= stack_trace_init,
-	.reset		= stack_trace_reset,
-#ifdef CONFIG_FTRACE_SELFTEST
-	.selftest    = trace_selftest_startup_sysprof,
-#endif
-};
-
-__init static int init_stack_trace(void)
-{
-	return register_tracer(&stack_trace);
-}
-device_initcall(init_stack_trace);
-
-#define MAX_LONG_DIGITS 22
-
-static ssize_t
-sysprof_sample_read(struct file *filp, char __user *ubuf,
-		    size_t cnt, loff_t *ppos)
-{
-	char buf[MAX_LONG_DIGITS];
-	int r;
-
-	r = sprintf(buf, "%ld\n", nsecs_to_usecs(sample_period));
-
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-}
-
-static ssize_t
-sysprof_sample_write(struct file *filp, const char __user *ubuf,
-		     size_t cnt, loff_t *ppos)
-{
-	char buf[MAX_LONG_DIGITS];
-	unsigned long val;
-
-	if (cnt > MAX_LONG_DIGITS-1)
-		cnt = MAX_LONG_DIGITS-1;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	val = simple_strtoul(buf, NULL, 10);
-	/*
-	 * Enforce a minimum sample period of 100 usecs:
-	 */
-	if (val < 100)
-		val = 100;
-
-	mutex_lock(&sample_timer_lock);
-	stop_stack_timers();
-	sample_period = val * 1000;
-	start_stack_timers();
-	mutex_unlock(&sample_timer_lock);
-
-	return cnt;
-}
-
-static const struct file_operations sysprof_sample_fops = {
-	.read		= sysprof_sample_read,
-	.write		= sysprof_sample_write,
-};
-
-void init_tracer_sysprof_debugfs(struct dentry *d_tracer)
-{
-
-	trace_create_file("sysprof_sample_period", 0644,
-			d_tracer, NULL, &sysprof_sample_fops);
-}
-- 
1.6.2.3

