Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1GPLZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:25:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61337 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1GPLWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:55 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=VviFJQwueRsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=XrfWbyG36wNYK5LU5-wA:9 a=-Tjoi7y_2oscieJs3TEA:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112253.048577160@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 07/20] tracing: Have dynamic size event stack traces
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Have-dynamic-size-event-stack-traces.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the stack trace per event in ftace is only 8 frames.
This can be quite limiting and sometimes useless. Especially when
the "ignore frames" is wrong and we also use up stack frames for
the event processing itself.

Change this to be dynamic by adding a percpu buffer that we can
write a large stack frame into and then copy into the ring buffer.

For interrupts and NMIs that come in while another event is being
process, will only get to use the 8 frame stack. That should be enough
as the task that it interrupted will have the full stack frame anyway.

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 +
 kernel/trace/trace.c         |   92 ++++++++++++++++++++++++++++++++++++------
 kernel/trace/trace_entries.h |    3 +-
 kernel/trace/trace_output.c  |   11 +++--
 4 files changed, 88 insertions(+), 19 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index b1e69ee..96efa67 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -76,6 +76,7 @@ struct trace_iterator {
 	struct trace_entry	*ent;
 	unsigned long		lost_events;
 	int			leftover;
+	int			ent_size;
 	int			cpu;
 	u64			ts;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d9c1612..e5df02c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1248,6 +1248,15 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
 }
 
 #ifdef CONFIG_STACKTRACE
+
+#define FTRACE_STACK_MAX_ENTRIES (PAGE_SIZE / sizeof(unsigned long))
+struct ftrace_stack {
+	unsigned long		calls[FTRACE_STACK_MAX_ENTRIES];
+};
+
+static DEFINE_PER_CPU(struct ftrace_stack, ftrace_stack);
+static DEFINE_PER_CPU(int, ftrace_stack_reserve);
+
 static void __ftrace_trace_stack(struct ring_buffer *buffer,
 				 unsigned long flags,
 				 int skip, int pc, struct pt_regs *regs)
@@ -1256,25 +1265,77 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 	struct ring_buffer_event *event;
 	struct stack_entry *entry;
 	struct stack_trace trace;
+	int use_stack;
+	int size = FTRACE_STACK_ENTRIES;
+
+	trace.nr_entries	= 0;
+	trace.skip		= skip;
+
+	/*
+	 * Since events can happen in NMIs there's no safe way to
+	 * use the per cpu ftrace_stacks. We reserve it and if an interrupt
+	 * or NMI comes in, it will just have to use the default
+	 * FTRACE_STACK_SIZE.
+	 */
+	preempt_disable_notrace();
+
+	use_stack = ++__get_cpu_var(ftrace_stack_reserve);
+	/*
+	 * We don't need any atomic variables, just a barrier.
+	 * If an interrupt comes in, we don't care, because it would
+	 * have exited and put the counter back to what we want.
+	 * We just need a barrier to keep gcc from moving things
+	 * around.
+	 */
+	barrier();
+	if (use_stack == 1) {
+		trace.entries		= &__get_cpu_var(ftrace_stack).calls[0];
+		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
+
+		if (regs)
+			save_stack_trace_regs(regs, &trace);
+		else
+			save_stack_trace(&trace);
+
+		if (trace.nr_entries > size)
+			size = trace.nr_entries;
+	} else
+		/* From now on, use_stack is a boolean */
+		use_stack = 0;
+
+	size *= sizeof(unsigned long);
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_STACK,
-					  sizeof(*entry), flags, pc);
+					  sizeof(*entry) + size, flags, pc);
 	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	memset(&entry->caller, 0, sizeof(entry->caller));
+		goto out;
+	entry = ring_buffer_event_data(event);
 
-	trace.nr_entries	= 0;
-	trace.max_entries	= FTRACE_STACK_ENTRIES;
-	trace.skip		= skip;
-	trace.entries		= entry->caller;
+	memset(&entry->caller, 0, size);
+
+	if (use_stack)
+		memcpy(&entry->caller, trace.entries,
+		       trace.nr_entries * sizeof(unsigned long));
+	else {
+		trace.max_entries	= FTRACE_STACK_ENTRIES;
+		trace.entries		= entry->caller;
+		if (regs)
+			save_stack_trace_regs(regs, &trace);
+		else
+			save_stack_trace(&trace);
+	}
+
+	entry->size = trace.nr_entries;
 
-	if (regs)
-		save_stack_trace_regs(regs, &trace);
-	else
-		save_stack_trace(&trace);
 	if (!filter_check_discard(call, entry, buffer, event))
 		ring_buffer_unlock_commit(buffer, event);
+
+ out:
+	/* Again, don't let gcc optimize things here */
+	barrier();
+	__get_cpu_var(ftrace_stack_reserve)--;
+	preempt_enable_notrace();
+
 }
 
 void ftrace_trace_stack_regs(struct ring_buffer *buffer, unsigned long flags,
@@ -1562,7 +1623,12 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts,
 
 	ftrace_enable_cpu();
 
-	return event ? ring_buffer_event_data(event) : NULL;
+	if (event) {
+		iter->ent_size = ring_buffer_event_length(event);
+		return ring_buffer_event_data(event);
+	}
+	iter->ent_size = 0;
+	return NULL;
 }
 
 static struct trace_entry *
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index e32744c..9336590 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -161,7 +161,8 @@ FTRACE_ENTRY(kernel_stack, stack_entry,
 	TRACE_STACK,
 
 	F_STRUCT(
-		__array(	unsigned long,	caller, FTRACE_STACK_ENTRIES	)
+		__field(	int,		size	)
+		__dynamic_array(unsigned long,	caller	)
 	),
 
 	F_printk("\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n"
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index e37de49..5199930 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1107,19 +1107,20 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 {
 	struct stack_entry *field;
 	struct trace_seq *s = &iter->seq;
-	int i;
+	unsigned long *p;
+	unsigned long *end;
 
 	trace_assign_type(field, iter->ent);
+	end = (unsigned long *)((long)iter->ent + iter->ent_size);
 
 	if (!trace_seq_puts(s, "<stack trace>\n"))
 		goto partial;
-	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-		if (!field->caller[i] || (field->caller[i] == ULONG_MAX))
-			break;
+
+	for (p = field->caller; p && *p != ULONG_MAX && p < end; p++) {
 		if (!trace_seq_puts(s, " => "))
 			goto partial;
 
-		if (!seq_print_ip_sym(s, field->caller[i], flags))
+		if (!seq_print_ip_sym(s, *p, flags))
 			goto partial;
 		if (!trace_seq_puts(s, "\n"))
 			goto partial;
-- 
1.7.5.4


