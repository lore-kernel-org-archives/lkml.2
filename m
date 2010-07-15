Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055Ab0GOXgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 19:36:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32866 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933661Ab0GOXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 19:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=HShxzdRXhUZ35IUT5pqpVJ7in72cUWPRA+APrKe0BZYyOmVY/G95CdqcVMzN6zcZlG
         K2dzAGUX9+ISBPyQIrsXpFJ6UxPmKdPnnR1F8BcHykMzx8LNTmnr3277uqVDHcxNonnj
         SNYJAN7PJYN0BjMW4JqZLKgxcI6vUGkIsqIB8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Soeren Sandmann <sandmann@daimi.au.dk>
Subject: [RFC PATCH 2/2] tracing: Remove special traces
Date: Fri, 16 Jul 2010 01:36:43 +0200
Message-Id: <1279237003-31354-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1279237003-31354-1-git-send-regression-fweisbec@gmail.com>
References: <1279237003-31354-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Special traces type was only used by sysprof. Lets remove it now
that sysprof ftrace plugin has been dropped.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>
---
 include/linux/kernel.h        |    5 ---
 include/linux/sched.h         |   12 -------
 kernel/trace/trace.c          |   55 ----------------------------------
 kernel/trace/trace.h          |    6 ----
 kernel/trace/trace_entries.h  |   17 ----------
 kernel/trace/trace_output.c   |   66 -----------------------------------------
 kernel/trace/trace_selftest.c |    1 -
 7 files changed, 0 insertions(+), 162 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..adee958 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -508,9 +508,6 @@ extern void tracing_start(void);
 extern void tracing_stop(void);
 extern void ftrace_off_permanent(void);
 
