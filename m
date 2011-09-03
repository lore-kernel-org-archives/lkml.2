Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1ICSFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 14:05:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51764 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab1ICSFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 14:05:33 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Sep 2011 14:05:30 EDT
Message-Id: <20110903175543.363519825@efficios.com>
User-Agent: quilt/0.48-1
Date: Sat, 03 Sep 2011 13:47:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Huang Ying <ying.huang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, lenb@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC patch 1/2] Rename the "llist" (lockless list) to "llstack" (lockless stack)
References: <20110903174721.390074195@efficios.com>
Content-Disposition: inline; filename=llist-rename-to-llstack.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sat,  3 Sep 2011 17:55:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API we can provide with a lock-less structure does not only depend
on how the elements are organized, but also on the operations allowed on
the structure. So the API should reflect that.

This is illustrated by the following feature request: Previously, the
concensus was to keep the "llist" name until we could gather evidence
that this name is inappropriate. A feature request from Peter Zijlstra
outlines very well the need for an llstack API that allows the push
operation to return whether the stack was empty or not before the
operation.

By taking advantage of the stack structure, the "push" operation can
return whether the stack was empty or not prior to the push with almost
no cost (the old stack head is already in registers). Adding this
feature to the push API is not a good fit for a "generic llist" API
however, because it would cast in stone the fact that this llist behaves
like a stack.

The only reason why we can get away this easily with knowing atomically
if the structure was empty prior to the insertion is because this "list"
behaves like a stack (LIFO). I foresee we'll need to add "lockless
queues" at some point (with FIFO behavior), which has the ability to
enqueue/dequeue concurrently without sharing the same cache-lines when
the queue is non-empty. Within that kind of queue structure, knowing if
the queue was empty prior to insertion would become a bottleneck, so I
would not advise to make that part of _that_ API, which would require to
add a new "llqueue" API. And at that point, the "llist" vs "llqueue"
semantic would become really confusing. This is why I propose to rename
the "llist" to the less confusing "llstack" right away.

If we don't fix that now, I think we're heading into a lock-free
structure namespacing trainwreck that will limit our ability to add
other lock-free operations due vague naming that does not take the
operations allowed on the structure into consideration, combined with
API constraints permitted by a specific given behavior (e.g. FIFO
semantic) that tend to define these lock-free APIs.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Huang Ying <ying.huang@intel.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: "lenb@kernel.org" <lenb@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/acpi/apei/Kconfig |    2 
 drivers/acpi/apei/ghes.c  |   19 +++---
 include/linux/llist.h     |  126 --------------------------------------------
 include/linux/llstack.h   |  126 ++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig               |    2 
 lib/Makefile              |    2 
 lib/llist.c               |  129 ----------------------------------------------
 lib/llstack.c             |  129 ++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 268 insertions(+), 267 deletions(-)

