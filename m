Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab0EKDJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 23:09:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36227 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0EKDJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 23:09:12 -0400
X-Authority-Analysis: v=1.1 cv=GuuPm/R9MDBdMhOgsQZYzj+bBK5woo0X8cuc0sTVRtI= c=1 sm=0 a=Yb4RpWuJWxsA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=1MKAjXN5lkaQoIJQ5rwA:9 a=e8GDxtnQxkPPTL-WRr4A:7 a=QyExK7bKs8EKHx34bQKfzEk86mwA:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100511030909.214870112@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 May 2010 23:00:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/10 -v3][RFC] tracing: Create class struct for events
References: <20100511030020.837892321@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Create-class-struct-for-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch creates a ftrace_event_class struct that event structs point to.
This class struct will be made to hold information to modify the
events. Currently the class struct only holds the events system name.

This patch slightly increases the size of the text as well as decreases
the data size. The overall change is still a slight increase, but
this change lays the ground work of other changes to make the footprint
of tracepoints smaller.

With 82 standard tracepoints, and 616 system call tracepoints:

   text	   data	    bss	    dec	    hex	filename
5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
5792282	1333796	9351592	16477670	 fb6de6	vmlinux.class

This patch also cleans up some stale comments in ftrace.h.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |    6 ++++-
 include/linux/syscalls.h           |    6 +++-
 include/trace/ftrace.h             |   40 +++++++++++++++--------------------
 kernel/trace/trace_events.c        |   20 +++++++++---------
 kernel/trace/trace_events_filter.c |    6 ++--
 kernel/trace/trace_export.c        |    6 ++++-
 kernel/trace/trace_kprobe.c        |   12 +++++-----
 kernel/trace/trace_syscalls.c      |    4 +++
 8 files changed, 54 insertions(+), 46 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 39e71b0..496eea8 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -113,10 +113,14 @@ void tracing_record_cmdline(struct task_struct *tsk);
 
 struct event_filter;
 
+struct ftrace_event_class {
+	char			*system;
+};
+
 struct ftrace_event_call {
 	struct list_head	list;
+	struct ftrace_event_class *class;
 	char			*name;
-	char			*system;
 	struct dentry		*dir;
 	struct trace_event	*event;
 	int			enabled;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 057929b..ac5791d 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -134,6 +134,8 @@ struct perf_event_attr;
 #define __SC_STR_TDECL5(t, a, ...)	#t, __SC_STR_TDECL4(__VA_ARGS__)
 #define __SC_STR_TDECL6(t, a, ...)	#t, __SC_STR_TDECL5(__VA_ARGS__)
 
+extern struct ftrace_event_class event_class_syscalls;
+
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
 	static const struct syscall_metadata __syscall_meta_##sname;	\
 	static struct ftrace_event_call					\
@@ -146,7 +148,7 @@ struct perf_event_attr;
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
-		.system                 = "syscalls",			\
+		.class			= &event_class_syscalls,	\
 		.event                  = &enter_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
 		.define_fields		= syscall_enter_define_fields,	\
@@ -168,7 +170,7 @@ struct perf_event_attr;
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
-		.system                 = "syscalls",			\
+		.class			= &event_class_syscalls,	\
 		.event                  = &exit_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
 		.define_fields		= syscall_exit_define_fields,	\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 75dd778..d5ec9d1 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -62,7 +62,10 @@
 		struct trace_entry	ent;				\
 		tstruct							\
 		char			__data[0];			\
-	};
+	};								\
+									\
+	static struct ftrace_event_class event_class_##name;
+
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)	\
 	static struct ftrace_event_call			\
@@ -430,22 +433,6 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *
  * Override the macros in <trace/trace_events.h> to include the following:
  *
- * static void ftrace_event_<call>(proto)
- * {
- *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
- * }
- *
- * static int ftrace_reg_event_<call>(struct ftrace_event_call *unused)
- * {
- *	return register_trace_<call>(ftrace_event_<call>);
- * }
- *
- * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
- * {
- *	unregister_trace_<call>(ftrace_event_<call>);
- * }
- *
- *
  * For those macros defined with TRACE_EVENT:
  *
  * static struct ftrace_event_call event_<call>;
