Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab0DZUEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:04:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab0DZUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:02:45 -0400
X-Authority-Analysis: v=1.1 cv=2/WNtoURsBD4grC4Rqfj62/w1mAETqRJkFX1sgq41IM= c=1 sm=0 a=gbPtx3RPhRoA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=2_17gA6sb-6lC0Te0AMA:9 a=_Ug0llfOD3EkP8ajJKQA:7 a=IiRoLaONWjF7YGd_Z7JCKaRT3mUA:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100426200242.470116062@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 26 Apr 2010 15:50:29 -0400
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
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 05/10][RFC] tracing: Move fields from event to class structure
References: <20100426195024.256424113@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Move-fields-from-event-to-class-structure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Move the defined fields from the event to the class structure.
Since the fields of the event are defined by the class they belong
to, it makes sense to have the class hold the information instead
of the individual events. The events of the same class would just
hold duplicate information.

After this change the size of the kernel dropped another 8K:

   text	   data	    bss	    dec	    hex	filename
5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
5774316	1306580	9351592	16432488	 fabd68	vmlinux.reg
5774503	1297492	9351592	16423587	 fa9aa3	vmlinux.fields

Although the text increased, this was mainly due to the C files
having to adapt to the change. This is a constant increase, where
new tracepoints will not increase the Text. But the big drop is
in the data size (as well as needed allocations to hold the fields).
This will give even more savings as more tracepoints are created.

Note, if just TRACE_EVENT()s are used and not DECLARE_EVENT_CLASS()
with several DEFINE_EVENT()s, then the savings will be lost. But
we are pushing developers to consolidate events with DEFINE_EVENT()
so this should not be an issue.

The kprobes define a unique class to every new event, but are dynamic
so it should not be a issue.

The syscalls however have a single class but the fields for the individual
events are different. The syscalls use a metadata to define the
fields. I moved the fields list from the event to the metadata and
added a "get_fields()" function to the class. This function is used
to find the fields. For normal events and kprobes, get_fields() just
returns a pointer to the fields list_head in the class. For syscall
events, it returns the fields list_head in the metadata for the event.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |    5 ++-
 include/linux/syscalls.h           |   12 +++++-----
 include/trace/ftrace.h             |   10 +++++---
 include/trace/syscall.h            |    3 +-
 kernel/trace/trace.h               |    3 ++
 kernel/trace/trace_events.c        |   43 +++++++++++++++++++++++++++++++-----
 kernel/trace/trace_events_filter.c |   10 +++++---
 kernel/trace/trace_export.c        |   14 ++++++------
 kernel/trace/trace_kprobe.c        |    8 +++---
 kernel/trace/trace_syscalls.c      |   23 ++++++++++++++++---
 10 files changed, 92 insertions(+), 39 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index dd0051e..1e2c8f5 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -128,6 +128,9 @@ struct ftrace_event_class {
 	void			*perf_probe;
 	int			(*reg)(struct ftrace_event_call *event,
 				       enum trace_reg type);
+	int			(*define_fields)(struct ftrace_event_call *);
+	struct list_head	*(*get_fields)(struct ftrace_event_call *);
+	struct list_head	fields;
 };
 
 struct ftrace_event_call {
@@ -140,8 +143,6 @@ struct ftrace_event_call {
 	int			id;
 	const char		*print_fmt;
 	int			(*raw_init)(struct ftrace_event_call *);
-	int			(*define_fields)(struct ftrace_event_call *);
-	struct list_head	fields;
 	int			filter_active;
 	struct event_filter	*filter;
 	void			*mod;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e3348c4..ef4f81c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -122,7 +122,7 @@ extern struct ftrace_event_class event_class_syscall_enter;
 extern struct ftrace_event_class event_class_syscall_exit;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
-	static const struct syscall_metadata __syscall_meta_##sname;	\
+	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_enter_##sname;		\
 	static struct trace_event enter_syscall_print_##sname = {	\
@@ -136,12 +136,11 @@ extern struct ftrace_event_class event_class_syscall_exit;
 		.class			= &event_class_syscall_enter,	\
 		.event                  = &enter_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
-		.define_fields		= syscall_enter_define_fields,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
-	static const struct syscall_metadata __syscall_meta_##sname;	\
+	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call					\
 	__attribute__((__aligned__(4))) event_exit_##sname;		\
 	static struct trace_event exit_syscall_print_##sname = {	\
@@ -155,14 +154,13 @@ extern struct ftrace_event_class event_class_syscall_exit;
 		.class			= &event_class_syscall_exit,	\
 		.event                  = &exit_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
-		.define_fields		= syscall_exit_define_fields,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 	}
 
 #define SYSCALL_METADATA(sname, nb)				\
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
-	static const struct syscall_metadata __used		\
+	static struct syscall_metadata __used			\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
@@ -172,12 +170,13 @@ extern struct ftrace_event_class event_class_syscall_exit;
 		.args		= args_##sname,			\
 		.enter_event	= &event_enter_##sname,		\
 		.exit_event	= &event_exit_##sname,		\
+		.fields		= LIST_HEAD_INIT(__syscall_meta_##sname.fields), \
 	};
 
 #define SYSCALL_DEFINE0(sname)					\
 	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
-	static const struct syscall_metadata __used		\
+	static struct syscall_metadata __used			\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta__##sname = {				\
@@ -185,6 +184,7 @@ extern struct ftrace_event_class event_class_syscall_exit;
 		.nb_args 	= 0,				\
 		.enter_event	= &event_enter__##sname,	\
 		.exit_event	= &event_exit__##sname,		\
+		.fields		= LIST_HEAD_INIT(__syscall_meta__##sname.fields), \
 	};							\
 	asmlinkage long sys_##sname(void)
 #else
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 62fe622..e6ec392 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -429,6 +429,9 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *
  * static struct ftrace_event_class __used event_class_<template> = {
  *	.system			= "<system>",
+ *	.define_fields		= ftrace_define_fields_<call>,
+	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
+	.probe			= ftrace_raw_event_##call,		\
  * }
  *
  * static struct ftrace_event_call __used
@@ -437,10 +440,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	.name			= "<call>",
  *	.class			= event_class_<template>,
  *	.raw_init		= trace_event_raw_init,
- *	.regfunc		= ftrace_reg_event_<call>,
- *	.unregfunc		= ftrace_unreg_event_<call>,
+ *	.event			= &ftrace_event_type_<call>,
  *	.print_fmt		= print_fmt_<call>,
- *	.define_fields		= ftrace_define_fields_<call>,
  * }
  *
  */
