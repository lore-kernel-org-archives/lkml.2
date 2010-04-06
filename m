Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab0DFCXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 22:23:45 -0400
Received: from fischerfamily.org ([71.216.156.246]:27854 "EHLO gw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757069Ab0DFCXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 22:23:06 -0400
From: Todd Fischer <todd.fischer@ridgerun.com>
To: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       todd.fischer@ridgerun.com
Subject: [PATCH 4/4]-V3 Add MFD driver for TPS6507x family of multi-function chips and move TPS6507x regulator driver from being stand-alone to using the MFD driver.
Date: Mon,  5 Apr 2010 20:23:59 -0600
Message-Id: <1270520639-20516-5-git-send-email-todd.fischer@ridgerun.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1270520639-20516-4-git-send-email-todd.fischer@ridgerun.com>
References: <1270520639-20516-1-git-send-email-todd.fischer@ridgerun.com>
 <1270520639-20516-2-git-send-email-todd.fischer@ridgerun.com>
 <1270520639-20516-3-git-send-email-todd.fischer@ridgerun.com>
 <1270520639-20516-4-git-send-email-todd.fischer@ridgerun.com>
Organization: RidgeRun
X-SA-Exim-Connect-IP: 10.0.0.3
X-SA-Exim-Mail-From: todd.fischer@ridgerun.com
X-SA-Exim-Scanned: No (on gw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MFD driver for TPS6507x family of multi-function chips.  Move TPS6507x 
regulator driver from being stand-alone driver to using the MFD TPS6507x driver.

Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>
---
 drivers/mfd/Kconfig                    |   12 +++
 drivers/mfd/Makefile                   |    3 +-
 drivers/mfd/tps6507x.c                 |  155 ++++++++++++++++++++++++++++++++
 drivers/regulator/tps6507x-regulator.c |  153 +++++++++++++++----------------
 include/linux/mfd/tps6507x.h           |   22 +++++
 5 files changed, 265 insertions(+), 80 deletions(-)
 create mode 100644 drivers/mfd/tps6507x.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2a5a0b7..1e301ad 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -111,6 +111,18 @@ config TPS65010
 	  This driver can also be built as a module.  If so, the module
 	  will be called tps65010.
 
+config TPS6507X
+	tristate "TPS6507x Power Management / Touch Screen chips"
+	select MFD_CORE
+	depends on I2C
+	help
+	  If you say yes here you get support for the TPS6507x series of
+	  Power Management / Touch Screen chips.  These include voltage
+	  regulators, lithium ion/polymer battery charging, touch screen
+	  and other features that are often used in portable devices.
+	  This driver can also be built as a module.  If so, the module
+	  will be called tps6507x.
+
 config MENELAUS
 	bool "Texas Instruments TWL92330/Menelaus PM chip"
 	depends on I2C=y && ARCH_OMAP2
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 22715ad..2bebc95 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
 obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o
 
 obj-$(CONFIG_TPS65010)		+= tps65010.o
+obj-$(CONFIG_TPS6507X)		+= tps6507x.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
 
 obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
@@ -62,4 +63,4 @@ obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
 obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
-obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
\ No newline at end of file
+obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
new file mode 100644
index 0000000..5bca398
--- /dev/null
+++ b/drivers/mfd/tps6507x.c
@@ -0,0 +1,155 @@
+/*
+ * tps6507x.c  --  TPS6507x chip family multi-function driver
+ *
+ *  Copyright (c) 2010 RidgeRun (todd.fischer@ridgerun.com)
+ *
+ * Author: Todd Fischer
+ *         todd.fischer@ridgerun.com
+ *
+ * Credits:
+ *
+ *    Using code from wm831x-*.c, wm8400-core, Wolfson Microelectronics PLC.
+ *
+ * For licencing details see kernel-base/COPYING
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/tps6507x.h>
+
+static struct mfd_cell tps6507x_devs[] = {
+	{
+		.name = "tps6507x-pmic",
+	},
+};
+
+
+static int tps6507x_i2c_read_device(struct tps6507x_dev *tps6507x, char reg,
+				  int bytes, void *dest)
+{
+	struct i2c_client *i2c = tps6507x->i2c_client;
+	struct i2c_msg xfer[2];
+	int ret;
+
+	/* Write register */
+	xfer[0].addr = i2c->addr;
+	xfer[0].flags = 0;
+	xfer[0].len = 1;
+	xfer[0].buf = &reg;
+
+	/* Read data */
+	xfer[1].addr = i2c->addr;
+	xfer[1].flags = I2C_M_RD;
+	xfer[1].len = bytes;
+	xfer[1].buf = dest;
+
+	ret = i2c_transfer(i2c->adapter, xfer, 2);
+	if (ret == 2)
+		ret = 0;
+	else if (ret >= 0)
+		ret = -EIO;
+
+	return ret;
+}
+
+static int tps6507x_i2c_write_device(struct tps6507x_dev *tps6507x, char reg,
+				   int bytes, void *src)
+{
+	struct i2c_client *i2c = tps6507x->i2c_client;
+	/* we add 1 byte for device register */
+	u8 msg[TPS6507X_MAX_REGISTER + 1];
+	int ret;
+
+	if (bytes > (TPS6507X_MAX_REGISTER + 1))
+		return -EINVAL;
+
+	msg[0] = reg;
+	memcpy(&msg[1], src, bytes);
+
+	ret = i2c_master_send(i2c, msg, bytes + 1);
+	if (ret < 0)
+		return ret;
+	if (ret != bytes + 1)
+		return -EIO;
+	return 0;
+}
+
+static int tps6507x_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct tps6507x_dev *tps6507x;
+	int ret = 0;
+
+	tps6507x = kzalloc(sizeof(struct tps6507x_dev), GFP_KERNEL);
+	if (tps6507x == NULL) {
+		kfree(i2c);
+		return -ENOMEM;
+	}
+
+	i2c_set_clientdata(i2c, tps6507x);
+	tps6507x->dev = &i2c->dev;
+	tps6507x->i2c_client = i2c;
+	tps6507x->read_dev = tps6507x_i2c_read_device;
+	tps6507x->write_dev = tps6507x_i2c_write_device;
+
+	ret = mfd_add_devices(tps6507x->dev, -1,
+			      tps6507x_devs, ARRAY_SIZE(tps6507x_devs),
+			      NULL, 0);
+
+	if (ret < 0)
+		goto err;
+
+	return ret;
+
+err:
+	mfd_remove_devices(tps6507x->dev);
+	kfree(tps6507x);
+	return ret;
+}
+
+static int tps6507x_i2c_remove(struct i2c_client *i2c)
+{
+	struct tps6507x_dev *tps6507x = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(tps6507x->dev);
+	kfree(tps6507x);
+
+	return 0;
+}
+
+static const struct i2c_device_id tps6507x_i2c_id[] = {
+       { "tps6507x", 0 },
+       { }
+};
+MODULE_DEVICE_TABLE(i2c, tps6507x_i2c_id);
+
+
+static struct i2c_driver tps6507x_i2c_driver = {
+	.driver = {
+		   .name = "tps6507x",
+		   .owner = THIS_MODULE,
+	},
+	.probe = tps6507x_i2c_probe,
+	.remove = tps6507x_i2c_remove,
+	.id_table = tps6507x_i2c_id,
+};
+
+static int __init tps6507x_i2c_init(void)
+{
+	return i2c_add_driver(&tps6507x_i2c_driver);
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(tps6507x_i2c_init);
+
+static void __exit tps6507x_i2c_exit(void)
+{
+	i2c_del_driver(&tps6507x_i2c_driver);
+}
+module_exit(tps6507x_i2c_exit);
+
+MODULE_DESCRIPTION("TPS6507x chip family multi-function driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 86f2e05..e4d7d2f 100644
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
+	struct tps6507x_dev *tps6507x_dev = dev_get_drvdata(pdev->dev.parent);
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
 
-	tps_board = dev_get_platdata(&client->dev);
+	tps_board = dev_get_platdata(tps6507x_dev->dev);
 	if (!tps_board)
 		return -EINVAL;
 
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
index fd73af5..9543cb7 100644
--- a/include/linux/mfd/tps6507x.h
+++ b/include/linux/mfd/tps6507x.h
@@ -131,6 +131,8 @@
 /* VDCDC MASK */
 #define TPS6507X_DEFDCDCX_DCDC_MASK		0X3F
 
+#define TPS6507X_MAX_REGISTER			0X19
+
 /**
  * struct tps6507x_board - packages regulator and touchscreen init data
  * @tps6507x_regulator_data: regulator initialization values
@@ -142,4 +144,24 @@ struct tps6507x_board {
 	struct regulator_init_data *tps6507x_pmic_init_data;
 };
 
+/**
+ * struct tps6507x_dev - tps6507x sub-driver chip access routines
+ * @read_dev() - I2C register read function
+ * @write_dev() - I2C register write function
+ *
+ * Device data may be used to access the TPS6507x chip
+ */
+
+struct tps6507x_dev {
+	struct device *dev;
+	struct i2c_client *i2c_client;
+	int (*read_dev)(struct tps6507x_dev *tps6507x, char reg, int size,
+			void *dest);
+	int (*write_dev)(struct tps6507x_dev *tps6507x, char reg, int size,
+			 void *src);
+
+	/* Client devices */
+	struct tps6507x_pmic *pmic;
+};
+
 #endif /*  __LINUX_MFD_TPS6507X_H */
-- 
1.6.0.4

