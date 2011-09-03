Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1ICSFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 14:05:47 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51764 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab1ICSFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 14:05:32 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Sep 2011 14:05:30 EDT
Message-Id: <20110903175543.544717224@efficios.com>
User-Agent: quilt/0.48-1
Date: Sat, 03 Sep 2011 13:47:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Huang Ying <ying.huang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, lenb@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC patch 2/2] llstack: make llstack_push return "prior empty state" information
References: <20110903174721.390074195@efficios.com>
Content-Disposition: inline; filename=llstack-push-return-empty-state.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sat,  3 Sep 2011 17:55:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A feature request from Peter Zijlstra outlines very well the need for an
llstack API that allows the push operation to return whether the stack
was empty or not before the operation. Peter wants to use this
information to know if a irq_work should be raised when pushing into the
stack.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Huang Ying <ying.huang@intel.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: "lenb@kernel.org" <lenb@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/llstack.h |    6 +++---
 lib/llstack.c           |   15 +++++++++++++--
 2 files changed, 16 insertions(+), 5 deletions(-)

Index: linux-2.6-lttng/lib/llstack.c
===================================================================
--- linux-2.6-lttng.orig/lib/llstack.c
+++ linux-2.6-lttng/lib/llstack.c
@@ -8,6 +8,7 @@
  *
  * Copyright 2010,2011 Intel Corp.
  *   Author: Huang Ying <ying.huang@intel.com>
+ * Copyright 2011 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version
@@ -33,8 +34,11 @@
  * llstack_push - push a node into a lock-less stack.
  * @new:       new entry to be added
  * @head:      the head for your lock-less stack
+ *
+ * Returns 0 if the stack was empty prior to push operation (check performed
+ * atomically with push), returns 1 otherwise.
  */
-void llstack_push(struct llstack_node *new, struct llstack_head *head)
+int llstack_push(struct llstack_node *new, struct llstack_head *head)
 {
 	struct llstack_node *entry, *old_entry;
 
@@ -48,6 +52,8 @@ void llstack_push(struct llstack_node *n
 		new->next = entry;
 		cpu_relax();
 	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
+
+	return !!(unsigned long) entry;
 }
 EXPORT_SYMBOL_GPL(llstack_push);
 
@@ -56,8 +62,11 @@ EXPORT_SYMBOL_GPL(llstack_push);
  * @new_first:	first entry in batch to be added
  * @new_last:	last entry in batch to be added
  * @head:	the head for your lock-less list
+ *
+ * Returns 0 if the stack was empty prior to push operation (check performed
+ * atomically with push), returns 1 otherwise.
  */
-void llstack_push_batch(struct llstack_node *new_first, struct llstack_node *new_last,
+int llstack_push_batch(struct llstack_node *new_first, struct llstack_node *new_last,
 			struct llstack_head *head)
 {
 	struct llstack_node *entry, *old_entry;
@@ -72,6 +81,8 @@ void llstack_push_batch(struct llstack_n
 		new_last->next = entry;
 		cpu_relax();
 	} while ((entry = cmpxchg(&head->first, old_entry, new_first)) != old_entry);
+
+	return !!(unsigned long) entry;
 }
 EXPORT_SYMBOL_GPL(llstack_push_batch);
 
Index: linux-2.6-lttng/include/linux/llstack.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/llstack.h
+++ linux-2.6-lttng/include/linux/llstack.h
@@ -118,9 +118,9 @@ static inline int llstack_empty(const st
 	return ACCESS_ONCE(head->first) == NULL;
 }
 
-void llstack_push(struct llstack_node *new, struct llstack_head *head);
-void llstack_push_batch(struct llstack_node *new_first, struct llstack_node *new_last,
-			struct llstack_head *head);
+int llstack_push(struct llstack_node *new, struct llstack_head *head);
+int llstack_push_batch(struct llstack_node *new_first, struct llstack_node *new_last,
+		       struct llstack_head *head);
 struct llstack_node *llstack_pop(struct llstack_head *head);
 struct llstack_node *llstack_pop_all(struct llstack_head *head);
 #endif /* LLSTACK_H */

