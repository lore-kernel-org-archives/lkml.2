Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab0EMWPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:15:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54346 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab0EMWMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:12:51 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=KyLEJWmUQqEA:10 a=yQWWgrYGNuUA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=n0Os9h9x7a7lgcQwEwEA:9 a=jLlLqsHzerqKD3o3LOYA:7 a=fhtKje-1JIYNJPs6tkzkEBytzd8A:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100513221249.097658111@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 May 2010 18:10:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 08/12 v2] tracing: Move print functions into event class
References: <20100513221004.765293881@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Move-print-functions-into-event-class.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently, every event has its own trace_event structure. This is
fine since the structure is needed anyway. But the print function
structure (trace_event_functions) is now separate. Since the output
of the trace event is done by the class (with the exception of events
defined by DEFINE_EVENT_PRINT), it makes sense to have the class
define the print functions that all events in the class can use.

This makes a bigger deal with the syscall events since all syscall events
use the same class. The savings here is another 30K.

   text	   data	    bss	    dec	    hex	filename
4913961	1088356	 861512	6863829	 68bbd5	vmlinux.orig
4900382	1048964	 861512	6810858	 67ecea	vmlinux.init
4900446	1049028	 861512	6810986	 67ed6a	vmlinux.preprint
4895024	1023812	 861512	6780348	 6775bc	vmlinux.print

To accomplish this, and to let the class know what event is being
printed, the event structure is embedded in the ftrace_event_call
structure. This should not be an issues since the event structure
was created for each event anyway.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h  |    2 +-
 include/linux/syscalls.h      |   18 +++------------
 include/trace/ftrace.h        |   45 +++++++++++++++++-----------------------
 kernel/trace/trace_events.c   |    6 ++--
 kernel/trace/trace_kprobe.c   |   14 +++++-------
 kernel/trace/trace_syscalls.c |    8 +++++++
 6 files changed, 41 insertions(+), 52 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4f77932..b1a007d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -148,7 +148,7 @@ struct ftrace_event_call {
 	struct ftrace_event_class *class;
 	char			*name;
 	struct dentry		*dir;
-	struct trace_event	*event;
+	struct trace_event	event;
 	int			enabled;
 	int			id;
 	const char		*print_fmt;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f725677..a1a86a5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -120,24 +120,20 @@ struct perf_event_attr;
 
 extern struct ftrace_event_class event_class_syscall_enter;
 extern struct ftrace_event_class event_class_syscall_exit;
+extern struct trace_event_functions enter_syscall_print_funcs;
+extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
 	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_enter_##sname;		\
-	static struct trace_event_functions enter_syscall_print_funcs_##sname = { \
-		.trace                  = print_syscall_enter,		\
-	};								\
-	static struct trace_event enter_syscall_print_##sname = {	\
-		.funcs                  = &enter_syscall_print_funcs_##sname, \
-	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
 		.class			= &event_class_syscall_enter,	\
-		.event                  = &enter_syscall_print_##sname,	\
+		.event.funcs            = &enter_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 	}
 
@@ -145,19 +141,13 @@ extern struct ftrace_event_class event_class_syscall_exit;
 	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_exit_##sname;		\
-	static struct trace_event_functions exit_syscall_print_funcs_##sname = { \
-		.trace                  = print_syscall_exit,		\
-	};								\
-	static struct trace_event exit_syscall_print_##sname = {	\
-		.funcs                  = &exit_syscall_print_funcs_##sname, \
-	};								\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
 		.class			= &event_class_syscall_exit,	\
-		.event                  = &exit_syscall_print_##sname,	\
+		.event.funcs		= &exit_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 	}
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 51ed7f3..824141d 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -206,18 +206,22 @@
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace enum print_line_t					\
-ftrace_raw_output_id_##call(int event_id, const char *name,		\
-			    struct trace_iterator *iter, int flags)	\
+ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
+			 struct trace_event *trace_event)		\
 {									\
+	struct ftrace_event_call *event;				\
 	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##call *field;				\
 	struct trace_entry *entry;					\
 	struct trace_seq *p;						\
 	int ret;							\
 									\
+	event = container_of(trace_event, struct ftrace_event_call,	\
+			     event);					\
+									\
 	entry = iter->ent;						\
 									\
-	if (entry->type != event_id) {					\
+	if (entry->type != event->id) {					\
 		WARN_ON_ONCE(1);					\
 		return TRACE_TYPE_UNHANDLED;				\
 	}								\
@@ -226,7 +230,7 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 									\
 	p = &get_cpu_var(ftrace_event_seq);				\
 	trace_seq_init(p);						\
-	ret = trace_seq_printf(s, "%s: ", name);			\
+	ret = trace_seq_printf(s, "%s: ", event->name);			\
 	if (ret)							\
 		ret = trace_seq_printf(s, print);			\
 	put_cpu();							\
@@ -234,17 +238,10 @@ ftrace_raw_output_id_##call(int event_id, const char *name,		\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
 	return TRACE_TYPE_HANDLED;					\
-}
-
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)			\
-static notrace enum print_line_t					\
-ftrace_raw_output_##name(struct trace_iterator *iter, int flags,	\
-			 struct trace_event *event)			\
-{									\
-	return ftrace_raw_output_id_##template(event_##name.id,		\
-					       #name, iter, flags);	\
-}
+}									\
+static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
+	.trace			= ftrace_raw_output_##call,		\
+};
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
@@ -277,7 +274,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
 	return TRACE_TYPE_HANDLED;					\
