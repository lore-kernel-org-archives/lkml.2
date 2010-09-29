Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab0I2MTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:13 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:50313 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755211Ab0I2MTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:10 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/17] kernel: add bl_list
Date: Wed, 29 Sep 2010 22:18:33 +1000
Message-Id: <1285762729-17928-2-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285762729-17928-1-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Introduce a type of hlist that can support the use of the lowest bit
in the hlist_head. This will be subsequently used to implement
per-bucket bit spinlock for inode hashes.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/list_bl.h    |  127 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/rculist_bl.h |  128 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 255 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/list_bl.h
 create mode 100644 include/linux/rculist_bl.h

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
new file mode 100644
index 0000000..cf8acfc
--- /dev/null
+++ b/include/linux/list_bl.h
@@ -0,0 +1,127 @@
+#ifndef _LINUX_LIST_BL_H
+#define _LINUX_LIST_BL_H
+
+#include <linux/list.h>
+#include <linux/bit_spinlock.h>
+
+/*
+ * Special version of lists, where head of the list has a bit spinlock
+ * in the lowest bit. This is useful for scalable hash tables without
+ * increasing memory footprint overhead.
+ *
+ * For modification operations, the 0 bit of hlist_bl_head->first
+ * pointer must be set.
+ */
+
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+#define LIST_BL_LOCKMASK	1UL
+#else
+#define LIST_BL_LOCKMASK	0UL
+#endif
+
+#ifdef CONFIG_DEBUG_LIST
+#define LIST_BL_BUG_ON(x) BUG_ON(x)
+#else
+#define LIST_BL_BUG_ON(x)
+#endif
+
+
+struct hlist_bl_head {
+	struct hlist_bl_node *first;
+};
+
+struct hlist_bl_node {
+	struct hlist_bl_node *next, **pprev;
+};
+#define INIT_HLIST_BL_HEAD(ptr) \
+	((ptr)->first = NULL)
+
+static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
+{
+	h->next = NULL;
+	h->pprev = NULL;
+}
+
+#define hlist_bl_entry(ptr, type, member) container_of(ptr,type,member)
+
+static inline int hlist_bl_unhashed(const struct hlist_bl_node *h)
+{
+	return !h->pprev;
+}
+
+static inline struct hlist_bl_node *hlist_bl_first(struct hlist_bl_head *h)
+{
+	return (struct hlist_bl_node *)
+		((unsigned long)h->first & ~LIST_BL_LOCKMASK);
+}
+
+static inline void hlist_bl_set_first(struct hlist_bl_head *h,
+					struct hlist_bl_node *n)
+{
+	LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
+	LIST_BL_BUG_ON(!bit_spin_is_locked(0, (unsigned long *)&h->first));
+	h->first = (struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK);
+}
+
+static inline int hlist_bl_empty(const struct hlist_bl_head *h)
+{
+	return !((unsigned long)h->first & ~LIST_BL_LOCKMASK);
+}
+
+static inline void hlist_bl_add_head(struct hlist_bl_node *n,
+					struct hlist_bl_head *h)
+{
+	struct hlist_bl_node *first = hlist_bl_first(h);
+
+	n->next = first;
+	if (first)
+		first->pprev = &n->next;
+	n->pprev = &h->first;
+	hlist_bl_set_first(h, n);
+}
+
+static inline void __hlist_bl_del(struct hlist_bl_node *n)
+{
+	struct hlist_bl_node *next = n->next;
+	struct hlist_bl_node **pprev = n->pprev;
+
+	LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
+
+	/* pprev may be `first`, so be careful not to lose the lock bit */
+	*pprev = (struct hlist_bl_node *)
+			((unsigned long)next |
+			 ((unsigned long)*pprev & LIST_BL_LOCKMASK));
+	if (next)
+		next->pprev = pprev;
+}
+
+static inline void hlist_bl_del(struct hlist_bl_node *n)
+{
+	__hlist_bl_del(n);
+	n->next = LIST_POISON1;
+	n->pprev = LIST_POISON2;
+}
+
+static inline void hlist_bl_del_init(struct hlist_bl_node *n)
+{
+	if (!hlist_bl_unhashed(n)) {
+		__hlist_bl_del(n);
+		INIT_HLIST_BL_NODE(n);
+	}
+}
+
+/**
+ * hlist_bl_for_each_entry	- iterate over list of given type
+ * @tpos:	the type * to use as a loop cursor.
+ * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the hlist_node within the struct.
+ *
+ */
+#define hlist_bl_for_each_entry(tpos, pos, head, member)		\
+	for (pos = hlist_bl_first(head);				\
+	     pos &&							\
+		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1;}); \
+	     pos = pos->next)
+
+#endif
diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
new file mode 100644
index 0000000..cdfb54e
--- /dev/null
+++ b/include/linux/rculist_bl.h
@@ -0,0 +1,128 @@
+#ifndef _LINUX_RCULIST_BL_H
+#define _LINUX_RCULIST_BL_H
+
+/*
+ * RCU-protected bl list version. See include/linux/list_bl.h.
+ */
+#include <linux/list_bl.h>
+#include <linux/rcupdate.h>
+#include <linux/bit_spinlock.h>
+
+static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
+					struct hlist_bl_node *n)
+{
+	LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
+	LIST_BL_BUG_ON(!bit_spin_is_locked(0, (unsigned long *)&h->first));
+	rcu_assign_pointer(h->first,
+		(struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK));
+}
+
+static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
+{
+	return (struct hlist_bl_node *)
+		((unsigned long)rcu_dereference(h->first) & ~LIST_BL_LOCKMASK);
+}
+
+/**
+ * hlist_bl_del_init_rcu - deletes entry from hash list with re-initialization
+ * @n: the element to delete from the hash list.
+ *
+ * Note: hlist_bl_unhashed() on the node returns true after this. It is
+ * useful for RCU based read lockfree traversal if the writer side
+ * must know if the list entry is still hashed or already unhashed.
+ *
+ * In particular, it means that we can not poison the forward pointers
+ * that may still be used for walking the hash list and we can only
+ * zero the pprev pointer so list_unhashed() will return true after
+ * this.
+ *
+ * The caller must take whatever precautions are necessary (such as
+ * holding appropriate locks) to avoid racing with another
+ * list-mutation primitive, such as hlist_bl_add_head_rcu() or
+ * hlist_bl_del_rcu(), running on this same list.  However, it is
+ * perfectly legal to run concurrently with the _rcu list-traversal
+ * primitives, such as hlist_bl_for_each_entry_rcu().
+ */
+static inline void hlist_bl_del_init_rcu(struct hlist_bl_node *n)
+{
+	if (!hlist_bl_unhashed(n)) {
+		__hlist_bl_del(n);
+		n->pprev = NULL;
+	}
+}
+
+/**
+ * hlist_bl_del_rcu - deletes entry from hash list without re-initialization
+ * @n: the element to delete from the hash list.
+ *
+ * Note: hlist_bl_unhashed() on entry does not return true after this,
+ * the entry is in an undefined state. It is useful for RCU based
+ * lockfree traversal.
+ *
+ * In particular, it means that we can not poison the forward
+ * pointers that may still be used for walking the hash list.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_bl_add_head_rcu()
+ * or hlist_bl_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_bl_for_each_entry().
+ */
+static inline void hlist_bl_del_rcu(struct hlist_bl_node *n)
+{
+	__hlist_bl_del(n);
+	n->pprev = LIST_POISON2;
+}
+
+/**
+ * hlist_bl_add_head_rcu
+ * @n: the element to add to the hash list.
+ * @h: the list to add to.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist_bl,
+ * while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_bl_add_head_rcu()
+ * or hlist_bl_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_bl_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.  Regardless of the type of CPU, the
+ * list-traversal primitive must be guarded by rcu_read_lock().
+ */
+static inline void hlist_bl_add_head_rcu(struct hlist_bl_node *n,
+					struct hlist_bl_head *h)
+{
+	struct hlist_bl_node *first;
+
+	/* don't need hlist_bl_first_rcu because we're under lock */
+	first = hlist_bl_first(h);
+
+	n->next = first;
+	if (first)
+		first->pprev = &n->next;
+	n->pprev = &h->first;
+
+	/* need _rcu because we can have concurrent lock free readers */
+	hlist_bl_set_first_rcu(h, n);
+}
+/**
+ * hlist_bl_for_each_entry_rcu - iterate over rcu list of given type
+ * @tpos:	the type * to use as a loop cursor.
+ * @pos:	the &struct hlist_bl_node to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the hlist_bl_node within the struct.
+ *
+ */
+#define hlist_bl_for_each_entry_rcu(tpos, pos, head, member)		\
+	for (pos = hlist_bl_first_rcu(head);				\
+		pos &&							\
+		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
+		pos = rcu_dereference_raw(pos->next))
+
+#endif
-- 
1.7.1

