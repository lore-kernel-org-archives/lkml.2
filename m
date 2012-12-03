Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab2LCEop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 23:44:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46283 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab2LCEol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 23:44:41 -0500
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Liam Gridwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] regulator: new driver for LP8755
Date: Mon,  3 Dec 2012 13:44:24 +0900
Message-Id: <1354509864-30001-2-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1354509864-30001-1-git-send-email-gshark.jeong@gmail.com>
References: <1354509864-30001-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Jeong <daniel.jeong@ti.com>

This driver is a general version for lp8755 regulator driver of TI.

LP8755 :
The LP8755 is a high performance power management unit.It contains
six step-down DC-DC converters which can be filexibly bundled
together in multiphase converters as required by application.
www.ti.com

Signed-off-by: Daniel Jeong <daniel.jeong@ti.com>
---
 drivers/regulator/Kconfig            |    9 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/lp8755.c           |  553 ++++++++++++++++++++++++++++++++++
 include/linux/platform_data/lp8755.h |   72 +++++
 4 files changed, 635 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/lp8755.c
 create mode 100644 include/linux/platform_data/lp8755.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 67d47b59..63e37ff 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -257,6 +257,15 @@ config REGULATOR_LP872X
 	help
 	  This driver supports LP8720/LP8725 PMIC
 
+config REGULATOR_LP8755
+	tristate "TI LP8755 Hihg Performance PMU driver"
+	depends on I2C
+	select REGMAP_I2C
+	help
+	  This driver supports LP8755 High Performance PMU driver. This
+	  chip contains six step-down DC/DC converters which can support
+	  9 mode multiphase configuration.
+
 config REGULATOR_LP8788
 	bool "TI LP8788 Power Regulators"
 	depends on MFD_LP8788
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index e431eed..bf346b7 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_REGULATOR_LP3972) += lp3972.o
 obj-$(CONFIG_REGULATOR_LP872X) += lp872x.o
 obj-$(CONFIG_REGULATOR_LP8788) += lp8788-buck.o
 obj-$(CONFIG_REGULATOR_LP8788) += lp8788-ldo.o
+obj-$(CONFIG_REGULATOR_LP8755) += lp8755.o
 obj-$(CONFIG_REGULATOR_MAX1586) += max1586.o
 obj-$(CONFIG_REGULATOR_MAX8649)	+= max8649.o
 obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
