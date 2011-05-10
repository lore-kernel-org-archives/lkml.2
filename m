Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1EJUfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:35:48 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:33817 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab1EJUen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:34:43 -0400
MIME-Version: 1.0
Date: Tue, 10 May 2011 15:25:50 -0500
Message-ID: <BANLkTims+=20bPoVYSVhMis+vpL75bvpZA@mail.gmail.com>
Subject: [PATCH 3/4] tps65912: irq: add interrupt controller
From: Margarita Olaya <magi@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This module controls the interrupt handling for the tps65912.
The interrupt sources can be the following:

- GPIO
- PWRON signal
- PWRHOLD signal
- Temperature detection

Signed-off-by: Margarita Olaya Cabrera <magi@slimlogic.co.uk>
---
 drivers/mfd/Makefile         |    2 +-
 drivers/mfd/tps65912-irq.c   |  224 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/tps65912.c       |   20 ++++
 include/linux/mfd/tps65912.h |    5 +
 4 files changed, 250 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/tps65912-irq.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 687bd2a..c902069 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -31,7 +31,7 @@ wm8350-objs			+= wm8350-irq.o
 obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
 obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
 obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o wm8994-irq.o
-obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o tps65912-gpio.o
+obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o tps65912-gpio.o tps65912-irq.o

 obj-$(CONFIG_TPS6105X)		+= tps6105x.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
