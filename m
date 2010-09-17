Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab0IQPJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:09:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0IQPJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:09:51 -0400
Date: Fri, 17 Sep 2010 11:09:13 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Message-Id: <a9ba2056e2c9cf332c3c300b577463ce66ff23a8.1284733808.git.jbaron@redhat.com>
In-Reply-To: <cover.1284733808.git.jbaron@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
Subject: [PATCH 06/10] jump label v11: tracepoint support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the jump label infrastructure for tracepoints.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/tracepoint.h |    5 ++++-
 kernel/tracepoint.c        |   14 ++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 103d1b6..a4a90b6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/rcupdate.h>
+#include <linux/jump_label.h>
 
 struct module;
 struct tracepoint;
@@ -145,7 +146,9 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	extern struct tracepoint __tracepoint_##name;			\
 	static inline void trace_##name(proto)				\
 	{								\
-		if (unlikely(__tracepoint_##name.state))		\
+		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
+		return;							\
+do_trace:								\
 			__DO_TRACE(&__tracepoint_##name,		\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args));			\
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index c77f3ec..d6073a5 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/jump_label.h>
 
 extern struct tracepoint __start___tracepoints[];
 extern struct tracepoint __stop___tracepoints[];
@@ -263,7 +264,13 @@ static void set_tracepoint(struct tracepoint_entry **entry,
 	 * is used.
 	 */
 	rcu_assign_pointer(elem->funcs, (*entry)->funcs);
-	elem->state = active;
+	if (!elem->state && active) {
+		enable_jump_label(&elem->state);
+		elem->state = active;
+	} else if (elem->state && !active) {
+		disable_jump_label(&elem->state);
+		elem->state = active;
+	}
 }
 
 /*
@@ -277,7 +284,10 @@ static void disable_tracepoint(struct tracepoint *elem)
 	if (elem->unregfunc && elem->state)
 		elem->unregfunc();
 
-	elem->state = 0;
+	if (elem->state) {
+		disable_jump_label(&elem->state);
+		elem->state = 0;
+	}
 	rcu_assign_pointer(elem->funcs, NULL);
 }
 
-- 
1.7.1

