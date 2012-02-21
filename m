Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2BUMyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:54:13 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2890 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab2BUMyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:54:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 21 Feb 2012 04:54:12 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: sameo@linux.intel.com, jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gg@slimlogic.co.u
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        ldewangan@nvidia.com
Subject: [PATCH V2] mfd: tps65910: use regmap for device register access.
Date: Tue, 21 Feb 2012 18:21:34 +0530
Message-Id: <1329828694-2955-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using regmap apis for accessing the device registers and
using RBTREE caching mechanims for caching registers.

Enabling caching of the registers which is used for voltage
controls. By doing this, the modify_bits operation is faster as
it does not involve the i2c register read from device, just read
from cache. This results faster set voltage operation.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
The orginal change was pushed into two patches
[PATCH V1 1/2] mfd: tps65910: use regmap for device register access.
[PATCH V1 2/2] regulator: tps65910: Enable register caching of voltage controls.
where it was suggested to enable caching in mfd core driver only and so
it does not require second patch.
Changes from V1:
- Enable caching in the core driver itself.
- Remove changes from regulator driver.

 drivers/mfd/Kconfig          |    1 +
 drivers/mfd/tps65910.c       |  123 ++++++++++++++++--------------------------
 include/linux/mfd/tps65910.h |    1 +
 3 files changed, 48 insertions(+), 77 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index cd13e9f..0e066cd 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -162,6 +162,7 @@ config MFD_TPS65910
 	depends on I2C=y && GPIOLIB
 	select MFD_CORE
 	select GPIO_TPS65910
+	select REGMAP_I2C
 	help
 	  if you say yes here you get support for the TPS65910 series of
 	  Power Management chips.
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 4392f6b..1c4f53e 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -16,10 +16,12 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
+#include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/mfd/core.h>
+#include <linux/regmap.h>
 #include <linux/mfd/tps65910.h>
 
 static struct mfd_cell tps65910s[] = {
@@ -38,99 +40,56 @@ static struct mfd_cell tps65910s[] = {
 static int tps65910_i2c_read(struct tps65910 *tps65910, u8 reg,
 				  int bytes, void *dest)
 {
-	struct i2c_client *i2c = tps65910->i2c_client;
-	struct i2c_msg xfer[2];
-	int ret;
-
-	/* Write register */
-	xfer[0].addr = i2c->addr;
-	xfer[0].flags = 0;
-	xfer[0].len = 1;
-	xfer[0].buf = &reg;
-
-	/* Read data */
-	xfer[1].addr = i2c->addr;
-	xfer[1].flags = I2C_M_RD;
-	xfer[1].len = bytes;
-	xfer[1].buf = dest;
-
-	ret = i2c_transfer(i2c->adapter, xfer, 2);
-	if (ret == 2)
-		ret = 0;
-	else if (ret >= 0)
-		ret = -EIO;
-
-	return ret;
+	return regmap_bulk_read(tps65910->regmap, reg, dest, bytes);
 }
 
 static int tps65910_i2c_write(struct tps65910 *tps65910, u8 reg,
-				   int bytes, void *src)
+				  int bytes, void *src)
 {
-	struct i2c_client *i2c = tps65910->i2c_client;
-	/* we add 1 byte for device register */
-	u8 msg[TPS65910_MAX_REGISTER + 1];
-	int ret;
-
-	if (bytes > TPS65910_MAX_REGISTER)
-		return -EINVAL;
-
-	msg[0] = reg;
-	memcpy(&msg[1], src, bytes);
-
-	ret = i2c_master_send(i2c, msg, bytes + 1);
-	if (ret < 0)
-		return ret;
-	if (ret != bytes + 1)
-		return -EIO;
-	return 0;
+	return regmap_bulk_write(tps65910->regmap, reg, src, bytes);
 }
 
 int tps65910_set_bits(struct tps65910 *tps65910, u8 reg, u8 mask)
 {
-	u8 data;
-	int err;
-
-	mutex_lock(&tps65910->io_mutex);
-	err = tps65910_i2c_read(tps65910, reg, 1, &data);
-	if (err) {
-		dev_err(tps65910->dev, "read from reg %x failed\n", reg);
-		goto out;
-	}
-
-	data |= mask;
-	err = tps65910_i2c_write(tps65910, reg, 1, &data);
-	if (err)
-		dev_err(tps65910->dev, "write to reg %x failed\n", reg);
-
-out:
-	mutex_unlock(&tps65910->io_mutex);
-	return err;
+	return regmap_update_bits(tps65910->regmap, reg, mask, mask);
 }
 EXPORT_SYMBOL_GPL(tps65910_set_bits);
 
 int tps65910_clear_bits(struct tps65910 *tps65910, u8 reg, u8 mask)
 {
-	u8 data;
-	int err;
-
-	mutex_lock(&tps65910->io_mutex);
-	err = tps65910_i2c_read(tps65910, reg, 1, &data);
-	if (err) {
-		dev_err(tps65910->dev, "read from reg %x failed\n", reg);
-		goto out;
-	}
-
-	data &= ~mask;
-	err = tps65910_i2c_write(tps65910, reg, 1, &data);
-	if (err)
-		dev_err(tps65910->dev, "write to reg %x failed\n", reg);
-
-out:
-	mutex_unlock(&tps65910->io_mutex);
-	return err;
+	return regmap_update_bits(tps65910->regmap, reg, mask, 0);
 }
 EXPORT_SYMBOL_GPL(tps65910_clear_bits);
 
+static bool is_volatile_reg(struct device *dev, unsigned int reg)
+{
+	struct tps65910 *tps65910 = dev_get_drvdata(dev);
+
+	/*
+	 * Caching all regulator registers.
+	 * All regualator register address range is same for
+	 * TPS65910 and TPS65911
+	 */
+	if ((reg >= TPS65910_VIO) && (reg <= TPS65910_VDAC)) {
+		/* Check for non-existing register */
+		if (tps65910_chip_id(tps65910) == TPS65910)
+			if ((reg == TPS65911_VDDCTRL_OP) ||
+				(reg == TPS65911_VDDCTRL_SR))
+				return true;
+		return false;
+	}
+	return true;
+}
+
+static const struct regmap_config rc5t583_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.volatile_reg = is_volatile_reg,
+	.max_register = TPS65910_MAX_REGISTER,
+	.num_reg_defaults_raw = TPS65910_MAX_REGISTER,
+	.cache_type = REGCACHE_RBTREE,
+};
+
 static int tps65910_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
