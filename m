Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab2BGPLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:11:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63574 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab2BGPKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:10:50 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=SEpPaoqGAvwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=VnNF1IyMAAAA:8 a=UPm3pfgAAAAA:8 a=meVymXHHAAAA:8 a=wv91tmdJEZCA7l7znooA:9 a=_Pu3XhDJXVXLl6GBpEQA:7 a=jEp0ucaQiEUA:10 a=mOio7EKfaG4A:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120207151049.164032464@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 07 Feb 2012 09:56:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 1/3][RFC] tracing/rcu: Add trace_##name##__rcuidle() static tracepoint for
 inside rcu_idle_exit() sections
References: <20120207145653.829892056@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-rcu-Add-trace_-name-__rcuidle-static-tracepo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Added is a new static inline function that lets *any* tracepoint be used
inside a rcu_idle_exit() section. And this also solves the problem where
the same tracepoint may be used inside a rcu_idle_exit() section as well
as outside of one.

I added a new tracepoint function with a "_rcuidle" extension. All
tracepoints can be used with either the normal "trace_foobar()"
function, or the "trace_foobar_rcuidle()" function when inside a
rcu_idle_exit() section.

All tracepoints defined by TRACE_EVENT() or any of the derivatives
will have a "_rcuidle()" function also defined. When a tracepoint is
used within an rcu_idle_exit() section, the "_rcuidle()" version must
be used. This denotes that the tracepoint is within rcu_idle_exit()
and it allows the rcu read locks within the tracepoint to still
be valid, as this version takes us out of rcu_idle_exit().

Another nice aspect about this patch is that "static inline"s are not
compiled into text when not used. So only the tracepoints that actually
use the _rcuidle() version will have them defined in the actual text
that is booted.

Link: http://lkml.kernel.org/r/1328563113.2200.39.camel@gandalf.stny.rr.com>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index df0a779..00d073a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -114,7 +114,7 @@ static inline void tracepoint_synchronize_unregister(void)
  * as "(void *, void)". The DECLARE_TRACE_NOARGS() will pass in just
  * "void *data", where as the DECLARE_TRACE() will pass in "void *data, proto".
  */
-#define __DO_TRACE(tp, proto, args, cond)				\
+#define __DO_TRACE(tp, proto, args, cond, prercu, postrcu)		\
 	do {								\
 		struct tracepoint_func *it_func_ptr;			\
 		void *it_func;						\
@@ -122,6 +122,7 @@ static inline void tracepoint_synchronize_unregister(void)
 									\
 		if (!(cond))						\
 			return;						\
+		prercu;							\
 		rcu_read_lock_sched_notrace();				\
 		it_func_ptr = rcu_dereference_sched((tp)->funcs);	\
 		if (it_func_ptr) {					\
@@ -132,6 +133,7 @@ static inline void tracepoint_synchronize_unregister(void)
 			} while ((++it_func_ptr)->func);		\
 		}							\
 		rcu_read_unlock_sched_notrace();			\
+		postrcu;						\
 	} while (0)
 
 /*
@@ -139,7 +141,7 @@ static inline void tracepoint_synchronize_unregister(void)
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
+#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
@@ -147,7 +149,17 @@ static inline void tracepoint_synchronize_unregister(void)
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
-				TP_CONDITION(cond));			\
+				TP_CONDITION(cond),,);			\
+	}								\
+	static inline void trace_##name##_rcuidle(proto)		\
+	{								\
+		if (static_branch(&__tracepoint_##name.key))		\
+			__DO_TRACE(&__tracepoint_##name,		\
+				TP_PROTO(data_proto),			\
+				TP_ARGS(data_args),			\
+				TP_CONDITION(cond),			\
+				rcu_idle_exit(),			\
+				rcu_idle_enter());			\
 	}								\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto), void *data)	\
@@ -190,7 +202,7 @@ static inline void tracepoint_synchronize_unregister(void)
 	EXPORT_SYMBOL(__tracepoint_##name)
 
 #else /* !CONFIG_TRACEPOINTS */
-#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
+#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
 	static inline void trace_##name(proto)				\
 	{ }								\
 	static inline int						\
-- 
1.7.8.3


