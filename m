Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2KUSVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:21:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab2KUSVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:21:07 -0500
Date: Wed, 21 Nov 2012 19:21:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: Magnus Damm <magnus.damm@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: add an AS3711 PMIC MFD driver
Message-ID: <Pine.LNX.4.64.1211211916160.842@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:vy/NEYfzd0ds6xBskh4mTFUPEqnA43k0JxhTfRnRdiO
 9oV7PUrdv9W6SHDd1txW+XYlhOMz/Siw449oQzuMZMhvOdPH0M
 2w1q8jCph1Q7XU4YPks6VQQoWpfSZOeGc9mOSwTbu23w6zxTLP
 oXotkUyz8ZAcxl601zWZcC/vvQciez1HP5XwOW4gBZCXnGwcdF
 4AuAtCnwXsLXvc5GFkGUJr13sX9+mqk2TBWjT86biuz/WCMONk
 ZtUqLqkyXNwWgBbQDUf6MgxzsWGHrQDuaN5os4GntlHjufnZKP
 UWTZCxIrKmrj+KYdCdTXxtwqkfMlD3V8ge/0F/twIev5jGsNu4
 Qx2s3K81pfvfx3r7/gK2atPCmyTxM318bnoDE4QKbiSimKVOwT
 4VL+ubSKX6Gjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AS3711 is a PMIC with multiple DCDC and LDO power supplies, GPIOs, an RTC,
a battery charger and a general purpose ADC. This patch adds support for
the MFD with support for a regulator driver and a backlight driver.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

An as3711 backlight driver is still under development, is expected soon.

 drivers/mfd/as3711.c       |  202 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/as3711.h |  126 +++++++++++++++++++++++++++
 2 files changed, 328 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/as3711.c
 create mode 100644 include/linux/mfd/as3711.h

