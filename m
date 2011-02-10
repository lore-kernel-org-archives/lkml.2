Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab1BJXvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:51:08 -0500
Received: from www.tglx.de ([62.245.132.106]:43997 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423Ab1BJXgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:35 -0500
Message-Id: <20110210223255.769629560@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:36:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 15/75] genirq: Consolidate disable/enable
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-consolidate-disable-enable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create irq_disable/enable and use them to keep the flags consistent.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c      |   12 +++++++++++-
 kernel/irq/internals.h |    2 ++
 kernel/irq/manage.c    |    2 +-
 kernel/irq/resend.c    |   10 +++++-----
 kernel/irq/spurious.c  |    2 +-
 5 files changed, 20 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -198,7 +198,7 @@ int irq_startup(struct irq_desc *desc)
 	if (desc->irq_data.chip->irq_startup)
 		return desc->irq_data.chip->irq_startup(&desc->irq_data);
 
-	desc->irq_data.chip->irq_enable(&desc->irq_data);
+	irq_enable(desc);
 	return 0;
 }
 
@@ -209,6 +209,16 @@ void irq_shutdown(struct irq_desc *desc)
 	desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 }
 
+void irq_enable(struct irq_desc *desc)
+{
+	desc->irq_data.chip->irq_enable(&desc->irq_data);
+}
+
+void irq_disable(struct irq_desc *desc)
+{
+	desc->irq_data.chip->irq_disable(&desc->irq_data);
+}
+
 /*
  * default enable function
  */
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -34,6 +34,8 @@ extern void __enable_irq(struct irq_desc
 
 extern int irq_startup(struct irq_desc *desc);
 extern void irq_shutdown(struct irq_desc *desc);
+extern void irq_enable(struct irq_desc *desc);
+extern void irq_disable(struct irq_desc *desc);
 
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -339,7 +339,7 @@ void __disable_irq(struct irq_desc *desc
 
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
-		desc->irq_data.chip->irq_disable(&desc->irq_data);
+		irq_disable(desc);
 	}
 }
 
Index: linux-2.6-tip/kernel/irq/resend.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/resend.c
+++ linux-2.6-tip/kernel/irq/resend.c
@@ -55,20 +55,20 @@ static DECLARE_TASKLET(resend_tasklet, r
  */
 void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 {
-	unsigned int status = desc->status;
-
 	/*
 	 * Make sure the interrupt is enabled, before resending it:
 	 */
-	desc->irq_data.chip->irq_enable(&desc->irq_data);
+	irq_enable(desc);
 
 	/*
 	 * We do not resend level type interrupts. Level type
 	 * interrupts are resent by hardware when they are still
 	 * active.
 	 */
-	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
-		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
+	if (desc->status & IRQ_LEVEL)
+		return;
+	if ((desc->status & (IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
+		desc->status = (desc->status & ~IRQ_PENDING) | IRQ_REPLAY;
 
 		if (!desc->irq_data.chip->irq_retrigger ||
 		    !desc->irq_data.chip->irq_retrigger(&desc->irq_data)) {
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -303,7 +303,7 @@ void note_interrupt(unsigned int irq, st
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
 		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
-		desc->irq_data.chip->irq_disable(&desc->irq_data);
+		irq_disable(desc);
 
 		mod_timer(&poll_spurious_irq_timer,
 			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);


