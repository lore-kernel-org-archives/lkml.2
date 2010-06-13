Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0FMPcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:32:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:37721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0FMPcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:10 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/12] irq: make spurious poll timer per desc
Date: Sun, 13 Jun 2010 17:31:28 +0200
Message-Id: <1276443098-20653-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276443098-20653-1-git-send-email-tj@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is single timer for for spurious IRQ polling and when
it kicks in, it polls all the IRQs.  Add irq_desc->poll_timer and use
it for spurious polling such that only the failed IRQ is polled.  This
significantly reduces the cost of spurious polling and the polling
interval is adjusted to 10ms.

irq_poll_action_{added|removed}(), which are called from
{setup|free}_irq() respectively, are added so that poll timer
management is done inside spurious.c.

The global polling function poll_spurious_irqs() is replaced with
per-IRQ polling function poll_irq() and try_one_irq() is changed to
expect its callers to acquire desc->lock for upcoming extension of
poll_irq().

This reduces the overhead of spurious handling and eases implementing
further fine grained IRQ protection mechanisms on top.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/irq.h    |    5 +++
 kernel/irq/internals.h |    6 +++
 kernel/irq/manage.c    |   14 +++-----
 kernel/irq/spurious.c  |   93 +++++++++++++++++++++++++++++------------------
 4 files changed, 73 insertions(+), 45 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index ec93be4..50a77f9 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -21,6 +21,7 @@
 #include <linux/irqreturn.h>
 #include <linux/irqnr.h>
 #include <linux/errno.h>
+#include <linux/timer.h>
 #include <linux/topology.h>
 #include <linux/wait.h>
 
@@ -169,6 +170,7 @@ struct irq_2_iommu;
  * @pending_mask:	pending rebalanced interrupts
  * @threads_active:	number of irqaction threads currently running
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
+ * @poll_timer:		timer for IRQ polling
  * @dir:		/proc/irq/ procfs entry
  * @name:		flow handler name for /proc/interrupts output
  */
@@ -203,6 +205,9 @@ struct irq_desc {
 #endif
 	atomic_t		threads_active;
 	wait_queue_head_t       wait_for_threads;
+
+	struct timer_list	poll_timer;
+
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
 #endif
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 341f952..088e5d6 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -38,6 +38,12 @@ extern int irq_select_affinity_usr(unsigned int irq);
 
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
+extern void poll_irq(unsigned long arg);
+extern void irq_poll_action_added(struct irq_desc *desc,
+				  struct irqaction *action);
+extern void irq_poll_action_removed(struct irq_desc *desc,
+				    struct irqaction *action);
+
 /* Inline functions for support of irq chips on slow busses */
 static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
 {
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3164ba7..cf9ab65 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -752,6 +752,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		irq_chip_set_defaults(desc->chip);
 
 		init_waitqueue_head(&desc->wait_for_threads);
+		setup_timer(&desc->poll_timer, poll_irq, (unsigned long)desc);
 
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
@@ -804,17 +805,10 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 
-	/*
-	 * Check whether we disabled the irq via the spurious handler
-	 * before. Reenable it and give it another chance.
-	 */
-	if (shared && (desc->status & IRQ_SPURIOUS_DISABLED)) {
-		desc->status &= ~IRQ_SPURIOUS_DISABLED;
-		__enable_irq(desc, irq, false);
-	}
-
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
+	irq_poll_action_added(desc, new);
+
 	/*
 	 * Strictly no need to wake it up, but hung_task complains
 	 * when no hard interrupt wakes the thread up.
@@ -930,6 +924,8 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
+	irq_poll_action_removed(desc, action);
+
 	unregister_handler_proc(irq, action);
 
 	/* Make sure it's not being used on another CPU: */
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 5da60a2..545f730 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -12,22 +12,22 @@
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
-#include <linux/timer.h>
+
+#include "internals.h"
 
 enum {
 	/* irqfixup levels */
 	IRQFIXUP_SPURIOUS		= 0,		/* spurious storm detection */
 	IRQFIXUP_MISROUTED		= 1,		/* misrouted IRQ fixup */
 	IRQFIXUP_POLL			= 2,		/* enable polling by default */
+
+	/* IRQ polling common parameters */
+	IRQ_POLL_INTV			= HZ / 100,	/* from the good ol' 100HZ tick */
 };
 
 int noirqdebug __read_mostly;
 static int irqfixup __read_mostly = IRQFIXUP_SPURIOUS;
 
-#define POLL_SPURIOUS_IRQ_INTERVAL (HZ/10)
-static void poll_spurious_irqs(unsigned long dummy);
-static DEFINE_TIMER(poll_spurious_irq_timer, poll_spurious_irqs, 0, 0);
-
 /*
  * Recovery handler for misrouted interrupts.
  */
@@ -36,7 +36,6 @@ static int try_one_irq(int irq, struct irq_desc *desc)
 	struct irqaction *action;
 	int ok = 0, work = 0;
 
-	raw_spin_lock(&desc->lock);
 	/* Already running on another processor */
 	if (desc->status & IRQ_INPROGRESS) {
 		/*
@@ -45,7 +44,6 @@ static int try_one_irq(int irq, struct irq_desc *desc)
 		 */
 		if (desc->action && (desc->action->flags & IRQF_SHARED))
 			desc->status |= IRQ_PENDING;
-		raw_spin_unlock(&desc->lock);
 		return ok;
 	}
 	/* Honour the normal IRQ locking */
@@ -88,7 +86,6 @@ static int try_one_irq(int irq, struct irq_desc *desc)
 	 */
 	if (work && desc->chip && desc->chip->end)
 		desc->chip->end(irq);
-	raw_spin_unlock(&desc->lock);
 
 	return ok;
 }
@@ -105,39 +102,15 @@ static int misrouted_irq(int irq)
 		if (i == irq)	/* Already tried */
 			continue;
 
+		raw_spin_lock(&desc->lock);
 		if (try_one_irq(i, desc))
 			ok = 1;
+		raw_spin_unlock(&desc->lock);
 	}
 	/* So the caller can adjust the irq error counts */
 	return ok;
 }
 
