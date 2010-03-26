Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab0CZUol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:44:41 -0400
Received: from fischerfamily.org ([71.216.156.246]:23869 "EHLO gw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752837Ab0CZUoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:44:38 -0400
X-Greylist: delayed 2017 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Mar 2010 16:44:37 EDT
From: Todd Fischer <todd.fischer@ridgerun.com>
To: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       todd.fischer@ridgerun.com
Subject: [PATCH 4/5] Cleaned up name space so each MFD sub-driver uses a different name space.
Date: Fri, 26 Mar 2010 14:11:31 -0600
Message-Id: <1269634292-29686-5-git-send-email-todd.fischer@ridgerun.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1269634292-29686-4-git-send-email-todd.fischer@ridgerun.com>
References: <1269634292-29686-1-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-2-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-3-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-4-git-send-email-todd.fischer@ridgerun.com>
Organization: RidgeRun
X-SA-Exim-Connect-IP: 10.0.0.3
X-SA-Exim-Mail-From: todd.fischer@ridgerun.com
X-SA-Exim-Scanned: No (on gw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move from using tps or tsp6507x to tps6057x_pmic in a consistent
manner.

Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>
---
 drivers/regulator/tps6507x-regulator.c |  172 ++++++++++++++++----------------
 1 files changed, 87 insertions(+), 85 deletions(-)

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 27f4e7a..30211fb 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -103,7 +103,7 @@ struct tps_info {
 	const u16 *table;
 };
 
-struct tps_pmic {
+struct tps6507x_pmic {
 	struct regulator_desc desc[TPS6507X_NUM_REGULATOR];
 	struct i2c_client *client;
 	struct regulator_dev *rdev[TPS6507X_NUM_REGULATOR];
@@ -111,23 +111,23 @@ struct tps_pmic {
 	struct mutex io_lock;
 };
 
-static inline int tps_6507x_read(struct tps_pmic *tps, u8 reg)
+static inline int tps6507x_pmic_read(struct tps6507x_pmic *tps, u8 reg)
 {
 	return i2c_smbus_read_byte_data(tps->client, reg);
 }
 
-static inline int tps_6507x_write(struct tps_pmic *tps, u8 reg, u8 val)
+static inline int tps6507x_pmic_write(struct tps6507x_pmic *tps, u8 reg, u8 val)
 {
 	return i2c_smbus_write_byte_data(tps->client, reg, val);
 }
 
-static int tps_6507x_set_bits(struct tps_pmic *tps, u8 reg, u8 mask)
+static int tps6507x_pmic_set_bits(struct tps6507x_pmic *tps, u8 reg, u8 mask)
 {
 	int err, data;
 
 	mutex_lock(&tps->io_lock);
 
-	data = tps_6507x_read(tps, reg);
+	data = tps6507x_pmic_read(tps, reg);
 	if (data < 0) {
 		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
 		err = data;
@@ -135,7 +135,7 @@ static int tps_6507x_set_bits(struct tps_pmic *tps, u8 reg, u8 mask)
 	}
 
 	data |= mask;
-	err = tps_6507x_write(tps, reg, data);
+	err = tps6507x_pmic_write(tps, reg, data);
 	if (err)
 		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
 
@@ -144,13 +144,13 @@ out:
 	return err;
 }
 
-static int tps_6507x_clear_bits(struct tps_pmic *tps, u8 reg, u8 mask)
+static int tps6507x_pmic_clear_bits(struct tps6507x_pmic *tps, u8 reg, u8 mask)
 {
 	int err, data;
 
 	mutex_lock(&tps->io_lock);
 
-	data = tps_6507x_read(tps, reg);
+	data = tps6507x_pmic_read(tps, reg);
 	if (data < 0) {
 		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
 		err = data;
@@ -158,7 +158,7 @@ static int tps_6507x_clear_bits(struct tps_pmic *tps, u8 reg, u8 mask)
 	}
 
 	data &= ~mask;
-	err = tps_6507x_write(tps, reg, data);
+	err = tps6507x_pmic_write(tps, reg, data);
 	if (err)
 		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
 
@@ -167,13 +167,13 @@ out:
 	return err;
 }
 
-static int tps_6507x_reg_read(struct tps_pmic *tps, u8 reg)
+static int tps6507x_pmic_reg_read(struct tps6507x_pmic *tps, u8 reg)
 {
 	int data;
 
 	mutex_lock(&tps->io_lock);
 
-	data = tps_6507x_read(tps, reg);
+	data = tps6507x_pmic_read(tps, reg);
 	if (data < 0)
 		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
 
@@ -181,13 +181,13 @@ static int tps_6507x_reg_read(struct tps_pmic *tps, u8 reg)
 	return data;
 }
 
-static int tps_6507x_reg_write(struct tps_pmic *tps, u8 reg, u8 val)
+static int tps6507x_pmic_reg_write(struct tps6507x_pmic *tps, u8 reg, u8 val)
 {
 	int err;
 
 	mutex_lock(&tps->io_lock);
 
-	err = tps_6507x_write(tps, reg, val);
+	err = tps6507x_pmic_write(tps, reg, val);
 	if (err < 0)
 		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
 
@@ -195,9 +195,9 @@ static int tps_6507x_reg_write(struct tps_pmic *tps, u8 reg, u8 val)
 	return err;
 }
 
-static int tps6507x_dcdc_is_enabled(struct regulator_dev *dev)
+static int tps6507x_pmic_dcdc_is_enabled(struct regulator_dev *dev)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int data, dcdc = rdev_get_id(dev);
 	u8 shift;
 
@@ -205,7 +205,7 @@ static int tps6507x_dcdc_is_enabled(struct regulator_dev *dev)
 		return -EINVAL;
 
 	shift = TPS6507X_MAX_REG_ID - dcdc;
-	data = tps_6507x_reg_read(tps, TPS6507X_REG_CON_CTRL1);
+	data = tps6507x_pmic_reg_read(tps, TPS6507X_REG_CON_CTRL1);
 
 	if (data < 0)
 		return data;
@@ -213,9 +213,9 @@ static int tps6507x_dcdc_is_enabled(struct regulator_dev *dev)
 		return (data & 1<<shift) ? 1 : 0;
 }
 
-static int tps6507x_ldo_is_enabled(struct regulator_dev *dev)
+static int tps6507x_pmic_ldo_is_enabled(struct regulator_dev *dev)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int data, ldo = rdev_get_id(dev);
 	u8 shift;
 
@@ -223,7 +223,7 @@ static int tps6507x_ldo_is_enabled(struct regulator_dev *dev)
 		return -EINVAL;
 
 	shift = TPS6507X_MAX_REG_ID - ldo;
-	data = tps_6507x_reg_read(tps, TPS6507X_REG_CON_CTRL1);
+	data = tps6507x_pmic_reg_read(tps, TPS6507X_REG_CON_CTRL1);
 
 	if (data < 0)
 		return data;
@@ -231,9 +231,9 @@ static int tps6507x_ldo_is_enabled(struct regulator_dev *dev)
 		return (data & 1<<shift) ? 1 : 0;
 }
 
-static int tps6507x_dcdc_enable(struct regulator_dev *dev)
+static int tps6507x_pmic_dcdc_enable(struct regulator_dev *dev)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int dcdc = rdev_get_id(dev);
 	u8 shift;
 
@@ -241,12 +241,12 @@ static int tps6507x_dcdc_enable(struct regulator_dev *dev)
 		return -EINVAL;
 
 	shift = TPS6507X_MAX_REG_ID - dcdc;
-	return tps_6507x_set_bits(tps, TPS6507X_REG_CON_CTRL1, 1 << shift);
+	return tps6507x_pmic_set_bits(tps, TPS6507X_REG_CON_CTRL1, 1 << shift);
 }
 
-static int tps6507x_dcdc_disable(struct regulator_dev *dev)
+static int tps6507x_pmic_dcdc_disable(struct regulator_dev *dev)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int dcdc = rdev_get_id(dev);
 	u8 shift;
 
@@ -254,12 +254,13 @@ static int tps6507x_dcdc_disable(struct regulator_dev *dev)
 		return -EINVAL;
 
 	shift = TPS6507X_MAX_REG_ID - dcdc;
-	return tps_6507x_clear_bits(tps, TPS6507X_REG_CON_CTRL1, 1 << shift);
+	return tps6507x_pmic_clear_bits(tps, TPS6507X_REG_CON_CTRL1,
+					1 << shift);
 }
 
