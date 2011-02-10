Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab1BJXgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:55 -0500
Received: from www.tglx.de ([62.245.132.106]:44078 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416Ab1BJXgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:53 -0500
Message-Id: <20110210223256.628937100@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 24/75] genirq: Use handle_irq_event() in handle_level_irq()
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-convert-level-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -477,9 +477,6 @@ out_unlock:
 void
 handle_level_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct irqaction *action;
-	irqreturn_t action_ret;
-
 	raw_spin_lock(&desc->lock);
 	mask_ack_irq(desc);
 
@@ -494,19 +491,10 @@ handle_level_irq(unsigned int irq, struc
 	 * If its disabled or no action available
 	 * keep it masked and get out of here
 	 */
-	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
+	if (unlikely(!desc->action || (desc->status & IRQ_DISABLED)))
 		goto out_unlock;
 
-	desc->status |= IRQ_INPROGRESS;
-	raw_spin_unlock(&desc->lock);
-
-	action_ret = handle_IRQ_event(irq, action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
-
-	raw_spin_lock(&desc->lock);
-	desc->status &= ~IRQ_INPROGRESS;
+	handle_irq_event(desc);
 
 	if (!(desc->status & (IRQ_DISABLED | IRQ_ONESHOT)))
 		unmask_irq(desc);


