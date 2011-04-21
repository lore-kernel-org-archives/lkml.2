Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1DUKlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 06:41:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab1DUKlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 06:41:09 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 1/3] trace: add support for enabling ftrace/function tracepoint event
Date: Thu, 21 Apr 2011 12:40:56 +0200
Message-Id: <1303382458-11072-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1303382458-11072-1-git-send-email-jolsa@redhat.com>
References: <1303382458-11072-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactored function trace code to be able to resuse the functionality
for tracing via global_trace.

Added reg function for ftrace tracepoint events and added support
for enabling ftrace/function tracepoint.

wbr,
jirka
---
 kernel/trace/ftrace.c          |   35 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c           |   25 +++++++++++++++++++++++++
 kernel/trace/trace.h           |    8 ++++++++
 kernel/trace/trace_export.c    |    1 +
 kernel/trace/trace_functions.c |   32 +++++---------------------------
 5 files changed, 74 insertions(+), 27 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ee24fa1..00fe267 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3218,6 +3218,41 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
+static void
+ftrace_function_call_trace(unsigned long ip, unsigned long parent_ip)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	trace_function_call_global(flags, preempt_count(), ip, parent_ip);
+	local_irq_restore(flags);
+}
+
+static struct ftrace_ops ftrace_trace_ops __read_mostly = {
+	.func = ftrace_function_call_trace,
+};
+
+int ftrace_event_class_register(struct ftrace_event_call *call,
+				enum trace_reg type)
+{
+	int etype = call->event.type;
+
+	if (etype != TRACE_FN)
+		return -EINVAL;
+
+	switch (type) {
+	case TRACE_REG_REGISTER:
+		return register_ftrace_function(&ftrace_trace_ops);
+	case TRACE_REG_UNREGISTER:
+		return unregister_ftrace_function(&ftrace_trace_ops);
+	case TRACE_REG_PERF_REGISTER:
+	case TRACE_REG_PERF_UNREGISTER:
+		break;
+	}
+
+	return -EINVAL;
+}
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 static int ftrace_graph_active;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d38c16a..6283e0c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1224,6 +1224,31 @@ trace_function(struct trace_array *tr,
 }
 
 void
+trace_function_call(struct trace_array *tr, unsigned long flags, int pc,
+		    unsigned long ip, unsigned long parent_ip)
+{
+	struct trace_array_cpu *data;
+	long disabled;
+	int cpu;
+
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1))
+		trace_function(tr, ip, parent_ip, flags, pc);
+
+	atomic_dec(&data->disabled);
+}
+
+void
+trace_function_call_global(unsigned long flags, int pc,
+			   unsigned long ip, unsigned long parent_ip)
+{
+	trace_function_call(&global_trace, flags, pc, ip, parent_ip);
+}
+
+void
 ftrace(struct trace_array *tr, struct trace_array_cpu *data,
        unsigned long ip, unsigned long parent_ip, unsigned long flags,
        int pc)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 5e9dfc6..3298333 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -343,6 +343,11 @@ void trace_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
+void trace_function_call(struct trace_array *tr,
+			 unsigned long flags, int pc,
+			 unsigned long ip, unsigned long parent_ip);
+void trace_function_call_global(unsigned long flags, int pc,
+				unsigned long ip, unsigned long parent_ip);
 void trace_graph_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
@@ -773,6 +778,9 @@ extern struct list_head ftrace_events;
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
+extern int ftrace_event_class_register(struct ftrace_event_call *call,
+				       enum trace_reg type);
+
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print)		\
 	extern struct ftrace_event_call					\
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index bbeec31..0b0906a 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -159,6 +159,7 @@ struct ftrace_event_class event_class_ftrace_##call = {			\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.define_fields		= ftrace_define_fields_##call,		\
 	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
+	.reg			= ftrace_event_class_register,		\
 };									\
 									\
 struct ftrace_event_call __used event_##call = {			\
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 16aee4d..175a8e2 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -50,11 +50,7 @@ static void function_trace_start(struct trace_array *tr)
 static void
 function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
 {
-	struct trace_array *tr = func_trace;
-	struct trace_array_cpu *data;
 	unsigned long flags;
-	long disabled;
-	int cpu;
 	int pc;
 
 	if (unlikely(!ftrace_function_enabled))
@@ -63,26 +59,16 @@ function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
 	pc = preempt_count();
 	preempt_disable_notrace();
 	local_save_flags(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
 
-	if (likely(disabled == 1))
-		trace_function(tr, ip, parent_ip, flags, pc);
+	trace_function_call(func_trace, flags, pc, ip, parent_ip);
 
-	atomic_dec(&data->disabled);
 	preempt_enable_notrace();
 }
 
 static void
-function_trace_call(unsigned long ip, unsigned long parent_ip)
+function_trace_call_irq(unsigned long ip, unsigned long parent_ip)
 {
-	struct trace_array *tr = func_trace;
-	struct trace_array_cpu *data;
 	unsigned long flags;
-	long disabled;
-	int cpu;
-	int pc;
 
 	if (unlikely(!ftrace_function_enabled))
 		return;
@@ -92,16 +78,9 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	 * recursive protection is performed.
 	 */
 	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
 
-	if (likely(disabled == 1)) {
-		pc = preempt_count();
-		trace_function(tr, ip, parent_ip, flags, pc);
-	}
+	trace_function_call(func_trace, flags, preempt_count(), ip, parent_ip);
 
-	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 }
 
@@ -148,7 +127,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 
 static struct ftrace_ops trace_ops __read_mostly =
 {
-	.func = function_trace_call,
+	.func = function_trace_call_irq,
 };
 
 static struct ftrace_ops trace_stack_ops __read_mostly =
@@ -180,7 +159,7 @@ static void tracing_start_function_trace(void)
 	if (trace_flags & TRACE_ITER_PREEMPTONLY)
 		trace_ops.func = function_trace_call_preempt_only;
 	else
-		trace_ops.func = function_trace_call;
+		trace_ops.func = function_trace_call_irq;
 
 	if (func_flags.val & TRACE_FUNC_OPT_STACK)
 		register_ftrace_function(&trace_stack_ops);
@@ -400,4 +379,3 @@ static __init int init_function_trace(void)
 	return register_tracer(&function_trace);
 }
 device_initcall(init_function_trace);
-
-- 
1.7.1