-static int tps6507x_ldo_enable(struct regulator_dev *dev)
+static int tps6507x_pmic_ldo_enable(struct regulator_dev *dev)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int ldo = rdev_get_id(dev);
 	u8 shift;
 
@@ -267,12 +268,12 @@ static int tps6507x_ldo_enable(struct regulator_dev *dev)
 		return -EINVAL;
 
 	shift = TPS6507X_MAX_REG_ID - ldo;
-	return tps_6507x_set_bits(tps, TPS6507X_REG_CON_CTRL1, 1 << shift);
+	return tps6507x_pmic_set_bits(tps, TPS6507X_REG_CON_CTRL1, 1 << shift);
 }
 
-static int tps6507x_ldo_disable(struct regulator_dev *dev)
+static int tps6507x_pmic_ldo_disable(struct regulator_dev *dev)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int ldo = rdev_get_id(dev);
 	u8 shift;
 
@@ -280,12 +281,13 @@ static int tps6507x_ldo_disable(struct regulator_dev *dev)
 		return -EINVAL;
 
 	shift = TPS6507X_MAX_REG_ID - ldo;
-	return tps_6507x_clear_bits(tps, TPS6507X_REG_CON_CTRL1, 1 << shift);
+	return tps6507x_pmic_clear_bits(tps, TPS6507X_REG_CON_CTRL1,
+					1 << shift);
 }
 
