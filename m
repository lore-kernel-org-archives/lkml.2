Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab2C1VCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:02:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56715 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab2C1VCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:02:32 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Torben Hohn <torbenh@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] gpio/sodaville: Convert sodaville driver to new irqdomain API
Date: Wed, 28 Mar 2012 15:02:26 -0600
Message-Id: <1332968546-12901-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irqdomain api changed significantly in v3.4 which caused a build
failure for this driver.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Hans J. Koch <hjk@linutronix.de>
Cc: Torben Hohn <torbenh@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

Hi guys,

This patch fixes the build failure for the sodaville driver, but I've got
no way to test it.  Please take a look before I merge it.

g.

 drivers/gpio/Kconfig          |    2 +-
 drivers/gpio/gpio-sodaville.c |   23 ++++++++++-------------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index dfea1d8..dbb1909 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -419,7 +419,7 @@ config GPIO_ML_IOH
 
 config GPIO_SODAVILLE
 	bool "Intel Sodaville GPIO support"
-	depends on X86 && PCI && OF && BROKEN
+	depends on X86 && PCI && OF
 	select GPIO_GENERIC
 	select GENERIC_IRQ_CHIP
 	help
diff --git a/drivers/gpio/gpio-sodaville.c b/drivers/gpio/gpio-sodaville.c
index 9ba15d3..031e5d2 100644
--- a/drivers/gpio/gpio-sodaville.c
+++ b/drivers/gpio/gpio-sodaville.c
@@ -41,7 +41,7 @@
 struct sdv_gpio_chip_data {
 	int irq_base;
 	void __iomem *gpio_pub_base;
-	struct irq_domain id;
+	struct irq_domain *id;
 	struct irq_chip_generic *gc;
 	struct bgpio_chip bgpio;
 };
@@ -51,10 +51,9 @@ static int sdv_gpio_pub_set_type(struct irq_data *d, unsigned int type)
 	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
 	struct sdv_gpio_chip_data *sd = gc->private;
 	void __iomem *type_reg;
-	u32 irq_offs = d->irq - sd->irq_base;
 	u32 reg;
 
-	if (irq_offs < 8)
+	if (d->hwirq < 8)
 		type_reg = sd->gpio_pub_base + GPIT1R0;
 	else
 		type_reg = sd->gpio_pub_base + GPIT1R1;
@@ -63,11 +62,11 @@ static int sdv_gpio_pub_set_type(struct irq_data *d, unsigned int type)
 
 	switch (type) {
 	case IRQ_TYPE_LEVEL_HIGH:
-		reg &= ~BIT(4 * (irq_offs % 8));
+		reg &= ~BIT(4 * (d->hwirq % 8));
 		break;
 
 	case IRQ_TYPE_LEVEL_LOW:
-		reg |= BIT(4 * (irq_offs % 8));
+		reg |= BIT(4 * (d->hwirq % 8));
 		break;
 
 	default:
@@ -91,7 +90,7 @@ static irqreturn_t sdv_gpio_pub_irq_handler(int irq, void *data)
 		u32 irq_bit = __fls(irq_stat);
 
 		irq_stat &= ~BIT(irq_bit);
-		generic_handle_irq(sd->irq_base + irq_bit);
+		generic_handle_irq(irq_find_mapping(sd->id, irq_bit));
 	}
 
 	return IRQ_HANDLED;
@@ -127,7 +126,7 @@ static int sdv_xlate(struct irq_domain *h, struct device_node *node,
 }
 
 static struct irq_domain_ops irq_domain_sdv_ops = {
-	.dt_translate	= sdv_xlate,
+	.xlate = sdv_xlate,
 };
 
 static __devinit int sdv_register_irqsupport(struct sdv_gpio_chip_data *sd,
@@ -149,10 +148,6 @@ static __devinit int sdv_register_irqsupport(struct sdv_gpio_chip_data *sd,
 	if (ret)
 		goto out_free_desc;
 
-	sd->id.irq_base = sd->irq_base;
-	sd->id.of_node = of_node_get(pdev->dev.of_node);
-	sd->id.ops = &irq_domain_sdv_ops;
-
 	/*
 	 * This gpio irq controller latches level irqs. Testing shows that if
 	 * we unmask & ACK the IRQ before the source of the interrupt is gone
@@ -179,7 +174,10 @@ static __devinit int sdv_register_irqsupport(struct sdv_gpio_chip_data *sd,
 			IRQ_GC_INIT_MASK_CACHE, IRQ_NOREQUEST,
 			IRQ_LEVEL | IRQ_NOPROBE);
 
-	irq_domain_add(&sd->id);
+	sd->id = irq_domain_add_legacy(pdev->dev.of_node, SDV_NUM_PUB_GPIOS,
+				sd->irq_base, 0, &irq_domain_sdv_ops, sd);
+	if (!sd->id)
+		goto out_free_irq;
 	return 0;
 out_free_irq:
 	free_irq(pdev->irq, sd);
@@ -260,7 +258,6 @@ static void sdv_gpio_remove(struct pci_dev *pdev)
 {
 	struct sdv_gpio_chip_data *sd = pci_get_drvdata(pdev);
 
-	irq_domain_del(&sd->id);
 	free_irq(pdev->irq, sd);
 	irq_free_descs(sd->irq_base, SDV_NUM_PUB_GPIOS);
 
-- 
1.7.9.1

