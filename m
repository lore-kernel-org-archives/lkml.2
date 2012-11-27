Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab2K0Hh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:37:26 -0500
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:59033 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758176Ab2K0HhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:37:25 -0500
From: Qing Xu <qingx@marvell.com>
To: qingx@marvell.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v2 1/7] mfd: max8925: add irqdomain for dt
Date: Tue, 27 Nov 2012 15:38:30 +0800
Message-Id: <1354001910-5012-1-git-send-email-qingx@marvell.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 27 Nov 2012 07:37:06.0884 (UTC) FILETIME=[00692040:01CDCC72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qing Xu <qingx@marvell.com>

Add irqdomains for max8925's main irq, wrap irq register operations
into irqdomain's map func. it is necessary for dt support.

Also, add dt support for max8925 driver.

Signed-off-by: Qing Xu <qingx@marvell.com>
---
 drivers/mfd/max8925-core.c  |   69 ++++++++++++++++++++++++++-----------------
 drivers/mfd/max8925-i2c.c   |   37 +++++++++++++++++++++--
 include/linux/mfd/max8925.h |    3 +-
 3 files changed, 78 insertions(+), 31 deletions(-)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index 1e0ab0a..d0ebdbf 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -14,10 +14,13 @@
 #include <linux/i2c.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/machine.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/max8925.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 
 static struct resource bk_resources[] __devinitdata = {
 	{ 0x84, 0x84, "mode control", IORESOURCE_REG, },
@@ -639,17 +642,33 @@ static struct irq_chip max8925_irq_chip = {
 	.irq_disable	= max8925_irq_disable,
 };
 
+static int max8925_irq_domain_map(struct irq_domain *d, unsigned int virq,
+				 irq_hw_number_t hw)
+{
+	irq_set_chip_data(virq, d->host_data);
+	irq_set_chip_and_handler(virq, &max8925_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+	return 0;
+}
+
+static struct irq_domain_ops max8925_irq_domain_ops = {
+	.map	= max8925_irq_domain_map,
+	.xlate	= irq_domain_xlate_onetwocell,
+};
+
+
 static int max8925_irq_init(struct max8925_chip *chip, int irq,
 			    struct max8925_platform_data *pdata)
 {
 	unsigned long flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
-	int i, ret;
-	int __irq;
+	int ret;
+	struct device_node *node = chip->dev->of_node;
 
-	if (!pdata || !pdata->irq_base) {
-		dev_warn(chip->dev, "No interrupt support on IRQ base\n");
-		return -EINVAL;
-	}
 	/* clear all interrupts */
 	max8925_reg_read(chip->i2c, MAX8925_CHG_IRQ1);
 	max8925_reg_read(chip->i2c, MAX8925_CHG_IRQ2);
@@ -667,35 +686,32 @@ static int max8925_irq_init(struct max8925_chip *chip, int irq,
 	max8925_reg_write(chip->rtc, MAX8925_RTC_IRQ_MASK, 0xff);
 
 	mutex_init(&chip->irq_lock);
-	chip->core_irq = irq;
-	chip->irq_base = pdata->irq_base;
 
-	/* register with genirq */
-	for (i = 0; i < ARRAY_SIZE(max8925_irqs); i++) {
-		__irq = i + chip->irq_base;
-		irq_set_chip_data(__irq, chip);
-		irq_set_chip_and_handler(__irq, &max8925_irq_chip,
-					 handle_edge_irq);
-		irq_set_nested_thread(__irq, 1);
-#ifdef CONFIG_ARM
-		set_irq_flags(__irq, IRQF_VALID);
-#else
-		irq_set_noprobe(__irq);
-#endif
-	}
-	if (!irq) {
-		dev_warn(chip->dev, "No interrupt support on core IRQ\n");
-		goto tsc_irq;
+	chip->irq_base = irq_alloc_descs(-1, 0, MAX8925_NR_IRQS, 0);
+	if (chip->irq_base < 0) {
+		dev_err(chip->dev, "Failed to allocate interrupts, ret:%d\n",
+			chip->irq_base);
+		return -EBUSY;
 	}
 
+	irq_domain_add_legacy(node, MAX8925_NR_IRQS, chip->irq_base, 0,
+			      &max8925_irq_domain_ops, chip);
+
+	/* request irq handler for pmic main irq*/
+
+	chip->core_irq = irq;
+	if (!chip->core_irq)
+		return -EBUSY;
 	ret = request_threaded_irq(irq, NULL, max8925_irq, flags,
 				   "max8925", chip);
 	if (ret) {
 		dev_err(chip->dev, "Failed to request core IRQ: %d\n", ret);
 		chip->core_irq = 0;
+		return -EBUSY;
 	}
 
-tsc_irq:
+	/* request irq handler for pmic tsc irq*/
+
 	/* mask TSC interrupt */
 	max8925_reg_write(chip->adc, MAX8925_TSC_IRQ_MASK, 0x0f);
 
@@ -704,7 +720,6 @@ tsc_irq:
 		return 0;
 	}
 	chip->tsc_irq = pdata->tsc_irq;
-
 	ret = request_threaded_irq(chip->tsc_irq, NULL, max8925_tsc_irq,
 				   flags, "max8925-tsc", chip);
 	if (ret) {
@@ -876,7 +891,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
 	if (pdata && pdata->power) {
 		ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
 					ARRAY_SIZE(power_devs),
-				      &power_supply_resources[0], 0, NULL);
+					&power_supply_resources[0], 0, NULL);
 		if (ret < 0) {
 			dev_err(chip->dev, "Failed to add power supply "
 				"subdev\n");
diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
index d9e4b36..2f1966b 100644
--- a/drivers/mfd/max8925-i2c.c
+++ b/drivers/mfd/max8925-i2c.c
@@ -135,13 +135,38 @@ static const struct i2c_device_id max8925_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max8925_id_table);
 
+static int __devinit max8925_dt_init(struct device_node *np,
+				    struct device *dev,
+				    struct max8925_platform_data *pdata)
+{
+	int ret;
+
+	ret = of_property_read_u32(np, "tsc-irq", &pdata->tsc_irq);
+	if (ret) {
+		dev_err(dev, "Not found \"tsc-irq\" property\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int __devinit max8925_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
 	struct max8925_platform_data *pdata = client->dev.platform_data;
 	static struct max8925_chip *chip;
-
-	if (!pdata) {
+	struct device_node *node = client->dev.of_node;
+
+	if (node && !pdata) {
+		/* parse DT to get platform data */
+		pdata = devm_kzalloc(&client->dev,
+				     sizeof(struct max8925_platform_data),
+				     GFP_KERNEL);
+		if (!pdata)
+			return -ENOMEM;
+
+		if (max8925_dt_init(node, &client->dev, pdata))
+			return -EINVAL;
+	} else if (!pdata) {
 		pr_info("%s: platform data is missing\n", __func__);
 		return -EINVAL;
 	}
@@ -203,11 +228,18 @@ static int max8925_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(max8925_pm_ops, max8925_suspend, max8925_resume);
 
+static const struct of_device_id max8925_dt_ids[] = {
+	{ .compatible = "maxium,max8925", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, max8925_dt_ids);
+
 static struct i2c_driver max8925_driver = {
 	.driver	= {
 		.name	= "max8925",
 		.owner	= THIS_MODULE,
 		.pm     = &max8925_pm_ops,
+		.of_match_table = of_match_ptr(max8925_dt_ids),
 	},
 	.probe		= max8925_probe,
 	.remove		= __devexit_p(max8925_remove),
@@ -217,7 +249,6 @@ static struct i2c_driver max8925_driver = {
 static int __init max8925_i2c_init(void)
 {
 	int ret;
-
 	ret = i2c_add_driver(&max8925_driver);
 	if (ret != 0)
 		pr_err("Failed to register MAX8925 I2C driver: %d\n", ret);
diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
index 74d8e29..ce8502e 100644
--- a/include/linux/mfd/max8925.h
+++ b/include/linux/mfd/max8925.h
@@ -190,6 +190,8 @@ enum {
 	MAX8925_NR_IRQS,
 };
 
+
+
 struct max8925_chip {
 	struct device		*dev;
 	struct i2c_client	*i2c;
@@ -201,7 +203,6 @@ struct max8925_chip {
 	int			irq_base;
 	int			core_irq;
 	int			tsc_irq;
-
 	unsigned int            wakeup_flag;
 };
 
-- 
1.7.0.4