-static int tps6507x_dcdc_get_voltage(struct regulator_dev *dev)
+static int tps6507x_pmic_dcdc_get_voltage(struct regulator_dev *dev)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int data, dcdc = rdev_get_id(dev);
 	u8 reg;
 
@@ -303,7 +305,7 @@ static int tps6507x_dcdc_get_voltage(struct regulator_dev *dev)
 		return -EINVAL;
 	}
 
-	data = tps_6507x_reg_read(tps, reg);
+	data = tps6507x_pmic_reg_read(tps, reg);
 	if (data < 0)
 		return data;
 
@@ -311,10 +313,10 @@ static int tps6507x_dcdc_get_voltage(struct regulator_dev *dev)
 	return tps->info[dcdc]->table[data] * 1000;
 }
 
-static int tps6507x_dcdc_set_voltage(struct regulator_dev *dev,
+static int tps6507x_pmic_dcdc_set_voltage(struct regulator_dev *dev,
 				int min_uV, int max_uV)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int data, vsel, dcdc = rdev_get_id(dev);
 	u8 reg;
 
@@ -352,19 +354,19 @@ static int tps6507x_dcdc_set_voltage(struct regulator_dev *dev,
 	if (vsel == tps->info[dcdc]->table_len)
 		return -EINVAL;
 
-	data = tps_6507x_reg_read(tps, reg);
+	data = tps6507x_pmic_reg_read(tps, reg);
 	if (data < 0)
 		return data;
 
 	data &= ~TPS6507X_DEFDCDCX_DCDC_MASK;
 	data |= vsel;
 
-	return tps_6507x_reg_write(tps, reg, data);
+	return tps6507x_pmic_reg_write(tps, reg, data);
 }
 
-static int tps6507x_ldo_get_voltage(struct regulator_dev *dev)
+static int tps6507x_pmic_ldo_get_voltage(struct regulator_dev *dev)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int data, ldo = rdev_get_id(dev);
 	u8 reg, mask;
 
@@ -378,7 +380,7 @@ static int tps6507x_ldo_get_voltage(struct regulator_dev *dev)
 				TPS6507X_REG_DEFLDO2_LDO2_MASK);
 	}
 
-	data = tps_6507x_reg_read(tps, reg);
+	data = tps6507x_pmic_reg_read(tps, reg);
 	if (data < 0)
 		return data;
 
@@ -386,10 +388,10 @@ static int tps6507x_ldo_get_voltage(struct regulator_dev *dev)
 	return tps->info[ldo]->table[data] * 1000;
 }
 
