Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1CEKtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:49:32 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:53094 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484Ab1CEKs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:48:59 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/5] mfd: reentrance and revamp ab8500 gpadc fetching interface
Date: Sat, 5 Mar 2011 11:46:13 +0100
Message-ID: <1299321973-6798-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Willerud <daniel.willerud@stericsson.com>

This revamps the interface so that AB8500 GPADCs are fetched by
name. Probed GPADCs are added to a list and this list is searched
for a matching GPADC. This makes it possible to have multiple
AB8500 GPADC instances instead of it being a singleton, and
rids the need to keep a GPADC pointer around in the core AB8500
MFD struct.

Currently the match is made to the device name which is by default
numbered from the device instance such as "ab8500-gpadc.0" but
by using the .init_name field of the device a more intiutive
naming for the GPADC blocks can be achieved if desired.

Signed-off-by: Daniel Willerud <daniel.willerud@stericsson.com>
[Match by name instead of taking the first GPADC]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c              |  115 +++++++++++++++++++------------
 include/linux/mfd/ab8500/ab8500-gpadc.h |    6 ++-
 2 files changed, 75 insertions(+), 46 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index f60f71f4..178cbc5 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -3,6 +3,7 @@
  *
  * License Terms: GNU General Public License v2
  * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ * Author: Daniel Willerud <daniel.willerud@stericsson.com>
  */
 #include <linux/init.h>
 #include <linux/module.h>
@@ -15,6 +16,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/list.h>
 #include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/ab8500/ab8500-gpadc.h>
@@ -48,21 +50,41 @@
 /**
  * struct ab8500_gpadc - ab8500 GPADC device information
  * @dev:			pointer to the struct device
- * @parent:			pointer to the parent device structure ab8500
+ * @node:			a list of AB8500 GPADCs, hence prepared for
+				reentrance
  * @ab8500_gpadc_complete:	pointer to the struct completion, to indicate
  *				the completion of gpadc conversion
  * @ab8500_gpadc_lock:		structure of type mutex
  * @regu:			pointer to the struct regulator
  * @irq:			interrupt number that is used by gpadc
  */
