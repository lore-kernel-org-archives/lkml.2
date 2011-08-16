Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1HPOIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:08:30 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:33990 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab1HPOI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:08:27 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v3 1/2] rcu: More rcu-variants for list manipulation
Date: Tue, 16 Aug 2011 16:07:45 +0200
Message-Id: <1313503666-13726-2-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313503666-13726-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1313503666-13726-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

This commit introduces __list_link() and some more *_rcu variants of some
list manipulation functions:

* __list_link()

  Takes two list elements and link them via their next/prev pointers.

* __list_link_rcu()

  RCU-aware counterpart to __list_link().

* __list_splice_rcu(), list_splice_tail_init_rcu()

  RCU-aware non-blocking splicing.

  The existing rcu-splice function allows concurrent readers on the
  list to be spliced that are not from the destination list. Therefore,
  it has to block to get these readers off the list before the splicing
  can be done. The new functions forbid this and can, thus, work without
  blocking.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

---
Changes since v2:
- merged __list_link() from a dropped patch
- dropped list_add_tail_nobackref() again

Changes since v1:
- added comments
- added list_add_tail_nobackref()
---
 include/linux/list.h    |   12 +++++++
 include/linux/rculist.h |   74 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index cc6d2aa..0a7b057 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -21,6 +21,18 @@
 #define LIST_HEAD(name) \
 	struct list_head name = LIST_HEAD_INIT(name)
 
+/*
+ * Link two list entries by making the prev/next entries
+ * point to each other.
+ *
+ * This is only for internal list manipulation.
+ */
+static inline void __list_link(struct list_head *prev, struct list_head *next)
+{
+	next->prev = prev;
+	prev->next = next;
+}
+
 static inline void INIT_LIST_HEAD(struct list_head *list)
 {
 	list->next = list;
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index d079290..a9be1e0 100644
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
@@ -158,6 +181,57 @@ static inline void list_replace_rcu(struct list_head *old,
 	old->prev = LIST_POISON2;
 }
 
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
 /**
  * list_splice_init_rcu - splice an RCU-protected list into an existing list.
  * @list:	the RCU-protected list to splice
-- 
1.7.6

