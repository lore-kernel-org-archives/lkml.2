Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2GROdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:33:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38781 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab2GROdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:33:32 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>
Subject: [PATCH 1/6] mfd: add lp8788 mfd driver
Thread-Topic: [PATCH 1/6] mfd: add lp8788 mfd driver
Thread-Index: Ac1k8i6xsVnWXGXAR2GxE5eW2yYAsQ==
Date: Wed, 18 Jul 2012 14:32:40 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FD79B@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.177.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI LP8788 PMU supports regulators, battery charger, RTC, backlight driver and
current sinks.

Registers are controlled via the I2C with the regmap-i2c interface.
LP8788 irq domains are defined and used for handling interrupts.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/mfd/Kconfig              |   10 +
 drivers/mfd/Makefile             |    2 +
 drivers/mfd/lp8788-irq.c         |  290 +++++++++++++++++++++++++++++
 drivers/mfd/lp8788.c             |  377 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/lp8788-isink.h |   52 ++++++
 include/linux/mfd/lp8788.h       |  367 +++++++++++++++++++++++++++++++++++++
 6 files changed, 1098 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/lp8788-irq.c
 create mode 100644 drivers/mfd/lp8788.c
 create mode 100644 include/linux/mfd/lp8788-isink.h
 create mode 100644 include/linux/mfd/lp8788.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b3c19ba..0d2b1a2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -449,6 +449,16 @@ config PMIC_ADP5520
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
+	  backlight driver and current sinks.
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
index 0000000..de499bd
--- /dev/null
+++ b/drivers/mfd/lp8788-irq.c
@@ -0,0 +1,290 @@
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
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/mfd/lp8788.h>
+
+/* register address */
+#define LP8788_INT_1			0x00
+#define LP8788_INTEN_1			0x03
+
+#define BASE_INTEN_REG			LP8788_INTEN_1
+#define DEBOUNCE_MSEC			450
+#define SIZE_REG			8
+#define NUM_INTREGS			3
+
+/*
+ * struct lp8788_irq_data
+ * @lp               : access to lp8788 registers
+ * @irqdm            : interrupt domain for handling nested interrupt
+ * @irq_lock         : mutex for enabling/disabling the interrupt
+ * @work             : work for handling interrupt with debounce time
+ * @thread           : work queue for handling interrupt
+ * @enabled          : status of enabled interrupt
+ * @irq         : pin number of IRQ_N pin
+ * @irq_base         : used for handling chained interrupt
+ */
+struct lp8788_irq_data {
+	struct lp8788 *lp;
+	struct irq_domain *irqdm;
+	struct mutex irq_lock;
+	struct delayed_work work;
+	struct workqueue_struct *thread;
+	int enabled[LP8788_INT_MAX];
+	int irq;
+	int irq_base;
+};
+
+static inline u8 _irq_to_addr(enum lp8788_int_id id)
+{
+	return id / SIZE_REG;
+}
+
+static inline u8 _irq_to_enable_addr(enum lp8788_int_id id)
+{
+	return _irq_to_addr(id) + BASE_INTEN_REG;
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
+	enum lp8788_int_id irq = data->irq - irqd->irq_base;
+
+	irqd->enabled[irq] = 1;
+}
+
+static void lp8788_irq_disable(struct irq_data *data)
+{
+	struct lp8788_irq_data *irqd = irq_data_get_irq_chip_data(data);
+	enum lp8788_int_id irq = data->irq - irqd->irq_base;
+
+	irqd->enabled[irq] = 0;
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
+	enum lp8788_int_id irq = data->irq - irqd->irq_base;
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
+static int lp8788_irq_map(struct irq_domain *d, unsigned int virq,
+			irq_hw_number_t hwirq)
+{
+	struct lp8788_irq_data *irqd = d->host_data;
+	struct irq_chip *chip = &lp8788_irq_chip;
+
+	irq_set_chip_data(virq, irqd);
+	irq_set_chip_and_handler(virq, chip, handle_simple_irq);
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
+static struct irq_domain_ops lp8788_irqdm_ops = {
+	.map = lp8788_irq_map,
+};
+
+static void lp8788_nested_irq_handler(struct work_struct *work)
+{
+	struct lp8788_irq_data *irqd =
+		container_of(work, struct lp8788_irq_data, work.work);
+	struct lp8788 *lp = irqd->lp;
+	u8 status[NUM_INTREGS], addr, mask;
+	int i, ret, irq;
+
+	ret = lp8788_read_multi_bytes(lp, LP8788_INT_1, status, NUM_INTREGS);
+	if (ret)
+		return;
+
+	for (i = 0 ; i < LP8788_INT_MAX ; i++) {
+		addr = _irq_to_addr(i);
+		mask = _irq_to_mask(i);
+
+		/* only reporting the irq which is enabled */
+		if (status[addr] & mask) {
+			irq = irq_find_mapping(irqd->irqdm, i);
+			handle_nested_irq(irq);
+			dev_info(lp->dev, "IRQ: %d\n", irq);
+		}
+	}
+}
+
+static irqreturn_t lp8788_irq_handler(int irq, void *ptr)
+{
+	struct lp8788_irq_data *irqd = ptr;
+	unsigned long delay = msecs_to_jiffies(DEBOUNCE_MSEC);
+
+	queue_delayed_work(irqd->thread, &irqd->work, delay);
+
+	return IRQ_HANDLED;
+}
+
+static int lp8788_update_enable_irq_status(struct lp8788_irq_data *irqd)
+{
+	struct lp8788 *lp = irqd->lp;
+	u8 data[NUM_INTREGS], addr, mask;
+	int i, ret;
+
+	/* clear interrupts before setting irq data */
+	ret = lp8788_read_multi_bytes(lp, LP8788_INT_1, data, NUM_INTREGS);
+	if (ret)
+		return ret;
+
+	/* read irq enable bits and update enabled status */
+	ret = lp8788_read_multi_bytes(lp, LP8788_INTEN_1, data, NUM_INTREGS);
+	if (ret)
+		return ret;
+
+	for (i = 0 ; i < LP8788_INT_MAX ; i++) {
+		addr = _irq_to_addr(i);
+		mask = _irq_to_mask(i);
+		irqd->enabled[i] = data[addr] & mask ? 1 : 0;
+	}
+
+	return 0;
+}
+
+static int lp8788_create_irq_threads(struct lp8788_irq_data *irqd)
+{
+	struct device *dev = irqd->lp->dev;
+	int irq = irqd->irq;
+	int ret;
+
+	/* thread for IRQ_N pin */
+	ret = request_threaded_irq(irq, NULL, lp8788_irq_handler,
+				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				"lp8788-irq", irqd);
+	if (ret) {
+		dev_err(dev, "failed to create a thread for IRQ_N\n");
+		goto err_irq;
+	}
+
+	INIT_DELAYED_WORK(&irqd->work, lp8788_nested_irq_handler);
+
+	/* thread for handling nested IRQs after debounce time */
+	irqd->thread = create_singlethread_workqueue("lp8788-nested-irq");
+	if (!irqd->thread) {
+		dev_err(dev, "failed to create a thread for nested irqs\n");
+		ret = -ENOMEM;
+		goto cleanup_irq_thread;
+	}
+
+	return 0;
+
+cleanup_irq_thread:
+	free_irq(irq, irqd);
+err_irq:
+	return ret;
+}
+
+int lp8788_irq_init(struct lp8788 *lp, int irq)
+{
+	struct device_node *of_node = lp->dev->of_node;
+	struct lp8788_irq_data *irqd;
+	int ret, irq_base;
+
+	if (!lp->pdata) {
+		dev_warn(lp->dev, "no platform data for irq\n");
+		goto no_err;
+	}
+
+	irqd = devm_kzalloc(lp->dev, sizeof(*irqd), GFP_KERNEL);
+	if (!irqd)
+		return -ENOMEM;
+
+	lp->irqd = irqd;
+	irqd->lp = lp;
+	irqd->irq = irq;
+
+	ret = lp8788_update_enable_irq_status(irqd);
+	if (ret)
+		return ret;
+
+	irq_base = lp->pdata->irq_base;
+	if (irq_base) {
+		irq_base = irq_alloc_descs(irq_base, 0, LP8788_INT_MAX, 0);
+		if (irq_base < 0) {
+			dev_warn(lp->dev, "no allocated irq: %d\n", irq_base);
+			goto no_err;
+		}
+	}
+	irqd->irq_base = irq_base;
+
+	mutex_init(&irqd->irq_lock);
+
+	irqd->irqdm = irq_domain_add_simple(of_node, LP8788_INT_MAX, irq_base,
+					&lp8788_irqdm_ops, irqd);
+	if (!irqd->irqdm) {
+		dev_err(lp->dev, "failed to add irq domain err\n");
+		return -EINVAL;
+	}
+
+	return lp8788_create_irq_threads(irqd);
+
+no_err:
+	return 0;
+}
+
+void lp8788_irq_exit(struct lp8788 *lp)
+{
+	struct lp8788_irq_data *irqd = lp->irqd;
+
+	free_irq(irqd->irq, irqd);
+	destroy_workqueue(irqd->thread);
+}
diff --git a/drivers/mfd/lp8788.c b/drivers/mfd/lp8788.c
new file mode 100644
index 0000000..977ae2e
--- /dev/null
+++ b/drivers/mfd/lp8788.c
@@ -0,0 +1,377 @@
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
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/lp8788.h>
+
+/* register address */
+#define LP8788_ADC_CONF			0x60
+#define LP8788_ADC_RAW			0x61
+#define LP8788_ADC_DONE			0x63
+
+#define ADC_CONV_START			1
+#define ADC_CONV_DELAY_US		100
+#define MAX_LP8788_REGISTERS		0xA2
+
+#define MFD_DEV_WITH_RESOURCE(_name, _resource, num_resource)	\
+{								\
+	.name = LP8788_DEV_##_name,				\
+	.resources = _resource,					\
+	.num_resources = num_resource,				\
+}
+
+#define MFD_DEV_WITH_ID(_name, _id)		\
+{						\
+	.name = LP8788_DEV_##_name,		\
+	.id = _id,				\
+}
+
+#define MFD_DEV_SIMPLE(_name)			\
+{						\
+	.name = LP8788_DEV_##_name,		\
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
+	/* battery charger */
+	MFD_DEV_WITH_RESOURCE(CHARGER, chg_irqs, ARRAY_SIZE(chg_irqs)),
+	/* rtc */
+	MFD_DEV_WITH_RESOURCE(RTC, rtc_irqs, ARRAY_SIZE(rtc_irqs)),
+	/* backlight */
+	MFD_DEV_SIMPLE(BACKLIGHT),
+	/* current sink for vibrator */
+	MFD_DEV_SIMPLE(VIBRATOR),
+	/* current sink for keypad LED */
+	MFD_DEV_SIMPLE(KEYLED),
+};
+
+/*
+	ADC constant values for each selection
+
+[8 bit resolution]
+   - VIN_CHG : adc max value x 1000000 / (255 x 0.48)
+   - OTHERS  : adc max value x 1000000 / 255
+
+[12 bit resolution]
+   - VIN_CHG : adc max value x 1000000 / (4095 x 0.48)
+   - OTHERS  : adc max value x 1000000 / 4095
+
+*/
+static const int adc_const_8b[LPADC_MAX] = {
+	[LPADC_VBATT_5P5] = 21568,
+	[LPADC_VIN_CHG]   = 49019,
+	[LPADC_IBATT]     = 9803,
+	[LPADC_IC_TEMP]   = 9803,
+	[LPADC_VBATT_6P0] = 23529,
+	[LPADC_VBATT_5P0] = 19607,
+	[LPADC_ADC1]      = 9803,
+	[LPADC_ADC2]      = 9803,
+	[LPADC_VDD]       = 16470,
+	[LPADC_VCOIN]     = 12156,
+	[LPADC_VDD_LDO]   = 9803,
+	[LPADC_ADC3]      = 9803,
+	[LPADC_ADC4]      = 9803,
+};
+
+static const int adc_const_12b[LPADC_MAX] = {
+	[LPADC_VBATT_5P5] = 1343,
+	[LPADC_VIN_CHG]   = 3052,
+	[LPADC_IBATT]     = 610,
+	[LPADC_IC_TEMP]   = 610,
+	[LPADC_VBATT_6P0] = 1465,
+	[LPADC_VBATT_5P0] = 1221,
+	[LPADC_ADC1]      = 610,
+	[LPADC_ADC2]      = 610,
+	[LPADC_VDD]       = 1025,
+	[LPADC_VCOIN]     = 757,
+	[LPADC_VDD_LDO]   = 610,
+	[LPADC_ADC3]      = 610,
+	[LPADC_ADC4]      = 610,
+};
+
+static inline unsigned int _get_adc_micro_unit(unsigned int adc_const,
+					unsigned int adc_result)
+{
+	return adc_const * ((adc_result * 1000 + 500) / 1000);
+}
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
+EXPORT_SYMBOL(lp8788_read_byte);
+
+int lp8788_read_multi_bytes(struct lp8788 *lp, u8 reg, u8 *data, size_t count)
+{
+	return regmap_bulk_read(lp->regmap, reg, data, count);
+}
+EXPORT_SYMBOL(lp8788_read_multi_bytes);
+
+int lp8788_write_byte(struct lp8788 *lp, u8 reg, u8 data)
+{
+	return regmap_write(lp->regmap, reg, data);
+}
+EXPORT_SYMBOL(lp8788_write_byte);
+
+int lp8788_update_bits(struct lp8788 *lp, u8 reg, u8 mask, u8 data)
+{
+	return regmap_update_bits(lp->regmap, reg, mask, data);
+}
+EXPORT_SYMBOL(lp8788_update_bits);
+
+unsigned int lp8788_get_adc(struct lp8788 *lp, enum lp8788_adc_id id,
+			enum lp8788_adc_resolution res)
+{
+	unsigned int adc_const, adc_result;
+	int retry = 5;
+	u8 val;
+
+	if (res > LP8788_ADC_12BIT_RES) {
+		dev_warn(lp->dev, "invalid ADC resolution: %d\n", res);
+		res = LP8788_ADC_8BIT_RES;
+	}
+
+	val = (id << 1) | ADC_CONV_START;
+	if (lp8788_write_byte(lp, LP8788_ADC_CONF, val))
+		goto err;
+
+	/* retry until adc conversion is done */
+	val = 0;
+	while (retry--) {
+		udelay(ADC_CONV_DELAY_US);
+
+		if (lp8788_read_byte(lp, LP8788_ADC_DONE, &val))
+			goto err;
+
+		/* conversion done */
+		if (val)
+			break;
+	}
+
+	if (res == LP8788_ADC_8BIT_RES) {
+		u8 adc;
+
+		if (lp8788_read_byte(lp, LP8788_ADC_RAW, &adc))
+			goto err;
+
+		adc_result = adc & 0x0000ff;
+		adc_const = adc_const_8b[id];
+	} else {
+		u8 adc[2];
+		unsigned int msb, lsb;
+		int size = ARRAY_SIZE(adc);
+
+		if (lp8788_read_multi_bytes(lp, LP8788_ADC_RAW, adc, size))
+			goto err;
+
+		msb = (adc[0] << 4) & 0x00000ff0;
+		lsb = (adc[1] >> 4) & 0x0000000f;
+		adc_result = msb | lsb;
+		adc_const = adc_const_12b[id];
+	}
+
+	return _get_adc_micro_unit(adc_const, adc_result);
+err:
+	return 0;
+}
+EXPORT_SYMBOL(lp8788_get_adc);
+
+static int lp8788_platform_init(struct lp8788 *lp)
+{
+	struct lp8788_platform_data *pdata = lp->pdata;
+
+	return (pdata && pdata->init_func) ? pdata->init_func(lp) : 0;
+}
+
+static int lp8788_add_devices(struct lp8788 *lp)
+{
+	int ret;
+	int irq_base = lp->pdata ? lp->pdata->irq_base : 0;
+
+	ret = mfd_add_devices(lp->dev, -1, lp8788_devs, ARRAY_SIZE(lp8788_devs),
+			NULL, irq_base);
+	if (ret)
+		dev_err(lp->dev, "failed to add mfd device: %d\n", ret);
+
+	return ret;
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
+	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
+		return -EIO;
+
+	if (!pdata)
+		dev_warn(&cl->dev, "no lp8788 platform data\n");
+
+	lp = devm_kzalloc(&cl->dev, sizeof(struct lp8788), GFP_KERNEL);
+	if (!lp)
+		return -ENOMEM;
+
+	lp->regmap = devm_regmap_init_i2c(cl, &lp8788_regmap_config);
+	if (IS_ERR(lp->regmap)) {
+		ret = PTR_ERR(lp->regmap);
+		dev_err(&cl->dev, "regmap init i2c err: %d\n", ret);
+		goto err_out;
+	}
+
+	lp->pdata = pdata;
+	lp->dev = &cl->dev;
+	i2c_set_clientdata(cl, lp);
+
+	ret = lp8788_platform_init(lp);
+	if (ret)
+		goto err_out;
+
+	ret = lp8788_irq_init(lp, cl->irq);
+	if (ret)
+		goto err_out;
+
+	ret = lp8788_add_devices(lp);
+	if (ret)
+		goto err_irq;
+
+	return 0;
+
+err_irq:
+	lp8788_irq_exit(lp);
+err_out:
+	return ret;
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
index 0000000..c8b7070
--- /dev/null
+++ b/include/linux/mfd/lp8788.h
@@ -0,0 +1,367 @@
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
+#include <linux/regmap.h>
+#include <linux/gpio.h>
+
+#define LP8788_DEV_BUCK		"lp8788-buck"
+#define LP8788_DEV_DLDO		"lp8788-dldo"
+#define LP8788_DEV_ALDO		"lp8788-aldo"
+#define LP8788_DEV_CHARGER	"lp8788-charger"
+#define LP8788_DEV_RTC		"lp8788-rtc"
+#define LP8788_DEV_BACKLIGHT	"lp8788-backlight"
+#define LP8788_DEV_VIBRATOR	"lp8788-vibrator"
+#define LP8788_DEV_KEYLED	"lp8788-keyled"
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
+enum lp8788_adc_resolution {
+	LP8788_ADC_8BIT_RES,
+	LP8788_ADC_12BIT_RES,
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
+struct lp8788_irq_data;
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
+ * @irq_base     : used in chained interrupt handling
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
+ */
+struct lp8788_platform_data {
+	/* general system information */
+	int irq_base;
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
+};
+
+/*
+ * struct lp8788
+ * @regmap       : used for i2c communcation on accessing registers
+ * @irqd         : used for handling interrupts
+ * @dev          : parent device pointer
+ * @pdata        : lp8788 platform specific data
+ */
+struct lp8788 {
+	struct regmap *regmap;
+	struct lp8788_irq_data *irqd;
+	struct device *dev;
+	struct lp8788_platform_data *pdata;
+};
+
+int lp8788_irq_init(struct lp8788 *lp, int chip_irq);
+void lp8788_irq_exit(struct lp8788 *lp);
+int lp8788_read_byte(struct lp8788 *lp, u8 reg, u8 *data);
+int lp8788_read_multi_bytes(struct lp8788 *lp, u8 reg, u8 *data, size_t count);
+int lp8788_write_byte(struct lp8788 *lp, u8 reg, u8 data);
+int lp8788_update_bits(struct lp8788 *lp, u8 reg, u8 mask, u8 data);
+unsigned int lp8788_get_adc(struct lp8788 *lp, enum lp8788_adc_id id,
+			enum lp8788_adc_resolution res);
+
+#endif
-- 
1.7.2.5


Best Regards,
Milo


