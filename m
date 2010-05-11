Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab0EKS7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:59:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45854 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab0EKS54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:57:56 -0400
X-Authority-Analysis: v=1.1 cv=PaD2Wv+9xJqXNP3J8apim3QBTBpXOuB+BaCFQon6buA= c=1 sm=0 a=2vLbHwPzyPIA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=1BJqe3Qrg15LNDULqhEA:9 a=8DZo4lALZr7bwoJTKaUA:7 a=VSd0RZxzNZWHai1BbA2PAZmU76IA:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100511185754.086820687@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 11 May 2010 14:20:26 -0400
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
Subject: [PATCH 04/10] tracing: Remove per event trace registering
References: <20100511182022.826921702@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Remove-per-event-trace-registering.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch removes the register functions of TRACE_EVENT() to enable
and disable tracepoints. The registering of a event is now down
directly in the trace_events.c file. The tracepoint_probe_register()
is now called directly.

The prototypes are no longer type checked, but this should not be
an issue since the tracepoints are created automatically by the
macros. If a prototype is incorrect in the TRACE_EVENT() macro, then
other macros will catch it.

The trace_event_class structure now holds the probes to be called
by the callbacks. This removes needing to have each event have
a separate pointer for the probe.

To handle kprobes and syscalls, since they register probes in a
different manner, a "reg" field is added to the ftrace_event_class
structure. If the "reg" field is assigned, then it will be called for
enabling and disabling of the probe for either ftrace or perf. To let
the reg function know what is happening, a new enum (trace_reg) is
created that has the type of control that is needed.

With this new rework, the 82 kernel events and 618 syscall events
has their footprint dramatically lowered:

   text	   data	    bss	    dec	    hex	filename
4913961	1088356	 861512	6863829	 68bbd5	vmlinux.orig
4914025	1088868	 861512	6864405	 68be15	vmlinux.class
4918492	1084612	 861512	6864616	 68bee8	vmlinux.tracepoint
4900252	1057412	 861512	6819176	 680d68	vmlinux.regs

The size went from 6863829 to 6819176, that's a total of 44K
in savings. With tracepoints being continuously added, this is
critical that the footprint becomes minimal.

v3: Updated to handle void *data in beginning of probe parameters.
    Also added the tracepoint: check_trace_callback_type_##call().

v2: Changed the callback probes to pass void * and typecast the
    value within the function.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h    |   19 +++++-
 include/linux/syscalls.h        |   29 +-------
 include/trace/ftrace.h          |  133 +++++++++++----------------------------
 kernel/trace/trace_event_perf.c |   15 ++++-
 kernel/trace/trace_events.c     |   26 ++++++--
 kernel/trace/trace_kprobe.c     |   34 +++++++---
 kernel/trace/trace_syscalls.c   |   56 ++++++++++++++++-
 7 files changed, 167 insertions(+), 145 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 496eea8..e665ed3 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -113,8 +113,23 @@ void tracing_record_cmdline(struct task_struct *tsk);
 
 struct event_filter;
 