Index: linux-2.6-lttng/include/linux/llist.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/llist.h
+++ /dev/null
@@ -1,126 +0,0 @@
-#ifndef LLIST_H
-#define LLIST_H
-/*
- * Lock-less NULL terminated single linked list
- *
- * If there are multiple producers and multiple consumers, llist_add
- * can be used in producers and llist_del_all can be used in
- * consumers.  They can work simultaneously without lock.  But
- * llist_del_first can not be used here.  Because llist_del_first
- * depends on list->first->next does not changed if list->first is not
- * changed during its operation, but llist_del_first, llist_add,
- * llist_add (or llist_del_all, llist_add, llist_add) sequence in
- * another consumer may violate that.
- *
- * If there are multiple producers and one consumer, llist_add can be
- * used in producers and llist_del_all or llist_del_first can be used
- * in the consumer.
- *
- * This can be summarized as follow:
- *
- *           |   add    | del_first |  del_all
- * add       |    -     |     -     |     -
- * del_first |          |     L     |     L
- * del_all   |          |           |     -
- *
- * Where "-" stands for no lock is needed, while "L" stands for lock
- * is needed.
- *
- * The list entries deleted via llist_del_all can be traversed with
- * traversing function such as llist_for_each etc.  But the list
- * entries can not be traversed safely before deleted from the list.
- * The order of deleted entries is from the newest to the oldest added
- * one.  If you want to traverse from the oldest to the newest, you
- * must reverse the order by yourself before traversing.
- *
- * The basic atomic operation of this list is cmpxchg on long.  On
- * architectures that don't have NMI-safe cmpxchg implementation, the
- * list can NOT be used in NMI handler.  So code uses the list in NMI
- * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
- */
-
-struct llist_head {
-	struct llist_node *first;
-};
-
-struct llist_node {
-	struct llist_node *next;
-};
-
-#define LLIST_HEAD_INIT(name)	{ NULL }
-#define LLIST_HEAD(name)	struct llist_head name = LLIST_HEAD_INIT(name)
-
-/**
- * init_llist_head - initialize lock-less list head
- * @head:	the head for your lock-less list
- */
-static inline void init_llist_head(struct llist_head *list)
-{
-	list->first = NULL;
-}
-
-/**
- * llist_entry - get the struct of this entry
- * @ptr:	the &struct llist_node pointer.
- * @type:	the type of the struct this is embedded in.
- * @member:	the name of the llist_node within the struct.
- */
-#define llist_entry(ptr, type, member)		\
-	container_of(ptr, type, member)
-
-/**
- * llist_for_each - iterate over some deleted entries of a lock-less list
- * @pos:	the &struct llist_node to use as a loop cursor
- * @node:	the first entry of deleted list entries
- *
- * In general, some entries of the lock-less list can be traversed
- * safely only after being deleted from list, so start with an entry
- * instead of list head.
- *
- * If being used on entries deleted from lock-less list directly, the
- * traverse order is from the newest to the oldest added entry.  If
- * you want to traverse from the oldest to the newest, you must
- * reverse the order by yourself before traversing.
- */
-#define llist_for_each(pos, node)			\
-	for ((pos) = (node); pos; (pos) = (pos)->next)
-
-/**
- * llist_for_each_entry - iterate over some deleted entries of lock-less list of given type
- * @pos:	the type * to use as a loop cursor.
- * @node:	the fist entry of deleted list entries.
- * @member:	the name of the llist_node with the struct.
- *
- * In general, some entries of the lock-less list can be traversed
- * safely only after being removed from list, so start with an entry
- * instead of list head.
- *
- * If being used on entries deleted from lock-less list directly, the
- * traverse order is from the newest to the oldest added entry.  If
- * you want to traverse from the oldest to the newest, you must
- * reverse the order by yourself before traversing.
- */
-#define llist_for_each_entry(pos, node, member)				\
-	for ((pos) = llist_entry((node), typeof(*(pos)), member);	\
-	     &(pos)->member != NULL;					\
-	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
-
-/**
- * llist_empty - tests whether a lock-less list is empty
- * @head:	the list to test
- *
- * Not guaranteed to be accurate or up to date.  Just a quick way to
- * test whether the list is empty without deleting something from the
- * list.
- */
-static inline int llist_empty(const struct llist_head *head)
-{
-	return ACCESS_ONCE(head->first) == NULL;
-}
-
-void llist_add(struct llist_node *new, struct llist_head *head);
-void llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
-		     struct llist_head *head);
-struct llist_node *llist_del_first(struct llist_head *head);
-struct llist_node *llist_del_all(struct llist_head *head);
-#endif /* LLIST_H */
Index: linux-2.6-lttng/include/linux/llstack.h
===================================================================
--- /dev/null
+++ linux-2.6-lttng/include/linux/llstack.h
@@ -0,0 +1,126 @@
+#ifndef LLSTACK_H
+#define LLSTACK_H
+/*
+ * Lock-less NULL terminated single linked list stack (LIFO)
+ *
+ * If there are multiple producers and multiple consumers, llstack_add
+ * can be used in producers and llstack_del_all can be used in
+ * consumers.  They can work simultaneously without lock.  But
+ * llstack_del_first can not be used here.  Because llstack_del_first
+ * depends on list->first->next does not changed if list->first is not
+ * changed during its operation, but llstack_del_first, llstack_add,
+ * llstack_add (or llstack_del_all, llstack_add, llstack_add) sequence in
+ * another consumer may violate that.
+ *
+ * If there are multiple producers and one consumer, llstack_add can be
+ * used in producers and llstack_del_all or llstack_del_first can be used
+ * in the consumer.
+ *
+ * This can be summarized as follow:
+ *
+ *           |  push    |    pop    |  pop_all
+ * push      |    -     |     -     |     -
+ * pop       |          |     L     |     L
+ * pop_all   |          |           |     -
+ *
+ * Where "-" stands for no lock is needed, while "L" stands for lock
+ * is needed.
+ *
+ * The list entries deleted via llstack_del_all can be traversed with
+ * traversing function such as llstack_for_each etc.  But the list
+ * entries can not be traversed safely before deleted from the list.
+ * The order of deleted entries is from the newest to the oldest added
+ * one.  If you want to traverse from the oldest to the newest, you
+ * must reverse the order by yourself before traversing.
+ *
+ * The basic atomic operation of this list is cmpxchg on long.  On
+ * architectures that don't have NMI-safe cmpxchg implementation, the
+ * list can NOT be used in NMI handler.  So code uses the list in NMI
+ * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
+ */
+
+struct llstack_head {
+	struct llstack_node *first;
+};
+
+struct llstack_node {
+	struct llstack_node *next;
+};
+
+#define LLSTACK_HEAD_INIT(name)	{ NULL }
+#define LLSTACK_HEAD(name)	struct llstack_head name = LLSTACK_HEAD_INIT(name)
+
+/**
+ * init_llstack_head - initialize lock-less list stack head
+ * @head:	the head for your lock-less list stack
+ */
+static inline void init_llstack_head(struct llstack_head *stack)
+{
+	stack->first = NULL;
+}
+
+/**
+ * llstack_entry - get the struct of this entry
+ * @ptr:	the &struct llstack_node pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the llstack_node within the struct.
+ */
+#define llstack_entry(ptr, type, member)		\
+	container_of(ptr, type, member)
+
+/**
+ * llstack_for_each - iterate over some deleted entries of a lock-less stack
+ * @pos:	the &struct llstack_node to use as a loop cursor
+ * @node:	the first entry of deleted list entries
+ *
+ * In general, some entries of the lock-less list can be traversed
+ * safely only after being deleted from list, so start with an entry
+ * instead of list head.
+ *
+ * If being used on entries deleted from lock-less list directly, the
+ * traverse order is from the newest to the oldest added entry.  If
+ * you want to traverse from the oldest to the newest, you must
+ * reverse the order by yourself before traversing.
+ */
+#define llstack_for_each(pos, node)			\
+	for ((pos) = (node); pos; (pos) = (pos)->next)
+
+/**
+ * llstack_for_each_entry - iterate over some deleted entries of lock-less stack of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @node:	the fist entry of deleted list entries.
+ * @member:	the name of the llstack_node with the struct.
+ *
+ * In general, some entries of the lock-less list can be traversed
+ * safely only after being removed from list, so start with an entry
+ * instead of list head.
+ *
+ * If being used on entries deleted from lock-less list directly, the
+ * traverse order is from the newest to the oldest added entry.  If
+ * you want to traverse from the oldest to the newest, you must
+ * reverse the order by yourself before traversing.
+ */
+#define llstack_for_each_entry(pos, node, member)			\
+	for ((pos) = llstack_entry((node), typeof(*(pos)), member);	\
+	     &(pos)->member != NULL;					\
+	     (pos) = llstack_entry((pos)->member.next, typeof(*(pos)), member))
+
+/**
+ * llstack_empty - tests whether a lock-less stack is empty
+ * @head:	the stack to test
+ *
+ * Not guaranteed to be accurate or up to date.  Just a quick way to
+ * test whether the list is empty without deleting something from the
+ * list.
+ */
+static inline int llstack_empty(const struct llstack_head *head)
+{
+	return ACCESS_ONCE(head->first) == NULL;
+}
+
+void llstack_push(struct llstack_node *new, struct llstack_head *head);
+void llstack_push_batch(struct llstack_node *new_first, struct llstack_node *new_last,
+			struct llstack_head *head);
+struct llstack_node *llstack_pop(struct llstack_head *head);
+struct llstack_node *llstack_pop_all(struct llstack_head *head);
+#endif /* LLSTACK_H */
Index: linux-2.6-lttng/lib/Kconfig
===================================================================
--- linux-2.6-lttng.orig/lib/Kconfig
+++ linux-2.6-lttng/lib/Kconfig
@@ -276,7 +276,7 @@ config CORDIC
 	  so its calculations are in fixed point. Modules can select this
 	  when they require this function. Module will be called cordic.
 
