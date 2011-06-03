Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1FCBO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:14:57 -0400
Received: from smtp-out-212.synserver.de ([212.40.185.212]:1443 "HELO
	smtp-out-212.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753566Ab1FCBO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:14:56 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23129
From: Lars-Peter Clausen <lars@metafoo.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] MFD: jz4740-adc: Use generic irq chip
Date: Fri,  3 Jun 2011 03:14:26 +0200
Message-Id: <1307063666-10702-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic irq chip framework for implementing the irq chip for
the jz4740-adc driver.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mfd/Kconfig      |    3 +-
 drivers/mfd/jz4740-adc.c |   90 ++++++++++++++-------------------------------
 2 files changed, 30 insertions(+), 63 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 0f09c05..a204124 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -656,8 +656,9 @@ config MFD_JANZ_CMODIO
 	  CAN and GPIO controllers.
 
 config MFD_JZ4740_ADC
-	tristate "Support for the JZ4740 SoC ADC core"
+	bool "Support for the JZ4740 SoC ADC core"
 	select MFD_CORE
+	select GENERIC_IRQ_CHIP
 	depends on MACH_JZ4740
 	help
 	  Say yes here if you want support for the ADC unit in the JZ4740 SoC.
diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index a0bd0cf..21131c7 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -56,7 +56,7 @@ struct jz4740_adc {
 	void __iomem *base;
 
 	int irq;
-	int irq_base;
+	struct irq_chip_generic *gc;
 
 	struct clk *clk;
 	atomic_t clk_ref;
@@ -64,63 +64,17 @@ struct jz4740_adc {
 	spinlock_t lock;
 };
 
-static inline void jz4740_adc_irq_set_masked(struct jz4740_adc *adc, int irq,
-	bool masked)
-{
-	unsigned long flags;
-	uint8_t val;
-
-	irq -= adc->irq_base;
-
-	spin_lock_irqsave(&adc->lock, flags);
-
-	val = readb(adc->base + JZ_REG_ADC_CTRL);
-	if (masked)
-		val |= BIT(irq);
-	else
-		val &= ~BIT(irq);
-	writeb(val, adc->base + JZ_REG_ADC_CTRL);
-
-	spin_unlock_irqrestore(&adc->lock, flags);
-}
-
-static void jz4740_adc_irq_mask(struct irq_data *data)
-{
-	struct jz4740_adc *adc = irq_data_get_irq_chip_data(data);
-	jz4740_adc_irq_set_masked(adc, data->irq, true);
-}
-
-static void jz4740_adc_irq_unmask(struct irq_data *data)
-{
-	struct jz4740_adc *adc = irq_data_get_irq_chip_data(data);
-	jz4740_adc_irq_set_masked(adc, data->irq, false);
-}
-
-static void jz4740_adc_irq_ack(struct irq_data *data)
-{
-	struct jz4740_adc *adc = irq_data_get_irq_chip_data(data);
-	unsigned int irq = data->irq - adc->irq_base;
-	writeb(BIT(irq), adc->base + JZ_REG_ADC_STATUS);
-}
-
-static struct irq_chip jz4740_adc_irq_chip = {
-	.name = "jz4740-adc",
-	.irq_mask = jz4740_adc_irq_mask,
-	.irq_unmask = jz4740_adc_irq_unmask,
-	.irq_ack = jz4740_adc_irq_ack,
-};
-
 static void jz4740_adc_irq_demux(unsigned int irq, struct irq_desc *desc)
 {
-	struct jz4740_adc *adc = irq_desc_get_handler_data(desc);
+	struct irq_chip_generic *gc = irq_desc_get_handler_data(desc);
 	uint8_t status;
 	unsigned int i;
 
-	status = readb(adc->base + JZ_REG_ADC_STATUS);
+	status = readb(gc->reg_base + JZ_REG_ADC_STATUS);
 
 	for (i = 0; i < 5; ++i) {
 		if (status & BIT(i))
-			generic_handle_irq(adc->irq_base + i);
+			generic_handle_irq(gc->irq_base + i);
 	}
 }
 
@@ -249,10 +203,12 @@ const struct mfd_cell jz4740_adc_cells[] = {
 
 static int __devinit jz4740_adc_probe(struct platform_device *pdev)
 {
-	int ret;
+	struct irq_chip_generic *gc;
+	struct irq_chip_type *ct;
 	struct jz4740_adc *adc;
 	struct resource *mem_base;
-	int irq;
+	int ret;
+	int irq_base;
 
 	adc = kmalloc(sizeof(*adc), GFP_KERNEL);
 	if (!adc) {
@@ -267,9 +223,9 @@ static int __devinit jz4740_adc_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
-	adc->irq_base = platform_get_irq(pdev, 1);
-	if (adc->irq_base < 0) {
-		ret = adc->irq_base;
+	irq_base = platform_get_irq(pdev, 1);
+	if (irq_base < 0) {
+		ret = irq_base;
 		dev_err(&pdev->dev, "Failed to get irq base: %d\n", ret);
 		goto err_free;
 	}
@@ -309,20 +265,28 @@ static int __devinit jz4740_adc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, adc);
 
-	for (irq = adc->irq_base; irq < adc->irq_base + 5; ++irq) {
-		irq_set_chip_data(irq, adc);
-		irq_set_chip_and_handler(irq, &jz4740_adc_irq_chip,
-					 handle_level_irq);
-	}
+	gc = irq_alloc_generic_chip("INTC", 1, irq_base, adc->base,
+		handle_level_irq);
+
+	ct = gc->chip_types;
+	ct->regs.mask = JZ_REG_ADC_CTRL;
+	ct->regs.ack = JZ_REG_ADC_STATUS;
+	ct->chip.irq_mask = irq_gc_mask_set_bit;
+	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
+	ct->chip.irq_ack = irq_gc_ack;
+
+	irq_setup_generic_chip(gc, IRQ_MSK(5), 0, 0, IRQ_NOPROBE | IRQ_LEVEL);
+
+	adc->gc = gc;
 
-	irq_set_handler_data(adc->irq, adc);
+	irq_set_handler_data(adc->irq, gc);
 	irq_set_chained_handler(adc->irq, jz4740_adc_irq_demux);
 
 	writeb(0x00, adc->base + JZ_REG_ADC_ENABLE);
 	writeb(0xff, adc->base + JZ_REG_ADC_CTRL);
 
 	ret = mfd_add_devices(&pdev->dev, 0, jz4740_adc_cells,
-		ARRAY_SIZE(jz4740_adc_cells), mem_base, adc->irq_base);
+		ARRAY_SIZE(jz4740_adc_cells), mem_base, irq_base);
 	if (ret < 0)
 		goto err_clk_put;
 
@@ -347,6 +311,8 @@ static int __devexit jz4740_adc_remove(struct platform_device *pdev)
 
 	mfd_remove_devices(&pdev->dev);
 
+	irq_remove_generic_chip(adc->gc, IRQ_MSK(5), IRQ_NOPROBE | IRQ_LEVEL, 0);
+	kfree(adc->gc);
 	irq_set_handler_data(adc->irq, NULL);
 	irq_set_chained_handler(adc->irq, NULL);
 
-- 
1.7.2.5

