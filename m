Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab0FDEca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:32:30 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:5735 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0FDEc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:32:29 -0400
X-IronPort-AV: E=Sophos;i="4.53,358,1272859200"; 
   d="scan'208";a="16980501"
Subject: [PATCH v6] regulator: new drivers for AD5398 and AD5821
From: sonic zhang <sonic.adi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain
Date: Fri, 4 Jun 2010 12:40:46 +0800
Message-ID: <1275626446.1515.5.camel@eight.analog.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 32646efc2e7fb19945a10ad3f1172d6f751186b8 Mon Sep 17 00:00:00 2001
From: Sonic Zhang <sonic.zhang@analog.com>
Date: Fri, 4 Jun 2010 11:46:04 +0800
Subject: [PATCH v6] regulator: new drivers for AD5398 and AD5821

The AD5398 and AD5821 are single 10-bit DAC with 120 mA output current
sink capability. They feature an internal reference and operates from
a single 2.7 V to 5.5 V supply.

This driver supports both the AD5398 and the AD5821.  It adapts into the
voltage and current framework.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/regulator/Kconfig  |    6 +
 drivers/regulator/Makefile |    1 +
 drivers/regulator/ad5398.c |  288 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 295 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/ad5398.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 04f2e08..679ea37 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -201,5 +201,11 @@ config REGULATOR_88PM8607
 	help
 	  This driver supports 88PM8607 voltage regulator chips.
 
