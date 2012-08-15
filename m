Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2HOPSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:18:41 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:18100 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab2HOPSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:18:35 -0400
Message-Id: <201208151518.q7FFIN9v011639@latitude.olech.com>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Wed, 15 Aug 2012 16:05:21 +0100
Subject: [NEW DRIVER V3 1/8] DA9058 MFD core driver
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Steven Toth <stoth@kernellabs.com>
Cc: Michael Krufky <mkrufky@kernellabs.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: David Dajun Chen <david.chen@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the CORE component driver for the Dialog DA9058 PMIC MFD.

This driver, via MFD CELLs, causes all the other component drivers to
be loaded (if a module), and initialized via their probe methods.
All the other component drivers depend on this CORE component driver.

This CORE component driver supplies all of the MFD cell platform data
used by the other DA9058 component drivers for initialization.
This CORE component driver recieves the actual platform data from the
machine driver, but that config data has the nature of overides from
sensible default values. Thus it is not essential to provide any real
platform data at all from the machine driver.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
 drivers/mfd/Kconfig                  |   18 +
 drivers/mfd/Makefile                 |    3 +
 drivers/mfd/da9058-core.c            |   83 +++
 drivers/mfd/da9058-i2c.c             |   97 ++++
 drivers/mfd/da9058-info.c            |  935 ++++++++++++++++++++++++++++++++++
 drivers/mfd/da9058-irq.c             |   56 ++
 include/linux/mfd/da9058/bat.h       |   33 ++
 include/linux/mfd/da9058/codec.h     |   22 +
 include/linux/mfd/da9058/conf.h      |   22 +
 include/linux/mfd/da9058/core.h      |   66 +++
 include/linux/mfd/da9058/gpio.h      |   19 +
 include/linux/mfd/da9058/hwmon.h     |   36 ++
 include/linux/mfd/da9058/i2c.h       |   22 +
 include/linux/mfd/da9058/irq.h       |   50 ++
 include/linux/mfd/da9058/onkey.h     |   17 +
 include/linux/mfd/da9058/pdata.h     |   32 ++
 include/linux/mfd/da9058/registers.h |  480 +++++++++++++++++
 include/linux/mfd/da9058/regulator.h |   33 ++
 include/linux/mfd/da9058/rtc.h       |   17 +
 19 files changed, 2041 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/da9058-core.c
 create mode 100644 drivers/mfd/da9058-i2c.c
 create mode 100644 drivers/mfd/da9058-info.c
 create mode 100644 drivers/mfd/da9058-irq.c
 create mode 100644 include/linux/mfd/da9058/bat.h
 create mode 100644 include/linux/mfd/da9058/codec.h
 create mode 100644 include/linux/mfd/da9058/conf.h
 create mode 100644 include/linux/mfd/da9058/core.h
 create mode 100644 include/linux/mfd/da9058/gpio.h
 create mode 100644 include/linux/mfd/da9058/hwmon.h
 create mode 100644 include/linux/mfd/da9058/i2c.h
 create mode 100644 include/linux/mfd/da9058/irq.h
 create mode 100644 include/linux/mfd/da9058/onkey.h
 create mode 100644 include/linux/mfd/da9058/pdata.h
 create mode 100644 include/linux/mfd/da9058/registers.h
 create mode 100644 include/linux/mfd/da9058/regulator.h
 create mode 100644 include/linux/mfd/da9058/rtc.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 92144ed..3fa1a75 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -3,6 +3,7 @@
 #
 
 if HAS_IOMEM
+
 menu "Multifunction device drivers"
 
 config MFD_CORE
@@ -20,6 +21,23 @@ config MFD_88PM860X
 	  select individual components like voltage regulators, RTC and
 	  battery-charger under the corresponding menus.
 
+config MFD_DA9058
+	tristate "Dialog Semiconductor DA9058 PMIC Support"
+	depends on I2C
+	select REGMAP_I2C
+	select REGMAP_IRQ
+	select MFD_CORE
+	help
+	  Say yes here for support of Dialog Semiconductor DA9058. This is
+	  a Power Management IC. This driver provides common support for
+	  accessing the device as well as the I2C interface to the chip itself.
+	  Additional drivers must be enabled in order to use the functionality
+	  of the device.
+
+	  This driver can be built as a module, but since the functionality
+	  of the device includes regulators it probably should be built into
+	  the kernel. If built as a module it will be called "da9058"
+
 config MFD_SM501
 	tristate "Support for Silicon Motion SM501"
 	 ---help---
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 75f6ed6..1853278 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -86,6 +86,9 @@ obj-$(CONFIG_MFD_MAX8998)	+= max8998.o max8998-irq.o
 
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633.o
+da9058-objs			= da9058-irq.o da9058-i2c.o da9058-core.o da9058-info.o
+obj-$(CONFIG_MFD_DA9058)		+= da9058.o
+
 obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
 obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
 obj-$(CONFIG_ABX500_CORE)	+= abx500-core.o