-static void poll_spurious_irqs(unsigned long dummy)
-{
-	struct irq_desc *desc;
-	int i;
-
-	for_each_irq_desc(i, desc) {
-		unsigned int status;
-
-		if (!i)
-			 continue;
-
-		/* Racy but it doesn't matter */
-		status = desc->status;
-		barrier();
-		if (!(status & IRQ_SPURIOUS_DISABLED))
-			continue;
-
-		local_irq_disable();
-		try_one_irq(i, desc);
-		local_irq_enable();
-	}
-
-	mod_timer(&poll_spurious_irq_timer,
-		  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
-}
-
 /*
  * If 99,900 of the previous 100,000 interrupts have not been handled
  * then assume that the IRQ is stuck in some manner. Drop a diagnostic
@@ -264,12 +237,60 @@ void __note_interrupt(unsigned int irq, struct irq_desc *desc,
 		desc->depth++;
 		desc->chip->disable(irq);
 
-		mod_timer(&poll_spurious_irq_timer,
-			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
+		mod_timer(&desc->poll_timer, jiffies + IRQ_POLL_INTV);
 	}
 	desc->irqs_unhandled = 0;
 }
 
+/*
+ * IRQ poller.  Called from desc->poll_timer.
+ */
+void poll_irq(unsigned long arg)
+{
+	struct irq_desc *desc = (void *)arg;
+
+	raw_spin_lock_irq(&desc->lock);
+	try_one_irq(desc->irq, desc);
+	raw_spin_unlock_irq(&desc->lock);
+
+	mod_timer(&desc->poll_timer, jiffies + IRQ_POLL_INTV);
+}
+
+void irq_poll_action_added(struct irq_desc *desc, struct irqaction *action)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+
+	/* if the interrupt was killed before, give it one more chance */
+	if (desc->status & IRQ_SPURIOUS_DISABLED) {
+		desc->status &= ~IRQ_SPURIOUS_DISABLED;
+		__enable_irq(desc, desc->irq, false);
+	}
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+}
+
+void irq_poll_action_removed(struct irq_desc *desc, struct irqaction *action)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+
+	/*
+	 * Make sure the timer is offline if no irqaction is left as
+	 * the irq_desc will be reinitialized when the next irqaction
+	 * is added.
+	 */
+	while (!desc->action && try_to_del_timer_sync(&desc->poll_timer) < 0) {
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+		cpu_relax();
+		raw_spin_lock_irqsave(&desc->lock, flags);
+	}
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+}
+
 int noirqdebug_setup(char *str)
 {
 	noirqdebug = 1;
-- 
1.6.4.2