-extern void
-ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
-
 static inline void __attribute__ ((format (printf, 1, 2)))
 ____trace_printk_check_format(const char *fmt, ...)
 {
@@ -586,8 +583,6 @@ __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
 
 extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
 #else
-static inline void
-ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
 static inline int
 trace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 747fcae..f751ea9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2434,18 +2434,6 @@ static inline void set_task_cpu(struct task_struct *p, unsigned int cpu)
 
 #endif /* CONFIG_SMP */
 
-#ifdef CONFIG_TRACING
-extern void
-__trace_special(void *__tr, void *__data,
-		unsigned long arg1, unsigned long arg2, unsigned long arg3);
-#else
-static inline void
-__trace_special(void *__tr, void *__data,
-		unsigned long arg1, unsigned long arg2, unsigned long arg3)
-{
-}
-#endif
-
 extern long sched_setaffinity(pid_t pid, const struct cpumask *new_mask);
 extern long sched_getaffinity(pid_t pid, struct cpumask *mask);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 78a49e6..d9a4aa0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1331,61 +1331,6 @@ static void __trace_userstack(struct trace_array *tr, unsigned long flags)
 
 #endif /* CONFIG_STACKTRACE */
 
-static void
-ftrace_trace_special(void *__tr,
-		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
-		     int pc)
-{
-	struct ftrace_event_call *call = &event_special;
-	struct ring_buffer_event *event;
-	struct trace_array *tr = __tr;
-	struct ring_buffer *buffer = tr->buffer;
-	struct special_entry *entry;
-
-	event = trace_buffer_lock_reserve(buffer, TRACE_SPECIAL,
-					  sizeof(*entry), 0, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->arg1			= arg1;
-	entry->arg2			= arg2;
-	entry->arg3			= arg3;
-
-	if (!filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, 0, pc);
-}
-
-void
-__trace_special(void *__tr, void *__data,
-		unsigned long arg1, unsigned long arg2, unsigned long arg3)
-{
-	ftrace_trace_special(__tr, arg1, arg2, arg3, preempt_count());
-}
-
-void
-ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
-{
-	struct trace_array *tr = &global_trace;
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	int cpu;
-	int pc;
-
-	if (tracing_disabled)
-		return;
-
-	pc = preempt_count();
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-
-	if (likely(atomic_inc_return(&data->disabled) == 1))
-		ftrace_trace_special(tr, arg1, arg2, arg3, pc);
-
-	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
-}
-
 /**
  * trace_vbprintk - write binary msg to tracing buffer
  *
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2114b4c..2f8619b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,7 +22,6 @@ enum trace_type {
 	TRACE_STACK,
 	TRACE_PRINT,
 	TRACE_BPRINT,
-	TRACE_SPECIAL,
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BRANCH,
@@ -332,11 +331,6 @@ void tracing_sched_wakeup_trace(struct trace_array *tr,
 				struct task_struct *wakee,
 				struct task_struct *cur,
 				unsigned long flags, int pc);
-void trace_special(struct trace_array *tr,
-		   struct trace_array_cpu *data,
-		   unsigned long arg1,
-		   unsigned long arg2,
-		   unsigned long arg3, int pc);
 void trace_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index 8412837..e3dfeca 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -151,23 +151,6 @@ FTRACE_ENTRY_DUP(wakeup, ctx_switch_entry,
 );
 
 /*
- * Special (free-form) trace entry:
- */
-FTRACE_ENTRY(special, special_entry,
-
-	TRACE_SPECIAL,
-
-	F_STRUCT(
-		__field(	unsigned long,	arg1	)
-		__field(	unsigned long,	arg2	)
-		__field(	unsigned long,	arg3	)
-	),
-
-	F_printk("(%08lx) (%08lx) (%08lx)",
-		 __entry->arg1, __entry->arg2, __entry->arg3)
-);
-
-/*
  * Stack-trace entry:
  */
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 57c1b45..a46197b 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1069,65 +1069,6 @@ static struct trace_event trace_wake_event = {
 	.funcs		= &trace_wake_funcs,
 };
 
-/* TRACE_SPECIAL */
-static enum print_line_t trace_special_print(struct trace_iterator *iter,
-					     int flags, struct trace_event *event)
-{
-	struct special_entry *field;
-
-	trace_assign_type(field, iter->ent);
-
-	if (!trace_seq_printf(&iter->seq, "# %ld %ld %ld\n",
-			      field->arg1,
-			      field->arg2,
-			      field->arg3))
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
-}
-
-static enum print_line_t trace_special_hex(struct trace_iterator *iter,
-					   int flags, struct trace_event *event)
-{
-	struct special_entry *field;
-	struct trace_seq *s = &iter->seq;
-
-	trace_assign_type(field, iter->ent);
-
-	SEQ_PUT_HEX_FIELD_RET(s, field->arg1);
-	SEQ_PUT_HEX_FIELD_RET(s, field->arg2);
-	SEQ_PUT_HEX_FIELD_RET(s, field->arg3);
-
-	return TRACE_TYPE_HANDLED;
-}
-
-static enum print_line_t trace_special_bin(struct trace_iterator *iter,
-					   int flags, struct trace_event *event)
-{
-	struct special_entry *field;
-	struct trace_seq *s = &iter->seq;
-
-	trace_assign_type(field, iter->ent);
-
-	SEQ_PUT_FIELD_RET(s, field->arg1);
-	SEQ_PUT_FIELD_RET(s, field->arg2);
-	SEQ_PUT_FIELD_RET(s, field->arg3);
-
-	return TRACE_TYPE_HANDLED;
-}
-
-static struct trace_event_functions trace_special_funcs = {
-	.trace		= trace_special_print,
-	.raw		= trace_special_print,
-	.hex		= trace_special_hex,
-	.binary		= trace_special_bin,
-};
-
-static struct trace_event trace_special_event = {
-	.type		= TRACE_SPECIAL,
-	.funcs		= &trace_special_funcs,
-};
-
 /* TRACE_STACK */
 
 static enum print_line_t trace_stack_print(struct trace_iterator *iter,
@@ -1161,9 +1102,6 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 
 static struct trace_event_functions trace_stack_funcs = {
 	.trace		= trace_stack_print,
-	.raw		= trace_special_print,
-	.hex		= trace_special_hex,
-	.binary		= trace_special_bin,
 };
 
 static struct trace_event trace_stack_event = {
@@ -1194,9 +1132,6 @@ static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
 
 static struct trace_event_functions trace_user_stack_funcs = {
 	.trace		= trace_user_stack_print,
-	.raw		= trace_special_print,
-	.hex		= trace_special_hex,
-	.binary		= trace_special_bin,
 };
 
 static struct trace_event trace_user_stack_event = {
@@ -1314,7 +1249,6 @@ static struct trace_event *events[] __initdata = {
 	&trace_fn_event,
 	&trace_ctx_event,
 	&trace_wake_event,
-	&trace_special_event,
 	&trace_stack_event,
 	&trace_user_stack_event,
 	&trace_bprint_event,
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 6ed05ee..155a415 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -13,7 +13,6 @@ static inline int trace_valid_entry(struct trace_entry *entry)
 	case TRACE_WAKE:
 	case TRACE_STACK:
 	case TRACE_PRINT:
-	case TRACE_SPECIAL:
 	case TRACE_BRANCH:
 	case TRACE_GRAPH_ENT:
 	case TRACE_GRAPH_RET:
-- 
1.6.2.3