+config REGULATOR_AD5398
+	tristate "Analog Devices AD5398/AD5821 regulators"
+	depends on I2C
+	help
+	  This driver supports AD5398 and AD5821 current regulator chips.
+	  If building into module, its name is ad5398.ko.
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
index 0000000..0451c30
--- /dev/null
+++ b/drivers/regulator/ad5398.c
@@ -0,0 +1,288 @@
+/*
+ * Voltage and current regulation for AD5398 and AD5821
+ *
+ * Copyright 2010 Analog Devices Inc.
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+
+#define AD5398_CURRENT_EN_MASK	0x8000
+
+struct ad5398_chip_info {
+	struct i2c_client *client;
+	int min_uA;
+	int max_uA;
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
+static int ad5398_read_reg(struct i2c_client *client, unsigned short *data)
+{
+	unsigned short val;
+	int ret;
+
+	ret = i2c_master_recv(client, (char *)&val, 2);
+	if (ret < 0) {
+		dev_err(&client->dev, "I2C read error\n");
+		return ret;
+	}
+	*data = be16_to_cpu(val);
+
+	return ret;
+}
+
+static int ad5398_write_reg(struct i2c_client *client, const unsigned short data)
+{
+	unsigned short val;
+	int ret;
+
+	val = cpu_to_be16(data);
+	ret = i2c_master_send(client, (char *)&val, 2);
+	if (ret < 0)
+		dev_err(&client->dev, "I2C write error\n");
+
+	return ret;
+}
+
+static int ad5398_get_current_limit(struct regulator_dev *rdev)
+{
+	struct ad5398_chip_info *chip = rdev_get_drvdata(rdev);
+	struct i2c_client *client = chip->client;
+	unsigned short data;
+	int ret;
+
+	ret = ad5398_read_reg(client, &data);
+	if (ret < 0)
+		return ret;
+
+	ret = (data & chip->current_mask) >> chip->current_offset;
+
+	return ad5398_calc_current(chip, ret);
+}
+
+static int ad5398_set_current_limit(struct regulator_dev *rdev, int min_uA, int max_uA)
+{
+	struct ad5398_chip_info *chip = rdev_get_drvdata(rdev);
+	struct i2c_client *client = chip->client;
+	unsigned range_uA = chip->max_uA - chip->min_uA;
+	unsigned selector;
+	unsigned short data;
+	int ret;
+
+	if (min_uA > chip->max_uA || min_uA < chip->min_uA)
+		return -EINVAL;
+	if (max_uA > chip->max_uA || max_uA < chip->min_uA)
+		return -EINVAL;
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
+	ret = ad5398_read_reg(client, &data);
+	if (ret < 0)
+		return ret;
+
+	/* prepare register data */
+	selector = (selector << chip->current_offset) & chip->current_mask;
+	data = (unsigned short)selector | (data & AD5398_CURRENT_EN_MASK);
+
+	/* write the new current value back as well as enable bit */
+	ret = ad5398_write_reg(client, data);
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
+	ret = ad5398_read_reg(client, &data);
+	if (ret < 0)
+		return ret;
+
+	if (data & AD5398_CURRENT_EN_MASK)
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
+	ret = ad5398_read_reg(client, &data);
+	if (ret < 0)
+		return ret;
+
+	if (data & AD5398_CURRENT_EN_MASK)
+		return 0;
+
+	data |= AD5398_CURRENT_EN_MASK;
+
+	ret = ad5398_write_reg(client, data);
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
+	ret = ad5398_read_reg(client, &data);
+	if (ret < 0)
+		return ret;
+
+	if (!(data & AD5398_CURRENT_EN_MASK))
+		return 0;
+
+	data &= ~AD5398_CURRENT_EN_MASK;
+
+	ret = ad5398_write_reg(client, data);
+
+	return ret;
+}
+
+static struct regulator_ops ad5398_ops = {
+	.get_current_limit = ad5398_get_current_limit,
+	.set_current_limit = ad5398_set_current_limit,
+	.enable = ad5398_enable,
+	.disable = ad5398_disable,
+	.is_enabled = ad5398_is_enabled,
+};
+
+static struct regulator_desc ad5398_reg = {
+	.name = "isink",
+	.id = 0,
+	.ops = &ad5398_ops,
+	.type = REGULATOR_CURRENT,
+	.owner = THIS_MODULE,
+};
+
+struct ad5398_current_data_format {
+	int current_bits;
+	int current_offset;
+	int min_uA;
+	int max_uA;
+};
+
+static const struct ad5398_current_data_format df_10_4_120 = {10, 4, 0, 120000};
+
+static const struct i2c_device_id ad5398_id[] = {
+	{ "ad5398", (kernel_ulong_t)&df_10_4_120 },
+	{ "ad5821", (kernel_ulong_t)&df_10_4_120 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ad5398_id);
+
+static int __devinit ad5398_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct regulator_dev *rdev;
+	struct regulator_init_data *init_data = client->dev.platform_data;
+	struct ad5398_chip_info *chip;
+	const struct ad5398_current_data_format *df =
+			(struct ad5398_current_data_format *)id->driver_data;
+	int ret;
+
+	if (!init_data)
+		return -EINVAL;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->client = client;
+
+	chip->min_uA = df->min_uA;
+	chip->max_uA = df->max_uA;
+	chip->current_level = 1 << df->current_bits;
+	chip->current_offset = df->current_offset;
+	chip->current_mask = (chip->current_level - 1) << chip->current_offset;
+
+	rdev = regulator_register(&ad5398_reg, &client->dev, init_data, chip);
+	if (IS_ERR(rdev)) {
+		ret = PTR_ERR(rdev);
+		dev_err(&client->dev, "failed to register %s %s\n",
+			id->name, ad5398_reg.name);
+		goto err;
+	}
+
+	i2c_set_clientdata(client, chip);
+	dev_dbg(&client->dev, "%s regulator driver is registered.\n", id->name);
+	return 0;
+
+err:
+	kfree(chip);
+	return ret;
+}
+
+static int __devexit ad5398_remove(struct i2c_client *client)
+{
+	struct ad5398_chip_info *chip = i2c_get_clientdata(client);
+
+	regulator_unregister(&chip->rdev);
+	kfree(chip);
+	i2c_set_clientdata(client, NULL);
+
+	return 0;
+}
+
+static struct i2c_driver ad5398_driver = {
+	.probe = ad5398_probe,
+	.remove = __devexit_p(ad5398_remove),
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
+MODULE_ALIAS("i2c:ad5398-regulator");
-- 
1.6.0



