Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab1BJXgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:11 -0500
Received: from www.tglx.de ([62.245.132.106]:43889 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757342Ab1BJXgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:09 -0500
Message-Id: <20110210223254.901307630@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 06/75] genirq: Plug race in report_bad_irq()
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-fix-race-in-report-bad-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot walk the action chain unlocked. Even if IRQ_INPROGRESS is
set an action can be removed and we follow a null pointer. It's safe
to take the lock there, because the code which removes the action will
call synchronize_irq() which waits unlocked for IRQ_INPROGRESS going
away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/spurious.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -139,15 +139,13 @@ static void poll_spurious_irqs(unsigned 
  *
  * (The other 100-of-100,000 interrupts may have been a correctly
  *  functioning device sharing an IRQ with the failing one)
- *
- * Called under desc->lock
  */
-
 static void
 __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 		 irqreturn_t action_ret)
 {
 	struct irqaction *action;
+	unsigned long flags;
 
 	if (action_ret != IRQ_HANDLED && action_ret != IRQ_NONE) {
 		printk(KERN_ERR "irq event %d: bogus return value %x\n",
@@ -159,6 +157,13 @@ __report_bad_irq(unsigned int irq, struc
 	dump_stack();
 	printk(KERN_ERR "handlers:\n");
 
+	/*
+	 * We need to take desc->lock here. note_interrupt() is called
+	 * w/o desc->lock held, but IRQ_PROGRESS set. We might race
+	 * with something else removing an action. It's ok to take
+	 * desc->lock here. See synchronize_irq().
+	 */
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	action = desc->action;
 	while (action) {
 		printk(KERN_ERR "[<%p>]", action->handler);
@@ -167,6 +172,7 @@ __report_bad_irq(unsigned int irq, struc
 		printk("\n");
 		action = action->next;
 	}
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 static void


