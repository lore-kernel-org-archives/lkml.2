Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239Ab2IGIwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:52:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56289 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab2IGIwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:52:00 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] mfd: add new lp8788 driver
Thread-Topic: [PATCH v4] mfd: add new lp8788 driver
Thread-Index: Ac2M1gQXiBTL4S84St2PU1RVbjSwbA==
Date: Fri, 7 Sep 2012 08:51:50 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF4501@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 TI LP8788 PMU provides regulators, battery charger, ADC,
 RTC, backlight driver and current sinks.

 This MFD patch supports the I2C communication using the regmap,
 the interrupt handling using the linear IRQ domain and
 configurable platform data structures for each driver module.

 (Driver Architecture)

                                         < mfd devices >
  LP8788 HW  ..........  mfd  .......... regulator drivers
                I2C                      power supply driver
                IRQs                     iio adc driver
                                         rtc driver
                                         backlight driver
                                         current sink drivers

  o regulators    : LDOs and BUCKs
  o power supply  : Battery charger
  o iio adc       : Battery voltage/temperature
  o rtc           : RTC and alarm
  o backlight
  o current sink  : LED and vibrator

 All MFD device modules are registered by LP8788 MFD core driver.
 For sharing information such like the virtual IRQ number,
 MFD core driver uses the resource structure.
 Then each module can retrieve the specific IRQ number and detect it
 in the IRQ thread.

 Configurable platform data is handled in each driver module.

 (History)

 Patch v4.
 ADC platform data change : pointer array -> simple pointer

 Patch v3.
 Use linear IRQ domain rather than old generic IRQ.

 Patch v2.
 Use generic IRQ for interrupt handling.
 Remove ADC exported functions. moved to new iio adc driver.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/mfd/Kconfig              |   10 ++
 drivers/mfd/Makefile             |    2 +
 drivers/mfd/lp8788-irq.c         |  197 +++++++++++++++++++++
 drivers/mfd/lp8788.c             |  245 +++++++++++++++++++++++++
 include/linux/mfd/lp8788-isink.h |   52 ++++++
 include/linux/mfd/lp8788.h       |  364 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 870 insertions(+)
 create mode 100644 drivers/mfd/lp8788-irq.c
 create mode 100644 drivers/mfd/lp8788.c
 create mode 100644 include/linux/mfd/lp8788-isink.h
 create mode 100644 include/linux/mfd/lp8788.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b1a1462..c64876a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -451,6 +451,16 @@ config PMIC_ADP5520
 	  individual components like LCD backlight, LEDs, GPIOs and Kepad
 	  under the corresponding menus.
 
+config MFD_LP8788
+	bool "Texas Instruments LP8788 Power Management Unit Driver"
+	depends on I2C=y
+	select MFD_CORE
+	select REGMAP_I2C
+	select IRQ_DOMAIN
+	help
+	  TI LP8788 PMU supports regulators, battery charger, RTC,
+	  ADC, backlight driver and current sinks.
+
 config MFD_MAX77686
 	bool "Maxim Semiconductor MAX77686 PMIC Support"
 	depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 79dd22d..489cab9 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -90,6 +90,8 @@ obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
 obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
 obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
 
+obj-$(CONFIG_MFD_LP8788)	+= lp8788.o lp8788-irq.o
+
 obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
 obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