diff --git a/drivers/mfd/da9058-core.c b/drivers/mfd/da9058-core.c
new file mode 100644
index 0000000..072f591
--- /dev/null
+++ b/drivers/mfd/da9058-core.c
@@ -0,0 +1,83 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/regmap.h>
+#include <linux/mfd/core.h>
+
+#include <linux/mfd/da9058/core.h>
+#include <linux/mfd/da9058/registers.h>
+#include <linux/mfd/da9058/irq.h>
+#include <linux/mfd/da9058/pdata.h>
+#include <linux/mfd/da9058/conf.h>
+
+struct da9058 *__devinit da9058_device_init(struct device *dev,
+				struct regmap *regmap, void *adapter,
+				int irq, struct da9058_chip_pdata *pdata)
+{
+	struct da9058 *da9058;
+	int ret;
+
+	da9058 = devm_kzalloc(dev, sizeof(struct da9058), GFP_KERNEL);
+	if (!da9058) {
+		ret = -ENOMEM;
+		goto failed_to_allocate_memory;
+	}
+
+	dev_set_drvdata(dev, da9058);
+	da9058->dev = dev;
+	da9058->regmap = regmap;
+
+	/*
+	 * the init_board_irq() call-back function should be defined in
+	 * the machine driver initialization code and is used to set up
+	 * the actual (probably GPIO) line as an interrupt line.
+	 */
+	if (pdata->init_board_irq) {
+		ret = pdata->init_board_irq();
+		if (ret)
+			goto failed_to_setup_the_actual_i2c_hw_irq;
+	}
+
+	mutex_init(&da9058->adc_mutex);
+	init_completion(&da9058->adc_read_done);
+
+	da9058_set_bits(da9058, DA9058_POWERCONT_REG, DA9058_POWERCONT_nSLEEP);
+	da9058_clear_bits(da9058, DA9058_CONTROLB_REG,
+				DA9058_CONTROLB_WRITEMODE);
+
+	ret = da9058_irq_init(da9058, irq, &da9058_irq_chip);
+	if (ret)
+		goto failed_to_initialize_i2c_irq;
+
+	ret = da9058_add_mfd_devices(da9058, pdata, adapter);
+	if (ret)
+		goto mfd_initialization_error;
+
+	return da9058;
+
+mfd_initialization_error:
+	da9058_irq_exit(da9058);
+failed_to_initialize_i2c_irq:
+failed_to_setup_the_actual_i2c_hw_irq:
+failed_to_allocate_memory:
+	dev_err(da9058->dev, "failed to initialize devices: %d\n", ret);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(da9058_device_init);
+
+int da9058_device_exit(struct da9058 *da9058)
+{
+	mfd_remove_devices(da9058->dev);
+
+	return da9058_irq_exit(da9058);
+}
+EXPORT_SYMBOL_GPL(da9058_device_exit);
diff --git a/drivers/mfd/da9058-i2c.c b/drivers/mfd/da9058-i2c.c
new file mode 100644
index 0000000..4666c82
--- /dev/null
+++ b/drivers/mfd/da9058-i2c.c
@@ -0,0 +1,97 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+
+#include <linux/mfd/da9058/version.h>
+#include <linux/mfd/da9058/core.h>
+#include <linux/mfd/da9058/i2c.h>
+
+static int __devinit da9058_i2c_probe(struct i2c_client *i2c,
+					const struct i2c_device_id *id)
+{
+	struct device *dev = &i2c->dev;
+	struct regmap *regmap;
+	void *da9058;
+	int ret;
+
+	regmap = devm_regmap_init_i2c(i2c, &da9058_regmap_config);
+
+	if (IS_ERR(regmap)) {
+		ret = PTR_ERR(regmap);
+		dev_err(dev, "Failed to allocate register map: %d\n", ret);
+		goto exit;
+	}
+
+	da9058 = da9058_device_init(dev, regmap, i2c->adapter, i2c->irq,
+				i2c->dev.platform_data);
+	if (IS_ERR(da9058)) {
+		ret = PTR_ERR(da9058);
+		dev_err(dev, "Failed to initialize da9058: %d\n", ret);
+		goto exit;
+	}
+
+	i2c_set_clientdata(i2c, da9058);
+	ret = 0;
+exit:
+	return ret;
+}
+
+static int da9058_i2c_remove(struct i2c_client *i2c)
+{
+	void *da9058 = i2c_get_clientdata(i2c);
+
+	if (!da9058)
+		return -ENODEV;
+
+	return da9058_device_exit(da9058);
+}
+
+static const struct i2c_device_id da9058_i2c_id[] = {
+	{"da9058", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, da9058_i2c_id);
+
+static struct i2c_driver da9058_i2c_driver = {
+	.driver = {
+		.name = "da9058",
+		.owner = THIS_MODULE,
+	},
+	.probe = da9058_i2c_probe,
+	.remove = da9058_i2c_remove,
+	.id_table = da9058_i2c_id,
+};
+
+/*
+ *  This driver is potentially initialised very early during bootup
+ */
+static int __init da9058_i2c_init(void)
+{
+	return i2c_add_driver(&da9058_i2c_driver);
+}
+
+subsys_initcall(da9058_i2c_init);
+
+static void __exit da9058_i2c_exit(void)
+{
+	i2c_del_driver(&da9058_i2c_driver);
+}
+
+module_exit(da9058_i2c_exit);
+
+MODULE_DESCRIPTION("Core/I2C support for the Dialog DA9058 PMIC");
+MODULE_AUTHOR("Anthony Olech <Anthony.Olech@diasemi.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9058");
diff --git a/drivers/mfd/da9058-info.c b/drivers/mfd/da9058-info.c
new file mode 100644
index 0000000..3fe9c5a
--- /dev/null
+++ b/drivers/mfd/da9058-info.c
@@ -0,0 +1,935 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/regulator/machine.h>
+#include <linux/regmap.h>
+#include <linux/mfd/core.h>
+
+#include <linux/mfd/da9058/registers.h>
+#include <linux/mfd/da9058/core.h>
+#include <linux/mfd/da9058/regulator.h>
+#include <linux/mfd/da9058/rtc.h>
+#include <linux/mfd/da9058/codec.h>
+#include <linux/mfd/da9058/onkey.h>
+#include <linux/mfd/da9058/hwmon.h>
+#include <linux/mfd/da9058/irq.h>
+#include <linux/mfd/da9058/adc.h>
+#include <linux/mfd/da9058/bat.h>
+#include <linux/mfd/da9058/gpio.h>
+#include <linux/mfd/da9058/pdata.h>
+#include <linux/mfd/da9058/conf.h>
+
+static bool da9058_register_readable(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case DA9058_ADCCONT_REG:
+	case DA9058_ADCMAN_REG:
+	case DA9058_ADCRESH_REG:
+	case DA9058_ADCRESL_REG:
+	case DA9058_ALARMD_REG:
+	case DA9058_ALARMH_REG:
+	case DA9058_ALARMMI_REG:
+	case DA9058_ALARMMO_REG:
+	case DA9058_ALARMS_REG:
+	case DA9058_ALARMY_REG:
+	case DA9058_AUDIO_CONF2_REG_B:
+	case DA9058_AUTORES_REG_1:
+	case DA9058_BUCK1_REG:
+	case DA9058_BUCK2_REG:
+	case DA9058_BUCK3_REG:
+	case DA9058_BUCK4_REG:
+	case DA9058_CONTROLB_REG:
+	case DA9058_COUNTD_REG:
+	case DA9058_COUNTH_REG:
+	case DA9058_COUNTMI_REG:
+	case DA9058_COUNTMO_REG:
+	case DA9058_COUNTS_REG:
+	case DA9058_COUNTY_REG:
+	case DA9058_EVENTA_REG:
+	case DA9058_EVENTB_REG:
+	case DA9058_EVENTC_REG:
+	case DA9058_EVENTD_REG:
+	case DA9058_GPIO0001_REG:
+	case DA9058_IRQMASKA_REG:
+	case DA9058_IRQMASKB_REG:
+	case DA9058_IRQMASKC_REG:
+	case DA9058_IRQMASKD_REG:
+	case DA9058_LDO10_REG:
+	case DA9058_LDO12_REG:
+	case DA9058_LDO13_REG:
+	case DA9058_LDO14_REG:
+	case DA9058_LDO16_REG:
+	case DA9058_LDO17_REG:
+	case DA9058_LDO18_REG:
+	case DA9058_LDO19_REG:
+	case DA9058_LDO1_REG:
+	case DA9058_LDO2_REG:
+	case DA9058_LDO3_REG:
+	case DA9058_LDO4_REG:
+	case DA9058_LDO5_REG:
+	case DA9058_LDO6_REG:
+	case DA9058_LDO7_REG:
+	case DA9058_LDO8_REG:
+	case DA9058_LDO9_REG:
+	case DA9058_POWERCONT_REG:
+	case DA9058_STATUSA_REG:
+	case DA9058_STATUSB_REG:
+	case DA9058_STATUSC_REG:
+	case DA9058_STATUSD_REG:
+	case DA9058_SUPPLY_REG:
+	case DA9058_TEMPRES_REG_MSB:
+	case DA9058_TOFFSET_REG:
+	case DA9058_VBATRES_REG_MSB:
+	case DA9058_WAITCONT_REG:
+
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool da9058_register_writeable(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case DA9058_ADCCONT_REG:
+	case DA9058_ADCMAN_REG:
+	case DA9058_ALARMD_REG:
+	case DA9058_ALARMH_REG:
+	case DA9058_ALARMMI_REG:
+	case DA9058_ALARMMO_REG:
+	case DA9058_ALARMS_REG:
+	case DA9058_ALARMY_REG:
+	case DA9058_AUDIO_CONF2_REG_B:
+	case DA9058_BUCK1_REG:
+	case DA9058_BUCK2_REG:
+	case DA9058_BUCK3_REG:
+	case DA9058_BUCK4_REG:
+	case DA9058_CONTROLB_REG:
+	case DA9058_COUNTD_REG:
+	case DA9058_COUNTH_REG:
+	case DA9058_COUNTMI_REG:
+	case DA9058_COUNTMO_REG:
+	case DA9058_COUNTS_REG:
+	case DA9058_COUNTY_REG:
+	case DA9058_EVENTA_REG:
+	case DA9058_EVENTB_REG:
+	case DA9058_EVENTC_REG:
+	case DA9058_EVENTD_REG:
+	case DA9058_GPIO0001_REG:
+	case DA9058_IRQMASKA_REG:
+	case DA9058_IRQMASKB_REG:
+	case DA9058_IRQMASKC_REG:
+	case DA9058_IRQMASKD_REG:
+	case DA9058_LDO10_REG:
+	case DA9058_LDO12_REG:
+	case DA9058_LDO13_REG:
+	case DA9058_LDO14_REG:
+	case DA9058_LDO16_REG:
+	case DA9058_LDO17_REG:
+	case DA9058_LDO18_REG:
+	case DA9058_LDO19_REG:
+	case DA9058_LDO1_REG:
+	case DA9058_LDO2_REG:
+	case DA9058_LDO3_REG:
+	case DA9058_LDO4_REG:
+	case DA9058_LDO5_REG:
+	case DA9058_LDO6_REG:
+	case DA9058_LDO7_REG:
+	case DA9058_LDO8_REG:
+	case DA9058_LDO9_REG:
+	case DA9058_POWERCONT_REG:
+	case DA9058_SUPPLY_REG:
+	case DA9058_TOFFSET_REG:
+	case DA9058_WAITCONT_REG:
+
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool da9058_register_volatile(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case DA9058_ADCMAN_REG:
+	case DA9058_ADCRESH_REG:
+	case DA9058_ADCRESL_REG:
+	case DA9058_ALARMD_REG:
+	case DA9058_ALARMH_REG:
+	case DA9058_ALARMMI_REG:
+	case DA9058_ALARMMO_REG:
+	case DA9058_ALARMS_REG:
+	case DA9058_ALARMY_REG:
+	case DA9058_AUTORES_REG_1:
+	case DA9058_CONTROLB_REG:
+	case DA9058_COUNTD_REG:
+	case DA9058_COUNTH_REG:
+	case DA9058_COUNTMI_REG:
+	case DA9058_COUNTMO_REG:
+	case DA9058_COUNTS_REG:
+	case DA9058_COUNTY_REG:
+	case DA9058_EVENTA_REG:
+	case DA9058_EVENTB_REG:
+	case DA9058_EVENTC_REG:
+	case DA9058_EVENTD_REG:
+	case DA9058_STATUSA_REG:
+	case DA9058_STATUSB_REG:
+	case DA9058_STATUSC_REG:
+	case DA9058_STATUSD_REG:
+	case DA9058_SUPPLY_REG:
+	case DA9058_TEMPRES_REG_MSB:
+	case DA9058_VBATRES_REG_MSB:
+	case DA9058_WAITCONT_REG:
+		return true;
+	case DA9058_ADCCONT_REG:
+	case DA9058_AUDIO_CONF2_REG_B:
+	case DA9058_POWERCONT_REG:
+	case DA9058_IRQMASKA_REG:
+	case DA9058_IRQMASKB_REG:
+	case DA9058_IRQMASKC_REG:
+	case DA9058_IRQMASKD_REG:
+	case DA9058_BUCK1_REG:
+	case DA9058_BUCK2_REG:
+	case DA9058_BUCK3_REG:
+	case DA9058_BUCK4_REG:
+	case DA9058_GPIO0001_REG:
+	case DA9058_LDO10_REG:
+	case DA9058_LDO12_REG:
+	case DA9058_LDO13_REG:
+	case DA9058_LDO14_REG:
+	case DA9058_LDO16_REG:
+	case DA9058_LDO17_REG:
+	case DA9058_LDO18_REG:
+	case DA9058_LDO19_REG:
+	case DA9058_LDO1_REG:
+	case DA9058_LDO2_REG:
+	case DA9058_LDO3_REG:
+	case DA9058_LDO4_REG:
+	case DA9058_LDO5_REG:
+	case DA9058_LDO6_REG:
+	case DA9058_LDO7_REG:
+	case DA9058_LDO8_REG:
+	case DA9058_LDO9_REG:
+	case DA9058_TOFFSET_REG:
+	default:
+		return false;
+	}
+}
+
+struct regmap_config da9058_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.cache_type = REGCACHE_RBTREE,
+
+	.max_register = DA9058_MAX_REGISTER_CNT,
+	.readable_reg = da9058_register_readable,
+	.writeable_reg = da9058_register_writeable,
+	.volatile_reg = da9058_register_volatile,
+};
+EXPORT_SYMBOL_GPL(da9058_regmap_config);
+
+static struct regulator_consumer_supply platform_vddarm_consumers[] = {
+	{.supply = "vcc",}
+};
+
+#define DA9058_BUCK12_VOLT_UPPER	2075
+#define DA9058_BUCK12_VOLT_LOWER	500
+#define DA9058_BUCK3_VOLT_UPPER		2500
+#define DA9058_BUCK3_VOLT_LOWER		925
+#define DA9058_BUCK4_VOLT_UPPER		2800
+#define DA9058_BUCK4_VOLT_LOWER		1225
+
+#define DA9058_BUCK_VOLT_STEP		25
+
+#define DA9058_LDO_VOLT_UPPER		3300
+#define DA9058_LDO_VOLT_LOWER		1200
+
+#define DA9058_LDO_VOLT_STEP		50
+
+enum da9058_regulator_ids {
+	DA9058_BUCK_1,
+	DA9058_BUCK_2,
+	DA9058_BUCK_3,
+	DA9058_BUCK_4,
+	DA9058_LDO_1,
+	DA9058_LDO_2,
+	DA9058_LDO_3,
+	DA9058_LDO_4,
+	DA9058_LDO_5,
+	DA9058_LDO_6,
+	DA9058_LDO_7,
+	DA9058_LDO_8,
+	DA9058_LDO_9,
+	DA9058_LDO_10,
+	DA9058_LDO_12,
+	DA9058_LDO_13,
+	DA9058_LDO_14,
+	DA9058_LDO_16,
+	DA9058_LDO_17,
+	DA9058_LDO_18,
+	DA9058_LDO_19,
+	DA9058_LDO_AUD1,
+	DA9058_LDO_AUD2,
+	DA9058_NUMBER_OF_REGULATORS,
+};
+
+static struct da9058_regulator_pdata buck1_pdata = {
+	.regulator_name = "DA9058_BUCK1",
+	.regulator_id = DA9058_BUCK_1,
+	.min_uV = DA9058_BUCK12_VOLT_LOWER * 1000,
+	.max_uV = DA9058_BUCK12_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_BUCK_VOLT_STEP,
+	.control_register = DA9058_BUCK1_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.ramp_register = DA9058_SUPPLY_REG,
+	.ramp_enable_mask = DA9058_SUPPLY_VBUCK1GO,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_MODE |
+				REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.boot_on = 1,
+	.num_consumer_supplies = ARRAY_SIZE(platform_vddarm_consumers),
+	.consumer_supplies = platform_vddarm_consumers,
+};
+
+static struct da9058_regulator_pdata buck2_pdata = {
+	.regulator_name = "DA9058_BUCK2",
+	.regulator_id = DA9058_BUCK_2,
+	.min_uV = DA9058_BUCK12_VOLT_LOWER * 1000,
+	.max_uV = DA9058_BUCK12_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_BUCK_VOLT_STEP,
+	.control_register = DA9058_BUCK2_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.ramp_register = DA9058_SUPPLY_REG,
+	.ramp_enable_mask = DA9058_SUPPLY_VBUCK2GO,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_MODE,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.always_on = 1,
+};
+
+static struct da9058_regulator_pdata buck3_pdata = {
+	.regulator_name = "DA9058_BUCK3",
+	.regulator_id = DA9058_BUCK_3,
+	.min_uV = DA9058_BUCK3_VOLT_LOWER * 1000,
+	.max_uV = DA9058_BUCK3_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_BUCK_VOLT_STEP,
+	.control_register = DA9058_BUCK3_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.ramp_register = DA9058_SUPPLY_REG,
+	.ramp_enable_mask = DA9058_SUPPLY_VBUCK3GO,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_MODE |
+				REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.boot_on = 1,
+};
+
+static struct da9058_regulator_pdata buck4_pdata = {
+	.regulator_name = "DA9058_BUCK4",
+	.regulator_id = DA9058_BUCK_4,
+	.min_uV = DA9058_BUCK4_VOLT_LOWER * 1000,
+	.max_uV = DA9058_BUCK4_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_BUCK_VOLT_STEP,
+	.control_register = DA9058_BUCK4_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.ramp_register = DA9058_SUPPLY_REG,
+	.ramp_enable_mask = DA9058_SUPPLY_VBUCK4GO,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_MODE |
+		REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+static struct da9058_regulator_pdata ldo1_pdata = {
+	.regulator_name = "DA9058_LDO1",
+	.regulator_id = DA9058_LDO_1,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO1_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.boot_on = 1,
+};
+
+static struct da9058_regulator_pdata ldo2_pdata = {
+	.regulator_name = "DA9058_LDO2",
+	.regulator_id = DA9058_LDO_2,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO2_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.boot_on = 1,
+};
+
+static struct da9058_regulator_pdata ldo3_pdata = {
+	.regulator_name = "DA9058_LDO3",
+	.regulator_id = DA9058_LDO_3,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO3_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.boot_on = 1,
+};
+
+static struct da9058_regulator_pdata ldo4_pdata = {
+	.regulator_name = "DA9058_LDO4",
+	.regulator_id = DA9058_LDO_4,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO4_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.boot_on = 1,
+};
+
+static struct da9058_regulator_pdata ldo5_pdata = {
+	.regulator_name = "DA9058_LDO5",
+	.regulator_id = DA9058_LDO_5,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO5_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.boot_on = 1,
+};
+
+static struct da9058_regulator_pdata ldo6_pdata = {
+	.regulator_name = "DA9058_LDO6",
+	.regulator_id = DA9058_LDO_6,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO6_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+static struct da9058_regulator_pdata ldo7_pdata = {
+	.regulator_name = "DA9058_LDO7",
+	.regulator_id = DA9058_LDO_7,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO7_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.boot_on = 1,
+};
+
+static struct da9058_regulator_pdata ldo8_pdata = {
+	.regulator_name = "DA9058_LDO8",
+	.regulator_id = DA9058_LDO_8,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO8_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.boot_on = 1,
+};
+
+static struct da9058_regulator_pdata ldo9_pdata = {
+	.regulator_name = "DA9058_LDO9",
+	.regulator_id = DA9058_LDO_9,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO9_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+static struct da9058_regulator_pdata ldo10_pdata = {
+	.regulator_name = "DA9058_LDO10",
+	.regulator_id = DA9058_LDO_10,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO10_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.boot_on = 1,
+};
+
+static struct da9058_regulator_pdata ldo12_pdata = {
+	.regulator_name = "DA9058_LDO12",
+	.regulator_id = DA9058_LDO_12,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO12_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+	.boot_on = 1,
+};
+
+static struct da9058_regulator_pdata ldo13_pdata = {
+	.regulator_name = "DA9058_LDO13",
+	.regulator_id = DA9058_LDO_13,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO13_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+static struct da9058_regulator_pdata ldo14_pdata = {
+	.regulator_name = "DA9058_LDO14",
+	.regulator_id = DA9058_LDO_14,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO14_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+static struct da9058_regulator_pdata ldo16_pdata = {
+	.regulator_name = "DA9058_LDO16",
+	.regulator_id = DA9058_LDO_16,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO16_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+static struct da9058_regulator_pdata ldo17_pdata = {
+	.regulator_name = "DA9058_LDO17",
+	.regulator_id = DA9058_LDO_17,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO17_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+static struct da9058_regulator_pdata ldo18_pdata = {
+	.regulator_name = "DA9058_LDO18",
+	.regulator_id = DA9058_LDO_18,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO18_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+static struct da9058_regulator_pdata ldo19_pdata = {
+	.regulator_name = "DA9058_LDO19",
+	.regulator_id = DA9058_LDO_19,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_voltage_step = DA9058_LDO_VOLT_STEP,
+	.control_register = DA9058_LDO19_REG,
+	.control_enable_mask = DA9058_BUCK_LDO_EN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+static struct da9058_regulator_pdata ldoAUD1_pdata = {
+	.regulator_name = "DA9058_AUD1",
+	.regulator_id = DA9058_LDO_AUD1,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.control_register = DA9058_SUPPLY_REG,
+	.control_enable_mask = DA9058_SUPPLY_LDO15AEN,
+	.fixed_voltage = 1600,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+static struct da9058_regulator_pdata ldoAUD2_pdata = {
+	.regulator_name = "DA9058_AUD2",
+	.regulator_id = DA9058_LDO_AUD2,
+	.min_uV = DA9058_LDO_VOLT_LOWER * 1000,
+	.max_uV = DA9058_LDO_VOLT_UPPER * 1000,
+	.fixed_voltage = 3300,
+	.control_register = DA9058_SUPPLY_REG,
+	.control_enable_mask = DA9058_SUPPLY_LDO15BEN,
+	.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_STATUS,
+	.valid_modes_mask = REGULATOR_MODE_NORMAL,
+};
+
+static const struct resource da9058_gpio_resources[] = {
+	{
+		.name = "gpio0",
+		.start = DA9058_IRQ_EGPI0,
+		.end = DA9058_IRQ_EGPI0,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "gpio1",
+		.start = DA9058_IRQ_EGPI1,
+		.end = DA9058_IRQ_EGPI1,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static const struct resource da9058_rtc_resources[] = {
+	{
+		.name = "alarm",
+		.start = DA9058_IRQ_EALRAM,
+		.end = DA9058_IRQ_EALRAM,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "tick",
+		.start = DA9058_IRQ_ETICK,
+		.end = DA9058_IRQ_ETICK,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static const struct resource da9058_onkey_resources[] = {
+	{
+		.name = "keydown",
+		.start = DA9058_IRQ_ENONKEY,
+		.end = DA9058_IRQ_ENONKEY,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static const struct resource da9058_adc_resources[] = {
+	{
+		.name = "adc",
+		.start = DA9058_IRQ_EADCEOM,
+		.end = DA9058_IRQ_EADCEOM,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static const struct resource da9058_codec_resources[] = {
+	{
+		.name = "codec",
+		.start = DA9058_IRQ_EAUDIO,
+		.end = DA9058_IRQ_EAUDIO,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct da9058_gpio_pdata gpio_pdata = {
+
+		.ngpio = ARRAY_SIZE(da9058_gpio_resources),
+		.gpio_base = -1,
+};
+
+static struct da9058_hwmon_pdata hwmon_pdata = {
+};
+
+static struct da9058_rtc_pdata rtc_pdata = {
+};
+
+static struct da9058_onkey_pdata onkey_pdata = {
+};
+
+static struct da9058_power_pdata power_pdata = {
+};
+
+static struct da9058_adc_pdata adc_pdata = {
+};
+
+static struct da9058_codec_pdata codec_pdata = {
+	.i2c_addr = 0x9A,
+	.amplifier_initially_on = 0,
+	.amp_control_reg = DA9058_AUDIO_CONF2_REG_B,
+	.amp_enable_mask = DA9058_AUDIOCONF_CLASSDEN,
+};
+
+static struct mfd_cell da9058_devices[] = {
+	{
+		.name = "da9058-adc",
+		.id = -1,
+		.platform_data = &adc_pdata,
+		.num_resources = ARRAY_SIZE(da9058_adc_resources),
+		.resources = da9058_adc_resources,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_BUCK_1,
+		.platform_data = &buck1_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_BUCK_2,
+		.platform_data = &buck2_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_BUCK_3,
+		.platform_data = &buck3_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_BUCK_4,
+		.platform_data = &buck4_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_1,
+		.platform_data = &ldo1_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_2,
+		.platform_data = &ldo2_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_3,
+		.platform_data = &ldo3_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_4,
+		.platform_data = &ldo4_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_5,
+		.platform_data = &ldo5_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_6,
+		.platform_data = &ldo6_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_7,
+		.platform_data = &ldo7_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_8,
+		.platform_data = &ldo8_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_9,
+		.platform_data = &ldo9_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_10,
+		.platform_data = &ldo10_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_12,
+		.platform_data = &ldo12_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_13,
+		.platform_data = &ldo13_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_14,
+		.platform_data = &ldo14_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_16,
+		.platform_data = &ldo16_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_17,
+		.platform_data = &ldo17_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_18,
+		.platform_data = &ldo18_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_19,
+		.platform_data = &ldo19_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_AUD1,
+		.platform_data = &ldoAUD1_pdata,
+	},
+	{
+		.name = "da9058-regulator",
+		.id = DA9058_LDO_AUD2,
+		.platform_data = &ldoAUD2_pdata,
+	},
+	{
+		.name = "da9058-hwmon",
+		.id = -1,
+		.platform_data = &hwmon_pdata,
+	},
+	{
+		.name = "da9058-gpio",
+		.id = -1,
+		.platform_data = &gpio_pdata,
+		.num_resources = ARRAY_SIZE(da9058_gpio_resources),
+		.resources = da9058_gpio_resources,
+	},
+	{
+		.name = "da9058-rtc",
+		.id = -1,
+		.platform_data = &rtc_pdata,
+		.num_resources = ARRAY_SIZE(da9058_rtc_resources),
+		.resources = da9058_rtc_resources,
+	},
+	{
+		.name = "da9058-onkey",
+		.id = -1,
+		.platform_data = &onkey_pdata,
+		.num_resources = ARRAY_SIZE(da9058_onkey_resources),
+		.resources = da9058_onkey_resources,
+	},
+	{
+		.name = "da9058-power",
+		.id = -1,
+		.platform_data = &power_pdata,
+	},
+	{
+		.name = "da9058-codec",
+		.id = -1,
+		.platform_data = &codec_pdata,
+		.num_resources = ARRAY_SIZE(da9058_codec_resources),
+		.resources = da9058_codec_resources,
+	},
+};
+
+#define DA9058_INT_OFFSET_1			0
+#define DA9058_INT_OFFSET_2			1
+#define DA9058_INT_OFFSET_3			2
+#define DA9058_INT_OFFSET_4			3
+
+static struct regmap_irq da9058_irqs[DA9058_NUM_IRQ] = {
+	/* EVENT Register A start */
+	[DA9058_IRQ_EALRAM] = {
+				.reg_offset = DA9058_INT_OFFSET_1,
+				.mask = DA9058_IRQMASKA_MALRAM,
+	},
+	[DA9058_IRQ_ESEQRDY] = {
+				.reg_offset = DA9058_INT_OFFSET_1,
+				.mask = DA9058_IRQMASKA_MSEQRDY,
+	},
+	[DA9058_IRQ_ETICK] = {
+				.reg_offset = DA9058_INT_OFFSET_1,
+				.mask = DA9058_IRQMASKA_MTICK,
+	},
+	/* EVENT Register B start */
+	[DA9058_IRQ_ENONKEY] = {
+				.reg_offset = DA9058_INT_OFFSET_2,
+				.mask = DA9058_IRQMASKB_MNONKEY,
+	},
+	[DA9058_IRQ_EADCEOM] = {
+				.reg_offset = DA9058_INT_OFFSET_2,
+				.mask = DA9058_IRQMASKB_MADCEOM,
+	},
+	/* EVENT Register C start */
+	[DA9058_IRQ_EGPI0] = {
+				.reg_offset = DA9058_INT_OFFSET_3,
+				.mask = DA9058_IRQMASKC_MGPI0,
+	},
+	[DA9058_IRQ_EGPI1] = {
+				.reg_offset = DA9058_INT_OFFSET_3,
+				.mask = DA9058_IRQMASKC_MGPI1,
+	},
+	[DA9058_IRQ_EAUDIO] = {
+				.reg_offset = DA9058_INT_OFFSET_3,
+				.mask = DA9058_IRQMASKC_MAUDIO,
+	},
+	/* EVENT Register D start */
+	[DA9058_IRQ_EGPI2] = {
+				.reg_offset = DA9058_INT_OFFSET_4,
+				.mask = DA9058_IRQMASKD_MGPI2,
+	},
+	[DA9058_IRQ_EGPI3] = {
+				.reg_offset = DA9058_INT_OFFSET_4,
+				.mask = DA9058_IRQMASKD_MGPI3,
+	},
+	[DA9058_IRQ_EGPI4] = {
+				.reg_offset = DA9058_INT_OFFSET_4,
+				.mask = DA9058_IRQMASKD_MGPI4,
+	},
+	[DA9058_IRQ_EGPI5] = {
+				.reg_offset = DA9058_INT_OFFSET_4,
+				.mask = DA9058_IRQMASKD_MGPI5,
+	},
+};
+
+struct regmap_irq_chip da9058_irq_chip = {
+	.name = "da9058",
+	.irqs = da9058_irqs,
+	.num_irqs = ARRAY_SIZE(da9058_irqs),
+
+	.num_regs = 4,
+	.status_base = DA9058_EVENTA_REG,
+	.mask_base = DA9058_IRQMASKA_REG,
+	.ack_base = DA9058_EVENTA_REG,
+};
+EXPORT_SYMBOL_GPL(da9058_irq_chip);
+
+int __devinit da9058_add_mfd_devices(struct da9058 *da9058,
+					struct da9058_chip_pdata *pdata,
+					struct i2c_adapter *adapter)
+{
+
+	if (pdata->battery_type && pdata->lookup_tables &&
+					pdata->temp_adc_resistance) {
+		power_pdata.battery_type = pdata->battery_type;
+		power_pdata.bat_low_limit = pdata->bat_low_limit;
+		power_pdata.use_automatic_adc = pdata->use_automatic_adc;
+		power_pdata.lookup_tables = pdata->lookup_tables;
+	} else {
+		dev_warn(da9058->dev, "battery power monitor diabled\n");
+	}
+
+	adc_pdata.use_automatic_adc = pdata->use_automatic_adc;
+	hwmon_pdata.use_automatic_adc = pdata->use_automatic_adc;
+	hwmon_pdata.temp_adc_resistance = pdata->temp_adc_resistance;
+	hwmon_pdata.vf_adc_resistance = pdata->vf_adc_resistance;
+	hwmon_pdata.init_hwmon_platform_callback =
+					pdata->init_hwmon_platform_callback;
+	hwmon_pdata.exit_hwmon_platform_callback =
+					pdata->exit_hwmon_platform_callback;
+	codec_pdata.i2c_adapter = adapter;
+
+	return mfd_add_devices(da9058->dev, 0, da9058_devices,
+				ARRAY_SIZE(da9058_devices), NULL,
+				regmap_irq_chip_get_base(da9058->irq_data));
+}
+EXPORT_SYMBOL_GPL(da9058_add_mfd_devices);
diff --git a/drivers/mfd/da9058-irq.c b/drivers/mfd/da9058-irq.c
new file mode 100644
index 0000000..4516a41
--- /dev/null
+++ b/drivers/mfd/da9058-irq.c
@@ -0,0 +1,56 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/regmap.h>
+
+#include <linux/mfd/da9058/core.h>
+#include <linux/mfd/da9058/pdata.h>
+#include <linux/mfd/da9058/conf.h>
+
+int __devinit da9058_irq_init(struct da9058 *da9058, int irq,
+				struct regmap_irq_chip *irq_chip)
+{
+	int ret;
+
+	da9058->chip_irq = irq;
+
+	if (!da9058->chip_irq) {
+		dev_err(da9058->dev, "No IRQ configured\n");
+		return -EINVAL;
+	}
+	if (!irq_chip) {
+		dev_err(da9058->dev, "No chip interrupt data specified\n");
+		return 0;
+	}
+
+	ret = regmap_add_irq_chip(da9058->regmap, da9058->chip_irq,
+					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					-1, irq_chip, &da9058->irq_data);
+	if (ret) {
+		dev_err(da9058->dev, "Failed to register IRQ chip: %d\n", ret);
+		return ret;
+	}
+
+	da9058->irq_base = regmap_irq_chip_get_base(da9058->irq_data);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(da9058_irq_init);
+
+int da9058_irq_exit(struct da9058 *da9058)
+{
+	regmap_del_irq_chip(da9058->chip_irq, da9058->irq_data);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(da9058_irq_exit);
diff --git a/include/linux/mfd/da9058/bat.h b/include/linux/mfd/da9058/bat.h
new file mode 100644
index 0000000..71ebb56
--- /dev/null
+++ b/include/linux/mfd/da9058/bat.h
@@ -0,0 +1,33 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __D1982_BAT_H
+#define __D1982_BAT_H
+
+#define DA9058_LOOK_UP_TABLE_SIZE		68
+
+struct da9058_temp_capacity {
+	int temperature;
+	u32 capacity[DA9058_LOOK_UP_TABLE_SIZE][2];
+};
+
+struct da9058_power_table {
+	int temperature_points;
+	struct da9058_temp_capacity (*temp_tables)[];
+};
+
+struct da9058_power_pdata {
+	int battery_type;
+	int bat_low_limit;
+	int use_automatic_adc;
+	struct da9058_power_table *lookup_tables;
+};
+
+#endif /* __D1982_BAT_H */
diff --git a/include/linux/mfd/da9058/codec.h b/include/linux/mfd/da9058/codec.h
new file mode 100644
index 0000000..dd0d479
--- /dev/null
+++ b/include/linux/mfd/da9058/codec.h
@@ -0,0 +1,22 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __DA9058_CODEC_H
+#define __DA9058_CODEC_H
+
+struct da9058_codec_pdata {
+	int i2c_addr;
+	struct i2c_adapter *i2c_adapter;
+	int amplifier_initially_on;
+	int amp_control_reg;
+	int amp_enable_mask;
+};
+
+#endif /* __DA9058_CODEC_H */
diff --git a/include/linux/mfd/da9058/conf.h b/include/linux/mfd/da9058/conf.h
new file mode 100644
index 0000000..4c87e5e
--- /dev/null
+++ b/include/linux/mfd/da9058/conf.h
@@ -0,0 +1,22 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __DA9058_CONF_H
+#define __DA9058_CONF_H
+
+extern struct regmap_irq_chip da9058_irq_chip;
+extern int da9058_irq_init(struct da9058 *da9058, int irq,
+			struct regmap_irq_chip *da9058_irq_chip) __devinit;
+extern int da9058_irq_exit(struct da9058 *da9058);
+extern int da9058_add_mfd_devices(struct da9058 *da9058,
+			struct da9058_chip_pdata *pdata,
+			struct i2c_adapter *adapter) __devinit;
+
+#endif /* __DA9058_CONF_H */
diff --git a/include/linux/mfd/da9058/core.h b/include/linux/mfd/da9058/core.h
new file mode 100644
index 0000000..87e1246
--- /dev/null
+++ b/include/linux/mfd/da9058/core.h
@@ -0,0 +1,66 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __DA9058_CORE_H
+#define __DA9058_CORE_H
+
+#define DA9058_ADC_VBAT		0
+#define DA9058_ADC_TEMP		2
+#define DA9058_ADC_VF		4
+#define DA9058_ADC_ADCIN	5
+#define DA9058_ADC_TJUNC	8
+
+struct da9058;
+
+struct da9058 {
+	struct device *dev;
+	struct regmap *regmap;
+
+	int chip_irq;
+	int irq_base;
+
+	struct regmap_irq_chip_data *irq_data;
+
+	struct mutex adc_mutex;
+	struct completion adc_read_done;
+	int (*adc_read)(struct da9058 *da9058, const int channel,
+				int automatic_mode, int *value);
+};
+
+/*
+ * da9058 device IO
+ */
+#define da9058_set_bits(da9058, reg, mask) \
+	regmap_update_bits(da9058->regmap, reg, mask, 0xFF)
+#define da9058_clear_bits(da9058, reg, mask) \
+	regmap_update_bits(da9058->regmap, reg, mask, 0x00)
+#define da9058_update_bits(da9058, reg, mask, pval) \
+	regmap_update_bits(da9058->regmap, reg, mask, pval)
+
+#define da9058_bulk_read(da9058, reg, pval, count) \
+	 regmap_bulk_read(da9058->regmap, reg, pval, count)
+#define da9058_bulk_write(da9058, reg, pval, count) \
+	regmap_bulk_write(da9058->regmap, reg, pval, count)
+
+#define da9058_reg_read(da9058, reg, pval) \
+	regmap_read(da9058->regmap, reg, pval)
+#define da9058_reg_write(da9058, reg, val) \
+	regmap_write(da9058->regmap, reg, val)
+static inline int da9058_adc_read(struct da9058 *da9058, const int channel,
+					int automatic_mode, int *value)
+{
+	if (da9058->adc_read == NULL)
+		return -ENODEV;
+	else
+		return da9058->adc_read(da9058, channel,
+					automatic_mode, value);
+}
+
+#endif /* __DA9058_CORE_H */
diff --git a/include/linux/mfd/da9058/gpio.h b/include/linux/mfd/da9058/gpio.h
new file mode 100644
index 0000000..b61eee7
--- /dev/null
+++ b/include/linux/mfd/da9058/gpio.h
@@ -0,0 +1,19 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __D1982_GPIO_H
+#define __D1982_GPIO_H
+
+struct da9058_gpio_pdata {
+	int ngpio;
+	int gpio_base;
+};
+
+#endif /* __D1982_GPIO_H */
diff --git a/include/linux/mfd/da9058/hwmon.h b/include/linux/mfd/da9058/hwmon.h
new file mode 100644
index 0000000..1055857
--- /dev/null
+++ b/include/linux/mfd/da9058/hwmon.h
@@ -0,0 +1,36 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __DA9058_HWMON_H
+#define __DA9058_HWMON_H
+
+struct da9058_hwmon;
+struct da9058_hwmon {
+	struct da9058	*da9058;
+	struct platform_device *pdev;
+
+	struct device	*class_device;
+	struct mutex	hwmon_lock;
+	int use_automatic_adc;
+	int temp_adc_resistance;
+	int vf_adc_resistance;
+	void (*exit_hwmon_platform_callback)(struct da9058_hwmon *hwmon);
+	void (*init_hwmon_platform_callback)(struct da9058_hwmon *hwmon);
+};
+
+struct da9058_hwmon_pdata {
+	int use_automatic_adc;
+	int temp_adc_resistance;
+	int vf_adc_resistance;
+	void (*init_hwmon_platform_callback)(struct da9058_hwmon *hwmon);
+	void (*exit_hwmon_platform_callback)(struct da9058_hwmon *hwmon);
+};
+
+#endif /* __DA9058_HWMON_H */
diff --git a/include/linux/mfd/da9058/i2c.h b/include/linux/mfd/da9058/i2c.h
new file mode 100644
index 0000000..649cc56
--- /dev/null
+++ b/include/linux/mfd/da9058/i2c.h
@@ -0,0 +1,22 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __DA9058_I2C_H
+#define __DA9058_I2C_H
+
+struct da9058;
+struct da9058_chip_pdata;
+extern struct da9058 *da9058_device_init(struct device *dev,
+				struct regmap *regmap, void *adapter, int irq,
+				struct da9058_chip_pdata *pdata) __devinit;
+extern int da9058_device_exit(struct da9058 *da9058);
+extern struct regmap_config da9058_regmap_config;
+
+#endif /* __DA9058_I2C_H */
diff --git a/include/linux/mfd/da9058/irq.h b/include/linux/mfd/da9058/irq.h
new file mode 100644
index 0000000..9ceece3
--- /dev/null
+++ b/include/linux/mfd/da9058/irq.h
@@ -0,0 +1,50 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __DA9058_IRQ_H
+#define __DA9058_IRQ_H
+
+enum {
+
+DA9058_IRQ_EALRAM,
+DA9058_IRQ_ESEQRDY,
+DA9058_IRQ_ETICK,
+
+DA9058_IRQ_ENONKEY,
+DA9058_IRQ_EADCEOM,
+
+DA9058_IRQ_EGPI0,
+DA9058_IRQ_EGPI1,
+DA9058_IRQ_EAUDIO,
+
+DA9058_IRQ_EGPI2,
+DA9058_IRQ_EGPI3,
+DA9058_IRQ_EGPI4,
+DA9058_IRQ_EGPI5,
+
+DA9058_NUM_IRQ
+};
+
+/*
+ *  da9058 virtual threaded interrupts
+ *  the MFD component drivers or users of those drivers
+ *  (in the case of GPIOs) will call:
+ *  request_threaded_irq() and free_irq() directly using
+ *  the actual virtual threaded IRQ number which can be
+ *  obtained from the DA9058 PMIC relative (soft) IRQ number
+ */
+static inline int da9058_to_virt_irq_num(struct da9058 *da9058, int irq)
+{
+	if (!da9058->irq_data)
+		return -EINVAL;
+	return regmap_irq_get_virq(da9058->irq_data, irq);
+}
+
+#endif /* __DA9058_IRQ_H */
diff --git a/include/linux/mfd/da9058/onkey.h b/include/linux/mfd/da9058/onkey.h
new file mode 100644
index 0000000..8b95117
--- /dev/null
+++ b/include/linux/mfd/da9058/onkey.h
@@ -0,0 +1,17 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __DA9058_ONKEY_H
+#define __DA9058_ONKEY_H
+
+struct da9058_onkey_pdata {
+};
+
+#endif /* __DA9058_ONKEY_H */
diff --git a/include/linux/mfd/da9058/pdata.h b/include/linux/mfd/da9058/pdata.h
new file mode 100644
index 0000000..dc7bf27
--- /dev/null
+++ b/include/linux/mfd/da9058/pdata.h
@@ -0,0 +1,32 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __DA9058_PDATA_H
+#define __DA9058_PDATA_H
+
+struct da9058_hwmon;
+/*
+ *  This is the Platform Data for the DA9058 PMIC chip as a whole.
+ */
+struct da9058_chip_pdata {
+	int (*init_board_irq)(void);
+	void (*init_hwmon_platform_callback)(struct da9058_hwmon *hwmon);
+	void (*exit_hwmon_platform_callback)(struct da9058_hwmon *hwmon);
+	char *platform_description;
+	struct i2c_adapter *i2c_adapter;
+	int battery_type;
+	int bat_low_limit;
+	int use_automatic_adc;
+	int temp_adc_resistance;
+	int vf_adc_resistance;
+	struct da9058_power_table *lookup_tables;
+};
+
+#endif /* __DA9058_PDATA_H */
diff --git a/include/linux/mfd/da9058/registers.h b/include/linux/mfd/da9058/registers.h
new file mode 100644
index 0000000..ae3deb5
--- /dev/null
+++ b/include/linux/mfd/da9058/registers.h
@@ -0,0 +1,480 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __DA9058_REGISTERS_H
+#define __DA9058_REGISTERS_H
+
+#define DA9058_PAGECON0_REG			0
+#define DA9058_STATUSA_REG			1
+#define DA9058_STATUSB_REG			2
+#define DA9058_STATUSC_REG			3
+#define DA9058_STATUSD_REG			4
+#define DA9058_EVENTA_REG			5
+#define DA9058_EVENTB_REG			6
+#define DA9058_EVENTC_REG			7
+#define DA9058_EVENTD_REG			8
+#define DA9058_FAULTLOG_REG			9
+#define DA9058_IRQMASKA_REG			10
+#define DA9058_IRQMASKB_REG			11
+#define DA9058_IRQMASKC_REG			12
+#define DA9058_IRQMASKD_REG			13
+#define DA9058_CONTROLA_REG			14
+#define DA9058_CONTROLB_REG			15
+#define DA9058_CONTROLC_REG			16
+#define DA9058_CONTROLD_REG			17
+#define DA9058_PDDIS_REG			18
+#define DA9058_INTERFACE_REG			19
+#define DA9058_RESET_REG			20
+#define DA9058_GPIO0001_REG			21
+
+#define DA9058_GPIO0203_REG			25
+#define DA9058_GPIO0405_REG			27
+
+#define DA9058_ID01_REG				29
+#define DA9058_ID23_REG				30
+#define DA9058_ID45_REG				31
+#define DA9058_ID67_REG				32
+#define DA9058_ID89_REG				33
+#define DA9058_ID1011_REG			34
+#define DA9058_ID1213_REG			35
+#define DA9058_ID1415_REG			36
+#define DA9058_ID1617_REG			37
+
+#define DA9058_SEQSTATUS_REG			40
+#define DA9058_SEQA_REG				41
+#define DA9058_SEQB_REG				42
+#define DA9058_SEQTIMER_REG			43
+#define DA9058_BUCKA_REG			44
+#define DA9058_BUCKB_REG			45
+#define DA9058_BUCK1_REG			46
+#define DA9058_BUCK2_REG			47
+#define DA9058_BUCK3_REG			48
+#define DA9058_BUCK4_REG			49
+#define DA9058_LDO1_REG				50
+#define DA9058_LDO2_REG				51
+#define DA9058_LDO3_REG				52
+#define DA9058_LDO4_REG				53
+#define DA9058_LDO5_REG				54
+#define DA9058_LDO6_REG				55
+#define DA9058_LDO7_REG				56
+#define DA9058_LDO8_REG				57
+#define DA9058_LDO9_REG				58
+#define DA9058_LDO10_REG			59
+#define DA9058_LDO12_REG			60
+#define DA9058_LDO13_REG			61
+#define DA9058_PULLDOWN_REG_A			62
+#define DA9058_PULLDOWN_REG_B			63
+#define DA9058_PULLDOWN_REG_C			64
+#define DA9058_LDO14_REG			65
+#define DA9058_LDO16_REG			66
+#define DA9058_LDO17_REG			67
+#define DA9058_LDO18_REG			68
+#define DA9058_LDO19_REG			69
+#define DA9058_SUPPLY_REG			70
+#define DA9058_WAITCONT_REG			71
+#define DA9058_ONKEYCONT_REG			72
+#define DA9058_POWERCONT_REG			73
+#define DA9058_AUDIO_CONF1_REG			74
+#define DA9058_AUDIO_CONF2_REG_A		75
+#define DA9058_AUDIO_CONF2_REG_B		76
+#define DA9058_BBATCONT_REG			77
+
+#define DA9058_ADCMAN_REG			81
+#define DA9058_ADCCONT_REG			82
+#define DA9058_ADCRESL_REG			83
+#define DA9058_ADCRESH_REG			84
+#define DA9058_VBATRES_REG_MSB			85
+
+#define DA9058_TEMPRES_REG_MSB			90
+
+#define DA9058_TOFFSET_REG			94
+#define DA9058_VREF_REG				95
+
+#define DA9058_ADCINRES_REG_MSB			98
+
+#define DA9058_TJUNCRES_REG			104
+#define DA9058_AUTORES_REG_1			105
+#define DA9058_AUTORES_REG_2			106
+#define DA9058_AUTORES_REG_3			107
+
+#define DA9058_COUNTS_REG			111
+#define DA9058_COUNTMI_REG			112
+#define DA9058_COUNTH_REG			113
+#define DA9058_COUNTD_REG			114
+#define DA9058_COUNTMO_REG			115
+#define DA9058_COUNTY_REG			116
+#define DA9058_ALARMS_REG			117
+#define DA9058_ALARMMI_REG			118
+#define DA9058_ALARMH_REG			119
+#define DA9058_ALARMD_REG			120
+#define DA9058_ALARMMO_REG			121
+#define DA9058_ALARMY_REG			122
+
+#define DA9058_PAGECON1_REG			128
+#define DA9058_CHIPID_REG			129
+#define DA9058_CONFIGID_REG			130
+#define DA9058_OTPCONT_REG			131
+#define DA9058_OSCTRIM_REG			132
+#define DA9058_GPID0_REG			133
+#define DA9058_GPID1_REG			134
+#define DA9058_GPID2_REG			135
+#define DA9058_GPID3_REG			136
+#define DA9058_GPID4_REG			137
+#define DA9058_GPID5_REG			138
+#define DA9058_GPID6_REG			139
+#define DA9058_GPID7_REG			140
+#define DA9058_GPID8_REG			141
+#define DA9058_GPID9_REG			142
+
+#define DA9058_PAGE0_REG_START			DA9058_STATUSA_REG
+#define DA9058_PAGE0_REG_END			DA9058_ALARMY_REG
+#define DA9058_PAGE1_REG_START			DA9058_CHIPID_REG
+#define DA9058_PAGE1_REG_END			DA9058_GPID9_REG
+#define DA9058_MAX_REGISTER_CNT			DA9058_PAGE1_REG_END
+
+/* STATUS REGISTER A */
+#define DA9058_STATUSA_NONKEY			(1<<0)
+/* STATUS REGISTER B */
+#define DA9058_STATUSB_SEQUENCING		(1<<6)
+/* STATUS REGISTER C */
+#define DA9058_STATUSC_INT_IN			(1<<2)
+#define DA9058_STATUSC_GPI1			(1<<1)
+#define DA9058_STATUSC_GPI0			(1<<0)
+/* STATUS REGISTER D */
+#define DA9058_STATUSD_GPI5			(1<<5)
+#define DA9058_STATUSD_GPI4			(1<<4)
+#define DA9058_STATUSD_GPI3			(1<<3)
+#define DA9058_STATUSD_GPI2			(1<<0)
+/* EVENT REGISTER A */
+#define DA9058_EVENTA_ETICK			(1<<7)
+#define DA9058_EVENTA_ESEQRDY			(1<<6)
+#define DA9058_EVENTA_EALRAM			(1<<5)
+/* EVENT REGISTER B */
+#define DA9058_EVENTB_EADCEOM			(1<<5)
+#define DA9058_EVENTB_ENONKEY			(1<<0)
+/* EVENT REGISTER C */
+#define DA9058_EVENTC_EAUDIO			(1<<2)
+#define DA9058_EVENTC_EGPI1			(1<<1)
+#define DA9058_EVENTC_EGPI0			(1<<0)
+/* EVENT REGISTER D */
+#define DA9058_EVENTC_EGPI5			(1<<5)
+#define DA9058_EVENTC_EGPI4			(1<<4)
+#define DA9058_EVENTC_EGPI3			(1<<3)
+#define DA9058_EVENTC_EGPI2			(1<<0)
+/* FAULT LOG REGISTER */
+#define DA9058_FAULTLOG_WAITSET			(1<<7)
+#define DA9058_FAULTLOG_KEYSHUT			(1<<5)
+#define DA9058_FAULTLOG_TEMPOVER		(1<<3)
+#define DA9058_FAULTLOG_VDDSTART		(1<<2)
+#define DA9058_FAULTLOG_VDDFAULT		(1<<1)
+#define DA9058_FAULTLOG_TWDERROR		(1<<0)
+/* IRQ_MASK REGISTER A */
+#define DA9058_IRQMASKA_MTICK			(1<<7)
+#define DA9058_IRQMASKA_MSEQRDY			(1<<6)
+#define DA9058_IRQMASKA_MALRAM			(1<<5)
+#define DA9058_IRQMASKA_BIT4			(1<<4)
+/* IRQ_MASK REGISTER B */
+#define DA9058_IRQMASKB_MADCEOM			(1<<5)
+#define DA9058_IRQMASKB_BIT4			(1<<4)
+#define DA9058_IRQMASKB_MNONKEY			(1<<0)
+/* IRQ_MASK REGISTER C */
+#define DA9058_IRQMASKC_MAUDIO			(1<<2)
+#define DA9058_IRQMASKC_MGPI1			(1<<1)
+#define DA9058_IRQMASKC_MGPI0			(1<<0)
+/* IRQ_MASK REGISTER D */
+#define DA9058_IRQMASKD_MGPI5			(1<<5)
+#define DA9058_IRQMASKD_MGPI4			(1<<4)
+#define DA9058_IRQMASKD_MGPI3			(1<<3)
+#define DA9058_IRQMASKD_MGPI2			(1<<0)
+/* CONTROL REGISTER A */
+#define DA9058_CONTROLA_GPIV			(1<<7)
+#define DA9058_CONTROLA_PMOTYPE			(1<<5)
+#define DA9058_CONTROLA_PMOPU			(1<<4)
+#define DA9058_CONTROLA_PMIV			(1<<3)
+#define DA9058_CONTROLA_PMIFV			(1<<3)
+#define DA9058_CONTROLA_PWR1EN			(1<<2)
+#define DA9058_CONTROLA_PWREN			(1<<1)
+#define DA9058_CONTROLA_SYSEN			(1<<0)
+/* CONTROL REGISTER B */
+#define DA9058_CONTROLB_SHUTDOWN		(1<<7)
+#define DA9058_CONTROLB_DEEPSLEEP		(1<<6)
+#define DA9058_CONTROLB_WRITEMODE		(1<<5)
+#define DA9058_CONTROLB_I2C1_SPEED		(1<<4)
+#define DA9058_CONTROLB_OTPREADEN		(1<<3)
+#define DA9058_CONTROLB_AUTOBOOT		(1<<2)
+/* CONTROL REGISTER C */
+#define DA9058_CONTROLC_DEBOUNCING		(7<<2)
+#define DA9058_CONTROLC_PMFBPIN			(1<<0)
+/* CONTROL REGISTER D */
+#define DA9058_CONTROLD_WATCHDOG		(1<<7)
+#define DA9058_CONTROLD_KEEPACTEN		(1<<3)
+#define DA9058_CONTROLD_TWDSCALE		(7<<0)
+/* POWER DOWN DISABLE REGISTER */
+#define DA9058_PDDIS_PMCONTPD			(1<<7)
+#define DA9058_PDDIS_OUT32KPD			(1<<6)
+#define DA9058_PDDIS_CHGBBATPD			(1<<5)
+#define DA9058_PDDIS_HSIFPD			(1<<3)
+#define DA9058_PDDIS_PMIFPD			(1<<2)
+#define DA9058_PDDIS_GPADCPD			(1<<1)
+#define DA9058_PDDIS_GPIOPD			(1<<0)
+/* INTERFACE REGISTER */
+#define DA9058_INTERFACE_IFBASEADDR		(7<<5)
+/* RESET REGISTER */
+#define DA9058_RESET_RESETEVENT			(3<<6)
+#define DA9058_RESET_RESETTIMER			(63<<0)
+/* GPIO control register for PIN 0 and 1 */
+#define DA9058_GPIO01_GPIO1MODE			(1<<7)
+#define DA9058_GPIO01_GPIO1TYPE			(1<<6)
+#define DA9058_GPIO01_GPIO1PIN			(3<<4)
+#define DA9058_GPIO01_GPIO0MODE			(1<<3)
+#define DA9058_GPIO01_GPIO0TYPE			(1<<2)
+#define DA9058_GPIO01_GPIO0PIN			(3<<0)
+/* GPIO control register for PIN 2 and 3 */
+#define DA9058_GPIO23_GPIO3MODE			(1<<7)
+#define DA9058_GPIO23_GPIO3TYPE			(1<<6)
+#define DA9058_GPIO23_GPIO3PIN			(3<<4)
+#define DA9058_GPIO23_GPIO2MODE			(1<<3)
+#define DA9058_GPIO23_GPIO2TYPE			(1<<2)
+#define DA9058_GPIO23_GPIO2PIN			(3<<0)
+/* GPIO control register for PIN 4 and 5 */
+#define DA9058_GPIO45_GPIO5MODE			(1<<7)
+#define DA9058_GPIO45_GPIO5TYPE			(1<<6)
+#define DA9058_GPIO45_GPIO5PIN			(3<<4)
+#define DA9058_GPIO45_GPIO4MODE			(1<<3)
+#define DA9058_GPIO45_GPIO4TYPE			(1<<2)
+#define DA9058_GPIO45_GPIO4PIN			(3<<0)
+/* BUCK and LDO fields */
+#define DA9058_BUCK_LDO_EN			(1<<6)
+#define DA9058_MAX_VSEL				0x3F
+/* SEQ control register for ID 0 and 1 */
+#define DA9058_ID01_LDO1STEP			(15<<4)
+#define DA9058_ID01_WAITIDALWAYS		(1<<2)
+#define DA9058_ID01_SYSPRE			(1<<2)
+#define DA9058_ID01_DEFSUPPLY			(1<<1)
+#define DA9058_ID01_nRESMODE			(1<<0)
+/* SEQ control register for ID 2 and 3 */
+#define DA9058_ID23_LDO3STEP			(15<<4)
+#define DA9058_ID23_LDO2STEP			(15<<0)
+/* SEQ control register for ID 4 and 5 */
+#define DA9058_ID45_LDO5STEP			(15<<4)
+#define DA9058_ID45_LDO4STEP			(15<<0)
+/* SEQ control register for ID 6 and 7 */
+#define DA9058_ID67_LDO7STEP			(15<<4)
+#define DA9058_ID67_LDO6STEP			(15<<0)
+/* SEQ control register for ID 8 and 9 */
+#define DA9058_ID89_LDO9STEP			(15<<4)
+#define DA9058_ID89_LDO8STEP			(15<<0)
+/* SEQ control register for ID 10 and 11 */
+#define DA9058_ID1011_PDDISSTEP			(15<<4)
+#define DA9058_ID1011_LDO10STEP			(15<<0)
+/* SEQ control register for ID 12 and 13 */
+#define DA9058_ID1213_LDO13STEP			(15<<4)
+#define DA9058_ID1213_LDO12STEP			(15<<0)
+/* SEQ control register for ID 14 and 15 */
+#define DA9058_ID1415_BUCK2			(15<<4)
+#define DA9058_ID1415_BUCK1			(15<<0)
+/* SEQ control register for ID 16 and 17 */
+#define DA9058_ID1617_BUCK4			(15<<4)
+#define DA9058_ID1617_BUCK3			(15<<0)
+/* Power SEQ Status register */
+#define DA9058_SEQSTATUS_SEQPOINTER		(15<<4)
+#define DA9058_SEQSTATUS_WAITSTEP		(15<<0)
+/* Power SEQ A register */
+#define DA9058_SEQA_POWEREND			(15<<4)
+#define DA9058_SEQA_SYSTEMEND			(15<<0)
+/* Power SEQ B register */
+#define DA9058_SEQB_PARTDOWN			(15<<4)
+#define DA9058_SEQB_MAXCOUNT			(15<<0)
+/* Power SEQ TIMER register */
+#define DA9058_SEQTIMER_SEQDUMMY		(15<<4)
+#define DA9058_SEQTIMER_SEQTIME			(15<<0)
+/* BUCK REGISTER A */
+#define DA9058_BUCKA_BUCK2ILIM			(3<<6)
+#define DA9058_BUCKA_BUCK2MODE			(3<<4)
+#define DA9058_BUCKA_BUCK1ILIM			(3<<2)
+#define DA9058_BUCKA_BUCK1MODE			(3<<0)
+/* BUCK REGISTER B */
+#define DA9058_BUCKB_BUCK4ILIM			(3<<6)
+#define DA9058_BUCKB_BUCK4IMODE			(3<<4)
+#define DA9058_BUCKB_BUCK3ILIM			(3<<2)
+#define DA9058_BUCKB_BUCK3MODE			(3<<0)
+/* SUPPLY REGISTER */
+#define DA9058_SUPPLY_VLOCK			(1<<7)
+#define DA9058_SUPPLY_LDO15BEN			(1<<6)
+#define DA9058_SUPPLY_LDO15AEN			(1<<5)
+#define DA9058_SUPPLY_BBCHGEN			(1<<4)
+#define DA9058_SUPPLY_VBUCK4GO			(1<<3)
+#define DA9058_SUPPLY_VBUCK3GO			(1<<2)
+#define DA9058_SUPPLY_VBUCK2GO			(1<<1)
+#define DA9058_SUPPLY_VBUCK1GO			(1<<0)
+/* PULLDOWN REGISTER A */
+#define DA9058_PULLDOWN_A_LDO4PDDIS		(1<<7)
+#define DA9058_PULLDOWN_A_LDO3PDDIS		(1<<6)
+#define DA9058_PULLDOWN_A_LDO2PDDIS		(1<<5)
+#define DA9058_PULLDOWN_A_LDO1PDDIS		(1<<4)
+#define DA9058_PULLDOWN_A_BUCK4PDDIS		(1<<3)
+#define DA9058_PULLDOWN_A_BUCK3PDDIS		(1<<2)
+#define DA9058_PULLDOWN_A_BUCK2PDDIS		(1<<1)
+#define DA9058_PULLDOWN_A_BUCK1PDDIS		(1<<0)
+/* PULLDOWN REGISTER B */
+#define DA9058_PULLDOWN_B_LDO13PDDIS		(1<<7)
+#define DA9058_PULLDOWN_B_LDO12PDDIS		(1<<6)
+#define DA9058_PULLDOWN_B_LDO10PDDIS		(1<<5)
+#define DA9058_PULLDOWN_B_LDO9PDDIS		(1<<4)
+#define DA9058_PULLDOWN_B_LDO8PDDIS		(1<<3)
+#define DA9058_PULLDOWN_B_LDO7PDDIS		(1<<2)
+#define DA9058_PULLDOWN_B_LDO6PDDIS		(1<<1)
+#define DA9058_PULLDOWN_B_LDO5PDDIS		(1<<0)
+/* PULLDOWN REGISTER C */
+#define DA9058_PULLDOWN_C_LDO19PDDIS		(1<<6)
+#define DA9058_PULLDOWN_C_LDO18PDDIS		(1<<5)
+#define DA9058_PULLDOWN_C_LDO17PDDIS		(1<<4)
+#define DA9058_PULLDOWN_C_LDO16PDDIS		(1<<3)
+#define DA9058_PULLDOWN_C_LDO15BPDDIS		(1<<2)
+#define DA9058_PULLDOWN_C_LDO15APDDIS		(1<<1)
+#define DA9058_PULLDOWN_C_LDO14PDDIS		(1<<0)
+/* WAIT CONTROL REGISTER */
+#define DA9058_WAITCONT_WAITDIR			(1<<7)
+#define DA9058_WAITCONT_RTCCLOCK		(1<<6)
+#define DA9058_WAITCONT_WAITMODE		(1<<5)
+#define DA9058_WAITCONT_EN32KOUT		(1<<4)
+#define DA9058_WAITCONT_DELAYTIME		(15<<0)
+/* ONKEY CONTROL REGISTER */
+#define DA9058_ONKEYCONT_PRESSTIME		(15<<0)
+/* POWER CONTROL REGISTER */
+#define DA9058_POWERCONT_nSLEEP			(1<<0)
+/* BACKUP BATTERY CONTROL REGISTER */
+#define DA9058_BBATCONT_BCHARGERISET		(15<<4)
+#define DA9058_BBATCONT_BCHARGERVSET		(15<<0)
+/* AUDIO CONF2 REGISTER */
+#define DA9058_AUDIOCONF_CLASSDEN		(1<<0)
+/* ADC MANUAL registers */
+#define DA9058_ADCMAN_MANCONV			(1<<4)
+#define DA9058_ADCMAN_MUXSEL_MASK		(0x0F)
+#define DA9058_ADCMAN_MUXSEL_VBAT		(0x0<<0)
+#define DA9058_ADCMAN_MUXSEL_TEMP		(0x2<<0)
+#define DA9058_ADCMAN_MUXSEL_VF			(0x4<<0)
+#define DA9058_ADCMAN_MUXSEL_ADCIN		(0x5<<0)
+#define DA9058_ADCMAN_MUXSEL_TJUNC		(0x8<<0)
+/* ADC CONTROL regsisters */
+#define DA9058_ADCCONT_AUTOADCEN		(1<<7)
+#define DA9058_ADCCONT_ADCMODE			(1<<6)
+#define DA9058_ADCCONT_TEMPISRCEN		(1<<5)
+#define DA9058_ADCCONT_VFISRCEN			(1<<4)
+#define DA9058_ADCCONT_AUTOAINEN		(1<<2)
+#define DA9058_ADCCONT_AUTOVFEN			(1<<1)
+#define DA9058_ADCCONT_AUTOVBATEN		(1<<0)
+/* ADC 12 BIT MANUAL CONVERSION RESULT LSB register */
+#define DA9058_ADCRESL_ADCRESLSB		(15<<0)
+#define DA9058_ADCRESL_ADCRESLSB_MASK		DA9058_ADCRESL_ADCRESLSB
+/* ADC 12 BIT MANUAL CONVERSION RESULT MSB register */
+#define DA9058_ADCRESH_ADCRESMSB			(255<<0)
+#define DA9058_ADCRESH_ADCRESMSB_MASK		DA9058_ADCRESH_ADCRESMSB
+/* VBAT 10 BIT RES MSB regsister*/
+#define DA9058_VBATRES_VBATRESMSB		(255<<0)
+#define DA9058_VBATRES_VBATRESMSB_MASK		DA9058_VBATRES_VBATRESMSB
+/* VBAT 10 BIT RES LSB regsister*/
+#define DA9058_VBATRES_VBATRESLSB		(3<<2)
+#define DA9058_VBATRES_VBATRESLSB_MASK		DA9058_VBATRES_VBATRESLSB
+/* TEMP 10 BIT RES MSB regsister*/
+#define DA9058_TEMPRES_TEMPRESMSB		(255<<0)
+#define DA9058_TEMPRES_TEMPRESMSB_MASK		DA9058_TEMPRES_TEMPRESMSB
+/* TEMP 10 BIT RES LSB regsister*/
+#define DA9058_TEMPRES_TEMPRESLSB		(3<<6)
+#define DA9058_TEMPRES_TEMPRESLSB_MASK		DA9058_TEMPRES_TEMPRESLSB
+/* T_OFFSET regsister*/
+#define DA9058_TOFFSET_TOFFSET			(255<<0)
+/* VF 10 BIT RES MSB regsister*/
+#define DA9058_VFRES_VFRESMSB			(255<<0)
+#define DA9058_VFRES_VFRESMSB_MASK		DA9058_VFRES_VFRESMSB
+/* VF 10 BIT RES LSB regsister*/
+#define DA9058_VFRES_VFRESLSB			(3<<2)
+#define DA9058_VFRES_VFRESLSB_MASK		DA9058_VFRES_VFRESLSB
+/* ADCIN 10 BIT RES MSB regsister*/
+#define DA9058_ADCINRES_ADCINRESMSB		(255<<0)
+#define DA9058_ADCINRES_ADCINRESMSB_MASK	DA9058_ADCINRES_ADCINRESMSB
+/* ADCIN 10 BIT RES LSB regsister*/
+#define DA9058_ADCINRES_ADCINRESLSB		(3<<6)
+#define DA9058_ADCINRES_ADCINRESLSB_MASK	DA9058_ADCINRES_ADCINRESLSB
+/* TJUNC 10 BIT RES MSB regsister*/
+#define DA9058_TJUNCRES_TJUNCRESMSB		(255<<0)
+#define DA9058_TJUNCRES_TJUNCRESMSB_MASK	DA9058_TJUNCRES_TJUNCRESMSB
+/* ADCIN 10 BIT RES LSB regsister*/
+#define DA9058_TJUNCRES_TJUNCRESLSB		(3<<6)
+#define DA9058_TJUNCRES_TJUNCRESLSB_MASK	DA9058_TJUNCRES_TJUNCRESLSB
+/* RTC fields - all values are coded linearly from 0 or 1 upwards */
+#define DA9058_RTC_SECS_MASK			0x3F
+#define DA9058_RTC_MINS_MASK			0x3F
+#define DA9058_RTC_HRS_MASK			0x1F
+#define DA9058_RTC_DAY_MASK			0x1F
+#define DA9058_RTC_MTH_MASK			0x0F
+#define DA9058_RTC_YRS_MASK			0x3F
+#define DA9058_RTC_ALMSECS_MASK			0x3F
+#define DA9058_RTC_ALMMINS_MASK			0x3F
+#define DA9058_RTC_ALMHRS_MASK			0x1F
+#define DA9058_RTC_ALMDAY_MASK			0x1F
+#define DA9058_RTC_ALMMTH_MASK			0x0F
+#define DA9058_RTC_ALMYRS_MASK			0x3F
+/* RTC TIMER SECONDS REGISTER */
+#define DA9058_COUNTS_COUNTSEC			(63<<0)
+/* RTC TIMER MINUTES REGISTER */
+#define DA9058_COUNTMI_COUNTMIN			(63<<0)
+/* RTC TIMER HOUR REGISTER */
+#define DA9058_COUNTH_COUNTHOUR			(31<<0)
+/* RTC TIMER DAYS REGISTER */
+#define DA9058_COUNTD_COUNTDAY			(31<<0)
+/* RTC TIMER MONTHS REGISTER */
+#define DA9058_COUNTMO_COUNTMONTH		(15<<0)
+/* RTC TIMER YEARS REGISTER */
+#define DA9058_COUNTY_MONITOR			(1<<6)
+#define DA9058_COUNTY_COUNTYEAR			(63<<0)
+/* RTC ALARM SECONDS REGISTER */
+#define DA9058_ALARMMI_COUNTSEC			(63<<0)
+/* RTC ALARM MINUTES REGISTER */
+#define DA9058_ALARMMI_TICKTYPE			(1<<7)
+#define DA9058_ALARMMI_ALARMMIN			(63<<0)
+/* RTC ALARM HOURS REGISTER */
+#define DA9058_ALARMH_ALARMHOUR			(31<<0)
+/* RTC ALARM DAYS REGISTER */
+#define DA9058_ALARMD_ALARMDAY			(31<<0)
+/* RTC ALARM MONTHS REGISTER */
+#define DA9058_ALARMMO_ALARMMONTH		(15<<0)
+/* RTC ALARM YEARS REGISTER */
+#define DA9058_ALARMY_TICKON			(1<<7)
+#define DA9058_ALARMY_ALARMON			(1<<6)
+#define DA9058_ALARMY_ALARMYEAR			(63<<0)
+/* CHIP IDENTIFICATION REGISTER */
+#define DA9058_CHIPID_MRC			(15<<4)
+#define DA9058_CHIPID_TRC			(15<<0)
+/* CONFIGURATION IDENTIFICATION REGISTER */
+#define DA9058_CONFIGID_CONFID			(7<<0)
+/* OTP CONTROL REGISTER */
+#define DA9058_OTPCONT_GPWRITEDIS		(1<<7)
+#define DA9058_OTPCONT_OTPCONFLOCK		(1<<6)
+#define DA9058_OTPCONT_OTPGPLOCK		(1<<5)
+#define DA9058_OTPCONT_OTPCONFG			(1<<3)
+#define DA9058_OTPCONT_OTPGP			(1<<2)
+#define DA9058_OTPCONT_OTPRP			(1<<1)
+#define DA9058_OTPCONT_OTPTRANSFER		(1<<0)
+/* RTC OSCILLATOR TRIM REGISTER */
+#define DA9058_OSCTRIM_TRIM32K			(255<<0)
+/* GP ID REGISTERs 0 - 9 */
+#define DA9058_GPID0_GP0			(255<<0)
+#define DA9058_GPID1_GP1			(255<<0)
+#define DA9058_GPID2_GP2			(255<<0)
+#define DA9058_GPID3_GP3			(255<<0)
+#define DA9058_GPID4_GP4			(255<<0)
+#define DA9058_GPID5_GP5			(255<<0)
+#define DA9058_GPID6_GP6			(255<<0)
+#define DA9058_GPID7_GP7			(255<<0)
+#define DA9058_GPID8_GP8			(255<<0)
+#define DA9058_GPID9_GP9			(255<<0)
+
+#endif /* __DA9058_REGISTERS_H */
diff --git a/include/linux/mfd/da9058/regulator.h b/include/linux/mfd/da9058/regulator.h
new file mode 100644
index 0000000..686c607
--- /dev/null
+++ b/include/linux/mfd/da9058/regulator.h
@@ -0,0 +1,33 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __DA9058_REGULATOR_H
+#define __DA9058_REGULATOR_H
+
+struct da9058_regulator_pdata {
+	char *regulator_name;
+	int regulator_id;
+	int min_uV;
+	int max_uV;
+	int control_voltage_step;
+	int control_register;
+	int control_enable_mask;
+	int ramp_register;
+	int ramp_enable_mask;
+	int fixed_voltage;
+	unsigned int valid_ops_mask;
+	unsigned int valid_modes_mask;
+	unsigned int always_on:1;
+	unsigned int boot_on:1;
+	int num_consumer_supplies;
+	struct regulator_consumer_supply *consumer_supplies;
+};
+
+#endif /* __DA9058_REGULATOR_H */
diff --git a/include/linux/mfd/da9058/rtc.h b/include/linux/mfd/da9058/rtc.h
new file mode 100644
index 0000000..aa597df
--- /dev/null
+++ b/include/linux/mfd/da9058/rtc.h
@@ -0,0 +1,17 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#ifndef __DA9058_RTC_H
+#define __DA9058_RTC_H
+
+struct da9058_rtc_pdata {
+};
+
+#endif /* __DA9058_RTC_H */
-- 
end-of-patch for NEW DRIVER V3

