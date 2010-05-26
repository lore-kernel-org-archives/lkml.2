Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532Ab0EZWap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:30:45 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46932 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934162Ab0EZWam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references:mime-version:content-type
         :content-transfer-encoding;
        b=qBFnUUjm4MNZVDmfLbdZ6G1rB8lGwFo0D0GHGELvA07+F3uO59lLY8WWZXEaB4qN5J
         m8W4MWa7EB9odsGfzjPsAtH7F1iTDwTJ61JotDSK3bQwbDy9PjDkpoS4UdQMcC2+oxpo
         Xs8U0wqXWue6Fyp3DeYKIcdNQTVvWbQu+eAj0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?utf-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
       Chase Douglas <chase.douglas@canonical.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] tracing: Remove boot tracer
Date: Thu, 27 May 2010 00:30:36 +0200
Message-Id: <1274913037-1126-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274913037-1126-1-git-send-regression-fweisbec@gmail.com>
References: <1274913037-1126-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Américo Wang <xiyou.wangcong@gmail.com>

The boot tracer is useless. It simply logs the initcalls
but in fact these initcalls are also logged through printk
while using the initcall_debug kernel parameter.

Nobody seem to be using it so far. Then just remove it.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <20100526105753.GA5677@cr0.nay.redhat.com>
[ remove the hooks in main.c, and the headers ]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/boot.h         |   60 --------------
 init/main.c                  |   27 +++----
 kernel/trace/Kconfig         |   17 ----
 kernel/trace/Makefile        |    1 -
 kernel/trace/trace.c         |    3 -
 kernel/trace/trace.h         |    8 --
 kernel/trace/trace_boot.c    |  185 ------------------------------------------
 kernel/trace/trace_entries.h |   27 ------
 8 files changed, 10 insertions(+), 318 deletions(-)
 delete mode 100644 include/trace/boot.h
 delete mode 100644 kernel/trace/trace_boot.c

diff --git a/include/trace/boot.h b/include/trace/boot.h
deleted file mode 100644
index 088ea08..0000000
--- a/include/trace/boot.h
+++ /dev/null
@@ -1,60 +0,0 @@
-#ifndef _LINUX_TRACE_BOOT_H
-#define _LINUX_TRACE_BOOT_H
-
-#include <linux/module.h>
-#include <linux/kallsyms.h>
-#include <linux/init.h>
-
-/*
- * Structure which defines the trace of an initcall
- * while it is called.
- * You don't have to fill the func field since it is
- * only used internally by the tracer.
- */
-struct boot_trace_call {
-	pid_t			caller;
-	char			func[KSYM_SYMBOL_LEN];
-};
-
-/*
- * Structure which defines the trace of an initcall
- * while it returns.
- */
-struct boot_trace_ret {
-	char			func[KSYM_SYMBOL_LEN];
-	int				result;
-	unsigned long long	duration;		/* nsecs */
-};
-
-#ifdef CONFIG_BOOT_TRACER
-/* Append the traces on the ring-buffer */
-extern void trace_boot_call(struct boot_trace_call *bt, initcall_t fn);
-extern void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn);
-
-/* Tells the tracer that smp_pre_initcall is finished.
- * So we can start the tracing
- */
-extern void start_boot_trace(void);
-
-/* Resume the tracing of other necessary events
- * such as sched switches
- */
-extern void enable_boot_trace(void);
-
-/* Suspend this tracing. Actually, only sched_switches tracing have
- * to be suspended. Initcalls doesn't need it.)
- */
-extern void disable_boot_trace(void);
-#else
-static inline
-void trace_boot_call(struct boot_trace_call *bt, initcall_t fn) { }
-
-static inline
-void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn) { }
-
-static inline void start_boot_trace(void) { }
-static inline void enable_boot_trace(void) { }
-static inline void disable_boot_trace(void) { }
-#endif /* CONFIG_BOOT_TRACER */
-
-#endif /* __LINUX_TRACE_BOOT_H */
diff --git a/init/main.c b/init/main.c
index 5c85402..22d5f73 100644
--- a/init/main.c
+++ b/init/main.c
@@ -69,7 +69,6 @@
 #include <linux/sfi.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
