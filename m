Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583Ab1CYLMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:12:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:38600 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934571Ab1CYLMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:12:37 -0400
Message-Id: <20110325111218.536585142@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 Mar 2011 11:12:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 10/10] mfd: Fold irq_set_chip/irq_set_handler
References: <20110325110939.701487744@linutronix.de>
Content-Disposition: inline; filename=mfd-fold.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the combined irq_set_chip_and_handler() function
instead. Converted with coccinelle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/asic3.c      |    3 +--
 drivers/mfd/htc-egpio.c  |    7 +++----
 drivers/mfd/htc-i2cpld.c |    4 ++--
 drivers/mfd/t7l66xb.c    |    3 +--
 drivers/mfd/tc6393xb.c   |    3 +--
 5 files changed, 8 insertions(+), 12 deletions(-)

Index: linux-2.6-tip/drivers/mfd/asic3.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/asic3.c
+++ linux-2.6-tip/drivers/mfd/asic3.c
@@ -416,8 +416,7 @@ static void asic3_irq_remove(struct plat
 
 	for (irq = irq_base; irq < irq_base + ASIC3_NR_IRQS; irq++) {
 		set_irq_flags(irq, 0);
-		irq_set_handler(irq, NULL);
-		irq_set_chip(irq, NULL);
+		irq_set_chip_and_handler(irq, NULL, NULL);
 		irq_set_chip_data(irq, NULL);
 	}
 	irq_set_chained_handler(asic->irq_nr, NULL);
Index: linux-2.6-tip/drivers/mfd/htc-egpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/htc-egpio.c
+++ linux-2.6-tip/drivers/mfd/htc-egpio.c
@@ -344,9 +344,9 @@ static int __init egpio_probe(struct pla
 			ei->ack_write = 0;
 		irq_end = ei->irq_start + ei->nirqs;
 		for (irq = ei->irq_start; irq < irq_end; irq++) {
-			irq_set_chip(irq, &egpio_muxed_chip);
+			irq_set_chip_and_handler(irq, &egpio_muxed_chip,
+						 handle_simple_irq);
 			irq_set_chip_data(irq, ei);
-			irq_set_handler(irq, handle_simple_irq);
 			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 		}
 		irq_set_irq_type(ei->chained_irq, IRQ_TYPE_EDGE_RISING);
@@ -373,8 +373,7 @@ static int __exit egpio_remove(struct pl
 	if (ei->chained_irq) {
 		irq_end = ei->irq_start + ei->nirqs;
 		for (irq = ei->irq_start; irq < irq_end; irq++) {
-			irq_set_chip(irq, NULL);
-			irq_set_handler(irq, NULL);
+			irq_set_chip_and_handler(irq, NULL, NULL);
 			set_irq_flags(irq, 0);
 		}
 		irq_set_chained_handler(ei->chained_irq, NULL);
Index: linux-2.6-tip/drivers/mfd/htc-i2cpld.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/htc-i2cpld.c
+++ linux-2.6-tip/drivers/mfd/htc-i2cpld.c
@@ -348,9 +348,9 @@ static int __devinit htcpld_setup_chip_i
 	/* Setup irq handlers */
 	irq_end = chip->irq_start + chip->nirqs;
 	for (irq = chip->irq_start; irq < irq_end; irq++) {
-		irq_set_chip(irq, &htcpld_muxed_chip);
+		irq_set_chip_and_handler(irq, &htcpld_muxed_chip,
+					 handle_simple_irq);
 		irq_set_chip_data(irq, chip);
-		irq_set_handler(irq, handle_simple_irq);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 #else
Index: linux-2.6-tip/drivers/mfd/t7l66xb.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/t7l66xb.c
+++ linux-2.6-tip/drivers/mfd/t7l66xb.c
@@ -243,9 +243,8 @@ static void t7l66xb_attach_irq(struct pl
 	irq_base = t7l66xb->irq_base;
 
 	for (irq = irq_base; irq < irq_base + T7L66XB_NR_IRQS; irq++) {
-		irq_set_chip(irq, &t7l66xb_chip);
+		irq_set_chip_and_handler(irq, &t7l66xb_chip, handle_level_irq);
 		irq_set_chip_data(irq, t7l66xb);
-		irq_set_handler(irq, handle_level_irq);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 #endif
Index: linux-2.6-tip/drivers/mfd/tc6393xb.c
===================================================================
--- linux-2.6-tip.orig/drivers/mfd/tc6393xb.c
+++ linux-2.6-tip/drivers/mfd/tc6393xb.c
@@ -572,9 +572,8 @@ static void tc6393xb_attach_irq(struct p
 	irq_base = tc6393xb->irq_base;
 
 	for (irq = irq_base; irq < irq_base + TC6393XB_NR_IRQS; irq++) {
-		irq_set_chip(irq, &tc6393xb_chip);
+		irq_set_chip_and_handler(irq, &tc6393xb_chip, handle_edge_irq);
 		irq_set_chip_data(irq, tc6393xb);
-		irq_set_handler(irq, handle_edge_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 


