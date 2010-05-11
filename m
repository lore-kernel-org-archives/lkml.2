Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab0EKDKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:10:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36227 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab0EKDJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:09:13 -0400
X-Authority-Analysis: v=1.1 cv=GuuPm/R9MDBdMhOgsQZYzj+bBK5woo0X8cuc0sTVRtI= c=1 sm=0 a=zQuhXZngtzcA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=7d_E57ReAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=meBN8sMzOjX0nyEOL4sA:9 a=y_INiaS9UT7qv9ICb98A:7 a=oT6Qa7tZo6OZpT_VwljK7VPYdmIA:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=D6-X0JM3zdQA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100511030910.502469997@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 May 2010 23:00:25 -0400
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
Subject: [PATCH 05/10 -v3][RFC] tracing: Move fields from event to class structure
References: <20100511030020.837892321@goodmis.org>
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

v2:  Fixed the syscall fields. The syscall metadata needs a list
     of fields for both enter and exit.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |    5 ++-
 include/linux/syscalls.h           |   14 ++++++----
 include/trace/ftrace.h             |   11 ++++---
 include/trace/syscall.h            |    4 +-
 kernel/trace/trace.h               |    3 ++
 kernel/trace/trace_events.c        |   48 +++++++++++++++++++++++++++---------
 kernel/trace/trace_events_filter.c |   10 ++++---
 kernel/trace/trace_export.c        |   14 +++++-----
 kernel/trace/trace_kprobe.c        |    8 +++---
 kernel/trace/trace_syscalls.c      |   31 ++++++++++++++++++++---
 10 files changed, 102 insertions(+), 46 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index e665ed3..479c3c1 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -130,6 +130,9 @@ struct ftrace_event_class {
 #endif
 	int			(*reg)(struct ftrace_event_call *event,
 				       enum trace_reg type);
+	int			(*define_fields)(struct ftrace_event_call *);
+	struct list_head	*(*get_fields)(struct ftrace_event_call *);
+	struct list_head	fields;
 };
 
 struct ftrace_event_call {
@@ -142,8 +145,6 @@ struct ftrace_event_call {
 	int			id;
 	const char		*print_fmt;
 	int			(*raw_init)(struct ftrace_event_call *);
-	int			(*define_fields)(struct ftrace_event_call *);
-	struct list_head	fields;
 	int			filter_active;
 	struct event_filter	*filter;
 	void			*mod;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e3348c4..fd0f1f2 100644
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
@@ -172,12 +170,14 @@ extern struct ftrace_event_class event_class_syscall_exit;
 		.args		= args_##sname,			\
 		.enter_event	= &event_enter_##sname,		\
 		.exit_event	= &event_exit_##sname,		\
+		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
+		.exit_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.exit_fields), \
 	};
 
 #define SYSCALL_DEFINE0(sname)					\
 	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
-	static const struct syscall_metadata __used		\
+	static struct syscall_metadata __used			\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta__##sname = {				\
@@ -185,6 +185,8 @@ extern struct ftrace_event_class event_class_syscall_exit;
 		.nb_args 	= 0,				\
 		.enter_event	= &event_enter__##sname,	\
 		.exit_event	= &event_exit__##sname,		\
+		.enter_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.enter_fields), \
+		.exit_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.exit_fields), \
 	};							\
 	asmlinkage long sys_##sname(void)
 #else
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 025dbbf..d387d01 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -430,6 +430,9 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *
  * static struct ftrace_event_class __used event_class_<template> = {
  *	.system			= "<system>",
+ *	.define_fields		= ftrace_define_fields_<call>,
+	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
+	.probe			= ftrace_raw_event_##call,		\
  * }
  *
  * static struct ftrace_event_call __used
@@ -438,10 +441,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	.name			= "<call>",
  *	.class			= event_class_<template>,
  *	.raw_init		= trace_event_raw_init,