diff --git a/drivers/mfd/lp8788-irq.c b/drivers/mfd/lp8788-irq.c
new file mode 100644
index 0000000..4b8014a
--- /dev/null
+++ b/drivers/mfd/lp8788-irq.c
@@ -0,0 +1,197 @@
+/*
+ * TI LP8788 MFD - interrupt handler
+ *
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/mfd/lp8788.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+/* register address */
+#define LP8788_INT_1			0x00
+#define LP8788_INTEN_1			0x03
+
+#define BASE_INTEN_ADDR			LP8788_INTEN_1
+#define SIZE_REG			8
+#define NUM_REGS			3
+
+/*
+ * struct lp8788_irq_data
+ * @lp               : used for accessing to lp8788 registers
+ * @irq_lock         : mutex for enabling/disabling the interrupt
+ * @domain           : IRQ domain for handling nested interrupt
+ * @enabled          : status of enabled interrupt
+ */
+struct lp8788_irq_data {
+	struct lp8788 *lp;
+	struct mutex irq_lock;
+	struct irq_domain *domain;
+	int enabled[LP8788_INT_MAX];
+};
+
+static inline u8 _irq_to_addr(enum lp8788_int_id id)
+{
+	return id / SIZE_REG;
+}
+
+static inline u8 _irq_to_enable_addr(enum lp8788_int_id id)
+{
+	return _irq_to_addr(id) + BASE_INTEN_ADDR;
+}
+
+static inline u8 _irq_to_mask(enum lp8788_int_id id)
+{
+	return 1 << (id % SIZE_REG);
+}
+
+static inline u8 _irq_to_val(enum lp8788_int_id id, int enable)
+{
+	return enable << (id % SIZE_REG);
+}
+
+static void lp8788_irq_enable(struct irq_data *data)
+{
+	struct lp8788_irq_data *irqd = irq_data_get_irq_chip_data(data);
+	irqd->enabled[data->hwirq] = 1;
+}
+
+static void lp8788_irq_disable(struct irq_data *data)
+{
+	struct lp8788_irq_data *irqd = irq_data_get_irq_chip_data(data);
+	irqd->enabled[data->hwirq] = 0;
+}
+
+static void lp8788_irq_bus_lock(struct irq_data *data)
+{
+	struct lp8788_irq_data *irqd = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&irqd->irq_lock);
+}
+
+static void lp8788_irq_bus_sync_unlock(struct irq_data *data)
+{
+	struct lp8788_irq_data *irqd = irq_data_get_irq_chip_data(data);
+	enum lp8788_int_id irq = data->hwirq;
+	u8 addr, mask, val;
+
+	addr = _irq_to_enable_addr(irq);
+	mask = _irq_to_mask(irq);
+	val = _irq_to_val(irq, irqd->enabled[irq]);
+
+	lp8788_update_bits(irqd->lp, addr, mask, val);
+
+	mutex_unlock(&irqd->irq_lock);
+}
+
+static struct irq_chip lp8788_irq_chip = {
+	.name			= "lp8788",
+	.irq_enable		= lp8788_irq_enable,
+	.irq_disable		= lp8788_irq_disable,
+	.irq_bus_lock		= lp8788_irq_bus_lock,
+	.irq_bus_sync_unlock	= lp8788_irq_bus_sync_unlock,
+};
+
+static irqreturn_t lp8788_irq_handler(int irq, void *ptr)
+{
+	struct lp8788_irq_data *irqd = ptr;
+	struct lp8788 *lp = irqd->lp;
+	u8 status[NUM_REGS], addr, mask;
+	bool handled;
+	int i;
+
+	if (lp8788_read_multi_bytes(lp, LP8788_INT_1, status, NUM_REGS))
+		return IRQ_NONE;
+
+	for (i = 0 ; i < LP8788_INT_MAX ; i++) {
+		addr = _irq_to_addr(i);
+		mask = _irq_to_mask(i);
+
+		/* reporting only if the irq is enabled */
+		if (status[addr] & mask) {
+			handle_nested_irq(irq_find_mapping(irqd->domain, i));
+			handled = true;
+		}
+	}
+
+	return handled ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static int lp8788_irq_map(struct irq_domain *d, unsigned int virq,
+			irq_hw_number_t hwirq)
+{
+	struct lp8788_irq_data *irqd = d->host_data;
+	struct irq_chip *chip = &lp8788_irq_chip;
+
+	irq_set_chip_data(virq, irqd);
+	irq_set_chip_and_handler(virq, chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static struct irq_domain_ops lp8788_domain_ops = {
+	.map = lp8788_irq_map,
+};
+
+int lp8788_irq_init(struct lp8788 *lp, int irq)
+{
+	struct lp8788_irq_data *irqd;
+	int ret;
+
+	if (irq <= 0) {
+		dev_warn(lp->dev, "invalid irq number: %d\n", irq);
+		return 0;
+	}
+
+	irqd = devm_kzalloc(lp->dev, sizeof(*irqd), GFP_KERNEL);
+	if (!irqd)
+		return -ENOMEM;
+
+	irqd->lp = lp;
+	irqd->domain = irq_domain_add_linear(lp->dev->of_node, LP8788_INT_MAX,
+					&lp8788_domain_ops, irqd);
+	if (!irqd->domain) {
+		dev_err(lp->dev, "failed to add irq domain err\n");
+		return -EINVAL;
+	}
+
+	lp->irqdm = irqd->domain;
+	mutex_init(&irqd->irq_lock);
+
+	ret = request_threaded_irq(irq, NULL, lp8788_irq_handler,
+				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				"lp8788-irq", irqd);
+	if (ret) {
+		dev_err(lp->dev, "failed to create a thread for IRQ_N\n");
+		return ret;
+	}
+
+	lp->irq = irq;
+
+	return 0;
+}
+
+void lp8788_irq_exit(struct lp8788 *lp)
+{
+	if (lp->irq)
+		free_irq(lp->irq, lp->irqdm);
+}
diff --git a/drivers/mfd/lp8788.c b/drivers/mfd/lp8788.c
new file mode 100644
index 0000000..f312ed9
--- /dev/null
+++ b/drivers/mfd/lp8788.c
@@ -0,0 +1,245 @@
+/*
+ * TI LP8788 MFD - core interface
+ *
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/lp8788.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#define MAX_LP8788_REGISTERS		0xA2
+
+#define MFD_DEV_SIMPLE(_name)					\
+{								\
+	.name = LP8788_DEV_##_name,				\
+}
+
+#define MFD_DEV_WITH_ID(_name, _id)				\
+{								\
+	.name = LP8788_DEV_##_name,				\
+	.id = _id,						\
+}
+
+#define MFD_DEV_WITH_RESOURCE(_name, _resource, num_resource)	\
+{								\
+	.name = LP8788_DEV_##_name,				\
+	.resources = _resource,					\
+	.num_resources = num_resource,				\
+}
+
+static struct resource chg_irqs[] = {
+	/* Charger Interrupts */
+	{
+		.start = LP8788_INT_CHG_INPUT_STATE,
+		.end   = LP8788_INT_PRECHG_TIMEOUT,
+		.name  = LP8788_CHG_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+	/* Power Routing Switch Interrupts */
+	{
+		.start = LP8788_INT_ENTER_SYS_SUPPORT,
+		.end   = LP8788_INT_EXIT_SYS_SUPPORT,
+		.name  = LP8788_PRSW_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+	/* Battery Interrupts */
+	{
+		.start = LP8788_INT_BATT_LOW,
+		.end   = LP8788_INT_NO_BATT,
+		.name  = LP8788_BATT_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource rtc_irqs[] = {
+	{
+		.start = LP8788_INT_RTC_ALARM1,
+		.end   = LP8788_INT_RTC_ALARM2,
+		.name  = LP8788_ALM_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell lp8788_devs[] = {
+	/* 4 bucks */
+	MFD_DEV_WITH_ID(BUCK, 1),
+	MFD_DEV_WITH_ID(BUCK, 2),
+	MFD_DEV_WITH_ID(BUCK, 3),
+	MFD_DEV_WITH_ID(BUCK, 4),
+
+	/* 12 digital ldos */
+	MFD_DEV_WITH_ID(DLDO, 1),
+	MFD_DEV_WITH_ID(DLDO, 2),
+	MFD_DEV_WITH_ID(DLDO, 3),
+	MFD_DEV_WITH_ID(DLDO, 4),
+	MFD_DEV_WITH_ID(DLDO, 5),
+	MFD_DEV_WITH_ID(DLDO, 6),
+	MFD_DEV_WITH_ID(DLDO, 7),
+	MFD_DEV_WITH_ID(DLDO, 8),
+	MFD_DEV_WITH_ID(DLDO, 9),
+	MFD_DEV_WITH_ID(DLDO, 10),
+	MFD_DEV_WITH_ID(DLDO, 11),
+	MFD_DEV_WITH_ID(DLDO, 12),
+
+	/* 10 analog ldos */
+	MFD_DEV_WITH_ID(ALDO, 1),
+	MFD_DEV_WITH_ID(ALDO, 2),
+	MFD_DEV_WITH_ID(ALDO, 3),
+	MFD_DEV_WITH_ID(ALDO, 4),
+	MFD_DEV_WITH_ID(ALDO, 5),
+	MFD_DEV_WITH_ID(ALDO, 6),
+	MFD_DEV_WITH_ID(ALDO, 7),
+	MFD_DEV_WITH_ID(ALDO, 8),
+	MFD_DEV_WITH_ID(ALDO, 9),
+	MFD_DEV_WITH_ID(ALDO, 10),
+
+	/* ADC */
+	MFD_DEV_SIMPLE(ADC),
+
+	/* battery charger */
+	MFD_DEV_WITH_RESOURCE(CHARGER, chg_irqs, ARRAY_SIZE(chg_irqs)),
+
+	/* rtc */
+	MFD_DEV_WITH_RESOURCE(RTC, rtc_irqs, ARRAY_SIZE(rtc_irqs)),
+
+	/* backlight */
+	MFD_DEV_SIMPLE(BACKLIGHT),
+
+	/* current sink for vibrator */
+	MFD_DEV_SIMPLE(VIBRATOR),
+
+	/* current sink for keypad LED */
+	MFD_DEV_SIMPLE(KEYLED),
+};
+
+int lp8788_read_byte(struct lp8788 *lp, u8 reg, u8 *data)
+{
+	int ret;
+	unsigned int val;
+
+	ret = regmap_read(lp->regmap, reg, &val);
+	if (ret < 0) {
+		dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
+		return ret;
+	}
+
+	*data = (u8)val;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(lp8788_read_byte);
+
+int lp8788_read_multi_bytes(struct lp8788 *lp, u8 reg, u8 *data, size_t count)
+{
+	return regmap_bulk_read(lp->regmap, reg, data, count);
+}
+EXPORT_SYMBOL_GPL(lp8788_read_multi_bytes);
+
+int lp8788_write_byte(struct lp8788 *lp, u8 reg, u8 data)
+{
+	return regmap_write(lp->regmap, reg, data);
+}
+EXPORT_SYMBOL_GPL(lp8788_write_byte);
+
+int lp8788_update_bits(struct lp8788 *lp, u8 reg, u8 mask, u8 data)
+{
+	return regmap_update_bits(lp->regmap, reg, mask, data);
+}
+EXPORT_SYMBOL_GPL(lp8788_update_bits);
+
+static int lp8788_platform_init(struct lp8788 *lp)
+{
+	struct lp8788_platform_data *pdata = lp->pdata;
+
+	return (pdata && pdata->init_func) ? pdata->init_func(lp) : 0;
+}
+
+static const struct regmap_config lp8788_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX_LP8788_REGISTERS,
+};
+
+static int lp8788_probe(struct i2c_client *cl, const struct i2c_device_id *id)
+{
+	struct lp8788 *lp;
+	struct lp8788_platform_data *pdata = cl->dev.platform_data;
+	int ret;
+
+	lp = devm_kzalloc(&cl->dev, sizeof(struct lp8788), GFP_KERNEL);
+	if (!lp)
+		return -ENOMEM;
+
+	lp->regmap = devm_regmap_init_i2c(cl, &lp8788_regmap_config);
+	if (IS_ERR(lp->regmap)) {
+		ret = PTR_ERR(lp->regmap);
+		dev_err(&cl->dev, "regmap init i2c err: %d\n", ret);
+		return ret;
+	}
+
+	lp->pdata = pdata;
+	lp->dev = &cl->dev;
+	i2c_set_clientdata(cl, lp);
+
+	ret = lp8788_platform_init(lp);
+	if (ret)
+		return ret;
+
+	ret = lp8788_irq_init(lp, cl->irq);
+	if (ret)
+		return ret;
+
+	return mfd_add_devices(lp->dev, -1, lp8788_devs,
+			ARRAY_SIZE(lp8788_devs), NULL, 0);
+}
+
+static int __devexit lp8788_remove(struct i2c_client *cl)
+{
+	struct lp8788 *lp = i2c_get_clientdata(cl);
+
+	mfd_remove_devices(lp->dev);
+	lp8788_irq_exit(lp);
+	return 0;
+}
+
+static const struct i2c_device_id lp8788_ids[] = {
+	{"lp8788", 0},
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, lp8788_ids);
+
+static struct i2c_driver lp8788_driver = {
+	.driver = {
+		.name = "lp8788",
+		.owner = THIS_MODULE,
+	},
+	.probe = lp8788_probe,
+	.remove = __devexit_p(lp8788_remove),
+	.id_table = lp8788_ids,
+};
+
+static int __init lp8788_init(void)
+{
+	return i2c_add_driver(&lp8788_driver);
+}
+subsys_initcall(lp8788_init);
+
+static void __exit lp8788_exit(void)
+{
+	i2c_del_driver(&lp8788_driver);
+}
+module_exit(lp8788_exit);
+
+MODULE_DESCRIPTION("TI LP8788 MFD Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/lp8788-isink.h b/include/linux/mfd/lp8788-isink.h
new file mode 100644
index 0000000..f38262d
--- /dev/null
+++ b/include/linux/mfd/lp8788-isink.h
@@ -0,0 +1,52 @@
+/*
+ * TI LP8788 MFD - common definitions for current sinks
+ *
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __ISINK_LP8788_H__
+#define __ISINK_LP8788_H__
+
+/* register address */
+#define LP8788_ISINK_CTRL		0x99
+#define LP8788_ISINK12_IOUT		0x9A
+#define LP8788_ISINK3_IOUT		0x9B
+#define LP8788_ISINK1_PWM		0x9C
+#define LP8788_ISINK2_PWM		0x9D
+#define LP8788_ISINK3_PWM		0x9E
+
+/* mask bits */
+#define LP8788_ISINK1_IOUT_M		0x0F	/* Addr 9Ah */
+#define LP8788_ISINK2_IOUT_M		0xF0
+#define LP8788_ISINK3_IOUT_M		0x0F	/* Addr 9Bh */
+
+/* 6 bits used for PWM code : Addr 9C ~ 9Eh */
+#define LP8788_ISINK_MAX_PWM		63
+#define LP8788_ISINK_SCALE_OFFSET	3
+
+static const u8 lp8788_iout_addr[] = {
+	LP8788_ISINK12_IOUT,
+	LP8788_ISINK12_IOUT,
+	LP8788_ISINK3_IOUT,
+};
+
+static const u8 lp8788_iout_mask[] = {
+	LP8788_ISINK1_IOUT_M,
+	LP8788_ISINK2_IOUT_M,
+	LP8788_ISINK3_IOUT_M,
+};
+
+static const u8 lp8788_pwm_addr[] = {
+	LP8788_ISINK1_PWM,
+	LP8788_ISINK2_PWM,
+	LP8788_ISINK3_PWM,
+};
+
+#endif
diff --git a/include/linux/mfd/lp8788.h b/include/linux/mfd/lp8788.h
new file mode 100644
index 0000000..cec364b
--- /dev/null
+++ b/include/linux/mfd/lp8788.h
@@ -0,0 +1,364 @@
+/*
+ * TI LP8788 MFD Device
+ *
+ * Copyright 2012 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __MFD_LP8788_H__
+#define __MFD_LP8788_H__
+
+#include <linux/gpio.h>
+#include <linux/irqdomain.h>
+#include <linux/regmap.h>
+
+#define LP8788_DEV_BUCK		"lp8788-buck"
+#define LP8788_DEV_DLDO		"lp8788-dldo"
+#define LP8788_DEV_ALDO		"lp8788-aldo"
+#define LP8788_DEV_CHARGER	"lp8788-charger"
+#define LP8788_DEV_RTC		"lp8788-rtc"
+#define LP8788_DEV_BACKLIGHT	"lp8788-backlight"
+#define LP8788_DEV_VIBRATOR	"lp8788-vibrator"
+#define LP8788_DEV_KEYLED	"lp8788-keyled"
+#define LP8788_DEV_ADC		"lp8788-adc"
+
+#define LP8788_NUM_BUCKS	4
+#define LP8788_NUM_DLDOS	12
+#define LP8788_NUM_ALDOS	10
+#define LP8788_NUM_BUCK2_DVS	2
+
+#define LP8788_CHG_IRQ		"CHG_IRQ"
+#define LP8788_PRSW_IRQ		"PRSW_IRQ"
+#define LP8788_BATT_IRQ		"BATT_IRQ"
+#define LP8788_ALM_IRQ		"ALARM_IRQ"
+
+enum lp8788_int_id {
+	/* interrup register 1 : Addr 00h */
+	LP8788_INT_TSDL,
+	LP8788_INT_TSDH,
+	LP8788_INT_UVLO,
+	LP8788_INT_FLAGMON,
+	LP8788_INT_PWRON_TIME,
+	LP8788_INT_PWRON,
+	LP8788_INT_COMP1,
+	LP8788_INT_COMP2,
+
+	/* interrupt register 2 : Addr 01h */
+	LP8788_INT_CHG_INPUT_STATE,
+	LP8788_INT_CHG_STATE,
+	LP8788_INT_EOC,
+	LP8788_INT_CHG_RESTART,
+	LP8788_INT_RESTART_TIMEOUT,
+	LP8788_INT_FULLCHG_TIMEOUT,
+	LP8788_INT_PRECHG_TIMEOUT,
+
+	/* interrupt register 3 : Addr 02h */
+	LP8788_INT_RTC_ALARM1 = 17,
+	LP8788_INT_RTC_ALARM2,
+	LP8788_INT_ENTER_SYS_SUPPORT,
+	LP8788_INT_EXIT_SYS_SUPPORT,
+	LP8788_INT_BATT_LOW,
+	LP8788_INT_NO_BATT,
+
+	LP8788_INT_MAX = 24,
+};
+
+enum lp8788_dvs_sel {
+	DVS_SEL_V0,
+	DVS_SEL_V1,
+	DVS_SEL_V2,
+	DVS_SEL_V3,
+};
+
+enum lp8788_ext_ldo_en_id {
+	EN_ALDO1,
+	EN_ALDO234,
+	EN_ALDO5,
+	EN_ALDO7,
+	EN_DLDO7,
+	EN_DLDO911,
+	EN_LDOS_MAX,
+};
+
+enum lp8788_charger_event {
+	NO_CHARGER,
+	CHARGER_DETECTED,
+};
+
+enum lp8788_bl_ctrl_mode {
+	LP8788_BL_REGISTER_ONLY,
+	LP8788_BL_COMB_PWM_BASED,	/* PWM + I2C, changed by PWM input */
+	LP8788_BL_COMB_REGISTER_BASED,	/* PWM + I2C, changed by I2C */
+};
+
+enum lp8788_bl_dim_mode {
+	LP8788_DIM_EXPONENTIAL,
+	LP8788_DIM_LINEAR,
+};
+
+enum lp8788_bl_full_scale_current {
+	LP8788_FULLSCALE_5000uA,
+	LP8788_FULLSCALE_8500uA,
+	LP8788_FULLSCALE_1200uA,
+	LP8788_FULLSCALE_1550uA,
+	LP8788_FULLSCALE_1900uA,
+	LP8788_FULLSCALE_2250uA,
+	LP8788_FULLSCALE_2600uA,
+	LP8788_FULLSCALE_2950uA,
+};
+
+enum lp8788_bl_ramp_step {
+	LP8788_RAMP_8us,
+	LP8788_RAMP_1024us,
+	LP8788_RAMP_2048us,
+	LP8788_RAMP_4096us,
+	LP8788_RAMP_8192us,
+	LP8788_RAMP_16384us,
+	LP8788_RAMP_32768us,
+	LP8788_RAMP_65538us,
+};
+
+enum lp8788_bl_pwm_polarity {
+	LP8788_PWM_ACTIVE_HIGH,
+	LP8788_PWM_ACTIVE_LOW,
+};
+
+enum lp8788_isink_scale {
+	LP8788_ISINK_SCALE_100mA,
+	LP8788_ISINK_SCALE_120mA,
+};
+
+enum lp8788_isink_number {
+	LP8788_ISINK_1,
+	LP8788_ISINK_2,
+	LP8788_ISINK_3,
+};
+
+enum lp8788_alarm_sel {
+	LP8788_ALARM_1,
+	LP8788_ALARM_2,
+	LP8788_ALARM_MAX,
+};
+
+enum lp8788_adc_id {
+	LPADC_VBATT_5P5,
+	LPADC_VIN_CHG,
+	LPADC_IBATT,
+	LPADC_IC_TEMP,
+	LPADC_VBATT_6P0,
+	LPADC_VBATT_5P0,
+	LPADC_ADC1,
+	LPADC_ADC2,
+	LPADC_VDD,
+	LPADC_VCOIN,
+	LPADC_VDD_LDO,
+	LPADC_ADC3,
+	LPADC_ADC4,
+	LPADC_MAX,
+};
+
+struct lp8788;
+
+/*
+ * lp8788_buck1_dvs
+ * @gpio         : gpio pin number for dvs control
+ * @vsel         : dvs selector for buck v1 register
+ */
+struct lp8788_buck1_dvs {
+	int gpio;
+	enum lp8788_dvs_sel vsel;
+};
+
+/*
+ * lp8788_buck2_dvs
+ * @gpio         : two gpio pin numbers are used for dvs
+ * @vsel         : dvs selector for buck v2 register
+ */
+struct lp8788_buck2_dvs {
+	int gpio[LP8788_NUM_BUCK2_DVS];
+	enum lp8788_dvs_sel vsel;
+};
+
+/*
+ * struct lp8788_ldo_enable_pin
+ *
+ *   Basically, all LDOs are enabled through the I2C commands.
+ *   But ALDO 1 ~ 5, 7, DLDO 7, 9, 11 can be enabled by external gpio pins.
+ *
+ * @gpio         : gpio number which is used for enabling ldos
+ * @init_state   : initial gpio state (ex. GPIOF_OUT_INIT_LOW)
+ */
+struct lp8788_ldo_enable_pin {
+	int gpio;
+	int init_state;
+};
+
+/*
+ * struct lp8788_chg_param
+ * @addr         : charging control register address (range : 0x11 ~ 0x1C)
+ * @val          : charging parameter value
+ */
+struct lp8788_chg_param {
+	u8 addr;
+	u8 val;
+};
+
+/*
+ * struct lp8788_charger_platform_data
+ * @vbatt_adc         : adc selection id for battery voltage
+ * @batt_temp_adc     : adc selection id for battery temperature
+ * @max_vbatt_mv      : used for calculating battery capacity
+ * @chg_params        : initial charging parameters
+ * @num_chg_params    : numbers of charging parameters
+ * @charger_event     : the charger event can be reported to the platform side
+ */
+struct lp8788_charger_platform_data {
+	enum lp8788_adc_id vbatt_adc;
+	enum lp8788_adc_id batt_temp_adc;
+	unsigned int max_vbatt_mv;
+	struct lp8788_chg_param *chg_params;
+	int num_chg_params;
+	void (*charger_event) (struct lp8788 *lp,
+				enum lp8788_charger_event event);
+};
+
+/*
+ * struct lp8788_bl_pwm_data
+ * @pwm_set_intensity     : set duty of pwm
+ * @pwm_get_intensity     : get current duty of pwm
+ */
+struct lp8788_bl_pwm_data {
+	void (*pwm_set_intensity) (int brightness, int max_brightness);
+	int (*pwm_get_intensity) (int max_brightness);
+};
+
+/*
+ * struct lp8788_backlight_platform_data
+ * @name                  : backlight driver name. (default: "lcd-backlight")
+ * @initial_brightness    : initial value of backlight brightness
+ * @bl_mode               : brightness control by pwm or lp8788 register
+ * @dim_mode              : dimming mode selection
+ * @full_scale            : full scale current setting
+ * @rise_time             : brightness ramp up step time
+ * @fall_time             : brightness ramp down step time
+ * @pwm_pol               : pwm polarity setting when bl_mode is pwm based
+ * @pwm_data              : platform specific pwm generation functions
+ *                          only valid when bl_mode is pwm based
+ */
+struct lp8788_backlight_platform_data {
+	char *name;
+	int initial_brightness;
+	enum lp8788_bl_ctrl_mode bl_mode;
+	enum lp8788_bl_dim_mode dim_mode;
+	enum lp8788_bl_full_scale_current full_scale;
+	enum lp8788_bl_ramp_step rise_time;
+	enum lp8788_bl_ramp_step fall_time;
+	enum lp8788_bl_pwm_polarity pwm_pol;
+	struct lp8788_bl_pwm_data pwm_data;
+};
+
+/*
+ * struct lp8788_led_platform_data
+ * @name         : led driver name. (default: "keyboard-backlight")
+ * @scale        : current scale
+ * @num          : current sink number
+ * @iout_code    : current output value (Addr 9Ah ~ 9Bh)
+ */
+struct lp8788_led_platform_data {
+	char *name;
+	enum lp8788_isink_scale scale;
+	enum lp8788_isink_number num;
+	int iout_code;
+};
+
+/*
+ * struct lp8788_vib_platform_data
+ * @name         : vibrator driver name
+ * @scale        : current scale
+ * @num          : current sink number
+ * @iout_code    : current output value (Addr 9Ah ~ 9Bh)
+ * @pwm_code     : PWM code value (Addr 9Ch ~ 9Eh)
+ */
+struct lp8788_vib_platform_data {
+	char *name;
+	enum lp8788_isink_scale scale;
+	enum lp8788_isink_number num;
+	int iout_code;
+	int pwm_code;
+};
+
+/*
+ * struct lp8788_platform_data
+ * @init_func    : used for initializing registers
+ *                 before mfd driver is registered
+ * @buck_data    : regulator initial data for buck
+ * @dldo_data    : regulator initial data for digital ldo
+ * @aldo_data    : regulator initial data for analog ldo
+ * @buck1_dvs    : gpio configurations for buck1 dvs
+ * @buck2_dvs    : gpio configurations for buck2 dvs
+ * @ldo_pin      : gpio configurations for enabling LDOs
+ * @chg_pdata    : platform data for charger driver
+ * @alarm_sel    : rtc alarm selection (1 or 2)
+ * @bl_pdata     : configurable data for backlight driver
+ * @led_pdata    : configurable data for led driver
+ * @vib_pdata    : configurable data for vibrator driver
+ * @adc_pdata    : iio map data for adc driver
+ */
+struct lp8788_platform_data {
+	/* general system information */
+	int (*init_func) (struct lp8788 *lp);
+
+	/* regulators */
+	struct regulator_init_data *buck_data[LP8788_NUM_BUCKS];
+	struct regulator_init_data *dldo_data[LP8788_NUM_DLDOS];
+	struct regulator_init_data *aldo_data[LP8788_NUM_ALDOS];
+	struct lp8788_buck1_dvs *buck1_dvs;
+	struct lp8788_buck2_dvs *buck2_dvs;
+	struct lp8788_ldo_enable_pin *ldo_pin[EN_LDOS_MAX];
+
+	/* charger */
+	struct lp8788_charger_platform_data *chg_pdata;
+
+	/* rtc alarm */
+	enum lp8788_alarm_sel alarm_sel;
+
+	/* backlight */
+	struct lp8788_backlight_platform_data *bl_pdata;
+
+	/* current sinks */
+	struct lp8788_led_platform_data *led_pdata;
+	struct lp8788_vib_platform_data *vib_pdata;
+
+	/* adc iio map data */
+	struct iio_map *adc_pdata;
+};
+
+/*
+ * struct lp8788
+ * @dev          : parent device pointer
+ * @regmap       : used for i2c communcation on accessing registers
+ * @irqdm        : interrupt domain for handling nested interrupt
+ * @irq          : pin number of IRQ_N
+ * @pdata        : lp8788 platform specific data
+ */
+struct lp8788 {
+	struct device *dev;
+	struct regmap *regmap;
+	struct irq_domain *irqdm;
+	int irq;
+	struct lp8788_platform_data *pdata;
+};
+
+int lp8788_irq_init(struct lp8788 *lp, int chip_irq);
+void lp8788_irq_exit(struct lp8788 *lp);
+int lp8788_read_byte(struct lp8788 *lp, u8 reg, u8 *data);
+int lp8788_read_multi_bytes(struct lp8788 *lp, u8 reg, u8 *data, size_t count);
+int lp8788_write_byte(struct lp8788 *lp, u8 reg, u8 data);
+int lp8788_update_bits(struct lp8788 *lp, u8 reg, u8 mask, u8 data);
+#endif
-- 
1.7.9.5


Best Regards,
Milo