+enum trace_reg {
+	TRACE_REG_REGISTER,
+	TRACE_REG_UNREGISTER,
+	TRACE_REG_PERF_REGISTER,
+	TRACE_REG_PERF_UNREGISTER,
+};
+
+struct ftrace_event_call;
+
 struct ftrace_event_class {
 	char			*system;
+	void			*probe;
+#ifdef CONFIG_PERF_EVENTS
+	void			*perf_probe;
+#endif
+	int			(*reg)(struct ftrace_event_call *event,
+				       enum trace_reg type);
 };
 
 struct ftrace_event_call {
@@ -124,8 +139,6 @@ struct ftrace_event_call {
 	struct dentry		*dir;
 	struct trace_event	*event;
 	int			enabled;
-	int			(*regfunc)(struct ftrace_event_call *);
-	void			(*unregfunc)(struct ftrace_event_call *);
 	int			id;
 	const char		*print_fmt;
 	int			(*raw_init)(struct ftrace_event_call *);
@@ -137,8 +150,6 @@ struct ftrace_event_call {
 	void			*data;
 
 	int			perf_refcount;
-	int			(*perf_event_enable)(struct ftrace_event_call *);
-	void			(*perf_event_disable)(struct ftrace_event_call *);
 };
 
 #define PERF_MAX_TRACE_SIZE	2048
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index ac5791d..e3348c4 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -103,22 +103,6 @@ struct perf_event_attr;
 #define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
-#ifdef CONFIG_PERF_EVENTS
-
-#define TRACE_SYS_ENTER_PERF_INIT(sname)				       \
-	.perf_event_enable = perf_sysenter_enable,			       \
-	.perf_event_disable = perf_sysenter_disable,
-
-#define TRACE_SYS_EXIT_PERF_INIT(sname)					       \
-	.perf_event_enable = perf_sysexit_enable,			       \
-	.perf_event_disable = perf_sysexit_disable,
-#else
-#define TRACE_SYS_ENTER_PERF(sname)
-#define TRACE_SYS_ENTER_PERF_INIT(sname)
-#define TRACE_SYS_EXIT_PERF(sname)
-#define TRACE_SYS_EXIT_PERF_INIT(sname)
-#endif /* CONFIG_PERF_EVENTS */
-
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define __SC_STR_ADECL1(t, a)		#a
 #define __SC_STR_ADECL2(t, a, ...)	#a, __SC_STR_ADECL1(__VA_ARGS__)
@@ -134,7 +118,8 @@ struct perf_event_attr;
 #define __SC_STR_TDECL5(t, a, ...)	#t, __SC_STR_TDECL4(__VA_ARGS__)
 #define __SC_STR_TDECL6(t, a, ...)	#t, __SC_STR_TDECL5(__VA_ARGS__)
 
-extern struct ftrace_event_class event_class_syscalls;
+extern struct ftrace_event_class event_class_syscall_enter;
+extern struct ftrace_event_class event_class_syscall_exit;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
 	static const struct syscall_metadata __syscall_meta_##sname;	\
@@ -148,14 +133,11 @@ extern struct ftrace_event_class event_class_syscalls;
 	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
-		.class			= &event_class_syscalls,	\
+		.class			= &event_class_syscall_enter,	\
 		.event                  = &enter_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
 		.define_fields		= syscall_enter_define_fields,	\
-		.regfunc		= reg_event_syscall_enter,	\
-		.unregfunc		= unreg_event_syscall_enter,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		TRACE_SYS_ENTER_PERF_INIT(sname)			\
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
@@ -170,14 +152,11 @@ extern struct ftrace_event_class event_class_syscalls;
 	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
-		.class			= &event_class_syscalls,	\
+		.class			= &event_class_syscall_exit,	\
 		.event                  = &exit_syscall_print_##sname,	\
 		.raw_init		= init_syscall_trace,		\
 		.define_fields		= syscall_exit_define_fields,	\
-		.regfunc		= reg_event_syscall_exit,	\
-		.unregfunc		= unreg_event_syscall_exit,	\
 		.data			= (void *)&__syscall_meta_##sname,\
-		TRACE_SYS_EXIT_PERF_INIT(sname)			\
 	}
 
 #define SYSCALL_METADATA(sname, nb)				\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 15e599b..025dbbf 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -381,53 +381,6 @@ static inline notrace int ftrace_get_offsets_##call(			\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#ifdef CONFIG_PERF_EVENTS
-
-/*
- * Generate the functions needed for tracepoint perf_event support.
- *
- * NOTE: The insertion profile callback (ftrace_profile_<call>) is defined later
- *
- * static int ftrace_profile_enable_<call>(void)
- * {
- * 	return register_trace_<call>(ftrace_profile_<call>);
- * }
- *
- * static void ftrace_profile_disable_<call>(void)
- * {
- * 	unregister_trace_<call>(ftrace_profile_<call>);
- * }
- *
- */
-
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)
-
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(template, name, proto, args)			\
-									\
-static void perf_trace_##name(void *, proto);				\
-									\
-static notrace int							\
-perf_trace_enable_##name(struct ftrace_event_call *unused)		\
-{									\
-	return register_trace_##name(perf_trace_##name, NULL);		\
-}									\
-									\
-static notrace void							\
-perf_trace_disable_##name(struct ftrace_event_call *unused)		\
-{									\
-	unregister_trace_##name(perf_trace_##name, NULL);		\
-}
-
-#undef DEFINE_EVENT_PRINT
-#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
-
-#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
-
-#endif /* CONFIG_PERF_EVENTS */
-
 /*
  * Stage 4 of the trace events.
  *
@@ -437,8 +390,9 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *
  * static struct ftrace_event_call event_<call>;
  *
- * static void ftrace_raw_event_<call>(proto)
+ * static void ftrace_raw_event_<call>(void *__data, proto)
  * {
+ *	struct ftrace_event_call *event_call = __data;
  *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
  *	struct ring_buffer_event *event;
  *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
@@ -468,16 +422,6 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
  *						   event, irq_flags, pc);
  * }
  *
- * static int ftrace_raw_reg_event_<call>(struct ftrace_event_call *unused)
- * {
- *	return register_trace_<call>(ftrace_raw_event_<call>);
- * }
- *
- * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
- * {
- *	unregister_trace_<call>(ftrace_raw_event_<call>);
- * }
- *
  * static struct trace_event ftrace_event_type_<call> = {
  *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
@@ -504,11 +448,15 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
 
 #ifdef CONFIG_PERF_EVENTS
 
+#define _TRACE_PERF_PROTO(call, proto)					\
+	static notrace void						\
+	perf_trace_##call(void *__data, proto);
+
 #define _TRACE_PERF_INIT(call)						\
-	.perf_event_enable = perf_trace_enable_##call,			\
-	.perf_event_disable = perf_trace_disable_##call,
+	.perf_probe		= perf_trace_##call,
 
 #else
+#define _TRACE_PERF_PROTO(call, proto)
 #define _TRACE_PERF_INIT(call)
 #endif /* CONFIG_PERF_EVENTS */
 
