Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab0DFMxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 08:53:13 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56975 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755180Ab0DFMxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 08:53:06 -0400
Date: Tue, 6 Apr 2010 08:53:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, adobriyan@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 1/5] Debugobjects transition check (updated changelog)
Message-ID: <20100406125302.GA22529@Krystal>
References: <20100329143405.252313609@efficios.com> <20100329143701.765545140@efficios.com> <alpine.LFD.2.00.1003301819060.32352@localhost.localdomain> <20100331133100.GA25453@Krystal> <alpine.LFD.2.00.1003311549250.32352@localhost.localdomain> <20100331142736.GA26207@Krystal> <alpine.LFD.2.00.1004061013340.32352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004061013340.32352@localhost.localdomain>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:52:15 up 73 days, 15:29,  7 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a basic state machine checker in the debugobjects.

This state machine checker detects races and inconsistencies within the "active"
life of a debugobject. The checker only keeps track of the current state; all
the state machine logic is kept at the object instance level.

The checker works by adding a supplementary "unsigned int astate" field to the
debug_obj structure. It keeps track of the current "active state" of the object.

The only constraints that are imposed on the states by the debugobjects system
is that:

- activation of an object sets the current active state to 0,
- deactivation of an object expects the current active state to be 0.

For the rest of the states, the state mapping is determined by the specific
object instance. Therefore, the logic keeping track of the state machine is
within the specialized instance, without any need to know about it at the
debugobject level.

The current object active state is changed by calling:

debug_object_active_state(addr, descr, expect, next)

where "expect" is the expected state and "next" is the next state to move to if
the expected state is found. A warning is generated if the expected is not
found.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: David S. Miller <davem@davemloft.net>
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
 include/linux/debugobjects.h |   11 ++++++++
 lib/debugobjects.c           |   59 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 67 insertions(+), 3 deletions(-)

Index: linux.trees.git/include/linux/debugobjects.h
===================================================================
--- linux.trees.git.orig/include/linux/debugobjects.h	2010-03-27 18:48:23.000000000 -0400
+++ linux.trees.git/include/linux/debugobjects.h	2010-03-27 18:50:09.000000000 -0400
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
@@ -60,6 +62,15 @@ extern void debug_object_deactivate(void
 extern void debug_object_destroy   (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_free      (void *addr, struct debug_obj_descr *descr);
 
+/*
+ * Active state:
+ * - Set at 0 upon initialization.
+ * - Must return to 0 before deactivation.
+ */
+extern void
+debug_object_active_state(void *addr, struct debug_obj_descr *descr,
+			  unsigned int expect, unsigned int next);
+
 extern void debug_objects_early_init(void);
 extern void debug_objects_mem_init(void);
 #else
Index: linux.trees.git/lib/debugobjects.c
===================================================================
--- linux.trees.git.orig/lib/debugobjects.c	2010-03-27 18:48:23.000000000 -0400
+++ linux.trees.git/lib/debugobjects.c	2010-03-27 18:50:09.000000000 -0400
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
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