@@ -497,14 +484,18 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *
  * static const char print_fmt_<call>[] = <TP_printk>;
  *
+ * static struct ftrace_event_class __used event_class_<template> = {
+ *	.system			= "<system>",
+ * }
+ *
  * static struct ftrace_event_call __used
  * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
  *	.name			= "<call>",
- *	.system			= "<system>",
+ *	.class			= event_class_<template>,
  *	.raw_init		= trace_event_raw_init,
- *	.regfunc		= ftrace_reg_event_<call>,
- *	.unregfunc		= ftrace_unreg_event_<call>,
+ *	.regfunc		= ftrace_raw_reg_event_<call>,
+ *	.unregfunc		= ftrace_raw_unreg_event_<call>,
  *	.print_fmt		= print_fmt_<call>,
  *	.define_fields		= ftrace_define_fields_<call>,
  * }
@@ -627,7 +618,10 @@ static struct trace_event ftrace_event_type_##call = {			\
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
-static const char print_fmt_##call[] = print;
+static const char print_fmt_##call[] = print;				\
+static struct ftrace_event_class __used event_class_##call = {		\
+	.system			= __stringify(TRACE_SYSTEM)		\
+}
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
@@ -636,7 +630,7 @@ static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
-	.system			= __stringify(TRACE_SYSTEM),		\
+	.class			= &event_class_##template,		\
 	.event			= &ftrace_event_type_##call,		\
 	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
@@ -655,7 +649,7 @@ static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
-	.system			= __stringify(TRACE_SYSTEM),		\
+	.class			= &event_class_##template,		\
 	.event			= &ftrace_event_type_##call,		\
 	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c697c70..2f54b48 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -176,10 +176,10 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
 
 		if (match &&
 		    strcmp(match, call->name) != 0 &&
-		    strcmp(match, call->system) != 0)
+		    strcmp(match, call->class->system) != 0)
 			continue;
 
-		if (sub && strcmp(sub, call->system) != 0)
+		if (sub && strcmp(sub, call->class->system) != 0)
 			continue;
 
 		if (event && strcmp(event, call->name) != 0)
@@ -355,8 +355,8 @@ static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_event_call *call = v;
 
-	if (strcmp(call->system, TRACE_SYSTEM) != 0)
-		seq_printf(m, "%s:", call->system);
+	if (strcmp(call->class->system, TRACE_SYSTEM) != 0)
+		seq_printf(m, "%s:", call->class->system);
 	seq_printf(m, "%s\n", call->name);
 
 	return 0;
@@ -453,7 +453,7 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		if (!call->name || !call->regfunc)
 			continue;
 
-		if (system && strcmp(call->system, system) != 0)
+		if (system && strcmp(call->class->system, system) != 0)
 			continue;
 
 		/*
@@ -925,8 +925,8 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	 * If the trace point header did not define TRACE_SYSTEM
 	 * then the system would be called "TRACE_SYSTEM".
 	 */
-	if (strcmp(call->system, TRACE_SYSTEM) != 0)
-		d_events = event_subsystem_dir(call->system, d_events);
+	if (strcmp(call->class->system, TRACE_SYSTEM) != 0)
+		d_events = event_subsystem_dir(call->class->system, d_events);
 
 	call->dir = debugfs_create_dir(call->name, d_events);
 	if (!call->dir) {
@@ -1041,7 +1041,7 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 	list_del(&call->list);
 	trace_destroy_fields(call);
 	destroy_preds(call);
-	remove_subsystem_dir(call->system);
+	remove_subsystem_dir(call->class->system);
 }
 
 /* Remove an event_call */
@@ -1399,8 +1399,8 @@ static __init void event_trace_self_tests(void)
  * syscalls as we test.
  */
 #ifndef CONFIG_EVENT_TRACE_TEST_SYSCALLS
