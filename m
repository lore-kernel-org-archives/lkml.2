Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2GRGaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:30:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1267 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2GRGaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:30:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 17 Jul 2012 23:29:59 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>, <swarren@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 2/6] mfd: Use regmap for tps6586x register access.
Date: Wed, 18 Jul 2012 11:50:46 +0530
Message-ID: <1342592450-12488-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
References: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using regmap apis for accessing the device registers.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Changes V1 -> V2:
No change, generated new patch for V2 series.
Changes V2 -> V3:
No change, generated new patch for V3 series.

 drivers/mfd/Kconfig    |    1 +
 drivers/mfd/tps6586x.c |  157 ++++++++++++++----------------------------------
 2 files changed, 47 insertions(+), 111 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fa267d4..ec885a9 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -200,6 +200,7 @@ config MFD_TPS6586X
 	bool "TPS6586x Power Management chips"
 	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
 	select MFD_CORE
+	select REGMAP_I2C
 	depends on REGULATOR
 	help
 	  If you say yes here you get support for the TPS6586X series of
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index c103ea9..6f59594 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -21,8 +21,10 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
+#include <linux/regmap.h>
 #include <linux/regulator/of_regulator.h>
 
 #include <linux/mfd/core.h>
@@ -48,6 +50,9 @@
 /* device id */
 #define TPS6586X_VERSIONCRC	0xcd
 
