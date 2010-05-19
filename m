Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0ESQWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:22:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab0ESQWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:22:35 -0400
Date: Wed, 19 May 2010 12:22:01 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com
Message-Id: <4b3aaa07e71e713769e12d4d1b2556d366958a77.1274283321.git.jbaron@redhat.com>
In-Reply-To: <cover.1274283321.git.jbaron@redhat.com>
References: <cover.1274283321.git.jbaron@redhat.com>
Subject: [PATCH 04/13] jump label v8: tracepoint support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the jump label infrastructure for tracepoints.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/tracepoint.h |   34 +++++++++++++++++++---------------
 kernel/tracepoint.c        |    8 ++++++++
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 1d85f9a..ea78e92 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -16,6 +16,7 @@
 
 #include <linux/types.h>
 #include <linux/rcupdate.h>
+#include <linux/jump_label.h>
 
 struct module;
 struct tracepoint;
@@ -122,20 +123,22 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  */
-#define DECLARE_TRACE(name, proto, args)				\
-	extern struct tracepoint __tracepoint_##name;			\
-	static inline void trace_##name(proto)				\
-	{								\
-		if (unlikely(__tracepoint_##name.state))		\
-			__DO_TRACE(&__tracepoint_##name,		\
-				TP_PROTO(proto), TP_ARGS(args));	\
-	}								\
-	static inline int register_trace_##name(void (*probe)(proto))	\
-	{								\
-		return tracepoint_probe_register(#name, (void *)probe);	\
-	}								\
-	static inline int unregister_trace_##name(void (*probe)(proto))	\
-	{								\
+#define DECLARE_TRACE(name, proto, args)				 \
+	extern struct tracepoint __tracepoint_##name;			 \
+	static inline void trace_##name(proto)				 \
+	{								 \
+		JUMP_LABEL(&__tracepoint_##name, do_trace, __tracepoint_##name.state);\
+		return;							 \
+do_trace:								 \
+		__DO_TRACE(&__tracepoint_##name,			 \
+			   TP_PROTO(proto), TP_ARGS(args));		 \
+	}								 \
+	static inline int register_trace_##name(void (*probe)(proto))	 \
+	{								 \
+		return tracepoint_probe_register(#name, (void *)probe);	 \
+	}								 \
+	static inline int unregister_trace_##name(void (*probe)(proto))	 \
+	{								 \
 		return tracepoint_probe_unregister(#name, (void *)probe);\
 	}
 
@@ -145,7 +148,8 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
 	struct tracepoint __tracepoint_##name				\
 	__attribute__((section("__tracepoints"), aligned(32))) =	\
-		{ __tpstrtab_##name, 0, reg, unreg, NULL }
+		{ __tpstrtab_##name, 0, reg, unreg, NULL };		\
+	DEFINE_JUMP_LABEL(name);
 
 #define DEFINE_TRACE(name)						\
 	DEFINE_TRACE_FN(name, NULL, NULL);
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index cc89be5..8acced8 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/jump_label.h>
 
 extern struct tracepoint __start___tracepoints[];
 extern struct tracepoint __stop___tracepoints[];
@@ -256,6 +257,10 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
+	if (!elem->state && active)
+		enable_jump_label(elem->name);
+	if (elem->state && !active)
+		disable_jump_label(elem->name);
 	elem->state = active;
 }
 
@@ -270,6 +275,9 @@ static void disable_tracepoint(struct tracepoint *elem)
 	if (elem->unregfunc && elem->state)
 		elem->unregfunc();
 
+	if (elem->state)
+		disable_jump_label(elem->name);
+
 	elem->state = 0;
 	rcu_assign_pointer(elem->funcs, NULL);
 }
-- 
1.7.0.1

