Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1G0TLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:11:51 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:54756 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab1G0TLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:11:48 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH RFCv2 2/8] rcu: More rcu-variants for list manipulation
Date: Wed, 27 Jul 2011 21:10:19 +0200
Message-Id: <1311793825-31933-3-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

This commit introduces some more *_rcu variants of some list
manipulation functions:

* __list_link_rcu()

  RCU-aware counterpart to __list_link()

* __list_splice_rcu(), list_splice_tail_init_rcu()

  RCU-aware non-blocking splicing.

  The existing rcu-splice function allows concurrent readers on the
  list to be spliced that are not from the destination list. Therefore,
  it has to block to get these readers off the list before the splicing
  can be done. The new functions forbid this and can, thus, work without
  blocking.

And a new function:

* list_add_tail_nobackref()

  This function is similar to list_add_tail() with the difference that
  the references from head->next and head->prev back to head are not
  maintained. This is mainly useful, when you are not allowed to
  overwrite them, because the nodes logically belong to an RCU protected
  list from which they were removed and there might still be readers on
  these nodes.

  As this function only makes sense with RCU-protected lists, it is
  added to rculist.h, although the function itself is completely unaware
  of RCU.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

---
Changes since v1:
- added comments
- added list_add_tail_nobackref()
---
 include/linux/rculist.h |  122 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 122 insertions(+), 0 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 748401b..445c4f2 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -25,6 +25,29 @@
 #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
 
 /*
+ * Link two list entries by making the prev/next entries
+ * point to each other.
+ *
+ * The next pointer of @prev is assigned RCU-aware. So, this
+ * function is primarily intended to publish new nodes starting
+ * at @next within the RCU-protected list @prev.
+ *
+ * This is only for internal list manipulation, when everything
+ * else, i. e. a link from the nodes given by @next back to the
+ * list of @prev, is already set up.
+ *
+ * Concurrent readers are basically allowed, concurrent writers
+ * are forbidden.
+ */
+static inline void __list_link_rcu(struct list_head *prev,
+					struct list_head *next)
+{
+	rcu_assign_pointer(list_next_rcu(prev), next);
+	next->prev = prev;
+}
+
+
+/*
  * Insert a new entry between two known consecutive entries.
  *
  * This is only for internal list manipulation where we know
@@ -159,6 +182,105 @@ static inline void list_replace_rcu(struct list_head *old,
 }
 
 /**
+ * list_add_tail_nobackref - add element to list without setting up
+ *			     back references
+ * @new: element to add
+ * @head: list to add the element to
+ *
+ * @new is appended to @head.
+ *
+ * In contrast to list_add_tail(), this function does not maintain the
+ * references back to @head. So, neither @new->next will be changed, nor
+ * -- in case @new becomes the first entry of @head -- @new->pref.
+ *
+ * This is useful when reorganizing deleted elements of a RCU-protected
+ * list as concurrent readers must always find their way back to the list.
+ * When used in this context, special care must be taken in order to not
+ * disturb concurrent readers on @head (or @new):
+ * a) @new->next must lead back to the list
+ * b) @new->next must not lead to any node already on @head
+ * c) @new must be already known to existing readers on @head
+ *
+ * Point a) is the normal RCU invariant.
+ *
+ * Point b) prevents capturing readers in cycles.
+ *
+ * Point c) is necessary as this function itself is not RCU-aware: if a
+ * concurrent reader would reach an unknown node it might see uninitialized
+ * data in that node. Basically this requires that @new was not published
+ * for the first time after any of the nodes given by @head.
+ *
+ * Concurrent writers are forbidden.
+ */
+static inline void list_add_tail_nobackref(struct list_head *new,
+						struct list_head *head)
+{
+	if (list_empty(head)) {
+		/* If @head is empty, simply let it point to @new */
+		head->next = new;
+		head->prev = new;
+	} else {
+		/*
+		 * If @head has elements, append @new to the last element and
+		 * advance the tail pointer of @head.
+		 */
+		__list_link(head->prev, new);
+		head->prev = new;
+	}
+}
+
+/*
+ * Low level function for splicing.
+ *
+ * @prev and @next must point into the same RCU-protected list.
+ *
+ * All elements between (not including) @prev and @next are replaced
+ * by the nodes given by @list.
+ *
+ * It is safe to have concurrent readers of the @prev/@next list
+ * on any of the referenced nodes. There must be no reader not
+ * from @prev/@next within @list.
+ * There must be no concurrent writers on @list or @prev/@next.
+ *
+ * This is only for internal list manipulation. If elements of
+ * @prev/@next are deleted, their prev-pointers are not poisoned.
+ */
+static inline void __list_splice_rcu(struct list_head *list,
+					struct list_head *prev,
+					struct list_head *next)
+{
+	/* Prepare link back to @prev/@next */
+	__list_link(list->prev, next);
+
+	/*
+	 * Publish new nodes, implicitly deleting everything between
+	 * @prev and @next.
+	 */
+	__list_link_rcu(prev, list->next);
+}
+
+/**
+ * list_splice_tail_init_rcu - splice a list into a RCU-protected list
+ * @list: the list to be spliced
+ * @head: the RCU-protected list to splice into
+ *
+ * The contents of @list are inserted before @head. After completion
+ * @list is empty.
+ *
+ * It is safe to have concurrent readers of @head. There must be no
+ * concurrent readers not from @head on @list.
+ * There must be no concurrent writers on @list or @head.
+ */
+static inline void list_splice_tail_init_rcu(struct list_head *list,
+						struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice_rcu(list, head->prev, head);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+/**
  * list_splice_init_rcu - splice an RCU-protected list into an existing list.
  * @list:	the RCU-protected list to splice
  * @head:	the place in the list to splice the first list into
-- 
1.7.6

