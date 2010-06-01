Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab0FANbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:31:18 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33439 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512Ab0FANbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:31:17 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/2] regulator: new driver for the AD12{2,3,4,5}, AD150, and AD5022 parts
Date: Tue,  1 Jun 2010 09:33:59 -0400
Message-Id: <1275399239-6788-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275399239-6788-1-git-send-email-vapier@gentoo.org>
References: <1275399239-6788-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

With userspace consumer enabled, power devices with only one switch
PIN connect to GPIO port can be enabled and disable via sysfs interface.

Following chips are supported.
AD122, AD123, AD124, AD125, AD150, AD5022.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/regulator/Kconfig            |    6 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/adp_switch.c       |  172 ++++++++++++++++++++++++++++++++++
 include/linux/regulator/adp_switch.h |   26 +++++
 4 files changed, 205 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/adp_switch.c
 create mode 100644 include/linux/regulator/adp_switch.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 2ade09c..7760f16 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -207,5 +207,11 @@ config REGULATOR_AD5398
 	help
 	  This driver supports AD5398 and AD5821 current regulator chips.
 
+config REGULATOR_ADP_SWITCH
+	tristate "Ananlog Devices Switch only power regulators"
+	help
+	  This driver supports ADP series siwtch only power regulator chips.
+	  ADP122, ADP123, ADP124, ADP125, ADP150, ADP5022, etc.
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index c256668..10e7a5a 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
+obj-$(CONFIG_REGULATOR_ADP_SWITCH) += adp_switch.o
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
 obj-$(CONFIG_REGULATOR_DUMMY) += dummy.o
 obj-$(CONFIG_REGULATOR_LP3971) += lp3971.o