diff --git a/drivers/mfd/tps65912-irq.c b/drivers/mfd/tps65912-irq.c
new file mode 100644
index 0000000..8e0763a
--- /dev/null
+++ b/drivers/mfd/tps65912-irq.c
@@ -0,0 +1,224 @@
+/*
+ * tps65912-irq.c  --  TI TPS6591x
+ *
+ * Copyright 2011 Texas Instruments Inc.
+ *
+ * Author: Margarita Olaya <magi@slimlogic.co.uk>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/bug.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+#include <linux/mfd/tps65912.h>
+
+static inline int irq_to_tps65912_irq(struct tps65912 *tps65912,
+							int irq)
+{
+	return irq - tps65912->irq_base;
+}
+
+/*
+ * This is a threaded IRQ handler so can access I2C/SPI.  Since all
+ * interrupts are clear on read the IRQ line will be reasserted and
+ * the physical IRQ will be handled again if another interrupt is
+ * asserted while we run - in the normal course of events this is a
+ * rare occurrence so we save I2C/SPI reads.  We're also assuming that
+ * it's rare to get lots of interrupts firing simultaneously so try to
+ * minimise I/O.
+ */
+static irqreturn_t tps65912_irq(int irq, void *irq_data)
+{
+	struct tps65912 *tps65912 = irq_data;
+	u32 irq_sts;
+	u32 irq_mask;
+	u8 reg;
+	int i;
+
+
+	tps65912->read(tps65912, TPS65912_INT_STS, 1, &reg);
+	irq_sts = reg;
+	tps65912->read(tps65912, TPS65912_INT_STS2, 1, &reg);
+	irq_sts |= reg << 8;
+	tps65912->read(tps65912, TPS65912_INT_STS3, 1, &reg);
+	irq_sts |= reg << 16;
+	tps65912->read(tps65912, TPS65912_INT_STS4, 1, &reg);
+	irq_sts |= reg << 24;
+
+	tps65912->read(tps65912, TPS65912_INT_MSK, 1, &reg);
+	irq_mask = reg;
+	tps65912->read(tps65912, TPS65912_INT_MSK2, 1, &reg);
+	irq_mask |= reg << 8;
+	tps65912->read(tps65912, TPS65912_INT_MSK3, 1, &reg);
+	irq_mask |= reg << 16;
+	tps65912->read(tps65912, TPS65912_INT_MSK4, 1, &reg);
+	irq_mask |= reg << 24;
+
+	irq_sts &= ~irq_mask;
+	if (!irq_sts)
+		return IRQ_NONE;
+
+	for (i = 0; i < tps65912->irq_num; i++) {
+		if (!(irq_sts & (1 << i)))
+			continue;
+
+		handle_nested_irq(tps65912->irq_base + i);
+	}
+
+	/* Write the STS register back to clear IRQs we handled */
+	reg = irq_sts & 0xFF;
+	irq_sts >>= 8;
+	if (reg)
+		tps65912->write(tps65912, TPS65912_INT_STS, 1, &reg);
+	reg = irq_sts & 0xFF;
+	irq_sts >>= 8;
+	if (reg)
+		tps65912->write(tps65912, TPS65912_INT_STS2, 1, &reg);
+	reg = irq_sts & 0xFF;
+	irq_sts >>= 8;
+	if (reg)
+		tps65912->write(tps65912, TPS65912_INT_STS3, 1, &reg);
+	reg = irq_sts & 0xFF;
+	if (reg)
+		tps65912->write(tps65912, TPS65912_INT_STS4, 1, &reg);
+
+	return IRQ_HANDLED;
+}
+
+static void tps65912_irq_lock(struct irq_data *data)
+{
+	struct tps65912 *tps65912 = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&tps65912->irq_lock);
+}
+
+static void tps65912_irq_sync_unlock(struct irq_data *data)
+{
+	struct tps65912 *tps65912 = irq_data_get_irq_chip_data(data);
+	u32 reg_mask;
+	u8 reg;
+
+	tps65912->read(tps65912, TPS65912_INT_MSK, 1, &reg);
+	reg_mask = reg;
+	tps65912->read(tps65912, TPS65912_INT_MSK2, 1, &reg);
+	reg_mask |= reg << 8;
+	tps65912->read(tps65912, TPS65912_INT_MSK3, 1, &reg);
+	reg_mask |= reg << 16;
+	tps65912->read(tps65912, TPS65912_INT_MSK4, 1, &reg);
+	reg_mask |= reg << 24;
+
+	if (tps65912->irq_mask != reg_mask) {
+		reg = tps65912->irq_mask & 0xFF;
+		tps65912->write(tps65912, TPS65912_INT_MSK, 1, &reg);
+		reg = tps65912->irq_mask >> 8 & 0xFF;
+		tps65912->write(tps65912, TPS65912_INT_MSK2, 1, &reg);
+		reg = tps65912->irq_mask >> 16 & 0xFF;
+		tps65912->write(tps65912, TPS65912_INT_MSK3, 1, &reg);
+		reg = tps65912->irq_mask >> 24 & 0xFF;
+		tps65912->write(tps65912, TPS65912_INT_MSK4, 1, &reg);
+	}
+
+	mutex_unlock(&tps65912->irq_lock);
+}
+
+static void tps65912_irq_enable(struct irq_data *data)
+{
+	struct tps65912 *tps65912 = irq_data_get_irq_chip_data(data);
+
+	tps65912->irq_mask &= ~(1 << irq_to_tps65912_irq(tps65912, data->irq));
+}
+
+static void tps65912_irq_disable(struct irq_data *data)
+{
+	struct tps65912 *tps65912 = irq_data_get_irq_chip_data(data);
+
+	tps65912->irq_mask |= (1 << irq_to_tps65912_irq(tps65912, data->irq));
+}
+
+static struct irq_chip tps65912_irq_chip = {
+	.name = "tps65912",
+	.irq_bus_lock = tps65912_irq_lock,
+	.irq_bus_sync_unlock = tps65912_irq_sync_unlock,
+	.irq_disable = tps65912_irq_disable,
+	.irq_enable = tps65912_irq_enable,
+};
+
+int tps65912_irq_init(struct tps65912 *tps65912, int irq,
+			    struct tps65912_platform_data *pdata)
+{
+	int ret, cur_irq;
+	int flags = IRQF_ONESHOT;
+	u8 reg;
+
+	if (!irq) {
+		dev_warn(tps65912->dev, "No interrupt support, no core IRQ\n");
+		return 0;
+	}
+
+	if (!pdata || !pdata->irq_base) {
+		dev_warn(tps65912->dev, "No interrupt support, no IRQ base\n");
+		return 0;
+	}
+
+	/* Clear unattended interrupts */
+	tps65912->read(tps65912, TPS65912_INT_STS, 1, &reg);
+	tps65912->write(tps65912, TPS65912_INT_STS, 1, &reg);
+	tps65912->read(tps65912, TPS65912_INT_STS2, 1, &reg);
+	tps65912->write(tps65912, TPS65912_INT_STS2, 1, &reg);
+	tps65912->read(tps65912, TPS65912_INT_STS3, 1, &reg);
+	tps65912->write(tps65912, TPS65912_INT_STS3, 1, &reg);
+	tps65912->read(tps65912, TPS65912_INT_STS4, 1, &reg);
+	tps65912->write(tps65912, TPS65912_INT_STS4, 1, &reg);
+
+	/* Mask top level interrupts */
+	tps65912->irq_mask = 0xFFFFFFFF;
+
+	mutex_init(&tps65912->irq_lock);
+	tps65912->chip_irq = irq;
+	tps65912->irq_base = pdata->irq_base;
+
+	tps65912->irq_num = TPS65912_NUM_IRQ;
+
+	/* Register with genirq */
+	for (cur_irq = tps65912->irq_base;
+	     cur_irq < tps65912->irq_num + tps65912->irq_base;
+	     cur_irq++) {
+		irq_set_chip_data(cur_irq, tps65912);
+		irq_set_chip_and_handler(cur_irq, &tps65912_irq_chip,
+					 handle_edge_irq);
+		irq_set_nested_thread(cur_irq, 1);
+		/* ARM needs us to explicitly flag the IRQ as valid
+		 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+		set_irq_flags(cur_irq, IRQF_VALID);
+#else
+		irq_set_noprobe(cur_irq);
+#endif
+	}
+
+	ret = request_threaded_irq(irq, NULL, tps65912_irq, flags,
+				   "tps65912", tps65912);
+
+	irq_set_irq_type(irq, IRQ_TYPE_LEVEL_LOW);
+	if (ret != 0)
+		dev_err(tps65912->dev, "Failed to request IRQ: %d\n", ret);
+
+	return ret;
+}
+
+int tps65912_irq_exit(struct tps65912 *tps65912)
+{
+	free_irq(tps65912->chip_irq, tps65912);
+	return 0;
+}
+
diff --git a/drivers/mfd/tps65912.c b/drivers/mfd/tps65912.c
index 83dbc3a..44ddcd4 100644
--- a/drivers/mfd/tps65912.c
+++ b/drivers/mfd/tps65912.c
@@ -89,12 +89,20 @@ static int tps65912_i2c_probe(struct i2c_client *i2c,
 {
 	struct tps65912 *tps65912;
 	struct tps65912_board *pmic_plat_data;
+	struct tps65912_platform_data *init_data;
 	int ret = 0;

 	pmic_plat_data = dev_get_platdata(&i2c->dev);
 	if (!pmic_plat_data)
 		return -EINVAL;

+	init_data = kzalloc(sizeof(struct tps65912_platform_data), GFP_KERNEL);
+	if (init_data == NULL)
+		return -ENOMEM;
+
+	init_data->irq = pmic_plat_data->irq;
+	init_data->irq_base = pmic_plat_data->irq;
+
 	tps65912 = kzalloc(sizeof(struct tps65912), GFP_KERNEL);
 	if (tps65912 == NULL)
 		return -ENOMEM;
@@ -114,6 +122,10 @@ static int tps65912_i2c_probe(struct i2c_client *i2c,

 	tps65912_gpio_init(tps65912, pmic_plat_data->gpio_base);

+	ret = tps65912_irq_init(tps65912, init_data->irq, init_data);
+	if (ret < 0)
+		goto err;
+
 	return ret;

 err:
@@ -226,6 +238,10 @@ static int __devinit tps65912_spi_probe(struct
spi_device *spi)
 								GFP_KERNEL);
 	if (init_data == NULL)
 		return -ENOMEM;
+
+	init_data->irq = pmic_plat_data->irq;
+	init_data->irq_base = pmic_plat_data->irq;
+
 	tps65912 = kzalloc(sizeof(struct tps65912), GFP_KERNEL);
 	if (tps65912 == NULL)
 		return -ENOMEM;
@@ -255,6 +271,10 @@ static int __devinit tps65912_spi_probe(struct
spi_device *spi)

 	tps65912_gpio_init(tps65912, pmic_plat_data->gpio_base);

+	ret = tps65912_irq_init(tps65912, init_data->irq, init_data);
+	if (ret < 0)
+		goto err;
+
 	return ret;

 err:
diff --git a/include/linux/mfd/tps65912.h b/include/linux/mfd/tps65912.h
index bcfdc0d..9a576ab 100644
--- a/include/linux/mfd/tps65912.h
+++ b/include/linux/mfd/tps65912.h
@@ -406,6 +406,8 @@
  */
 struct tps65912_board {
 	int gpio_base;
+	int irq;
+	int irq_base;
 	struct regulator_init_data *tps65912_pmic_init_data;
 };

@@ -443,6 +445,7 @@ struct tps65912 {
 };

 struct tps65912_platform_data {
+	int irq;
 	int irq_base;
 	int is_dcdc1_avs;
 	int is_dcdc2_avs;
@@ -455,6 +458,8 @@ unsigned int tps_chip(void);
 int tps65912_set_bits(struct tps65912 *tps65912, u8 reg, u8 mask);
 int tps65912_clear_bits(struct tps65912 *tps65912, u8 reg, u8 mask);
 void tps65912_gpio_init(struct tps65912 *tps65912, int gpio_base);
+int tps65912_irq_init(struct tps65912 *tps65912, int irq,
+			struct tps65912_platform_data *pdata);

 #endif /*  __LINUX_MFD_TPS65912_H */

-- 
1.7.0.4
