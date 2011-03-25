Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934599Ab1CYLOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:14:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:38575 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934534Ab1CYLMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:12:30 -0400
Message-Id: <20110325111218.061208160@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 11:12:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 05/10] mfd: htc-i2cpld: Cleanup interrupt handling
References: <20110325110939.701487744@linutronix.de>
Content-Disposition: inline; filename=mfd-htc-i2.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the pointless irq_desc check in set_type. This function is
called with that irq descriptor locked. Also remove the write back of
the flow type as the core code does this already when the return value
is 0.

Also store the flow type in the chip data structure, so there is no
need to fiddle in the irq descriptor.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/htc-i2cpld.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

Index: linux-2.6-tip/drivers/mfd/htc-i2cpld.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/htc-i2cpld.c
+++ linux-2.6-tip/drivers/mfd/htc-i2cpld.c
@@ -58,6 +58,7 @@ struct htcpld_chip {
 	uint                    irq_start;
 	int                     nirqs;
 
+	unsigned int		flow_type;
 	/*
 	 * Work structure to allow for setting values outside of any
 	 * possible interrupt context
@@ -97,12 +98,7 @@ static void htcpld_unmask(struct irq_dat
 
 static int htcpld_set_type(struct irq_data *data, unsigned int flags)
 {
-	struct irq_desc *d = irq_to_desc(data->irq);
-
-	if (!d) {
-		pr_err("HTCPLD invalid IRQ: %d\n", data->irq);
-		return -EINVAL;
-	}
+	struct htcpld_chip *chip = irq_data_get_irq_chip_data(data);
 
 	if (flags & ~IRQ_TYPE_SENSE_MASK)
 		return -EINVAL;
@@ -111,9 +107,7 @@ static int htcpld_set_type(struct irq_da
 	if (flags & (IRQ_TYPE_LEVEL_LOW|IRQ_TYPE_LEVEL_HIGH))
 		return -EINVAL;
 
-	d->status &= ~IRQ_TYPE_SENSE_MASK;
-	d->status |= flags;
-
+	chip->flow_type = flags;
 	return 0;
 }
 
@@ -135,7 +129,6 @@ static irqreturn_t htcpld_handler(int ir
 	unsigned int i;
 	unsigned long flags;
 	int irqpin;
-	struct irq_desc *desc;
 
 	if (!htcpld) {
 		pr_debug("htcpld is null in ISR\n");
@@ -195,23 +188,19 @@ static irqreturn_t htcpld_handler(int ir
 		 * associated interrupts.
 		 */
 		for (irqpin = 0; irqpin < chip->nirqs; irqpin++) {
-			unsigned oldb, newb;
-			int flags;
+			unsigned oldb, newb, type = chip->flow_type;
 
 			irq = chip->irq_start + irqpin;
-			desc = irq_to_desc(irq);
-			flags = desc->status;
 
 			/* Run the IRQ handler, but only if the bit value
 			 * changed, and the proper flags are set */
 			oldb = (old_val >> irqpin) & 1;
 			newb = (uval >> irqpin) & 1;
 
-			if ((!oldb && newb && (flags & IRQ_TYPE_EDGE_RISING)) ||
-			    (oldb && !newb &&
-			     (flags & IRQ_TYPE_EDGE_FALLING))) {
+			if ((!oldb && newb && (type & IRQ_TYPE_EDGE_RISING)) ||
+			    (oldb && !newb && (type & IRQ_TYPE_EDGE_FALLING))) {
 				pr_debug("fire IRQ %d\n", irqpin);
-				desc->handle_irq(irq, desc);
+				generic_handle_irq(irq);
 			}
 		}
 	}


