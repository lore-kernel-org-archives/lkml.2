Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2INNPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:15:24 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:38258
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab2INNPR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:15:17 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 5
X-BigFish: VPS5(zzc89bhc8kd6f1izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh1315hbe9i1155h)
Subject: [Patch v1 1/7] DA9055 MFD core driver
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 18:54:50 +0530
Message-ID: <1347629090.18587.9.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-Originating-IP: [10.10.38.47]
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the DA9055 MFD core driver that instantiate all the dependent
component
drivers and provides them the device access via I2C.

This patch is functionally tested on Samsung SMDK6410.

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/mfd/Kconfig              |   17 +
 drivers/mfd/Makefile             |    3 +
 drivers/mfd/da9055-core.c        |  423 +++++++++++++++++++++++
 drivers/mfd/da9055-i2c.c         |   93 +++++
 include/linux/mfd/da9055/core.h  |   94 +++++
 include/linux/mfd/da9055/pdata.h |   32 ++
 include/linux/mfd/da9055/reg.h   |  699 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 1361 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/da9055-core.c
 create mode 100644 drivers/mfd/da9055-i2c.c
 create mode 100644 include/linux/mfd/da9055/core.h
 create mode 100644 include/linux/mfd/da9055/pdata.h
 create mode 100644 include/linux/mfd/da9055/reg.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b1a1462..34a539f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -441,6 +441,23 @@ config MFD_DA9052_I2C
 	  for accessing the device, additional drivers must be enabled in
 	  order to use the functionality of the device.
 
+config MFD_DA9055
+	bool "Dialog Semiconductor DA9055 PMIC Support"
+	select REGMAP_I2C
+	select REGMAP_IRQ
+	select PMIC_DA9055
+	select MFD_CORE
+	depends on I2C=y
+	help
+	  Say yes here for support of Dialog Semiconductor DA9055. This is
+	  a Power Management IC. This driver provides common support for
+	  accessing the device as well as the I2C interface to the chip itself.
+	  Additional drivers must be enabled in order to use the functionality
+	  of the device.
+
+	  This driver can be built as a module. If built as a module it will be
+	  called "da9055"
+
 config PMIC_ADP5520
 	bool "Analog Devices ADP5520/01 MFD PMIC Core Support"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 79dd22d..339cbb4 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -90,6 +90,9 @@ obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
 obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
 obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
 
+da9055-objs			:= da9055-core.o da9055-i2c.o
+obj-$(CONFIG_MFD_DA9055)	+= da9055.o
+
 obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
 obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
