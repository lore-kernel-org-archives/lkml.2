Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2INGIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:08:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48844 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2INGIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:08:00 -0400
Date: Thu, 13 Sep 2012 23:07:39 -0700
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-7ece55a4a3a04abe37118b1d4fb0b702eeb1de4c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mathieu.desnoyers@efficios.com, paulmck@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, josh@joshtriplett.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, paulmck@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, josh@joshtriplett.org
In-Reply-To: <20120905062306.GA14756@leaf>
References: <20120905062306.GA14756@leaf>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] trace: Don'
 t declare trace_*_rcuidle functions in modules
Git-Commit-ID: 7ece55a4a3a04abe37118b1d4fb0b702eeb1de4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:07:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ece55a4a3a04abe37118b1d4fb0b702eeb1de4c
Gitweb:     http://git.kernel.org/tip/7ece55a4a3a04abe37118b1d4fb0b702eeb1de4c
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Tue, 4 Sep 2012 23:23:06 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 12 Sep 2012 10:20:14 -0400

trace: Don't declare trace_*_rcuidle functions in modules

Tracepoints declare a static inline trace_*_rcuidle variant of the trace
function, to support safely generating trace events from the idle loop.
Module code never actually uses that variant of trace functions, because
modules don't run code that needs tracing with RCU idled.  However, the
declaration of those otherwise unused functions causes the module to
reference rcu_idle_exit and rcu_idle_enter, which RCU does not export to
modules.

To avoid this, don't generate trace_*_rcuidle functions for tracepoints
declared in module code.

Link: http://lkml.kernel.org/r/20120905062306.GA14756@leaf

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 802de56..2f322c3 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -136,6 +136,22 @@ static inline void tracepoint_synchronize_unregister(void)
 		postrcu;						\
 	} while (0)
 
+#ifndef MODULE
+#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)	\
+	static inline void trace_##name##_rcuidle(proto)		\
+	{								\
+		if (static_key_false(&__tracepoint_##name.key))		\
+			__DO_TRACE(&__tracepoint_##name,		\
+				TP_PROTO(data_proto),			\
+				TP_ARGS(data_args),			\
+				TP_CONDITION(cond),			\
+				rcu_idle_exit(),			\
+				rcu_idle_enter());			\
+	}
+#else
+#define __DECLARE_TRACE_RCU(name, proto, args, cond, data_proto, data_args)
+#endif
+
 /*
  * Make sure the alignment of the structure in the __tracepoints section will
  * not add unwanted padding between the beginning of the section and the
@@ -151,16 +167,8 @@ static inline void tracepoint_synchronize_unregister(void)
 				TP_ARGS(data_args),			\
 				TP_CONDITION(cond),,);			\
 	}								\
-	static inline void trace_##name##_rcuidle(proto)		\
-	{								\
-		if (static_key_false(&__tracepoint_##name.key))		\
-			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(data_proto),			\
-				TP_ARGS(data_args),			\
-				TP_CONDITION(cond),			\
-				rcu_idle_exit(),			\
-				rcu_idle_enter());			\
-	}								\
+	__DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),		\
+		PARAMS(cond), PARAMS(data_proto), PARAMS(data_args))	\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto), void *data)	\
 	{								\
