Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab1IHGA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 02:00:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:48915 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006Ab1IHGA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 02:00:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,349,1312182000"; 
   d="scan'208";a="50364512"
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH -mm -v2 1/5] llist, Make all llist functions inline
Date: Thu,  8 Sep 2011 14:00:42 +0800
Message-Id: <1315461646-1379-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because llist may be used in performance critical code path, make all
llist functions inline to avoid function calling overhead.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 drivers/acpi/apei/Kconfig |    1 
 include/linux/llist.h     |  122 +++++++++++++++++++++++++++++++++++++++++--
 lib/Kconfig               |    3 -
 lib/Makefile              |    2 
 lib/llist.c               |  129 ----------------------------------------------
 5 files changed, 116 insertions(+), 141 deletions(-)
 delete mode 100644 lib/llist.c

--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -14,7 +14,6 @@ config ACPI_APEI_GHES
 	depends on ACPI_APEI && X86
 	select ACPI_HED
 	select IRQ_WORK
-	select LLIST
 	select GENERIC_ALLOCATOR
 	help
 	  Generic Hardware Error Source provides a way to report
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -37,8 +37,28 @@
  * architectures that don't have NMI-safe cmpxchg implementation, the
  * list can NOT be used in NMI handler.  So code uses the list in NMI
  * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
+ *
+ * Copyright 2010,2011 Intel Corp.
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
  */
 
+#include <linux/kernel.h>
+#include <asm/system.h>
+#include <asm/processor.h>
+
 struct llist_head {
 	struct llist_node *first;
 };