+/* Maximum register */
+#define TPS6586X_MAX_REGISTER	(TPS6586X_VERSIONCRC + 1)
+
 struct tps6586x_irq_data {
 	u8	mask_reg;
 	u8	mask_mask;
@@ -90,9 +95,9 @@ static const struct tps6586x_irq_data tps6586x_irqs[] = {
 };
 
 struct tps6586x {
-	struct mutex		lock;
 	struct device		*dev;
 	struct i2c_client	*client;
+	struct regmap		*regmap;
 
 	struct gpio_chip	gpio;
 	struct irq_chip		irq_chip;
@@ -103,152 +108,69 @@ struct tps6586x {
 	u8			mask_reg[5];
 };
 
-static inline int __tps6586x_read(struct i2c_client *client,
-				  int reg, uint8_t *val)
+static inline struct tps6586x *dev_to_tps6586x(struct device *dev)
 {
-	int ret;
-
-	ret = i2c_smbus_read_byte_data(client, reg);
-	if (ret < 0) {
-		dev_err(&client->dev, "failed reading at 0x%02x\n", reg);
-		return ret;
-	}
-
-	*val = (uint8_t)ret;
-
-	return 0;
-}
-
-static inline int __tps6586x_reads(struct i2c_client *client, int reg,
-				   int len, uint8_t *val)
-{
-	int ret;
-
-	ret = i2c_smbus_read_i2c_block_data(client, reg, len, val);
-	if (ret < 0) {
-		dev_err(&client->dev, "failed reading from 0x%02x\n", reg);
-		return ret;
-	}
-
-	return 0;
-}
-
-static inline int __tps6586x_write(struct i2c_client *client,
-				 int reg, uint8_t val)
-{
-	int ret;
-
-	ret = i2c_smbus_write_byte_data(client, reg, val);
-	if (ret < 0) {
-		dev_err(&client->dev, "failed writing 0x%02x to 0x%02x\n",
-				val, reg);
-		return ret;
-	}
-
-	return 0;
-}
-
-static inline int __tps6586x_writes(struct i2c_client *client, int reg,
-				  int len, uint8_t *val)
-{
-	int ret, i;
-
-	for (i = 0; i < len; i++) {
-		ret = __tps6586x_write(client, reg + i, *(val + i));
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
+	return i2c_get_clientdata(to_i2c_client(dev));
 }
 
 int tps6586x_write(struct device *dev, int reg, uint8_t val)
 {
-	return __tps6586x_write(to_i2c_client(dev), reg, val);
+	struct tps6586x *tps6586x = dev_to_tps6586x(dev);
+
+	return regmap_write(tps6586x->regmap, reg, val);
 }
 EXPORT_SYMBOL_GPL(tps6586x_write);
 
 int tps6586x_writes(struct device *dev, int reg, int len, uint8_t *val)
 {
-	return __tps6586x_writes(to_i2c_client(dev), reg, len, val);
+	struct tps6586x *tps6586x = dev_to_tps6586x(dev);
+
+	return regmap_bulk_write(tps6586x->regmap, reg, val, len);
 }
 EXPORT_SYMBOL_GPL(tps6586x_writes);
 
 int tps6586x_read(struct device *dev, int reg, uint8_t *val)
 {
-	return __tps6586x_read(to_i2c_client(dev), reg, val);
+	struct tps6586x *tps6586x = dev_to_tps6586x(dev);
+	unsigned int rval;
+	int ret;
+
+	ret = regmap_read(tps6586x->regmap, reg, &rval);
+	if (!ret)
+		*val = rval;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(tps6586x_read);
 
 int tps6586x_reads(struct device *dev, int reg, int len, uint8_t *val)
 {
-	return __tps6586x_reads(to_i2c_client(dev), reg, len, val);
+	struct tps6586x *tps6586x = dev_to_tps6586x(dev);
+
+	return regmap_bulk_read(tps6586x->regmap, reg, val, len);
 }
 EXPORT_SYMBOL_GPL(tps6586x_reads);
 
 int tps6586x_set_bits(struct device *dev, int reg, uint8_t bit_mask)
 {
-	struct tps6586x *tps6586x = dev_get_drvdata(dev);
-	uint8_t reg_val;
-	int ret = 0;
-
-	mutex_lock(&tps6586x->lock);
-
-	ret = __tps6586x_read(to_i2c_client(dev), reg, &reg_val);
-	if (ret)
-		goto out;
+	struct tps6586x *tps6586x = dev_to_tps6586x(dev);
 
-	if ((reg_val & bit_mask) != bit_mask) {
-		reg_val |= bit_mask;
-		ret = __tps6586x_write(to_i2c_client(dev), reg, reg_val);
-	}
-out:
-	mutex_unlock(&tps6586x->lock);
-	return ret;
+	return regmap_update_bits(tps6586x->regmap, reg, bit_mask, bit_mask);
 }
 EXPORT_SYMBOL_GPL(tps6586x_set_bits);
 
 int tps6586x_clr_bits(struct device *dev, int reg, uint8_t bit_mask)
 {
-	struct tps6586x *tps6586x = dev_get_drvdata(dev);
-	uint8_t reg_val;
-	int ret = 0;
+	struct tps6586x *tps6586x = dev_to_tps6586x(dev);
 
-	mutex_lock(&tps6586x->lock);
-
-	ret = __tps6586x_read(to_i2c_client(dev), reg, &reg_val);
-	if (ret)
-		goto out;
-
-	if (reg_val & bit_mask) {
-		reg_val &= ~bit_mask;
-		ret = __tps6586x_write(to_i2c_client(dev), reg, reg_val);
-	}
-out:
-	mutex_unlock(&tps6586x->lock);
-	return ret;
+	return regmap_update_bits(tps6586x->regmap, reg, bit_mask, 0);
 }
 EXPORT_SYMBOL_GPL(tps6586x_clr_bits);
 
 int tps6586x_update(struct device *dev, int reg, uint8_t val, uint8_t mask)
 {
-	struct tps6586x *tps6586x = dev_get_drvdata(dev);
-	uint8_t reg_val;
-	int ret = 0;
-
-	mutex_lock(&tps6586x->lock);
-
-	ret = __tps6586x_read(tps6586x->client, reg, &reg_val);
-	if (ret)
-		goto out;
+	struct tps6586x *tps6586x = dev_to_tps6586x(dev);
 
-	if ((reg_val & mask) != val) {
-		reg_val = (reg_val & ~mask) | val;
-		ret = __tps6586x_write(tps6586x->client, reg, reg_val);
-	}
-out:
-	mutex_unlock(&tps6586x->lock);
-	return ret;
+	return regmap_update_bits(tps6586x->regmap, reg, mask, val);
 }
 EXPORT_SYMBOL_GPL(tps6586x_update);
 
@@ -258,7 +180,7 @@ static int tps6586x_gpio_get(struct gpio_chip *gc, unsigned offset)
 	uint8_t val;
 	int ret;
 
-	ret = __tps6586x_read(tps6586x->client, TPS6586X_GPIOSET2, &val);
+	ret = tps6586x_read(tps6586x->dev, TPS6586X_GPIOSET2, &val);
 	if (ret)
 		return ret;
 
@@ -556,6 +478,12 @@ static struct tps6586x_platform_data *tps6586x_parse_dt(struct i2c_client *clien
 }
 #endif
 
+static const struct regmap_config tps6586x_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = TPS6586X_MAX_REGISTER - 1,
+};
+
 static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
@@ -589,7 +517,14 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 	tps6586x->dev = &client->dev;
 	i2c_set_clientdata(client, tps6586x);
 
-	mutex_init(&tps6586x->lock);
+	tps6586x->regmap = devm_regmap_init_i2c(client,
+					&tps6586x_regmap_config);
+	if (IS_ERR(tps6586x->regmap)) {
+		ret = PTR_ERR(tps6586x->regmap);
+		dev_err(&client->dev, "regmap init failed: %d\n", ret);
+		return ret;
+	}
+
 
 	if (client->irq) {
 		ret = tps6586x_irq_init(tps6586x, client->irq,
-- 
1.7.1.1

