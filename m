Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1AFSrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:47:35 -0500
Received: from mail.openrapids.net ([64.15.138.104]:46964 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753287Ab1AFSre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:47:34 -0500
Date: Thu, 6 Jan 2011 13:47:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] TRACE_EVENT: gradual semicolumn removal
Message-ID: <20110106184732.GB2526@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:45:57 up 43 days, 23:49,  5 users,  load average: 0.32, 0.14,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initiates the removal of the extra semicolumns at the end of:

TRACE_EVENT(
   ....
);     <---- here

DEFINE_EVENT(
   ...
);     <---- and here

by removing the semicolumn from the comment in tracepoint.h explaining the
TRACE_EVENT() usage.

Adding the missing semicolumn within the DEFINE_EVENT() macro is required as a
preliminary step to remove extra semicolumns.  We currently are not seeing any
impact of this missing semicolumn because extra they appear all over the
place in the code generated from TRACE_EVENT within ftrace stages. The
side-effect of these extra semicolumns are:

a) to pollute the preprocessor output, leaving extra ";" between trace event
instances in trace points creation.

b) to render impossible creation of an array of events. Extra semicolumns are
not a matter as long as TRACE_EVENT creates statements, structure elements or
functions, because extra semicolumns are discarded by the compiler. However,
when creating an array, the separator is the comma, and the semicolumn causes a
parse error.


* So what is the motivation for removing these semicolumns ?

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


* Why do this incrementally ?

After this preliminary patch, the semicolumn removal can be done gradually
without breaking the build: we can be in an intermediate state with some files
having semicolumns and others without. This is therefore good for
bissectability, and seems like a nice way to bring in an internal API change
without making developers suffer too much. Then, once things are stabilized, we
can start modifying the Ftrace code to generate the more space-efficient arrays
(possibly in a release-cycle or so), knowing that this enforces a strict
requirement on semicolumn removal.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/tracepoint.h |    2 +-
 include/trace/ftrace.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/trace/ftrace.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/ftrace.h
+++ linux-2.6-lttng/include/trace/ftrace.h
@@ -69,7 +69,7 @@
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)	\
 	static struct ftrace_event_call	__used		\
-	__attribute__((__aligned__(4))) event_##name
+	__attribute__((__aligned__(4))) event_##name;
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
Index: linux-2.6-lttng/include/linux/tracepoint.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/tracepoint.h
+++ linux-2.6-lttng/include/linux/tracepoint.h
@@ -326,7 +326,7 @@ static inline void tracepoint_update_pro
  *		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
  *		__entry->next_comm, __entry->next_pid, __entry->next_prio),
  *
- * );
+ * )
  *
  * This macro construct is thus used for the regular printk format
  * tracing setup, it is used to construct a function pointer based

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