@@ -113,14 +133,104 @@ static inline void init_llist_head(struc
  * test whether the list is empty without deleting something from the
  * list.
  */
-static inline int llist_empty(const struct llist_head *head)
+static inline bool llist_empty(const struct llist_head *head)
 {
 	return ACCESS_ONCE(head->first) == NULL;
 }
 
-void llist_add(struct llist_node *new, struct llist_head *head);
-void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
-		     struct llist_head *head);
-struct llist_node *llist_del_first(struct llist_head *head);
-struct llist_node *llist_del_all(struct llist_head *head);
+/**
+ * llist_add - add a new entry
+ * @new:	new entry to be added
+ * @head:	the head for your lock-less list
+ */
+static inline void llist_add(struct llist_node *new, struct llist_head *head)
+{
+	struct llist_node *entry, *old_entry;
+
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	entry = head->first;
+	do {
+		old_entry = entry;
+		new->next = entry;
+		cpu_relax();
+	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
+}
+
+/**
+ * llist_add_batch - add several linked entries in batch
+ * @new_first:	first entry in batch to be added
+ * @new_last:	last entry in batch to be added
+ * @head:	the head for your lock-less list
+ */
+static inline void llist_add_batch(struct llist_node *new_first,
+				   struct llist_node *new_last,
+				   struct llist_head *head)
+{
+	struct llist_node *entry, *old_entry;
+
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	entry = head->first;
+	do {
+		old_entry = entry;
+		new_last->next = entry;
+		cpu_relax();
+	} while ((entry = cmpxchg(&head->first, old_entry, new_first)) != old_entry);
+}
+
+/**
+ * llist_del_first - delete the first entry of lock-less list
+ * @head:	the head for your lock-less list
+ *
+ * If list is empty, return NULL, otherwise, return the first entry
+ * deleted, this is the newest added one.
+ *
+ * Only one llist_del_first user can be used simultaneously with
+ * multiple llist_add users without lock.  Because otherwise
+ * llist_del_first, llist_add, llist_add (or llist_del_all, llist_add,
+ * llist_add) sequence in another user may change @head->first->next,
+ * but keep @head->first.  If multiple consumers are needed, please
+ * use llist_del_all or use lock between consumers.
+ */
+static inline struct llist_node *llist_del_first(struct llist_head *head)
+{
+	struct llist_node *entry, *old_entry, *next;
+
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	entry = head->first;
+	do {
+		if (entry == NULL)
+			return NULL;
+		old_entry = entry;
+		next = entry->next;
+		cpu_relax();
+	} while ((entry = cmpxchg(&head->first, old_entry, next)) != old_entry);
+
+	return entry;
+}
+
+/**
+ * llist_del_all - delete all entries from lock-less list
+ * @head:	the head of lock-less list to delete all entries
+ *
+ * If list is empty, return NULL, otherwise, delete all entries and
+ * return the pointer to the first entry.  The order of entries
+ * deleted is from the newest to the oldest added one.
+ */
+static inline struct llist_node *llist_del_all(struct llist_head *head)
+{
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	return xchg(&head->first, NULL);
+}
 #endif /* LLIST_H */
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -276,7 +276,4 @@ config CORDIC
 	  so its calculations are in fixed point. Modules can select this
 	  when they require this function. Module will be called cordic.
 
-config LLIST
-	bool
-
 endmenu
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -116,8 +116,6 @@ obj-$(CONFIG_CPU_RMAP) += cpu_rmap.o
 
 obj-$(CONFIG_CORDIC) += cordic.o
 
-obj-$(CONFIG_LLIST) += llist.o
-
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
--- a/lib/llist.c
+++ /dev/null
@@ -1,129 +0,0 @@
-/*
- * Lock-less NULL terminated single linked list
- *
- * The basic atomic operation of this list is cmpxchg on long.  On
- * architectures that don't have NMI-safe cmpxchg implementation, the
- * list can NOT be used in NMI handler.  So code uses the list in NMI
- * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
- *
- * Copyright 2010,2011 Intel Corp.
- *   Author: Huang Ying <ying.huang@intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation;
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/llist.h>
-
-#include <asm/system.h>
-
-/**
- * llist_add - add a new entry
- * @new:	new entry to be added
- * @head:	the head for your lock-less list
- */
-void llist_add(struct llist_node *new, struct llist_head *head)
-{
-	struct llist_node *entry, *old_entry;
-
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
-
-	entry = head->first;
-	do {
-		old_entry = entry;
-		new->next = entry;
-		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
-}
-EXPORT_SYMBOL_GPL(llist_add);
-
-/**
- * llist_add_batch - add several linked entries in batch
- * @new_first:	first entry in batch to be added
- * @new_last:	last entry in batch to be added
- * @head:	the head for your lock-less list
- */
-void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
-		     struct llist_head *head)
-{
-	struct llist_node *entry, *old_entry;
-
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
-
-	entry = head->first;
-	do {
-		old_entry = entry;
-		new_last->next = entry;
-		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, new_first)) != old_entry);
-}
-EXPORT_SYMBOL_GPL(llist_add_batch);
-
-/**
- * llist_del_first - delete the first entry of lock-less list
- * @head:	the head for your lock-less list
- *
- * If list is empty, return NULL, otherwise, return the first entry
- * deleted, this is the newest added one.
- *
- * Only one llist_del_first user can be used simultaneously with
- * multiple llist_add users without lock.  Because otherwise
- * llist_del_first, llist_add, llist_add (or llist_del_all, llist_add,
- * llist_add) sequence in another user may change @head->first->next,
- * but keep @head->first.  If multiple consumers are needed, please
- * use llist_del_all or use lock between consumers.
- */
-struct llist_node *llist_del_first(struct llist_head *head)
-{
-	struct llist_node *entry, *old_entry, *next;
-
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
-
-	entry = head->first;
-	do {
-		if (entry == NULL)
-			return NULL;
-		old_entry = entry;
-		next = entry->next;
-		cpu_relax();
-	} while ((entry = cmpxchg(&head->first, old_entry, next)) != old_entry);
-
-	return entry;
-}
-EXPORT_SYMBOL_GPL(llist_del_first);
-
-/**
- * llist_del_all - delete all entries from lock-less list
- * @head:	the head of lock-less list to delete all entries
- *
- * If list is empty, return NULL, otherwise, delete all entries and
- * return the pointer to the first entry.  The order of entries
- * deleted is from the newest to the oldest added one.
- */
-struct llist_node *llist_del_all(struct llist_head *head)
-{
-#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	BUG_ON(in_nmi());
-#endif
-
-	return xchg(&head->first, NULL);
-}
-EXPORT_SYMBOL_GPL(llist_del_all);
