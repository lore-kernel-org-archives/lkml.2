Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab1BJXs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:48:56 -0500
Received: from www.tglx.de ([62.245.132.106]:44103 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757464Ab1BJXg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:58 -0500
Message-Id: <20110210223256.817406431@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 26/75] genirq: Use handle_irq_event() in handle_edge_irq()
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-convert-edge-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's safe to drop the IRQ_INPROGRESS flag between action chain walks
as we are protected by desc->lock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -581,14 +581,8 @@ handle_edge_irq(unsigned int irq, struct
 	/* Start handling the irq */
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
-	/* Mark the IRQ currently in progress.*/
-	desc->status |= IRQ_INPROGRESS;
-
 	do {
-		struct irqaction *action = desc->action;
-		irqreturn_t action_ret;
-
-		if (unlikely(!action)) {
+		if (unlikely(!desc->action)) {
 			mask_irq(desc);
 			goto out_unlock;
 		}
@@ -604,16 +598,10 @@ handle_edge_irq(unsigned int irq, struct
 			unmask_irq(desc);
 		}
 
-		desc->status &= ~IRQ_PENDING;
-		raw_spin_unlock(&desc->lock);
-		action_ret = handle_IRQ_event(irq, action);
-		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
-		raw_spin_lock(&desc->lock);
+		handle_irq_event(desc);
 
 	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
 
-	desc->status &= ~IRQ_INPROGRESS;
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }


