Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab1F3GBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 02:01:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54316 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758251Ab1F3GAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 02:00:48 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 7/8] mfd: Convert pcf50633 to use new register map API
Date: Wed, 29 Jun 2011 23:00:35 -0700
Message-Id: <1309413636-1169-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309413636-1169-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110630055844.GC796@opensource.wolfsonmicro.com>
 <1309413636-1169-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig               |    1 +
 drivers/mfd/pcf50633-core.c       |  114 +++++++++---------------------------
 include/linux/mfd/pcf50633/core.h |    3 +-
 3 files changed, 32 insertions(+), 86 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 97e01b4..c5edb8b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -488,6 +488,7 @@ config MFD_WM8994
 config MFD_PCF50633
 	tristate "Support for NXP PCF50633"
 	depends on I2C
+	select REGMAP
 	help
 	  Say yes here if you have NXP PCF50633 chip on your board.
 	  This core driver provides register access and IRQ handling
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 57868416..6e7a8d4 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -23,45 +23,16 @@
 #include <linux/i2c.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
+#include <linux/regmap.h>
+#include <linux/err.h>
 
 #include <linux/mfd/pcf50633/core.h>
 
-static int __pcf50633_read(struct pcf50633 *pcf, u8 reg, int num, u8 *data)
-{
-	int ret;
-
-	ret = i2c_smbus_read_i2c_block_data(pcf->i2c_client, reg,
-				num, data);
-	if (ret < 0)
-		dev_err(pcf->dev, "Error reading %d regs at %d\n", num, reg);
-
-	return ret;
-}
-
-static int __pcf50633_write(struct pcf50633 *pcf, u8 reg, int num, u8 *data)
-{
-	int ret;
-
-	ret = i2c_smbus_write_i2c_block_data(pcf->i2c_client, reg,
-				num, data);
-	if (ret < 0)
-		dev_err(pcf->dev, "Error writing %d regs at %d\n", num, reg);
-
-	return ret;
-
-}
-
 /* Read a block of up to 32 regs  */
 int pcf50633_read_block(struct pcf50633 *pcf, u8 reg,
 					int nr_regs, u8 *data)
 {
-	int ret;
-
-	mutex_lock(&pcf->lock);
-	ret = __pcf50633_read(pcf, reg, nr_regs, data);
-	mutex_unlock(&pcf->lock);
-
-	return ret;
+	return regmap_raw_read(pcf->regmap, reg, data, nr_regs);
 }
 EXPORT_SYMBOL_GPL(pcf50633_read_block);
 
@@ -69,23 +40,18 @@ EXPORT_SYMBOL_GPL(pcf50633_read_block);
 int pcf50633_write_block(struct pcf50633 *pcf , u8 reg,
 					int nr_regs, u8 *data)
 {
-	int ret;
-
-	mutex_lock(&pcf->lock);
-	ret = __pcf50633_write(pcf, reg, nr_regs, data);
-	mutex_unlock(&pcf->lock);
-
-	return ret;
+	return regmap_raw_write(pcf->regmap, reg, data, nr_regs);
 }
 EXPORT_SYMBOL_GPL(pcf50633_write_block);
 
 u8 pcf50633_reg_read(struct pcf50633 *pcf, u8 reg)
 {
-	u8 val;
+	unsigned int val;
+	int ret;
 
-	mutex_lock(&pcf->lock);
-	__pcf50633_read(pcf, reg, 1, &val);
-	mutex_unlock(&pcf->lock);
+	ret = regmap_read(pcf->regmap, reg, &val);
+	if (ret < 0)
+		return -1;
 
 	return val;
 }
