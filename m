Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2BQNsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:48:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2BQNsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:48:35 -0500
Date: Fri, 17 Feb 2012 05:47:40 -0800
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-2fbb90db1b8fcc78f43830f1a009f3af243c5f42@git.kernel.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, rostedt@goodmis.org, srostedt@redhat.com,
        josh@joshtriplett.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, rostedt@goodmis.org, srostedt@redhat.com,
        josh@joshtriplett.org, tglx@linutronix.de
In-Reply-To: <1328563113.2200.39.camel@gandalf.stny.rr.com>
References: <1328563113.2200.39.camel@gandalf.stny.rr.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/rcu: Add trace_##name##__rcuidle()
  static tracepoint for inside rcu_idle_exit() sections
Git-Commit-ID: 2fbb90db1b8fcc78f43830f1a009f3af243c5f42
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 05:48:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fbb90db1b8fcc78f43830f1a009f3af243c5f42
Gitweb:     http://git.kernel.org/tip/2fbb90db1b8fcc78f43830f1a009f3af243c5f42
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 7 Feb 2012 09:32:43 -0500
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 13 Feb 2012 08:23:21 -0500

tracing/rcu: Add trace_##name##__rcuidle() static tracepoint for inside rcu_idle_exit() sections

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
 include/linux/tracepoint.h |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index df0a779..fc36da9 100644
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
@@ -190,9 +202,11 @@ static inline void tracepoint_synchronize_unregister(void)
 	EXPORT_SYMBOL(__tracepoint_##name)
 
 #else /* !CONFIG_TRACEPOINTS */
-#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
+#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
 	static inline void trace_##name(proto)				\
 	{ }								\
+	static inline void trace_##name##_rcuidle(proto)		\
+	{ }								\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto),		\
 			      void *data)				\
