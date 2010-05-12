Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0ELP3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:29:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33303 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0ELP25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:28:57 -0400
X-Authority-Analysis: v=1.1 cv=QBaIlYAip0cLYvdi/Wu3On4+kilSXYulM+a9j4asJ0c= c=1 sm=0 a=tllnUSBlRc0A:10 a=yQWWgrYGNuUA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=u4j5mRHdNQ9NR39BCW4A:9 a=MrzvD5-KPBXrZ9_uWLcA:7 a=e7ndZhkDXhfOkloJZ9o0Dx_k4tUA:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100512152853.786611299@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 12 May 2010 11:28:16 -0400
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
Subject: [PATCH 06/10 final] tracing: Move raw_init from events to class
References: <20100512152810.819338250@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Move-raw_init-from-events-to-class.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The raw_init function pointer in the event is used to initialize
various kinds of events. The type of initialization needed is usually
classed to the kind of event it is.

Two events with the same class will always have the same initialization
function, so it makes sense to move this to the class structure.

Perhaps even making a special system structure would work since
the initialization is the same for all events within a system.
But since there's no system structure (yet), this will just move it
to the class.

   text	   data	    bss	    dec	    hex	filename
4913961	1088356	 861512	6863829	 68bbd5	vmlinux.orig
4900375	1053380	 861512	6815267	 67fe23	vmlinux.fields
4900382	1048964	 861512	6810858	 67ecea	vmlinux.init

