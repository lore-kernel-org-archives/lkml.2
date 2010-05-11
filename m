Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab0EKDJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:09:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab0EKDJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:09:15 -0400
X-Authority-Analysis: v=1.1 cv=GuuPm/R9MDBdMhOgsQZYzj+bBK5woo0X8cuc0sTVRtI= c=1 sm=0 a=yBDBXZmeikYA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=DGQuRcfz33TNmVfkWooA:9 a=5YyC-Z1Yl11jnPFAP7gA:7 a=8qRseE3tycCpA8KCtMlvLkBytuEA:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100511030911.134554959@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 May 2010 23:00:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 07/10 -v3][RFC] tracing: Allow events to share their print functions
References: <20100511030020.837892321@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Allow-events-to-share-their-print-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Multiple events may use the same method to print their data.
Instead of having all events have a pointer to their print funtions,
the trace_event structure now points to a trace_event_functions structure
that will hold the way to print ouf the event.

The event itself is now passed to the print function to let the print
function know what kind of event it should print.

This opens the door to consolidating the way several events print
their output.

v2: Fix the new function graph tracer event calls to handle this change.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h         |   17 +++-
 include/linux/syscalls.h             |   10 ++-
 include/trace/ftrace.h               |   13 ++-
 include/trace/syscall.h              |    6 +-
 kernel/trace/blktrace.c              |   13 ++-
 kernel/trace/kmemtrace.c             |   28 +++++--
 kernel/trace/trace.c                 |    9 +-
 kernel/trace/trace_functions_graph.c |   13 ++-
 kernel/trace/trace_kprobe.c          |   22 ++++--
 kernel/trace/trace_output.c          |  137 +++++++++++++++++++++++-----------
 kernel/trace/trace_output.h          |    2 +-
 kernel/trace/trace_syscalls.c        |    6 +-
 12 files changed, 186 insertions(+), 90 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 393a839..4f77932 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -70,18 +70,25 @@ struct trace_iterator {
 };
 
 
+struct trace_event;
+
 typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
-					      int flags);
-struct trace_event {
-	struct hlist_node	node;
-	struct list_head	list;
-	int			type;
+				      int flags, struct trace_event *event);
+
+struct trace_event_functions {
 	trace_print_func	trace;
 	trace_print_func	raw;
 	trace_print_func	hex;
 	trace_print_func	binary;
 };
 
+struct trace_event {
+	struct hlist_node		node;
+	struct list_head		list;
+	int				type;
+	struct trace_event_functions	*funcs;
+};
+
 extern int register_ftrace_event(struct trace_event *event);
 extern int unregister_ftrace_event(struct trace_event *event);
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 211c704..f725677 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -125,9 +125,12 @@ extern struct ftrace_event_class event_class_syscall_exit;
 	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_enter_##sname;		\
-	static struct trace_event enter_syscall_print_##sname = {	\
+	static struct trace_event_functions enter_syscall_print_funcs_##sname = { \
 		.trace                  = print_syscall_enter,		\
 	};								\
+	static struct trace_event enter_syscall_print_##sname = {	\
+		.funcs                  = &enter_syscall_print_funcs_##sname, \
+	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
@@ -142,9 +145,12 @@ extern struct ftrace_event_class event_class_syscall_exit;
 	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_exit_##sname;		\
-	static struct trace_event exit_syscall_print_##sname = {	\
+	static struct trace_event_functions exit_syscall_print_funcs_##sname = { \
 		.trace                  = print_syscall_exit,		\
 	};								\
+	static struct trace_event exit_syscall_print_##sname = {	\
+		.funcs                  = &exit_syscall_print_funcs_##sname, \
+	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 78533fd..5e94447 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -239,7 +239,8 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)			\
 static notrace enum print_line_t					\
-ftrace_raw_output_##name(struct trace_iterator *iter, int flags)	\
+ftrace_raw_output_##name(struct trace_iterator *iter, int flags,	\
+			 struct trace_event *event)			\
 {									\
 	return ftrace_raw_output_id_##template(event_##name.id,		\
 					       #name, iter, flags);	\
@@ -248,7 +249,8 @@ ftrace_raw_output_##name(struct trace_iterator *iter, int flags)	\
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
 static notrace enum print_line_t					\
-ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
+ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
+			 struct trace_event *event)			\
 {									\
 	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##template *field;				\
@@ -531,11 +533,12 @@ ftrace_raw_event_##call(void *__data, proto)				\
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
-									\
-static struct trace_event ftrace_event_type_##call = {			\
+static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 	.trace			= ftrace_raw_output_##call,		\
 };									\
