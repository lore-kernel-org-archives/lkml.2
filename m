Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab0LBWsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:48:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43282 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab0LBWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:48:17 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=c7G5NcZ8m5IA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=uKqAGkRtdUx11UUtumIA:9 a=nKq_iUD47WJYEoQTMUUA:7 a=35yCBP8We1l7nME5xV7a1-eoc1cA:4 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101202224814.667536793@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 17:36:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [RFC][PATCH 1/2] [PATCH 1/2] tracing: Add TRACE_EVENT_CONDITIONAL()
References: <20101202223654.596106888@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-TRACE_EVENT_CONDITIONAL.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There are instances in the kernel that we only want to trace
a tracepoint when a certain condition is set. But we do not
want to test for that condition in the core kernel.
If we test for that condition before calling the tracepoin, then
we will be performing that test even when tracing is not enabled.
This is 99.99% of the time.

We currently can just filter out on that condition, but that happens
after we write to the trace buffer. We just wasted time writing to
the ring buffer for an event we never cared about.

This patch adds:

   TRACE_EVENT_CONDITION() and DECLARE_TRACE_CLASS_CONDITION()

These have a new TP_CONDITION() argument that comes right after
the TP_ARGS().  This condition can use the parameters of the
TRACE_EVENT() to determine if the tracepoint should be traced
or not. The TP_CONDITION() will be placed in a if (cond) trace;

For example, for the tracepoint sched_wakeup, it is useless to
trace an wakeup event where the caller never actually work
anything up (success = 0). So adding:

	TP_CONDITION(success),

which uses the "success" parameter of the wakeup tracepoint
will have it only trace when we have successfully woken up a
task.

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h   |    3 ++
 include/trace/define_trace.h |    6 +++
 include/trace/events/sched.h |    2 +-
 include/trace/ftrace.h       |   70 +++++++++++++++++++++++++++++++----------
 4 files changed, 63 insertions(+), 18 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 5a6074f..380c807 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -344,12 +344,15 @@ do_trace:								\
  * TRACE_EVENT_FN to perform any (un)registration work.
  */
 
+#define DECLARE_EVENT_CLASS_CONDITION(name, proto, args, cond, tstruct, assign, print)
 #define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)
 #define DEFINE_EVENT(template, name, proto, args)		\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
+#define TRACE_EVENT_CONDITION(name, proto, args, cond, struct, assign, print) \
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define TRACE_EVENT_FN(name, proto, args, struct,		\
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 1dfab54..89cf844 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -26,6 +26,10 @@
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
 	DEFINE_TRACE(name)
 
+#undef TRACE_EVENT_CONDITION
+#define TRACE_EVENT_CONDITION(name, proto, args, cond, tstruct, assign, print) \
+	DEFINE_TRACE(name)
+
 #undef TRACE_EVENT_FN
 #define TRACE_EVENT_FN(name, proto, args, tstruct,		\
 		assign, print, reg, unreg)			\
@@ -75,7 +79,9 @@
 
 #undef TRACE_EVENT
 #undef TRACE_EVENT_FN
+#undef TRACE_EVENT_CONDITION
 #undef DECLARE_EVENT_CLASS
+#undef DECLARE_EVENT_CLASS_CONDITION
 #undef DEFINE_EVENT
 #undef DEFINE_EVENT_PRINT
 #undef TRACE_HEADER_MULTI_READ
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index f633478..67456f0 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -10,7 +10,7 @@
 /*
  * Tracepoint for calling kthread_stop, performed to end a kthread:
  */
