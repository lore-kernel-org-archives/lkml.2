Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1BFVqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:46:24 -0500
Received: from www.tglx.de ([62.245.132.106]:45937 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab1BFVqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:46:01 -0500
Message-Id: <20110206214534.662442061@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:45:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 3/7] mn10300: Convert cpu irq_chips to new functions
References: <20110206214441.438777646@linutronix.de>
Content-Disposition: inline; filename=mn10300-convert-cpu-irq_chips.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/kernel/irq.c |   62 ++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

Index: linux-next/arch/mn10300/kernel/irq.c
===================================================================
--- linux-next.orig/arch/mn10300/kernel/irq.c
+++ linux-next/arch/mn10300/kernel/irq.c
@@ -37,8 +37,9 @@ atomic_t irq_err_count;
 /*
  * MN10300 interrupt controller operations
  */
-static void mn10300_cpupic_ack(unsigned int irq)
+static void mn10300_cpupic_ack(struct irq_chip *d)
 {
+	unsigned int irq = d->irq;
 	unsigned long flags;
 	u16 tmp;
 
@@ -61,13 +62,14 @@ static void __mask_and_set_icr(unsigned 
 	arch_local_irq_restore(flags);
 }
 
-static void mn10300_cpupic_mask(unsigned int irq)
+static void mn10300_cpupic_mask(struct irq_chip *d)
 {
-	__mask_and_set_icr(irq, GxICR_LEVEL, 0);
+	__mask_and_set_icr(d->irq, GxICR_LEVEL, 0);
 }
 
-static void mn10300_cpupic_mask_ack(unsigned int irq)
+static void mn10300_cpupic_mask_ack(struct irq_chip *d)
 {
+	unsigned int irq = d->irq;
 #ifdef CONFIG_SMP
 	unsigned long flags;
 	u16 tmp;
@@ -85,7 +87,7 @@ static void mn10300_cpupic_mask_ack(unsi
 		tmp2 = GxICR(irq);
 
 		irq_affinity_online[irq] =
-			any_online_cpu(*irq_desc[irq].affinity);
+			any_online_cpu(*d->affinity);
 		CROSS_GxICR(irq, irq_affinity_online[irq]) =
 			(tmp & (GxICR_LEVEL | GxICR_ENABLE)) | GxICR_DETECT;
 		tmp = CROSS_GxICR(irq, irq_affinity_online[irq]);
@@ -97,13 +99,14 @@ static void mn10300_cpupic_mask_ack(unsi
 #endif /* CONFIG_SMP */
 }
 
-static void mn10300_cpupic_unmask(unsigned int irq)
+static void mn10300_cpupic_unmask(struct irq_chip *d)
 {
-	__mask_and_set_icr(irq, GxICR_LEVEL, GxICR_ENABLE);
+	__mask_and_set_icr(d->irq, GxICR_LEVEL, GxICR_ENABLE);
 }
 
-static void mn10300_cpupic_unmask_clear(unsigned int irq)
+static void mn10300_cpupic_unmask_clear(struct irq_chip *d)
 {
+	unsigned int irq = d->irq;
 	/* the MN10300 PIC latches its interrupt request bit, even after the
 	 * device has ceased to assert its interrupt line and the interrupt
 	 * channel has been disabled in the PIC, so for level-triggered
@@ -121,7 +124,7 @@ static void mn10300_cpupic_unmask_clear(
 	} else {
 		tmp = GxICR(irq);
 
-		irq_affinity_online[irq] = any_online_cpu(*irq_desc[irq].affinity);
+		irq_affinity_online[irq] = any_online_cpu(*d->affinity);
 		CROSS_GxICR(irq, irq_affinity_online[irq]) = (tmp & GxICR_LEVEL) | GxICR_ENABLE | GxICR_DETECT;
 		tmp = CROSS_GxICR(irq, irq_affinity_online[irq]);
 	}
@@ -134,7 +137,8 @@ static void mn10300_cpupic_unmask_clear(
 
 #ifdef CONFIG_SMP
 static int
-mn10300_cpupic_setaffinity(unsigned int irq, const struct cpumask *mask)
+mn10300_cpupic_setaffinity(struct irq_chip *d, const struct cpumask *mask,
+			   bool force)
 {
 	unsigned long flags;
 	int err;
@@ -142,7 +146,7 @@ mn10300_cpupic_setaffinity(unsigned int 
 	flags = arch_local_cli_save();
 
 	/* check irq no */
-	switch (irq) {
+	switch (d->irq) {
 	case TMJCIRQ:
 	case RESCHEDULE_IPI:
 	case CALL_FUNC_SINGLE_IPI:
@@ -181,7 +185,7 @@ mn10300_cpupic_setaffinity(unsigned int 
 		break;
 
 	default:
-		set_bit(irq, irq_affinity_request);
+		set_bit(d->irq, irq_affinity_request);
 		err = 0;
 		break;
 	}
@@ -202,15 +206,15 @@ mn10300_cpupic_setaffinity(unsigned int 
  * mask_ack() is provided), and mask_ack() just masks.
  */
 static struct irq_chip mn10300_cpu_pic_level = {
-	.name		= "cpu_l",
-	.disable	= mn10300_cpupic_mask,
-	.enable		= mn10300_cpupic_unmask_clear,
-	.ack		= NULL,
-	.mask		= mn10300_cpupic_mask,
-	.mask_ack	= mn10300_cpupic_mask,
-	.unmask		= mn10300_cpupic_unmask_clear,
+	.name			= "cpu_l",
+	.irq_disable		= mn10300_cpupic_mask,
+	.irq_enable		= mn10300_cpupic_unmask_clear,
+	.irq_ack		= NULL,
+	.irq_mask		= mn10300_cpupic_mask,
+	.irq_mask_ack		= mn10300_cpupic_mask,
+	.irq_unmask		= mn10300_cpupic_unmask_clear,
 #ifdef CONFIG_SMP
-	.set_affinity	= mn10300_cpupic_setaffinity,
+	.irq_set_affinity	= mn10300_cpupic_setaffinity,
 #endif
 };
 
@@ -220,15 +224,15 @@ static struct irq_chip mn10300_cpu_pic_l
  * We use the latch clearing function of the PIC as the 'ACK' function.
  */
 static struct irq_chip mn10300_cpu_pic_edge = {
-	.name		= "cpu_e",
-	.disable	= mn10300_cpupic_mask,
-	.enable		= mn10300_cpupic_unmask,
-	.ack		= mn10300_cpupic_ack,
-	.mask		= mn10300_cpupic_mask,
-	.mask_ack	= mn10300_cpupic_mask_ack,
-	.unmask		= mn10300_cpupic_unmask,
+	.name			= "cpu_e",
+	.irq_disable		= mn10300_cpupic_mask,
+	.irq_enable		= mn10300_cpupic_unmask,
+	.irq_ack		= mn10300_cpupic_ack,
+	.irq_mask		= mn10300_cpupic_mask,
+	.irq_mask_ack		= mn10300_cpupic_mask_ack,
+	.irq_unmask		= mn10300_cpupic_unmask,
 #ifdef CONFIG_SMP
-	.set_affinity	= mn10300_cpupic_setaffinity,
+	.irq_set_affinity	= mn10300_cpupic_setaffinity,
 #endif
 };
 
@@ -271,7 +275,7 @@ void __init init_IRQ(void)
 	int irq;
 
 	for (irq = 0; irq < NR_IRQS; irq++)
-		if (irq_desc[irq].chip == &no_irq_chip)
+		if (get_irq_chip(irq) == &no_irq_chip)
 			/* due to the PIC latching interrupt requests, even
 			 * when the IRQ is disabled, IRQ_PENDING is superfluous
 			 * and we can use handle_level_irq() for edge-triggered


