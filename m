Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1DTB1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:27:38 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:40258 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab1DTB1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:27:36 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv3 3/4] TPS65910: IRQ: Add interrupt controller
Date: Tue, 19 Apr 2011 20:27:32 -0500
Message-Id: <5728ED73-0475-4240-BEA5-00EB9BA20275@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, sameo@linux.intel.com,
        Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk>

This module controls the interrupt handling for the tps chip. The
interrupt sources are the following:

- GPIO falling/rising edge detection
- Battery voltage below/above threshold
- PWRON signal
- PWRHOLD signal
- Temperature detection
- RTC alarm and periodic event

Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/mfd/Makefile         |    2 +-
 drivers/mfd/tps65910-irq.c   |  187 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/tps65910.c       |   12 +++
 include/linux/mfd/tps65910.h |    5 +
 4 files changed, 205 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/tps65910-irq.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 012ed17..c771eed 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -88,4 +88,4 @@ obj-$(CONFIG_MFD_VX855)		+= vx855.o
 obj-$(CONFIG_MFD_WL1273_CORE)	+= wl1273-core.o
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o
-obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-gpio.o
+obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-gpio.o tps65910-irq.o
diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
new file mode 100644
index 0000000..b970a4c
--- /dev/null
+++ b/drivers/mfd/tps65910-irq.c
@@ -0,0 +1,187 @@
+/*
+ * tps65910-irq.c  --  TI TPS6591x
+ *
+ * Copyright 2010 Texas Instruments Inc.
+ *
+ * Author: Graeme Gregory <gg@slimlogic.co.uk>
+ * Author: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
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
+#include <linux/mfd/tps65910.h>
+
+static inline int irq_to_tps65910_irq(struct tps65910 *tps65910,
+							int irq)
+{
+	return (irq - tps65910->irq_base);
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
+static irqreturn_t tps65910_irq(int irq, void *irq_data)
+{
+	struct tps65910 *tps65910 = irq_data;
+	u16 irq_sts;
+	u16 irq_mask;
+	u8 reg;
+	int i;
+
+	tps65910->read(tps65910, TPS65910_INT_STS, 1, &reg);
+	irq_sts = reg;
+	tps65910->read(tps65910, TPS65910_INT_STS2, 1, &reg);
+	irq_sts |= reg << 8;
+
+	tps65910->read(tps65910, TPS65910_INT_MSK, 1, &reg);
+	irq_mask = reg;
+	tps65910->read(tps65910, TPS65910_INT_STS2, 1, &reg);
+	irq_mask |= reg << 8;
+
+	irq_sts &= ~irq_mask;
+
+	if (!irq_sts)
+		return IRQ_NONE;
+
+	for (i = 0; i < TPS65910_NUM_IRQ; i++) {
+
+		if (!(irq_sts & (1 << i)))
+			continue;
+
+		handle_nested_irq(tps65910->irq_base + i);
+	}
+
+	/* Write the STS register back to clear IRQs we handled */
+	reg = irq_sts & 0xFF;
+	tps65910->write(tps65910, TPS65910_INT_STS, 1, &reg);
+	reg = irq_sts >> 8;
+	tps65910->write(tps65910, TPS65910_INT_STS2, 1, &reg);
+
+	return IRQ_HANDLED;
+}
+
+static void tps65910_irq_lock(struct irq_data *data)
+{
+	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
+
+	mutex_lock(&tps65910->irq_lock);
+}
+
+static void tps65910_irq_sync_unlock(struct irq_data *data)
+{
+	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
+	u16 reg_mask;
+	u8 reg;
+
+	tps65910->read(tps65910, TPS65910_INT_MSK, 1, &reg);
+	reg_mask = reg;
+	tps65910->read(tps65910, TPS65910_INT_MSK2, 1, &reg);
+	reg_mask |= reg << 8;
+
+	if (tps65910->irq_mask != reg_mask) {
+		reg = tps65910->irq_mask & 0xFF;
+		tps65910->write(tps65910, TPS65910_INT_MSK, 1, &reg);
+		reg = tps65910->irq_mask >> 8;
+		tps65910->write(tps65910, TPS65910_INT_MSK2, 1, &reg);
+	}
+	mutex_unlock(&tps65910->irq_lock);
+}
+
+static void tps65910_irq_enable(struct irq_data *data)
+{
+	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
+
+	tps65910->irq_mask &= ~( 1 << irq_to_tps65910_irq(tps65910, data->irq));
+}
+
+static void tps65910_irq_disable(struct irq_data *data)
+{
+	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
+
+	tps65910->irq_mask |= ( 1 << irq_to_tps65910_irq(tps65910, data->irq));
+}
+
+static struct irq_chip tps65910_irq_chip = {
+	.name = "tps65910",
+	.irq_bus_lock = tps65910_irq_lock,
+	.irq_bus_sync_unlock = tps65910_irq_sync_unlock,
+	.irq_disable = tps65910_irq_disable,
+	.irq_enable = tps65910_irq_enable,
+};
+
+int tps65910_irq_init(struct tps65910 *tps65910, int irq,
+		    struct tps65910_platform_data *pdata)
+{
+	int ret, cur_irq;
+	int flags = IRQF_ONESHOT;
+	u8 reg;
+
+	if (!irq) {
+		dev_warn(tps65910->dev, "No interrupt support, no core IRQ\n");
+		return -EINVAL;
+	}
+
+	if (!pdata || !pdata->irq_base) {
+		dev_warn(tps65910->dev, "No interrupt support, no IRQ base\n");
+		return -EINVAL;
+	}
+
+	/* Mask top level interrupts */
+	reg = 0xFF;
+	tps65910->write(tps65910, TPS65910_INT_MSK, 1, &reg);
+	reg = 0x03;
+	tps65910->write(tps65910, TPS65910_INT_MSK2, 1, &reg);
+
+	mutex_init(&tps65910->irq_lock);
+	tps65910->chip_irq = irq;
+	tps65910->irq_base = pdata->irq_base;
+
+	/* Register with genirq */
+	for (cur_irq = tps65910->irq_base;
+	     cur_irq < TPS65910_NUM_IRQ + tps65910->irq_base;
+	     cur_irq++) {
+		irq_set_chip_data(cur_irq, tps65910);
+		irq_set_chip_and_handler(cur_irq, &tps65910_irq_chip,
+					 handle_edge_irq);
+		irq_set_nested_thread(cur_irq, 1);
+
+		/* ARM needs us to explicitly flag the IRQ as valid
+		 * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+		set_irq_flags(cur_irq, IRQF_VALID);
+#else
+		set_irq_noprobe(cur_irq);
+#endif
+	}
+
+	ret = request_threaded_irq(irq, NULL, tps65910_irq, flags,
+				   "tps65910", tps65910);
+	if (ret != 0)
+		dev_err(tps65910->dev, "Failed to request IRQ: %d\n", ret);
+
+	return ret;
+}
+
+int tps65910_irq_exit(struct tps65910 *tps65910)
+{
+	free_irq(tps65910->chip_irq, tps65910);
+	return 0;
+}
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 99c43b6..618ef5b 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -90,12 +90,20 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 {
 	struct tps65910 *tps65910;
 	struct tps65910_board *pmic_plat_data;
+	struct tps65910_platform_data *init_data;
 	int ret = 0;
 
 	pmic_plat_data = dev_get_platdata(&i2c->dev);
 	if (!pmic_plat_data)
 		return -EINVAL;
 
+	init_data = kzalloc(sizeof(struct tps65910_platform_data), GFP_KERNEL);
+	if (init_data == NULL)
+		return -ENOMEM;
+
+	init_data->irq = pmic_plat_data->irq;
+	init_data->irq_base = pmic_plat_data->irq;
+
 	tps65910 = kzalloc(sizeof(struct tps65910), GFP_KERNEL);
 	if (tps65910 == NULL)
 		return -ENOMEM;
@@ -114,6 +122,10 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
 
+	ret = tps65910_irq_init(tps65910, init_data->irq, init_data);
+	if (ret < 0)
+		goto err;
+
 	return ret;
 
 err:
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index bf3597e..afc1896 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -715,6 +715,8 @@
 
 struct tps65910_board {
 	int gpio_base;
+	int irq;
+	int irq_base;
 	struct regulator_init_data *tps65910_pmic_init_data;
 };
 
@@ -744,9 +746,12 @@ struct tps65910 {
 };
 
 struct tps65910_platform_data {
+	int irq;
 	int irq_base;
 };
 
 void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base);
+int tps65910_irq_init(struct tps65910 *tps65910, int irq,
+		struct tps65910_platform_data *pdata);
 
 #endif /*  __LINUX_MFD_TPS65910_H */
-- 
1.7.1