diff --git a/drivers/mfd/as3711.c b/drivers/mfd/as3711.c
new file mode 100644
index 0000000..649020a
--- /dev/null
+++ b/drivers/mfd/as3711.c
@@ -0,0 +1,202 @@
+/*
+ * AS3711 PMIC MFC driver
+ *
+ * Copyright (C) 2012 Renesas Electronics Corporation
+ * Author: Guennadi Liakhovetski, <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the version 2 of the GNU General Public License as
+ * published by the Free Software Foundation
+ */
+
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mfd/as3711.h>
+#include <linux/mfd/core.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+enum {
+	AS3711_REGULATOR,
+	AS3711_BACKLIGHT,
+};
+
+static struct mfd_cell as3711_subdevs[] = {
+	[AS3711_REGULATOR] = {.name = "as3711-regulator",},
+	[AS3711_BACKLIGHT] = {.name = "as3711-backlight",},
+};
+
+static bool as3711_volatile_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case AS3711_GPIO_SIGNAL_IN:
+	case AS3711_INTERRUPT_STATUS_1:
+	case AS3711_INTERRUPT_STATUS_2:
+	case AS3711_INTERRUPT_STATUS_3:
+	case AS3711_CHARGER_STATUS_1:
+	case AS3711_CHARGER_STATUS_2:
+	case AS3711_REG_STATUS:
+		return true;
+	}
+	return false;
+}
+
+static bool as3711_precious_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case AS3711_INTERRUPT_STATUS_1:
+	case AS3711_INTERRUPT_STATUS_2:
+	case AS3711_INTERRUPT_STATUS_3:
+		return true;
+	}
+	return false;
+}
+
+static bool as3711_readable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case AS3711_SD_1_VOLTAGE:
+	case AS3711_SD_2_VOLTAGE:
+	case AS3711_SD_3_VOLTAGE:
+	case AS3711_SD_4_VOLTAGE:
+	case AS3711_LDO_1_VOLTAGE:
+	case AS3711_LDO_2_VOLTAGE:
+	case AS3711_LDO_3_VOLTAGE:
+	case AS3711_LDO_4_VOLTAGE:
+	case AS3711_LDO_5_VOLTAGE:
+	case AS3711_LDO_6_VOLTAGE:
+	case AS3711_LDO_7_VOLTAGE:
+	case AS3711_LDO_8_VOLTAGE:
+	case AS3711_SD_CONTROL:
+	case AS3711_GPIO_SIGNAL_OUT:
+	case AS3711_GPIO_SIGNAL_IN:
+	case AS3711_SD_CONTROL_1:
+	case AS3711_SD_CONTROL_2:
+	case AS3711_CURR_CONTROL:
+	case AS3711_CURR1_VALUE:
+	case AS3711_CURR2_VALUE:
+	case AS3711_CURR3_VALUE:
+	case AS3711_STEPUP_CONTROL_1:
+	case AS3711_STEPUP_CONTROL_2:
+	case AS3711_STEPUP_CONTROL_4:
+	case AS3711_STEPUP_CONTROL_5:
+	case AS3711_REG_STATUS:
+	case AS3711_INTERRUPT_STATUS_1:
+	case AS3711_INTERRUPT_STATUS_2:
+	case AS3711_INTERRUPT_STATUS_3:
+	case AS3711_CHARGER_STATUS_1:
+	case AS3711_CHARGER_STATUS_2:
+	case AS3711_ASIC_ID_1:
+	case AS3711_ASIC_ID_2:
+		return true;
+	}
+	return false;
+}
+
+static const struct regmap_config as3711_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.volatile_reg = as3711_volatile_reg,
+	.readable_reg = as3711_readable_reg,
+	.precious_reg = as3711_precious_reg,
+	.max_register = AS3711_MAX_REGS,
+	.num_reg_defaults_raw = AS3711_MAX_REGS,
+	.cache_type = REGCACHE_RBTREE,
+};
+
+static int as3711_i2c_probe(struct i2c_client *client,
+			    const struct i2c_device_id *id)
+{
+	struct as3711 *as3711;
+	struct as3711_platform_data *pdata = client->dev.platform_data;
+	unsigned int id1, id2;
+	int ret;
+
+	if (!pdata) {
+		dev_err(&client->dev, "Platform data not found\n");
+		return -ENODEV;
+	}
+
+	as3711 = devm_kzalloc(&client->dev, sizeof(struct as3711), GFP_KERNEL);
+	if (!as3711) {
+		dev_err(&client->dev, "Memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	as3711->dev = &client->dev;
+	i2c_set_clientdata(client, as3711);
+
+	if (client->irq)
+		dev_notice(&client->dev, "IRQ not supported yet\n");
+
+	as3711->regmap = devm_regmap_init_i2c(client, &as3711_regmap_config);
+	if (IS_ERR(as3711->regmap)) {
+		ret = PTR_ERR(as3711->regmap);
+		dev_err(&client->dev, "regmap initialization failed: %d\n", ret);
+		return ret;
+	}
+
+	regmap_read(as3711->regmap, AS3711_ASIC_ID_1, &id1);
+	regmap_read(as3711->regmap, AS3711_ASIC_ID_2, &id2);
+	dev_info(as3711->dev, "AS3711 detected: %x:%x\n", id1, id2);
+	if (id1 != 0x8b)
+		return -ENODEV;
+
+	as3711_subdevs[AS3711_REGULATOR].platform_data = &pdata->regulator;
+	as3711_subdevs[AS3711_REGULATOR].pdata_size = sizeof(pdata->regulator);
+	as3711_subdevs[AS3711_BACKLIGHT].platform_data = &pdata->backlight;
+	as3711_subdevs[AS3711_BACKLIGHT].pdata_size = sizeof(pdata->backlight);
+
+	ret = mfd_add_devices(as3711->dev, -1, as3711_subdevs,
+			      ARRAY_SIZE(as3711_subdevs), NULL, 0, NULL);
+	if (ret < 0)
+		dev_err(&client->dev, "add mfd devices failed: %d\n", ret);
+
+	return ret;
+}
+
+static int as3711_i2c_remove(struct i2c_client *client)
+{
+	struct as3711 *as3711 = i2c_get_clientdata(client);
+
+	mfd_remove_devices(as3711->dev);
+	return 0;
+}
+
+static const struct i2c_device_id as3711_i2c_id[] = {
+	{.name = "as3711", .driver_data = 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, as3711_i2c_id);
+
+static struct i2c_driver as3711_i2c_driver = {
+	.driver = {
+		   .name = "as3711",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = as3711_i2c_probe,
+	.remove = as3711_i2c_remove,
+	.id_table = as3711_i2c_id,
+};
+
+static int __init as3711_i2c_init(void)
+{
+	return i2c_add_driver(&as3711_i2c_driver);
+}
+/* Initialise early */
+subsys_initcall(as3711_i2c_init);
+
+static void __exit as3711_i2c_exit(void)
+{
+	i2c_del_driver(&as3711_i2c_driver);
+}
+module_exit(as3711_i2c_exit);
+
+MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
+MODULE_DESCRIPTION("AS3711 PMIC driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/as3711.h b/include/linux/mfd/as3711.h
new file mode 100644
index 0000000..38452ce
--- /dev/null
+++ b/include/linux/mfd/as3711.h
@@ -0,0 +1,126 @@
+/*
+ * AS3711 PMIC MFC driver header
+ *
+ * Copyright (C) 2012 Renesas Electronics Corporation
+ * Author: Guennadi Liakhovetski, <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the version 2 of the GNU General Public License as
+ * published by the Free Software Foundation
+ */
+
+#ifndef MFD_AS3711_H
+#define MFD_AS3711_H
+
+/*
+ * Client data
+ */
+
+/* Register addresses */
+#define AS3711_SD_1_VOLTAGE		0	/* Digital Step-Down */
+#define AS3711_SD_2_VOLTAGE		1
+#define AS3711_SD_3_VOLTAGE		2
+#define AS3711_SD_4_VOLTAGE		3
+#define AS3711_LDO_1_VOLTAGE		4	/* Analog LDO */
+#define AS3711_LDO_2_VOLTAGE		5
+#define AS3711_LDO_3_VOLTAGE		6	/* Digital LDO */
+#define AS3711_LDO_4_VOLTAGE		7
+#define AS3711_LDO_5_VOLTAGE		8
+#define AS3711_LDO_6_VOLTAGE		9
+#define AS3711_LDO_7_VOLTAGE		0xa
+#define AS3711_LDO_8_VOLTAGE		0xb
+#define AS3711_SD_CONTROL		0x10
+#define AS3711_GPIO_SIGNAL_OUT		0x20
+#define AS3711_GPIO_SIGNAL_IN		0x21
+#define AS3711_SD_CONTROL_1		0x30
+#define AS3711_SD_CONTROL_2		0x31
+#define AS3711_CURR_CONTROL		0x40
+#define AS3711_CURR1_VALUE		0x43
+#define AS3711_CURR2_VALUE		0x44
+#define AS3711_CURR3_VALUE		0x45
+#define AS3711_STEPUP_CONTROL_1		0x50
+#define AS3711_STEPUP_CONTROL_2		0x51
+#define AS3711_STEPUP_CONTROL_4		0x53
+#define AS3711_STEPUP_CONTROL_5		0x54
+#define AS3711_REG_STATUS		0x73
+#define AS3711_INTERRUPT_STATUS_1	0x77
+#define AS3711_INTERRUPT_STATUS_2	0x78
+#define AS3711_INTERRUPT_STATUS_3	0x79
+#define AS3711_CHARGER_STATUS_1		0x86
+#define AS3711_CHARGER_STATUS_2		0x87
+#define AS3711_ASIC_ID_1		0x90
+#define AS3711_ASIC_ID_2		0x91
+
+#define AS3711_MAX_REGS			0x92
+
+/* Regulators */
+enum {
+	AS3711_REGULATOR_SD_1,
+	AS3711_REGULATOR_SD_2,
+	AS3711_REGULATOR_SD_3,
+	AS3711_REGULATOR_SD_4,
+	AS3711_REGULATOR_LDO_1,
+	AS3711_REGULATOR_LDO_2,
+	AS3711_REGULATOR_LDO_3,
+	AS3711_REGULATOR_LDO_4,
+	AS3711_REGULATOR_LDO_5,
+	AS3711_REGULATOR_LDO_6,
+	AS3711_REGULATOR_LDO_7,
+	AS3711_REGULATOR_LDO_8,
+
+	AS3711_REGULATOR_MAX,
+};
+
+struct device;
+struct regmap;
+
+struct as3711 {
+	struct device *dev;
+	struct regmap *regmap;
+};
+
+#define AS3711_MAX_STEPDOWN 4
+#define AS3711_MAX_STEPUP 2
+#define AS3711_MAX_LDO 8
+
+enum as3711_su2_feedback {
+	AS3711_SU2_VOLTAGE,
+	AS3711_SU2_CURR1,
+	AS3711_SU2_CURR2,
+	AS3711_SU2_CURR3,
+	AS3711_SU2_CURR_AUTO,
+};
+
+enum as3711_su2_fbprot {
+	AS3711_SU2_LX_SD4,
+	AS3711_SU2_GPIO2,
+	AS3711_SU2_GPIO3,
+	AS3711_SU2_GPIO4,
+};
+
+/*
+ * Platform data
+ */
+
+struct as3711_regulator_pdata {
+	struct regulator_init_data *init_data[AS3711_REGULATOR_MAX];
+};
+
+struct as3711_bl_pdata {
+	const char *su1_fb;
+	int su1_max_uA;
+	const char *su2_fb;
+	int su2_max_uA;
+	enum as3711_su2_feedback su2_feedback;
+	enum as3711_su2_fbprot su2_fbprot;
+	bool su2_auto_curr1;
+	bool su2_auto_curr2;
+	bool su2_auto_curr3;
+};
+
+struct as3711_platform_data {
+	struct as3711_regulator_pdata regulator;
+	struct as3711_bl_pdata backlight;
+};
+
+#endif
-- 
1.7.2.5

