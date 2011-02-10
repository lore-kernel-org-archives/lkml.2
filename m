Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab1BJXvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:51:10 -0500
Received: from www.tglx.de ([62.245.132.106]:43996 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349Ab1BJXgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:35 -0500
Message-Id: <20110210223255.961530799@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 17/75] genirq: Consolidate IRQ_DISABLED
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-consolidate-IRQ_DISABLED.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle IRQ_DISABLED consistent.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c     |   14 ++++++++++----
 kernel/irq/manage.c   |    9 +++------
 kernel/irq/resend.c   |    5 -----
 kernel/irq/spurious.c |    2 +-
 4 files changed, 14 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -192,11 +192,14 @@ EXPORT_SYMBOL_GPL(set_irq_nested_thread)
 
 int irq_startup(struct irq_desc *desc)
 {
-	desc->status &= ~(IRQ_MASKED | IRQ_DISABLED);
+	desc->status &= ~IRQ_DISABLED;
 	desc->depth = 0;
 
-	if (desc->irq_data.chip->irq_startup)
-		return desc->irq_data.chip->irq_startup(&desc->irq_data);
+	if (desc->irq_data.chip->irq_startup) {
+		int ret = desc->irq_data.chip->irq_startup(&desc->irq_data);
+		desc->status &= IRQ_MASKED;
+		return ret;
+	}
 
 	irq_enable(desc);
 	return 0;
@@ -204,7 +207,7 @@ int irq_startup(struct irq_desc *desc)
 
 void irq_shutdown(struct irq_desc *desc)
 {
-	desc->status |= IRQ_MASKED | IRQ_DISABLED;
+	desc->status |= IRQ_DISABLED;
 	desc->depth = 1;
 	if (desc->irq_data.chip->irq_shutdown)
 		desc->irq_data.chip->irq_shutdown(&desc->irq_data);
@@ -212,10 +215,12 @@ void irq_shutdown(struct irq_desc *desc)
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
 	else
 		desc->irq_data.chip->irq_mask(&desc->irq_data);
+	desc->status |= IRQ_MASKED;
 }
 
 void irq_enable(struct irq_desc *desc)
 {
+	desc->status &= ~IRQ_DISABLED;
 	if (desc->irq_data.chip->irq_enable)
 		desc->irq_data.chip->irq_enable(&desc->irq_data);
 	else
@@ -225,6 +230,7 @@ void irq_enable(struct irq_desc *desc)
 
 void irq_disable(struct irq_desc *desc)
 {
+	desc->status |= IRQ_DISABLED;
 	if (desc->irq_data.chip->irq_disable) {
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
 		desc->status |= IRQ_MASKED;
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -337,10 +337,8 @@ void __disable_irq(struct irq_desc *desc
 		desc->status |= IRQ_SUSPENDED;
 	}
 
-	if (!desc->depth++) {
-		desc->status |= IRQ_DISABLED;
+	if (!desc->depth++)
 		irq_disable(desc);
-	}
 }
 
 /**
@@ -415,12 +413,11 @@ void __enable_irq(struct irq_desc *desc,
 		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
 		break;
 	case 1: {
-		unsigned int status = desc->status & ~IRQ_DISABLED;
-
 		if (desc->status & IRQ_SUSPENDED)
 			goto err_out;
 		/* Prevent probing on this irq: */
-		desc->status = status | IRQ_NOPROBE;
+		desc->status |= IRQ_NOPROBE;
+		irq_enable(desc);
 		check_irq_resend(desc, irq);
 		/* fall-through */
 	}
Index: linux-2.6-tip/kernel/irq/resend.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/resend.c
+++ linux-2.6-tip/kernel/irq/resend.c
@@ -56,11 +56,6 @@ static DECLARE_TASKLET(resend_tasklet, r
 void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 {
 	/*
-	 * Make sure the interrupt is enabled, before resending it:
-	 */
-	irq_enable(desc);
-
-	/*
 	 * We do not resend level type interrupts. Level type
 	 * interrupts are resent by hardware when they are still
 	 * active.
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -301,7 +301,7 @@ void note_interrupt(unsigned int irq, st
 		 * Now kill the IRQ
 		 */
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
-		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
+		desc->status |= IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
 		irq_disable(desc);
 


