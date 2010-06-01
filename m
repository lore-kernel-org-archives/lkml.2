Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0FANbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:31:20 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33442 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab0FANbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:31:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 1/2] regulator: new driver for the AD5398 and AD5821
Date: Tue,  1 Jun 2010 09:33:58 -0400
Message-Id: <1275399239-6788-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

This driver supports both the AD5398 and the AD5821.  It adapts into the
voltage and current framework.  The generic userspace-consumer and virtual
consumer should be selected to access devices via this driver.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/regulator/Kconfig        |    6 +
 drivers/regulator/Makefile       |    1 +
 drivers/regulator/ad5398.c       |  270 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/ad5398.h |   30 ++++
 4 files changed, 307 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/ad5398.c
 create mode 100644 include/linux/regulator/ad5398.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 04f2e08..2ade09c 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -201,5 +201,11 @@ config REGULATOR_88PM8607
 	help
 	  This driver supports 88PM8607 voltage regulator chips.
 
+config REGULATOR_AD5398
+	tristate "Ananlog Devices AD5398/AD5821 regulators"
+	depends on I2C
+	help
+	  This driver supports AD5398 and AD5821 current regulator chips.
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 4e7feec..c256668 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
+obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
 obj-$(CONFIG_REGULATOR_DUMMY) += dummy.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
