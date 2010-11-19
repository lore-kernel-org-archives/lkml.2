Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392Ab0KSCDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 21:03:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:63005 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760266Ab0KSCDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 21:03:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,220,1288594800"; 
   d="scan'208";a="678964310"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v5 3/3] lib, Add lock-less NULL terminated single list
Date: Fri, 19 Nov 2010 10:02:14 +0800
Message-Id: <1290132134-21217-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290132134-21217-1-git-send-email-ying.huang@intel.com>
References: <1290132134-21217-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cmpxchg is used to implement adding new entry to the list, deleting
all entries from the list, deleting first entry of the list and some
other operations.

Because this is a single list, so the tail can not be accessed in O(1).

This can be used in NMI handler.

If there are multiple producers and multiple consumers, llist_add can
be used in producers and llist_del_all can be used in consumers.  They
can work simultaneously without lock.  But llist_del_first can not be
used here.  Because llist_del_first depends on list->first->next does
not changed if list->first is not changed during its operation, but
llist_del_first, llist_add, llist_add sequence in another consumer may
violate that.

If there are multiple producers and one consumer, llist_add can be
used in producers and llist_del_all or llist_del_first can be used in
the consumer.

The list entries deleted via llist_del_all can be traversed with
traversing function such as llist_for_each etc.  But the list entries
can not be traversed safely before deleted from the list without
proper synchronization with the list consumers.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/llist.h |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig           |    4 ++
 lib/Makefile          |    2 +
 lib/llist.c           |   80 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 178 insertions(+)
 create mode 100644 include/linux/llist.h
 create mode 100644 lib/llist.c

--- /dev/null
+++ b/include/linux/llist.h
@@ -0,0 +1,92 @@
+#ifndef LLIST_H
+#define LLIST_H
+/*
+ * Lock-less NULL terminated single linked list
+ *
+ * If there are multiple producers and multiple consumers, llist_add
+ * can be used in producers and llist_del_all can be used in
+ * consumers.  They can work simultaneously without lock.  But
+ * llist_del_first can not be used here.  Because llist_del_first
+ * depends on list->first->next does not changed if list->first is not
+ * changed during its operation, but llist_del_first, llist_add,
+ * llist_add sequence in another consumer may violate that.
+ *
+ * If there are multiple producers and one consumer, llist_add can be
+ * used in producers and llist_del_all or llist_del_first can be used
+ * in the consumer.
+ *
+ * The list entries deleted via llist_del_all can be traversed with
+ * traversing function such as llist_for_each etc.  But the list
+ * entries can not be traversed safely before deleted from the list
+ * without proper synchronization with the list consumers.
+ */
+
+struct llist_head {
+	struct llist_node *first;
+};
+
+struct llist_node {
+	struct llist_node *next;
+};
+
+#define LLIST_HEAD_INIT(name)	{ NULL }
+#define LLIST_HEAD(name)	struct llist_head name = LLIST_HEAD_INIT(name)
+
+/**
+ * init_llist_head - initialize lock-less list head
+ * @head:	the head for your lock-less list
+ */
+static inline void init_llist_head(struct llist_head *list)
+{
+	list->first = NULL;
+}
+
+/**
+ * llist_entry - get the struct of this entry
+ * @ptr:	the &struct llist_node pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the llist_node within the struct.
+ */
+#define llist_entry(ptr, type, member)		\
+	container_of(ptr, type, member)
+
+/**
+ * llist_for_each - iterate over some entries of a lock-less list
+ * @pos:	the &struct llist_node to use as a loop cursor
+ * @node:	the first entry of deleted list entries
+ *
+ * In general, some entries of the lock-less list can be traversed
+ * safely only after being deleted from list, so start with an entry
+ * instead of list head.
+ */
+#define llist_for_each(pos, node)			\
+	for (pos = (node); pos; pos = pos->next)
+
+/**
+ * llist_for_each_entry - iterate over some entries of lock-less list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @node:	the fist entry of deleted list entries.
+ * @member:	the name of the llist_node with the struct.
+ *
+ * In general, some entries of the lock-less list can be traversed
+ * safely only after being removed from list, so start with an entry
+ * instead of list head.
+ */
+#define llist_for_each_entry(pos, node, member)				\
+	for (pos = llist_entry((node), typeof(*pos), member);		\
+	     &pos->member != NULL;					\
+	     pos = llist_entry(pos->member.next, typeof(*pos), member))
+
+/**
+ * llist_empty - tests whether a lock-less list is empty
+ * @head:	the list to test
+ */
+static inline int llist_empty(const struct llist_head *head)
+{
+	return head->first == NULL;
+}
+
+void llist_add(struct llist_node *new, struct llist_head *head);
+struct llist_node *llist_del_first(struct llist_head *head);
+struct llist_node *llist_del_all(struct llist_head *head);
+#endif /* LLIST_H */
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -210,4 +210,8 @@ config GENERIC_ATOMIC64
 config LRU_CACHE
 	tristate
 
+config LLIST
+	bool
+	depends on ARCH_HAVE_NMI_SAFE_CMPXCHG
+
 endmenu
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -106,6 +106,8 @@ obj-$(CONFIG_GENERIC_ATOMIC64) += atomic
 
 obj-$(CONFIG_ATOMIC64_SELFTEST) += atomic64_test.o
 
+obj-$(CONFIG_LLIST) += llist.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
--- /dev/null
+++ b/lib/llist.c
@@ -0,0 +1,80 @@
+/*
+ * Lock-less NULL terminated single linked list
+ *
+ * Copyright 2010 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation;
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/llist.h>
+#include <linux/errno.h>
+
+#include <asm/system.h>
+
+/**
+ * llist_add - add a new entry
+ * @new:	new entry to be added
+ * @head:	the head for your lock-less list
+ */
+void llist_add(struct llist_node *new, struct llist_head *head)
+{
+	struct llist_node *entry;
+
+	do {
+		entry = head->first;
+		new->next = entry;
+	} while (cmpxchg(&head->first, entry, new) != entry);
+}
+EXPORT_SYMBOL_GPL(llist_add);
+
+/**
+ * llist_del_first - delete the first entry of lock-less list
+ * @head:	the head for your lock-less list
+ *
+ * If list is empty, return NULL, otherwise, return the first entry deleted.
+ *
+ * Only one llist_del_first user can be used simultaneously with
+ * multiple llist_add users without lock. Because otherwise
+ * llist_del_first, llist_add, llist_add sequence in another user may
+ * change @head->first->next, but keep @head->first. If multiple
+ * consumers are needed, please use llist_del_all.
+ */
+struct llist_node *llist_del_first(struct llist_head *head)
+{
+	struct llist_node *entry;
+
+	do {
+		entry = head->first;
+		if (entry == NULL)
+			return NULL;
+	} while (cmpxchg(&head->first, entry, entry->next) != entry);
+
+	return entry;
+}
+EXPORT_SYMBOL_GPL(llist_del_first);
+
+/**
+ * llist_del_all - delete all entries from lock-less list
+ * @head:	the head of lock-less list to delete all entries
+ *
+ * If list is empty, return NULL, otherwise, delete all entries and
+ * return the pointer to the first entry.
+ */
+struct llist_node *llist_del_all(struct llist_head *head)
+{
+	return xchg(&head->first, NULL);
+}
+EXPORT_SYMBOL_GPL(llist_del_all);