-TRACE_EVENT(sched_kthread_stop,
+TRACE_EVENT_CONDITION(sched_kthread_stop,
 
 	TP_PROTO(struct task_struct *t),
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e718a91..30f5da0 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -29,14 +29,41 @@
  */
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print) \
-	DECLARE_EVENT_CLASS(name,			       \
+	TRACE_EVENT_CONDITION(name,			       \
 			     PARAMS(proto),		       \
 			     PARAMS(args),		       \
+			     TP_CONDITION(1),		       \
+			     PARAMS(tstruct),		       \
+			     PARAMS(assign),		       \
+			     PARAMS(print));
+
+#undef TRACE_EVENT_CONDITION
+#define TRACE_EVENT_CONDITION(name, proto, args, cond, tstruct, assign, print) \
+	DECLARE_EVENT_CLASS_CONDITION(name,			\
+			     PARAMS(proto),		       \
+			     PARAMS(args),		       \
+			     PARAMS(cond),		       \
 			     PARAMS(tstruct),		       \
 			     PARAMS(assign),		       \
 			     PARAMS(print));		       \
 	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));
 
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)	\
+	DECLARE_EVENT_CLASS_CONDITION(name,				\
+		PARAMS(proto),						\
+		PARAMS(args),						\
+		TP_CONDITION(1),					\
+		PARAMS(tstruct),					\
+		PARAMS(assign),						\
+		PARAMS(print))
+
+/*
+ * Just to shorten the name, we use _DECLARE_EVENT_CLASS instead
+ * of DECLARE_EVENT_CLASS_CONDITION.
+ */
+#undef DECLARE_EVENT_CLASS_CONDITION
+#define DECLARE_EVENT_CLASS_CONDITION _DECLARE_EVENT_CLASS
 
 #undef __field
 #define __field(type, item)		type	item;
@@ -56,8 +83,13 @@
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)	\
+#undef TP_CONDITION
+#define TP_CONDITION(cond)			\
+	if (!(cond))				\
+		return;
+
+#undef _DECLARE_EVENT_CLASS
+#define _DECLARE_EVENT_CLASS(name, proto, args, cond, tstruct, assign, print) \
 	struct ftrace_raw_##name {					\
 		struct trace_entry	ent;				\
 		tstruct							\
@@ -120,8 +152,8 @@
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#undef _DECLARE_EVENT_CLASS
+#define _DECLARE_EVENT_CLASS(call, proto, args, cond, tstruct, assign, print) \
 	struct ftrace_data_offsets_##call {				\
 		tstruct;						\
 	};
@@ -208,8 +240,8 @@
 #undef __print_hex
 #define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#undef _DECLARE_EVENT_CLASS
+#define _DECLARE_EVENT_CLASS(call, proto, args, cond, tstruct, assign, print) \
 static notrace enum print_line_t					\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 			 struct trace_event *trace_event)		\
@@ -314,8 +346,8 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
+#undef _DECLARE_EVENT_CLASS
+#define _DECLARE_EVENT_CLASS(call, proto, args, cond, tstruct, func, print) \
 static int notrace							\
 ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
@@ -362,8 +394,8 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#undef _DECLARE_EVENT_CLASS
+#define _DECLARE_EVENT_CLASS(call, proto, args, cond, tstruct, assign, print) \
 static inline notrace int ftrace_get_offsets_##call(			\
 	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
 {									\
@@ -491,8 +523,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
 #undef TP_perf_assign
 #define TP_perf_assign(args...)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#undef _DECLARE_EVENT_CLASS
+#define _DECLARE_EVENT_CLASS(call, proto, args, cond, tstruct, assign, print) \
 									\
 static notrace void							\
 ftrace_raw_event_##call(void *__data, proto)				\
@@ -506,6 +538,8 @@ ftrace_raw_event_##call(void *__data, proto)				\
 	int __data_size;						\
 	int pc;								\
 									\
+	cond;								\
+									\
 	local_save_flags(irq_flags);					\
 	pc = preempt_count();						\
 									\
@@ -556,8 +590,8 @@ static inline void ftrace_test_probe_##call(void)			\
 #undef TP_printk
 #define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#undef _DECLARE_EVENT_CLASS
+#define _DECLARE_EVENT_CLASS(call, proto, args, cond, tstruct, assign, print) \
 _TRACE_PERF_PROTO(call, PARAMS(proto));					\
 static const char print_fmt_##call[] = print;				\
 static struct ftrace_event_class __used event_class_##call = {		\
@@ -690,8 +724,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef __perf_count
 #define __perf_count(c) __count = (c)
 
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+#undef _DECLARE_EVENT_CLASS
+#define _DECLARE_EVENT_CLASS(call, proto, args, cond, tstruct, assign, print) \
 static notrace void							\
 perf_trace_##call(void *__data, proto)					\
 {									\
@@ -705,6 +739,8 @@ perf_trace_##call(void *__data, proto)					\
 	int __data_size;						\
 	int rctx;							\
 									\
+	cond;								\
+									\
 	perf_fetch_caller_regs(&__regs);				\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
-- 
1.7.2.3


