Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab1IFGZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 02:25:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:60692 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab1IFGZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 02:25:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="45363898"
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -mm 4/4] irq_work, Use llist in irq_work
Date: Tue,  6 Sep 2011 14:25:07 +0800
Message-Id: <1315290307-25145-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315290307-25145-1-git-send-email-ying.huang@intel.com>
References: <1315290307-25145-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use llist in irq_work instead of the lock-less linked list
implementation in irq_work to avoid the code duplication.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/irq_work.h |   15 ++++---
 kernel/irq_work.c        |   92 ++++++++++++++++-------------------------------
 2 files changed, 41 insertions(+), 66 deletions(-)

--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -1,20 +1,23 @@
 #ifndef _LINUX_IRQ_WORK_H
 #define _LINUX_IRQ_WORK_H
 
+#include <linux/llist.h>
+
 struct irq_work {
-	struct irq_work *next;
+	unsigned long flags;
+	struct llist_node llnode;
 	void (*func)(struct irq_work *);
 };
 
 static inline
-void init_irq_work(struct irq_work *entry, void (*func)(struct irq_work *))
+void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 {
-	entry->next = NULL;
-	entry->func = func;
+	work->flags = 0;
+	work->func = func;
 }
 
-bool irq_work_queue(struct irq_work *entry);
+bool irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
-void irq_work_sync(struct irq_work *entry);
+void irq_work_sync(struct irq_work *work);
 
 #endif /* _LINUX_IRQ_WORK_H */
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -10,7 +10,6 @@
 #include <linux/irq_work.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
-#include <asm/processor.h>
 
 /*
  * An entry can be in one of four states:
@@ -19,54 +18,34 @@
  * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
  * pending   next, 3 -> {busy}          : queued, pending callback
  * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
- *
- * We use the lower two bits of the next pointer to keep PENDING and BUSY
- * flags.
  */
 
 #define IRQ_WORK_PENDING	1UL
 #define IRQ_WORK_BUSY		2UL
 #define IRQ_WORK_FLAGS		3UL
 
-static inline bool irq_work_is_set(struct irq_work *entry, int flags)
-{
-	return (unsigned long)entry->next & flags;
-}
-
-static inline struct irq_work *irq_work_next(struct irq_work *entry)
-{
-	unsigned long next = (unsigned long)entry->next;
-	next &= ~IRQ_WORK_FLAGS;
-	return (struct irq_work *)next;
-}
-
-static inline struct irq_work *next_flags(struct irq_work *entry, int flags)
-{
-	unsigned long next = (unsigned long)entry;
-	next |= flags;
-	return (struct irq_work *)next;
-}
-
-static DEFINE_PER_CPU(struct irq_work *, irq_work_list);
+static DEFINE_PER_CPU(struct llist_head, irq_work_list);
 
 /*
  * Claim the entry so that no one else will poke at it.
  */
-static bool irq_work_claim(struct irq_work *entry)
+static bool irq_work_claim(struct irq_work *work)
 {
-	struct irq_work *next, *nflags;
+	unsigned long flags, nflags;
 
-	do {
-		next = entry->next;
-		if ((unsigned long)next & IRQ_WORK_PENDING)
+	for (;;) {
+		flags = work->flags;
+		if (flags & IRQ_WORK_PENDING)
 			return false;
-		nflags = next_flags(next, IRQ_WORK_FLAGS);
-	} while (cmpxchg(&entry->next, next, nflags) != next);
+		nflags = flags | IRQ_WORK_FLAGS;
+		if (cmpxchg(&work->flags, flags, nflags) == flags)
+			break;
+		cpu_relax();
+	}
 
 	return true;
 }
 
-
 void __weak arch_irq_work_raise(void)
 {
 	/*
@@ -77,20 +56,13 @@ void __weak arch_irq_work_raise(void)
 /*
  * Queue the entry and raise the IPI if needed.
  */
-static void __irq_work_queue(struct irq_work *entry)
+static void __irq_work_queue(struct irq_work *work)
 {
-	struct irq_work *next;
-
 	preempt_disable();
 
-	do {
-		next = __this_cpu_read(irq_work_list);
-		/* Can assign non-atomic because we keep the flags set. */
-		entry->next = next_flags(next, IRQ_WORK_FLAGS);
-	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
-
+	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
 	/* The list was empty, raise self-interrupt to start processing. */
-	if (!irq_work_next(entry))
+	if (!work->llnode.next)
 		arch_irq_work_raise();
 
 	preempt_enable();
@@ -102,16 +74,16 @@ static void __irq_work_queue(struct irq_
  *
  * Can be re-enqueued while the callback is still in progress.
  */
-bool irq_work_queue(struct irq_work *entry)
+bool irq_work_queue(struct irq_work *work)
 {
-	if (!irq_work_claim(entry)) {
+	if (!irq_work_claim(work)) {
 		/*
 		 * Already enqueued, can't do!
 		 */
 		return false;
 	}
 
-	__irq_work_queue(entry);
+	__irq_work_queue(work);
 	return true;
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
@@ -122,34 +94,34 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
  */
 void irq_work_run(void)
 {
-	struct irq_work *list;
+	struct irq_work *work;
+	struct llist_head *this_list;
+	struct llist_node *llnode;
 
-	if (this_cpu_read(irq_work_list) == NULL)
+	this_list = &__get_cpu_var(irq_work_list);
+	if (llist_empty(this_list))
 		return;
 
 	BUG_ON(!in_irq());
 	BUG_ON(!irqs_disabled());
 
-	list = this_cpu_xchg(irq_work_list, NULL);
-
-	while (list != NULL) {
-		struct irq_work *entry = list;
+	llnode = llist_del_all(this_list);
+	while (llnode != NULL) {
+		work = llist_entry(llnode, struct irq_work, llnode);
 
-		list = irq_work_next(list);
+		llnode = llnode->next;
 
 		/*
-		 * Clear the PENDING bit, after this point the @entry
+		 * Clear the PENDING bit, after this point the @work
 		 * can be re-used.
 		 */
-		entry->next = next_flags(NULL, IRQ_WORK_BUSY);
-		entry->func(entry);
+		work->flags = IRQ_WORK_BUSY;
+		work->func(work);
 		/*
 		 * Clear the BUSY bit and return to the free state if
 		 * no-one else claimed it meanwhile.
 		 */
-		(void)cmpxchg(&entry->next,
-			      next_flags(NULL, IRQ_WORK_BUSY),
-			      NULL);
+		(void)cmpxchg(&work->flags, IRQ_WORK_BUSY, 0);
 	}
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
@@ -158,11 +130,11 @@ EXPORT_SYMBOL_GPL(irq_work_run);
  * Synchronize against the irq_work @entry, ensures the entry is not
  * currently in use.
  */
-void irq_work_sync(struct irq_work *entry)
+void irq_work_sync(struct irq_work *work)
 {
 	WARN_ON_ONCE(irqs_disabled());
 
-	while (irq_work_is_set(entry, IRQ_WORK_BUSY))
+	while (work->flags & IRQ_WORK_BUSY)
 		cpu_relax();
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
