Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2KRBFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 20:05:49 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51386 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2KRBFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 20:05:13 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 8/9] irq_work: Make self-IPIs optable
Date: Sun, 18 Nov 2012 02:04:51 +0100
Message-Id: <1353200692-6039-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353200692-6039-1-git-send-email-fweisbec@gmail.com>
References: <1353200692-6039-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On irq work initialization, let the user choose to define it
as "lazy" or not. "Lazy" means that we don't want to send
an IPI (provided the arch can anyway) when we enqueue this
work but we rather prefer to wait for the next timer tick
to execute our work if possible.

This is going to be a benefit for non-urgent enqueuers
(like printk in the future) that may prefer not to raise
an IPI storm in case of frequent enqueuing on short periods
of time.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/irq_work.h |   14 +++++++++++++
 kernel/irq_work.c        |   47 ++++++++++++++++++++++++++-------------------
 2 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index a69704f..b28eb60 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -3,6 +3,20 @@
 
 #include <linux/llist.h>
 
+/*
+ * An entry can be in one of four states:
+ *
+ * free	     NULL, 0 -> {claimed}       : free to be used
+ * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
+ * pending   next, 3 -> {busy}          : queued, pending callback
+ * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
+ */
+
+#define IRQ_WORK_PENDING	1UL
+#define IRQ_WORK_BUSY		2UL
+#define IRQ_WORK_FLAGS		3UL
+#define IRQ_WORK_LAZY		4UL /* Doesn't want IPI, wait for tick */
+
 struct irq_work {
 	unsigned long flags;
 	struct llist_node llnode;
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 480f747..7f3a59b 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -12,24 +12,15 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
+#include <linux/sched.h>
+#include <linux/tick.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <asm/processor.h>
 
-/*
- * An entry can be in one of four states:
- *
- * free	     NULL, 0 -> {claimed}       : free to be used
- * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
- * pending   next, 3 -> {busy}          : queued, pending callback
- * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
- */
-
-#define IRQ_WORK_PENDING	1UL
-#define IRQ_WORK_BUSY		2UL
-#define IRQ_WORK_FLAGS		3UL
 
 static DEFINE_PER_CPU(struct llist_head, irq_work_list);
+static DEFINE_PER_CPU(int, irq_work_raised);
 
 /*
  * Claim the entry so that no one else will poke at it.
@@ -69,14 +60,19 @@ void __weak arch_irq_work_raise(void)
  */
 static void __irq_work_queue(struct irq_work *work)
 {
-	bool empty;
-
 	preempt_disable();
 
-	empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
-	/* The list was empty, raise self-interrupt to start processing. */
-	if (empty)
-		arch_irq_work_raise();
+	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
+
+	/*
+	 * If the work is not "lazy" or the tick is stopped, raise the irq
+	 * work interrupt (if supported by the arch), otherwise, just wait
+	 * for the next tick.
+	 */
+	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
+		if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
+			arch_irq_work_raise();
+	}
 
 	preempt_enable();
 }
@@ -117,10 +113,19 @@ bool irq_work_needs_cpu(void)
 
 static void __irq_work_run(void)
 {
+	unsigned long flags;
 	struct irq_work *work;
 	struct llist_head *this_list;
 	struct llist_node *llnode;
 
+
+	/*
+	 * Reset the "raised" state right before we check the list because
+	 * an NMI may enqueue after we find the list empty from the runner.
+	 */
+	__this_cpu_write(irq_work_raised, 0);
+	barrier();
+
 	this_list = &__get_cpu_var(irq_work_list);
 	if (llist_empty(this_list))
 		return;
@@ -140,13 +145,15 @@ static void __irq_work_run(void)
 		 * to claim that work don't rely on us to handle their data
 		 * while we are in the middle of the func.
 		 */
-		xchg(&work->flags, IRQ_WORK_BUSY);
+		flags = work->flags & ~IRQ_WORK_PENDING;
+		xchg(&work->flags, flags);
+
 		work->func(work);
 		/*
 		 * Clear the BUSY bit and return to the free state if
 		 * no-one else claimed it meanwhile.
 		 */
-		(void)cmpxchg(&work->flags, IRQ_WORK_BUSY, 0);
+		(void)cmpxchg(&work->flags, flags, flags & ~IRQ_WORK_BUSY);
 	}
 }
 
-- 
1.7.5.4

