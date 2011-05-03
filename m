Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1ECXOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:14:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40224 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab1ECXOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:14:41 -0400
Message-Id: <20110503231424.151227450@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 19:10:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC patch 01/32] TRACE_EVENT: gradual semicolon removal
References: <20110503231023.968960757@efficios.com>
Content-Disposition: inline; filename=trace-event-gradual-semicolon-removal.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  3 May 2011 23:14:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initiate the removal of the extra semicolons at the end of:

TRACE_EVENT(
  ...
);     <---- here,

TRACE_EVENT_FN(
  ...
);     <---- here,

DEFINE_EVENT(
  ...
);     <---- here,

DEFINE_EVENT_PRINT(
  ...
);     <---- and here.

by removing the semicolon from the comment in tracepoint.h explaining the
TRACE_EVENT() usage. It is now also mandated that all declarations done in the
trace event headers should be surrounded by ifdefs checks: it is already
necessary, but some users get away from this requirement for structure
forward-declarations.

I am proposing to merge this patchset through the "tracing" tree for better
coordination.

Adding the missing semicolon within the DEFINE_EVENT(), DEFINE_EVENT_PRINT()
and DEFINE_TRACE_FN() macros is required as a preliminary step to remove extra
semicolons.  We currently are not seeing any impact of this missing semicolon
because extra they appear all over the place in the code generated from
TRACE_EVENT within ftrace stages. The side-effect of these extra semicolons are:

a) to pollute the preprocessor output, leaving extra ";" between trace event
instances in trace points creation.

b) to render impossible creation of an array of events. Extra semicolons are
not a matter as long as TRACE_EVENT creates statements, structure elements or
functions, because extra semicolons are discarded by the compiler. However,
when creating an array, the separator is the comma, and the semicolon causes a
parse error.


* So what is the motivation for removing these semicolons ?

Currently, Ftrace is creating a "ftrace_define_fields_##call" function for each
event to define the event fields, which consumes space. It also has the
".fields" list head to keep a dynamically generated list of event fields.

By allowing creation of arrays of events, we can do the following: turn the
dynamically created list of event fields into a first-level const array listing
event fields. We can use ARRAY_SIZE() on this array to know its size,
statically. Then, in a following trace event stage, we can create another const
array containing tuples of (pointers to the event-specific arrays, array size).

So we get all the same information Ftrace currently gets with much less code
overall, much less read-write data, and less dynamic initialization code.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/tracepoint.h |    4 ++--
 include/trace/ftrace.h     |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6-lttng/include/trace/ftrace.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/ftrace.h
+++ linux-2.6-lttng/include/trace/ftrace.h
@@ -34,8 +34,8 @@
 			     PARAMS(args),		       \
 			     PARAMS(tstruct),		       \
 			     PARAMS(assign),		       \
-			     PARAMS(print));		       \
-	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));
+			     PARAMS(print))		       \
+	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args))
 
 
 #undef __field
@@ -69,7 +69,7 @@
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)	\
 	static struct ftrace_event_call	__used		\
-	__attribute__((__aligned__(4))) event_##name
+	__attribute__((__aligned__(4))) event_##name;
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
@@ -588,7 +588,7 @@ static struct ftrace_event_call __used e
 	.print_fmt		= print_fmt_##template,			\
 };									\
 static struct ftrace_event_call __used					\
-__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
+__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
@@ -602,7 +602,7 @@ static struct ftrace_event_call __used e
 	.print_fmt		= print_fmt_##call,			\
 };									\
 static struct ftrace_event_call __used					\
-__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
+__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
Index: linux-2.6-lttng/include/linux/tracepoint.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/tracepoint.h
+++ linux-2.6-lttng/include/linux/tracepoint.h
@@ -187,7 +187,7 @@ do_trace:								\
 		&__tracepoint_##name;
 
 #define DEFINE_TRACE(name)						\
-	DEFINE_TRACE_FN(name, NULL, NULL);
+	DEFINE_TRACE_FN(name, NULL, NULL)
 
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)				\
 	EXPORT_SYMBOL_GPL(__tracepoint_##name)
@@ -345,7 +345,7 @@ do_trace:								\
  *		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
  *		__entry->next_comm, __entry->next_pid, __entry->next_prio),
  *
- * );
+ * )
  *
  * This macro construct is thus used for the regular printk format
  * tracing setup, it is used to construct a function pointer based