The text grew very slightly, but this is a constant growth that happened
with the changing of the C files that call the init code.
The bigger savings is the data which will be saved the more events share
a class.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h  |    2 +-
 include/linux/syscalls.h      |    2 --
 include/trace/ftrace.h        |    9 ++++-----
 kernel/trace/trace_events.c   |   12 ++++++------
 kernel/trace/trace_export.c   |    2 +-
 kernel/trace/trace_kprobe.c   |    6 +++---
 kernel/trace/trace_syscalls.c |    2 ++
 7 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 479c3c1..393a839 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -133,6 +133,7 @@ struct ftrace_event_class {
 	int			(*define_fields)(struct ftrace_event_call *);
 	struct list_head	*(*get_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
+	int			(*raw_init)(struct ftrace_event_call *);
 };
 
 struct ftrace_event_call {
@@ -144,7 +145,6 @@ struct ftrace_event_call {
 	int			enabled;
 	int			id;
 	const char		*print_fmt;
-	int			(*raw_init)(struct ftrace_event_call *);
 	int			filter_active;
 	struct event_filter	*filter;
 	void			*mod;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index fd0f1f2..211c704 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -135,7 +135,6 @@ extern struct ftrace_event_class event_class_syscall_exit;
 		.name                   = "sys_enter"#sname,		\
 		.class			= &event_class_syscall_enter,	\
 		.event                  = &enter_syscall_print_##sname,	\
-		.raw_init		= init_syscall_trace,		\
 		.data			= (void *)&__syscall_meta_##sname,\
 	}
 
@@ -153,7 +152,6 @@ extern struct ftrace_event_class event_class_syscall_exit;
 		.name                   = "sys_exit"#sname,		\
 		.class			= &event_class_syscall_exit,	\
 		.event                  = &exit_syscall_print_##sname,	\
-		.raw_init		= init_syscall_trace,		\
 		.data			= (void *)&__syscall_meta_##sname,\
 	}
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index c7e3bcd..e7eb334 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -431,8 +431,9 @@ static inline notrace int ftrace_get_offsets_##call(			\
  * static struct ftrace_event_class __used event_class_<template> = {
  *	.system			= "<system>",
  *	.define_fields		= ftrace_define_fields_<call>,
- *	.fields			= LIST_HEAD_INIT(event_class_##call.fields), \
- *	.probe			= ftrace_raw_event_##call,		\
+ *	.fields			= LIST_HEAD_INIT(event_class_##call.fields),
+ *	.raw_init		= trace_event_raw_init,
+ *	.probe			= ftrace_raw_event_##call,
  * };
  *
  * static struct ftrace_event_call __used
@@ -440,7 +441,6 @@ static inline notrace int ftrace_get_offsets_##call(			\
  * __attribute__((section("_ftrace_events"))) event_<call> = {
  *	.name			= "<call>",
  *	.class			= event_class_<template>,
- *	.raw_init		= trace_event_raw_init,
  *	.event			= &ftrace_event_type_<call>,
  *	.print_fmt		= print_fmt_<call>,
  * };
@@ -566,6 +566,7 @@ static struct ftrace_event_class __used event_class_##call = {		\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.define_fields		= ftrace_define_fields_##call,		\
 	.fields			= LIST_HEAD_INIT(event_class_##call.fields),\
+	.raw_init		= trace_event_raw_init,			\
 	.probe			= ftrace_raw_event_##call,		\
 	_TRACE_PERF_INIT(call)						\
 };
@@ -579,7 +580,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
 	.event			= &ftrace_event_type_##call,		\
-	.raw_init		= trace_event_raw_init,			\
 	.print_fmt		= print_fmt_##template,			\
 };
 
@@ -594,7 +594,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
 	.event			= &ftrace_event_type_##call,		\
-	.raw_init		= trace_event_raw_init,			\
 	.print_fmt		= print_fmt_##call,			\
 }
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a09c4a0..683ab3f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1006,8 +1006,8 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
 	if (!call->name)
 		return -EINVAL;
 
-	if (call->raw_init) {
-		ret = call->raw_init(call);
+	if (call->class->raw_init) {
+		ret = call->class->raw_init(call);
 		if (ret < 0) {
 			if (ret != -ENOSYS)
 				pr_warning("Could not initialize trace "
@@ -1168,8 +1168,8 @@ static void trace_module_add_events(struct module *mod)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
-		if (call->raw_init) {
-			ret = call->raw_init(call);
+		if (call->class->raw_init) {
+			ret = call->class->raw_init(call);
 			if (ret < 0) {
 				if (ret != -ENOSYS)
 					pr_warning("Could not initialize trace "
@@ -1322,8 +1322,8 @@ static __init int event_trace_init(void)
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
-		if (call->raw_init) {
-			ret = call->raw_init(call);
+		if (call->class->raw_init) {
+			ret = call->class->raw_init(call);
 			if (ret < 0) {
 				if (ret != -ENOSYS)
 					pr_warning("Could not initialize trace "
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index e700a0c..e878d06 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -158,6 +158,7 @@ static int ftrace_raw_init_event(struct ftrace_event_call *call)
 struct ftrace_event_class event_class_ftrace_##call = {			\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.define_fields		= ftrace_define_fields_##call,		\
+	.raw_init		= ftrace_raw_init_event,		\
 };									\
 									\
 struct ftrace_event_call __used						\
@@ -166,7 +167,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.id			= type,					\
 	.class			= &event_class_ftrace_##call,		\
-	.raw_init		= ftrace_raw_init_event,		\
 	.print_fmt		= print,				\
 };									\
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index b14bf74..428f4a5 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1359,13 +1359,13 @@ static int register_probe_event(struct trace_probe *tp)
 	/* Initialize ftrace_event_call */
 	if (probe_is_return(tp)) {
 		tp->event.trace = print_kretprobe_event;
-		call->raw_init = probe_event_raw_init;
 		INIT_LIST_HEAD(&call->class->fields);
+		call->class->raw_init = probe_event_raw_init;
 		call->class->define_fields = kretprobe_event_define_fields;
 	} else {
-		tp->event.trace = print_kprobe_event;
-		call->raw_init = probe_event_raw_init;
 		INIT_LIST_HEAD(&call->class->fields);
+		tp->event.trace = print_kprobe_event;
+		call->class->raw_init = probe_event_raw_init;
 		call->class->define_fields = kprobe_event_define_fields;
 	}
 	if (set_print_fmt(tp) < 0)
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index cceccf0..1c1b9bf 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -44,6 +44,7 @@ struct ftrace_event_class event_class_syscall_enter = {
 	.reg			= syscall_enter_register,
 	.define_fields		= syscall_enter_define_fields,
 	.get_fields		= syscall_get_enter_fields,
+	.raw_init		= init_syscall_trace,
 };
 
 struct ftrace_event_class event_class_syscall_exit = {
@@ -51,6 +52,7 @@ struct ftrace_event_class event_class_syscall_exit = {
 	.reg			= syscall_exit_register,
 	.define_fields		= syscall_exit_define_fields,
 	.get_fields		= syscall_get_exit_fields,
+	.raw_init		= init_syscall_trace,
 };
 
 extern unsigned long __start_syscalls_metadata[];
-- 
1.7.0


