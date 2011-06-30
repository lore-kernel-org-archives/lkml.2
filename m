Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab1F3GA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 02:00:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54296 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751320Ab1F3GAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 02:00:46 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 8/8] regulator: Convert tps65023 to use regmap API
Date: Wed, 29 Jun 2011 23:00:36 -0700
Message-Id: <1309413636-1169-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309413636-1169-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110630055844.GC796@opensource.wolfsonmicro.com>
 <1309413636-1169-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Kconfig              |    1 +
 drivers/regulator/tps65023-regulator.c |   98 +++++++++-----------------------
 2 files changed, 28 insertions(+), 71 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index a1dffd9..5e8707a 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -235,6 +235,7 @@ config REGULATOR_TPS6105X
 config REGULATOR_TPS65023
 	tristate "TI TPS65023 Power regulators"
 	depends on I2C
+	select REGMAP
 	help
 	  This driver supports TPS65023 voltage regulator chips. TPS65023 provides
 	  three step-down converters and two general-purpose LDO voltage regulators.
diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index fbddc15..3fa3ba5 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -25,6 +25,7 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/regmap.h>
 
 /* Register definitions */
 #define	TPS65023_REG_VERSION		0
@@ -125,93 +126,35 @@ struct tps_pmic {
 	struct i2c_client *client;
 	struct regulator_dev *rdev[TPS65023_NUM_REGULATOR];
 	const struct tps_info *info[TPS65023_NUM_REGULATOR];
-	struct mutex io_lock;
+	struct regmap *regmap;
 };
 
-static inline int tps_65023_read(struct tps_pmic *tps, u8 reg)
-{
-	return i2c_smbus_read_byte_data(tps->client, reg);
-}
-
-static inline int tps_65023_write(struct tps_pmic *tps, u8 reg, u8 val)
-{
-	return i2c_smbus_write_byte_data(tps->client, reg, val);
-}
-
 static int tps_65023_set_bits(struct tps_pmic *tps, u8 reg, u8 mask)
 {
-	int err, data;
-
-	mutex_lock(&tps->io_lock);
-
-	data = tps_65023_read(tps, reg);
-	if (data < 0) {
-		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
-		err = data;
-		goto out;
-	}
-
-	data |= mask;
-	err = tps_65023_write(tps, reg, data);
-	if (err)
-		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
-
-out:
-	mutex_unlock(&tps->io_lock);
-	return err;
+	return regmap_update_bits(tps->regmap, reg, mask, mask);
 }
 
 static int tps_65023_clear_bits(struct tps_pmic *tps, u8 reg, u8 mask)
 {
-	int err, data;
-
-	mutex_lock(&tps->io_lock);
-
-	data = tps_65023_read(tps, reg);
-	if (data < 0) {
-		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
-		err = data;
-		goto out;
-	}
-
-	data &= ~mask;
-
-	err = tps_65023_write(tps, reg, data);
-	if (err)
-		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
-
-out:
-	mutex_unlock(&tps->io_lock);
-	return err;
-
+	return regmap_update_bits(tps->regmap, reg, mask, 0);
 }
 
 static int tps_65023_reg_read(struct tps_pmic *tps, u8 reg)
 {
-	int data;
+	unsigned int val;
+	int ret;
 
-	mutex_lock(&tps->io_lock);
+	ret = regmap_read(tps->regmap, reg, &val);
 
-	data = tps_65023_read(tps, reg);
-	if (data < 0)
-		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
-
-	mutex_unlock(&tps->io_lock);
-	return data;
+	if (ret != 0)
+		return ret;
+	else
+		return val;
 }
 
 static int tps_65023_reg_write(struct tps_pmic *tps, u8 reg, u8 val)
 {
-	int err;
-
-	mutex_lock(&tps->io_lock);
-
-	err = tps_65023_write(tps, reg, val);
-	if (err < 0)
-		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
-
-	mutex_unlock(&tps->io_lock);
-	return err;
+	return regmap_write(tps->regmap, reg, val);
 }
 
 static int tps65023_dcdc_is_enabled(struct regulator_dev *dev)
@@ -463,6 +406,10 @@ static struct regulator_ops tps65023_ldo_ops = {
 	.list_voltage = tps65023_ldo_list_voltage,
 };
 
+static struct regmap_config tps65023_regmap_config = {
+	.reg_bits = 8, .val_bits = 8,
+};
+
 static int __devinit tps_65023_probe(struct i2c_client *client,
 				     const struct i2c_device_id *id)
 {
@@ -488,7 +435,13 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 	if (!tps)
 		return -ENOMEM;
 
-	mutex_init(&tps->io_lock);
+	tps->regmap = regmap_init(&client->dev, &tps65023_regmap_config);
+	if (IS_ERR(tps->regmap)) {
+		error = PTR_ERR(tps->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+			error);
+		goto fail_alloc;
+	}
 
 	/* common for all regulators */
 	tps->client = client;
@@ -523,10 +476,12 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 
 	return 0;
 
- fail:
+fail:
 	while (--i >= 0)
 		regulator_unregister(tps->rdev[i]);
 
+	regmap_exit(tps->regmap);
+fail_alloc:
 	kfree(tps);
 	return error;
 }
@@ -545,6 +500,7 @@ static int __devexit tps_65023_remove(struct i2c_client *client)
 	for (i = 0; i < TPS65023_NUM_REGULATOR; i++)
 		regulator_unregister(tps->rdev[i]);
 
+	regmap_exit(tps->regmap);
 	kfree(tps);
 
 	return 0;
-- 
1.7.5.4

