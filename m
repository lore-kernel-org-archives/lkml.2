Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0DDOhN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:37:13 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53038 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab0DDOg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:36:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EjYMuHyrLIbZ3UXeoJLEm+AG+fwwS+zJoj8Jn9hOHET1f9g5Sw17SPudlhbRMMVp1u
         AmIiTmzmHNO7Zr/11JmXbVqDIlLOqvlkQBNFw1tX8KDqwrhTbQfL6doMz7srG+O1NtnJ
         oQ8mE3izGCwFA6WnnRdshjXranFVDCSSvJY28=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/4] perf: Fetch hot regs from the template caller
Date: Sun,  4 Apr 2010 16:36:42 +0200
Message-Id: <1270391804-6552-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
References: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace events can be defined from a template using
DECLARE_EVENT_CLASS/DEFINE_EVENT or directly with TRACE_EVENT.

In both cases we have a template tracepoint handler, used to
record the trace, to which we pass our ftrace event instance.

In the function level, if the class is named "foo" and the event
is named "blah", we have the following chain of calls:

perf_trace_blah() -> perf_trace_templ_foo()

In the case we have several events sharing the class "blah",
we'll have multiple users of perf_trace_templ_foo(), and it
won't be inlined by the compiler. This is usually what happens
with the DECLARE_EVENT_CLASS/DEFINE_EVENT based definition.

But if perf_trace_blah() is the only caller of perf_trace_templ_foo()
there are fair chances that it will be inlined.

The problem is that we fetch the regs from perf_trace_templ_foo()
after we rewinded the frame pointer to the second caller, we want
to reach the caller of perf_trace_blah() to get the right source
of the event. And we do this by always assuming that
perf_trace_templ_foo() is not inlined. But as shown above this
is not always true. And if it is inlined we miss the first caller,
losing the most important level of precision.

We get:
	    61.31%       ls  [kernel.kallsyms]  [k] do_softirq
                         |
                         --- do_softirq
                             irq_exit
                             do_IRQ
                             common_interrupt
                            |
                            |--25.00%-- tty_buffer_request_room

Instead of:
	    61.31%       ls  [kernel.kallsyms]  [k] __do_softirq
                         |
                         --- __do_softirq
                             do_softirq
                             irq_exit
                             do_IRQ
                             common_interrupt
                            |
                            |--25.00%-- tty_buffer_request_room

To fix this, we fetch the regs from perf_trace_blah() rather than
perf_trace_templ_foo() so that we don't have to deal with inlining
surprises.

That also bring us the advantage of having the true source of the
event even if we don't have frame pointers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/trace/ftrace.h |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index ea6f9d4..882c648 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -758,13 +758,12 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace void							\
 perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
-			    proto)					\
+			struct pt_regs *__regs, proto)			\
 {									\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
 	struct ftrace_raw_##call *entry;				\
 	u64 __addr = 0, __count = 1;					\
 	unsigned long irq_flags;					\
-	struct pt_regs *__regs;						\
 	int __entry_size;						\
 	int __data_size;						\
 	int rctx;							\
@@ -785,20 +784,22 @@ perf_trace_templ_##call(struct ftrace_event_call *event_call,		\
 									\
 	{ assign; }							\
 									\
-	__regs = &__get_cpu_var(perf_trace_regs);			\
-	perf_fetch_caller_regs(__regs, 2);				\
-									\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
 			       __count, irq_flags, __regs);		\
 }
 
 #undef DEFINE_EVENT
-#define DEFINE_EVENT(template, call, proto, args)		\
-static notrace void perf_trace_##call(proto)			\
-{								\
-	struct ftrace_event_call *event_call = &event_##call;	\
-								\
-	perf_trace_templ_##template(event_call, args);		\
+#define DEFINE_EVENT(template, call, proto, args)			\
+static notrace void perf_trace_##call(proto)				\
+{									\
+	struct ftrace_event_call *event_call = &event_##call;		\
+	struct pt_regs *__regs = &get_cpu_var(perf_trace_regs);		\
+									\
+	perf_fetch_caller_regs(__regs, 1);				\
+									\
+	perf_trace_templ_##template(event_call, __regs, args);		\
+									\
+	put_cpu_var(perf_trace_regs);					\
 }
 
 #undef DEFINE_EVENT_PRINT
-- 
1.6.2.3

