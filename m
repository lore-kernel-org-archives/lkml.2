Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab2KMNvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:51:51 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18494 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab2KMNvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:51:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Nov 2012 05:51:47 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <broonie@opensource.wolfsonmicro.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND 1/3] mfd: Convert tps6586x to irq_domain
Date: Tue, 13 Nov 2012 19:18:05 +0530
Message-ID: <1352814487-25886-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352814487-25886-1-git-send-email-ldewangan@nvidia.com>
References: <1352814487-25886-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate the irq base if it base is not porvided i.e.
in case of device tree invocation of this driver.
Convert the tps6586x driver to irq domain, using a
legacy IRQ mapping if an irq_base is specified in
platform data or dynamically allocated and otherwise
using a linear mapping.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Reposting in case of patch missed.
Also added Reviewed by Mark as he already reviewed the patches.

 drivers/mfd/tps6586x.c       |   91 ++++++++++++++++++++++++++++++-----------
 include/linux/mfd/tps6586x.h |    1 +
 2 files changed, 67 insertions(+), 25 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 4674643..2cdf1e6 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -17,12 +17,14 @@
 
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
+#include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/machine.h>
@@ -116,6 +118,7 @@ struct tps6586x {
 	int			irq_base;
 	u32			irq_en;
 	u8			mask_reg[5];
+	struct irq_domain	*irq_domain;
 };
 
 static inline struct tps6586x *dev_to_tps6586x(struct device *dev)
@@ -184,6 +187,14 @@ int tps6586x_update(struct device *dev, int reg, uint8_t val, uint8_t mask)
 }
 EXPORT_SYMBOL_GPL(tps6586x_update);
 
