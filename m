Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392Ab0EZKyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:54:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36897 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934317Ab0EZKyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HlECklY8VwxffQehr23006MFm64PW4VY1H7MqhgDPloC6Mc0mg2L6nIa5dxs/cUQ2Z
         tAVrnu5bY5vFQugojb03lgvbTLx/3G7k0cAE5CL78wKUwUiHwkNGew2GDtyNy7mUSNLJ
         MAOosoyrWFdOWdzYQSvGVq8hNk+cjSC7q4Dew=
Date: Wed, 26 May 2010 18:57:53 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Chase Douglas <chase.douglas@canonical.com>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [Patch] tracing: remove boot tracer
Message-ID: <20100526105753.GA5677@cr0.nay.redhat.com>
References: <1274815906.9757.83.camel@cndougla-ubuntu>
 <1274816768.22648.220.camel@gandalf.stny.rr.com>
 <20100525201736.GB5370@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525201736.GB5370@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 10:17:43PM +0200, Frederic Weisbecker wrote:
>On Tue, May 25, 2010 at 03:46:08PM -0400, Steven Rostedt wrote:
>> > CONFIG_BOOT_TRACER=y (no performance impact by default)
>> 
>> But this tracer is pretty useless. It gives no more information than
>> debug_initcalls.
>
>
>
>Yeah it's pretty useless. And these informations can also be displayed
>through printk on boot so...


Then just remove it.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

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
index 8a76339..687c487 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4602,9 +4602,6 @@ __init static int tracer_alloc_buffers(void)
 
 	register_tracer(&nop_trace);
 	current_trace = &nop_trace;
-#ifdef CONFIG_BOOT_TRACER
-	register_tracer(&boot_tracer);
-#endif
 	/* All seems OK, enable tracing */
 	tracing_disabled = 0;
 
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
