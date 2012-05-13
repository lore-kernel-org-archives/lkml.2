Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2EMOyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 10:54:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55672 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573Ab2EMOyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 10:54:53 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Convert regmap_irq to use irq_domain
Date: Sun, 13 May 2012 15:54:49 +0100
Message-Id: <1336920889-22516-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets us up to date with the recommended current kernel infrastructure
and should transparently give us device tree interrupt bindings for any
devices using the framework. If an explicit IRQ mapping is passed in then
a legacy interrupt range is created, otherwise a simple linear mapping is
used.

A function regmap_irq_get_virq() is provided to allow drivers to map
individual IRQs which should be used in preference to the existing
regmap_irq_chip_get_base() since it avoids the need to create the mappings
for the full range of interrupts.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |  110 ++++++++++++++++++++++++++------------
 drivers/mfd/Kconfig              |    3 ++
 include/linux/regmap.h           |    1 +
 3 files changed, 80 insertions(+), 34 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index f9724af..e73998d 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -15,6 +15,7 @@
 #include <linux/regmap.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/slab.h>
 
 #include "internal.h"
@@ -25,7 +26,7 @@ struct regmap_irq_chip_data {
 	struct regmap *map;
 	struct regmap_irq_chip *chip;
 
-	int irq_base;
+	struct irq_domain *domain;
 
 	void *status_reg_buf;
 	unsigned int *status_buf;
@@ -37,7 +38,7 @@ static inline const
 struct regmap_irq *irq_to_regmap_irq(struct regmap_irq_chip_data *data,
 				     int irq)
 {
-	return &data->chip->irqs[irq - data->irq_base];
+	return &data->chip->irqs[irq];
 }
 
 static void regmap_irq_lock(struct irq_data *data)
@@ -74,7 +75,7 @@ static void regmap_irq_enable(struct irq_data *data)
 {
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
 	struct regmap *map = d->map;
-	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->irq);
+	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
 
 	d->mask_buf[irq_data->reg_offset / map->reg_stride] &= ~irq_data->mask;
 }
@@ -83,7 +84,7 @@ static void regmap_irq_disable(struct irq_data *data)
 {
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
 	struct regmap *map = d->map;
-	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->irq);
+	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
 
 	d->mask_buf[irq_data->reg_offset / map->reg_stride] |= irq_data->mask;
 }
@@ -153,7 +154,7 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 	for (i = 0; i < chip->num_irqs; i++) {
 		if (data->status_buf[chip->irqs[i].reg_offset /
 				     map->reg_stride] & chip->irqs[i].mask) {
-			handle_nested_irq(data->irq_base + i);
+			handle_nested_irq(irq_find_mapping(data->domain, i));
 			handled = true;
 		}
 	}
@@ -164,6 +165,31 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 		return IRQ_NONE;
 }
 
