Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0JRGVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 02:21:31 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:37316 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751515Ab0JRGV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 02:21:29 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/20] kernel: add bl_list
Date: Mon, 18 Oct 2010 17:20:38 +1100
Message-Id: <1287382856-29529-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287382856-29529-1-git-send-email-david@fromorbit.com>
References: <1287382856-29529-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Introduce a type of hlist that can support the use of the lowest bit
in the hlist_head. This will be subsequently used to implement
per-bucket bit spinlock for inode hashes.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/list_bl.h |  145 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/poison.h  |    2 +
 2 files changed, 147 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/list_bl.h

diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
new file mode 100644
index 0000000..0d791ff
--- /dev/null
+++ b/include/linux/list_bl.h
@@ -0,0 +1,145 @@
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
+static inline void init_hlist_bl_node(struct hlist_bl_node *h)
+{
+	h->next = NULL;
+	h->pprev = NULL;
+}
+
+#define hlist_bl_entry(ptr, type, member) container_of(ptr, type, member)
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
+	n->next = BL_LIST_POISON1;
+	n->pprev = BL_LIST_POISON2;
+}
+
+static inline void hlist_bl_del_init(struct hlist_bl_node *n)
+{
+	if (!hlist_bl_unhashed(n)) {
+		__hlist_bl_del(n);
+		init_hlist_bl_node(n);
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
+		({ tpos = hlist_bl_entry(pos, typeof(*tpos), member); 1; }); \
+	     pos = pos->next)
+
+#endif
+
+/**
+ * hlist_bl_lock	- lock a hash list
+ * @h:	hash list head to lock
+ */
+static inline void hlist_bl_lock(struct hlist_bl_head *h)
+{
+	bit_spin_lock(0, (unsigned long *)h);
+}
+
+/**
+ * hlist_bl_unlock	- unlock a hash list
+ * @h:	hash list head to unlock
+ */
+static inline void hlist_bl_unlock(struct hlist_bl_head *h)
+{
+	__bit_spin_unlock(0, (unsigned long *)h);
+}
diff --git a/include/linux/poison.h b/include/linux/poison.h
index 2110a81..d367d39 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -22,6 +22,8 @@
 #define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
 #define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
 
+#define BL_LIST_POISON1  ((void *) 0x00300300 + POISON_POINTER_DELTA)
+#define BL_LIST_POISON2  ((void *) 0x00400400 + POISON_POINTER_DELTA)
 /********** include/linux/timer.h **********/
 /*
  * Magic number "tsta" to indicate a static timer initializer
-- 
1.7.1