new file mode 100644
index 0000000..6297bc0
--- /dev/null
+++ b/drivers/mfd/da9055-core.c
@@ -0,0 +1,423 @@
+/*
+ * Device access for Dialog DA9055 PMICs.
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: David Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/irq.h>
+#include <linux/mutex.h>
+
+#include <linux/mfd/core.h>
+#include <linux/mfd/da9055/core.h>
+#include <linux/mfd/da9055/pdata.h>
+#include <linux/mfd/da9055/reg.h>
+
+#define DA9055_IRQ_NONKEY_MASK		0x01
+#define DA9055_IRQ_ALM_MASK		0x02
+#define DA9055_IRQ_TICK_MASK		0x04
+#define DA9055_IRQ_ADC_MASK		0x08
+#define DA9055_IRQ_BUCK_ILIM_MASK	0x08
+
+static bool da9055_register_readable(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case DA9055_REG_STATUS_A:
+	case DA9055_REG_STATUS_B:
+	case DA9055_REG_EVENT_A:
+	case DA9055_REG_EVENT_B:
+	case DA9055_REG_EVENT_C:
+	case DA9055_REG_IRQ_MASK_A:
+	case DA9055_REG_IRQ_MASK_B:
+	case DA9055_REG_IRQ_MASK_C:
+
+	case DA9055_REG_CONTROL_A:
+	case DA9055_REG_CONTROL_B:
+	case DA9055_REG_CONTROL_C:
+	case DA9055_REG_CONTROL_D:
+	case DA9055_REG_CONTROL_E:
+
+	case DA9055_REG_ADC_MAN:
+	case DA9055_REG_ADC_CONT:
+	case DA9055_REG_VSYS_MON:
+	case DA9055_REG_ADC_RES_L:
+	case DA9055_REG_ADC_RES_H:
+	case DA9055_REG_VSYS_RES:
+	case DA9055_REG_ADCIN1_RES:
+	case DA9055_REG_ADCIN2_RES:
+	case DA9055_REG_ADCIN3_RES:
+
+	case DA9055_REG_COUNT_S:
+	case DA9055_REG_COUNT_MI:
+	case DA9055_REG_COUNT_H:
+	case DA9055_REG_COUNT_D:
+	case DA9055_REG_COUNT_MO:
+	case DA9055_REG_COUNT_Y:
+	case DA9055_REG_ALARM_H:
+	case DA9055_REG_ALARM_D:
+	case DA9055_REG_ALARM_MI:
+	case DA9055_REG_ALARM_MO:
+	case DA9055_REG_ALARM_Y:
+
+	case DA9055_REG_GPIO0_1:
+	case DA9055_REG_GPIO2:
+	case DA9055_REG_GPIO_MODE0_2:
+
+	case DA9055_REG_BCORE_CONT:
+	case DA9055_REG_BMEM_CONT:
+	case DA9055_REG_LDO1_CONT:
+	case DA9055_REG_LDO2_CONT:
+	case DA9055_REG_LDO3_CONT:
+	case DA9055_REG_LDO4_CONT:
+	case DA9055_REG_LDO5_CONT:
+	case DA9055_REG_LDO6_CONT:
+	case DA9055_REG_BUCK_LIM:
+	case DA9055_REG_BCORE_MODE:
+	case DA9055_REG_VBCORE_A:
+	case DA9055_REG_VBMEM_A:
+	case DA9055_REG_VLDO1_A:
+	case DA9055_REG_VLDO2_A:
+	case DA9055_REG_VLDO3_A:
+	case DA9055_REG_VLDO4_A:
+	case DA9055_REG_VLDO5_A:
+	case DA9055_REG_VLDO6_A:
+	case DA9055_REG_VBCORE_B:
+	case DA9055_REG_VBMEM_B:
+	case DA9055_REG_VLDO1_B:
+	case DA9055_REG_VLDO2_B:
+	case DA9055_REG_VLDO3_B:
+	case DA9055_REG_VLDO4_B:
+	case DA9055_REG_VLDO5_B:
+	case DA9055_REG_VLDO6_B:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool da9055_register_writeable(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case DA9055_REG_STATUS_A:
+	case DA9055_REG_STATUS_B:
+	case DA9055_REG_EVENT_A:
+	case DA9055_REG_EVENT_B:
+	case DA9055_REG_EVENT_C:
+	case DA9055_REG_IRQ_MASK_A:
+	case DA9055_REG_IRQ_MASK_B:
+	case DA9055_REG_IRQ_MASK_C:
+
+	case DA9055_REG_CONTROL_A:
+	case DA9055_REG_CONTROL_B:
+	case DA9055_REG_CONTROL_C:
+	case DA9055_REG_CONTROL_D:
+	case DA9055_REG_CONTROL_E:
+
+	case DA9055_REG_ADC_MAN:
+	case DA9055_REG_ADC_CONT:
+	case DA9055_REG_VSYS_MON:
+	case DA9055_REG_ADC_RES_L:
+	case DA9055_REG_ADC_RES_H:
+	case DA9055_REG_VSYS_RES:
+	case DA9055_REG_ADCIN1_RES:
+	case DA9055_REG_ADCIN2_RES:
+	case DA9055_REG_ADCIN3_RES:
+
+	case DA9055_REG_COUNT_S:
+	case DA9055_REG_COUNT_MI:
+	case DA9055_REG_COUNT_H:
+	case DA9055_REG_COUNT_D:
+	case DA9055_REG_COUNT_MO:
+	case DA9055_REG_COUNT_Y:
+	case DA9055_REG_ALARM_H:
+	case DA9055_REG_ALARM_D:
+	case DA9055_REG_ALARM_MI:
+	case DA9055_REG_ALARM_MO:
+	case DA9055_REG_ALARM_Y:
+
+	case DA9055_REG_GPIO0_1:
+	case DA9055_REG_GPIO2:
+	case DA9055_REG_GPIO_MODE0_2:
+
+	case DA9055_REG_BCORE_CONT:
+	case DA9055_REG_BMEM_CONT:
+	case DA9055_REG_LDO1_CONT:
+	case DA9055_REG_LDO2_CONT:
+	case DA9055_REG_LDO3_CONT:
+	case DA9055_REG_LDO4_CONT:
+	case DA9055_REG_LDO5_CONT:
+	case DA9055_REG_LDO6_CONT:
+	case DA9055_REG_BUCK_LIM:
+	case DA9055_REG_BCORE_MODE:
+	case DA9055_REG_VBCORE_A:
+	case DA9055_REG_VBMEM_A:
+	case DA9055_REG_VLDO1_A:
+	case DA9055_REG_VLDO2_A:
+	case DA9055_REG_VLDO3_A:
+	case DA9055_REG_VLDO4_A:
+	case DA9055_REG_VLDO5_A:
+	case DA9055_REG_VLDO6_A:
+	case DA9055_REG_VBCORE_B:
+	case DA9055_REG_VBMEM_B:
+	case DA9055_REG_VLDO1_B:
+	case DA9055_REG_VLDO2_B:
+	case DA9055_REG_VLDO3_B:
+	case DA9055_REG_VLDO4_B:
+	case DA9055_REG_VLDO5_B:
+	case DA9055_REG_VLDO6_B:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool da9055_register_volatile(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case DA9055_REG_STATUS_A:
+	case DA9055_REG_STATUS_B:
+	case DA9055_REG_EVENT_A:
+	case DA9055_REG_EVENT_B:
+	case DA9055_REG_EVENT_C:
+
+	case DA9055_REG_CONTROL_A:
+	case DA9055_REG_CONTROL_E:
+
+	case DA9055_REG_ADC_MAN:
+	case DA9055_REG_ADC_RES_L:
+	case DA9055_REG_ADC_RES_H:
+	case DA9055_REG_VSYS_RES:
+	case DA9055_REG_ADCIN1_RES:
+	case DA9055_REG_ADCIN2_RES:
+	case DA9055_REG_ADCIN3_RES:
+
+	case DA9055_REG_COUNT_S:
+	case DA9055_REG_COUNT_MI:
+	case DA9055_REG_COUNT_H:
+	case DA9055_REG_COUNT_D:
+	case DA9055_REG_COUNT_MO:
+	case DA9055_REG_COUNT_Y:
+	case DA9055_REG_ALARM_MI:
+
+	case DA9055_REG_BCORE_CONT:
+	case DA9055_REG_BMEM_CONT:
+	case DA9055_REG_LDO1_CONT:
+	case DA9055_REG_LDO2_CONT:
+	case DA9055_REG_LDO3_CONT:
+	case DA9055_REG_LDO4_CONT:
+	case DA9055_REG_LDO5_CONT:
+	case DA9055_REG_LDO6_CONT:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static struct regmap_irq da9055_irqs[] = {
+	[DA9055_IRQ_NONKEY] = {
+		.reg_offset = 0,
+		.mask = DA9055_IRQ_NONKEY_MASK,
+	},
+	[DA9055_IRQ_ALARM] = {
+		.reg_offset = 0,
+		.mask = DA9055_IRQ_ALM_MASK,
+	},
+	[DA9055_IRQ_TICK] = {
+		.reg_offset = 0,
+		.mask = DA9055_IRQ_TICK_MASK,
+	},
+	[DA9055_IRQ_HWMON] = {
+		.reg_offset = 0,
+		.mask = DA9055_IRQ_ADC_MASK,
+	},
+	[DA9055_IRQ_REGULATOR] = {
+		.reg_offset = 1,
+		.mask = DA9055_IRQ_BUCK_ILIM_MASK,
+	},
+};
+
+struct regmap_config da9055_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.cache_type = REGCACHE_RBTREE,
+
+	.max_register = DA9055_MAX_REGISTER_CNT,
+	.readable_reg = da9055_register_readable,
+	.writeable_reg = da9055_register_writeable,
+	.volatile_reg = da9055_register_volatile,
+};
+EXPORT_SYMBOL_GPL(da9055_regmap_config);
+
+static struct resource da9055_onkey_resource = {
+	.name = "ONKEY",
+	.start = DA9055_IRQ_NONKEY,
+	.end   = DA9055_IRQ_NONKEY,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct resource da9055_rtc_resource[] = {
+	{
+		.name = "ALM",
+		.start = DA9055_IRQ_ALARM,
+		.end   = DA9055_IRQ_ALARM,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "TICK",
+		.start = DA9055_IRQ_TICK,
+		.end   = DA9055_IRQ_TICK,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource da9055_hwmon_resource = {
+	.name = "HWMON",
+	.start = DA9055_IRQ_HWMON,
+	.end   = DA9055_IRQ_HWMON,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct resource da9055_ld05_6_resource = {
+	.name = "REGULATOR",
+	.start = DA9055_IRQ_REGULATOR,
+	.end   = DA9055_IRQ_REGULATOR,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct mfd_cell da9055_devs[] = {
+	{
+		.of_compatible = "dialog,da9055-gpio",
+		.name = "da9055-gpio",
+	},
+	{
+		.of_compatible = "dialog,da9055-regulator",
+		.name = "da9055-regulator",
+		.id = 1,
+	},
+	{
+		.of_compatible = "dialog,da9055-regulator",
+		.name = "da9055-regulator",
+		.id = 2,
+	},
+	{
+		.of_compatible = "dialog,da9055-regulator",
+		.name = "da9055-regulator",
+		.id = 3,
+	},
+	{
+		.of_compatible = "dialog,da9055-regulator",
+		.name = "da9055-regulator",
+		.id = 4,
+	},
+	{
+		.of_compatible = "dialog,da9055-regulator",
+		.name = "da9055-regulator",
+		.id = 5,
+	},
+	{
+		.of_compatible = "dialog,da9055-regulator",
+		.name = "da9055-regulator",
+		.id = 6,
+	},
+	{
+		.of_compatible = "dialog,da9055-regulator",
+		.name = "da9055-regulator",
+		.id = 7,
+		.resources = &da9055_ld05_6_resource,
+		.num_resources = 1,
+	},
+	{
+		.of_compatible = "dialog,da9055-regulator",
+		.name = "da9055-regulator",
+		.resources = &da9055_ld05_6_resource,
+		.num_resources = 1,
+		.id = 8,
+	},
+	{
+		.of_compatible = "dialog,da9055-onkey",
+		.name = "da9055-onkey",
+		.resources = &da9055_onkey_resource,
+		.num_resources = 1,
+	},
+	{
+		.of_compatible = "dialog,da9055-rtc",
+		.name = "da9055-rtc",
+		.resources = da9055_rtc_resource,
+		.num_resources = ARRAY_SIZE(da9055_rtc_resource),
+	},
+	{
+		.of_compatible = "dialog,da9055-hwmon",
+		.name = "da9055-hwmon",
+		.resources = &da9055_hwmon_resource,
+		.num_resources = 1,
+	},
+	{
+		.of_compatible = "dialog,da9055-watchdog",
+		.name = "da9055-watchdog",
+	},
+};
+
+static struct regmap_irq_chip da9055_regmap_irq_chip = {
+	.name = "da9055_irq",
+	.status_base = DA9055_REG_EVENT_A,
+	.mask_base = DA9055_REG_IRQ_MASK_A,
+	.ack_base = DA9055_REG_EVENT_A,
+	.num_regs = 3,
+	.irqs = da9055_irqs,
+	.num_irqs = ARRAY_SIZE(da9055_irqs),
+};
+
+int __devinit da9055_device_init(struct da9055 *da9055)
+{
+	struct da9055_pdata *pdata = da9055->dev->platform_data;
+	int ret;
+
+	if (pdata && pdata->init != NULL)
+		pdata->init(da9055);
+
+	if (!pdata || !pdata->irq_base)
+		da9055->irq_base = -1;
+	else
+		da9055->irq_base = pdata->irq_base;
+
+	ret = regmap_add_irq_chip(da9055->regmap, da9055->chip_irq,
+				  IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				  da9055->irq_base, &da9055_regmap_irq_chip,
+				  &da9055->irq_data);
+	if (ret < 0)
+		return ret;
+
+	da9055->irq_base = regmap_irq_chip_get_base(da9055->irq_data);
+
+	ret = mfd_add_devices(da9055->dev, -1,
+				da9055_devs, ARRAY_SIZE(da9055_devs),
+				NULL, da9055->irq_base);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	mfd_remove_devices(da9055->dev);
+	return ret;
+}
+
+void __devexit da9055_device_exit(struct da9055 *da9055)
+{
+	regmap_del_irq_chip(da9055->chip_irq, da9055->irq_data);
+	mfd_remove_devices(da9055->dev);
+}
+
+MODULE_DESCRIPTION("Core support for the DA9055 PMIC");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
diff --git a/drivers/mfd/da9055-i2c.c b/drivers/mfd/da9055-i2c.c
new file mode 100644
index 0000000..88f6dca
--- /dev/null
+++ b/drivers/mfd/da9055-i2c.c
@@ -0,0 +1,93 @@
+ /* I2C access for DA9055 PMICs.
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
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
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+
+#include <linux/mfd/da9055/core.h>
+
+static int __devinit da9055_i2c_probe(struct i2c_client *i2c,
+				      const struct i2c_device_id *id)
+{
+	struct da9055 *da9055;
+	int ret;
+
+	da9055 = devm_kzalloc(&i2c->dev, sizeof(struct da9055), GFP_KERNEL);
+	if (!da9055)
+		return -ENOMEM;
+
+	da9055->regmap = devm_regmap_init_i2c(i2c, &da9055_regmap_config);
+	if (IS_ERR(da9055->regmap)) {
+		ret = PTR_ERR(da9055->regmap);
+		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	da9055->dev = &i2c->dev;
+	da9055->chip_irq = i2c->irq;
+
+	i2c_set_clientdata(i2c, da9055);
+
+	return da9055_device_init(da9055);
+}
+
+static int __devexit da9055_i2c_remove(struct i2c_client *i2c)
+{
+	struct da9055 *da9055 = i2c_get_clientdata(i2c);
+
+	da9055_device_exit(da9055);
+
+	return 0;
+}
+
+static struct i2c_device_id da9055_i2c_id[] = {
+	{"da9055-pmic", 0},
+	{ }
+};
+
+static struct i2c_driver da9055_i2c_driver = {
+	.probe = da9055_i2c_probe,
+	.remove = __devexit_p(da9055_i2c_remove),
+	.id_table = da9055_i2c_id,
+	.driver = {
+		.name = "da9055",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init da9055_i2c_init(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&da9055_i2c_driver);
+	if (ret != 0) {
+		pr_err("DA9055 I2C registration failed %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+subsys_initcall(da9055_i2c_init);
+
+static void __exit da9055_i2c_exit(void)
+{
+	i2c_del_driver(&da9055_i2c_driver);
+}
+module_exit(da9055_i2c_exit);
+
+MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
+MODULE_DESCRIPTION("I2C driver for Dialog DA9055 PMIC");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/da9055/core.h b/include/linux/mfd/da9055/core.h
new file mode 100644
index 0000000..c96ad68
--- /dev/null
+++ b/include/linux/mfd/da9055/core.h
@@ -0,0 +1,94 @@
+﻿/*
+ * da9055 declarations for DA9055 PMICs.
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __DA9055_CORE_H
+#define __DA9055_CORE_H
+
+#include <linux/interrupt.h>
+#include <linux/regmap.h>
+
+/*
+ * PMIC IRQ
+ */
+#define DA9055_IRQ_ALARM	0x01
+#define DA9055_IRQ_TICK		0x02
+#define DA9055_IRQ_NONKEY	0x00
+#define DA9055_IRQ_REGULATOR	0x0B
+#define DA9055_IRQ_HWMON	0x03
+
+struct da9055_pdata;
+
+struct da9055 {
+	struct regmap *regmap;
+	struct regmap_irq_chip_data *irq_data;
+	struct device *dev;
+	struct i2c_client *i2c_client;
+
+	int irq_base;
+	int chip_irq;
+};
+
+/* Device I/O */
+static inline int da9055_reg_read(struct da9055 *da9055, unsigned char reg)
+{
+	int val, ret;
+
+	ret = regmap_read(da9055->regmap, reg, &val);
+	if (ret < 0)
+		return ret;
+
+	return val;
+}
+
+static inline int da9055_reg_write(struct da9055 *da9055, unsigned char reg,
+				    unsigned char val)
+{
+	return regmap_write(da9055->regmap, reg, val);
+}
+
+static inline int da9055_group_read(struct da9055 *da9055, unsigned char reg,
+				     unsigned reg_cnt, unsigned char *val)
+{
+	return regmap_bulk_read(da9055->regmap, reg, val, reg_cnt);
+}
+
+static inline int da9055_group_write(struct da9055 *da9055, unsigned char reg,
+				      unsigned reg_cnt, unsigned char *val)
+{
+	return regmap_raw_write(da9055->regmap, reg, val, reg_cnt);
+}
+
+static inline int da9055_reg_update(struct da9055 *da9055, unsigned char reg,
+				     unsigned char bit_mask,
+				     unsigned char reg_val)
+{
+	return regmap_update_bits(da9055->regmap, reg, bit_mask, reg_val);
+}
+
+/* Generic Device API */
+int da9055_device_init(struct da9055 *da9055);
+void da9055_device_exit(struct da9055 *da9055);
+
+extern struct regmap_config da9055_regmap_config;
+
+#endif /* __DA9055_CORE_H */
diff --git a/include/linux/mfd/da9055/pdata.h b/include/linux/mfd/da9055/pdata.h
new file mode 100644
index 0000000..147293b
--- /dev/null
+++ b/include/linux/mfd/da9055/pdata.h
@@ -0,0 +1,32 @@
+﻿/* Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+#ifndef __DA9055_PDATA_H
+#define __DA9055_PDATA_H
+
+#define DA9055_MAX_REGULATORS	8
+
+struct da9055;
+
+enum gpio_select {
+	NO_GPIO = 0,
+	GPIO_1,
+	GPIO_2
+};
+
+struct da9055_pdata {
+	int (*init) (struct da9055 *da9055);
+	int irq_base;
+	int gpio_base;
+
+	struct regulator_init_data *regulators[DA9055_MAX_REGULATORS];
+	bool reset_enable;		/* Enable RTC in RESET Mode */
+	enum gpio_select *gpio_rsel;	/* Select regulator set thru GPIO 1/2 */
+	enum gpio_select *gpio_ren;	/* Enable regulator thru GPIO 1/2 */
+};
+#endif /* __DA9055_PDATA_H */
diff --git a/include/linux/mfd/da9055/reg.h b/include/linux/mfd/da9055/reg.h
new file mode 100644
index 0000000..df237ee
--- /dev/null
+++ b/include/linux/mfd/da9055/reg.h
@@ -0,0 +1,699 @@
+﻿/*
+ * DA9055 declarations for DA9055 PMICs.
+ *
+ * Copyright(c) 2012 Dialog Semiconductor Ltd.
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __DA9055_REG_H
+#define __DA9055_REG_H
+
+/*
+ * PMIC registers
+ */
+ /* PAGE0 */
+#define	DA9055_REG_PAGE_CON		0x00
+
+/* System Control and Event Registers */
+#define	DA9055_REG_STATUS_A		0x01
+#define	DA9055_REG_STATUS_B		0x02
+#define	DA9055_REG_FAULT_LOG		0x03
+#define	DA9055_REG_EVENT_A		0x04
+#define	DA9055_REG_EVENT_B		0x05
+#define	DA9055_REG_EVENT_C		0x06
+#define	DA9055_REG_IRQ_MASK_A		0x07
+#define	DA9055_REG_IRQ_MASK_B		0x08
+#define	DA9055_REG_IRQ_MASK_C		0x09
+#define	DA9055_REG_CONTROL_A		0x0A
+#define	DA9055_REG_CONTROL_B		0x0B
+#define	DA9055_REG_CONTROL_C		0x0C
+#define	DA9055_REG_CONTROL_D		0x0D
+#define	DA9055_REG_CONTROL_E		0x0E
+#define	DA9055_REG_PD_DIS		0x0F
+
+/* GPIO Control Registers */
+#define	DA9055_REG_GPIO0_1		0x10
+#define	DA9055_REG_GPIO2		0x11
+#define	DA9055_REG_GPIO_MODE0_2		0x12
+
+/* Regulator Control Registers */
+#define	DA9055_REG_BCORE_CONT		0x13
+#define	DA9055_REG_BMEM_CONT		0x14
+#define	DA9055_REG_LDO1_CONT		0x15
+#define	DA9055_REG_LDO2_CONT		0x16
+#define	DA9055_REG_LDO3_CONT		0x17
+#define	DA9055_REG_LDO4_CONT		0x18
+#define	DA9055_REG_LDO5_CONT		0x19
+#define	DA9055_REG_LDO6_CONT		0x1A
+
+/* GP-ADC Control Registers */
+#define	DA9055_REG_ADC_MAN		0x1B
+#define	DA9055_REG_ADC_CONT		0x1C
+#define	DA9055_REG_VSYS_MON		0x1D
+#define	DA9055_REG_ADC_RES_L		0x1E
+#define	DA9055_REG_ADC_RES_H		0x1F
+#define	DA9055_REG_VSYS_RES		0x20
+#define	DA9055_REG_ADCIN1_RES		0x21
+#define	DA9055_REG_ADCIN2_RES		0x22
+#define	DA9055_REG_ADCIN3_RES		0x23
+
+/* Sequencer Control Registers */
+#define	DA9055_REG_EN_32K		0x35
+
+/* Regulator Setting Registers */
+#define	DA9055_REG_BUCK_LIM		0x37
+#define	DA9055_REG_BCORE_MODE		0x38
+#define	DA9055_REG_VBCORE_A		0x39
+#define	DA9055_REG_VBMEM_A		0x3A
+#define	DA9055_REG_VLDO1_A		0x3B
+#define	DA9055_REG_VLDO2_A		0x3C
+#define	DA9055_REG_VLDO3_A		0x3D
+#define	DA9055_REG_VLDO4_A		0x3E
+#define	DA9055_REG_VLDO5_A		0x3F
+#define	DA9055_REG_VLDO6_A		0x40
+#define	DA9055_REG_VBCORE_B		0x41
+#define	DA9055_REG_VBMEM_B		0x42
+#define	DA9055_REG_VLDO1_B		0x43
+#define	DA9055_REG_VLDO2_B		0x44
+#define	DA9055_REG_VLDO3_B		0x45
+#define	DA9055_REG_VLDO4_B		0x46
+#define	DA9055_REG_VLDO5_B		0x47
+#define	DA9055_REG_VLDO6_B		0x48
+
+/* GP-ADC Threshold Registers */
+#define	DA9055_REG_AUTO1_HIGH		0x49
+#define	DA9055_REG_AUTO1_LOW		0x4A
+#define	DA9055_REG_AUTO2_HIGH		0x4B
+#define	DA9055_REG_AUTO2_LOW		0x4C
+#define	DA9055_REG_AUTO3_HIGH		0x4D
+#define	DA9055_REG_AUTO3_LOW		0x4E
+
+/* OTP */
+#define	DA9055_REG_OPT_COUNT		0x50
+#define	DA9055_REG_OPT_ADDR		0x51
+#define	DA9055_REG_OPT_DATA		0x52
+
+/* RTC Calendar and Alarm Registers */
+#define	DA9055_REG_COUNT_S		0x53
+#define	DA9055_REG_COUNT_MI		0x54
+#define	DA9055_REG_COUNT_H		0x55
+#define	DA9055_REG_COUNT_D		0x56
+#define	DA9055_REG_COUNT_MO		0x57
+#define	DA9055_REG_COUNT_Y		0x58
+#define	DA9055_REG_ALARM_MI		0x59
+#define	DA9055_REG_ALARM_H		0x5A
+#define	DA9055_REG_ALARM_D		0x5B
+#define	DA9055_REG_ALARM_MO		0x5C
+#define	DA9055_REG_ALARM_Y		0x5D
+#define	DA9055_REG_SECOND_A		0x5E
+#define	DA9055_REG_SECOND_B		0x5F
+#define	DA9055_REG_SECOND_C		0x60
+#define	DA9055_REG_SECOND_D		0x61
+
+/* Customer Trim and Configuration */
+#define	DA9055_REG_T_OFFSET		0x63
+#define	DA9055_REG_INTERFACE		0x64
+#define	DA9055_REG_CONFIG_A		0x65
+#define	DA9055_REG_CONFIG_B		0x66
+#define	DA9055_REG_CONFIG_C		0x67
+#define	DA9055_REG_CONFIG_D		0x68
+#define	DA9055_REG_CONFIG_E		0x69
+#define	DA9055_REG_TRIM_CLDR		0x6F
+
+/* General Purpose Registers */
+#define	DA9055_REG_GP_ID_0		0x70
+#define	DA9055_REG_GP_ID_1		0x71
+#define	DA9055_REG_GP_ID_2		0x72
+#define	DA9055_REG_GP_ID_3		0x73
+#define	DA9055_REG_GP_ID_4		0x74
+#define	DA9055_REG_GP_ID_5		0x75
+#define	DA9055_REG_GP_ID_6		0x76
+#define	DA9055_REG_GP_ID_7		0x77
+#define	DA9055_REG_GP_ID_8		0x78
+#define	DA9055_REG_GP_ID_9		0x79
+#define	DA9055_REG_GP_ID_10		0x7A
+#define	DA9055_REG_GP_ID_11		0x7B
+#define	DA9055_REG_GP_ID_12		0x7C
+#define	DA9055_REG_GP_ID_13		0x7D
+#define	DA9055_REG_GP_ID_14		0x7E
+#define	DA9055_REG_GP_ID_15		0x7F
+#define	DA9055_REG_GP_ID_16		0x80
+#define	DA9055_REG_GP_ID_17		0x81
+#define	DA9055_REG_GP_ID_18		0x82
+#define	DA9055_REG_GP_ID_19		0x83
+
+#define DA9055_MAX_REGISTER_CNT		DA9055_REG_GP_ID_19
+
+/*
+ * PMIC registers bits
+ */
+
+/* DA9055_REG_PAGE_CON (addr=0x00) */
+#define	DA9055_PAGE_WRITE_MODE		(0<<6)
+#define	DA9055_REPEAT_WRITE_MODE	(1<<6)
+
+/* DA9055_REG_STATUS_A (addr=0x01) */
+#define	DA9055_NOKEY_STS		0x01
+#define	DA9055_WAKE_STS			0x02
+#define	DA9055_DVC_BUSY_STS		0x04
+#define	DA9055_COMP1V2_STS		0x08
+#define	DA9055_NJIG_STS			0x10
+#define	DA9055_LDO5_LIM_STS		0x20
+#define	DA9055_LDO6_LIM_STS		0x40
+
+/* DA9055_REG_STATUS_B (addr=0x02) */
+#define	DA9055_GPI0_STS			0x01
+#define	DA9055_GPI1_STS			0x02
+#define	DA9055_GPI2_STS			0x04
+
+/* DA9055_REG_FAULT_LOG (addr=0x03) */
+#define	DA9055_TWD_ERROR_FLG		0x01
+#define	DA9055_POR_FLG			0x02
+#define	DA9055_VDD_FAULT_FLG		0x04
+#define	DA9055_VDD_START_FLG		0x08
+#define	DA9055_TEMP_CRIT_FLG		0x10
+#define	DA9055_KEY_RESET_FLG		0x20
+#define	DA9055_WAIT_SHUT_FLG		0x80
+
+/* DA9055_REG_EVENT_A (addr=0x04) */
+#define	DA9055_NOKEY_EINT		0x01
+#define	DA9055_ALARM_EINT		0x02
+#define	DA9055_TICK_EINT		0x04
+#define	DA9055_ADC_RDY_EINT		0x08
+#define	DA9055_SEQ_RDY_EINT		0x10
+#define	DA9055_EVENTS_B_EINT		0x20
+#define	DA9055_EVENTS_C_EINT		0x40
+
+/* DA9055_REG_EVENT_B (addr=0x05) */
+#define	DA9055_E_WAKE_EINT		0x01
+#define	DA9055_E_TEMP_EINT		0x02
+#define	DA9055_E_COMP1V2_EINT		0x04
+#define	DA9055_E_LDO_LIM_EINT		0x08
+#define	DA9055_E_NJIG_EINT		0x20
+#define	DA9055_E_VDD_MON_EINT		0x40
+#define	DA9055_E_VDD_WARN_EINT		0x80
+
+/* DA9055_REG_EVENT_C (addr=0x06) */
+#define	DA9055_E_GPI0_EINT		0x01
+#define	DA9055_E_GPI1_EINT		0x02
+#define	DA9055_E_GPI2_EINT		0x04
+
+/* DA9055_REG_IRQ_MASK_A (addr=0x07) */
+#define	DA9055_M_NONKEY_EINT		0x01
+#define	DA9055_M_ALARM_EINT		0x02
+#define	DA9055_M_TICK_EINT		0x04
+#define	DA9055_M_ADC_RDY_EINT		0x08
+#define	DA9055_M_SEQ_RDY_EINT		0x10
+
+/* DA9055_REG_IRQ_MASK_B (addr=0x08) */
+#define	DA9055_M_WAKE_EINT		0x01
+#define	DA9055_M_TEMP_EINT		0x02
+#define	DA9055_M_COMP_1V2_EINT		0x04
+#define	DA9055_M_LDO_LIM_EINT		0x08
+#define	DA9055_M_NJIG_EINT		0x20
+#define	DA9055_M_VDD_MON_EINT		0x40
+#define	DA9055_M_VDD_WARN_EINT		0x80
+
+/* DA9055_REG_IRQ_MASK_C (addr=0x09) */
+#define	DA9055_M_GPI0_EINT		0x01
+#define	DA9055_M_GPI1_EINT		0x02
+#define	DA9055_M_GPI2_EINT		0x04
+
+/* DA9055_REG_CONTROL_A (addr=0xA) */
+#define	DA9055_DEBOUNCING_SHIFT		0x00
+#define	DA9055_DEBOUNCING_MASK		0x07
+#define	DA9055_NRES_MODE_SHIFT		0x03
+#define	DA9055_NRES_MODE_MASK		0x08
+#define	DA9055_SLEW_RATE_SHIFT		0x04
+#define	DA9055_SLEW_RATE_MASK		0x30
+#define	DA9055_NOKEY_LOCK_SHIFT		0x06
+#define	DA9055_NOKEY_LOCK_MASK		0x40
+
+/* DA9055_REG_CONTROL_B (addr=0xB) */
+#define	DA9055_RTC_MODE_PD		0x01
+#define	DA9055_RTC_MODE_SD_SHIFT	0x01
+#define	DA9055_RTC_MODE_SD		0x02
+#define	DA9055_RTC_EN			0x04
+#define	DA9055_ECO_MODE_SHIFT		0x03
+#define	DA9055_ECO_MODE_MASK		0x08
+#define	DA9055_TWDSCALE_SHIFT		4
+#define	DA9055_TWDSCALE_MASK		0x70
+#define	DA9055_V_LOCK_SHIFT		0x07
+#define	DA9055_V_LOCK_MASK		0x80
+
+/* DA9055_REG_CONTROL_C (addr=0xC) */
+#define	DA9055_SYSTEM_EN_SHIFT		0x00
+#define	DA9055_SYSTEM_EN_MASK		0x01
+#define	DA9055_POWERN_EN_SHIFT		0x01
+#define	DA9055_POWERN_EN_MASK		0x02
+#define	DA9055_POWER1_EN_SHIFT		0x02
+#define	DA9055_POWER1_EN_MASK		0x04
+
+/* DA9055_REG_CONTROL_D (addr=0xD) */
+#define	DA9055_STANDBY_SHIFT		0x02
+#define	DA9055_STANDBY_MASK		0x08
+#define	DA9055_AUTO_BOOT_SHIFT		0x03
+#define	DA9055_AUTO_BOOT_MASK		0x04
+
+/* DA9055_REG_CONTROL_E (addr=0xE) */
+#define	DA9055_WATCHDOG_SHIFT		0x00
+#define	DA9055_WATCHDOG_MASK		0x01
+#define	DA9055_SHUTDOWN_SHIFT		0x01
+#define	DA9055_SHUTDOWN_MASK		0x02
+#define	DA9055_WAKE_UP_SHIFT		0x02
+#define	DA9055_WAKE_UP_MASK		0x04
+
+/* DA9055_REG_GPIO (addr=0x10/0x11) */
+#define	DA9055_GPIO0_PIN_SHIFT		0x00
+#define	DA9055_GPIO0_PIN_MASK		0x03
+#define	DA9055_GPIO0_TYPE_SHIFT		0x02
+#define	DA9055_GPIO0_TYPE_MASK		0x04
+#define	DA9055_GPIO0_WEN_SHIFT		0x03
+#define	DA9055_GPIO0_WEN_MASK		0x08
+#define	DA9055_GPIO1_PIN_SHIFT		0x04
+#define	DA9055_GPIO1_PIN_MASK		0x30
+#define	DA9055_GPIO1_TYPE_SHIFT		0x06
+#define	DA9055_GPIO1_TYPE_MASK		0x40
+#define	DA9055_GPIO1_WEN_SHIFT		0x07
+#define	DA9055_GPIO1_WEN_MASK		0x80
+#define	DA9055_GPIO2_PIN_SHIFT		0x00
+#define	DA9055_GPIO2_PIN_MASK		0x30
+#define	DA9055_GPIO2_TYPE_SHIFT		0x02
+#define	DA9055_GPIO2_TYPE_MASK		0x04
+#define	DA9055_GPIO2_WEN_SHIFT		0x03
+#define	DA9055_GPIO2_WEN_MASK		0x08
+
+/* DA9055_REG_GPIO_MODE (addr=0x12) */
+#define	DA9055_GPIO0_MODE_SHIFT		0x00
+#define	DA9055_GPIO0_MODE_MASK		0x01
+#define	DA9055_GPIO1_MODE_SHIFT		0x01
+#define	DA9055_GPIO1_MODE_MASK		0x02
+#define	DA9055_GPIO2_MODE_SHIFT		0x02
+#define	DA9055_GPIO2_MODE_MASK		0x04
+
+/* DA9055_REG_BCORE_CONT (addr=0x13) */
+#define	DA9055_BCORE_EN_SHIFT		0x00
+#define	DA9055_BCORE_EN_MASK		0x01
+#define	DA9055_BCORE_GPI_SHIFT		0x01
+#define	DA9055_BCORE_GPI_MASK		0x02
+#define	DA9055_BCORE_PD_DIS_SHIFT	0x03
+#define	DA9055_BCORE_PD_DIS_MASK	0x04
+#define	DA9055_VBCORE_SEL_SHIFT		0x04
+#define	DA9055_SEL_REG_A		0x0
+#define	DA9055_SEL_REG_B		0x10
+#define	DA9055_VBCORE_SEL_MASK		0x10
+#define DA9055_V_GPI_MASK		0x60
+#define DA9055_V_GPI_SHIFT		0x05
+#define DA9055_E_GPI_MASK		0x06
+#define DA9055_E_GPI_SHIFT		0x01
+#define	DA9055_VBCORE_GPI_SHIFT		0x05
+#define	DA9055_VBCORE_GPI_MASK		0x60
+#define	DA9055_BCORE_CONF_SHIFT		0x07
+#define	DA9055_BCORE_CONF_MASK		0x80
+
+/* DA9055_REG_BMEM_CONT (addr=0x14) */
+#define	DA9055_BMEM_EN_SHIFT		0x00
+#define	DA9055_BMEM_EN_MASK		0x01
+#define	DA9055_BMEM_GPI_SHIFT		0x01
+#define	DA9055_BMEM_GPI_MASK		0x06
+#define	DA9055_BMEM_PD_DIS_SHIFT	0x03
+#define	DA9055_BMEM_PD_DIS_MASK		0x08
+#define	DA9055_VBMEM_SEL_SHIT		0x04
+#define	DA9055_VBMEM_SEL_VBMEM_A	(0<<4)
+#define	DA9055_VBMEM_SEL_VBMEM_B	(1<<4)
+#define	DA9055_VBMEM_SEL_MASK		0x10
+#define	DA9055_VBMEM_GPI_SHIFT		0x05
+#define	DA9055_VBMEM_GPI_MASK		0x60
+#define	DA9055_BMEM_CONF_SHIFT		0x07
+#define	DA9055_BMEM_CONF_MASK		0x80
+
+/* DA9055_REG_LDO_CONT (addr=0x15-0x1A) */
+#define	DA9055_LDO_EN_SHIFT		0x00
+#define	DA9055_LDO_EN_MASK		0x01
+#define	DA9055_LDO_GPI_SHIFT		0x01
+#define	DA9055_LDO_GPI_MASK		0x06
+#define	DA9055_LDO_PD_DIS_SHIFT		0x03
+#define	DA9055_LDO_PD_DIS_MASK		0x08
+#define	DA9055_VLDO_SEL_SHIFT		0x04
+#define	DA9055_VLDO_SEL_MASK		0x10
+#define	DA9055_VLDO_SEL_VLDO_A		0x00
+#define	DA9055_VLDO_SEL_VLDO_B		0x01
+#define	DA9055_VLDO_GPI_SHIFT		0x05
+#define	DA9055_VLDO_GPI_MASK		0x60
+#define	DA9055_LDO_CONF_SHIFT		0x07
+#define	DA9055_LDO_CONF_MASK		0x80
+#define	DA9055_REGUALTOR_SET_A		0x00
+#define	DA9055_REGUALTOR_SET_B		0x10
+
+/* DA9055_REG_ADC_MAN (addr=0x1B) */
+#define	DA9055_ADC_MUX_SHIFT		0
+#define	DA9055_ADC_MUX_MASK		0xF
+#define	DA9055_ADC_MUX_VSYS		0x0
+#define	DA9055_ADC_MUX_ADCIN1		0x01
+#define	DA9055_ADC_MUX_ADCIN2		0x02
+#define	DA9055_ADC_MUX_ADCIN3		0x03
+#define	DA9055_ADC_MUX_T_SENSE		0x04
+#define	DA9055_ADC_MAN_SHIFT		0x04
+#define	DA9055_ADC_MAN_CONV		0x10
+#define DA9055_ADC_LSB_MASK		0X03
+#define DA9055_ADC_MODE_MASK		0x20
+#define	DA9055_ADC_MODE_SHIFT		5
+#define	DA9055_ADC_MODE_1MS		(1<<5)
+#define	DA9055_COMP1V2_EN_SHIFT		7
+
+/* DA9055_REG_ADC_CONT (addr=0x1C) */
+#define	DA9055_ADC_AUTO_VSYS_EN_SHIFT	0
+#define	DA9055_ADC_AUTO_AD1_EN_SHIFT	1
+#define	DA9055_ADC_AUTO_AD2_EN_SHIFT	2
+#define	DA9055_ADC_AUTO_AD3_EN_SHIFT	3
+#define	DA9055_ADC_ISRC_EN_SHIFT	4
+#define	DA9055_ADC_ADCIN1_DEB_SHIFT	5
+#define	DA9055_ADC_ADCIN2_DEB_SHIFT	6
+#define	DA9055_ADC_ADCIN3_DEB_SHIFT	7
+#define DA9055_AD1_ISRC_MASK		0x10
+#define DA9055_AD1_ISRC_SHIFT		4
+
+/* DA9055_REG_VSYS_MON (addr=0x1D) */
+#define	DA9055_VSYS_VAL_SHIFT		0
+#define	DA9055_VSYS_VAL_MASK		0xFF
+#define	DA9055_VSYS_VAL_BASE		0x00
+#define	DA9055_VSYS_VAL_MAX		DA9055_VSYS_VAL_MASK
+#define	DA9055_VSYS_VOLT_BASE		2500
+#define	DA9055_VSYS_VOLT_INC		10
+#define	DA9055_VSYS_STEPS		255
+#define	DA9055_VSYS_VOLT_MIN		2500
+
+/* DA9044_REG_XXX_RES (addr=0x20-0x23) */
+#define	DA9055_ADC_VAL_SHIFT		0
+#define	DA9055_ADC_VAL_MASK		0xFF
+#define	DA9055_ADC_VAL_BASE		0x00
+#define	DA9055_ADC_VAL_MAX		DA9055_ADC_VAL_MASK
+#define	DA9055_ADC_VOLT_BASE		0
+#define	DA9055_ADC_VSYS_VOLT_BASE	2500
+#define	DA9055_ADC_VOLT_INC		10
+#define	DA9055_ADC_VSYS_VOLT_INC	12
+#define	DA9055_ADC_STEPS		255
+
+/* DA9055_REG_EN_32K  (addr=0x35)*/
+#define	DA9055_STARTUP_TIME_MASK	0x07
+#define	DA9055_STARTUP_TIME_0S		0x0
+#define	DA9055_STARTUP_TIME_0_52S	0x1
+#define	DA9055_STARTUP_TIME_1S		0x2
+#define	DA9055_CRYSTAL_EN		0x08
+#define	DA9055_DELAY_MODE_EN		0x10
+#define	DA9055_OUT_CLCK_GATED		0x20
+#define	DA9055_RTC_CLOCK_GATED		0x40
+#define	DA9055_EN_32KOUT_BUF		0x80
+
+/* DA9055_REG_RESET (addr=0x36) */
+/* Timer up to 31.744 ms */
+#define	DA9055_RESET_TIMER_VAL_SHIFT	0
+#define	DA9055_RESET_LOW_VAL_MASK	0x3F
+#define	DA9055_RESET_LOW_VAL_BASE	0
+#define	DA9055_RESET_LOW_VAL_MAX	DA9055_RESET_LOW_VAL_MASK
+#define	DA9055_RESET_US_LOW_BASE	1024 /* min val in units of us */
+#define	DA9055_RESET_US_LOW_INC		1024 /* inc val in units of us */
+#define	DA9055_RESET_US_LOW_STEP	30
+
+/* Timer up to 1048.576ms */
+#define	DA9055_RESET_HIGH_VAL_MASK	0x3F
+#define	DA9055_RESET_HIGH_VAL_BASE	0
+#define	DA9055_RESET_HIGH_VAL_MAX	DA9055_RESET_HIGH_VAL_MASK
+#define	DA9055_RESET_US_HIGH_BASE	32768 /* min val in units of us */
+#define	DA9055_RESET_US_HIGH_INC	32768 /* inv val in units of us */
+#define	DA9055_RESET_US_HIGH_STEP	31
+
+/* DA9055_REG_BUCK_ILIM (addr=0x37)*/
+#define	DA9055_BMEM_ILIM_SHIFT		0
+#define	DA9055_ILIM_MASK		0x3
+#define	DA9055_ILIM_500MA		0x0
+#define	DA9055_ILIM_600MA		0x1
+#define	DA9055_ILIM_700MA		0x2
+#define	DA9055_ILIM_800MA		0x3
+#define	DA9055_BCORE_ILIM_SHIFT		2
+
+/* DA9055_REG_BCORE_MODE (addr=0x38) */
+#define	DA9055_BMEM_MODE_SHIFT		0
+#define	DA9055_MODE_MASK		0x3
+#define	DA9055_MODE_AB			0x0
+#define	DA9055_MODE_SLEEP		0x1
+#define	DA9055_MODE_SYNCHRO		0x2
+#define	DA9055_MODE_AUTO		0x3
+#define	DA9055_BCORE_MODE_SHIFT		2
+
+/* DA9055_REG_VBCORE_A/B (addr=0x39/0x41)*/
+#define	DA9055_VBCORE_VAL_SHIFT		0
+#define	DA9055_VBCORE_VAL_MASK		0x3F
+#define	DA9055_VBCORE_VAL_BASE		0x09
+#define	DA9055_VBCORE_VAL_MAX		DA9055_VBCORE_VAL_MASK
+#define	DA9055_VBCORE_VOLT_BASE		750
+#define	DA9055_VBCORE_VOLT_INC		25
+#define	DA9055_VBCORE_STEPS		53
+#define	DA9055_VBCORE_VOLT_MIN		DA9055_VBCORE_VOLT_BASE
+#define	DA9055_BCORE_SL_SYNCHRO		(0<<7)
+#define	DA9055_BCORE_SL_SLEEP		(1<<7)
+
+/* DA9055_REG_VBMEM_A/B (addr=0x3A/0x42)*/
+#define	DA9055_VBMEM_VAL_SHIFT		0
+#define	DA9055_VBMEM_VAL_MASK		0x3F
+#define	DA9055_VBMEM_VAL_BASE		0x00
+#define	DA9055_VBMEM_VAL_MAX		DA9055_VBMEM_VAL_MASK
+#define	DA9055_VBMEM_VOLT_BASE		925
+#define	DA9055_VBMEM_VOLT_INC		25
+#define	DA9055_VBMEM_STEPS		63
+#define	DA9055_VBMEM_VOLT_MIN		DA9055_VBMEM_VOLT_BASE
+#define	DA9055_BCMEM_SL_SYNCHRO		(0<<7)
+#define	DA9055_BCMEM_SL_SLEEP		(1<<7)
+
+
+/* DA9055_REG_VLDO (addr=0x3B-0x40/0x43-0x48)*/
+#define	DA9055_VLDO_VAL_SHIFT		0
+#define	DA9055_VLDO_VAL_MASK		0x3F
+#define	DA9055_VLDO6_VAL_MASK		0x7F
+#define	DA9055_VLDO_VAL_BASE		0x02
+#define	DA9055_VLDO2_VAL_BASE		0x03
+#define	DA9055_VLDO6_VAL_BASE		0x00
+#define	DA9055_VLDO_VAL_MAX		DA9055_VLDO_VAL_MASK
+#define	DA9055_VLDO6_VAL_MAX		DA9055_VLDO6_VAL_MASK
+#define	DA9055_VLDO_VOLT_BASE		900
+#define	DA9055_VLDO_VOLT_INC		50
+#define	DA9055_VLDO6_VOLT_INC		20
+#define	DA9055_VLDO_STEPS		48
+#define	DA9055_VLDO5_STEPS		37
+#define	DA9055_VLDO6_STEPS		120
+#define	DA9055_VLDO_VOLT_MIN		DA9055_VLDO_VOLT_BASE
+#define	DA9055_LDO_MODE_SHIFT		7
+#define	DA9055_LDO_SL_NORMAL		0
+#define	DA9055_LDO_SL_SLEEP		1
+
+/* DA9055_REG_OTP_CONT (addr=0x50) */
+#define	DA9055_OTP_TIM_NORMAL		(0<<0)
+#define	DA9055_OTP_TIM_MARGINAL		(1<<0)
+#define	DA9055_OTP_GP_RD_SHIFT		1
+#define	DA9055_OTP_APPS_RD_SHIFT	2
+#define	DA9055_PC_DONE_SHIFT		3
+#define	DA9055_OTP_GP_LOCK_SHIFT	4
+#define	DA9055_OTP_APPS_LOCK_SHIFT	5
+#define	DA9055_OTP_CONF_LOCK_SHIFT	6
+#define	DA9055_OTP_WRITE_DIS_SHIFT	7
+
+/* DA9055_REG_COUNT_S (addr=0x53) */
+#define	DA9055_RTC_SEC			0x3F
+#define	DA9055_RTC_MONITOR_EN		0x40
+#define	DA9055_RTC_READ			0x80
+
+/* DA9055_REG_COUNT_MI (addr=0x54) */
+#define	DA9055_RTC_MIN			0x3F
+
+/* DA9055_REG_COUNT_H (addr=0x55) */
+#define	DA9055_RTC_HOUR			0x1F
+
+/* DA9055_REG_COUNT_D (addr=0x56) */
+#define	DA9055_RTC_DAY			0x1F
+
+/* DA9055_REG_COUNT_MO (addr=0x57) */
+#define	DA9055_RTC_MONTH		0x0F
+
+/* DA9055_REG_COUNT_Y (addr=0x58) */
+#define	DA9055_RTC_YEAR			0x3F
+#define	DA9055_RTC_YEAR_BASE		2000
+
+/* DA9055_REG_ALARM_MI (addr=0x59) */
+#define	DA9055_RTC_ALM_MIN		0x3F
+#define	DA9055_ALARM_STATUS_SHIFT	6
+#define	DA9055_ALARM_STATUS_MASK	0x3
+#define	DA9055_ALARM_STATUS_NO_ALARM	0x0
+#define	DA9055_ALARM_STATUS_TICK	0x1
+#define	DA9055_ALARM_STATUS_TIMER_ALARM	0x2
+#define	DA9055_ALARM_STATUS_BOTH	0x3
+
+/* DA9055_REG_ALARM_H (addr=0x5A) */
+#define	DA9055_RTC_ALM_HOUR		0x1F
+
+/* DA9055_REG_ALARM_D (addr=0x5B) */
+#define	DA9055_RTC_ALM_DAY		0x1F
+
+/* DA9055_REG_ALARM_MO (addr=0x5C) */
+#define	DA9055_RTC_ALM_MONTH		0x0F
+#define	DA9055_RTC_TICK_WAKE_MASK	0x20
+#define	DA9055_RTC_TICK_WAKE_SHIFT	5
+#define	DA9055_RTC_TICK_TYPE		0x10
+#define	DA9055_RTC_TICK_TYPE_SHIFT	0x4
+#define	DA9055_RTC_TICK_SEC		0x0
+#define	DA9055_RTC_TICK_MIN		0x1
+#define	DA9055_ALARAM_TICK_WAKE		0x20
+
+/* DA9055_REG_ALARM_Y (addr=0x5D) */
+#define	DA9055_RTC_TICK_EN		0x80
+#define	DA9055_RTC_ALM_EN		0x40
+#define	DA9055_RTC_TICK_ALM_MASK	0xC0
+#define	DA9055_RTC_ALM_YEAR		0x3F
+
+/* DA9055_REG_TRIM_CLDR (addr=0x62) */
+#define	DA9055_TRIM_32K_SHIFT		0
+#define	DA9055_TRIM_32K_MASK		0x7F
+#define	DA9055_TRIM_DECREMENT		(1<<7)
+#define	DA9055_TRIM_INCREMENT		(0<<7)
+#define	DA9055_TRIM_VAL_BASE		0x0
+#define	DA9055_TRIM_PPM_BASE		0x0 /* min val in units of 0.1PPM */
+#define	DA9055_TRIM_PPM_INC		19 /* min inc in units of 0.1PPM */
+#define	DA9055_TRIM_STEPS		127
+
+/* DA9055_REG_CONFIG_A (addr=0x65) */
+#define	DA9055_PM_I_V_VDDCORE		(0<<0)
+#define	DA9055_PM_I_V_VDD_IO		(1<<0)
+#define	DA9055_VDD_FAULT_TYPE_ACT_LOW	(0<<1)
+#define	DA9055_VDD_FAULT_TYPE_ACT_HIGH	(1<<1)
+#define	DA9055_PM_O_TYPE_PUSH_PULL	(0<<2)
+#define	DA9055_PM_O_TYPE_OPEN_DRAIN	(1<<2)
+#define	DA9055_IRQ_TYPE_ACT_LOW		(0<<3)
+#define	DA9055_IRQ_TYPE_ACT_HIGH	(1<<3)
+#define	DA9055_NIRQ_MODE_IMM		(0<<4)
+#define	DA9055_NIRQ_MODE_ACTIVE		(1<<4)
+#define	DA9055_GPI_V_VDDCORE		(0<<5)
+#define	DA9055_GPI_V_VDD_IO		(1<<5)
+#define	DA9055_PM_IF_V_VDDCORE		(0<<6)
+#define	DA9055_PM_IF_V_VDD_IO		(1<<6)
+
+/* DA9055_REG_CONFIG_B (addr=0x66) */
+#define	DA9055_VDD_FAULT_VAL_SHIFT	0
+#define	DA9055_VDD_FAULT_VAL_MASK	0xF
+#define	DA9055_VDD_FAULT_VAL_BASE	0x0
+#define	DA9055_VDD_FAULT_VAL_MAX	DA9055_VDD_FAULT_VAL_MASK
+#define	DA9055_VDD_FAULT_VOLT_BASE	2500
+#define	DA9055_VDD_FAULT_VOLT_INC	50
+#define	DA9055_VDD_FAULT_STEPS		15
+
+#define	DA9055_VDD_HYST_VAL_SHIFT	4
+#define	DA9055_VDD_HYST_VAL_MASK	0x7
+#define	DA9055_VDD_HYST_VAL_BASE	0x0
+#define	DA9055_VDD_HYST_VAL_MAX		DA9055_VDD_HYST_VAL_MASK
+#define	DA9055_VDD_HYST_VOLT_BASE	100
+#define	DA9055_VDD_HYST_VOLT_INC	50
+#define	DA9055_VDD_HYST_STEPS		7
+#define	DA9055_VDD_HYST_VOLT_MIN	DA9055_VDD_HYST_VOLT_BASE
+
+#define	DA9055_VDD_FAULT_EN_SHIFT	7
+
+/* DA9055_REG_CONFIG_C (addr=0x67) */
+#define	DA9055_BCORE_CLK_INV_SHIFT	0
+#define	DA9055_BMEM_CLK_INV_SHIFT	1
+#define	DA9055_NFAULT_CONF_SHIFT	2
+#define	DA9055_LDO_SD_SHIFT		4
+#define	DA9055_LDO5_BYP_SHIFT		6
+#define	DA9055_LDO6_BYP_SHIFT		7
+
+/* DA9055_REG_CONFIG_D (addr=0x68) */
+#define	DA9055_NONKEY_PIN_SHIFT		0
+#define	DA9055_NONKEY_PIN_MASK		0x3
+#define	DA9055_NONKEY_PIN_PORT_MODE	0x0
+#define	DA9055_NONKEY_PIN_KEY_MODE	0x1
+#define	DA9055_NONKEY_PIN_MULTI_FUNC	0x2
+#define	DA9055_NONKEY_PIN_DEDICT	0x3
+#define	DA9055_NONKEY_SD_SHIFT		2
+#define	DA9055_KEY_DELAY_SHIFT		3
+#define	DA9055_KEY_DELAY_MASK		0x3
+#define	DA9055_KEY_DELAY_4S		0x0
+#define	DA9055_KEY_DELAY_6S		0x1
+#define	DA9055_KEY_DELAY_8S		0x2
+#define	DA9055_KEY_DELAY_10S		0x3
+
+/* DA9055_REG_CONFIG_E (addr=0x69) */
+#define	DA9055_GPIO_PUPD_PULL_UP	0x0
+#define	DA9055_GPIO_PUPD_OPEN_DRAIN	0x1
+#define	DA9055_GPIO0_PUPD_SHIFT		0
+#define	DA9055_GPIO1_PUPD_SHIFT		1
+#define	DA9055_GPIO2_PUPD_SHIFT		2
+#define	DA9055_UVOV_DELAY_SHIFT		4
+#define	DA9055_UVOV_DELAY_MASK		0x3
+#define	DA9055_RESET_DURATION_SHIFT	6
+#define	DA9055_RESET_DURATION_MASK	0x3
+#define	DA9055_RESET_DURATION_0MS	0x0
+#define	DA9055_RESET_DURATION_100MS	0x1
+#define	DA9055_RESET_DURATION_500MS	0x2
+#define	DA9055_RESET_DURATION_1000MS	0x3
+
+/* DA9055_REG_MON_REG_1 (addr=0x6A) */
+#define	DA9055_MON_THRES_SHIFT		0
+#define	DA9055_MON_THRES_MASK		0x3
+#define	DA9055_MON_RES_SHIFT		2
+#define	DA9055_MON_DEB_SHIFT		3
+#define	DA9055_MON_MODE_SHIFT		4
+#define	DA9055_MON_MODE_MASK		0x3
+#define	DA9055_START_MAX_SHIFT		6
+#define	DA9055_START_MAX_MASK		0x3
+
+/* DA9055_REG_MON_REG_2 (addr=0x6B) */
+#define	DA9055_LDO1_MON_EN_SHIFT	0
+#define	DA9055_LDO2_MON_EN_SHIFT	1
+#define	DA9055_LDO3_MON_EN_SHIFT	2
+#define	DA9055_LDO4_MON_EN_SHIFT	3
+#define	DA9055_LDO5_MON_EN_SHIFT	4
+#define	DA9055_LDO6_MON_EN_SHIFT	5
+#define	DA9055_BCORE_MON_EN_SHIFT	6
+#define	DA9055_BMEM_MON_EN_SHIFT	7
+
+/* DA9055_REG_CONFIG_F (addr=0x6C) */
+#define	DA9055_LDO1_DEF_SHIFT		0
+#define	DA9055_LDO2_DEF_SHIFT		1
+#define	DA9055_LDO3_DEF_SHIFT		2
+#define	DA9055_LDO4_DEF_SHIFT		3
+#define	DA9055_LDO5_DEF_SHIFT		4
+#define	DA9055_LDO6_DEF_SHIFT		5
+#define	DA9055_BCORE_DEF_SHIFT		6
+#define	DA9055_BMEM_DEF_SHIFT		7
+
+/* DA9055_REG_MON_REG_4 (addr=0x6D) */
+#define	DA9055_MON_A8_IDX_SHIFT		0
+#define	DA9055_MON_A89_IDX_MASK		0x3
+#define	DA9055_MON_A89_IDX_NONE		0x0
+#define	DA9055_MON_A89_IDX_BUCKCORE	0x1
+#define	DA9055_MON_A89_IDX_LDO3		0x2
+#define	DA9055_MON_A9_IDX_SHIFT		5
+
+/* DA9055_REG_MON_REG_5 (addr=0x6E) */
+#define	DA9055_MON_A10_IDX_SHIFT	0
+#define	DA9055_MON_A10_IDX_MASK		0x3
+#define	DA9055_MON_A10_IDX_NONE		0x0
+#define	DA9055_MON_A10_IDX_LDO1		0x1
+#define	DA9055_MON_A10_IDX_LDO2		0x2
+#define	DA9055_MON_A10_IDX_LDO5		0x3
+#define	DA9055_MON_A10_IDX_LDO6		0x4
+
+#endif /* __DA9055_REG_H */
-- 
1.7.0.4