- *	.regfunc		= ftrace_raw_reg_event_<call>,
- *	.unregfunc		= ftrace_raw_unreg_event_<call>,
+ *	.event			= &ftrace_event_type_<call>,
  *	.print_fmt		= print_fmt_<call>,
- *	.define_fields		= ftrace_define_fields_<call>,
  * }
  *
  */
@@ -563,6 +564,8 @@ _TRACE_PERF_PROTO(call, PARAMS(proto));					\
 static const char print_fmt_##call[] = print;				\
 static struct ftrace_event_class __used event_class_##call = {		\
 	.system			= __stringify(TRACE_SYSTEM),		\
+	.define_fields		= ftrace_define_fields_##call,		\
+	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
 	.probe			= ftrace_raw_event_##call,		\
 	_TRACE_PERF_INIT(call)						\
 }
@@ -578,7 +581,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.event			= &ftrace_event_type_##call,		\
 	.raw_init		= trace_event_raw_init,			\
 	.print_fmt		= print_fmt_##template,			\
-	.define_fields		= ftrace_define_fields_##template,	\
 }
 
 #undef DEFINE_EVENT_PRINT
@@ -594,7 +596,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.event			= &ftrace_event_type_##call,		\
 	.raw_init		= trace_event_raw_init,			\
 	.print_fmt		= print_fmt_##call,			\
-	.define_fields		= ftrace_define_fields_##template,	\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index e5e5f48..3964774 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -25,6 +25,8 @@ struct syscall_metadata {
 	int		nb_args;
 	const char	**types;
 	const char	**args;
+	struct list_head enter_fields;
+	struct list_head exit_fields;
 
 	struct ftrace_event_call *enter_event;
 	struct ftrace_event_call *exit_event;