@@ -552,6 +553,8 @@ _TRACE_PERF_PROTO(call, PARAMS(proto));					\
 static const char print_fmt_##call[] = print;				\
 static struct ftrace_event_class __used event_class_##call = {		\
 	.system			= __stringify(TRACE_SYSTEM),		\
+	.define_fields		= ftrace_define_fields_##call,		\
+	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
 	.probe			= ftrace_raw_event_##call,		\
 	_TRACE_PERF_INIT(call)						\
 }
@@ -567,7 +570,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.event			= &ftrace_event_type_##call,		\
 	.raw_init		= trace_event_raw_init,			\
 	.print_fmt		= print_fmt_##template,			\
-	.define_fields		= ftrace_define_fields_##template,	\
 }
 
 #undef DEFINE_EVENT_PRINT
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index e5e5f48..25087c3 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -25,6 +25,7 @@ struct syscall_metadata {
 	int		nb_args;
 	const char	**types;
 	const char	**args;
+	struct list_head fields;
 
 	struct ftrace_event_call *enter_event;
 	struct ftrace_event_call *exit_event;
@@ -34,8 +35,6 @@ struct syscall_metadata {
 extern unsigned long arch_syscall_addr(int nr);
 extern int init_syscall_trace(struct ftrace_event_call *call);
 
-extern int syscall_enter_define_fields(struct ftrace_event_call *call);
-extern int syscall_exit_define_fields(struct ftrace_event_call *call);
 extern int reg_event_syscall_enter(struct ftrace_event_call *call);
 extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
 extern int reg_event_syscall_exit(struct ftrace_event_call *call);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2825ef2..ff63bee 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -771,6 +771,9 @@ extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
 extern int filter_assign_type(const char *type);
 
+struct list_head *
+trace_get_fields(struct ftrace_event_call *event_call);
+
 static inline int
 filter_check_discard(struct ftrace_event_call *call, void *rec,
 		     struct ring_buffer *buffer,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f84cfcb..c31632e 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -28,11 +28,28 @@ DEFINE_MUTEX(event_mutex);
 
 LIST_HEAD(ftrace_events);
 
+static int fields_done(struct ftrace_event_call *event_call)
+{
+	return 0;
+}
+
+struct list_head *
+trace_get_fields(struct ftrace_event_call *event_call)
+{
+	if (!event_call->class->get_fields)
+		return &event_call->class->fields;
+	return event_call->class->get_fields(event_call);
+}
+
 int trace_define_field(struct ftrace_event_call *call, const char *type,
 		       const char *name, int offset, int size, int is_signed,
 		       int filter_type)
 {
 	struct ftrace_event_field *field;
+	struct list_head *head;
+
+	if (WARN_ON(!call->class) || call->class->define_fields == fields_done)
+		return 0;
 
 	field = kzalloc(sizeof(*field), GFP_KERNEL);
 	if (!field)
@@ -55,7 +72,8 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
 	field->size = size;
 	field->is_signed = is_signed;
 
-	list_add(&field->link, &call->fields);
+	head = trace_get_fields(call);
+	list_add(&field->link, head);
 
 	return 0;
 
@@ -81,6 +99,9 @@ static int trace_define_common_fields(struct ftrace_event_call *call)
 	int ret;
 	struct trace_entry ent;
 
+	if (call->class->define_fields == fields_done)
+		return 0;
+
 	__common_field(unsigned short, type);
 	__common_field(unsigned char, flags);
 	__common_field(unsigned char, preempt_count);
@@ -93,8 +114,10 @@ static int trace_define_common_fields(struct ftrace_event_call *call)
 void trace_destroy_fields(struct ftrace_event_call *call)
 {
 	struct ftrace_event_field *field, *next;
+	struct list_head *head;
 
-	list_for_each_entry_safe(field, next, &call->fields, link) {
+	head = trace_get_fields(call);
+	list_for_each_entry_safe(field, next, head, link) {
 		list_del(&field->link);
 		kfree(field->type);
 		kfree(field->name);
@@ -110,7 +133,6 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 	if (!id)
 		return -ENODEV;
 	call->id = id;
-	INIT_LIST_HEAD(&call->fields);
 
 	return 0;
 }
@@ -536,6 +558,7 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 {
 	struct ftrace_event_call *call = filp->private_data;
 	struct ftrace_event_field *field;
+	struct list_head *head;
 	struct trace_seq *s;
 	int common_field_count = 5;
 	char *buf;
@@ -554,7 +577,8 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_printf(s, "ID: %d\n", call->id);
 	trace_seq_printf(s, "format:\n");
 
-	list_for_each_entry_reverse(field, &call->fields, link) {
+	head = trace_get_fields(call);
+	list_for_each_entry_reverse(field, head, link) {
 		/*
 		 * Smartly shows the array type(except dynamic array).
 		 * Normal:
@@ -954,10 +978,10 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		trace_create_file("id", 0444, call->dir, call,
 		 		  id);
 
-	if (call->define_fields) {
+	if (call->class->define_fields) {
 		ret = trace_define_common_fields(call);
 		if (!ret)
-			ret = call->define_fields(call);
+			ret = call->class->define_fields(call);
 		if (ret < 0) {
 			pr_warning("Could not initialize trace point"
 				   " events/%s\n", call->name);
@@ -965,6 +989,13 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		}
 		trace_create_file("filter", 0644, call->dir, call,
 				  filter);
+
+		/*
+		 * Other events with the same class will call
+		 * define fields again, Set the define_fields
+		 * to a stub, and it will be skipped.
+		 */
+		call->class->define_fields = fields_done;
 	}
 
 	trace_create_file("format", 0444, call->dir, call,
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 22fa89f..560683d 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -499,8 +499,10 @@ static struct ftrace_event_field *
 find_event_field(struct ftrace_event_call *call, char *name)
 {
 	struct ftrace_event_field *field;
+	struct list_head *head;
 
-	list_for_each_entry(field, &call->fields, link) {
+	head = trace_get_fields(call);
+	list_for_each_entry(field, head, link) {
 		if (!strcmp(field->name, name))
 			return field;
 	}
@@ -624,7 +626,7 @@ static int init_subsystem_preds(struct event_subsystem *system)
 	int err;
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (!call->define_fields)
+		if (!call->class || !call->class->define_fields)
 			continue;
 
 		if (strcmp(call->class->system, system->name) != 0)
@@ -643,7 +645,7 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 	struct ftrace_event_call *call;
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (!call->define_fields)
+		if (!call->class || !call->class->define_fields)
 			continue;
 
 		if (strcmp(call->class->system, system->name) != 0)
@@ -1248,7 +1250,7 @@ static int replace_system_preds(struct event_subsystem *system,
 	list_for_each_entry(call, &ftrace_events, list) {
 		struct event_filter *filter = call->filter;
 
-		if (!call->define_fields)
+		if (!call->class || !call->class->define_fields)
 			continue;
 
 		if (strcmp(call->class->system, system->name) != 0)
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 7f16e21..e700a0c 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -18,10 +18,6 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM	ftrace
 
-struct ftrace_event_class event_class_ftrace = {
-	.system			= __stringify(TRACE_SYSTEM),
-};
-
 /* not needed for this file */
 #undef __field_struct
 #define __field_struct(type, item)
@@ -131,7 +127,7 @@ ftrace_define_fields_##name(struct ftrace_event_call *event_call)	\
 
 static int ftrace_raw_init_event(struct ftrace_event_call *call)
 {
-	INIT_LIST_HEAD(&call->fields);
+	INIT_LIST_HEAD(&call->class->fields);
 	return 0;
 }
 
@@ -159,15 +155,19 @@ static int ftrace_raw_init_event(struct ftrace_event_call *call)
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, type, tstruct, print)		\
 									\
+struct ftrace_event_class event_class_ftrace_##call = {			\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.define_fields		= ftrace_define_fields_##call,		\
+};									\
+									\
 struct ftrace_event_call __used						\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.id			= type,					\
-	.class			= &event_class_ftrace,			\
+	.class			= &event_class_ftrace_##call,		\
 	.raw_init		= ftrace_raw_init_event,		\
 	.print_fmt		= print,				\
-	.define_fields		= ftrace_define_fields_##call,		\
 };									\
 
 #include "trace_entries.h"
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f8af21a..b14bf74 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1112,8 +1112,6 @@ static void probe_event_disable(struct ftrace_event_call *call)
 
 static int probe_event_raw_init(struct ftrace_event_call *event_call)
 {
-	INIT_LIST_HEAD(&event_call->fields);
-
 	return 0;
 }
 
@@ -1362,11 +1360,13 @@ static int register_probe_event(struct trace_probe *tp)
 	if (probe_is_return(tp)) {
 		tp->event.trace = print_kretprobe_event;
 		call->raw_init = probe_event_raw_init;
-		call->define_fields = kretprobe_event_define_fields;
+		INIT_LIST_HEAD(&call->class->fields);
+		call->class->define_fields = kretprobe_event_define_fields;
 	} else {
 		tp->event.trace = print_kprobe_event;
 		call->raw_init = probe_event_raw_init;
-		call->define_fields = kprobe_event_define_fields;
+		INIT_LIST_HEAD(&call->class->fields);
+		call->class->define_fields = kprobe_event_define_fields;
 	}
 	if (set_print_fmt(tp) < 0)
 		return -ENOMEM;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index c92934d..eb535ba 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -19,14 +19,29 @@ static int syscall_enter_register(struct ftrace_event_call *event,
 static int syscall_exit_register(struct ftrace_event_call *event,
 				 enum trace_reg type);
 
+static int syscall_enter_define_fields(struct ftrace_event_call *call);
+static int syscall_exit_define_fields(struct ftrace_event_call *call);
+
+static struct list_head *
+syscall_get_fields(struct ftrace_event_call *call)
+{
+	struct syscall_metadata *entry = call->data;
+
+	return &entry->fields;
+}
+
 struct ftrace_event_class event_class_syscall_enter = {
 	.system			= "syscalls",
-	.reg			= syscall_enter_register
+	.reg			= syscall_enter_register,
+	.define_fields		= syscall_enter_define_fields,
+	.get_fields		= syscall_get_fields,
 };
 
 struct ftrace_event_class event_class_syscall_exit = {
 	.system			= "syscalls",
-	.reg			= syscall_exit_register
+	.reg			= syscall_exit_register,
+	.define_fields		= syscall_exit_define_fields,
+	.get_fields		= syscall_get_fields,
 };
 
 extern unsigned long __start_syscalls_metadata[];
@@ -219,7 +234,7 @@ static void free_syscall_print_fmt(struct ftrace_event_call *call)
 		kfree(call->print_fmt);
 }
 
-int syscall_enter_define_fields(struct ftrace_event_call *call)
+static int syscall_enter_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_enter trace;
 	struct syscall_metadata *meta = call->data;
@@ -242,7 +257,7 @@ int syscall_enter_define_fields(struct ftrace_event_call *call)
 	return ret;
 }
 
-int syscall_exit_define_fields(struct ftrace_event_call *call)
+static int syscall_exit_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_exit trace;
 	int ret;
-- 
1.7.0


