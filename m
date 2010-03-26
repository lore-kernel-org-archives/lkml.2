Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0CZUow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:44:52 -0400
Received: from fischerfamily.org ([71.216.156.246]:23889 "EHLO gw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753605Ab0CZUor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:44:47 -0400
From: Todd Fischer <todd.fischer@ridgerun.com>
To: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       todd.fischer@ridgerun.com
Subject: [PATCH 5/5] Move TPS6507x regulator driver from being stand-alone to using the MFD TPS6507x driver
Date: Fri, 26 Mar 2010 14:11:32 -0600
Message-Id: <1269634292-29686-6-git-send-email-todd.fischer@ridgerun.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1269634292-29686-5-git-send-email-todd.fischer@ridgerun.com>
References: <1269634292-29686-1-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-2-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-3-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-4-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-5-git-send-email-todd.fischer@ridgerun.com>
Organization: RidgeRun
X-SA-Exim-Connect-IP: 10.0.0.3
X-SA-Exim-Mail-From: todd.fischer@ridgerun.com
X-SA-Exim-Scanned: No (on gw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move TPS6507x regulator driver from being stand-alone to using 
the MFD TPS6507x driver.

Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>
---
 drivers/mfd/tps6507x.c                 |    1 +
 drivers/regulator/tps6507x-regulator.c |  153 +++++++++++++++----------------
 include/linux/mfd/tps6507.h           |    3 +
 3 files changed, 78 insertions(+), 79 deletions(-)

diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
index f0c2695..ff20037 100644
--- a/drivers/mfd/tps6507x.c
+++ b/drivers/mfd/tps6507x.c
@@ -27,6 +27,7 @@ struct tps_sub_devices {
 };
 
 static struct tps_sub_devices tps6507x_sub_devices[] = {
+	{ "tps6507x-pmic", NULL },
 	{ NULL, NULL }
 };
 
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 30211fb..0a754df 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -22,7 +22,6 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
-#include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/mfd/tps6507x.h>
 
@@ -103,22 +102,67 @@ struct tps_info {
 	const u16 *table;
 };
 
+static const struct tps_info tps6507x_pmic_regs[] = {
+	{
+		.name = "VDCDC1",
+		.min_uV = 725000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(VDCDCx_VSEL_table),
+		.table = VDCDCx_VSEL_table,
+	},
+	{
+		.name = "VDCDC2",
+		.min_uV = 725000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(VDCDCx_VSEL_table),
+		.table = VDCDCx_VSEL_table,
+	},
+	{
+		.name = "VDCDC3",
+		.min_uV = 725000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(VDCDCx_VSEL_table),
+		.table = VDCDCx_VSEL_table,
+	},
+	{
+		.name = "LDO1",
+		.min_uV = 1000000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(LDO1_VSEL_table),
+		.table = LDO1_VSEL_table,
+	},
+	{
+		.name = "LDO2",
+		.min_uV = 725000,
+		.max_uV = 3300000,
+		.table_len = ARRAY_SIZE(LDO2_VSEL_table),
+		.table = LDO2_VSEL_table,
+	},
+};
+
 struct tps6507x_pmic {
 	struct regulator_desc desc[TPS6507X_NUM_REGULATOR];
-	struct i2c_client *client;
+	struct tps6507x_dev *mfd;
 	struct regulator_dev *rdev[TPS6507X_NUM_REGULATOR];
 	const struct tps_info *info[TPS6507X_NUM_REGULATOR];
 	struct mutex io_lock;
 };
-
 static inline int tps6507x_pmic_read(struct tps6507x_pmic *tps, u8 reg)
 {
-	return i2c_smbus_read_byte_data(tps->client, reg);
+	u8 val;
+	int err;
+
+	err = tps->mfd->read_dev(tps->mfd, reg, 1, &val);
+
+	if (err)
+		return err;
+
+	return val;
 }
 
 static inline int tps6507x_pmic_write(struct tps6507x_pmic *tps, u8 reg, u8 val)
 {
-	return i2c_smbus_write_byte_data(tps->client, reg, val);
+	return tps->mfd->write_dev(tps->mfd, reg, 1, &val);
 }
 
 static int tps6507x_pmic_set_bits(struct tps6507x_pmic *tps, u8 reg, u8 mask)
@@ -129,7 +173,7 @@ static int tps6507x_pmic_set_bits(struct tps6507x_pmic *tps, u8 reg, u8 mask)
 
 	data = tps6507x_pmic_read(tps, reg);
 	if (data < 0) {
-		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
+		dev_err(tps->mfd->dev, "Read from reg 0x%x failed\n", reg);
 		err = data;
 		goto out;
 	}
@@ -137,7 +181,7 @@ static int tps6507x_pmic_set_bits(struct tps6507x_pmic *tps, u8 reg, u8 mask)
 	data |= mask;
 	err = tps6507x_pmic_write(tps, reg, data);
 	if (err)
-		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
+		dev_err(tps->mfd->dev, "Write for reg 0x%x failed\n", reg);
 
 out:
 	mutex_unlock(&tps->io_lock);
@@ -152,7 +196,7 @@ static int tps6507x_pmic_clear_bits(struct tps6507x_pmic *tps, u8 reg, u8 mask)
 
 	data = tps6507x_pmic_read(tps, reg);
 	if (data < 0) {
-		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
+		dev_err(tps->mfd->dev, "Read from reg 0x%x failed\n", reg);
 		err = data;
 		goto out;
 	}
@@ -160,7 +204,7 @@ static int tps6507x_pmic_clear_bits(struct tps6507x_pmic *tps, u8 reg, u8 mask)
 	data &= ~mask;
 	err = tps6507x_pmic_write(tps, reg, data);
 	if (err)
-		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
+		dev_err(tps->mfd->dev, "Write for reg 0x%x failed\n", reg);
 
 out:
 	mutex_unlock(&tps->io_lock);
@@ -175,7 +219,7 @@ static int tps6507x_pmic_reg_read(struct tps6507x_pmic *tps, u8 reg)
 
 	data = tps6507x_pmic_read(tps, reg);
 	if (data < 0)
-		dev_err(&tps->client->dev, "Read from reg 0x%x failed\n", reg);
+		dev_err(tps->mfd->dev, "Read from reg 0x%x failed\n", reg);
 
 	mutex_unlock(&tps->io_lock);
 	return data;
@@ -189,7 +233,7 @@ static int tps6507x_pmic_reg_write(struct tps6507x_pmic *tps, u8 reg, u8 val)
 
 	err = tps6507x_pmic_write(tps, reg, val);
 	if (err < 0)
-		dev_err(&tps->client->dev, "Write for reg 0x%x failed\n", reg);
+		dev_err(tps->mfd->dev, "Write for reg 0x%x failed\n", reg);
 
 	mutex_unlock(&tps->io_lock);
 	return err;
@@ -482,11 +526,12 @@ static struct regulator_ops tps6507x_pmic_ldo_ops = {
 	.list_voltage = tps6507x_pmic_ldo_list_voltage,
 };
 
-static int __devinit tps6507x_pmic_probe(struct i2c_client *client,
-				     const struct i2c_device_id *id)
+static __devinit
+int tps6507x_pmic_probe(struct platform_device *pdev)
 {
+	struct tps6507x_dev *tps6507x_dev = platform_get_drvdata(pdev);
 	static int desc_id;
-	const struct tps_info *info = (void *)id->driver_data;
+	const struct tps_info *info = &tps6507x_pmic_regs[0];
 	struct regulator_init_data *init_data;
 	struct regulator_dev *rdev;
 	struct tps6507x_pmic *tps;
@@ -494,16 +539,12 @@ static int __devinit tps6507x_pmic_probe(struct i2c_client *client,
 	int i;
 	int error;
 
-	if (!i2c_check_functionality(client->adapter,
-				I2C_FUNC_SMBUS_BYTE_DATA))
-		return -EIO;
-
 	/**
 	 * tps_board points to pmic related constants
 	 * coming from the board-evm file.
 	 */
 
-	tps_board = (struct tps6507x_board *)client->dev.platform_data;
+	tps_board = (struct tps6507x_board *)tps6507x_dev->dev->platform_data;
 	if (!tps_board)
 		return -EIO;
 
@@ -522,7 +563,7 @@ static int __devinit tps6507x_pmic_probe(struct i2c_client *client,
 	mutex_init(&tps->io_lock);
 
 	/* common for all regulators */
-	tps->client = client;
+	tps->mfd = tps6507x_dev;
 
 	for (i = 0; i < TPS6507X_NUM_REGULATOR; i++, info++, init_data++) {
 		/* Register the regulators */
@@ -536,10 +577,11 @@ static int __devinit tps6507x_pmic_probe(struct i2c_client *client,
 		tps->desc[i].owner = THIS_MODULE;
 
 		rdev = regulator_register(&tps->desc[i],
-					&client->dev, init_data, tps);
+					tps6507x_dev->dev, init_data, tps);
 		if (IS_ERR(rdev)) {
-			dev_err(&client->dev, "failed to register %s\n",
-				id->name);
+			dev_err(tps6507x_dev->dev,
+				"failed to register %s regulator\n",
+				pdev->name);
 			error = PTR_ERR(rdev);
 			goto fail;
 		}
@@ -548,7 +590,7 @@ static int __devinit tps6507x_pmic_probe(struct i2c_client *client,
 		tps->rdev[i] = rdev;
 	}
 
-	i2c_set_clientdata(client, tps);
+	tps6507x_dev->pmic = tps;
 
 	return 0;
 
@@ -566,14 +608,12 @@ fail:
  *
  * Unregister TPS driver as an i2c client device driver
  */
-static int __devexit tps6507x_pmic_remove(struct i2c_client *client)
+static int __devexit tps6507x_pmic_remove(struct platform_device *pdev)
 {
-	struct tps6507x_pmic *tps = i2c_get_clientdata(client);
+	struct tps6507x_dev *tps6507x_dev = platform_get_drvdata(pdev);
+	struct tps6507x_pmic *tps = tps6507x_dev->pmic;
 	int i;
 
-	/* clear the client data in i2c */
-	i2c_set_clientdata(client, NULL);
-
 	for (i = 0; i < TPS6507X_NUM_REGULATOR; i++)
 		regulator_unregister(tps->rdev[i]);
 
@@ -582,59 +622,13 @@ static int __devexit tps6507x_pmic_remove(struct i2c_client *client)
 	return 0;
 }
 
-static const struct tps_info tps6507x_pmic_regs[] = {
-	{
-		.name = "VDCDC1",
-		.min_uV = 725000,
-		.max_uV = 3300000,
-		.table_len = ARRAY_SIZE(VDCDCx_VSEL_table),
-		.table = VDCDCx_VSEL_table,
-	},
-	{
-		.name = "VDCDC2",
-		.min_uV = 725000,
-		.max_uV = 3300000,
-		.table_len = ARRAY_SIZE(VDCDCx_VSEL_table),
-		.table = VDCDCx_VSEL_table,
-	},
-	{
-		.name = "VDCDC3",
-		.min_uV = 725000,
-		.max_uV = 3300000,
-		.table_len = ARRAY_SIZE(VDCDCx_VSEL_table),
-		.table = VDCDCx_VSEL_table,
-	},
-	{
-		.name = "LDO1",
-		.min_uV = 1000000,
-		.max_uV = 3300000,
-		.table_len = ARRAY_SIZE(LDO1_VSEL_table),
-		.table = LDO1_VSEL_table,
-	},
-	{
-		.name = "LDO2",
-		.min_uV = 725000,
-		.max_uV = 3300000,
-		.table_len = ARRAY_SIZE(LDO2_VSEL_table),
-		.table = LDO2_VSEL_table,
-	},
-};
-
-static const struct i2c_device_id tps6507x_pmic_id[] = {
-	{.name = "tps6507x",
-	.driver_data = (unsigned long) tps6507x_pmic_regs,},
-	{ },
-};
-MODULE_DEVICE_TABLE(i2c, tps6507x_pmic_id);
-
-static struct i2c_driver tps6507x_i2c_driver = {
+static struct platform_driver tps6507x_pmic_driver = {
 	.driver = {
-		.name = "tps6507x",
+		.name = "tps6507x-pmic",
 		.owner = THIS_MODULE,
 	},
 	.probe = tps6507x_pmic_probe,
 	.remove = __devexit_p(tps6507x_pmic_remove),
-	.id_table = tps6507x_pmic_id,
 };
 
 /**
@@ -644,7 +638,7 @@ static struct i2c_driver tps6507x_i2c_driver = {
  */
 static int __init tps6507x_pmic_init(void)
 {
-	return i2c_add_driver(&tps6507x_i2c_driver);
+	return platform_driver_register(&tps6507x_pmic_driver);
 }
 subsys_initcall(tps6507x_pmic_init);
 
@@ -655,10 +649,11 @@ subsys_initcall(tps6507x_pmic_init);
  */
 static void __exit tps6507x_pmic_cleanup(void)
 {
-	i2c_del_driver(&tps6507x_i2c_driver);
+	platform_driver_unregister(&tps6507x_pmic_driver);
 }
 module_exit(tps6507x_pmic_cleanup);
 
 MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("TPS6507x voltage regulator driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tps6507x-pmic");
diff --git a/include/linux/mfd/tps6507x.h b/include/linux/mfd/tps6507x.h
index 46c3331..6ff0dae 100644
--- a/include/linux/mfd/tps6507x.h
+++ b/include/linux/mfd/tps6507x.h
@@ -160,6 +160,9 @@ struct tps6507x_dev {
 	int (*write_dev)(struct tps6507x_dev *tps6507x, char reg, int size,
 			 void *src);
 	struct mutex adc_mutex;
+
+	/* Client devices */
+	struct tps6507x_pmic *pmic;
 };
 
 #endif /*  __LINUX_MFD_TPS6507X_H */
-- 
1.6.0.4

