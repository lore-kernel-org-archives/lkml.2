Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab0JTBiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:38:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:28857 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658Ab0JTBhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:37:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="565620634"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 3/9] lock-less NULL terminated single list implementation
Date: Wed, 20 Oct 2010 09:36:54 +0800
Message-Id: <1287538620-7442-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cmpxchg is used to implement adding new entry to list, deleting first
entry of the list and some other operations.

Because this is a single list, so the tail can not be accessed in O(1).

This can be used in NMI handler.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 include/linux/llist.h |   64 +++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig           |    3 +
 lib/Makefile          |    2 +
 lib/llist.c           |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 147 insertions(+)
 create mode 100644 include/linux/llist.h
 create mode 100644 lib/llist.c

--- /dev/null
+++ b/include/linux/llist.h
@@ -0,0 +1,64 @@
+#ifndef LLIST_H
+#define LLIST_H
+
+/* lock-less NULL terminated single linked list */
+struct llist_head {
+	struct llist_head *next;
+};
+
+#define LLIST_HEAD_INIT(name) { NULL }
+
+#define LLIST_HEAD(name)				\
+	struct llist_head name = LLIST_HEAD_INIT(name)
+
+/**
+ * init_llist_head - initialize lock-less list head
+ * @head:	the head for your lock-less list
+ */
+static inline void init_llist_head(struct llist_head *list)
+{
+	list->next = NULL;
+}
+
+/**
+ * llist_entry - get the struct of this entry
+ * @ptr:	the &struct llist_head pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the llist_head within the struct.
+ */
+#define llist_entry(ptr, type, member)		\
+	container_of(ptr, type, member)
+
+/**
+ * llist_for_each - iterate over a lock-less list
+ * @pos:	the &struct llist_head to use as a loop cursor
+ * @head:	the head for your lock-less list
+ */
+#define llist_for_each(pos, head)					\
+	for (pos = (head)->next; pos; pos = pos->next)
+
+/**
+ * llist_for_each_entry - iterate over lock-less list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your lock-less list.
+ * @member:	the name of the llist_head with the struct.
+ */
+#define llist_for_each_entry(pos, head, member)				\
+	for (pos = llist_entry((head)->next, typeof(*pos), member);	\
+	     &pos->member != NULL;					\
+	     pos = llist_entry(pos->member.next, typeof(*pos), member))
+
+/**
+ * llist_empty - tests whether a lock-less list is empty
+ * @head:	the list to test
+ */
+static inline int llist_empty(const struct llist_head *head)
+{
+	return head->next == NULL;
+}
+
+void llist_add(struct llist_head *new, struct llist_head *head);
+struct llist_head *llist_del_first(struct llist_head *head);
+void llist_move_all(struct llist_head *list, struct llist_head *head);
+
+#endif /* LLIST_H */
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -210,4 +210,7 @@ config GENERIC_ATOMIC64
 config LRU_CACHE
 	tristate
 
+config LLIST
+	bool
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
@@ -0,0 +1,78 @@
+/*
+ * Simple lock-less NULL terminated single list implementation
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
+void llist_add(struct llist_head *new, struct llist_head *head)
+{
+	struct llist_head *entry;
+
+	do {
+		entry = head->next;
+		new->next = entry;
+	} while (cmpxchg(&head->next, entry, new) != entry);
+}
+EXPORT_SYMBOL_GPL(llist_add);
+
+/**
+ * llist_del_first - delete the first entry of lock-less list
+ * @head:	the head for your lock-less list
+ *
+ * If list is empty, return NULL, otherwise, return the first entry deleted
+ */
+struct llist_head *llist_del_first(struct llist_head *head)
+{
+	struct llist_head *entry;
+
+	do {
+		entry = head->next;
+		if (entry == NULL)
+			return NULL;
+	} while (cmpxchg(&head->next, entry, entry->next) != entry);
+
+	return entry;
+}
+EXPORT_SYMBOL_GPL(llist_del_first);
+
+/**
+ * llist_move_all - delete all entries from one list and add them to another list
+ * @list:	the head of lock-less list to delete all entries
+ * @head:	the head of lock-less list to add the entries
+ *
+ * Remove all entries from @list lock-lessly, then add the entries to
+ * lock-less list @head.
+ */
+void llist_move_all(struct llist_head *list, struct llist_head *head)
+{
+	struct llist_head *entry;
+
+	entry = xchg(&list->next, NULL);
+	head->next = entry;
+}
+EXPORT_SYMBOL_GPL(llist_move_all);
