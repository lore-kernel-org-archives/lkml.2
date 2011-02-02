Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1BBVlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:41:42 -0500
Received: from www.tglx.de ([62.245.132.106]:38913 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab1BBVlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:41:39 -0500
Message-Id: <20110202212552.167512165@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 02 Feb 2011 21:41:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [patch 5/8] powerpc: cell: Use handle_edge_irq
References: <20110202212258.546660886@linutronix.de>
Content-Disposition: inline; filename=powerpc-cell-use-handle-edge-irq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

handle_edge_irq is now special cased for the cell EOI
requirements. Use it and remove the duplicate code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/powerpc/platforms/cell/interrupt.c |   52 ++------------------------------
 1 file changed, 4 insertions(+), 48 deletions(-)

Index: linux-2.6-tip/arch/powerpc/platforms/cell/interrupt.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/cell/interrupt.c
+++ linux-2.6-tip/arch/powerpc/platforms/cell/interrupt.c
@@ -233,52 +233,6 @@ static int iic_host_match(struct irq_hos
 				    "IBM,CBEA-Internal-Interrupt-Controller");
 }
 
-extern int noirqdebug;
-
-static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
-{
-	raw_spin_lock(&desc->lock);
-
-	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
-
-	/*
-	 * If we're currently running this IRQ, or its disabled,
-	 * we shouldn't process the IRQ. Mark it pending, handle
-	 * the necessary masking and go out
-	 */
-	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
-		    !desc->action)) {
-		desc->status |= IRQ_PENDING;
-		goto out_eoi;
-	}
-
-	kstat_incr_irqs_this_cpu(irq, desc);
-
-	/* Mark the IRQ currently in progress.*/
-	desc->status |= IRQ_INPROGRESS;
-
-	do {
-		struct irqaction *action = desc->action;
-		irqreturn_t action_ret;
-
-		if (unlikely(!action))
-			goto out_eoi;
-
-		desc->status &= ~IRQ_PENDING;
-		raw_spin_unlock(&desc->lock);
-		action_ret = handle_IRQ_event(irq, action);
-		if (!noirqdebug)
-			note_interrupt(irq, desc, action_ret);
-		raw_spin_lock(&desc->lock);
-
-	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
-
-	desc->status &= ~IRQ_INPROGRESS;
-out_eoi:
-	desc->chip->eoi(irq);
-	raw_spin_unlock(&desc->lock);
-}
-
 static int iic_host_map(struct irq_host *h, unsigned int virq,
 			irq_hw_number_t hw)
 {
@@ -287,11 +241,13 @@ static int iic_host_map(struct irq_host 
 		set_irq_chip_and_handler(virq, &iic_chip, handle_percpu_irq);
 		break;
 	case IIC_IRQ_TYPE_IOEXC:
+		irq_set_status_flags(i, IRQ_EDGE_EOI);
 		set_irq_chip_and_handler(virq, &iic_ioexc_chip,
-					 handle_iic_irq);
+					 handle_edge_irq);
 		break;
 	default:
-		set_irq_chip_and_handler(virq, &iic_chip, handle_iic_irq);
+		irq_set_status_flags(i, IRQ_EDGE_EOI);
+		set_irq_chip_and_handler(virq, &iic_chip, handle_edge_irq);
 	}
 	return 0;
 }