-#include <trace/boot.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -713,38 +712,33 @@ int initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
 static char msgbuf[64];
-static struct boot_trace_call call;
-static struct boot_trace_ret ret;
 
 int do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
 	ktime_t calltime, delta, rettime;
+	unsigned long long duration;
+	int ret;
 
 	if (initcall_debug) {
-		call.caller = task_pid_nr(current);
-		printk("calling  %pF @ %i\n", fn, call.caller);
+		printk("calling  %pF @ %i\n", fn, task_pid_nr(current));
 		calltime = ktime_get();
-		trace_boot_call(&call, fn);
-		enable_boot_trace();
 	}
 
-	ret.result = fn();
+	ret = fn();
 
 	if (initcall_debug) {
-		disable_boot_trace();
 		rettime = ktime_get();
 		delta = ktime_sub(rettime, calltime);
-		ret.duration = (unsigned long long) ktime_to_ns(delta) >> 10;
-		trace_boot_ret(&ret, fn);
-		printk("initcall %pF returned %d after %Ld usecs\n", fn,
-			ret.result, ret.duration);
+		duration = (unsigned long long) ktime_to_ns(delta) >> 10;
+		printk("initcall %pF returned %d after %lld usecs\n", fn,
+			ret, duration);
 	}
 
 	msgbuf[0] = 0;
 
-	if (ret.result && ret.result != -ENODEV && initcall_debug)
-		sprintf(msgbuf, "error code %d ", ret.result);
+	if (ret && ret != -ENODEV && initcall_debug)
+		sprintf(msgbuf, "error code %d ", ret);
 
 	if (preempt_count() != count) {
 		strlcat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
@@ -758,7 +752,7 @@ int do_one_initcall(initcall_t fn)
 		printk("initcall %pF returned with %s\n", fn, msgbuf);
 	}
 
-	return ret.result;
+	return ret;
 }
 
 
@@ -878,7 +872,6 @@ static int __init kernel_init(void * unused)
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
-	start_boot_trace();
 
 	smp_init();
 	sched_init_smp();
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8b1797c..572992a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -229,23 +229,6 @@ config FTRACE_SYSCALLS
 	help
 	  Basic tracer to catch the syscall entry and exit events.
 
-config BOOT_TRACER
-	bool "Trace boot initcalls"
-	select GENERIC_TRACER
-	select CONTEXT_SWITCH_TRACER
-	help
-	  This tracer helps developers to optimize boot times: it records
-	  the timings of the initcalls and traces key events and the identity
-	  of tasks that can cause boot delays, such as context-switches.
-
-	  Its aim is to be parsed by the scripts/bootgraph.pl tool to
-	  produce pretty graphics about boot inefficiencies, giving a visual
-	  representation of the delays during initcalls - but the raw
-	  /debug/tracing/trace text output is readable too.
-
-	  You must pass in initcall_debug and ftrace=initcall to the kernel
-	  command line to enable this on bootup.
-
 config TRACE_BRANCH_PROFILING
 	bool
 	select GENERIC_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index ffb1a5b..c3aaeba 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -38,7 +38,6 @@ obj-$(CONFIG_SCHED_TRACER) += trace_sched_wakeup.o
 obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
-obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += trace_functions_graph.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ba0ec81..302ec46 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4591,9 +4591,6 @@ __init static int tracer_alloc_buffers(void)
 
 	register_tracer(&nop_trace);
 	current_trace = &nop_trace;
-#ifdef CONFIG_BOOT_TRACER
-	register_tracer(&boot_tracer);
-#endif
 	/* All seems OK, enable tracing */
 	tracing_disabled = 0;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2cd9639..75a5e80 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -9,10 +9,8 @@
 #include <linux/mmiotrace.h>
 #include <linux/tracepoint.h>
 #include <linux/ftrace.h>
-#include <trace/boot.h>
 #include <linux/kmemtrace.h>
 #include <linux/hw_breakpoint.h>
-
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
 
@@ -29,8 +27,6 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BRANCH,
-	TRACE_BOOT_CALL,
-	TRACE_BOOT_RET,
 	TRACE_GRAPH_RET,
 	TRACE_GRAPH_ENT,
 	TRACE_USER_STACK,
@@ -48,8 +44,6 @@ enum kmemtrace_type_id {
 	KMEMTRACE_TYPE_PAGES,		/* __get_free_pages() and friends. */
 };
 
-extern struct tracer boot_tracer;
-
 #undef __field
 #define __field(type, item)		type	item;
 
@@ -209,8 +203,6 @@ extern void __ftrace_bad_type(void);
 			  TRACE_MMIO_RW);				\
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
-		IF_ASSIGN(var, ent, struct trace_boot_call, TRACE_BOOT_CALL);\
-		IF_ASSIGN(var, ent, struct trace_boot_ret, TRACE_BOOT_RET);\
 		IF_ASSIGN(var, ent, struct trace_branch, TRACE_BRANCH); \
 		IF_ASSIGN(var, ent, struct ftrace_graph_ent_entry,	\
 			  TRACE_GRAPH_ENT);		\
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
deleted file mode 100644
index c21d5f3..0000000
--- a/kernel/trace/trace_boot.c
+++ /dev/null
@@ -1,185 +0,0 @@
-/*
- * ring buffer based initcalls tracer
- *
- * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
- *
- */
-
-#include <linux/init.h>
-#include <linux/debugfs.h>
-#include <linux/ftrace.h>
-#include <linux/kallsyms.h>
-#include <linux/time.h>
-
-#include "trace.h"
-#include "trace_output.h"
-
-static struct trace_array *boot_trace;
-static bool pre_initcalls_finished;
-
-/* Tells the boot tracer that the pre_smp_initcalls are finished.
- * So we are ready .
- * It doesn't enable sched events tracing however.
- * You have to call enable_boot_trace to do so.
- */
-void start_boot_trace(void)
-{
-	pre_initcalls_finished = true;
-}
-
-void enable_boot_trace(void)
-{
-	if (boot_trace && pre_initcalls_finished)
-		tracing_start_sched_switch_record();
-}
-
-void disable_boot_trace(void)
-{
-	if (boot_trace && pre_initcalls_finished)
-		tracing_stop_sched_switch_record();
-}
-
-static int boot_trace_init(struct trace_array *tr)
-{
-	boot_trace = tr;
-
-	if (!tr)
-		return 0;
-
-	tracing_reset_online_cpus(tr);
-
-	tracing_sched_switch_assign_trace(tr);
-	return 0;
-}
-
-static enum print_line_t
-initcall_call_print_line(struct trace_iterator *iter)
-{
-	struct trace_entry *entry = iter->ent;
-	struct trace_seq *s = &iter->seq;
-	struct trace_boot_call *field;
-	struct boot_trace_call *call;
-	u64 ts;
-	unsigned long nsec_rem;
-	int ret;
-
-	trace_assign_type(field, entry);
-	call = &field->boot_call;
-	ts = iter->ts;
-	nsec_rem = do_div(ts, NSEC_PER_SEC);
-
-	ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
-			(unsigned long)ts, nsec_rem, call->func, call->caller);
-
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-	else
-		return TRACE_TYPE_HANDLED;
-}
-
-static enum print_line_t
-initcall_ret_print_line(struct trace_iterator *iter)
-{
-	struct trace_entry *entry = iter->ent;
-	struct trace_seq *s = &iter->seq;
-	struct trace_boot_ret *field;
-	struct boot_trace_ret *init_ret;
-	u64 ts;
-	unsigned long nsec_rem;
-	int ret;
-
-	trace_assign_type(field, entry);
-	init_ret = &field->boot_ret;
-	ts = iter->ts;
-	nsec_rem = do_div(ts, NSEC_PER_SEC);
-
-	ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
-			"returned %d after %llu msecs\n",
-			(unsigned long) ts,
-			nsec_rem,
-			init_ret->func, init_ret->result, init_ret->duration);
-
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-	else
-		return TRACE_TYPE_HANDLED;
-}
-
-static enum print_line_t initcall_print_line(struct trace_iterator *iter)
-{
-	struct trace_entry *entry = iter->ent;
-
-	switch (entry->type) {
-	case TRACE_BOOT_CALL:
-		return initcall_call_print_line(iter);
-	case TRACE_BOOT_RET:
-		return initcall_ret_print_line(iter);
-	default:
-		return TRACE_TYPE_UNHANDLED;
-	}
-}
-
-struct tracer boot_tracer __read_mostly =
-{
-	.name		= "initcall",
-	.init		= boot_trace_init,
-	.reset		= tracing_reset_online_cpus,
-	.print_line	= initcall_print_line,
-};
-
-void trace_boot_call(struct boot_trace_call *bt, initcall_t fn)
-{
-	struct ftrace_event_call *call = &event_boot_call;
-	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
-	struct trace_boot_call *entry;
-	struct trace_array *tr = boot_trace;
-
-	if (!tr || !pre_initcalls_finished)
-		return;
-
-	/* Get its name now since this function could
-	 * disappear because it is in the .init section.
-	 */
-	sprint_symbol(bt->func, (unsigned long)fn);
-	preempt_disable();
-
-	buffer = tr->buffer;
-	event = trace_buffer_lock_reserve(buffer, TRACE_BOOT_CALL,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		goto out;
-	entry	= ring_buffer_event_data(event);
-	entry->boot_call = *bt;
-	if (!filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, 0, 0);
- out:
-	preempt_enable();
-}
-
-void trace_boot_ret(struct boot_trace_ret *bt, initcall_t fn)
-{
-	struct ftrace_event_call *call = &event_boot_ret;
-	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
-	struct trace_boot_ret *entry;
-	struct trace_array *tr = boot_trace;
-
-	if (!tr || !pre_initcalls_finished)
-		return;
-
-	sprint_symbol(bt->func, (unsigned long)fn);
-	preempt_disable();
-
-	buffer = tr->buffer;
-	event = trace_buffer_lock_reserve(buffer, TRACE_BOOT_RET,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		goto out;
-	entry	= ring_buffer_event_data(event);
-	entry->boot_ret = *bt;
-	if (!filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, 0, 0);
- out:
-	preempt_enable();
-}
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index dc008c1..c293364 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -271,33 +271,6 @@ FTRACE_ENTRY(mmiotrace_map, trace_mmiotrace_map,
 		 __entry->map_id, __entry->opcode)
 );
 
-FTRACE_ENTRY(boot_call, trace_boot_call,
-
-	TRACE_BOOT_CALL,
-
-	F_STRUCT(
-		__field_struct(	struct boot_trace_call,	boot_call	)
-		__field_desc(	pid_t,	boot_call,	caller		)
-		__array_desc(	char,	boot_call,	func,	KSYM_SYMBOL_LEN)
-	),
-
-	F_printk("%d  %s", __entry->caller, __entry->func)
-);
-
-FTRACE_ENTRY(boot_ret, trace_boot_ret,
-
-	TRACE_BOOT_RET,
-
-	F_STRUCT(
-		__field_struct(	struct boot_trace_ret,	boot_ret	)
-		__array_desc(	char,	boot_ret,	func,	KSYM_SYMBOL_LEN)
-		__field_desc(	int,	boot_ret,	result		)
-		__field_desc(	unsigned long, boot_ret, duration	)
-	),
-
-	F_printk("%s %d %lx",
-		 __entry->func, __entry->result, __entry->duration)
-);
 
 #define TRACE_FUNC_SIZE 30
 #define TRACE_FILE_SIZE 20
-- 
1.6.2.3

