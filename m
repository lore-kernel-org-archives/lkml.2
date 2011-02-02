Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1BBVlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:41:39 -0500
Received: from www.tglx.de ([62.245.132.106]:38911 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab1BBVlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:41:37 -0500
Message-Id: <20110202212552.044020100@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 02 Feb 2011 21:41:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [patch 4/8] genirq: Introduce IRQ_EDGE_EOI flag
References: <20110202212258.546660886@linutronix.de>
Content-Disposition: inline; filename=genirq-introduce-edge-eoi-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc/cell has a slightly modified version of the edge handler. The
main difference is that it does not ack and mask, but uses
eoi. handle_edge_irq is an oddball handler anyway, which should be
avoided wherever it can. So it's not worth to have a slightly
different copy around.

Add a special flag to reuse handle_edge_irq for this odd case.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/irq.h |    3 ++-
 kernel/irq/chip.c   |   11 ++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -71,10 +71,11 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 #define IRQ_ONESHOT		0x08000000	/* IRQ is not unmasked after hardirq */
 #define IRQ_NESTED_THREAD	0x10000000	/* IRQ is nested into another, no own handler thread */
+#define IRQ_EDGE_EOI		0x20000000	/* IRQ abuses edge handler with EOI */
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
-	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL)
+	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL | IRQ_EDGE_EOI)
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -633,13 +633,15 @@ handle_edge_irq(unsigned int irq, struct
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
 		desc->status |= IRQ_PENDING;
-		mask_ack_irq(desc);
+		if (!(desc->status & IRQ_EDGE_EOI))
+			mask_ack_irq(desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
+	if (!(desc->status & IRQ_EDGE_EOI))
+		desc->irq_data.chip->irq_ack(&desc->irq_data);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -649,7 +651,8 @@ handle_edge_irq(unsigned int irq, struct
 		irqreturn_t action_ret;
 
 		if (unlikely(!action)) {
-			mask_irq(desc);
+			if (!(desc->status & IRQ_EDGE_EOI))
+				mask_irq(desc);
 			goto out_unlock;
 		}
 
@@ -675,6 +678,8 @@ handle_edge_irq(unsigned int irq, struct
 
 	desc->status &= ~IRQ_INPROGRESS;
 out_unlock:
+	if (desc->status & IRQ_EDGE_EOI)
+		desc->irq_data.chip->irq_eoi(&desc->irq_data);
 	raw_spin_unlock(&desc->lock);
 }
 


