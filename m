Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab1BCOjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:39:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1BCOi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:38:59 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=vcSF-WElStQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=EHK_w3V9RrLpCXxS0swA:9 a=zpAyxmqerD5z5r1qGksA:7 a=vWLjyvuHK1U0RWCUmtRgYaUBsH0A:4 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=FaJUWjo_lj2k3SXV:21 a=oyz_OUViCkInc539:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110203143856.823688931@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 09:35:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 1/3 v2] tracing: Replace trace_event struct array with pointer array
References: <20110203143518.707423251@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Replace-trace_event-struct-array-with-pointe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the trace_event structures are placed in the _ftrace_events
section, and at link time, the linker makes one large array of all
the trace_event structures. On boot up, this array is read (much like
the initcall sections) and the events are processed.

The problem is that there is no guarantee that gcc will place complex
structures nicely together in an array format. Two structures in the
same file may be placed awkwardly, because gcc has no clue that they
are suppose to be in an array.

A hack was used previous to force the alignment to 4, to pack the
structures together. But this caused alignment issues with other
architectures (sparc).

Instead of packing the structures into an array, the structures' addresses
are now put into the _ftrace_event section. As pointers are always the
natural alignment, gcc should always pack them tightly together
(otherwise initcall, extable, etc would also fail).

By having the pointers to the structures in the section, we can still
iterate the trace_events without causing unnecessary alignment problems
with other architectures, or depending on the current behaviour of
gcc that will likely change in the future just to tick us kernel developers
off a little more.

The _ftrace_event section is also moved into the .init.data section
as it is now only needed at boot up.

Suggested-by: David Miller <davem@davemloft.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |    7 +++----
 include/linux/module.h            |    2 +-
 include/linux/syscalls.h          |   10 ++++++----
 include/trace/ftrace.h            |   24 +++++++++++++-----------
 kernel/trace/trace_events.c       |   12 ++++++------
 kernel/trace/trace_export.c       |    6 +++---
 6 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 6ebb810..f53708b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -124,7 +124,8 @@
 #endif
 
 #ifdef CONFIG_EVENT_TRACING
-#define FTRACE_EVENTS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
+#define FTRACE_EVENTS()	. = ALIGN(8);					\
+			VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
 			*(_ftrace_events)				\
 			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
 #else
@@ -179,9 +180,6 @@
 	TRACE_PRINTKS()							\
 									\
 	STRUCT_ALIGN();							\
-	FTRACE_EVENTS()							\
-									\
-	STRUCT_ALIGN();							\
 	TRACE_SYSCALLS()
 
 /*
@@ -482,6 +480,7 @@
 	KERNEL_CTORS()							\
 	*(.init.rodata)							\
 	MCOUNT_REC()							\
+	FTRACE_EVENTS()							\
 	DEV_DISCARD(init.rodata)					\
 	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.rodata)					\
diff --git a/include/linux/module.h b/include/linux/module.h
index e7c6385..7695a30 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -389,7 +389,7 @@ struct module
 	unsigned int num_trace_bprintk_fmt;
 #endif
 #ifdef CONFIG_EVENT_TRACING
-	struct ftrace_event_call *trace_events;
+	struct ftrace_event_call **trace_events;
 	unsigned int num_trace_events;
 #endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 18cd068..45508fe 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -128,28 +128,30 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata					\
 	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
-	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
 		.class			= &event_class_syscall_enter,	\
 		.event.funcs            = &enter_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 	};								\
+	static struct ftrace_event_call __used				\
+	  __attribute__((section("_ftrace_events")))			\
+	 *__event_enter_##sname = &event_enter_##sname;			\
 	__TRACE_EVENT_FLAGS(enter_##sname, TRACE_EVENT_FL_CAP_ANY)
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static struct syscall_metadata					\
 	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
-	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
 		.class			= &event_class_syscall_exit,	\
 		.event.funcs		= &exit_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 	};								\
+	static struct ftrace_event_call __used				\
+	  __attribute__((section("_ftrace_events")))			\
+	*__event_exit_##sname = &event_exit_##sname;			\
 	__TRACE_EVENT_FLAGS(exit_##sname, TRACE_EVENT_FL_CAP_ANY)
 
 #define SYSCALL_METADATA(sname, nb)				\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e16610c..3e68366 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -446,14 +446,16 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	.reg			= ftrace_event_reg,
  * };
  *
- * static struct ftrace_event_call __used
- * __attribute__((__aligned__(4)))
- * __attribute__((section("_ftrace_events"))) event_<call> = {
+ * static struct ftrace_event_call event_<call> = {
  *	.name			= "<call>",
  *	.class			= event_class_<template>,
  *	.event			= &ftrace_event_type_<call>,
  *	.print_fmt		= print_fmt_<call>,
  * };
+ * // its only safe to use pointers when doing linker tricks to
+ * // create an array.
+ * static struct ftrace_event_call __used
+ * __attribute__((section("_ftrace_events"))) *__event_<call> = &event_<call>;
  *
  */
 
