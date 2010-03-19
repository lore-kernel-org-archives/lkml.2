Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab0CSUyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:54:00 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45421 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab0CSUxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:53:32 -0400
Message-Id: <20100319205233.142080173@efficios.com>
References: <20100319204739.574593298@efficios.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Mar 2010 16:47:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC patch 1/3] Debugobjects transition check
Content-Disposition: inline; filename=debugobjects-transition-check.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 19 Mar 2010 20:52:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a basic state machine checker in the debugobjects.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org
CC: mingo@elte.hu
CC: laijs@cn.fujitsu.com
CC: dipankar@in.ibm.com
CC: josh@joshtriplett.org
CC: dvhltc@us.ibm.com
CC: niv@us.ibm.com
CC: tglx@linutronix.de
CC: peterz@infradead.org
CC: rostedt@goodmis.org
CC: Valdis.Kletnieks@vt.edu
CC: dhowells@redhat.com
CC: eric.dumazet@gmail.com
CC: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/debugobjects.h |    9 ++++++
 lib/debugobjects.c           |   59 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 65 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/linux/debugobjects.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/debugobjects.h	2010-03-19 15:26:02.000000000 -0400
+++ linux-2.6-lttng/include/linux/debugobjects.h	2010-03-19 15:26:06.000000000 -0400
@@ -20,12 +20,14 @@ struct debug_obj_descr;
  * struct debug_obj - representaion of an tracked object
  * @node:	hlist node to link the object into the tracker list
  * @state:	tracked object state
+ * @astate:	current active state
  * @object:	pointer to the real object
  * @descr:	pointer to an object type specific debug description structure
  */
 struct debug_obj {
 	struct hlist_node	node;
 	enum debug_obj_state	state;
+	unsigned int		astate;
 	void			*object;
 	struct debug_obj_descr	*descr;
 };
@@ -60,6 +62,13 @@ extern void debug_object_deactivate(void
 extern void debug_object_destroy   (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_free      (void *addr, struct debug_obj_descr *descr);
 
+/*
+ * Active state must return to 0 before deactivation.
+ */
+extern void
+debug_object_active_state(void *addr, struct debug_obj_descr *descr,
+			  unsigned int expect, unsigned int next);
+
 extern void debug_objects_early_init(void);
 extern void debug_objects_mem_init(void);
 #else
Index: linux-2.6-lttng/lib/debugobjects.c
===================================================================
--- linux-2.6-lttng.orig/lib/debugobjects.c	2010-03-19 15:26:02.000000000 -0400
+++ linux-2.6-lttng/lib/debugobjects.c	2010-03-19 15:26:06.000000000 -0400
@@ -140,6 +140,7 @@ alloc_object(void *addr, struct debug_bu
 		obj->object = addr;
 		obj->descr  = descr;
 		obj->state  = ODEBUG_STATE_NONE;
+		obj->astate = 0;
 		hlist_del(&obj->node);
 
 		hlist_add_head(&obj->node, &b->list);
@@ -251,8 +252,10 @@ static void debug_print_object(struct de
 
 	if (limit < 5 && obj->descr != descr_test) {
 		limit++;
-		WARN(1, KERN_ERR "ODEBUG: %s %s object type: %s\n", msg,
-		       obj_states[obj->state], obj->descr->name);
+		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
+				 "object type: %s\n",
+			msg, obj_states[obj->state], obj->astate,
+			obj->descr->name);
 	}
 	debug_objects_warnings++;
 }
@@ -446,7 +449,10 @@ void debug_object_deactivate(void *addr,
 		case ODEBUG_STATE_INIT:
 		case ODEBUG_STATE_INACTIVE:
 		case ODEBUG_STATE_ACTIVE:
-			obj->state = ODEBUG_STATE_INACTIVE;
+			if (!obj->astate)
+				obj->state = ODEBUG_STATE_INACTIVE;
+			else
+				debug_print_object(obj, "deactivate");
 			break;
 
 		case ODEBUG_STATE_DESTROYED:
@@ -552,6 +558,53 @@ out_unlock:
 	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
 
+/**
+ * debug_object_active_state - debug checks object usage state machine
+ * @addr:	address of the object
+ * @descr:	pointer to an object specific debug description structure
+ * @expect:	expected state
+ * @next:	state to move to if expected state is found
+ */
+void
+debug_object_active_state(void *addr, struct debug_obj_descr *descr,
+			  unsigned int expect, unsigned int next)
+{
+	struct debug_bucket *db;
+	struct debug_obj *obj;
+	unsigned long flags;
+
+	if (!debug_objects_enabled)
+		return;
+
+	db = get_bucket((unsigned long) addr);
+
+	raw_spin_lock_irqsave(&db->lock, flags);
+
+	obj = lookup_object(addr, db);
+	if (obj) {
+		switch (obj->state) {
+		case ODEBUG_STATE_ACTIVE:
+			if (obj->astate == expect)
+				obj->astate = next;
+			else
+				debug_print_object(obj, "active_state");
+			break;
+
+		default:
+			debug_print_object(obj, "active_state");
+			break;
+		}
+	} else {
+		struct debug_obj o = { .object = addr,
+				       .state = ODEBUG_STATE_NOTAVAILABLE,
+				       .descr = descr };
+
+		debug_print_object(&o, "active_state");
+	}
+
+	raw_spin_unlock_irqrestore(&db->lock, flags);
+}
+
 #ifdef CONFIG_DEBUG_OBJECTS_FREE
 static void __debug_check_no_obj_freed(const void *address, unsigned long size)
 {

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
