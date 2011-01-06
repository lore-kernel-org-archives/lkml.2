Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1AFThA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 14:37:00 -0500
Received: from mail.openrapids.net ([64.15.138.104]:41834 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751580Ab1AFTg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 14:36:58 -0500
Date: Thu, 6 Jan 2011 14:36:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] TRACE_EVENT: gradual semicolumn removal
Message-ID: <20110106193656.GB2866@Krystal>
References: <20110106184732.GB2526@Krystal> <20110106105845.6b1ec41b.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106105845.6b1ec41b.rdunlap@xenotime.net>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:36:04 up 44 days, 39 min,  5 users,  load average: 0.00, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (rdunlap@xenotime.net) wrote:
> On Thu, 6 Jan 2011 13:47:32 -0500 Mathieu Desnoyers wrote:
> 
> > This patch initiates the removal of the extra semicolumns at the end of:
> 
> Please s/semicolumn/semicolon/ globally.

Here is the updated patch, thanks!


TRACE_EVENT: gradual semicolon removal

This patch initiates the removal of the extra semicolons at the end of:

TRACE_EVENT(
   ....
);     <---- here

DEFINE_EVENT(
   ...
);     <---- and here

by removing the semicolon from the comment in tracepoint.h explaining the
TRACE_EVENT() usage.

Adding the missing semicolon within the DEFINE_EVENT() macro is required as a
preliminary step to remove extra semicolons.  We currently are not seeing any
impact of this missing semicolon because extra they appear all over the
place in the code generated from TRACE_EVENT within ftrace stages. The
side-effect of these extra semicolons are:

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


* Why do this incrementally ?

After this preliminary patch, the semicolon removal can be done gradually
without breaking the build: we can be in an intermediate state with some files
having semicolons and others without. This is therefore good for
bissectability, and seems like a nice way to bring in an internal API change
without making developers suffer too much. Then, once things are stabilized, we
can start modifying the Ftrace code to generate the more space-efficient arrays
(possibly in a release-cycle or so), knowing that this enforces a strict
requirement on semicolon removal.

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