-									\
+static struct trace_event ftrace_event_type_##call = {			\
+	.funcs			= &ftrace_event_type_funcs_##call,	\
+};									\
 static inline void ftrace_test_probe_##call(void)			\
 {									\
 	check_trace_callback_type_##call(ftrace_raw_event_##template);	\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 3964774..257e089 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -42,8 +42,10 @@ extern int reg_event_syscall_exit(struct ftrace_event_call *call);
 extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
 extern int
 ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
-enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
-enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
+enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags,
+				      struct trace_event *event);
+enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags,
+				     struct trace_event *event);
 #endif
 
 #ifdef CONFIG_PERF_EVENTS
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 19d93f8..36ea2b6 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1336,7 +1336,7 @@ out:
 }
 
 static enum print_line_t blk_trace_event_print(struct trace_iterator *iter,
-					       int flags)
+					       int flags, struct trace_event *event)
 {
 	return print_one_line(iter, false);
 }
@@ -1358,7 +1358,8 @@ static int blk_trace_synthesize_old_trace(struct trace_iterator *iter)
 }
 
 static enum print_line_t
-blk_trace_event_print_binary(struct trace_iterator *iter, int flags)
+blk_trace_event_print_binary(struct trace_iterator *iter, int flags,
+			     struct trace_event *event)
 {
 	return blk_trace_synthesize_old_trace(iter) ?
 			TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
@@ -1396,12 +1397,16 @@ static struct tracer blk_tracer __read_mostly = {
 	.set_flag	= blk_tracer_set_flag,
 };
 
-static struct trace_event trace_blk_event = {
-	.type		= TRACE_BLK,
+static struct trace_event_functions trace_blk_event_funcs = {
 	.trace		= blk_trace_event_print,
 	.binary		= blk_trace_event_print_binary,
 };
 
+static struct trace_event trace_blk_event = {
+	.type		= TRACE_BLK,
+	.funcs		= &trace_blk_event_funcs,
+};
+
 static int __init init_blk_tracer(void)
 {
 	if (!register_ftrace_event(&trace_blk_event)) {
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 7253d0c..bbfc1bb 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -243,7 +243,8 @@ struct kmemtrace_user_event_alloc {
 };
 
 static enum print_line_t
-kmemtrace_print_alloc(struct trace_iterator *iter, int flags)
+kmemtrace_print_alloc(struct trace_iterator *iter, int flags,
+		      struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_alloc_entry *entry;
@@ -263,7 +264,8 @@ kmemtrace_print_alloc(struct trace_iterator *iter, int flags)
 }
 
 static enum print_line_t
-kmemtrace_print_free(struct trace_iterator *iter, int flags)
+kmemtrace_print_free(struct trace_iterator *iter, int flags,
+		     struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_free_entry *entry;
@@ -281,7 +283,8 @@ kmemtrace_print_free(struct trace_iterator *iter, int flags)
 }
 
 static enum print_line_t
-kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
+kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags,
+			   struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_alloc_entry *entry;
@@ -315,7 +318,8 @@ kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
 }
 
 static enum print_line_t
-kmemtrace_print_free_user(struct trace_iterator *iter, int flags)
+kmemtrace_print_free_user(struct trace_iterator *iter, int flags,
+			  struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct kmemtrace_free_entry *entry;
@@ -469,18 +473,26 @@ static enum print_line_t kmemtrace_print_line(struct trace_iterator *iter)
 	}
 }
 
-static struct trace_event kmem_trace_alloc = {
-	.type			= TRACE_KMEM_ALLOC,
+static struct trace_event_functions kmem_trace_alloc_funcs = {
 	.trace			= kmemtrace_print_alloc,
 	.binary			= kmemtrace_print_alloc_user,
 };
 
-static struct trace_event kmem_trace_free = {
-	.type			= TRACE_KMEM_FREE,
+static struct trace_event kmem_trace_alloc = {
+	.type			= TRACE_KMEM_ALLOC,
+	.funcs			= &kmem_trace_alloc_funcs,
+};
+
+static struct trace_event_functions kmem_trace_free_funcs = {
 	.trace			= kmemtrace_print_free,
 	.binary			= kmemtrace_print_free_user,
 };
 
+static struct trace_event kmem_trace_free = {
+	.type			= TRACE_KMEM_FREE,
+	.funcs			= &kmem_trace_free_funcs,
+};
+
 static struct tracer kmem_tracer __read_mostly = {
 	.name			= "kmemtrace",
 	.init			= kmem_trace_init,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 756d728..ba0ec81 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1936,7 +1936,7 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	}
 
 	if (event)
-		return event->trace(iter, sym_flags);
+		return event->funcs->trace(iter, sym_flags, event);
 
 	if (!trace_seq_printf(s, "Unknown type %d\n", entry->type))
 		goto partial;
@@ -1962,7 +1962,7 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 
 	event = ftrace_find_event(entry->type);
 	if (event)
-		return event->raw(iter, 0);
+		return event->funcs->raw(iter, 0, event);
 
 	if (!trace_seq_printf(s, "%d ?\n", entry->type))
 		goto partial;
@@ -1989,7 +1989,7 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 
 	event = ftrace_find_event(entry->type);
 	if (event) {
-		enum print_line_t ret = event->hex(iter, 0);
+		enum print_line_t ret = event->funcs->hex(iter, 0, event);
 		if (ret != TRACE_TYPE_HANDLED)
 			return ret;
 	}
@@ -2014,7 +2014,8 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 	}
 
 	event = ftrace_find_event(entry->type);
-	return event ? event->binary(iter, 0) : TRACE_TYPE_HANDLED;
+	return event ? event->funcs->binary(iter, 0, event) :
+		TRACE_TYPE_HANDLED;
 }
 
 int trace_empty(struct trace_iterator *iter)
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index dd11c83..79f4bac 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1025,7 +1025,7 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 		if (!event)
 			return TRACE_TYPE_UNHANDLED;
 
-		ret = event->trace(iter, sym_flags);
+		ret = event->funcs->trace(iter, sym_flags, event);
 		if (ret != TRACE_TYPE_HANDLED)
 			return ret;
 	}
@@ -1112,7 +1112,8 @@ print_graph_function(struct trace_iterator *iter)
 }
 
 static enum print_line_t
