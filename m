Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1KYWOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 17:14:15 -0500
Received: from mail.openrapids.net ([64.15.138.104]:58282 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753389Ab1KYWOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 17:14:14 -0500
Date: Fri, 25 Nov 2011 17:14:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] Tracepoint: introduce tracepoint() API
Message-ID: <20111125221411.GA11733@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:04:28 up 367 days,  3:07,  8 users,  load average: 0.14, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce:

  tracepoint(event_name, arg1, arg2, ...)

while keeping the old tracepoint API in place, e.g.:

  trace_event_name(arg1, arg2, ...)

This allows skipping parameter side-effects (pointer dereference,
function calls, ...) when the tracepoint is not dynamically activated.

This allows progressive (and partial) API transition from trace_*(...)
to tracepoint(*, ...). This differs from the previous attempt to
introduce this change by Jason Baron in that it supports both the
original and new tracepoint APIs, which makes the transition smoother
than having to change all instrumentation at once.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jason Baron <jbaron@redhat.com>
Link: https://lkml.org/lkml/2009/5/19/328
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <cl@linux-foundation.org>
---
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index d530a44..c9c73f7 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -107,6 +107,12 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
 
 #ifdef CONFIG_TRACEPOINTS
 
+#define tracepoint(name, args...)					\
+	do {								\
+		if (static_branch(&__tracepoint_##name.key))		\
+			__trace_##name(args);				\
+	} while (0)
+
 /*
  * it_func[0] is never NULL because there is at least one element in the array
  * when the array itself is non NULL.
@@ -144,13 +150,17 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
  */
 #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
 	extern struct tracepoint __tracepoint_##name;			\
+	static inline void __trace_##name(proto)			\
+	{								\
+		__DO_TRACE(&__tracepoint_##name,			\
+			TP_PROTO(data_proto),				\
+			TP_ARGS(data_args),				\
+			TP_CONDITION(cond));				\
+	}								\
 	static inline void trace_##name(proto)				\
 	{								\
 		if (static_branch(&__tracepoint_##name.key))		\
-			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(data_proto),			\
-				TP_ARGS(data_args),			\
-				TP_CONDITION(cond));			\
+			__trace_##name(args);				\
 	}								\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto), void *data)	\
@@ -193,7 +203,12 @@ void tracepoint_update_probe_range(struct tracepoint * const *begin,
 	EXPORT_SYMBOL(__tracepoint_##name)
 
 #else /* !CONFIG_TRACEPOINTS */
+
+#define tracepoint(name, args...)	__trace_##name(args)
+
 #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
+	static inline void __trace_##name(proto)			\
+	{ }								\
 	static inline void trace_##name(proto)				\
 	{ }								\
 	static inline int						\

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