@@ -579,28 +581,28 @@ static struct ftrace_event_class __used event_class_##call = {		\
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
 									\
-static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
+static struct ftrace_event_call __used event_##call = {			\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
 	.event.funcs		= &ftrace_event_type_funcs_##template,	\
 	.print_fmt		= print_fmt_##template,			\
-};
+};									\
+static struct ftrace_event_call __used					\
+__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
 									\
 static const char print_fmt_##call[] = print;				\
 									\
-static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
+static struct ftrace_event_call __used event_##call = {			\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
 	.event.funcs		= &ftrace_event_type_funcs_##call,	\
 	.print_fmt		= print_fmt_##call,			\
-}
+};									\
+static struct ftrace_event_call __used					\
+__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 35fde09..5f499e0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1284,7 +1284,7 @@ trace_create_file_ops(struct module *mod)
 static void trace_module_add_events(struct module *mod)
 {
 	struct ftrace_module_file_ops *file_ops = NULL;
-	struct ftrace_event_call *call, *start, *end;
+	struct ftrace_event_call **call, **start, **end;
 
 	start = mod->trace_events;
 	end = mod->trace_events + mod->num_trace_events;
@@ -1297,7 +1297,7 @@ static void trace_module_add_events(struct module *mod)
 		return;
 
 	for_each_event(call, start, end) {
-		__trace_add_event_call(call, mod,
+		__trace_add_event_call(*call, mod,
 				       &file_ops->id, &file_ops->enable,
 				       &file_ops->filter, &file_ops->format);
 	}
@@ -1367,8 +1367,8 @@ static struct notifier_block trace_module_nb = {
 	.priority = 0,
 };
 
-extern struct ftrace_event_call __start_ftrace_events[];
-extern struct ftrace_event_call __stop_ftrace_events[];
+extern struct ftrace_event_call *__start_ftrace_events[];
+extern struct ftrace_event_call *__stop_ftrace_events[];
 
 static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
 
@@ -1384,7 +1384,7 @@ __setup("trace_event=", setup_trace_event);
 
 static __init int event_trace_init(void)
 {
-	struct ftrace_event_call *call;
+	struct ftrace_event_call **call;
 	struct dentry *d_tracer;
 	struct dentry *entry;
 	struct dentry *d_events;
@@ -1430,7 +1430,7 @@ static __init int event_trace_init(void)
 		pr_warning("tracing: Failed to allocate common fields");
 
 	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
-		__trace_add_event_call(call, NULL, &ftrace_event_id_fops,
+		__trace_add_event_call(*call, NULL, &ftrace_event_id_fops,
 				       &ftrace_enable_fops,
 				       &ftrace_event_filter_fops,
 				       &ftrace_event_format_fops);
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4b74d71..bbeec31 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -161,13 +161,13 @@ struct ftrace_event_class event_class_ftrace_##call = {			\
 	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
 };									\
 									\
-struct ftrace_event_call __used						\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
+struct ftrace_event_call __used event_##call = {			\
 	.name			= #call,				\
 	.event.type		= etype,				\
 	.class			= &event_class_ftrace_##call,		\
 	.print_fmt		= print,				\
 };									\
+struct ftrace_event_call __used						\
+__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
 
 #include "trace_entries.h"
-- 
1.7.2.3