new file mode 100644
index 0000000..9dbfc05
--- /dev/null
+++ b/drivers/regulator/ad5398.c
@@ -0,0 +1,270 @@
+/*
+ * ad5398.c  --  Voltage and current regulation for AD5398 and AD5821
+ *
+ * Copyright 2010 Analog Devices Inc.
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/ad5398.h>
+
+struct ad5398_chip_info {
+	struct i2c_client *client;
+	unsigned int min_uA;
+	unsigned int max_uA;
+	unsigned int current_level;
+	unsigned int current_mask;
+	unsigned int current_offset;
+	struct regulator_dev rdev;
+};
+
+static int ad5398_calc_current(struct ad5398_chip_info *chip,
+	unsigned selector)
+{
+	unsigned range_uA = chip->max_uA - chip->min_uA;
+
+	return chip->min_uA + (selector * range_uA / chip->current_level);
+}
+
+static int ad5398_get(struct regulator_dev *rdev)
+{
+	struct ad5398_chip_info *chip = rdev_get_drvdata(rdev);
+	struct i2c_client *client = chip->client;
+	unsigned short data;
+	int ret;
+
+	ret = i2c_master_recv(client, (char *)&data, 2);
+	if (ret < 0) {
+		dev_err(&client->dev, "I2C read error\n");
+		return ret;
+	}
+
+	ret = (be16_to_cpu(data) & chip->current_mask) >> chip->current_offset;
+
+	return ad5398_calc_current(chip, ret);
+}
+
+static int ad5398_set(struct regulator_dev *rdev, int min_uA, int max_uA)
+{
+	struct ad5398_chip_info *chip = rdev_get_drvdata(rdev);
+	struct i2c_client *client = chip->client;
+	unsigned range_uA = chip->max_uA - chip->min_uA;
+	unsigned selector;
+	unsigned short data;
+	int ret;
+
+	if (min_uA > chip->max_uA || max_uA < chip->min_uA)
+		return -EINVAL;
+	if (min_uA < chip->min_uA)
+		min_uA = chip->min_uA;
+
+	selector = ((min_uA - chip->min_uA) * chip->current_level +
+			range_uA - 1) / range_uA;
+	if (ad5398_calc_current(chip, selector) > max_uA)
+		return -EINVAL;
+
+	dev_dbg(&client->dev, "changing current %dmA\n",
+		ad5398_calc_current(chip, selector) / 1000);
+
+	/* read chip enable bit */
+	ret = i2c_master_recv(client, (char *)&data, 2);
+	if (ret < 0) {
+		dev_err(&client->dev, "I2C read error\n");
+		return ret;
+	}
+	data = be16_to_cpu(data);
+
+	/* prepare register data */
+	selector = (selector << chip->current_offset) & chip->current_mask;
+	selector |= (data & CURRENT_EN_MASK);
+
+	/* write the new current value back as well as enable bit */
+	data = cpu_to_be16((unsigned short)selector);
+	ret = i2c_master_send(client, (char *)&data, 2);
+	if (ret < 0)
+		dev_err(&client->dev, "I2C write error\n");
+
+	return ret;
+}
+
+static int ad5398_is_enabled(struct regulator_dev *rdev)
+{
+	struct ad5398_chip_info *chip = rdev_get_drvdata(rdev);
+	struct i2c_client *client = chip->client;
+	unsigned short data;
+	int ret;
+
+	ret = i2c_master_recv(client, (char *)&data, 2);
+	if (ret < 0) {
+		dev_err(&client->dev, "I2C read error\n");
+		return ret;
+	}
+
+	if (be16_to_cpu(data) & CURRENT_EN_MASK)
+		return 1;
+	else
+		return 0;
+}
+
+static int ad5398_enable(struct regulator_dev *rdev)
+{
+	struct ad5398_chip_info *chip = rdev_get_drvdata(rdev);
+	struct i2c_client *client = chip->client;
+	unsigned short data;
+	int ret;
+
+	ret = i2c_master_recv(client, (char *)&data, 2);
+	if (ret < 0) {
+		dev_err(&client->dev, "I2C read error\n");
+		return ret;
+	}
+	data = be16_to_cpu(data);
+	if (data & CURRENT_EN_MASK)
+		return 0;
+
+	data = cpu_to_be16(data | CURRENT_EN_MASK);
+
+	ret = i2c_master_send(client, (char *)&data, 2);
+	if (ret < 0)
+		dev_err(&client->dev, "I2C write error\n");
+
+	return ret;
+}
+
+static int ad5398_disable(struct regulator_dev *rdev)
+{
+	struct ad5398_chip_info *chip = rdev_get_drvdata(rdev);
+	struct i2c_client *client = chip->client;
+	unsigned short data;
+	int ret;
+
+	ret = i2c_master_recv(client, (char *)&data, 2);
+	if (ret < 0) {
+		dev_err(&client->dev, "I2C read error\n");
+		return ret;
+	}
+	if (!(data & CURRENT_EN_MASK))
+		return 0;
+
+	data = cpu_to_be16(data & ~CURRENT_EN_MASK);
+
+	ret = i2c_master_send(client, (char *)&data, 2);
+	if (ret < 0)
+		dev_err(&client->dev, "I2C write error\n");
+
+	return ret;
+}
+
+static struct regulator_ops ad5398_ops = {
+	.get_current_limit = ad5398_get,
+	.set_current_limit = ad5398_set,
+	.enable = ad5398_enable,
+	.disable = ad5398_disable,
+	.is_enabled = ad5398_is_enabled,
+	.set_suspend_enable = ad5398_enable,
+	.set_suspend_disable = ad5398_disable,
+};
+
+static struct regulator_desc ad5398_reg = {
+		.name = "isink",
+		.id = 0,
+		.ops = &ad5398_ops,
+		.type = REGULATOR_CURRENT,
+		.owner = THIS_MODULE,
+};
+
+static int ad5398_probe(struct i2c_client *client,
+		      const struct i2c_device_id *id)
+{
+	struct regulator_dev *rdev;
+	struct ad5398_platform_data *pdata = client->dev.platform_data;
+	struct ad5398_chip_info *chip;
+	int ret;
+
+	if (!pdata || !(pdata->regulator_data))
+		return -EINVAL;
+
+	if (pdata->current_bits >= CURRENT_BITS_MAX)
+		return -EINVAL;
+
+	chip = kzalloc(sizeof(struct ad5398_chip_info), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->client = client;
+
+	chip->min_uA = pdata->regulator_data->constraints.min_uA;
+	chip->max_uA = pdata->regulator_data->constraints.max_uA;
+	chip->current_level = 1 << pdata->current_bits;
+	chip->current_offset = pdata->current_offset;
+	chip->current_mask = (chip->current_level - 1) << chip->current_offset;
+
+	rdev = regulator_register(&ad5398_reg, &client->dev,
+			 pdata->regulator_data, chip);
+	if (IS_ERR(rdev)) {
+		ret = PTR_ERR(rdev);
+		dev_err(&client->dev, "failed to register %s %s\n",
+			id->name, ad5398_reg.name);
+		goto err;
+	}
+
+	i2c_set_clientdata(client, chip);
+	dev_info(&client->dev, "%s regulator driver loaded\n", id->name);
+	return 0;
+
+err:
+	kfree(chip);
+	return ret;
+}
+
+static int ad5398_remove(struct i2c_client *client)
+{
+	struct ad5398_chip_info *chip = i2c_get_clientdata(client);
+
+	if (chip) {
+		regulator_unregister(&chip->rdev);
+		kfree(chip);
+	}
+	i2c_set_clientdata(client, NULL);
+
+	return 0;
+}
+
+static const struct i2c_device_id ad5398_id[] = {
+	{ "ad5398", 0 },
+	{ "ad5821", 1 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ad5398_id);
+
+static struct i2c_driver ad5398_driver = {
+	.probe = ad5398_probe,
+	.remove = ad5398_remove,
+	.driver		= {
+		.name	= "ad5398",
+	},
+	.id_table	= ad5398_id,
+};
+
+static int __init ad5398_init(void)
+{
+	return i2c_add_driver(&ad5398_driver);
+}
+module_init(ad5398_init);
+
+static void __exit ad5398_exit(void)
+{
+	i2c_del_driver(&ad5398_driver);
+}
+module_exit(ad5398_exit);
+
+MODULE_DESCRIPTION("AD5398 and AD5821 current regulator driver");
+MODULE_AUTHOR("Sonic Zhang");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/ad5398.h b/include/linux/regulator/ad5398.h
new file mode 100644
index 0000000..92c9fcb
--- /dev/null
+++ b/include/linux/regulator/ad5398.h
@@ -0,0 +1,30 @@
+/*
+ * ad5398.h --  Voltage and current regulation for AD5398 and AD5821
+ *
+ * Copyright 2010 Analog Devices Inc.
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+#ifndef REGULATOR_AD5398
+#define REGULATOR_AD5398
+
+#include <linux/regulator/machine.h>
+
+#define CURRENT_EN_MASK		0x8000
+#define CURRENT_BITS_MAX	16
+
+/**
+ * ad5398_platform_data - platform data for ad5398
+ * @current_bits: effective bits in register
+ * @current_offset: offset of effective bits in register
+ * @ad5398_init_data: regulator init data
+ */
+struct ad5398_platform_data {
+	unsigned short current_bits;
+	unsigned short current_offset;
+	struct regulator_init_data *regulator_data;
+};
+
+#endif
-- 
1.7.1

