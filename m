Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab1BJXtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:49:50 -0500
Received: from www.tglx.de ([62.245.132.106]:44097 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454Ab1BJXg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:56 -0500
Message-Id: <20110210223256.724571488@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 25/75] genirq: Use handle_irq_event() in handle_fasteoi_irq()
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-convert-fasteoi-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -516,9 +516,6 @@ EXPORT_SYMBOL_GPL(handle_level_irq);
 void
 handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct irqaction *action;
-	irqreturn_t action_ret;
-
 	raw_spin_lock(&desc->lock);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
@@ -532,26 +529,14 @@ handle_fasteoi_irq(unsigned int irq, str
 	 * If its disabled or no action available
 	 * then mask it and get out of here:
 	 */
-	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
+	if (unlikely(!desc->action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
 		mask_irq(desc);
 		goto out;
 	}
-
-	desc->status |= IRQ_INPROGRESS;
-	desc->status &= ~IRQ_PENDING;
-	raw_spin_unlock(&desc->lock);
-
-	action_ret = handle_IRQ_event(irq, action);
-	if (!noirqdebug)
-		note_interrupt(irq, desc, action_ret);
-
-	raw_spin_lock(&desc->lock);
-	desc->status &= ~IRQ_INPROGRESS;
+	handle_irq_event(desc);
 out:
 	desc->irq_data.chip->irq_eoi(&desc->irq_data);
-
 	raw_spin_unlock(&desc->lock);
 }
 