@@ -161,6 +120,13 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	tps65910->write = tps65910_i2c_write;
 	mutex_init(&tps65910->io_mutex);
 
+	tps65910->regmap = regmap_init_i2c(i2c, &rc5t583_regmap_config);
+	if (IS_ERR(tps65910->regmap)) {
+		ret = PTR_ERR(tps65910->regmap);
+		dev_err(&i2c->dev, "regmap initialization failed: %d\n", ret);
+		goto regmap_err;
+	}
+
 	ret = mfd_add_devices(tps65910->dev, -1,
 			      tps65910s, ARRAY_SIZE(tps65910s),
 			      NULL, 0);
@@ -178,6 +144,8 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 	return ret;
 
 err:
+	regmap_exit(tps65910->regmap);
+regmap_err:
 	kfree(tps65910);
 	kfree(init_data);
 	return ret;
@@ -189,6 +157,7 @@ static int tps65910_i2c_remove(struct i2c_client *i2c)
 
 	tps65910_irq_exit(tps65910);
 	mfd_remove_devices(tps65910->dev);
+	regmap_exit(tps65910->regmap);
 	kfree(tps65910);
 
 	return 0;
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 5c76b96..9b24dcb 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -805,6 +805,7 @@ struct tps65910_board {
 struct tps65910 {
 	struct device *dev;
 	struct i2c_client *i2c_client;
+	struct regmap *regmap;
 	struct mutex io_mutex;
 	unsigned int id;
 	int (*read)(struct tps65910 *tps65910, u8 reg, int size, void *dest);
-- 
1.7.1.1