@@ -93,56 +59,19 @@ EXPORT_SYMBOL_GPL(pcf50633_reg_read);
 
 int pcf50633_reg_write(struct pcf50633 *pcf, u8 reg, u8 val)
 {
-	int ret;
-
-	mutex_lock(&pcf->lock);
-	ret = __pcf50633_write(pcf, reg, 1, &val);
-	mutex_unlock(&pcf->lock);
-
-	return ret;
+	return regmap_write(pcf->regmap, reg, val);
 }
 EXPORT_SYMBOL_GPL(pcf50633_reg_write);
 
 int pcf50633_reg_set_bit_mask(struct pcf50633 *pcf, u8 reg, u8 mask, u8 val)
 {
-	int ret;
-	u8 tmp;
-
-	val &= mask;
-
-	mutex_lock(&pcf->lock);
-	ret = __pcf50633_read(pcf, reg, 1, &tmp);
-	if (ret < 0)
-		goto out;
-
-	tmp &= ~mask;
-	tmp |= val;
-	ret = __pcf50633_write(pcf, reg, 1, &tmp);
-
-out:
-	mutex_unlock(&pcf->lock);
-
-	return ret;
+	return regmap_update_bits(pcf->regmap, reg, mask, val);
 }
 EXPORT_SYMBOL_GPL(pcf50633_reg_set_bit_mask);
 
 int pcf50633_reg_clear_bits(struct pcf50633 *pcf, u8 reg, u8 val)
 {
-	int ret;
-	u8 tmp;
-
-	mutex_lock(&pcf->lock);
-	ret = __pcf50633_read(pcf, reg, 1, &tmp);
-	if (ret < 0)
-		goto out;
-
-	tmp &= ~val;
-	ret = __pcf50633_write(pcf, reg, 1, &tmp);
-
-out:
-	mutex_unlock(&pcf->lock);
-
-	return ret;
+	return regmap_update_bits(pcf->regmap, reg, val, 0);
 }
 EXPORT_SYMBOL_GPL(pcf50633_reg_clear_bits);
 
@@ -251,6 +180,11 @@ static int pcf50633_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(pcf50633_pm, pcf50633_suspend, pcf50633_resume);
 
+static struct regmap_config pcf50633_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
 static int __devinit pcf50633_probe(struct i2c_client *client,
 				const struct i2c_device_id *ids)
 {
@@ -272,16 +206,23 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 
 	mutex_init(&pcf->lock);
 
+	pcf->regmap = regmap_init(pcf->dev, &pcf50633_regmap_config);
+	if (IS_ERR(pcf->regmap)) {
+		ret = PTR_ERR(pcf->regmap);
+		dev_err(pcf->dev, "Failed to allocate register map: %d\n",
+			ret);
+		goto err_free;
+	}
+
 	i2c_set_clientdata(client, pcf);
 	pcf->dev = &client->dev;
-	pcf->i2c_client = client;
 
 	version = pcf50633_reg_read(pcf, 0);
 	variant = pcf50633_reg_read(pcf, 1);
 	if (version < 0 || variant < 0) {
 		dev_err(pcf->dev, "Unable to probe pcf50633\n");
 		ret = -ENODEV;
-		goto err_free;
+		goto err_regmap;
 	}
 
 	dev_info(pcf->dev, "Probed device version %d variant %d\n",
@@ -328,6 +269,8 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 
 	return 0;
 
+err_regmap:
+	regmap_exit(pcf->regmap);
 err_free:
 	kfree(pcf);
 
@@ -351,6 +294,7 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
 	for (i = 0; i < PCF50633_NUM_REGULATORS; i++)
 		platform_device_unregister(pcf->regulator_pdev[i]);
 
+	regmap_exit(pcf->regmap);
 	kfree(pcf);
 
 	return 0;
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index 50d4a04..a808407 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -21,6 +21,7 @@
 #include <linux/mfd/pcf50633/backlight.h>
 
 struct pcf50633;
+struct regmap;
 
 #define PCF50633_NUM_REGULATORS	11
 
@@ -134,7 +135,7 @@ enum {
 
 struct pcf50633 {
 	struct device *dev;
-	struct i2c_client *i2c_client;
+	struct regmap *regmap;
 
 	struct pcf50633_platform_data *pdata;
 	int irq;
-- 
1.7.5.4

