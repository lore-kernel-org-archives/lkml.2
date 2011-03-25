Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532Ab1CYLMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:12:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:38555 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934499Ab1CYLM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:12:28 -0400
Message-Id: <20110325111217.675983999@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 11:12:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 01/10] mfd: asic3: Cleanup irq handling
References: <20110325110939.701487744@linutronix.de>
Content-Disposition: inline; filename=mfd-asic3.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the open coded access to irq_desc and use the proper wrappers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/asic3.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

Index: linux-2.6-tip/drivers/mfd/asic3.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/asic3.c
+++ linux-2.6-tip/drivers/mfd/asic3.c
@@ -139,13 +139,12 @@ static void asic3_irq_flip_edge(struct a
 
 static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 {
+	struct asic3 *asic = irq_desc_get_handler_data(desc);
+	struct irq_data *data = irq_desc_get_irq_data(desc);
 	int iter, i;
 	unsigned long flags;
-	struct asic3 *asic;
-
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
-	asic = get_irq_data(irq);
+	data->chip->irq_ack(irq_data);
 
 	for (iter = 0 ; iter < MAX_ASIC_ISR_LOOPS; iter++) {
 		u32 status;
@@ -188,8 +187,7 @@ static void asic3_irq_demux(unsigned int
 					irqnr = asic->irq_base +
 						(ASIC3_GPIOS_PER_BANK * bank)
 						+ i;
-					desc = irq_to_desc(irqnr);
-					desc->handle_irq(irqnr, desc);
+					generic_handle_irq(irqnr);
 					if (asic->irq_bothedge[bank] & bit)
 						asic3_irq_flip_edge(asic, base,
 								    bit);
@@ -200,11 +198,8 @@ static void asic3_irq_demux(unsigned int
 		/* Handle remaining IRQs in the status register */
 		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
 			/* They start at bit 4 and go up */
-			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
-				desc = irq_to_desc(asic->irq_base + i);
-				desc->handle_irq(asic->irq_base + i,
-						 desc);
-			}
+			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4)))
+				generic_handle_irq(asic->irq_base + i);
 		}
 	}
 