+static int regmap_irq_map(struct irq_domain *h, unsigned int virq,
+			  irq_hw_number_t hw)
+{
+	struct regmap_irq_chip_data *data = h->host_data;
+
+	irq_set_chip_data(virq, data);
+	irq_set_chip_and_handler(virq, &regmap_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+
+	/* ARM needs us to explicitly flag the IRQ as valid
+	 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static struct irq_domain_ops regmap_domain_ops = {
+	.map	= regmap_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
 /**
  * regmap_add_irq_chip(): Use standard regmap IRQ controller handling
  *
@@ -184,7 +210,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 			struct regmap_irq_chip_data **data)
 {
 	struct regmap_irq_chip_data *d;
-	int cur_irq, i;
+	int i;
 	int ret = -ENOMEM;
 
 	for (i = 0; i < chip->num_irqs; i++) {
@@ -195,15 +221,13 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 			return -EINVAL;
 	}
 
-	/* Ask for a dynamic range if none is specified */
-	if (!irq_base)
-		irq_base = -1;
-
-	irq_base = irq_alloc_descs(irq_base, 0, chip->num_irqs, 0);
-	if (irq_base < 0) {
-		dev_warn(map->dev, "Failed to allocate IRQs: %d\n",
-			 irq_base);
-		return irq_base;
+	if (irq_base) {
+		irq_base = irq_alloc_descs(irq_base, 0, chip->num_irqs, 0);
+		if (irq_base < 0) {
+			dev_warn(map->dev, "Failed to allocate IRQs: %d\n",
+				 irq_base);
+			return irq_base;
+		}
 	}
 
 	d = kzalloc(sizeof(*d), GFP_KERNEL);
@@ -234,7 +258,6 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 
 	d->map = map;
 	d->chip = chip;
-	d->irq_base = irq_base;
 	mutex_init(&d->lock);
 
 	for (i = 0; i < chip->num_irqs; i++)
@@ -253,33 +276,31 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 		}
 	}
 
-	/* Register them with genirq */
-	for (cur_irq = irq_base;
-	     cur_irq < chip->num_irqs + irq_base;
-	     cur_irq++) {
-		irq_set_chip_data(cur_irq, d);
-		irq_set_chip_and_handler(cur_irq, &regmap_irq_chip,
-					 handle_edge_irq);
-		irq_set_nested_thread(cur_irq, 1);
-
-		/* ARM needs us to explicitly flag the IRQ as valid
-		 * and will set them noprobe when we do so. */
-#ifdef CONFIG_ARM
-		set_irq_flags(cur_irq, IRQF_VALID);
-#else
-		irq_set_noprobe(cur_irq);
-#endif
+	if (irq_base)
+		d->domain = irq_domain_add_legacy(map->dev->of_node,
+						  chip->num_irqs, irq_base, 0,
+						  &regmap_domain_ops, d);
+	else
+		d->domain = irq_domain_add_linear(map->dev->of_node,
+						  chip->num_irqs,
+						  &regmap_domain_ops, d);
+	if (!d->domain) {
+		dev_err(map->dev, "Failed to create IRQ domain\n");
+		ret = -ENOMEM;
+		goto err_alloc;
 	}
 
 	ret = request_threaded_irq(irq, NULL, regmap_irq_thread, irq_flags,
 				   chip->name, d);
 	if (ret != 0) {
 		dev_err(map->dev, "Failed to request IRQ %d: %d\n", irq, ret);
-		goto err_alloc;
+		goto err_domain;
 	}
 
 	return 0;
 
+err_domain:
+	/* Should really dispose of the domain but... */
 err_alloc:
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
@@ -302,6 +323,7 @@ void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *d)
 		return;
 
 	free_irq(irq, d);
+	/* We should unmap the domain but... */
 	kfree(d->mask_buf_def);
 	kfree(d->mask_buf);
 	kfree(d->status_reg_buf);
@@ -319,6 +341,26 @@ EXPORT_SYMBOL_GPL(regmap_del_irq_chip);
  */
 int regmap_irq_chip_get_base(struct regmap_irq_chip_data *data)
 {
-	return data->irq_base;
+	int i;
+
+	/* Make sure all the IRQs are mapped, users will be assuming this */
+	for (i = 1; i < data->chip->num_irqs; i++)
+		irq_create_mapping(data->domain, i);
+
+	return irq_create_mapping(data->domain, 0);
 }
 EXPORT_SYMBOL_GPL(regmap_irq_chip_get_base);
+
+/**
+ * regmap_irq_get_virq(): Map an interrupt on a chip to a virtual IRQ
+ *
+ * Useful for drivers to request their own IRQs.
+ *
+ * @data: regmap_irq controller to operate on.
+ * @irq: index of the interrupt requested in the chip IRQs
+ */
+int regmap_irq_get_virq(struct regmap_irq_chip_data *data, int irq)
+{
+	return irq_create_mapping(data->domain, irq);
+}
+EXPORT_SYMBOL_GPL(regmap_irq_get_virq);
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index c618e3a..9846424 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -389,6 +389,7 @@ config PMIC_DA9052
 
 config MFD_DA9052_SPI
 	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with SPI"
+	select IRQ_DOMAIN
 	select REGMAP_SPI
 	select REGMAP_IRQ
 	select PMIC_DA9052
@@ -401,6 +402,7 @@ config MFD_DA9052_SPI
 
 config MFD_DA9052_I2C
 	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with I2C"
+	select IRQ_DOMAIN
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	select PMIC_DA9052
@@ -571,6 +573,7 @@ config MFD_WM8994
 	bool "Support Wolfson Microelectronics WM8994"
 	select MFD_CORE
 	select REGMAP_I2C
+	select IRQ_DOMAIN
 	select REGMAP_IRQ
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 9dbc9a1..7208668 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -245,6 +245,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 			struct regmap_irq_chip_data **data);
 void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *data);
 int regmap_irq_chip_get_base(struct regmap_irq_chip_data *data);
+int regmap_irq_get_virq(struct regmap_irq_chip_data *data, int irq);
 
 #else
 
-- 
1.7.10

