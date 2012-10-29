Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873Ab2J2N2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:28:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42297 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab2J2N2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:28:36 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 7/9] irq_work: Make self-IPIs optable
Date: Mon, 29 Oct 2012 14:28:14 +0100
Message-Id: <1351517296-9173-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/irq_work.h |   31 ++++++++++++++++++++++++++
 kernel/irq_work.c        |   53 ++++++++++++++++++++++++++++++++-------------
 kernel/time/tick-sched.c |    3 +-
 3 files changed, 70 insertions(+), 17 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index b39ea0b..7b60c87 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -4,6 +4,20 @@
 #include <linux/llist.h>
 #include <asm/irq_work.h>
 
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
@@ -17,8 +31,25 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 	work->func = func;
 }
 
+#define DEFINE_IRQ_WORK(w, f)	\
+	struct irq_work w = {	\
+		.func = f,	\
+	}
+
+#define DEFINE_IRQ_WORK_LAZY(w, f)	\
+	struct irq_work w = {		\
+		.flags = IRQ_WORK_LAZY, \
+		.func = f,		\
+	}
+
 bool irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
+#ifdef CONFIG_IRQ_WORK
+bool irq_work_needs_cpu(void);
+#else
+static bool irq_work_needs_cpu(void) { return false; }
+#endif
+
 #endif /* _LINUX_IRQ_WORK_H */
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index d00011c..ce72b20 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -12,20 +12,10 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
+#include <linux/tick.h>
+#include <linux/sched.h>
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
 
@@ -66,10 +56,28 @@ static void __irq_work_queue(struct irq_work *work)
 	preempt_disable();
 
 	empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
-	/* The list was empty, raise self-interrupt to start processing. */
-	if (empty)
+
+	/*
+	 * In any case, raise an IPI if requested and possible in case
+	 * the queue is empty or it's filled with lazy works.
+	 */
+	if (!(work->flags & IRQ_WORK_LAZY) && arch_irq_work_has_ipi()) {
 		arch_irq_work_raise();
+		goto out;
+	}
 
+	if (empty) {
+		/*
+		 * If the arch uses some other obscure way than IPI to raise
+		 * an irq work, just raise and don't think further.
+		 * Now if it can send an IPI, although not requested, and the tick
+		 * is stopped, send it nonetheless otherwise we may wait a long while
+		 * before that lazy work can run.
+		 */
+		if (!arch_irq_work_has_ipi() || tick_nohz_tick_stopped())
+			arch_irq_work_raise();
+	}
+out:
 	preempt_enable();
 }
 
@@ -93,12 +101,24 @@ bool irq_work_queue(struct irq_work *work)
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
 
+bool irq_work_needs_cpu(void)
+{
+	struct llist_head *this_list;
+
+	this_list = &__get_cpu_var(irq_work_list);
+	if (llist_empty(this_list))
+		return false;
+
+	return true;
+}
+
 /*
  * Run the irq_work entries on this cpu. Requires to be ran from hardirq
  * context with local IRQs disabled.
  */
 void irq_work_run(void)
 {
+	unsigned long flags;
 	struct irq_work *work;
 	struct llist_head *this_list;
 	struct llist_node *llnode;
@@ -120,13 +140,14 @@ void irq_work_run(void)
 		 * Clear the PENDING bit, after this point the @work
 		 * can be re-used.
 		 */
-		work->flags = IRQ_WORK_BUSY;
+		flags = work->flags & ~IRQ_WORK_PENDING;
+		work->flags = flags;
 		work->func(work);
 		/*
 		 * Clear the BUSY bit and return to the free state if
 		 * no-one else claimed it meanwhile.
 		 */
-		(void)cmpxchg(&work->flags, IRQ_WORK_BUSY, 0);
+		(void)cmpxchg(&work->flags, flags, flags & ~IRQ_WORK_BUSY);
 	}
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index ccc1971..7ac2fd8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/irq_work.h>
 
 #include <asm/irq_regs.h>
 
@@ -289,7 +290,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {
-- 
1.7.5.4