-static struct ab8500_gpadc {
+struct ab8500_gpadc {
 	struct device *dev;
-	struct ab8500 *parent;
+	struct list_head node;
 	struct completion ab8500_gpadc_complete;
 	struct mutex ab8500_gpadc_lock;
 	struct regulator *regu;
 	int irq;
-} *di;
+};
+
+static LIST_HEAD(ab8500_gpadc_list);
+
+/**
+ * ab8500_gpadc_get() - returns a reference to the primary AB8500 GPADC
+ * (i.e. the first GPADC in the instance list)
+ */
+struct ab8500_gpadc *ab8500_gpadc_get(char *name)
+{
+	struct ab8500_gpadc *gpadc;
+
+	list_for_each_entry(gpadc, &ab8500_gpadc_list, node) {
+		if (!strcmp(name, dev_name(gpadc->dev)))
+		    return gpadc;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL(ab8500_gpadc_get);
 
 /**
  * ab8500_gpadc_convert() - gpadc conversion
@@ -72,24 +94,24 @@ static struct ab8500_gpadc {
  * data. Thereafter calibration has to be made to obtain the
  * data in the required quantity measurement.
  */
-int ab8500_gpadc_convert(u8 input)
+int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 {
 	int ret;
 	u16 data = 0;
 	int looplimit = 0;
 	u8 val, low_data, high_data;
 
-	if (!di)
+	if (!gpadc)
 		return -ENODEV;
 
-	mutex_lock(&di->ab8500_gpadc_lock);
+	mutex_lock(&gpadc->ab8500_gpadc_lock);
 	/* Enable VTVout LDO this is required for GPADC */
-	regulator_enable(di->regu);
+	regulator_enable(gpadc->regu);
 
 	/* Check if ADC is not busy, lock and proceed */
 	do {
-		ret = abx500_get_register_interruptible(di->dev, AB8500_GPADC,
-			AB8500_GPADC_STAT_REG, &val);
+		ret = abx500_get_register_interruptible(gpadc->dev,
+			AB8500_GPADC, AB8500_GPADC_STAT_REG, &val);
 		if (ret < 0)
 			goto out;
 		if (!(val & GPADC_BUSY))
@@ -97,75 +119,76 @@ int ab8500_gpadc_convert(u8 input)
 		msleep(10);
 	} while (++looplimit < 10);
 	if (looplimit >= 10 && (val & GPADC_BUSY)) {
-		dev_err(di->dev, "gpadc_conversion: GPADC busy");
+		dev_err(gpadc->dev, "gpadc_conversion: GPADC busy");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	/* Enable GPADC */
-	ret = abx500_mask_and_set_register_interruptible(di->dev, AB8500_GPADC,
-		AB8500_GPADC_CTRL1_REG, EN_GPADC, EN_GPADC);
+	ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
+		AB8500_GPADC, AB8500_GPADC_CTRL1_REG, EN_GPADC, EN_GPADC);
 	if (ret < 0) {
-		dev_err(di->dev, "gpadc_conversion: enable gpadc failed\n");
+		dev_err(gpadc->dev, "gpadc_conversion: enable gpadc failed\n");
 		goto out;
 	}
 	/* Select the input source and set average samples to 16 */
-	ret = abx500_set_register_interruptible(di->dev, AB8500_GPADC,
+	ret = abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_CTRL2_REG, (input | SW_AVG_16));
 	if (ret < 0) {
-		dev_err(di->dev,
+		dev_err(gpadc->dev,
 			"gpadc_conversion: set avg samples failed\n");
 		goto out;
 	}
 	/* Enable ADC, Buffering and select rising edge, start Conversion */
-	ret = abx500_mask_and_set_register_interruptible(di->dev, AB8500_GPADC,
-		AB8500_GPADC_CTRL1_REG, EN_BUF, EN_BUF);
+	ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
+		AB8500_GPADC, AB8500_GPADC_CTRL1_REG, EN_BUF, EN_BUF);
 	if (ret < 0) {
-		dev_err(di->dev,
+		dev_err(gpadc->dev,
 			"gpadc_conversion: select falling edge failed\n");
 		goto out;
 	}
-	ret = abx500_mask_and_set_register_interruptible(di->dev, AB8500_GPADC,
-		AB8500_GPADC_CTRL1_REG, ADC_SW_CONV, ADC_SW_CONV);
+	ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
+		AB8500_GPADC, AB8500_GPADC_CTRL1_REG, ADC_SW_CONV, ADC_SW_CONV);
 	if (ret < 0) {
-		dev_err(di->dev,
+		dev_err(gpadc->dev,
 			"gpadc_conversion: start s/w conversion failed\n");
 		goto out;
 	}
 	/* wait for completion of conversion */
-	if (!wait_for_completion_timeout(&di->ab8500_gpadc_complete, 2*HZ)) {
-		dev_err(di->dev,
+	if (!wait_for_completion_timeout(&gpadc->ab8500_gpadc_complete, 2*HZ)) {
+		dev_err(gpadc->dev,
 			"timeout: didnt recieve GPADC conversion interrupt\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	/* Read the converted RAW data */
-	ret = abx500_get_register_interruptible(di->dev, AB8500_GPADC,
+	ret = abx500_get_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_MANDATAL_REG, &low_data);
 	if (ret < 0) {
-		dev_err(di->dev, "gpadc_conversion: read low data failed\n");
+		dev_err(gpadc->dev, "gpadc_conversion: read low data failed\n");
 		goto out;
 	}
 
-	ret = abx500_get_register_interruptible(di->dev, AB8500_GPADC,
+	ret = abx500_get_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_MANDATAH_REG, &high_data);
 	if (ret < 0) {
-		dev_err(di->dev, "gpadc_conversion: read high data failed\n");
+		dev_err(gpadc->dev,
+			"gpadc_conversion: read high data failed\n");
 		goto out;
 	}
 
 	data = (high_data << 8) | low_data;
 	/* Disable GPADC */
-	ret = abx500_set_register_interruptible(di->dev, AB8500_GPADC,
+	ret = abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_CTRL1_REG, DIS_GPADC);
 	if (ret < 0) {
-		dev_err(di->dev, "gpadc_conversion: disable gpadc failed\n");
+		dev_err(gpadc->dev, "gpadc_conversion: disable gpadc failed\n");
 		goto out;
 	}
 	/* Disable VTVout LDO this is required for GPADC */
-	regulator_disable(di->regu);
-	mutex_unlock(&di->ab8500_gpadc_lock);
+	regulator_disable(gpadc->regu);
+	mutex_unlock(&gpadc->ab8500_gpadc_lock);
 	return data;
 
 out:
@@ -175,12 +198,12 @@ out:
 	 * GPADC status register to go low. In V1.1 there wait_for_completion
 	 * seems to timeout when waiting for an interrupt.. Not seen in V2.0
 	 */
-	(void) abx500_set_register_interruptible(di->dev, AB8500_GPADC,
+	(void) abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_CTRL1_REG, DIS_GPADC);
-	regulator_disable(di->regu);
-	mutex_unlock(&di->ab8500_gpadc_lock);
-	dev_err(di->dev, "gpadc_conversion: Failed to AD convert channel %d\n",
-		input);
+	regulator_disable(gpadc->regu);
+	mutex_unlock(&gpadc->ab8500_gpadc_lock);
+	dev_err(gpadc->dev,
+		"gpadc_conversion: Failed to AD convert channel %d\n", input);
 	return ret;
 }
 EXPORT_SYMBOL(ab8500_gpadc_convert);
@@ -195,9 +218,9 @@ EXPORT_SYMBOL(ab8500_gpadc_convert);
  * can be read from the registers.
  * Returns IRQ status(IRQ_HANDLED)
  */
-static irqreturn_t ab8500_bm_gpswadcconvend_handler(int irq, void *_di)
+static irqreturn_t ab8500_bm_gpswadcconvend_handler(int irq, void *_gpadc)
 {
-	struct ab8500_gpadc *gpadc = _di;
+	struct ab8500_gpadc *gpadc = _gpadc;
 
 	complete(&gpadc->ab8500_gpadc_complete);
 
@@ -215,16 +238,16 @@ static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	gpadc->parent = dev_get_drvdata(pdev->dev.parent);
 	gpadc->irq = platform_get_irq_byname(pdev, "SW_CONV_END");
 	if (gpadc->irq < 0) {
-		dev_err(gpadc->dev, "failed to get platform irq-%d\n", di->irq);
+		dev_err(gpadc->dev, "failed to get platform irq-%d\n",
+			gpadc->irq);
 		ret = gpadc->irq;
 		goto fail;
 	}
 
 	gpadc->dev = &pdev->dev;
-	mutex_init(&di->ab8500_gpadc_lock);
+	mutex_init(&gpadc->ab8500_gpadc_lock);
 
 	/* Initialize completion used to notify completion of conversion */
 	init_completion(&gpadc->ab8500_gpadc_complete);
@@ -246,7 +269,7 @@ static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
 		dev_err(gpadc->dev, "failed to get vtvout LDO\n");
 		goto fail;
 	}
-	di = gpadc;
+	list_add_tail(&gpadc->node, &ab8500_gpadc_list);
 	dev_dbg(gpadc->dev, "probe success\n");
 	return 0;
 fail:
@@ -259,8 +282,10 @@ static int __devexit ab8500_gpadc_remove(struct platform_device *pdev)
 {
 	struct ab8500_gpadc *gpadc = platform_get_drvdata(pdev);
 
+	/* remove this gpadc entry from the list */
+	list_del(&gpadc->node);
 	/* remove interrupt  - completion of Sw ADC conversion */
-	free_irq(gpadc->irq, di);
+	free_irq(gpadc->irq, gpadc);
 	/* disable VTVout LDO that is being used by GPADC */
 	regulator_put(gpadc->regu);
 	kfree(gpadc);
@@ -291,6 +316,6 @@ subsys_initcall_sync(ab8500_gpadc_init);
 module_exit(ab8500_gpadc_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Arun R Murthy");
+MODULE_AUTHOR("Arun R Murthy, Daniel Willerud");
 MODULE_ALIAS("platform:ab8500_gpadc");
 MODULE_DESCRIPTION("AB8500 GPADC driver");
diff --git a/include/linux/mfd/ab8500/ab8500-gpadc.h b/include/linux/mfd/ab8500/ab8500-gpadc.h
index 74b87dd..46b9540 100644
--- a/include/linux/mfd/ab8500/ab8500-gpadc.h
+++ b/include/linux/mfd/ab8500/ab8500-gpadc.h
@@ -3,6 +3,7 @@
  * Licensed under GPLv2.
  *
  * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ * Author: Daniel Willerud <daniel.willerud@stericsson.com>
  */
 
 #ifndef	_AB8500_GPADC_H
@@ -23,6 +24,9 @@
 #define BK_BAT_V	0x0C
 #define DIE_TEMP	0x0D
 
-int ab8500_gpadc_convert(u8 input);
+struct ab8500_gpadc;
+
+struct ab8500_gpadc *ab8500_gpadc_get(char *name);
+int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input);
 
 #endif /* _AB8500_GPADC_H */
-- 
1.7.3.2