-}
+}									\
+static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
+	.trace			= ftrace_raw_output_##call,		\
+};
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
@@ -533,20 +533,13 @@ ftrace_raw_event_##call(void *__data, proto)				\
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
-static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
-	.trace			= ftrace_raw_output_##call,		\
-};									\
-static struct trace_event ftrace_event_type_##call = {			\
-	.funcs			= &ftrace_event_type_funcs_##call,	\
-};									\
 static inline void ftrace_test_probe_##call(void)			\
 {									\
 	check_trace_callback_type_##call(ftrace_raw_event_##template);	\
 }
 
 #undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
@@ -582,7 +575,7 @@ __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
-	.event			= &ftrace_event_type_##call,		\
+	.event.funcs		= &ftrace_event_type_funcs_##template,	\
 	.print_fmt		= print_fmt_##template,			\
 };
 
@@ -596,7 +589,7 @@ __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
-	.event			= &ftrace_event_type_##call,		\
+	.event.funcs		= &ftrace_event_type_funcs_##call,	\
 	.print_fmt		= print_fmt_##call,			\
 }
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 683ab3f..845805d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -122,7 +122,7 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 {
 	int id;
 
-	id = register_ftrace_event(call->event);
+	id = register_ftrace_event(&call->event);
 	if (!id)
 		return -ENODEV;
 	call->id = id;
@@ -1071,8 +1071,8 @@ static void remove_subsystem_dir(const char *name)
 static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
 	ftrace_event_enable_disable(call, 0);
-	if (call->event)
-		__unregister_ftrace_event(call->event);
+	if (call->event.funcs)
+		__unregister_ftrace_event(&call->event);
 	debugfs_remove_recursive(call->dir);
 	list_del(&call->list);
 	trace_destroy_fields(call);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index b989ae2..d8061c3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -204,7 +204,6 @@ struct trace_probe {
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
-	struct trace_event		event;
 	unsigned int		nr_args;
 	struct probe_arg	args[];
 };
@@ -1020,7 +1019,7 @@ print_kprobe_event(struct trace_iterator *iter, int flags,
 	int i;
 
 	field = (struct kprobe_trace_entry *)iter->ent;
-	tp = container_of(event, struct trace_probe, event);
+	tp = container_of(event, struct trace_probe, call.event);
 
 	if (!trace_seq_printf(s, "%s: (", tp->call.name))
 		goto partial;
@@ -1054,7 +1053,7 @@ print_kretprobe_event(struct trace_iterator *iter, int flags,
 	int i;
 
 	field = (struct kretprobe_trace_entry *)iter->ent;
-	tp = container_of(event, struct trace_probe, event);
+	tp = container_of(event, struct trace_probe, call.event);
 
 	if (!trace_seq_printf(s, "%s: (", tp->call.name))
 		goto partial;
@@ -1364,20 +1363,19 @@ static int register_probe_event(struct trace_probe *tp)
 
 	/* Initialize ftrace_event_call */
 	if (probe_is_return(tp)) {
-		tp->event.funcs = &kretprobe_funcs;
 		INIT_LIST_HEAD(&call->class->fields);
+		call->event.funcs = &kretprobe_funcs;
 		call->class->raw_init = probe_event_raw_init;
 		call->class->define_fields = kretprobe_event_define_fields;
 	} else {
 		INIT_LIST_HEAD(&call->class->fields);
-		tp->event.funcs = &kprobe_funcs;
+		call->event.funcs = &kprobe_funcs;
 		call->class->raw_init = probe_event_raw_init;
 		call->class->define_fields = kprobe_event_define_fields;
 	}
 	if (set_print_fmt(tp) < 0)
 		return -ENOMEM;
-	call->event = &tp->event;
-	call->id = register_ftrace_event(&tp->event);
+	call->id = register_ftrace_event(&call->event);
 	if (!call->id) {
 		kfree(call->print_fmt);
 		return -ENODEV;
@@ -1389,7 +1387,7 @@ static int register_probe_event(struct trace_probe *tp)
 	if (ret) {
 		pr_info("Failed to register kprobe event: %s\n", call->name);
 		kfree(call->print_fmt);
-		unregister_ftrace_event(&tp->event);
+		unregister_ftrace_event(&call->event);
 	}
 	return ret;
 }
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 3751c81..7c7cfe9 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -39,6 +39,14 @@ syscall_get_exit_fields(struct ftrace_event_call *call)
 	return &entry->exit_fields;
 }
 
+struct trace_event_functions enter_syscall_print_funcs = {
+	.trace                  = print_syscall_enter,
+};
+
+struct trace_event_functions exit_syscall_print_funcs = {
+	.trace                  = print_syscall_exit,
+};
+
 struct ftrace_event_class event_class_syscall_enter = {
 	.system			= "syscalls",
 	.reg			= syscall_enter_register,
-- 
1.7.0