-print_graph_function_event(struct trace_iterator *iter, int flags)
+print_graph_function_event(struct trace_iterator *iter, int flags,
+			   struct trace_event *event)
 {
 	return print_graph_function(iter);
 }
@@ -1225,14 +1226,18 @@ void graph_trace_close(struct trace_iterator *iter)
 	}
 }
 
+static struct trace_event_functions graph_functions = {
+	.trace		= print_graph_function_event,
+};
+
 static struct trace_event graph_trace_entry_event = {
 	.type		= TRACE_GRAPH_ENT,
-	.trace		= print_graph_function_event,
+	.funcs		= &graph_functions,
 };
 
 static struct trace_event graph_trace_ret_event = {
 	.type		= TRACE_GRAPH_RET,
-	.trace		= print_graph_function_event,
+	.funcs		= &graph_functions
 };
 
 static struct tracer graph_trace __read_mostly = {
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 428f4a5..b989ae2 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1011,16 +1011,15 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 
 /* Event entry printers */
 enum print_line_t
-print_kprobe_event(struct trace_iterator *iter, int flags)
+print_kprobe_event(struct trace_iterator *iter, int flags,
+		   struct trace_event *event)
 {
 	struct kprobe_trace_entry *field;
 	struct trace_seq *s = &iter->seq;
-	struct trace_event *event;
 	struct trace_probe *tp;
 	int i;
 
 	field = (struct kprobe_trace_entry *)iter->ent;
-	event = ftrace_find_event(field->ent.type);
 	tp = container_of(event, struct trace_probe, event);
 
 	if (!trace_seq_printf(s, "%s: (", tp->call.name))
@@ -1046,16 +1045,15 @@ partial:
 }
 
 enum print_line_t
-print_kretprobe_event(struct trace_iterator *iter, int flags)
+print_kretprobe_event(struct trace_iterator *iter, int flags,
+		      struct trace_event *event)
 {
 	struct kretprobe_trace_entry *field;
 	struct trace_seq *s = &iter->seq;
-	struct trace_event *event;
 	struct trace_probe *tp;
 	int i;
 
 	field = (struct kretprobe_trace_entry *)iter->ent;
-	event = ftrace_find_event(field->ent.type);
 	tp = container_of(event, struct trace_probe, event);
 
 	if (!trace_seq_printf(s, "%s: (", tp->call.name))
@@ -1351,6 +1349,14 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
 
+static struct trace_event_functions kretprobe_funcs = {
+	.trace		= print_kretprobe_event
+};
+
+static struct trace_event_functions kprobe_funcs = {
+	.trace		= print_kprobe_event
+};
+
 static int register_probe_event(struct trace_probe *tp)
 {
 	struct ftrace_event_call *call = &tp->call;
@@ -1358,13 +1364,13 @@ static int register_probe_event(struct trace_probe *tp)
 
 	/* Initialize ftrace_event_call */
 	if (probe_is_return(tp)) {
-		tp->event.trace = print_kretprobe_event;
+		tp->event.funcs = &kretprobe_funcs;
 		INIT_LIST_HEAD(&call->class->fields);
 		call->class->raw_init = probe_event_raw_init;
 		call->class->define_fields = kretprobe_event_define_fields;
 	} else {
 		INIT_LIST_HEAD(&call->class->fields);
-		tp->event.trace = print_kprobe_event;
+		tp->event.funcs = &kprobe_funcs;
 		call->class->raw_init = probe_event_raw_init;
 		call->class->define_fields = kprobe_event_define_fields;
 	}
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 2404c12..fc9d4db 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -726,6 +726,9 @@ int register_ftrace_event(struct trace_event *event)
 	if (WARN_ON(!event))
 		goto out;
 
+	if (WARN_ON(!event->funcs))
+		goto out;
+
 	INIT_LIST_HEAD(&event->list);
 
 	if (!event->type) {
@@ -758,14 +761,14 @@ int register_ftrace_event(struct trace_event *event)
 			goto out;
 	}
 
-	if (event->trace == NULL)
-		event->trace = trace_nop_print;
-	if (event->raw == NULL)
-		event->raw = trace_nop_print;
-	if (event->hex == NULL)
-		event->hex = trace_nop_print;
-	if (event->binary == NULL)
-		event->binary = trace_nop_print;
+	if (event->funcs->trace == NULL)
+		event->funcs->trace = trace_nop_print;
+	if (event->funcs->raw == NULL)
+		event->funcs->raw = trace_nop_print;
+	if (event->funcs->hex == NULL)
+		event->funcs->hex = trace_nop_print;
+	if (event->funcs->binary == NULL)
+		event->funcs->binary = trace_nop_print;
 
 	key = event->type & (EVENT_HASHSIZE - 1);
 
@@ -807,13 +810,15 @@ EXPORT_SYMBOL_GPL(unregister_ftrace_event);
  * Standard events
  */
 
-enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags)
+enum print_line_t trace_nop_print(struct trace_iterator *iter, int flags,
+				  struct trace_event *event)
 {
 	return TRACE_TYPE_HANDLED;
 }
 
 /* TRACE_FN */
-static enum print_line_t trace_fn_trace(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_trace(struct trace_iterator *iter, int flags,
+					struct trace_event *event)
 {
 	struct ftrace_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -840,7 +845,8 @@ static enum print_line_t trace_fn_trace(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static enum print_line_t trace_fn_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_raw(struct trace_iterator *iter, int flags,
+				      struct trace_event *event)
 {
 	struct ftrace_entry *field;
 
@@ -854,7 +860,8 @@ static enum print_line_t trace_fn_raw(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t trace_fn_hex(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_hex(struct trace_iterator *iter, int flags,
+				      struct trace_event *event)
 {
 	struct ftrace_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -867,7 +874,8 @@ static enum print_line_t trace_fn_hex(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags,
+				      struct trace_event *event)
 {
 	struct ftrace_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -880,14 +888,18 @@ static enum print_line_t trace_fn_bin(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
-static struct trace_event trace_fn_event = {
-	.type		= TRACE_FN,
+static struct trace_event_functions trace_fn_funcs = {
 	.trace		= trace_fn_trace,
 	.raw		= trace_fn_raw,
 	.hex		= trace_fn_hex,
 	.binary		= trace_fn_bin,
 };
 
+static struct trace_event trace_fn_event = {
+	.type		= TRACE_FN,
+	.funcs		= &trace_fn_funcs,
+};
+
 /* TRACE_CTX an TRACE_WAKE */
 static enum print_line_t trace_ctxwake_print(struct trace_iterator *iter,
 					     char *delim)
@@ -916,13 +928,14 @@ static enum print_line_t trace_ctxwake_print(struct trace_iterator *iter,
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t trace_ctx_print(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_ctx_print(struct trace_iterator *iter, int flags,
+					 struct trace_event *event)
 {
 	return trace_ctxwake_print(iter, "==>");
 }
 
 static enum print_line_t trace_wake_print(struct trace_iterator *iter,
-					  int flags)
+					  int flags, struct trace_event *event)
 {
 	return trace_ctxwake_print(iter, "  +");
 }
@@ -950,12 +963,14 @@ static int trace_ctxwake_raw(struct trace_iterator *iter, char S)
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t trace_ctx_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_ctx_raw(struct trace_iterator *iter, int flags,
+				       struct trace_event *event)
 {
 	return trace_ctxwake_raw(iter, 0);
 }
 
-static enum print_line_t trace_wake_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_wake_raw(struct trace_iterator *iter, int flags,
+					struct trace_event *event)
 {
 	return trace_ctxwake_raw(iter, '+');
 }
@@ -984,18 +999,20 @@ static int trace_ctxwake_hex(struct trace_iterator *iter, char S)
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t trace_ctx_hex(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_ctx_hex(struct trace_iterator *iter, int flags,
+				       struct trace_event *event)
 {
 	return trace_ctxwake_hex(iter, 0);
 }
 
-static enum print_line_t trace_wake_hex(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_wake_hex(struct trace_iterator *iter, int flags,
+					struct trace_event *event)
 {
 	return trace_ctxwake_hex(iter, '+');
 }
 
 static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
-					   int flags)
+					   int flags, struct trace_event *event)
 {
 	struct ctx_switch_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1012,25 +1029,33 @@ static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
 	return TRACE_TYPE_HANDLED;
 }
 
-static struct trace_event trace_ctx_event = {
-	.type		= TRACE_CTX,
+static struct trace_event_functions trace_ctx_funcs = {
 	.trace		= trace_ctx_print,
 	.raw		= trace_ctx_raw,
 	.hex		= trace_ctx_hex,
 	.binary		= trace_ctxwake_bin,
 };
 
-static struct trace_event trace_wake_event = {
-	.type		= TRACE_WAKE,
+static struct trace_event trace_ctx_event = {
+	.type		= TRACE_CTX,
+	.funcs		= &trace_ctx_funcs,
+};
+
+static struct trace_event_functions trace_wake_funcs = {
 	.trace		= trace_wake_print,
 	.raw		= trace_wake_raw,
 	.hex		= trace_wake_hex,
 	.binary		= trace_ctxwake_bin,
 };
 
+static struct trace_event trace_wake_event = {
+	.type		= TRACE_WAKE,
+	.funcs		= &trace_wake_funcs,
+};
+
 /* TRACE_SPECIAL */
 static enum print_line_t trace_special_print(struct trace_iterator *iter,
-					     int flags)
+					     int flags, struct trace_event *event)
 {
 	struct special_entry *field;
 
@@ -1046,7 +1071,7 @@ static enum print_line_t trace_special_print(struct trace_iterator *iter,
 }
 
 static enum print_line_t trace_special_hex(struct trace_iterator *iter,
-					   int flags)
+					   int flags, struct trace_event *event)
 {
 	struct special_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1061,7 +1086,7 @@ static enum print_line_t trace_special_hex(struct trace_iterator *iter,
 }
 
 static enum print_line_t trace_special_bin(struct trace_iterator *iter,
-					   int flags)
+					   int flags, struct trace_event *event)
 {
 	struct special_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1075,18 +1100,22 @@ static enum print_line_t trace_special_bin(struct trace_iterator *iter,
 	return TRACE_TYPE_HANDLED;
 }
 
-static struct trace_event trace_special_event = {
-	.type		= TRACE_SPECIAL,
+static struct trace_event_functions trace_special_funcs = {
 	.trace		= trace_special_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
 	.binary		= trace_special_bin,
 };
 
+static struct trace_event trace_special_event = {
+	.type		= TRACE_SPECIAL,
+	.funcs		= &trace_special_funcs,
+};
+
 /* TRACE_STACK */
 
 static enum print_line_t trace_stack_print(struct trace_iterator *iter,
-					   int flags)
+					   int flags, struct trace_event *event)
 {
 	struct stack_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1114,17 +1143,21 @@ static enum print_line_t trace_stack_print(struct trace_iterator *iter,
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static struct trace_event trace_stack_event = {
-	.type		= TRACE_STACK,
+static struct trace_event_functions trace_stack_funcs = {
 	.trace		= trace_stack_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
 	.binary		= trace_special_bin,
 };
 
+static struct trace_event trace_stack_event = {
+	.type		= TRACE_STACK,
+	.funcs		= &trace_stack_funcs,
+};
+
 /* TRACE_USER_STACK */
 static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
-						int flags)
+						int flags, struct trace_event *event)
 {
 	struct userstack_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1143,17 +1176,22 @@ static enum print_line_t trace_user_stack_print(struct trace_iterator *iter,
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static struct trace_event trace_user_stack_event = {
-	.type		= TRACE_USER_STACK,
+static struct trace_event_functions trace_user_stack_funcs = {
 	.trace		= trace_user_stack_print,
 	.raw		= trace_special_print,
 	.hex		= trace_special_hex,
 	.binary		= trace_special_bin,
 };
 
+static struct trace_event trace_user_stack_event = {
+	.type		= TRACE_USER_STACK,
+	.funcs		= &trace_user_stack_funcs,
+};
+
 /* TRACE_BPRINT */
 static enum print_line_t
-trace_bprint_print(struct trace_iterator *iter, int flags)
+trace_bprint_print(struct trace_iterator *iter, int flags,
+		   struct trace_event *event)
 {
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *s = &iter->seq;
@@ -1178,7 +1216,8 @@ trace_bprint_print(struct trace_iterator *iter, int flags)
 
 
 static enum print_line_t
-trace_bprint_raw(struct trace_iterator *iter, int flags)
+trace_bprint_raw(struct trace_iterator *iter, int flags,
+		 struct trace_event *event)
 {
 	struct bprint_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1197,16 +1236,19 @@ trace_bprint_raw(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
+static struct trace_event_functions trace_bprint_funcs = {
+	.trace		= trace_bprint_print,
+	.raw		= trace_bprint_raw,
+};
 
 static struct trace_event trace_bprint_event = {
 	.type		= TRACE_BPRINT,
-	.trace		= trace_bprint_print,
-	.raw		= trace_bprint_raw,
+	.funcs		= &trace_bprint_funcs,
 };
 
 /* TRACE_PRINT */
 static enum print_line_t trace_print_print(struct trace_iterator *iter,
-					   int flags)
+					   int flags, struct trace_event *event)
 {
 	struct print_entry *field;
 	struct trace_seq *s = &iter->seq;
@@ -1225,7 +1267,8 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
+					 struct trace_event *event)
 {
 	struct print_entry *field;
 
@@ -1240,12 +1283,16 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static struct trace_event trace_print_event = {
-	.type	 	= TRACE_PRINT,
+static struct trace_event_functions trace_print_funcs = {
 	.trace		= trace_print_print,
 	.raw		= trace_print_raw,
 };
 
+static struct trace_event trace_print_event = {
+	.type	 	= TRACE_PRINT,
+	.funcs		= &trace_print_funcs,
+};
+
 
 static struct trace_event *events[] __initdata = {
 	&trace_fn_event,
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 9d91c72..c038eba 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -25,7 +25,7 @@ extern void trace_event_read_unlock(void);
 extern struct trace_event *ftrace_find_event(int type);
 
 extern enum print_line_t trace_nop_print(struct trace_iterator *iter,
-					 int flags);
+					 int flags, struct trace_event *event);
 extern int
 trace_print_lat_fmt(struct trace_seq *s, struct trace_entry *entry);
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 1c1b9bf..3751c81 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -93,7 +93,8 @@ static struct syscall_metadata *syscall_nr_to_meta(int nr)
 }
 
 enum print_line_t
-print_syscall_enter(struct trace_iterator *iter, int flags)
+print_syscall_enter(struct trace_iterator *iter, int flags,
+		    struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *ent = iter->ent;
@@ -145,7 +146,8 @@ end:
 }
 
 enum print_line_t
-print_syscall_exit(struct trace_iterator *iter, int flags)
+print_syscall_exit(struct trace_iterator *iter, int flags,
+		   struct trace_event *event)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *ent = iter->ent;
-- 
1.7.0