-		if (call->system &&
-		    strcmp(call->system, "syscalls") == 0)
+		if (call->class->system &&
+		    strcmp(call->class->system, "syscalls") == 0)
 			continue;
 #endif
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 88c0b6d..ca32960 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -628,7 +628,7 @@ static int init_subsystem_preds(struct event_subsystem *system)
 		if (!call->define_fields)
 			continue;
 
-		if (strcmp(call->system, system->name) != 0)
+		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
 		err = init_preds(call);
@@ -647,7 +647,7 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 		if (!call->define_fields)
 			continue;
 
-		if (strcmp(call->system, system->name) != 0)
+		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
 		filter_disable_preds(call);
@@ -1252,7 +1252,7 @@ static int replace_system_preds(struct event_subsystem *system,
 		if (!call->define_fields)
 			continue;
 
-		if (strcmp(call->system, system->name) != 0)
+		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
 		/* try to see if the filter can be applied */
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index e091f64..7f16e21 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -18,6 +18,10 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM	ftrace
 
+struct ftrace_event_class event_class_ftrace = {
+	.system			= __stringify(TRACE_SYSTEM),
+};
+
 /* not needed for this file */
 #undef __field_struct
 #define __field_struct(type, item)
@@ -160,7 +164,7 @@ __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.id			= type,					\
-	.system			= __stringify(TRACE_SYSTEM),		\
+	.class			= &event_class_ftrace,			\
 	.raw_init		= ftrace_raw_init_event,		\
 	.print_fmt		= print,				\
 	.define_fields		= ftrace_define_fields_##call,		\
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1251e36..eda220b 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -332,8 +332,8 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 		goto error;
 	}
 
-	tp->call.system = kstrdup(group, GFP_KERNEL);
-	if (!tp->call.system)
+	tp->call.class->system = kstrdup(group, GFP_KERNEL);
+	if (!tp->call.class->system)
 		goto error;
 
 	INIT_LIST_HEAD(&tp->list);
@@ -361,7 +361,7 @@ static void free_trace_probe(struct trace_probe *tp)
 	for (i = 0; i < tp->nr_args; i++)
 		free_probe_arg(&tp->args[i]);
 
-	kfree(tp->call.system);
+	kfree(tp->call.class->system);
 	kfree(tp->call.name);
 	kfree(tp->symbol);
 	kfree(tp);
@@ -374,7 +374,7 @@ static struct trace_probe *find_probe_event(const char *event,
 
 	list_for_each_entry(tp, &probe_list, list)
 		if (strcmp(tp->call.name, event) == 0 &&
-		    strcmp(tp->call.system, group) == 0)
+		    strcmp(tp->call.class->system, group) == 0)
 			return tp;
 	return NULL;
 }
@@ -399,7 +399,7 @@ static int register_trace_probe(struct trace_probe *tp)
 	mutex_lock(&probe_lock);
 
 	/* register as an event */
-	old_tp = find_probe_event(tp->call.name, tp->call.system);
+	old_tp = find_probe_event(tp->call.name, tp->call.class->system);
 	if (old_tp) {
 		/* delete old event */
 		unregister_trace_probe(old_tp);
@@ -798,7 +798,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	char buf[MAX_ARGSTR_LEN + 1];
 
 	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
-	seq_printf(m, ":%s/%s", tp->call.system, tp->call.name);
+	seq_printf(m, ":%s/%s", tp->call.class->system, tp->call.name);
 
 	if (!tp->symbol)
 		seq_printf(m, " 0x%p", tp->rp.kp.addr);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4d6d711..d036a74 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -15,6 +15,10 @@ static int sys_refcount_exit;
 static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
 static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
+struct ftrace_event_class event_class_syscalls = {
+	.system			= "syscalls"
+};
+
 extern unsigned long __start_syscalls_metadata[];
 extern unsigned long __stop_syscalls_metadata[];
 
-- 
1.7.0