new file mode 100644
index 0000000..00d0763
--- /dev/null
+++ b/drivers/regulator/lp8755.c
@@ -0,0 +1,553 @@
+/*
+ * LP8755 High Performance Power Management Unit : System Interface Driver
+ * (based on rev. 0)
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Daniel(Geon Si) Jeong <daniel.jeong@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <linux/regmap.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/regulator/driver.h>
+#include <linux/platform_data/lp8755.h>
+
+#define LP8755_REG_BUCK0	0x00
+#define LP8755_REG_BUCK1	0x03
+#define LP8755_REG_BUCK2	0x04
+#define LP8755_REG_BUCK3	0x01
+#define LP8755_REG_BUCK4	0x05
+#define LP8755_REG_BUCK5	0x02
+#define LP8755_REG_MAX		0xFF
+
+#define LP8755_BUCK_EN_M	BIT(7)
+#define LP8755_BUCK_VOUT_M	0x7F
+
+enum bucks {
+	BUCK0 = 0,
+	BUCK1,
+	BUCK2,
+	BUCK3,
+	BUCK4,
+	BUCK5,
+};
+
+struct lp8755_mphase {
+	int nreg;
+	int buck_num[LP8755_BUCK_MAX];
+};
+
+struct lp8755_chip {
+	struct device *dev;
+	struct regmap *regmap;
+	struct lp8755_platform_data *pdata;
+
+	int irq;
+	unsigned int irqmask;
+
+	int num_reg;
+	int mphase;
+	struct regulator_dev *rdev[LP8755_BUCK_MAX];
+};
+
+static int lp8755_read(struct lp8755_chip *pchip, unsigned int reg,
+		       unsigned int *val)
+{
+	return regmap_read(pchip->regmap, reg, val);
+}
+
+static int lp8755_write(struct lp8755_chip *pchip, unsigned int reg,
+			unsigned int val)
+{
+	return regmap_write(pchip->regmap, reg, val);
+}
+
+static int lp8755_buck_enable_time(struct regulator_dev *rdev)
+{
+	unsigned int regval;
+	enum lp8755_bucks id = rdev_get_id(rdev);
+	struct lp8755_chip *pchip = rdev_get_drvdata(rdev);
+
+	if (lp8755_read(pchip, 0x12 + id, &regval) < 0) {
+		dev_err(pchip->dev, "i2c acceess error %s\n", __func__);
+		return -EINVAL;
+	}
+	return (regval & 0xff) * 100;
+}
+
+static int lp8755_buck_set_mode(struct regulator_dev *rdev, unsigned int mode)
+{
+	unsigned int regbval, regcval;
+	enum lp8755_bucks id = rdev_get_id(rdev);
+	struct lp8755_chip *pchip = rdev_get_drvdata(rdev);
+
+	if (lp8755_read(pchip, 0x06, &regbval) < 0)
+		goto err_i2c;
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		/* forced pwm mode */
+		regbval |= (0x01 << id);
+		break;
+	case REGULATOR_MODE_NORMAL:
+		/* enable automatic pwm/pfm mode */
+		regbval &= ~(0x01 << id);
+		if (lp8755_read(pchip, 0x08 + id, &regcval) < 0)
+			goto err_i2c;
+		regcval &= ~0x20;
+		if (lp8755_write(pchip, 0x08 + id, regcval) < 0)
+			goto err_i2c;
+		break;
+	case REGULATOR_MODE_IDLE:
+		/* enable automatic pwm/pfm/lppfm mode */
+		regbval &= ~(0x01 << id);
+
+		if (lp8755_read(pchip, 0x08 + id, &regcval) < 0)
+			goto err_i2c;
+		regcval |= 0x20;
+		if (lp8755_write(pchip, 0x08 + id, regcval) < 0)
+			goto err_i2c;
+
+		if (lp8755_read(pchip, 0x10, &regcval) < 0)
+			goto err_i2c;
+		regcval |= 0x01;
+		if (lp8755_write(pchip, 0x10, regcval) < 0)
+			goto err_i2c;
+		break;
+	default:
+		dev_err(pchip->dev, "Not supported buck mode %s\n", __func__);
+		return -EINVAL;
+	}
+
+	return lp8755_write(pchip, 0x06, regbval);
+err_i2c:
+	dev_err(pchip->dev, "i2c acceess error %s\n", __func__);
+	return -EINVAL;
+}
+
+static unsigned int lp8755_buck_get_mode(struct regulator_dev *rdev)
+{
+	unsigned int regval;
+	enum lp8755_bucks id = rdev_get_id(rdev);
+	struct lp8755_chip *pchip = rdev_get_drvdata(rdev);
+
+	if (lp8755_read(pchip, 0x06, &regval) < 0)
+		goto err_i2c;
+
+	regval &= ~(0x01 << id);
+
+	/* mode fast means forced pwm mode.
+	   mode normal means not forced pwm mode, according to
+	   current load it could be one of modes, PWM/PFM/LPPFM. */
+	return regval ? REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
+
+err_i2c:
+	dev_err(pchip->dev, "i2c acceess error %s\n", __func__);
+	return -EINVAL;
+}
+
+static int lp8755_buck_set_ramp(struct regulator_dev *rdev, int ramp)
+{
+	unsigned int regval;
+	enum lp8755_bucks id = rdev_get_id(rdev);
+	struct lp8755_chip *pchip = rdev_get_drvdata(rdev);
+
+	if (lp8755_read(pchip, 0x07 + id, &regval) < 0)
+		goto err_i2c;
+	regval &= ~0x07;
+
+	/* uV/us */
+	switch (ramp) {
+	case 0 ... 230:
+		regval |= 0x07;
+		break;
+	case 231 ... 470:
+		regval |= 0x06;
+		break;
+	case 471 ... 940:
+		regval |= 0x05;
+		break;
+	case 941 ... 1900:
+		regval |= 0x04;
+		break;
+	case 1901 ... 3800:
+		regval |= 0x03;
+		break;
+	case 3801 ... 7500:
+		regval |= 0x02;
+		break;
+	case 7501 ... 15000:
+		regval |= 0x01;
+		break;
+	case 15001 ... 30000:
+		regval |= 0x00;
+		break;
+	default:
+		dev_err(pchip->dev, "Not supported ramp value %d %s\n", ramp,
+			__func__);
+		return -EINVAL;
+	}
+
+	return lp8755_write(pchip, 0x07 + id, regval);
+err_i2c:
+	dev_err(pchip->dev, "i2c acceess error %s\n", __func__);
+	return -EINVAL;
+}
+
+static struct regulator_ops lp8755_buck_ops = {
+	.list_voltage = regulator_list_voltage_table,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable_time = lp8755_buck_enable_time,
+	.set_mode = lp8755_buck_set_mode,
+	.get_mode = lp8755_buck_get_mode,
+	.set_ramp_delay = lp8755_buck_set_ramp,
+};
+
+/* buck voltage table */
+static const int lp8755_buck_vtbl[] = {
+	500000, 510000, 520000, 530000, 540000,
+	550000, 560000, 570000, 580000, 590000,
+	600000, 610000, 620000, 630000, 640000,
+	650000, 660000, 670000, 680000, 690000,
+	700000, 710000, 720000, 730000, 740000,
+	750000, 760000, 770000, 780000, 790000,
+	800000, 810000, 820000, 830000, 840000,
+	850000, 860000, 870000, 880000, 890000,
+	900000, 910000, 920000, 930000, 940000,
+	950000, 960000, 970000, 980000, 990000,
+	1000000, 1010000, 1020000, 1030000, 1040000,
+	1050000, 1060000, 1070000, 1080000, 1090000,
+	1100000, 1110000, 1120000, 1130000, 1140000,
+	1150000, 1160000, 1170000, 1180000, 1190000,
+	1200000, 1210000, 1220000, 1230000, 1240000,
+	1250000, 1260000, 1270000, 1280000, 1290000,
+	1300000, 1310000, 1320000, 1330000, 1340000,
+	1350000, 1360000, 1370000, 1380000, 1390000,
+	1400000, 1410000, 1420000, 1430000, 1440000,
+	1450000, 1460000, 1470000, 1480000, 1490000,
+	1500000, 1510000, 1520000, 1530000, 1540000,
+	1550000, 1560000, 1570000, 1580000, 1590000,
+	1600000, 1610000, 1620000, 1630000, 1640000,
+	1650000, 1660000, 1670000, 1670000, 1670000,
+	1670000, 1670000, 1670000, 1670000, 1670000,
+	1670000, 1670000, 1670000, 1670000, 1670000
+};
+
+#define lp8755_rail(_id) "lp8755_buck"#_id
+#define lp8755_buck_desc(_id)\
+{\
+	.name = lp8755_rail(_id),\
+	.id   = LP8755_BUCK##_id,\
+	.ops  = &lp8755_buck_ops,\
+	.n_voltages = LP8755_BUCK_VOUT_M+1,\
+	.volt_table = lp8755_buck_vtbl,\
+	.type = REGULATOR_VOLTAGE,\
+	.owner = THIS_MODULE,\
+	.enable_reg = LP8755_REG_BUCK##_id,\
+	.enable_mask = LP8755_BUCK_EN_M,\
+	.vsel_reg = LP8755_REG_BUCK##_id,\
+	.vsel_mask = LP8755_BUCK_VOUT_M,\
+	.uV_step = 10000,\
+}
+
+static struct regulator_desc lp8755_regulators[] = {
+	lp8755_buck_desc(0),
+	lp8755_buck_desc(1),
+	lp8755_buck_desc(2),
+	lp8755_buck_desc(3),
+	lp8755_buck_desc(4),
+	lp8755_buck_desc(5),
+};
+
+static const struct lp8755_mphase mphase_buck[MPHASE_CONF_MAX] = {
+	{3, {BUCK0, BUCK3, BUCK5}
+	 },
+	{6, {BUCK0, BUCK1, BUCK2, BUCK3, BUCK4, BUCK5}
+	 },
+	{5, {BUCK0, BUCK2, BUCK3, BUCK4, BUCK5}
+	 },
+	{4, {BUCK0, BUCK3, BUCK4, BUCK5}
+	 },
+	{3, {BUCK0, BUCK4, BUCK5}
+	 },
+	{2, {BUCK0, BUCK5}
+	 },
+	{1, {BUCK0}
+	 },
+	{2, {BUCK0, BUCK3}
+	 },
+	{4, {BUCK0, BUCK2, BUCK3, BUCK5}
+	 },
+};
+
+static const struct regmap_config lp8755_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = LP8755_REG_MAX,
+};
+
+static int lp8755_chip_init(struct lp8755_chip *pchip)
+{
+	int ret;
+	unsigned int regval;
+
+	/* check vendor id and write init value */
+	ret = lp8755_read(pchip, 0x18, &regval);
+	if (ret < 0)
+		goto out_i2c_error;
+	dev_info(pchip->dev, "lp8755 : chip ID is 0x%x\n", regval);
+
+	return ret;
+
+out_i2c_error:
+	dev_err(pchip->dev, "i2c acceess error %s\n", __func__);
+	return ret;
+}
+
+static int __devinit lp8755_regulator_init(struct lp8755_chip *pchip)
+{
+	int ret, icnt, buck_num;
+	struct lp8755_platform_data *pdata = pchip->pdata;
+
+	struct regulator_config rconfig = { };
+
+	rconfig.regmap = pchip->regmap;
+	rconfig.dev = pchip->dev;
+	rconfig.driver_data = pchip;
+
+	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++) {
+		buck_num = mphase_buck[pchip->mphase].buck_num[icnt];
+		rconfig.init_data = pdata->buck_data[buck_num];
+		rconfig.of_node = pchip->dev->of_node;
+		pchip->rdev[icnt] =
+		    regulator_register(&lp8755_regulators[buck_num], &rconfig);
+		if (IS_ERR(pchip->rdev[icnt])) {
+			ret = PTR_ERR(pchip->rdev[icnt]);
+			dev_err(pchip->dev, "regulator init failed: buck 0\n");
+			goto err_buck;
+		}
+	}
+
+	dev_info(pchip->dev, "regulator init Done %s\n", __func__);
+	return 0;
+
+err_buck:
+	while (--icnt >= 0)
+		regulator_unregister(pchip->rdev[icnt]);
+	return ret;
+}
+
+/* interrupts */
+enum lp8755_irq {
+	LP8755_IRQ_OCP = 0,
+	LP8755_IRQ_OVP,
+	LP8755_IRQ_B0,
+	LP8755_IRQ_B1,
+	LP8755_IRQ_B2,
+	LP8755_IRQ_B3,
+	LP8755_IRQ_B4,
+	LP8755_IRQ_B5,
+	LP8755_IRQ_MAX,
+};
+
+static irqreturn_t lp8755_irq_handler(int irq, void *data)
+{
+	int ret, icnt, imask;
+	unsigned int flag0, flag1;
+	struct lp8755_chip *pchip = data;
+
+	/* read & clear flag register */
+	ret = lp8755_read(pchip, 0x0D, &flag0);
+	ret |= lp8755_write(pchip, 0x0D, 0x00);
+	if (ret < 0)
+		goto err_i2c;
+
+	ret = lp8755_read(pchip, 0x0E, &flag1);
+	ret |= lp8755_write(pchip, 0x0E, 0x00);
+	if (ret < 0)
+		goto err_i2c;
+
+	/* send OCP event to all regualtor devices */
+	if ((flag1 & 0x01) && (pchip->irqmask & 0x01))
+		for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
+			if (pchip->rdev[icnt] != NULL)
+				regulator_notifier_call_chain(pchip->rdev[icnt],
+							      LP8755_EVENT_OCP,
+							      NULL);
+
+	/* send OVP event to all regualtor devices */
+	if ((flag1 & 0x02) && (pchip->irqmask & 0x02))
+		for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
+			if (pchip->rdev[icnt] != NULL)
+				regulator_notifier_call_chain(pchip->rdev[icnt],
+							      LP8755_EVENT_OVP,
+							      NULL);
+
+	return ret ? IRQ_HANDLED : IRQ_NONE;
+
+err_i2c:
+	dev_err(pchip->dev, "i2c acceess error %s\n", __func__);
+	return IRQ_NONE;
+}
+
+static int __devinit lp8755_int_config(struct lp8755_chip *pchip)
+{
+	int ret;
+	unsigned int regval;
+
+	if (pchip->irq == 0) {
+		dev_warn(pchip->dev, "not use interrupt : %s\n", __func__);
+		return 0;
+	}
+
+	ret = lp8755_read(pchip, 0x0F, &regval);
+	if (ret < 0)
+		goto err_i2c;
+	pchip->irqmask = regval;
+	ret = request_threaded_irq(pchip->irq, NULL, lp8755_irq_handler,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   "lp8755-irq", pchip);
+	if (ret)
+		return -1;
+
+	return 0;
+
+err_i2c:
+	dev_err(pchip->dev, "i2c acceess error %s\n", __func__);
+	return ret;
+}
+
+static int __devinit lp8755_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	int ret, icnt;
+	struct lp8755_chip *pchip;
+	struct lp8755_platform_data *pdata = client->dev.platform_data;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "i2c functionality check fail.\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "platform data is NULL.\n");
+		return -ENOMEM;
+	}
+
+	pchip = devm_kzalloc(&client->dev,
+			     sizeof(struct lp8755_chip), GFP_KERNEL);
+
+	if (!pchip)
+		return -ENOMEM;
+
+	pchip->pdata = pdata;
+	pchip->dev = &client->dev;
+	pchip->mphase = pdata->mphase;
+
+	pchip->regmap = devm_regmap_init_i2c(client, &lp8755_regmap);
+	if (IS_ERR(pchip->regmap)) {
+		ret = PTR_ERR(pchip->regmap);
+		dev_err(&client->dev, "fail to allocate regmap %d\n", ret);
+		return ret;
+	}
+	i2c_set_clientdata(client, pchip);
+
+	ret = lp8755_chip_init(pchip);
+	if (ret < 0)
+		goto err_chip_init;
+
+	ret = lp8755_regulator_init(pchip);
+	if (ret < 0)
+		goto err_regulator;
+
+	pchip->irq = client->irq;
+	ret = lp8755_int_config(pchip);
+	if (ret < 0)
+		goto err_irq;
+
+	dev_info(&client->dev, "lp8755 init done.\n");
+	return ret;
+
+err_irq:
+	dev_err(&client->dev, "fail to irq config\n");
+
+	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++)
+		regulator_unregister(pchip->rdev[icnt]);
+
+err_regulator:
+	dev_err(&client->dev, "fail to initialize regulators\n");
+	for (icnt = 0; icnt < 0x06; icnt++)
+		lp8755_write(pchip, icnt, 0x00);
+
+err_chip_init:
+	dev_err(&client->dev, "fail to initialize chip\n");
+
+	return ret;
+}
+
+static int __devexit lp8755_remove(struct i2c_client *client)
+{
+	int icnt;
+	struct lp8755_chip *pchip = i2c_get_clientdata(client);
+
+	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++)
+		regulator_unregister(pchip->rdev[icnt]);
+
+	for (icnt = 0; icnt < 0x06; icnt++)
+		lp8755_write(pchip, icnt, 0x00);
+
+	if (pchip->irq != 0)
+		free_irq(pchip->irq, pchip);
+
+	return 0;
+}
+
+static const struct i2c_device_id lp8755_id[] = {
+	{LP8755_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lp8755_id);
+
+static struct i2c_driver lp8755_i2c_driver = {
+	.driver = {
+		   .name = LP8755_NAME,
+		   },
+	.probe = lp8755_probe,
+	.remove = __devexit_p(lp8755_remove),
+	.id_table = lp8755_id,
+};
+
+static int __init lp8755_init(void)
+{
+	return i2c_add_driver(&lp8755_i2c_driver);
+}
+
+subsys_initcall(lp8755_init);
+
+static void __exit lp8755_exit(void)
+{
+	i2c_del_driver(&lp8755_i2c_driver);
+}
+
+module_exit(lp8755_exit);
+
+MODULE_DESCRIPTION("Texas Instruments lp8755 driver");
+MODULE_AUTHOR("Daniel Jeong <daniel.jeong@ti.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/platform_data/lp8755.h b/include/linux/platform_data/lp8755.h
new file mode 100644
index 0000000..e0f7dde
--- /dev/null
+++ b/include/linux/platform_data/lp8755.h
@@ -0,0 +1,72 @@
+/*
+ * LP8755 High Performance Power Management Unit Driver:System Interface Driver
+ *
+ *			Copyright (C) 2012 Texas Instruments
+ *
+ * Author: Daniel(Geon Si) Jeong <daniel.jeong@ti.com>
+ *             G.Shark Jeong <gshark.jeong@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _LP8755_H
+#define _LP8755_H
+
+#include <linux/regulator/consumer.h>
+
+#define LP8755_NAME "lp8755-regulator"
+
+/*
+ *PWR FAULT : power fault detected
+ *OCP : over current protect activated
+ *OVP : over voltage protect activated
+ *TEMP_WARN : thermal warning
+ *TEMP_SHDN : thermal shutdonw detected
+ *I_LOAD : current measured
+ */
+#define LP8755_EVENT_PWR_FAULT REGULATOR_EVENT_FAIL
+#define LP8755_EVENT_OCP REGULATOR_EVENT_OVER_CURRENT
+#define LP8755_EVENT_OVP 0x10000
+#define LP8755_EVENT_TEMP_WARN 0x2000
+#define LP8755_EVENT_TEMP_SHDN REGULATOR_EVENT_OVER_TEMP
+#define LP8755_EVENT_I_LOAD	0x40000
+
+enum lp8755_bucks {
+	LP8755_BUCK0 = 0,
+	LP8755_BUCK1,
+	LP8755_BUCK2,
+	LP8755_BUCK3,
+	LP8755_BUCK4,
+	LP8755_BUCK5,
+	LP8755_BUCK_MAX,
+};
+
+/**
+ * multiphase configuration options
+ */
+enum lp8755_mphase_config {
+	MPHASE_CONF0,
+	MPHASE_CONF1,
+	MPHASE_CONF2,
+	MPHASE_CONF3,
+	MPHASE_CONF4,
+	MPHASE_CONF5,
+	MPHASE_CONF6,
+	MPHASE_CONF7,
+	MPHASE_CONF8,
+	MPHASE_CONF_MAX
+};
+
+/**
+ * struct lp8755_platform_data
+ * @mphase_type    : Multiphase Switcher Configurations 0~8
+ * @buck_init_volt : buck0~6 init voltage in uV.
+ */
+struct lp8755_platform_data {
+	int mphase;
+	struct regulator_init_data *buck_data[LP8755_BUCK_MAX];
+};
+#endif
-- 
1.7.5.4

