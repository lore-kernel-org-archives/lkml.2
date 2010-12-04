Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0LDCcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 21:32:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62393 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0LDCbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 21:31:43 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=uQMzxKW3AL4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=qr02Ien6On4zqSQgeJAA:9 a=oLrXhcDnmUG5mvbSVcwA:7 a=DcbFd1LuGzXWCUlcQqE7-IdCdh0A:4 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101204023141.552849493@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 03 Dec 2010 21:17:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 3/4] tracing: Add TRACE_EVENT_CONDITIONAL()
References: <20101204021744.521599148@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Add-TRACE_EVENT_CONDITIONAL.patch
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

   TRACE_EVENT_CONDITION() and DEFINE_EVENT_CONDITION()

These have a new TP_CONDITION() argument that comes right after
the TP_ARGS().  This condition can use the parameters of TP_ARGS()
in the TRACE_EVENT() to determine if the tracepoint should be traced
or not. The TP_CONDITION() will be placed in a if (cond) trace;

For example, for the tracepoint sched_wakeup, it is useless to
trace a wakeup event where the caller never actually wakes
anything up (where success == 0). So adding:

	TP_CONDITION(success),

which uses the "success" parameter of the wakeup tracepoint
will have it only trace when we have successfully woken up a
task.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h   |   29 +++++++++++++++++++++++------
 include/trace/define_trace.h |   15 +++++++++++++++
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 5a6074f..d3e4f87 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -106,6 +106,7 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 
 #define TP_PROTO(args...)	args
 #define TP_ARGS(args...)	args
+#define TP_CONDITION(args...)	args
 
 #ifdef CONFIG_TRACEPOINTS
 
@@ -119,12 +120,14 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
  * as "(void *, void)". The DECLARE_TRACE_NOARGS() will pass in just
  * "void *data", where as the DECLARE_TRACE() will pass in "void *data, proto".
  */
-#define __DO_TRACE(tp, proto, args)					\
+#define __DO_TRACE(tp, proto, args, cond)				\
 	do {								\
 		struct tracepoint_func *it_func_ptr;			\
 		void *it_func;						\
 		void *__data;						\
 									\
+		if (!(cond))						\
+			return;						\
 		rcu_read_lock_sched_notrace();				\
 		it_func_ptr = rcu_dereference_sched((tp)->funcs);	\
 		if (it_func_ptr) {					\
@@ -142,7 +145,7 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
+#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
@@ -151,7 +154,8 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 do_trace:								\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
-				TP_ARGS(data_args));			\
+				TP_ARGS(data_args),			\
+				TP_CONDITION(cond));			\
 	}								\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto), void *data)	\
@@ -186,7 +190,7 @@ do_trace:								\
 	EXPORT_SYMBOL(__tracepoint_##name)
 
 #else /* !CONFIG_TRACEPOINTS */
-#define __DECLARE_TRACE(name, proto, args, data_proto, data_args)	\
+#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
 	static inline void trace_##name(proto)				\
 	{ }								\
 	static inline int						\
@@ -227,13 +231,18 @@ do_trace:								\
  * "void *__data, proto" as the callback prototype.
  */
 #define DECLARE_TRACE_NOARGS(name)					\
-		__DECLARE_TRACE(name, void, , void *__data, __data)
+		__DECLARE_TRACE(name, void, , 1, void *__data, __data)
 
 #define DECLARE_TRACE(name, proto, args)				\
-		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args),	\
+		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args), 1,	\
 				PARAMS(void *__data, proto),		\
 				PARAMS(__data, args))
 
+#define DECLARE_TRACE_CONDITION(name, proto, args, cond)		\
+	__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args), PARAMS(cond), \
+			PARAMS(void *__data, proto),			\
+			PARAMS(__data, args))
+
 #define TRACE_EVENT_FLAGS(event, flag)
 
 #endif /* DECLARE_TRACE */
@@ -349,12 +358,20 @@ do_trace:								\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+#define DEFINE_EVENT_CONDITION(template, name, proto,		\
+			       args, cond)			\
+	DECLARE_TRACE_CONDITION(name, PARAMS(proto),		\
+				PARAMS(args), PARAMS(cond))
 
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define TRACE_EVENT_FN(name, proto, args, struct,		\
 		assign, print, reg, unreg)			\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+#define TRACE_EVENT_CONDITION(name, proto, args, cond,		\
+			      struct, assign, print)		\
+	DECLARE_TRACE_CONDITION(name, PARAMS(proto),		\
+				PARAMS(args), PARAMS(cond))
 
 #define TRACE_EVENT_FLAGS(event, flag)
 
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 1dfab54..b0b4eb2 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -26,6 +26,15 @@
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
 	DEFINE_TRACE(name)
 
+#undef TRACE_EVENT_CONDITION
+#define TRACE_EVENT_CONDITION(name, proto, args, cond, tstruct, assign, print) \
+	TRACE_EVENT(name,						\
+		PARAMS(proto),						\
+		PARAMS(args),						\
+		PARAMS(tstruct),					\
+		PARAMS(assign),						\
+		PARAMS(print))
+
 #undef TRACE_EVENT_FN
 #define TRACE_EVENT_FN(name, proto, args, tstruct,		\
 		assign, print, reg, unreg)			\
@@ -39,6 +48,10 @@
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_TRACE(name)
 
+#undef DEFINE_EVENT_CONDITION
+#define DEFINE_EVENT_CONDITION(template, name, proto, args, cond) \
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+
 #undef DECLARE_TRACE
 #define DECLARE_TRACE(name, proto, args)	\
 	DEFINE_TRACE(name)
@@ -75,9 +88,11 @@
 
 #undef TRACE_EVENT
 #undef TRACE_EVENT_FN
+#undef TRACE_EVENT_CONDITION
 #undef DECLARE_EVENT_CLASS
 #undef DEFINE_EVENT
 #undef DEFINE_EVENT_PRINT
+#undef DEFINE_EVENT_CONDITION
 #undef TRACE_HEADER_MULTI_READ
 #undef DECLARE_TRACE
 
-- 
1.7.2.3


