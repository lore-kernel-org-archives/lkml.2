Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1CYLVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:21:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:44743 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750820Ab1CYLVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:21:43 -0400
Date: Fri, 25 Mar 2011 12:21:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] dma: ipu: Convert interupt code
Message-ID: <alpine.LFD.2.00.1103251220000.31464@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new irq chip functions and cleanup the name space.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/dma/ipu/ipu_irq.c |   58 +++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

Index: linux-2.6-tip/drivers/dma/ipu/ipu_irq.c
===================================================================
--- linux-2.6-tip.orig/drivers/dma/ipu/ipu_irq.c
+++ linux-2.6-tip/drivers/dma/ipu/ipu_irq.c
@@ -94,9 +94,9 @@ static struct ipu_irq_map *src2map(unsig
 	return NULL;
 }
 
-static void ipu_irq_unmask(unsigned int irq)
+static void ipu_irq_unmask(struct irq_data *d)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = irq_data_get_chip_data(d);
 	struct ipu_irq_bank *bank;
 	uint32_t reg;
 	unsigned long lock_flags;
@@ -106,7 +106,7 @@ static void ipu_irq_unmask(unsigned int 
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
 
@@ -117,9 +117,9 @@ static void ipu_irq_unmask(unsigned int 
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_mask(unsigned int irq)
+static void ipu_irq_mask(struct irq_data *d)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = irq_data_get_chip_data(d);
 	struct ipu_irq_bank *bank;
 	uint32_t reg;
 	unsigned long lock_flags;
@@ -129,7 +129,7 @@ static void ipu_irq_mask(unsigned int ir
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
 
@@ -140,9 +140,9 @@ static void ipu_irq_mask(unsigned int ir
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_ack(unsigned int irq)
+static void ipu_irq_ack(struct irq_data *d)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = irq_data_get_chip_data(d);
 	struct ipu_irq_bank *bank;
 	unsigned long lock_flags;
 
@@ -151,7 +151,7 @@ static void ipu_irq_ack(unsigned int irq
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, d->irq);
 		return;
 	}
 
@@ -167,7 +167,7 @@ static void ipu_irq_ack(unsigned int irq
  */
 bool ipu_irq_status(unsigned int irq)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = irq_get_chip_data(irq);
 	struct ipu_irq_bank *bank;
 	unsigned long lock_flags;
 	bool ret;
@@ -269,7 +269,7 @@ int ipu_irq_unmap(unsigned int source)
 /* Chained IRQ handler for IPU error interrupt */
 static void ipu_irq_err(unsigned int irq, struct irq_desc *desc)
 {
-	struct ipu *ipu = get_irq_data(irq);
+	struct ipu *ipu = irq_get_handler_data(irq);
 	u32 status;
 	int i, line;
 
@@ -310,7 +310,7 @@ static void ipu_irq_err(unsigned int irq
 /* Chained IRQ handler for IPU function interrupt */
 static void ipu_irq_fn(unsigned int irq, struct irq_desc *desc)
 {
-	struct ipu *ipu = get_irq_data(irq);
+	struct ipu *ipu = irq_desc_get_handler_data(desc);
 	u32 status;
 	int i, line;
 
@@ -345,10 +345,10 @@ static void ipu_irq_fn(unsigned int irq,
 }
 
 static struct irq_chip ipu_irq_chip = {
-	.name	= "ipu_irq",
-	.ack	= ipu_irq_ack,
-	.mask	= ipu_irq_mask,
-	.unmask	= ipu_irq_unmask,
+	.name		= "ipu_irq",
+	.irq_ack	= ipu_irq_ack,
+	.irq_mask	= ipu_irq_mask,
+	.irq_unmask	= ipu_irq_unmask,
 };
 
 /* Install the IRQ handler */
@@ -366,26 +366,26 @@ int __init ipu_irq_attach_irq(struct ipu
 		int ret;
 
 		irq = irq_base + i;
-		ret = set_irq_chip(irq, &ipu_irq_chip);
+		ret = irq_set_chip(irq, &ipu_irq_chip);
 		if (ret < 0)
 			return ret;
-		ret = set_irq_chip_data(irq, irq_map + i);
+		ret = irq_set_chip_data(irq, irq_map + i);
 		if (ret < 0)
 			return ret;
 		irq_map[i].ipu = ipu;
 		irq_map[i].irq = irq;
 		irq_map[i].source = -EINVAL;
-		set_irq_handler(irq, handle_level_irq);
+		irq_set_handler(irq, handle_level_irq);
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 #endif
 	}
 
-	set_irq_data(ipu->irq_fn, ipu);
-	set_irq_chained_handler(ipu->irq_fn, ipu_irq_fn);
+	irq_set_handler_data(ipu->irq_fn, ipu);
+	irq_set_chained_handler(ipu->irq_fn, ipu_irq_fn);
 
-	set_irq_data(ipu->irq_err, ipu);
-	set_irq_chained_handler(ipu->irq_err, ipu_irq_err);
+	irq_set_handler_data(ipu->irq_err, ipu);
+	irq_set_chained_handler(ipu->irq_err, ipu_irq_err);
 
 	return 0;
 }
@@ -397,17 +397,17 @@ void ipu_irq_detach_irq(struct ipu *ipu,
 
 	irq_base = pdata->irq_base;
 
-	set_irq_chained_handler(ipu->irq_fn, NULL);
-	set_irq_data(ipu->irq_fn, NULL);
+	irq_set_chained_handler(ipu->irq_fn, NULL);
+	irq_set_handler_data(ipu->irq_fn, NULL);
 
-	set_irq_chained_handler(ipu->irq_err, NULL);
-	set_irq_data(ipu->irq_err, NULL);
+	irq_set_chained_handler(ipu->irq_err, NULL);
+	irq_set_handler_data(ipu->irq_err, NULL);
 
 	for (irq = irq_base; irq < irq_base + CONFIG_MX3_IPU_IRQS; irq++) {
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
-		set_irq_chip(irq, NULL);
-		set_irq_chip_data(irq, NULL);
+		irq_set_chip(irq, NULL);
+		irq_set_chip_data(irq, NULL);
 	}
 }