@@ -542,9 +490,9 @@ perf_trace_disable_##name(struct ftrace_event_call *unused)		\
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 									\
 static notrace void							\
-ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
-				       proto)				\
+ftrace_raw_event_##call(void *__data, proto)				\
 {									\
+	struct ftrace_event_call *event_call = __data;			\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
@@ -574,30 +522,23 @@ ftrace_raw_event_id_##call(struct ftrace_event_call *event_call,	\
 		trace_nowake_buffer_unlock_commit(buffer,		\
 						  event, irq_flags, pc); \
 }
+/*
+ * The ftrace_test_probe is compiled out, it is only here as a build time check
+ * to make sure that if the tracepoint handling changes, the ftrace probe will
+ * fail to compile unless it too is updated.
+ */
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
 									\
-static notrace void ftrace_raw_event_##call(void *__ignore, proto)	\
-{									\
-	ftrace_raw_event_id_##template(&event_##call, args);		\
-}									\
-									\
-static notrace int							\
-ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)		\
-{									\
-	return register_trace_##call(ftrace_raw_event_##call, NULL);	\
-}									\
-									\
-static notrace void							\
-ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)		\
-{									\
-	unregister_trace_##call(ftrace_raw_event_##call, NULL);		\
-}									\
-									\
 static struct trace_event ftrace_event_type_##call = {			\
 	.trace			= ftrace_raw_output_##call,		\
-};
+};									\
+									\
+static inline void ftrace_test_probe_##call(void)			\
+{									\
+	check_trace_callback_type_##call(ftrace_raw_event_##template);	\
+}
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
@@ -618,9 +559,12 @@ static struct trace_event ftrace_event_type_##call = {			\
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+_TRACE_PERF_PROTO(call, PARAMS(proto));					\
 static const char print_fmt_##call[] = print;				\
 static struct ftrace_event_class __used event_class_##call = {		\
-	.system			= __stringify(TRACE_SYSTEM)		\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.probe			= ftrace_raw_event_##call,		\
+	_TRACE_PERF_INIT(call)						\
 }
 
 #undef DEFINE_EVENT
@@ -633,11 +577,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.class			= &event_class_##template,		\
 	.event			= &ftrace_event_type_##call,		\
 	.raw_init		= trace_event_raw_init,			\
-	.regfunc		= ftrace_raw_reg_event_##call,		\
-	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.print_fmt		= print_fmt_##template,			\
 	.define_fields		= ftrace_define_fields_##template,	\
-	_TRACE_PERF_INIT(call)					\
 }
 
 #undef DEFINE_EVENT_PRINT
@@ -652,11 +593,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.class			= &event_class_##template,		\
 	.event			= &ftrace_event_type_##call,		\
 	.raw_init		= trace_event_raw_init,			\
-	.regfunc		= ftrace_raw_reg_event_##call,		\
-	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.print_fmt		= print_fmt_##call,			\
 	.define_fields		= ftrace_define_fields_##template,	\
-	_TRACE_PERF_INIT(call)					\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
@@ -756,9 +694,9 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace void							\
-perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
-			    proto)					\
+perf_trace_##call(void *__data, proto)					\
 {									\
+	struct ftrace_event_call *event_call = __data;			\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
 	u64 __addr = 0, __count = 1;					\
@@ -791,15 +729,20 @@ perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 			       __count, irq_flags, __regs);		\
 }
 
