Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab0IWD4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:56:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47905 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab0IWD4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:56:12 -0400
X-Authority-Analysis: v=1.1 cv=xllhIT3+0iZermAJQK9ulaVoiSOvD1gApk/LON5m1IU= c=1 sm=0 a=9DG58e4mvesA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=QIk3ugFRuPN_r2Y2-TQA:9 a=3wHkLTJF4TJQoLGL4zIA:7 a=E5IL4h63spE6o1kBs4o0r77-ca0A:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100923035608.884988118@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 22 Sep 2010 23:49:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>
Subject: [PATCH 06/11] jump label: Tracepoint support for jump labels
References: <20100923034910.867858597@goodmis.org>
Content-Disposition: inline; filename=0006-jump-label-Tracepoint-support-for-jump-labels.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Make use of the jump label infrastructure for tracepoints.

Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <a9ba2056e2c9cf332c3c300b577463ce66ff23a8.1284733808.git.jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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


