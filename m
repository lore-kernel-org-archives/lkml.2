Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1LIOTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:19:11 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:29819 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab1LIOTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:19:07 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202hzz8275bhz2dh2a8h668h839h93fh62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH 01/06] MFD: DA9052/53 MFD core module v9
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>,
        <linaro-dev@lists.linaro.org>, <arnd@arndb.de>, <eric.miao@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 9 Dec 2011 19:45:44 +0530
Message-ID: <1323440144.23171.69.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DA9052/53 is a highly integrated PMIC subsystem with supply domain
flexibility to support wide range of high performance application.

It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
control and other functionality.

This patch is functionally tested on Samsung SMDKV6410.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
Changes since v9:
- Add support for regmap_irq
- Patch split into I2C, ADC and SPI
- Support unconditional registration of all the regulators
- Replace magic number with define
- Remove user define bus_type from struct da9052
- Use spi_device_id - implemented in spi incremental patch 
- Remove ADC deadlock issue - implemented in ADC incremental patch
Changes since v8:
- Add read/write mask flag for SPI
Changes since v7:
- Replace ADC polling with interrupt mechanism
- Move macros related to battery module IRQs to header file
Changes since v6:
- Move inlined device I/O functions to header file
Changes since v5:
- Inline device I/O
- Unhandle IRQ return IRQ_NONE
- Remove register address conversion
Changes since v4:
- Modify KConfig 
- Use device registration for detemining chip id
- Remove preprocessor directive with runtime bustype variable
- Replace module_init() for spi with subsys_initcall()
- Remove platform string from MODULE_ALIAS of spi module.
Changes since v3:
- Code refactored to use REGMAP API.
- Add Battery resources.
- da9052_set_bits() and da9052_clear_bits() replaced by da9052_reg_update().
- Add support for DA9053 PMIC
Changes since v2:
- Drop da9052_irqs[] table.
- Move struct da9052_subdev_info[].
- Remove initialization of static member.
- Care for NULL pdata init().
- Check removal of subdevices on errors.
- Remove open source spi code.
- Remove '_spi' from the driver name.
- Move tbat_lookup table from header file.
- Remove irq.h 
- Remove num_gpio variable from pdata
---
 drivers/mfd/Kconfig               |   16 +
 drivers/mfd/Makefile              |    4 +
 drivers/mfd/da9052-core.c         |  366 +++++++++++++++++
 drivers/mfd/da9052-i2c.c          |  144 +++++++
 include/linux/mfd/da9052/da9052.h |  150 +++++++
 include/linux/mfd/da9052/pdata.h  |   40 ++
 include/linux/mfd/da9052/reg.h    |  778 +++++++++++++++++++++++++++++++++++++
 7 files changed, 1498 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/da9052-core.c
 create mode 100644 drivers/mfd/da9052-i2c.c
 create mode 100644 include/linux/mfd/da9052/da9052.h
 create mode 100644 include/linux/mfd/da9052/pdata.h
 create mode 100644 include/linux/mfd/da9052/reg.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f1391c2..baced42 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -328,6 +328,22 @@ config PMIC_DA903X
 	  individual components like LCD backlight, voltage regulators,
 	  LEDs and battery-charger under the corresponding menus.
 
+config PMIC_DA9052
+	bool
+	select MFD_CORE
+
+config MFD_DA9052_I2C
+	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with I2C"
+	select REGMAP_I2C
+	select REGMAP_IRQ
+	select PMIC_DA9052
+	depends on I2C=y
+	help
+	  Support for the Dialog Semiconductor DA9052 PMIC
+	  when controlled using I2C. This driver provides common support
+	  for accessing the device, additional drivers must be enabled in
+	  order to use the functionality of the device.
+
 config PMIC_ADP5520
 	bool "Analog Devices ADP5520/01 MFD PMIC Core Support"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b2292eb..484f209 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -67,6 +67,10 @@ endif
 obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
+
+obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
+obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
+
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
 obj-$(CONFIG_MFD_MAX8997)	+= max8997.o max8997-irq.o
diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
new file mode 100644
index 0000000..0e12055
--- /dev/null
+++ b/drivers/mfd/da9052-core.c
@@ -0,0 +1,366 @@
+/*
+ * Device access for Dialog DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/pdata.h>
+#include <linux/mfd/da9052/reg.h>
+
+#define DA9052_NUM_IRQ_REGS		4
+#define DA9052_IRQ_MASK_POS_1		0x01
+#define DA9052_IRQ_MASK_POS_2		0x02
+#define DA9052_IRQ_MASK_POS_3		0x04
+#define DA9052_IRQ_MASK_POS_4		0x08
+#define DA9052_IRQ_MASK_POS_5		0x10
+#define DA9052_IRQ_MASK_POS_6		0x20
+#define DA9052_IRQ_MASK_POS_7		0x40
+#define DA9052_IRQ_MASK_POS_8		0x80
+
+static struct resource da9052_rtc_resource = {
+	.name = "ALM",
+	.start = DA9052_IRQ_ALARM,
+	.end   = DA9052_IRQ_ALARM,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct resource da9052_onkey_resource = {
+	.name = "ONKEY",
+	.start = DA9052_IRQ_NONKEY,
+	.end   = DA9052_IRQ_NONKEY,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct resource da9052_bat_resources[] = {
+	{
+		.name = "BATT TEMP",
+		.start = DA9052_IRQ_TBAT,
+		.end   = DA9052_IRQ_TBAT,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "DCIN DET",
+		.start = DA9052_IRQ_DCIN,
+		.end   = DA9052_IRQ_DCIN,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "DCIN REM",
+		.start = DA9052_IRQ_DCINREM,
+		.end   = DA9052_IRQ_DCINREM,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS DET",
+		.start = DA9052_IRQ_VBUS,
+		.end   = DA9052_IRQ_VBUS,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS REM",
+		.start = DA9052_IRQ_VBUSREM,
+		.end   = DA9052_IRQ_VBUSREM,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "CHG END",
+		.start = DA9052_IRQ_CHGEND,
+		.end   = DA9052_IRQ_CHGEND,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource da9052_tsi_resources[] = {
+	{
+		.name = "PENDWN",
+		.start = DA9052_IRQ_PENDOWN,
+		.end   = DA9052_IRQ_PENDOWN,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "TSIRDY",
+		.start = DA9052_IRQ_TSIREADY,
+		.end   = DA9052_IRQ_TSIREADY,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+int da9052_add_regulator_devices(struct da9052 *da9052)
+{
+	struct platform_device *pdev;
+	int i, ret;
+
+	for (i = 0; i < DA9052_MAX_REGULATORS; i++) {
+		pdev = platform_device_alloc("da9052-regulator", i);
+		if (!pdev)
+			return -ENOMEM;
+
+		pdev->dev.parent = da9052->dev;
+		ret = platform_device_add(pdev);
+		if (ret) {
+			platform_device_put(pdev);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static struct mfd_cell __initdata da9052_subdev_info[] = {
+	{
+		.name = "da9052-onkey",
+		.resources = &da9052_onkey_resource,
+		.num_resources = 1,
+	},
+	{
+		.name = "da9052-rtc",
+		.resources = &da9052_rtc_resource,
+		.num_resources = 1,
+	},
+	{
+		.name = "da9052-gpio",
+	},
+	{
+		.name = "da9052-hwmon",
+	},
+	{
+		.name = "da9052-leds",
+	},
+	{
+		.name = "da9052-wled1",
+	},
+	{
+		.name = "da9052-wled2",
+	},
+	{
+		.name = "da9052-wled3",
+	},
+	{
+		.name = "da9052-tsi",
+		.resources = da9052_tsi_resources,
+		.num_resources = ARRAY_SIZE(da9052_tsi_resources),
+	},
+	{
+		.name = "da9052-bat",
+		.resources = da9052_bat_resources,
+		.num_resources = ARRAY_SIZE(da9052_bat_resources),
+	},
+	{
+		.name = "da9052-watchdog",
+	},
+};
+
+static struct regmap_irq da9052_irqs[] = {
+	[DA9052_IRQ_DCIN] = {
+		.reg_offset = 0,
+		.mask = DA9052_IRQ_MASK_POS_1,
+	},
+	[DA9052_IRQ_VBUS] = {
+		.reg_offset = 0,
+		.mask = DA9052_IRQ_MASK_POS_2,
+	},
+	[DA9052_IRQ_DCINREM] = {
+		.reg_offset = 0,
+		.mask = DA9052_IRQ_MASK_POS_3,
+	},
+	[DA9052_IRQ_VBUSREM] = {
+		.reg_offset = 0,
+		.mask = DA9052_IRQ_MASK_POS_4,
+	},
+	[DA9052_IRQ_VDDLOW] = {
+		.reg_offset = 0,
+		.mask = DA9052_IRQ_MASK_POS_5,
+	},
+	[DA9052_IRQ_ALARM] = {
+		.reg_offset = 0,
+		.mask = DA9052_IRQ_MASK_POS_6,
+	},
+	[DA9052_IRQ_SEQRDY] = {
+		.reg_offset = 0,
+		.mask = DA9052_IRQ_MASK_POS_7,
+	},
+	[DA9052_IRQ_COMP1V2] = {
+		.reg_offset = 0,
+		.mask = DA9052_IRQ_MASK_POS_8,
+	},
+	[DA9052_IRQ_NONKEY] = {
+		.reg_offset = 1,
+		.mask = DA9052_IRQ_MASK_POS_1,
+	},
+	[DA9052_IRQ_IDFLOAT] = {
+		.reg_offset = 1,
+		.mask = DA9052_IRQ_MASK_POS_2,
+	},
+	[DA9052_IRQ_IDGND] = {
+		.reg_offset = 1,
+		.mask = DA9052_IRQ_MASK_POS_3,
+	},
+	[DA9052_IRQ_CHGEND] = {
+		.reg_offset = 1,
+		.mask = DA9052_IRQ_MASK_POS_4,
+	},
+	[DA9052_IRQ_TBAT] = {
+		.reg_offset = 1,
+		.mask = DA9052_IRQ_MASK_POS_5,
+	},
+	[DA9052_IRQ_ADC_EOM] = {
+		.reg_offset = 1,
+		.mask = DA9052_IRQ_MASK_POS_6,
+	},
+	[DA9052_IRQ_PENDOWN] = {
+		.reg_offset = 1,
+		.mask = DA9052_IRQ_MASK_POS_7,
+	},
+	[DA9052_IRQ_TSIREADY] = {
+		.reg_offset = 1,
+		.mask = DA9052_IRQ_MASK_POS_8,
+	},
+	[DA9052_IRQ_GPI0] = {
+		.reg_offset = 2,
+		.mask = DA9052_IRQ_MASK_POS_1,
+	},
+	[DA9052_IRQ_GPI1] = {
+		.reg_offset = 2,
+		.mask = DA9052_IRQ_MASK_POS_2,
+	},
+	[DA9052_IRQ_GPI2] = {
+		.reg_offset = 2,
+		.mask = DA9052_IRQ_MASK_POS_3,
+	},
+	[DA9052_IRQ_GPI3] = {
+		.reg_offset = 2,
+		.mask = DA9052_IRQ_MASK_POS_4,
+	},
+	[DA9052_IRQ_GPI4] = {
+		.reg_offset = 2,
+		.mask = DA9052_IRQ_MASK_POS_5,
+	},
+	[DA9052_IRQ_GPI5] = {
+		.reg_offset = 2,
+		.mask = DA9052_IRQ_MASK_POS_6,
+	},
+	[DA9052_IRQ_GPI6] = {
+		.reg_offset = 2,
+		.mask = DA9052_IRQ_MASK_POS_7,
+	},
+	[DA9052_IRQ_GPI7] = {
+		.reg_offset = 2,
+		.mask = DA9052_IRQ_MASK_POS_8,
+	},
+	[DA9052_IRQ_GPI8] = {
+		.reg_offset = 3,
+		.mask = DA9052_IRQ_MASK_POS_1,
+	},
+	[DA9052_IRQ_GPI9] = {
+		.reg_offset = 3,
+		.mask = DA9052_IRQ_MASK_POS_2,
+	},
+	[DA9052_IRQ_GPI10] = {
+		.reg_offset = 3,
+		.mask = DA9052_IRQ_MASK_POS_3,
+	},
+	[DA9052_IRQ_GPI11] = {
+		.reg_offset = 3,
+		.mask = DA9052_IRQ_MASK_POS_4,
+	},
+	[DA9052_IRQ_GPI12] = {
+		.reg_offset = 3,
+		.mask = DA9052_IRQ_MASK_POS_5,
+	},
+	[DA9052_IRQ_GPI13] = {
+		.reg_offset = 3,
+		.mask = DA9052_IRQ_MASK_POS_6,
+	},
+	[DA9052_IRQ_GPI14] = {
+		.reg_offset = 3,
+		.mask = DA9052_IRQ_MASK_POS_7,
+	},
+	[DA9052_IRQ_GPI15] = {
+		.reg_offset = 3,
+		.mask = DA9052_IRQ_MASK_POS_8,
+	},
+};
+
+static struct regmap_irq_chip da9052_regmap_irq_chip = {
+	.name = "da9052_irq",
+	.status_base = DA9052_EVENT_A_REG,
+	.mask_base = DA9052_IRQ_MASK_A_REG,
+	.ack_base = DA9052_EVENT_A_REG,
+	.num_regs = DA9052_NUM_IRQ_REGS,
+	.irqs = da9052_irqs,
+	.num_irqs = ARRAY_SIZE(da9052_irqs),
+};
+
+int da9052_device_init(struct da9052 *da9052, u8 chip_id)
+{
+	struct da9052_pdata *pdata = da9052->dev->platform_data;
+	struct irq_desc *desc;
+	int ret;
+
+	mutex_init(&da9052->io_lock);
+
+	if (pdata && pdata->init != NULL)
+		pdata->init(da9052);
+
+	da9052->chip_id = chip_id;
+
+	if (!pdata && !pdata->irq_base)
+		da9052->irq_base = -1;
+	else
+		da9052->irq_base = pdata->irq_base;
+
+	ret = regmap_add_irq_chip(da9052->regmap, da9052->chip_irq,
+				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				  da9052->irq_base, &da9052_regmap_irq_chip,
+				  NULL);
+	if (ret < 0)
+		goto regmap_err;
+
+	ret = da9052_add_regulator_devices(da9052);
+	if (ret)
+		goto err;
+
+	desc = irq_to_desc(da9052->chip_irq);
+	da9052->irq_base = regmap_irq_chip_get_base(desc->action->dev_id);
+
+	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
+			      ARRAY_SIZE(da9052_subdev_info), NULL, 0);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	mfd_remove_devices(da9052->dev);
+regmap_err:
+	return ret;
+}
+
+void da9052_device_exit(struct da9052 *da9052)
+{
+	regmap_del_irq_chip(da9052->chip_irq,
+			    irq_get_irq_data(da9052->irq_base)->chip_data);
+	mfd_remove_devices(da9052->dev);
+}
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("DA9052 MFD Core");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
new file mode 100644
index 0000000..3c49c56
--- /dev/null
+++ b/drivers/mfd/da9052-i2c.c
@@ -0,0 +1,144 @@
+/*
+ * I2C access for DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/mfd/core.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+static int da9052_i2c_enable_multiwrite(struct da9052 *da9052)
+{
+	int reg_val, ret;
+
+	ret = regmap_read(da9052->regmap, DA9052_CONTROL_B_REG, &reg_val);
+	if (ret < 0)
+		return ret;
+
+	if (reg_val & DA9052_CONTROL_B_WRITEMODE) {
+		reg_val &= ~DA9052_CONTROL_B_WRITEMODE;
+		ret = regmap_write(da9052->regmap, DA9052_CONTROL_B_REG,
+				   reg_val);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static struct regmap_config da9052_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int __devinit da9052_i2c_probe(struct i2c_client *client,
+				       const struct i2c_device_id *id)
+{
+	struct da9052 *da9052;
+	int ret;
+
+	da9052 = kzalloc(sizeof(struct da9052), GFP_KERNEL);
+	if (!da9052)
+		return -ENOMEM;
+
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_info(&client->dev, "Error in %s:i2c_check_functionality\n",
+			 __func__);
+		return -ENODEV;
+	}
+
+	da9052->dev = &client->dev;
+	da9052->chip_irq = client->irq;
+
+	i2c_set_clientdata(client, da9052);
+
+	da9052->regmap = regmap_init_i2c(client, &da9052_regmap_config);
+	if (IS_ERR(da9052->regmap)) {
+		ret = PTR_ERR(da9052->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+			ret);
+		goto err;
+	}
+
+	ret = da9052_i2c_enable_multiwrite(da9052);
+	if (ret < 0)
+		goto err;
+
+	ret = da9052_device_init(da9052, id->driver_data);
+	if (ret != 0)
+		goto err;
+
+	return 0;
+
+err:
+	kfree(da9052);
+	return ret;
+}
+
+static int da9052_i2c_remove(struct i2c_client *client)
+{
+	struct da9052 *da9052 = i2c_get_clientdata(client);
+
+	da9052_device_exit(da9052);
+	kfree(da9052);
+
+	return 0;
+}
+
+static struct i2c_device_id da9052_i2c_id[] = {
+	{"da9052", DA9052},
+	{"da9053-aa", DA9053_AA},
+	{"da9053-ba", DA9053_BA},
+	{"da9053-bb", DA9053_BB},
+	{}
+};
+
+static struct i2c_driver da9052_i2c_driver = {
+	.probe = da9052_i2c_probe,
+	.remove = da9052_i2c_remove,
+	.id_table = da9052_i2c_id,
+	.driver = {
+		.name = "da9052",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init da9052_i2c_init(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&da9052_i2c_driver);
+	if (ret != 0) {
+		pr_err("DA9052 I2C registration failed %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+subsys_initcall(da9052_i2c_init);
+
+static void __exit da9052_i2c_exit(void)
+{
+	i2c_del_driver(&da9052_i2c_driver);
+}
+module_exit(da9052_i2c_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("I2C driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
new file mode 100644
index 0000000..f53b77a
--- /dev/null
+++ b/include/linux/mfd/da9052/da9052.h
@@ -0,0 +1,150 @@
+/*
+ * da9052 declarations for DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __MFD_DA9052_DA9052_H
+#define __MFD_DA9052_DA9052_H
+
+#include <linux/interrupt.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/completion.h>
+#include <linux/list.h>
+#include <linux/mfd/core.h>
+
+#include <linux/mfd/da9052/reg.h>
+
+#define DA9052_IRQ_DCIN	0
+#define DA9052_IRQ_VBUS	1
+#define DA9052_IRQ_DCINREM	2
+#define DA9052_IRQ_VBUSREM	3
+#define DA9052_IRQ_VDDLOW	4
+#define DA9052_IRQ_ALARM	5
+#define DA9052_IRQ_SEQRDY	6
+#define DA9052_IRQ_COMP1V2	7
+#define DA9052_IRQ_NONKEY	8
+#define DA9052_IRQ_IDFLOAT	9
+#define DA9052_IRQ_IDGND	10
+#define DA9052_IRQ_CHGEND	11
+#define DA9052_IRQ_TBAT	12
+#define DA9052_IRQ_ADC_EOM	13
+#define DA9052_IRQ_PENDOWN	14
+#define DA9052_IRQ_TSIREADY	15
+#define DA9052_IRQ_GPI0	16
+#define DA9052_IRQ_GPI1	17
+#define DA9052_IRQ_GPI2	18
+#define DA9052_IRQ_GPI3	19
+#define DA9052_IRQ_GPI4	20
+#define DA9052_IRQ_GPI5	21
+#define DA9052_IRQ_GPI6	22
+#define DA9052_IRQ_GPI7	23
+#define DA9052_IRQ_GPI8	24
+#define DA9052_IRQ_GPI9	25
+#define DA9052_IRQ_GPI10	26
+#define DA9052_IRQ_GPI11	27
+#define DA9052_IRQ_GPI12	28
+#define DA9052_IRQ_GPI13	29
+#define DA9052_IRQ_GPI14	30
+#define DA9052_IRQ_GPI15	31
+
+enum da9052_chip_id {
+	DA9052,
+	DA9053_AA,
+	DA9053_BA,
+	DA9053_BB,
+};
+
+struct da9052_pdata;
+
+struct da9052 {
+	struct mutex io_lock;
+
+	struct device *dev;
+	struct i2c_client *i2c_client;
+	struct regmap *regmap;
+
+	int irq_base;
+	u8 chip_id;
+
+	int chip_irq;
+};
+
+/* Device I/O API */
+static inline int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
+{
+	int val, ret;
+
+	if (reg > DA9052_MAX_REG_CNT) {
+		dev_err(da9052->dev, "invalid reg %x\n", reg);
+		return -EINVAL;
+	}
+
+	ret = regmap_read(da9052->regmap, reg, &val);
+	if (ret < 0)
+		return ret;
+	return val;
+}
+
+static inline int da9052_reg_write(struct da9052 *da9052, unsigned char reg,
+				    unsigned char val)
+{
+	if (reg > DA9052_MAX_REG_CNT) {
+		dev_err(da9052->dev, "invalid reg %x\n", reg);
+		return -EINVAL;
+	}
+
+	return regmap_write(da9052->regmap, reg, val);
+}
+
+static inline int da9052_group_read(struct da9052 *da9052, unsigned char reg,
+				     unsigned reg_cnt, unsigned char *val)
+{
+	if (reg > DA9052_MAX_REG_CNT) {
+		dev_err(da9052->dev, "invalid reg %x\n", reg);
+		return -EINVAL;
+	}
+
+	return regmap_bulk_read(da9052->regmap, reg, val, reg_cnt);
+}
+
+static inline int da9052_group_write(struct da9052 *da9052, unsigned char reg,
+				      unsigned reg_cnt, unsigned char *val)
+{
+	return regmap_raw_write(da9052->regmap, reg, val, reg_cnt);
+}
+
+static inline int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
+				     unsigned char bit_mask,
+				     unsigned char reg_val)
+{
+	if (reg > DA9052_MAX_REG_CNT) {
+		dev_err(da9052->dev, "invalid reg %x\n", reg);
+		return -EINVAL;
+	}
+
+	return regmap_update_bits(da9052->regmap, reg, bit_mask, reg_val);
+}
+
+int da9052_device_init(struct da9052 *da9052, u8 chip_id);
+void da9052_device_exit(struct da9052 *da9052);
+
+#endif /* __MFD_DA9052_DA9052_H */
diff --git a/include/linux/mfd/da9052/pdata.h b/include/linux/mfd/da9052/pdata.h
new file mode 100644
index 0000000..62c5c3c
--- /dev/null
+++ b/include/linux/mfd/da9052/pdata.h
@@ -0,0 +1,40 @@
+/*
+ * Platform data declarations for DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __MFD_DA9052_PDATA_H__
+#define __MFD_DA9052_PDATA_H__
+
+#define DA9052_MAX_REGULATORS	14
+
+struct da9052;
+
+struct da9052_pdata {
+	struct led_platform_data *pled;
+	int (*init) (struct da9052 *da9052);
+	int irq_base;
+	int gpio_base;
+	int use_for_apm;
+	struct regulator_init_data *regulators[DA9052_MAX_REGULATORS];
+};
+
+#endif
diff --git a/include/linux/mfd/da9052/reg.h b/include/linux/mfd/da9052/reg.h
new file mode 100644
index 0000000..7552456
--- /dev/null
+++ b/include/linux/mfd/da9052/reg.h
@@ -0,0 +1,778 @@
+/*
+ * Register declarations for DA9052 PMICs.
+ *
+ * Copyright(c) 2011 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_DA9052_REG_H
+#define __LINUX_MFD_DA9052_REG_H
+
+#define DA9052_MAX_REG_CNT		128
+
+/*STATUS REGISTERS*/
+#define DA9052_STATUS_A_REG		1
+#define DA9052_STATUS_B_REG		2
+#define DA9052_STATUS_C_REG		3
+#define DA9052_STATUS_D_REG		4
+
+/*EVENT REGISTERS*/
+#define DA9052_EVENT_A_REG		5
+#define DA9052_EVENT_B_REG		6
+#define DA9052_EVENT_C_REG		7
+#define DA9052_EVENT_D_REG		8
+#define DA9052_FAULTLOG_REG		9
+
+/*IRQ REGISTERS*/
+#define DA9052_IRQ_MASK_A_REG		10
+#define DA9052_IRQ_MASK_B_REG		11
+#define DA9052_IRQ_MASK_C_REG		12
+#define DA9052_IRQ_MASK_D_REG		13
+
+/*CONTROL REGISTERS*/
+#define DA9052_CONTROL_A_REG		14
+#define DA9052_CONTROL_B_REG		15
+#define DA9052_CONTROL_C_REG		16
+#define DA9052_CONTROL_D_REG		17
+
+#define DA9052_PDDIS_REG		18
+#define DA9052_INTERFACE_REG		19
+#define DA9052_RESET_REG		20
+
+/*GPIO REGISTERS*/
+#define DA9052_GPIO_0_1_REG		21
+#define DA9052_GPIO_2_3_REG		22
+#define DA9052_GPIO_4_5_REG		23
+#define DA9052_GPIO_6_7_REG		24
+#define DA9052_GPIO_14_15_REG		28
+
+/*LDO AND BUCK REGISTERS*/
+#define DA9052_BUCKA_REG		44
+#define DA9052_BUCKB_REG		45
+#define DA9052_BUCKCORE_REG		46
+#define DA9052_BUCKPRO_REG		47
+#define DA9052_BUCKMEM_REG		48
+#define DA9052_BUCKPERI_REG		49
+#define DA9052_LDO1_REG		50
+#define DA9052_LDO2_REG		51
+#define DA9052_LDO3_REG		52
+#define DA9052_LDO4_REG		53
+#define DA9052_LDO5_REG		54
+#define DA9052_LDO6_REG		55
+#define DA9052_LDO7_REG		56
+#define DA9052_LDO8_REG		57
+#define DA9052_LDO9_REG		58
+#define DA9052_LDO10_REG		59
+#define DA9052_SUPPLY_REG		60
+#define DA9052_PULLDOWN_REG		61
+#define DA9052_CHGBUCK_REG		62
+#define DA9052_WAITCONT_REG		63
+#define DA9052_ISET_REG		64
+#define DA9052_BATCHG_REG		65
+
+/*BATTERY CONTROL REGISTRS*/
+#define DA9052_CHG_CONT_REG		66
+#define DA9052_INPUT_CONT_REG		67
+#define DA9052_CHG_TIME_REG		68
+#define DA9052_BBAT_CONT_REG		69
+
+/*LED CONTROL REGISTERS*/
+#define DA9052_BOOST_REG		70
+#define DA9052_LED_CONT_REG		71
+#define DA9052_LEDMIN123_REG		72
+#define DA9052_LED1_CONF_REG		73
+#define DA9052_LED2_CONF_REG		74
+#define DA9052_LED3_CONF_REG		75
+#define DA9052_LED1CONT_REG		76
+#define DA9052_LED2CONT_REG		77
+#define DA9052_LED3CONT_REG		78
+#define DA9052_LED_CONT_4_REG		79
+#define DA9052_LED_CONT_5_REG		80
+
+/*ADC CONTROL REGISTERS*/
+#define DA9052_ADC_MAN_REG		81
+#define DA9052_ADC_CONT_REG		82
+#define DA9052_ADC_RES_L_REG		83
+#define DA9052_ADC_RES_H_REG		84
+#define DA9052_VDD_RES_REG		85
+#define DA9052_VDD_MON_REG		86
+
+/*SM CONTROL REGISTERS*/
+#define DA9052_ICHG_AV_REG		87
+#define DA9052_ICHG_THD_REG		88
+#define DA9052_ICHG_END_REG		89
+#define DA9052_TBAT_RES_REG		90
+#define DA9052_TBAT_HIGHP_REG		91
+#define DA9052_TBAT_HIGHIN_REG		92
+#define DA9052_TBAT_LOW_REG		93
+#define DA9052_T_OFFSET_REG		94
+
+/*TSI CONTROL REGISTERS*/
+#define DA9052_TJUNC_RES_REG		104
+#define DA9052_TSI_CONT_A_REG		105
+#define DA9052_TSI_CONT_B_REG		106
+#define DA9052_TSI_X_MSB_REG		107
+#define DA9052_TSI_Y_MSB_REG		108
+#define DA9052_TSI_LSB_REG		109
+#define DA9052_TSI_Z_MSB_REG		110
+
+/*RTC COUNT REGISTERS*/
+#define DA9052_COUNT_S_REG		111
+#define DA9052_COUNT_MI_REG		112
+#define DA9052_COUNT_H_REG		113
+#define DA9052_COUNT_D_REG		114
+#define DA9052_COUNT_MO_REG		115
+#define DA9052_COUNT_Y_REG		116
+
+/*RTC CONTROL REGISTERS*/
+#define DA9052_ALARM_MI_REG		117
+#define DA9052_ALARM_H_REG		118
+#define DA9052_ALARM_D_REG		119
+#define DA9052_ALARM_MO_REG		120
+#define DA9052_ALARM_Y_REG		121
+
+/* Reg Page Configuration */
+#define DA9052_PAGECON0_REGPAGE	0x80
+
+/* Onkey Event Registers */
+#define DA9052_M_nONKEY		0x0100
+#define DA9052_E_nONKEY		0x01
+
+/* TSI Event Registers */
+#define DA9052_E_PEN_DOWN		0x4000
+#define DA9052_E_TSI_READY		0x8000
+
+/* PAGE CONFIGURATION 128 REGISTER */
+#define DA9052_PAGECON128_REGPAGE	0x80
+
+/* STATUS REGISTER A */
+#define DA9052_STATUSA_VDATDET		0x80
+#define DA9052_STATUSA_VBUSSEL		0x40
+#define DA9052_STATUSA_DCINSEL		0x20
+#define DA9052_STATUSA_VBUSDET		0x10
+#define DA9052_STATUSA_DCINDET		0x08
+#define DA9052_STATUSA_IDGND		0x04
+#define DA9052_STATUSA_IDFLOAT		0x02
+#define DA9052_STATUSA_NONKEY		0x01
+
+/* STATUS REGISTER B */
+#define DA9052_STATUSB_COMPDET		0x80
+#define DA9052_STATUSB_SEQUENCING	0x40
+#define DA9052_STATUSB_GPFB2		0x20
+#define DA9052_STATUSB_CHGTO		0x10
+#define DA9052_STATUSB_CHGEND		0x08
+#define DA9052_STATUSB_CHGLIM		0x04
+#define DA9052_STATUSB_CHGPRE		0x02
+#define DA9052_STATUSB_CHGATT		0x01
+
+/* STATUS REGISTER C */
+#define DA9052_STATUSC_GPI7		0x80
+#define DA9052_STATUSC_GPI6		0x40
+#define DA9052_STATUSC_GPI5		0x20
+#define DA9052_STATUSC_GPI4		0x10
+#define DA9052_STATUSC_GPI3		0x08
+#define DA9052_STATUSC_GPI2		0x04
+#define DA9052_STATUSC_GPI1		0x02
+#define DA9052_STATUSC_GPI0		0x01
+
+/* STATUS REGISTER D */
+#define DA9052_STATUSD_GPI15		0x80
+#define DA9052_STATUSD_GPI14		0x40
+#define DA9052_STATUSD_GPI13		0x20
+#define DA9052_STATUSD_GPI12		0x10
+#define DA9052_STATUSD_GPI11		0x08
+#define DA9052_STATUSD_GPI10		0x04
+#define DA9052_STATUSD_GPI9		0x02
+#define DA9052_STATUSD_GPI8		0x01
+
+/* EVENT REGISTER A */
+#define DA9052_EVENTA_ECOMP1V2		0x80
+#define DA9052_EVENTA_ESEQRDY		0x40
+#define DA9052_EVENTA_EALRAM		0x20
+#define DA9052_EVENTA_EVDDLOW		0x10
+#define DA9052_EVENTA_EVBUSREM		0x08
+#define DA9052_EVENTA_EDCINREM		0x04
+#define DA9052_EVENTA_EVBUSDET		0x02
+#define DA9052_EVENTA_EDCINDET		0x01
+
+/* EVENT REGISTER B */
+#define DA9052_EVENTB_ETSIREADY	0x80
+#define DA9052_EVENTB_EPENDOWN		0x40
+#define DA9052_EVENTB_EADCEOM		0x20
+#define DA9052_EVENTB_ETBAT		0x10
+#define DA9052_EVENTB_ECHGEND		0x08
+#define DA9052_EVENTB_EIDGND		0x04
+#define DA9052_EVENTB_EIDFLOAT		0x02
+#define DA9052_EVENTB_ENONKEY		0x01
+
+/* EVENT REGISTER C */
+#define DA9052_EVENTC_EGPI7		0x80
+#define DA9052_EVENTC_EGPI6		0x40
+#define DA9052_EVENTC_EGPI5		0x20
+#define DA9052_EVENTC_EGPI4		0x10
+#define DA9052_EVENTC_EGPI3		0x08
+#define DA9052_EVENTC_EGPI2		0x04
+#define DA9052_EVENTC_EGPI1		0x02
+#define DA9052_EVENTC_EGPI0		0x01
+
+/* EVENT REGISTER D */
+#define DA9052_EVENTD_EGPI15		0x80
+#define DA9052_EVENTD_EGPI14		0x40
+#define DA9052_EVENTD_EGPI13		0x20
+#define DA9052_EVENTD_EGPI12		0x10
+#define DA9052_EVENTD_EGPI11		0x08
+#define DA9052_EVENTD_EGPI10		0x04
+#define DA9052_EVENTD_EGPI9		0x02
+#define DA9052_EVENTD_EGPI8		0x01
+
+/* FAULT LOG REGISTER */
+#define DA9052_FAULTLOG_WAITSET	0x80
+#define DA9052_FAULTLOG_NSDSET		0x40
+#define DA9052_FAULTLOG_KEYSHUT	0x20
+#define DA9052_FAULTLOG_TEMPOVER	0x08
+#define DA9052_FAULTLOG_VDDSTART	0x04
+#define DA9052_FAULTLOG_VDDFAULT	0x02
+#define DA9052_FAULTLOG_TWDERROR	0x01
+
+/* CONTROL REGISTER A */
+#define DA9052_CONTROLA_GPIV		0x80
+#define DA9052_CONTROLA_PMOTYPE	0x20
+#define DA9052_CONTROLA_PMOV		0x10
+#define DA9052_CONTROLA_PMIV		0x08
+#define DA9052_CONTROLA_PMIFV		0x08
+#define DA9052_CONTROLA_PWR1EN		0x04
+#define DA9052_CONTROLA_PWREN		0x02
+#define DA9052_CONTROLA_SYSEN		0x01
+
+/* CONTROL REGISTER B */
+#define DA9052_CONTROLB_SHUTDOWN	0x80
+#define DA9052_CONTROLB_DEEPSLEEP	0x40
+#define DA9052_CONTROL_B_WRITEMODE	0x20
+#define DA9052_CONTROLB_BBATEN		0x10
+#define DA9052_CONTROLB_OTPREADEN	0x08
+#define DA9052_CONTROLB_AUTOBOOT	0x04
+#define DA9052_CONTROLB_ACTDIODE	0x02
+#define DA9052_CONTROLB_BUCKMERGE	0x01
+
+/* CONTROL REGISTER C */
+#define DA9052_CONTROLC_BLINKDUR	0x80
+#define DA9052_CONTROLC_BLINKFRQ	0x60
+#define DA9052_CONTROLC_DEBOUNCING	0x1C
+#define DA9052_CONTROLC_PMFB2PIN	0x02
+#define DA9052_CONTROLC_PMFB1PIN	0x01
+
+/* CONTROL REGISTER D */
+#define DA9052_CONTROLD_WATCHDOG	0x80
+#define DA9052_CONTROLD_ACCDETEN	0x40
+#define DA9052_CONTROLD_GPI1415SD	0x20
+#define DA9052_CONTROLD_NONKEYSD	0x10
+#define DA9052_CONTROLD_KEEPACTEN	0x08
+#define DA9052_CONTROLD_TWDSCALE	0x07
+
+/* POWER DOWN DISABLE REGISTER */
+#define DA9052_PDDIS_PMCONTPD		0x80
+#define DA9052_PDDIS_OUT32KPD		0x40
+#define DA9052_PDDIS_CHGBBATPD		0x20
+#define DA9052_PDDIS_CHGPD		0x10
+#define DA9052_PDDIS_HS2WIREPD		0x08
+#define DA9052_PDDIS_PMIFPD		0x04
+#define DA9052_PDDIS_GPADCPD		0x02
+#define DA9052_PDDIS_GPIOPD		0x01
+
+/* CONTROL REGISTER D */
+#define DA9052_INTERFACE_IFBASEADDR	0xE0
+#define DA9052_INTERFACE_NCSPOL	0x10
+#define DA9052_INTERFACE_RWPOL		0x08
+#define DA9052_INTERFACE_CPHA		0x04
+#define DA9052_INTERFACE_CPOL		0x02
+#define DA9052_INTERFACE_IFTYPE	0x01
+
+/* CONTROL REGISTER D */
+#define DA9052_RESET_RESETEVENT	0xC0
+#define DA9052_RESET_RESETTIMER	0x3F
+
+/* GPIO REGISTERS */
+
+/* GPIO control register */
+#define DA9052_GPIO_EVEN_PORT_PIN	0x03
+#define DA9052_GPIO_EVEN_PORT_TYPE	0x04
+#define DA9052_GPIO_EVEN_PORT_MODE	0x08
+
+#define DA9052_GPIO_ODD_PORT_PIN	0x30
+#define DA9052_GPIO_ODD_PORT_TYPE	0x40
+#define DA9052_GPIO_ODD_PORT_MODE	0x80
+
+/*POWER SEQUENCER REGISTER*/
+
+/* SEQ control register for ID 0 and 1 */
+#define DA9052_ID01_LDO1STEP		0xF0
+#define DA9052_ID01_SYSPRE		0x04
+#define DA9052_ID01_DEFSUPPLY		0x02
+#define DA9052_ID01_nRESMODE		0x01
+
+/* SEQ control register for ID 2 and 3 */
+#define DA9052_ID23_LDO3STEP		0xF0
+#define DA9052_ID23_LDO2STEP		0x0F
+
+/* SEQ control register for ID 4 and 5 */
+#define DA9052_ID45_LDO5STEP		0xF0
+#define DA9052_ID45_LDO4STEP		0x0F
+
+/* SEQ control register for ID 6 and 7 */
+#define DA9052_ID67_LDO7STEP		0xF0
+#define DA9052_ID67_LDO6STEP		0x0F
+
+/* SEQ control register for ID 8 and 9 */
+#define DA9052_ID89_LDO9STEP		0xF0
+#define DA9052_ID89_LDO8STEP		0x0F
+
+/* SEQ control register for ID 10 and 11 */
+#define DA9052_ID1011_PDDISSTEP	0xF0
+#define DA9052_ID1011_LDO10STEP	0x0F
+
+/* SEQ control register for ID 12 and 13 */
+#define DA9052_ID1213_VMEMSWSTEP	0xF0
+#define DA9052_ID1213_VPERISWSTEP	0x0F
+
+/* SEQ control register for ID 14 and 15 */
+#define DA9052_ID1415_BUCKPROSTEP	0xF0
+#define DA9052_ID1415_BUCKCORESTEP	0x0F
+
+/* SEQ control register for ID 16 and 17 */
+#define DA9052_ID1617_BUCKPERISTEP	0xF0
+#define DA9052_ID1617_BUCKMEMSTEP	0x0F
+
+/* SEQ control register for ID 18 and 19 */
+#define DA9052_ID1819_GPRISE2STEP	0xF0
+#define DA9052_ID1819_GPRISE1STEP	0x0F
+
+/* SEQ control register for ID 20 and 21 */
+#define DA9052_ID2021_GPFALL2STEP	0xF0
+#define DA9052_ID2021_GPFALL1STEP	0x0F
+
+/* Power SEQ Status register */
+#define DA9052_SEQSTATUS_SEQPOINTER	0xF0
+#define DA9052_SEQSTATUS_WAITSTEP	0x0F
+
+/* Power SEQ A register */
+#define DA9052_SEQA_POWEREND		0xF0
+#define DA9052_SEQA_SYSTEMEND		0x0F
+
+/* Power SEQ B register */
+#define DA9052_SEQB_PARTDOWN		0xF0
+#define DA9052_SEQB_MAXCOUNT		0x0F
+
+/* Power SEQ TIMER register */
+#define DA9052_SEQTIMER_SEQDUMMY	0xF0
+#define DA9052_SEQTIMER_SEQTIME	0x0F
+
+/*POWER SUPPLY CONTROL REGISTER*/
+
+/* BUCK REGISTER A */
+#define DA9052_BUCKA_BPROILIM		0xC0
+#define DA9052_BUCKA_BPROMODE		0x30
+#define DA9052_BUCKA_BCOREILIM		0x0C
+#define DA9052_BUCKA_BCOREMODE		0x03
+
+/* BUCK REGISTER B */
+#define DA9052_BUCKB_BERIILIM		0xC0
+#define DA9052_BUCKB_BPERIMODE		0x30
+#define DA9052_BUCKB_BMEMILIM		0x0C
+#define DA9052_BUCKB_BMEMMODE		0x03
+
+/* BUCKCORE REGISTER */
+#define DA9052_BUCKCORE_BCORECONF	0x80
+#define DA9052_BUCKCORE_BCOREEN	0x40
+#define DA9052_BUCKCORE_VBCORE		0x3F
+
+/* BUCKPRO REGISTER */
+#define DA9052_BUCKPRO_BPROCONF	0x80
+#define DA9052_BUCKPRO_BPROEN		0x40
+#define DA9052_BUCKPRO_VBPRO		0x3F
+
+/* BUCKMEM REGISTER */
+#define DA9052_BUCKMEM_BMEMCONF	0x80
+#define DA9052_BUCKMEM_BMEMEN		0x40
+#define DA9052_BUCKMEM_VBMEM		0x3F
+
+/* BUCKPERI REGISTER */
+#define DA9052_BUCKPERI_BPERICONF	0x80
+#define DA9052_BUCKPERI_BPERIEN	0x40
+#define DA9052_BUCKPERI_BPERIHS	0x20
+#define DA9052_BUCKPERI_VBPERI		0x1F
+
+/* LDO1 REGISTER */
+#define DA9052_LDO1_LDO1CONF		0x80
+#define DA9052_LDO1_LDO1EN		0x40
+#define DA9052_LDO1_VLDO1		0x1F
+
+/* LDO2 REGISTER */
+#define DA9052_LDO2_LDO2CONF		0x80
+#define DA9052_LDO2_LDO2EN		0x40
+#define DA9052_LDO2_VLDO2		0x3F
+
+/* LDO3 REGISTER */
+#define DA9052_LDO3_LDO3CONF		0x80
+#define DA9052_LDO3_LDO3EN		0x40
+#define DA9052_LDO3_VLDO3		0x3F
+
+/* LDO4 REGISTER */
+#define DA9052_LDO4_LDO4CONF		0x80
+#define DA9052_LDO4_LDO4EN		0x40
+#define DA9052_LDO4_VLDO4		0x3F
+
+/* LDO5 REGISTER */
+#define DA9052_LDO5_LDO5CONF		0x80
+#define DA9052_LDO5_LDO5EN		0x40
+#define DA9052_LDO5_VLDO5		0x3F
+
+/* LDO6 REGISTER */
+#define DA9052_LDO6_LDO6CONF		0x80
+#define DA9052_LDO6_LDO6EN		0x40
+#define DA9052_LDO6_VLDO6		0x3F
+
+/* LDO7 REGISTER */
+#define DA9052_LDO7_LDO7CONF		0x80
+#define DA9052_LDO7_LDO7EN		0x40
+#define DA9052_LDO7_VLDO7		0x3F
+
+/* LDO8 REGISTER */
+#define DA9052_LDO8_LDO8CONF		0x80
+#define DA9052_LDO8_LDO8EN		0x40
+#define DA9052_LDO8_VLDO8		0x3F
+
+/* LDO9 REGISTER */
+#define DA9052_LDO9_LDO9CONF		0x80
+#define DA9052_LDO9_LDO9EN		0x40
+#define DA9052_LDO9_VLDO9		0x3F
+
+/* LDO10 REGISTER */
+#define DA9052_LDO10_LDO10CONF		0x80
+#define DA9052_LDO10_LDO10EN		0x40
+#define DA9052_LDO10_VLDO10		0x3F
+
+/* SUPPLY REGISTER */
+#define DA9052_SUPPLY_VLOCK		0x80
+#define DA9052_SUPPLY_VMEMSWEN		0x40
+#define DA9052_SUPPLY_VPERISWEN	0x20
+#define DA9052_SUPPLY_VLDO3GO		0x10
+#define DA9052_SUPPLY_VLDO2GO		0x08
+#define DA9052_SUPPLY_VBMEMGO		0x04
+#define DA9052_SUPPLY_VBPROGO		0x02
+#define DA9052_SUPPLY_VBCOREGO		0x01
+
+/* PULLDOWN REGISTER */
+#define DA9052_PULLDOWN_LDO5PDDIS	0x20
+#define DA9052_PULLDOWN_LDO2PDDIS	0x10
+#define DA9052_PULLDOWN_LDO1PDDIS	0x08
+#define DA9052_PULLDOWN_MEMPDDIS	0x04
+#define DA9052_PULLDOWN_PROPDDIS	0x02
+#define DA9052_PULLDOWN_COREPDDIS	0x01
+
+/* BAT CHARGER REGISTER */
+
+/* CHARGER BUCK REGISTER */
+#define DA9052_CHGBUCK_CHGTEMP		0x80
+#define DA9052_CHGBUCK_CHGUSBILIM	0x40
+#define DA9052_CHGBUCK_CHGBUCKLP	0x20
+#define DA9052_CHGBUCK_CHGBUCKEN	0x10
+#define DA9052_CHGBUCK_ISETBUCK	0x0F
+
+/* WAIT COUNTER REGISTER */
+#define DA9052_WAITCONT_WAITDIR	0x80
+#define DA9052_WAITCONT_RTCCLOCK	0x40
+#define DA9052_WAITCONT_WAITMODE	0x20
+#define DA9052_WAITCONT_EN32KOUT	0x10
+#define DA9052_WAITCONT_DELAYTIME	0x0F
+
+/* ISET CONTROL REGISTER */
+#define DA9052_ISET_ISETDCIN		0xF0
+#define DA9052_ISET_ISETVBUS		0x0F
+
+/* BATTERY CHARGER CONTROL REGISTER */
+#define DA9052_BATCHG_ICHGPRE		0xC0
+#define DA9052_BATCHG_ICHGBAT		0x3F
+
+/* CHARGER COUNTER REGISTER */
+#define DA9052_CHG_CONT_VCHG_BAT	0xF8
+#define DA9052_CHG_CONT_TCTR		0x07
+
+/* INPUT CONTROL REGISTER */
+#define DA9052_INPUT_CONT_TCTR_MODE	0x80
+#define DA9052_INPUT_CONT_VBUS_SUSP	0x10
+#define DA9052_INPUT_CONT_DCIN_SUSP	0x08
+
+/* CHARGING TIME REGISTER */
+#define DA9052_CHGTIME_CHGTIME		0xFF
+
+/* BACKUP BATTERY CONTROL REGISTER */
+#define DA9052_BBATCONT_BCHARGERISET	0xF0
+#define DA9052_BBATCONT_BCHARGERVSET	0x0F
+
+/* LED REGISTERS */
+/* LED BOOST REGISTER */
+#define DA9052_BOOST_EBFAULT		0x80
+#define DA9052_BOOST_MBFAULT		0x40
+#define DA9052_BOOST_BOOSTFRQ		0x20
+#define DA9052_BOOST_BOOSTILIM		0x10
+#define DA9052_BOOST_LED3INEN		0x08
+#define DA9052_BOOST_LED2INEN		0x04
+#define DA9052_BOOST_LED1INEN		0x02
+#define DA9052_BOOST_BOOSTEN		0x01
+
+/* LED CONTROL REGISTER */
+#define DA9052_LEDCONT_SELLEDMODE	0x80
+#define DA9052_LEDCONT_LED3ICONT	0x40
+#define DA9052_LEDCONT_LED3RAMP	0x20
+#define DA9052_LEDCONT_LED3EN		0x10
+#define DA9052_LEDCONT_LED2RAMP	0x08
+#define DA9052_LEDCONT_LED2EN		0x04
+#define DA9052_LEDCONT_LED1RAMP	0x02
+#define DA9052_LEDCONT_LED1EN		0x01
+
+/* LEDMIN123  REGISTER */
+#define DA9052_LEDMIN123_LEDMINCURRENT	0xFF
+
+/* LED1CONF  REGISTER */
+#define DA9052_LED1CONF_LED1CURRENT	0xFF
+
+/* LED2CONF  REGISTER */
+#define DA9052_LED2CONF_LED2CURRENT	0xFF
+
+/* LED3CONF  REGISTER */
+#define DA9052_LED3CONF_LED3CURRENT	0xFF
+
+/* LED COUNT  REGISTER */
+#define DA9052_LED_CONT_DIM		0x80
+
+/* ADC MAN registers */
+#define DA9052_ADC_MAN_MAN_CONV	0x10
+#define DA9052_ADC_MAN_MUXSEL_VDDOUT	0x00
+#define DA9052_ADC_MAN_MUXSEL_ICH	0x01
+#define DA9052_ADC_MAN_MUXSEL_TBAT	0x02
+#define DA9052_ADC_MAN_MUXSEL_VBAT	0x03
+#define DA9052_ADC_MAN_MUXSEL_AD4	0x04
+#define DA9052_ADC_MAN_MUXSEL_AD5	0x05
+#define DA9052_ADC_MAN_MUXSEL_AD6	0x06
+#define DA9052_ADC_MAN_MUXSEL_VBBAT	0x09
+
+/* ADC CONTROL regsisters */
+#define DA9052_ADCCONT_COMP1V2EN	0x80
+#define DA9052_ADCCONT_ADCMODE		0x40
+#define DA9052_ADCCONT_TBATISRCEN	0x20
+#define DA9052_ADCCONT_AD4ISRCEN	0x10
+#define DA9052_ADCCONT_AUTOAD6EN	0x08
+#define DA9052_ADCCONT_AUTOAD5EN	0x04
+#define DA9052_ADCCONT_AUTOAD4EN	0x02
+#define DA9052_ADCCONT_AUTOVDDEN	0x01
+
+/* ADC 10 BIT MANUAL CONVERSION RESULT LOW register */
+#define DA9052_ADC_RES_LSB		0x03
+
+/* ADC 10 BIT MANUAL CONVERSION RESULT HIGH register */
+#define DA9052_ADCRESH_ADCRESMSB	0xFF
+
+/* VDD RES regsister*/
+#define DA9052_VDDRES_VDDOUTRES	0xFF
+
+/* VDD MON regsister*/
+#define DA9052_VDDMON_VDDOUTMON	0xFF
+
+/* ICHG_AV regsister*/
+#define DA9052_ICHGAV_ICHGAV		0xFF
+
+/* ICHG_THD regsister*/
+#define DA9052_ICHGTHD_ICHGTHD		0xFF
+
+/* ICHG_END regsister*/
+#define DA9052_ICHGEND_ICHGEND		0xFF
+
+/* TBAT_RES regsister*/
+#define DA9052_TBATRES_TBATRES		0xFF
+
+/* TBAT_HIGHP regsister*/
+#define DA9052_TBATHIGHP_TBATHIGHP	0xFF
+
+/* TBAT_HIGHN regsister*/
+#define DA9052_TBATHIGHN_TBATHIGHN	0xFF
+
+/* TBAT_LOW regsister*/
+#define DA9052_TBATLOW_TBATLOW		0xFF
+
+/* T_OFFSET regsister*/
+#define DA9052_TOFFSET_TOFFSET		0xFF
+
+/* ADCIN4_RES regsister*/
+#define DA9052_ADCIN4RES_ADCIN4RES	0xFF
+
+/* ADCIN4_HIGH regsister*/
+#define DA9052_AUTO4HIGH_AUTO4HIGH	0xFF
+
+/* ADCIN4_LOW regsister*/
+#define DA9052_AUTO4LOW_AUTO4LOW	0xFF
+
+/* ADCIN5_RES regsister*/
+#define DA9052_ADCIN5RES_ADCIN5RES	0xFF
+
+/* ADCIN5_HIGH regsister*/
+#define DA9052_AUTO5HIGH_AUTOHIGH	0xFF
+
+/* ADCIN5_LOW regsister*/
+#define DA9052_AUTO5LOW_AUTO5LOW	0xFF
+
+/* ADCIN6_RES regsister*/
+#define DA9052_ADCIN6RES_ADCIN6RES	0xFF
+
+/* ADCIN6_HIGH regsister*/
+#define DA9052_AUTO6HIGH_AUTO6HIGH	0xFF
+
+/* ADCIN6_LOW regsister*/
+#define DA9052_AUTO6LOW_AUTO6LOW	0xFF
+
+/* TJUNC_RES regsister*/
+#define DA9052_TJUNCRES_TJUNCRES	0xFF
+
+/* TSI REGISTER */
+
+/* TSI Control Register A */
+#define DA9052_TSICONTA_TSIDELAY	0xC0
+#define DA9052_TSICONTA_TSISKIP	0x38
+#define DA9052_TSICONTA_TSIMODE	0x04
+#define DA9052_TSICONTA_PENDETEN	0x02
+#define DA9052_TSICONTA_AUTOTSIEN	0x01
+
+/* TSI Control Register B */
+#define DA9052_TSICONTB_ADCREF		0x80
+#define DA9052_TSICONTB_TSIMAN		0x40
+#define DA9052_TSICONTB_TSIMUX		0x30
+#define DA9052_TSICONTB_TSISEL3	0x08
+#define DA9052_TSICONTB_TSISEL2	0x04
+#define DA9052_TSICONTB_TSISEL1	0x02
+#define DA9052_TSICONTB_TSISEL0	0x01
+
+/* TSI X Co-ordinate MSB Result register */
+#define DA9052_TSIXMSB_TSIXM		0xFF
+
+/* TSI Y Co-ordinate MSB Result register */
+#define DA9052_TSIYMSB_TSIYM		0xFF
+
+/* TSI Co-ordinate LSB Result register */
+#define DA9052_TSILSB_PENDOWN		0x40
+#define DA9052_TSILSB_TSIZL		0x30
+#define DA9052_TSILSB_TSIYL		0x0C
+#define DA9052_TSILSB_TSIXL		0x03
+
+/* TSI Z Measurement MSB Result register */
+#define DA9052_TSIZMSB_TSIZM		0xFF
+
+/* RTC REGISTER */
+
+/* RTC TIMER SECONDS REGISTER */
+#define DA9052_COUNTS_MONITOR		0x40
+#define DA9052_RTC_SEC			0x3F
+
+/* RTC TIMER MINUTES REGISTER */
+#define DA9052_RTC_MIN			0x3F
+
+/* RTC TIMER HOUR REGISTER */
+#define DA9052_RTC_HOUR		0x1F
+
+/* RTC TIMER DAYS REGISTER */
+#define DA9052_RTC_DAY			0x1F
+
+/* RTC TIMER MONTHS REGISTER */
+#define DA9052_RTC_MONTH		0x0F
+
+/* RTC TIMER YEARS REGISTER */
+#define DA9052_RTC_YEAR		0x3F
+
+/* RTC ALARM MINUTES REGISTER */
+#define DA9052_ALARMM_I_TICK_TYPE	0x80
+#define DA9052_ALARMMI_ALARMTYPE	0x40
+
+/* RTC ALARM YEARS REGISTER */
+#define DA9052_ALARM_Y_TICK_ON		0x80
+#define DA9052_ALARM_Y_ALARM_ON	0x40
+
+/* RTC SECONDS REGISTER  A*/
+#define DA9052_SECONDA_SECONDSA	0xFF
+
+/* RTC SECONDS REGISTER  B*/
+#define DA9052_SECONDB_SECONDSB	0xFF
+
+/* RTC SECONDS REGISTER  C*/
+#define DA9052_SECONDC_SECONDSC	0xFF
+
+/* RTC SECONDS REGISTER  D*/
+#define DA9052_SECONDD_SECONDSD	0xFF
+
+/* OTP REGISTER */
+
+/* CHIP IDENTIFICATION REGISTER */
+#define DA9052_CHIPID_MRC		0xF0
+#define DA9052_CHIPID_TRC		0x0F
+
+/* CONFIGURATION IDENTIFICATION REGISTER */
+#define DA9052_CONFIGID_CUSTOMERID	0xF8
+#define DA9052_CONFIGID_CONFID		0x07
+
+/* OTP CONTROL REGISTER */
+#define DA9052_OTPCONT_GPWRITEDIS	0x80
+#define DA9052_OTPCONT_OTPCONFLOCK	0x40
+#define DA9052_OTPCONT_OTPGPLOCK	0x20
+#define DA9052_OTPCONT_OTPCONFG	0x08
+#define DA9052_OTPCONT_OTPGP		0x04
+#define DA9052_OTPCONT_OTPRP		0x02
+#define DA9052_OTPCONT_OTPTRANSFER	0x01
+
+/* RTC OSCILLATOR TRIM REGISTER */
+#define DA9052_OSCTRIM_TRIM32K		0xFF
+
+/* GP ID REGISTER 0 */
+#define DA9052_GPID0_GP0		0xFF
+
+/* GP ID REGISTER 1 */
+#define DA9052_GPID1_GP1		0xFF
+
+/* GP ID REGISTER 2 */
+#define DA9052_GPID2_GP2		0xFF
+
+/* GP ID REGISTER 3 */
+#define DA9052_GPID3_GP3		0xFF
+
+/* GP ID REGISTER 4 */
+#define DA9052_GPID4_GP4		0xFF
+
+/* GP ID REGISTER 5 */
+#define DA9052_GPID5_GP5		0xFF
+
+/* GP ID REGISTER 6 */
+#define DA9052_GPID6_GP6		0xFF
+
+/* GP ID REGISTER 7 */
+#define DA9052_GPID7_GP7		0xFF
+
+/* GP ID REGISTER 8 */
+#define DA9052_GPID8_GP8		0xFF
+
+/* GP ID REGISTER 9 */
+#define DA9052_GPID9_GP9		0xFF
+
+#endif
+/* __LINUX_MFD_DA9052_REG_H */
-- 
1.7.1