+/*
+ * This part is compiled out, it is only here as a build time check
+ * to make sure that if the tracepoint handling changes, the
+ * perf probe will fail to compile unless it too is updated.
+ */
 #undef DEFINE_EVENT
-#define DEFINE_EVENT(template, call, proto, args)		\
-static notrace void perf_trace_##call(void *__ignore, proto)	\
-{								\
-	struct ftrace_event_call *event_call = &event_##call;	\
-								\
-	perf_trace_templ_##template(event_call, args);		\
+#define DEFINE_EVENT(template, call, proto, args)			\
+static inline void perf_test_probe_##call(void)				\
+{									\
+	check_trace_callback_type_##call(perf_trace_##template);	\
+									\
 }
 
+
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 0565bb4..196fe9d 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -49,7 +49,12 @@ static int perf_trace_event_enable(struct ftrace_event_call *event)
 		rcu_assign_pointer(perf_trace_buf_nmi, buf);
 	}
 
-	ret = event->perf_event_enable(event);
+	if (event->class->reg)
+		ret = event->class->reg(event, TRACE_REG_PERF_REGISTER);
+	else
+		ret = tracepoint_probe_register(event->name,
+						event->class->perf_probe,
+						event);
 	if (!ret) {
 		total_ref_count++;
 		return 0;
@@ -75,7 +80,8 @@ int perf_trace_enable(int event_id)
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id && event->perf_event_enable &&
+		if (event->id == event_id &&
+		    event->class && event->class->perf_probe &&
 		    try_module_get(event->mod)) {
 			ret = perf_trace_event_enable(event);
 			break;
@@ -93,7 +99,10 @@ static void perf_trace_event_disable(struct ftrace_event_call *event)
 	if (--event->perf_refcount > 0)
 		return;
 
-	event->perf_event_disable(event);
+	if (event->class->reg)
+		event->class->reg(event, TRACE_REG_PERF_UNREGISTER);
+	else
+		tracepoint_probe_unregister(event->name, event->class->perf_probe, event);
 
 	if (!--total_ref_count) {
 		buf = perf_trace_buf;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 2f54b48..0eb9b28 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -127,13 +127,23 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 		if (call->enabled) {
 			call->enabled = 0;
 			tracing_stop_cmdline_record();
-			call->unregfunc(call);
+			if (call->class->reg)
+				call->class->reg(call, TRACE_REG_UNREGISTER);
+			else
+				tracepoint_probe_unregister(call->name,
+							    call->class->probe,
+							    call);
 		}
 		break;
 	case 1:
 		if (!call->enabled) {
 			tracing_start_cmdline_record();
-			ret = call->regfunc(call);
+			if (call->class->reg)
+				ret = call->class->reg(call, TRACE_REG_REGISTER);
+			else
+				ret = tracepoint_probe_register(call->name,
+								call->class->probe,
+								call);
 			if (ret) {
 				tracing_stop_cmdline_record();
 				pr_info("event trace: Could not enable event "
@@ -171,7 +181,8 @@ static int __ftrace_set_clr_event(const char *match, const char *sub,
 	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
 
-		if (!call->name || !call->regfunc)
+		if (!call->name || !call->class ||
+		    (!call->class->probe && !call->class->reg))
 			continue;
 
 		if (match &&
@@ -297,7 +308,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		 * The ftrace subsystem is for showing formats only.
 		 * They can not be enabled or disabled via the event files.
 		 */
-		if (call->regfunc)
+		if (call->class && (call->class->probe || call->class->reg))
 			return call;
 	}
 
@@ -450,7 +461,8 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
-		if (!call->name || !call->regfunc)
+		if (!call->name || !call->class ||
+		    (!call->class->probe && !call->class->reg))
 			continue;
 
 		if (system && strcmp(call->class->system, system) != 0)
@@ -935,11 +947,11 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		return -1;
 	}
 
-	if (call->regfunc)
+	if (call->class->probe || call->class->reg)
 		trace_create_file("enable", 0644, call->dir, call,
 				  enable);
 
-	if (call->id && call->perf_event_enable)
+	if (call->id && (call->class->perf_probe || call->class->reg))
 		trace_create_file("id", 0444, call->dir, call,
 		 		  id);
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index eda220b..f8af21a 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -202,6 +202,7 @@ struct trace_probe {
 	unsigned long 		nhit;
 	unsigned int		flags;	/* For TP_FLAG_* */
 	const char		*symbol;	/* symbol name */
+	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
 	struct trace_event		event;
 	unsigned int		nr_args;
@@ -323,6 +324,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 		goto error;
 	}
 
+	tp->call.class = &tp->class;
 	tp->call.name = kstrdup(event, GFP_KERNEL);
 	if (!tp->call.name)
 		goto error;
@@ -332,8 +334,8 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 		goto error;
 	}
 
-	tp->call.class->system = kstrdup(group, GFP_KERNEL);
-	if (!tp->call.class->system)
+	tp->class.system = kstrdup(group, GFP_KERNEL);
+	if (!tp->class.system)
 		goto error;
 
 	INIT_LIST_HEAD(&tp->list);
@@ -1302,6 +1304,26 @@ static void probe_perf_disable(struct ftrace_event_call *call)
 }
 #endif	/* CONFIG_PERF_EVENTS */
 
+static __kprobes
+int kprobe_register(struct ftrace_event_call *event, enum trace_reg type)
+{
+	switch (type) {
+	case TRACE_REG_REGISTER:
+		return probe_event_enable(event);
+	case TRACE_REG_UNREGISTER:
+		probe_event_disable(event);
+		return 0;
+
+#ifdef CONFIG_PERF_EVENTS
+	case TRACE_REG_PERF_REGISTER:
+		return probe_perf_enable(event);
+	case TRACE_REG_PERF_UNREGISTER:
+		probe_perf_disable(event);
+		return 0;
+#endif
+	}
+	return 0;
+}
 
 static __kprobes
 int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
@@ -1355,13 +1377,7 @@ static int register_probe_event(struct trace_probe *tp)
 		return -ENODEV;
 	}
 	call->enabled = 0;
-	call->regfunc = probe_event_enable;
-	call->unregfunc = probe_event_disable;
-
-#ifdef CONFIG_PERF_EVENTS
-	call->perf_event_enable = probe_perf_enable;
-	call->perf_event_disable = probe_perf_disable;
-#endif
+	call->class->reg = kprobe_register;
 	call->data = tp;
 	ret = trace_add_event_call(call);
 	if (ret) {
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index b8d30e7..a21d366 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -15,8 +15,19 @@ static int sys_refcount_exit;
 static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
 static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
 
-struct ftrace_event_class event_class_syscalls = {
-	.system			= "syscalls"
+static int syscall_enter_register(struct ftrace_event_call *event,
+				 enum trace_reg type);
+static int syscall_exit_register(struct ftrace_event_call *event,
+				 enum trace_reg type);
+
+struct ftrace_event_class event_class_syscall_enter = {
+	.system			= "syscalls",
+	.reg			= syscall_enter_register
+};
+
+struct ftrace_event_class event_class_syscall_exit = {
+	.system			= "syscalls",
+	.reg			= syscall_exit_register
 };
 
 extern unsigned long __start_syscalls_metadata[];
@@ -587,3 +598,44 @@ void perf_sysexit_disable(struct ftrace_event_call *call)
 
 #endif /* CONFIG_PERF_EVENTS */
 
+static int syscall_enter_register(struct ftrace_event_call *event,
+				 enum trace_reg type)
+{
+	switch (type) {
+	case TRACE_REG_REGISTER:
+		return reg_event_syscall_enter(event);
+	case TRACE_REG_UNREGISTER:
+		unreg_event_syscall_enter(event);
+		return 0;
+
+#ifdef CONFIG_PERF_EVENTS
+	case TRACE_REG_PERF_REGISTER:
+		return perf_sysenter_enable(event);
+	case TRACE_REG_PERF_UNREGISTER:
+		perf_sysenter_disable(event);
+		return 0;
+#endif
+	}
+	return 0;
+}
+
+static int syscall_exit_register(struct ftrace_event_call *event,
+				 enum trace_reg type)
+{
+	switch (type) {
+	case TRACE_REG_REGISTER:
+		return reg_event_syscall_exit(event);
+	case TRACE_REG_UNREGISTER:
+		unreg_event_syscall_exit(event);
+		return 0;
+
+#ifdef CONFIG_PERF_EVENTS
+	case TRACE_REG_PERF_REGISTER:
+		return perf_sysexit_enable(event);
+	case TRACE_REG_PERF_UNREGISTER:
+		perf_sysexit_disable(event);
+		return 0;
+#endif
+	}
+	return 0;
+}
-- 
1.7.0