@@ -34,8 +36,6 @@ struct syscall_metadata {
 extern unsigned long arch_syscall_addr(int nr);
 extern int init_syscall_trace(struct ftrace_event_call *call);
 
-extern int syscall_enter_define_fields(struct ftrace_event_call *call);
-extern int syscall_exit_define_fields(struct ftrace_event_call *call);
 extern int reg_event_syscall_enter(struct ftrace_event_call *call);
 extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
 extern int reg_event_syscall_exit(struct ftrace_event_call *call);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 911e986..c88c563 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -794,6 +794,9 @@ extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
 extern int filter_assign_type(const char *type);
 
+struct list_head *
+trace_get_fields(struct ftrace_event_call *event_call);
+
 static inline int
 filter_check_discard(struct ftrace_event_call *call, void *rec,
 		     struct ring_buffer *buffer,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0eb9b28..a446908 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -29,11 +29,23 @@ DEFINE_MUTEX(event_mutex);
 
 LIST_HEAD(ftrace_events);
 
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
+	if (WARN_ON(!call->class))
+		return 0;
 
 	field = kzalloc(sizeof(*field), GFP_KERNEL);
 	if (!field)
@@ -56,7 +68,8 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
 	field->size = size;
 	field->is_signed = is_signed;
 
-	list_add(&field->link, &call->fields);
+	head = trace_get_fields(call);
+	list_add(&field->link, head);
 
 	return 0;
 
@@ -94,8 +107,10 @@ static int trace_define_common_fields(struct ftrace_event_call *call)
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
@@ -111,7 +126,6 @@ int trace_event_raw_init(struct ftrace_event_call *call)
 	if (!id)
 		return -ENODEV;
 	call->id = id;
-	INIT_LIST_HEAD(&call->fields);
 
 	return 0;
 }
@@ -537,6 +551,7 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 {
 	struct ftrace_event_call *call = filp->private_data;
 	struct ftrace_event_field *field;
+	struct list_head *head;
 	struct trace_seq *s;
 	int common_field_count = 5;
 	char *buf;
@@ -555,7 +570,8 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_printf(s, "ID: %d\n", call->id);
 	trace_seq_printf(s, "format:\n");
 
-	list_for_each_entry_reverse(field, &call->fields, link) {
+	head = trace_get_fields(call);
+	list_for_each_entry_reverse(field, head, link) {
 		/*
 		 * Smartly shows the array type(except dynamic array).
 		 * Normal:
@@ -931,6 +947,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		 const struct file_operations *filter,
 		 const struct file_operations *format)
 {
+	struct list_head *head;
 	int ret;
 
 	/*
@@ -955,14 +972,21 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		trace_create_file("id", 0444, call->dir, call,
 		 		  id);
 
-	if (call->define_fields) {
-		ret = trace_define_common_fields(call);
-		if (!ret)
-			ret = call->define_fields(call);
-		if (ret < 0) {
-			pr_warning("Could not initialize trace point"
-				   " events/%s\n", call->name);
-			return ret;
+	if (call->class->define_fields) {
+		/*
+		 * Other events may have the same class. Only update
+		 * the fields if they are not already defined.
+		 */
+		head = trace_get_fields(call);
+		if (list_empty(head)) {
+			ret = trace_define_common_fields(call);
+			if (!ret)
+				ret = call->class->define_fields(call);
+			if (ret < 0) {
+				pr_warning("Could not initialize trace point"
+					   " events/%s\n", call->name);
+				return ret;
+			}
 		}
 		trace_create_file("filter", 0644, call->dir, call,
 				  filter);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index ca32960..961f99b 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -500,8 +500,10 @@ static struct ftrace_event_field *
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
@@ -625,7 +627,7 @@ static int init_subsystem_preds(struct event_subsystem *system)
 	int err;
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (!call->define_fields)
+		if (!call->class || !call->class->define_fields)
 			continue;
 
 		if (strcmp(call->class->system, system->name) != 0)
@@ -644,7 +646,7 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 	struct ftrace_event_call *call;
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (!call->define_fields)
+		if (!call->class || !call->class->define_fields)
 			continue;
 
 		if (strcmp(call->class->system, system->name) != 0)
@@ -1249,7 +1251,7 @@ static int replace_system_preds(struct event_subsystem *system,
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
index a21d366..cceccf0 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -20,14 +20,37 @@ static int syscall_enter_register(struct ftrace_event_call *event,
 static int syscall_exit_register(struct ftrace_event_call *event,
 				 enum trace_reg type);
 
+static int syscall_enter_define_fields(struct ftrace_event_call *call);
+static int syscall_exit_define_fields(struct ftrace_event_call *call);
+
+static struct list_head *
+syscall_get_enter_fields(struct ftrace_event_call *call)
+{
+	struct syscall_metadata *entry = call->data;
+
+	return &entry->enter_fields;
+}
+
+static struct list_head *
+syscall_get_exit_fields(struct ftrace_event_call *call)
+{
+	struct syscall_metadata *entry = call->data;
+
+	return &entry->exit_fields;
+}
+
 struct ftrace_event_class event_class_syscall_enter = {
 	.system			= "syscalls",
-	.reg			= syscall_enter_register
+	.reg			= syscall_enter_register,
+	.define_fields		= syscall_enter_define_fields,
+	.get_fields		= syscall_get_enter_fields,
 };
 
 struct ftrace_event_class event_class_syscall_exit = {
 	.system			= "syscalls",
-	.reg			= syscall_exit_register
+	.reg			= syscall_exit_register,
+	.define_fields		= syscall_exit_define_fields,
+	.get_fields		= syscall_get_exit_fields,
 };
 
 extern unsigned long __start_syscalls_metadata[];
@@ -220,7 +243,7 @@ static void free_syscall_print_fmt(struct ftrace_event_call *call)
 		kfree(call->print_fmt);
 }
 
-int syscall_enter_define_fields(struct ftrace_event_call *call)
+static int syscall_enter_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_enter trace;
 	struct syscall_metadata *meta = call->data;
@@ -243,7 +266,7 @@ int syscall_enter_define_fields(struct ftrace_event_call *call)
 	return ret;
 }
 
-int syscall_exit_define_fields(struct ftrace_event_call *call)
+static int syscall_exit_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_exit trace;
 	int ret;
-- 
1.7.0