diff --git a/drivers/regulator/adp_switch.c b/drivers/regulator/adp_switch.c
new file mode 100644
index 0000000..37951d2
--- /dev/null
+++ b/drivers/regulator/adp_switch.c
@@ -0,0 +1,172 @@
+/*
+ * adp_switch.c  --  Voltage regulation for switch only power devices
+ *		     AD122, AD123, AD124, AD125, AD150, AD5022, etc
+ *
+ * Copyright 2010 Analog Devices Inc.
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/adp_switch.h>
+
+struct adp_switch_chip_info {
+	unsigned short gpio_port;
+	unsigned short enabled;
+	struct regulator_dev *rdev;
+	struct regulator_desc rdesc;
+};
+
+static int adp_switch_is_enabled(struct regulator_dev *rdev)
+{
+	struct adp_switch_chip_info *chip = rdev_get_drvdata(rdev);
+
+	return chip->enabled;
+}
+
+static int adp_switch_enable(struct regulator_dev *rdev)
+{
+	struct adp_switch_chip_info *chip = rdev_get_drvdata(rdev);
+
+	gpio_set_value(chip->gpio_port, 1);
+
+	return 0;
+}
+
+static int adp_switch_disable(struct regulator_dev *rdev)
+{
+	struct adp_switch_chip_info *chip = rdev_get_drvdata(rdev);
+
+	gpio_set_value(chip->gpio_port, 0);
+
+	return 0;
+}
+
+static struct regulator_ops adp_switch_ops = {
+	.enable = adp_switch_enable,
+	.disable = adp_switch_disable,
+	.is_enabled = adp_switch_is_enabled,
+	.set_suspend_enable = adp_switch_enable,
+	.set_suspend_disable = adp_switch_disable,
+};
+
+static int __devinit adp_switch_probe(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev;
+	struct adp_switch_platform_data *pdata = pdev->dev.platform_data;
+	struct adp_switch_chip_info *chip;
+	int i, ret = 0;
+
+	dev_dbg(&pdev->dev, "%s enter\n", __func__);
+
+	if (!pdata || !pdata->regulator_num)
+		return -EINVAL;
+
+	chip = kzalloc(sizeof(struct adp_switch_chip_info) *
+			pdata->regulator_num, GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	for (i = 0; i < pdata->regulator_num; i++) {
+		/*
+		 * The GPIO port of the specific regulator is in driver_data field
+		 * of struct regulator_init_data defined in its platform board file.
+		 */
+		chip[i].gpio_port =
+		(unsigned short)(unsigned int)pdata->regulator_data[i].driver_data;
+		chip[i].rdesc.name = pdata->regulator_data[i].consumer_supplies->supply;
+		chip[i].rdesc.id = i,
+		chip[i].rdesc.ops = &adp_switch_ops,
+		chip[i].rdesc.type = REGULATOR_CURRENT,
+		chip[i].rdesc.owner = THIS_MODULE,
+
+		ret = gpio_request(chip[i].gpio_port, "adp_switch");
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Fail to request adp switch peripherals\n");
+			goto err;
+		}
+
+		rdev = regulator_register(&chip[i].rdesc, &pdev->dev,
+				 &pdata->regulator_data[i], &chip[i]);
+		if (IS_ERR(rdev)) {
+			ret = PTR_ERR(rdev);
+			dev_err(&pdev->dev, "failed to register %s\n",
+				chip[i].rdesc.name);
+			gpio_free(chip[i].gpio_port);
+			goto err;
+		}
+
+		gpio_direction_output(chip[i].gpio_port, 0);
+		chip[i].rdev = rdev;
+	}
+
+	dev_set_drvdata(&pdev->dev, chip);
+	dev_info(&pdev->dev, "regulator driver loaded\n");
+	return 0;
+
+err:
+	while (--i >= 0) {
+		regulator_unregister(chip[i].rdev);
+		gpio_free(chip[i].gpio_port);
+	}
+	kfree(chip);
+	return ret;
+}
+
+static int __devexit adp_switch_remove(struct platform_device *pdev)
+{
+	struct adp_switch_chip_info *chip = platform_get_drvdata(pdev);
+	struct adp_switch_platform_data *pdata = pdev->dev.platform_data;
+	int i;
+
+	dev_dbg(&pdev->dev, "%s enter\n", __func__);
+	dev_set_drvdata(&pdev->dev, NULL);
+
+
+	if (chip) {
+		for (i = 0; i < pdata->regulator_num; i++) {
+			regulator_unregister(chip[i].rdev);
+			gpio_free(chip[i].gpio_port);
+		}
+		kfree(chip);
+	}
+
+	return 0;
+}
+
+static struct platform_driver adp_switch_driver = {
+	.probe          = adp_switch_probe,
+	.remove         = __devexit_p(adp_switch_remove),
+	.driver         = {
+		.name   = "adp_switch",
+	},
+};
+
+static int __init adp_switch_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&adp_switch_driver);
+	if (ret)
+		pr_err("failed to register adp switch driver:%d\n", ret);
+
+	return ret;
+}
+module_init(adp_switch_init);
+
+static void __exit adp_switch_exit(void)
+{
+	platform_driver_unregister(&adp_switch_driver);
+}
+module_exit(adp_switch_exit);
+
+MODULE_DESCRIPTION("Switch only power regulator driver");
+MODULE_AUTHOR("Sonic Zhang");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/adp_switch.h b/include/linux/regulator/adp_switch.h
new file mode 100644
index 0000000..bbfac61
--- /dev/null
+++ b/include/linux/regulator/adp_switch.h
@@ -0,0 +1,26 @@
+/*
+ * adp_switch.h --  Voltage regulation for switch only power devices.
+ *		    AD122, AD123, AD124, AD125, AD150, AD5022, etc.
+ *
+ * Copyright 2010 Analog Devices Inc.
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+#ifndef REGULATOR_ADP_SWITCH
+#define REGULATOR_ADP_SWITCH
+
+#include <linux/regulator/machine.h>
+
+/**
+ * adp_switch_platform_data - platform data for power swtich
+ * @regulator_num: number of regulators
+ * @regulator_data: regulator init data
+ */
+struct adp_switch_platform_data {
+	unsigned short regulator_num;
+	struct regulator_init_data *regulator_data;
+};
+
+#endif
-- 
1.7.1