-static int tps6507x_ldo_set_voltage(struct regulator_dev *dev,
+static int tps6507x_pmic_ldo_set_voltage(struct regulator_dev *dev,
 				int min_uV, int max_uV)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int data, vsel, ldo = rdev_get_id(dev);
 	u8 reg, mask;
 
@@ -420,20 +422,20 @@ static int tps6507x_ldo_set_voltage(struct regulator_dev *dev,
 	if (vsel == tps->info[ldo]->table_len)
 		return -EINVAL;
 
-	data = tps_6507x_reg_read(tps, reg);
+	data = tps6507x_pmic_reg_read(tps, reg);
 	if (data < 0)
 		return data;
 
 	data &= ~mask;
 	data |= vsel;
 
-	return tps_6507x_reg_write(tps, reg, data);
+	return tps6507x_pmic_reg_write(tps, reg, data);
 }
 
-static int tps6507x_dcdc_list_voltage(struct regulator_dev *dev,
+static int tps6507x_pmic_dcdc_list_voltage(struct regulator_dev *dev,
 					unsigned selector)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int dcdc = rdev_get_id(dev);
 
 	if (dcdc < TPS6507X_DCDC_1 || dcdc > TPS6507X_DCDC_3)
@@ -445,10 +447,10 @@ static int tps6507x_dcdc_list_voltage(struct regulator_dev *dev,
 		return tps->info[dcdc]->table[selector] * 1000;
 }
 
-static int tps6507x_ldo_list_voltage(struct regulator_dev *dev,
+static int tps6507x_pmic_ldo_list_voltage(struct regulator_dev *dev,
 					unsigned selector)
 {
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
+	struct tps6507x_pmic *tps = rdev_get_drvdata(dev);
 	int ldo = rdev_get_id(dev);
 
 	if (ldo < TPS6507X_LDO_1 || ldo > TPS6507X_LDO_2)
@@ -461,33 +463,33 @@ static int tps6507x_ldo_list_voltage(struct regulator_dev *dev,
 }
 
 /* Operations permitted on VDCDCx */
-static struct regulator_ops tps6507x_dcdc_ops = {
-	.is_enabled = tps6507x_dcdc_is_enabled,
-	.enable = tps6507x_dcdc_enable,
-	.disable = tps6507x_dcdc_disable,
-	.get_voltage = tps6507x_dcdc_get_voltage,
-	.set_voltage = tps6507x_dcdc_set_voltage,
-	.list_voltage = tps6507x_dcdc_list_voltage,
+static struct regulator_ops tps6507x_pmic_dcdc_ops = {
+	.is_enabled = tps6507x_pmic_dcdc_is_enabled,
+	.enable = tps6507x_pmic_dcdc_enable,
+	.disable = tps6507x_pmic_dcdc_disable,
+	.get_voltage = tps6507x_pmic_dcdc_get_voltage,
+	.set_voltage = tps6507x_pmic_dcdc_set_voltage,
+	.list_voltage = tps6507x_pmic_dcdc_list_voltage,
 };
 
 /* Operations permitted on LDOx */
-static struct regulator_ops tps6507x_ldo_ops = {
-	.is_enabled = tps6507x_ldo_is_enabled,
-	.enable = tps6507x_ldo_enable,
-	.disable = tps6507x_ldo_disable,
-	.get_voltage = tps6507x_ldo_get_voltage,
-	.set_voltage = tps6507x_ldo_set_voltage,
-	.list_voltage = tps6507x_ldo_list_voltage,
+static struct regulator_ops tps6507x_pmic_ldo_ops = {
+	.is_enabled = tps6507x_pmic_ldo_is_enabled,
+	.enable = tps6507x_pmic_ldo_enable,
+	.disable = tps6507x_pmic_ldo_disable,
+	.get_voltage = tps6507x_pmic_ldo_get_voltage,
+	.set_voltage = tps6507x_pmic_ldo_set_voltage,
+	.list_voltage = tps6507x_pmic_ldo_list_voltage,
 };
 
-static int __devinit tps_6507x_probe(struct i2c_client *client,
+static int __devinit tps6507x_pmic_probe(struct i2c_client *client,
 				     const struct i2c_device_id *id)
 {
 	static int desc_id;
 	const struct tps_info *info = (void *)id->driver_data;
 	struct regulator_init_data *init_data;
 	struct regulator_dev *rdev;
-	struct tps_pmic *tps;
+	struct tps6507x_pmic *tps;
 	struct tps6507x_board *tps_board;
 	int i;
 	int error;
@@ -529,7 +531,7 @@ static int __devinit tps_6507x_probe(struct i2c_client *client,
 		tps->desc[i].id = desc_id++;
 		tps->desc[i].n_voltages = num_voltages[i];
 		tps->desc[i].ops = (i > TPS6507X_DCDC_3 ?
-				&tps6507x_ldo_ops : &tps6507x_dcdc_ops);
+		&tps6507x_pmic_ldo_ops : &tps6507x_pmic_dcdc_ops);
 		tps->desc[i].type = REGULATOR_VOLTAGE;
 		tps->desc[i].owner = THIS_MODULE;
 
@@ -559,14 +561,14 @@ fail:
 }
 
 /**
- * tps_6507x_remove - TPS6507x driver i2c remove handler
+ * tps6507x_remove - TPS6507x driver i2c remove handler
  * @client: i2c driver client device structure
  *
  * Unregister TPS driver as an i2c client device driver
  */
-static int __devexit tps_6507x_remove(struct i2c_client *client)
+static int __devexit tps6507x_pmic_remove(struct i2c_client *client)
 {
-	struct tps_pmic *tps = i2c_get_clientdata(client);
+	struct tps6507x_pmic *tps = i2c_get_clientdata(client);
 	int i;
 
 	/* clear the client data in i2c */
@@ -580,7 +582,7 @@ static int __devexit tps_6507x_remove(struct i2c_client *client)
 	return 0;
 }
 
-static const struct tps_info tps6507x_regs[] = {
+static const struct tps_info tps6507x_pmic_regs[] = {
 	{
 		.name = "VDCDC1",
 		.min_uV = 725000,
@@ -618,44 +620,44 @@ static const struct tps_info tps6507x_regs[] = {
 	},
 };
 
-static const struct i2c_device_id tps_6507x_id[] = {
+static const struct i2c_device_id tps6507x_pmic_id[] = {
 	{.name = "tps6507x",
-	.driver_data = (unsigned long) tps6507x_regs,},
+	.driver_data = (unsigned long) tps6507x_pmic_regs,},
 	{ },
 };
-MODULE_DEVICE_TABLE(i2c, tps_6507x_id);
+MODULE_DEVICE_TABLE(i2c, tps6507x_pmic_id);
 
-static struct i2c_driver tps_6507x_i2c_driver = {
+static struct i2c_driver tps6507x_i2c_driver = {
 	.driver = {
 		.name = "tps6507x",
 		.owner = THIS_MODULE,
 	},
-	.probe = tps_6507x_probe,
-	.remove = __devexit_p(tps_6507x_remove),
-	.id_table = tps_6507x_id,
+	.probe = tps6507x_pmic_probe,
+	.remove = __devexit_p(tps6507x_pmic_remove),
+	.id_table = tps6507x_pmic_id,
 };
 
 /**
- * tps_6507x_init
+ * tps6507x_pmic_init
  *
  * Module init function
  */
-static int __init tps_6507x_init(void)
+static int __init tps6507x_pmic_init(void)
 {
-	return i2c_add_driver(&tps_6507x_i2c_driver);
+	return i2c_add_driver(&tps6507x_i2c_driver);
 }
-subsys_initcall(tps_6507x_init);
+subsys_initcall(tps6507x_pmic_init);
 
 /**
- * tps_6507x_cleanup
+ * tps6507x_pmic_cleanup
  *
  * Module exit function
  */
-static void __exit tps_6507x_cleanup(void)
+static void __exit tps6507x_pmic_cleanup(void)
 {
-	i2c_del_driver(&tps_6507x_i2c_driver);
+	i2c_del_driver(&tps6507x_i2c_driver);
 }
-module_exit(tps_6507x_cleanup);
+module_exit(tps6507x_pmic_cleanup);
 
 MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("TPS6507x voltage regulator driver");
-- 
1.6.0.4