+int tps6586x_irq_get_virq(struct device *dev, int irq)
+{
+	struct tps6586x *tps6586x = dev_to_tps6586x(dev);
+
+	return irq_create_mapping(tps6586x->irq_domain, irq);
+}
+EXPORT_SYMBOL_GPL(tps6586x_irq_get_virq);
+
 static int __remove_subdev(struct device *dev, void *unused)
 {
 	platform_device_unregister(to_platform_device(dev));
@@ -205,7 +216,7 @@ static void tps6586x_irq_lock(struct irq_data *data)
 static void tps6586x_irq_enable(struct irq_data *irq_data)
 {
 	struct tps6586x *tps6586x = irq_data_get_irq_chip_data(irq_data);
-	unsigned int __irq = irq_data->irq - tps6586x->irq_base;
+	unsigned int __irq = irq_data->hwirq;
 	const struct tps6586x_irq_data *data = &tps6586x_irqs[__irq];
 
 	tps6586x->mask_reg[data->mask_reg] &= ~data->mask_mask;
@@ -216,7 +227,7 @@ static void tps6586x_irq_disable(struct irq_data *irq_data)
 {
 	struct tps6586x *tps6586x = irq_data_get_irq_chip_data(irq_data);
 
-	unsigned int __irq = irq_data->irq - tps6586x->irq_base;
+	unsigned int __irq = irq_data->hwirq;
 	const struct tps6586x_irq_data *data = &tps6586x_irqs[__irq];
 
 	tps6586x->mask_reg[data->mask_reg] |= data->mask_mask;
@@ -239,6 +250,39 @@ static void tps6586x_irq_sync_unlock(struct irq_data *data)
 	mutex_unlock(&tps6586x->irq_lock);
 }
 
+static struct irq_chip tps6586x_irq_chip = {
+	.name = "tps6586x",
+	.irq_bus_lock = tps6586x_irq_lock,
+	.irq_bus_sync_unlock = tps6586x_irq_sync_unlock,
+	.irq_disable = tps6586x_irq_disable,
+	.irq_enable = tps6586x_irq_enable,
+};
+
+static int tps6586x_irq_map(struct irq_domain *h, unsigned int virq,
+				irq_hw_number_t hw)
+{
+	struct tps6586x *tps6586x = h->host_data;
+
+	irq_set_chip_data(virq, tps6586x);
+	irq_set_chip_and_handler(virq, &tps6586x_irq_chip, handle_simple_irq);
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
+static struct irq_domain_ops tps6586x_domain_ops = {
+	.map    = tps6586x_irq_map,
+	.xlate  = irq_domain_xlate_twocell,
+};
+
 static irqreturn_t tps6586x_irq(int irq, void *data)
 {
 	struct tps6586x *tps6586x = data;
@@ -259,7 +303,8 @@ static irqreturn_t tps6586x_irq(int irq, void *data)
 		int i = __ffs(acks);
 
 		if (tps6586x->irq_en & (1 << i))
-			handle_nested_irq(tps6586x->irq_base + i);
+			handle_nested_irq(
+				irq_find_mapping(tps6586x->irq_domain, i));
 
 		acks &= ~(1 << i);
 	}
@@ -272,11 +317,8 @@ static int __devinit tps6586x_irq_init(struct tps6586x *tps6586x, int irq,
 {
 	int i, ret;
 	u8 tmp[4];
-
-	if (!irq_base) {
-		dev_warn(tps6586x->dev, "No interrupt support on IRQ base\n");
-		return -EINVAL;
-	}
+	int new_irq_base;
+	int irq_num = ARRAY_SIZE(tps6586x_irqs);
 
 	mutex_init(&tps6586x->irq_lock);
 	for (i = 0; i < 5; i++) {
@@ -286,25 +328,24 @@ static int __devinit tps6586x_irq_init(struct tps6586x *tps6586x, int irq,
 
 	tps6586x_reads(tps6586x->dev, TPS6586X_INT_ACK1, sizeof(tmp), tmp);
 
-	tps6586x->irq_base = irq_base;
-
-	tps6586x->irq_chip.name = "tps6586x";
-	tps6586x->irq_chip.irq_enable = tps6586x_irq_enable;
-	tps6586x->irq_chip.irq_disable = tps6586x_irq_disable;
-	tps6586x->irq_chip.irq_bus_lock = tps6586x_irq_lock;
-	tps6586x->irq_chip.irq_bus_sync_unlock = tps6586x_irq_sync_unlock;
-
-	for (i = 0; i < ARRAY_SIZE(tps6586x_irqs); i++) {
-		int __irq = i + tps6586x->irq_base;
-		irq_set_chip_data(__irq, tps6586x);
-		irq_set_chip_and_handler(__irq, &tps6586x->irq_chip,
-					 handle_simple_irq);
-		irq_set_nested_thread(__irq, 1);
-#ifdef CONFIG_ARM
-		set_irq_flags(__irq, IRQF_VALID);
-#endif
+	if  (irq_base > 0) {
+		new_irq_base = irq_alloc_descs(irq_base, 0, irq_num, -1);
+		if (new_irq_base < 0) {
+			dev_err(tps6586x->dev,
+				"Failed to alloc IRQs: %d\n", new_irq_base);
+			return new_irq_base;
+		}
+	} else {
+		new_irq_base = 0;
 	}
 
+	tps6586x->irq_domain = irq_domain_add_simple(tps6586x->dev->of_node,
+				irq_num, new_irq_base, &tps6586x_domain_ops,
+				tps6586x);
+	if (!tps6586x->irq_domain) {
+		dev_err(tps6586x->dev, "Failed to create IRQ domain\n");
+		return -ENOMEM;
+	}
 	ret = request_threaded_irq(irq, NULL, tps6586x_irq, IRQF_ONESHOT,
 				   "tps6586x", tps6586x);
 
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index 2dd1231..ebd8b08 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -93,5 +93,6 @@ extern int tps6586x_set_bits(struct device *dev, int reg, uint8_t bit_mask);
 extern int tps6586x_clr_bits(struct device *dev, int reg, uint8_t bit_mask);
 extern int tps6586x_update(struct device *dev, int reg, uint8_t val,
 			   uint8_t mask);
+extern int tps6586x_irq_get_virq(struct device *dev, int irq);
 
 #endif /*__LINUX_MFD_TPS6586X_H */
-- 
1.7.1.1