-config LLIST
+config LLSTACK
 	bool
 
 endmenu
Index: linux-2.6-lttng/lib/Makefile
===================================================================
--- linux-2.6-lttng.orig/lib/Makefile
+++ linux-2.6-lttng/lib/Makefile
@@ -115,7 +115,7 @@ obj-$(CONFIG_CPU_RMAP) += cpu_rmap.o
 
 obj-$(CONFIG_CORDIC) += cordic.o
 
-obj-$(CONFIG_LLIST) += llist.o
+obj-$(CONFIG_LLSTACK) += llstack.o
 
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
Index: linux-2.6-lttng/lib/llist.c
===================================================================
--- linux-2.6-lttng.orig/lib/llist.c
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
Index: linux-2.6-lttng/lib/llstack.c
===================================================================
--- /dev/null
+++ linux-2.6-lttng/lib/llstack.c
@@ -0,0 +1,129 @@
+/*
+ * Lock-less NULL terminated single linked list stack (LIFO)
+ *
+ * The basic atomic operation of this list is cmpxchg on long.  On
+ * architectures that don't have NMI-safe cmpxchg implementation, the
+ * list can NOT be used in NMI handler.  So code uses the list in NMI
+ * handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
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
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/llstack.h>
+
+#include <asm/system.h>
+
+/**
+ * llstack_push - push a node into a lock-less stack.
+ * @new:       new entry to be added
+ * @head:      the head for your lock-less stack
+ */
+void llstack_push(struct llstack_node *new, struct llstack_head *head)
+{
+	struct llstack_node *entry, *old_entry;
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
+EXPORT_SYMBOL_GPL(llstack_push);
+
+/**
+ * llstack_push_batch - add several linked entries in batch
+ * @new_first:	first entry in batch to be added
+ * @new_last:	last entry in batch to be added
+ * @head:	the head for your lock-less list
+ */
+void llstack_push_batch(struct llstack_node *new_first, struct llstack_node *new_last,
+			struct llstack_head *head)
+{
+	struct llstack_node *entry, *old_entry;
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
+EXPORT_SYMBOL_GPL(llstack_push_batch);
+
+/**
+ * llstack_pop - pop the first entry of lock-less list stack
+ * @head:	the head for your lock-less list
+ *
+ * If stack is empty, return NULL, otherwise, return the first entry
+ * removed, this is the newest added one.
+ *
+ * Only one llstack_pop user can be used simultaneously with
+ * multiple llstack_push users without lock.  Because otherwise
+ * llstack_pop, llstack_push, llstack_push (or llstack_pop_all, llstack_push,
+ * llstack_push) sequence in another user may change @head->first->next,
+ * but keep @head->first.  If multiple consumers are needed, please
+ * use llstack_pop_all or use lock between consumers.
+ */
+struct llstack_node *llstack_pop(struct llstack_head *head)
+{
+	struct llstack_node *entry, *old_entry, *next;
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
+EXPORT_SYMBOL_GPL(llstack_pop);
+
+/**
+ * llstack_pop_all - remove all entries from lock-less list stack
+ * @head:	the head of lock-less list to delete all entries
+ *
+ * If list stack is empty, return NULL, otherwise, delete all entries and
+ * return the pointer to the first entry.  The order of entries
+ * deleted is from the newest to the oldest added one.
+ */
+struct llstack_node *llstack_pop_all(struct llstack_head *head)
+{
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
+
+	return xchg(&head->first, NULL);
+}
+EXPORT_SYMBOL_GPL(llstack_pop_all);
Index: linux-2.6-lttng/drivers/acpi/apei/ghes.c
===================================================================
--- linux-2.6-lttng.orig/drivers/acpi/apei/ghes.c
+++ linux-2.6-lttng/drivers/acpi/apei/ghes.c
@@ -43,7 +43,7 @@
 #include <linux/ratelimit.h>
 #include <linux/vmalloc.h>
 #include <linux/irq_work.h>
-#include <linux/llist.h>
+#include <linux/llstack.h>
 #include <linux/genalloc.h>
 #include <acpi/apei.h>
 #include <acpi/atomicio.h>
@@ -105,7 +105,7 @@ struct ghes {
 };
 
 struct ghes_estatus_node {
-	struct llist_node llnode;
+	struct llstack_node llnode;
 	struct acpi_hest_generic *generic;
 };
 
@@ -168,13 +168,13 @@ static DEFINE_SPINLOCK(ghes_ioremap_lock
  * printk is not safe in NMI context.  So in NMI handler, we allocate
  * required memory from lock-less memory allocator
  * (ghes_estatus_pool), save estatus into it, put them into lock-less
- * list (ghes_estatus_llist), then delay printk into IRQ context via
+ * list (ghes_estatus_llstack), then delay printk into IRQ context via
  * irq_work (ghes_proc_irq_work).  ghes_estatus_size_request record
  * required pool size by all NMI error source.
  */
 static struct gen_pool *ghes_estatus_pool;
 static unsigned long ghes_estatus_pool_size_request;
-static struct llist_head ghes_estatus_llist;
+static struct llstack_head ghes_estatus_llstack;
 static struct irq_work ghes_proc_irq_work;
 
 struct ghes_estatus_cache *ghes_estatus_caches[GHES_ESTATUS_CACHES_SIZE];
@@ -712,7 +712,7 @@ static int ghes_notify_sci(struct notifi
 
 static void ghes_proc_in_irq(struct irq_work *irq_work)
 {
-	struct llist_node *llnode, *next, *tail = NULL;
+	struct llstack_node *llnode, *next, *tail = NULL;
 	struct ghes_estatus_node *estatus_node;
 	struct acpi_hest_generic *generic;
 	struct acpi_hest_generic_status *estatus;
@@ -722,7 +722,7 @@ static void ghes_proc_in_irq(struct irq_
 	 * Because the time order of estatus in list is reversed,
 	 * revert it back to proper order.
 	 */
-	llnode = llist_del_all(&ghes_estatus_llist);
+	llnode = llstack_pop_all(&ghes_estatus_llstack);
 	while (llnode) {
 		next = llnode->next;
 		llnode->next = tail;
@@ -732,8 +732,8 @@ static void ghes_proc_in_irq(struct irq_
 	llnode = tail;
 	while (llnode) {
 		next = llnode->next;
-		estatus_node = llist_entry(llnode, struct ghes_estatus_node,
-					   llnode);
+		estatus_node = llstack_entry(llnode, struct ghes_estatus_node,
+					     llnode);
 		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
 		len = apei_estatus_len(estatus);
 		node_len = GHES_ESTATUS_NODE_LEN(len);
@@ -806,7 +806,8 @@ static int ghes_notify_nmi(struct notifi
 			estatus_node->generic = ghes->generic;
 			estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
 			memcpy(estatus, ghes->estatus, len);
-			llist_add(&estatus_node->llnode, &ghes_estatus_llist);
+			llstack_push(&estatus_node->llnode,
+				     &ghes_estatus_llstack);
 		}
 next:
 #endif
Index: linux-2.6-lttng/drivers/acpi/apei/Kconfig
===================================================================
--- linux-2.6-lttng.orig/drivers/acpi/apei/Kconfig
+++ linux-2.6-lttng/drivers/acpi/apei/Kconfig
@@ -13,7 +13,7 @@ config ACPI_APEI_GHES
 	bool "APEI Generic Hardware Error Source"
 	depends on ACPI_APEI && X86
 	select ACPI_HED
-	select LLIST
+	select LLSTACK
 	select GENERIC_ALLOCATOR
 	help
 	  Generic Hardware Error Source provides a way to report

