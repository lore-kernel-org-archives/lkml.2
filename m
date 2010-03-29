Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab0C2U2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:28:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60069 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752017Ab0C2U2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:28:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add WM8994 interrupt controller support
Date: Mon, 29 Mar 2010 21:28:45 +0100
Message-Id: <1269894525-21530-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8994 has an interrupt controller which supports interrupts for
both CODEC and GPIO portions of the chip. Support this using genirq,
while allowing for systems that do not have an interrupt hooked up.

Wrapper functions are provided for the IRQ request and free to simplify
the code in consumer drivers when handling cases where IRQs are not
set up.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Since the major consumer of this is going to be the CODEC driver for the
device it'd be very helpful if it were possible to merge this via ASoC,
but it's a relatively big change for that.

 drivers/mfd/Kconfig              |    4 +-
 drivers/mfd/Makefile             |    2 +-
 drivers/mfd/wm8994-core.c        |   38 +++++-
 drivers/mfd/wm8994-irq.c         |  268 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8994/core.h  |   53 ++++++++-
 include/linux/mfd/wm8994/pdata.h |    1 +
 6 files changed, 359 insertions(+), 7 deletions(-)
 create mode 100644 drivers/mfd/wm8994-irq.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b36249f..0dfcae2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -301,9 +301,9 @@ config MFD_WM8350_I2C
 	  selected to enable support for the functionality of the chip.
 
 config MFD_WM8994
-	tristate "Support Wolfson Microelectronics WM8994"
+	bool "Support Wolfson Microelectronics WM8994"
 	select MFD_CORE
-	depends on I2C
+	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  The WM8994 is a highly integrated hi-fi CODEC designed for
 	  smartphone applicatiosn.  As well as audio functionality it
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 80fdb63..f177e06 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -26,7 +26,7 @@ wm8350-objs			:= wm8350-core.o wm8350-regmap.o wm8350-gpio.o
 wm8350-objs			+= wm8350-irq.o
 obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
 obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
-obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o
+obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o wm8994-irq.o
 
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index cc524df..675aea5 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -173,9 +173,34 @@ static struct mfd_cell wm8994_regulator_devs[] = {
 	{ .name = "wm8994-ldo", .id = 2 },
 };
 
+static struct resource wm8994_codec_resources[] = {
+	{
+		.start = WM8994_IRQ_TEMP_SHUT,
+		.end   = WM8994_IRQ_TEMP_WARN,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource wm8994_gpio_resources[] = {
+	{
+		.start = WM8994_IRQ_GPIO(1),
+		.end   = WM8994_IRQ_GPIO(11),
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
 static struct mfd_cell wm8994_devs[] = {
-	{ .name = "wm8994-codec" },
-	{ .name = "wm8994-gpio" },
+	{
+		.name = "wm8994-codec",
+		.num_resources = ARRAY_SIZE(wm8994_codec_resources),
+		.resources = wm8994_codec_resources,
+	},
+
+	{
+		.name = "wm8994-gpio",
+		.num_resources = ARRAY_SIZE(wm8994_gpio_resources),
+		.resources = wm8994_gpio_resources,
+	},
 };
 
 /*
@@ -348,6 +373,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
 
 
 	if (pdata) {
+		wm8994->irq_base = pdata->irq_base;
 		wm8994->gpio_base = pdata->gpio_base;
 
 		/* GPIO configuration is only applied if it's non-zero */
@@ -375,16 +401,20 @@ static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
 					WM8994_LDO1_DISCH, 0);
 	}
 
+	wm8994_irq_init(wm8994);
+
 	ret = mfd_add_devices(wm8994->dev, -1,
 			      wm8994_devs, ARRAY_SIZE(wm8994_devs),
 			      NULL, 0);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to add children: %d\n", ret);
-		goto err_enable;
+		goto err_irq;
 	}
 
 	return 0;
 
+err_irq:
+	wm8994_irq_exit(wm8994);
 err_enable:
 	regulator_bulk_disable(ARRAY_SIZE(wm8994_main_supplies),
 			       wm8994->supplies);
@@ -401,6 +431,7 @@ err:
 static void wm8994_device_exit(struct wm8994 *wm8994)
 {
 	mfd_remove_devices(wm8994->dev);
+	wm8994_irq_exit(wm8994);
 	regulator_bulk_disable(ARRAY_SIZE(wm8994_main_supplies),
 			       wm8994->supplies);
 	regulator_bulk_free(ARRAY_SIZE(wm8994_main_supplies), wm8994->supplies);
@@ -469,6 +500,7 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	wm8994->control_data = i2c;
 	wm8994->read_dev = wm8994_i2c_read_device;
 	wm8994->write_dev = wm8994_i2c_write_device;
+	wm8994->irq = i2c->irq;
 
 	return wm8994_device_init(wm8994, id->driver_data, i2c->irq);
 }
diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
new file mode 100644
index 0000000..910f2ec
--- /dev/null
+++ b/drivers/mfd/wm8994-irq.c
@@ -0,0 +1,268 @@
+/*
+ * wm8994-irq.c  --  Interrupt controller support for Wolfson WM8994
+ *
+ * Copyright 2010 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/irq.h>
+#include <linux/mfd/core.h>
+#include <linux/interrupt.h>
+
+#include <linux/mfd/wm8994/core.h>
+#include <linux/mfd/wm8994/registers.h>
+
+#include <linux/delay.h>
+
+struct wm8994_irq_data {
+	int reg;
+	int mask;
+};
+
+static struct wm8994_irq_data wm8994_irqs[] = {
+	[WM8994_IRQ_TEMP_SHUT] = {
+		.reg = 2,
+		.mask = WM8994_TEMP_SHUT_EINT,
+	},
+	[WM8994_IRQ_MIC1_DET] = {
+		.reg = 2,
+		.mask = WM8994_MIC1_DET_EINT,
+	},
+	[WM8994_IRQ_MIC1_SHRT] = {
+		.reg = 2,
+		.mask = WM8994_MIC1_SHRT_EINT,
+	},
+	[WM8994_IRQ_MIC2_DET] = {
+		.reg = 2,
+		.mask = WM8994_MIC2_DET_EINT,
+	},
+	[WM8994_IRQ_MIC2_SHRT] = {
+		.reg = 2,
+		.mask = WM8994_MIC2_SHRT_EINT,
+	},
+	[WM8994_IRQ_FLL1_LOCK] = {
+		.reg = 2,
+		.mask = WM8994_FLL1_LOCK_EINT,
+	},
+	[WM8994_IRQ_FLL2_LOCK] = {
+		.reg = 2,
+		.mask = WM8994_FLL2_LOCK_EINT,
+	},
+	[WM8994_IRQ_SRC1_LOCK] = {
+		.reg = 2,
+		.mask = WM8994_SRC1_LOCK_EINT,
+	},
+	[WM8994_IRQ_SRC2_LOCK] = {
+		.reg = 2,
+		.mask = WM8994_SRC2_LOCK_EINT,
+	},
+	[WM8994_IRQ_AIF1DRC1_SIG_DET] = {
+		.reg = 2,
+		.mask = WM8994_AIF1DRC1_SIG_DET,
+	},
+	[WM8994_IRQ_AIF1DRC2_SIG_DET] = {
+		.reg = 2,
+		.mask = WM8994_AIF1DRC2_SIG_DET_EINT,
+	},
+	[WM8994_IRQ_AIF2DRC_SIG_DET] = {
+		.reg = 2,
+		.mask = WM8994_AIF2DRC_SIG_DET_EINT,
+	},
+	[WM8994_IRQ_FIFOS_ERR] = {
+		.reg = 2,
+		.mask = WM8994_FIFOS_ERR_EINT,
+	},
+	[WM8994_IRQ_WSEQ_DONE] = {
+		.reg = 2,
+		.mask = WM8994_WSEQ_DONE_EINT,
+	},
+	[WM8994_IRQ_DCS_DONE] = {
+		.reg = 2,
+		.mask = WM8994_DCS_DONE_EINT,
+	},
+	[WM8994_IRQ_TEMP_WARN] = {
+		.reg = 2,
+		.mask = WM8994_TEMP_WARN_EINT,
+	},
+};
+
+static inline int irq_data_to_status_reg(struct wm8994_irq_data *irq_data)
+{
+	return WM8994_INTERRUPT_STATUS_1 - 1 + irq_data->reg;
+}
+
+static inline int irq_data_to_mask_reg(struct wm8994_irq_data *irq_data)
+{
+	return WM8994_INTERRUPT_STATUS_1_MASK - 1 + irq_data->reg;
+}
+
+static inline struct wm8994_irq_data *irq_to_wm8994_irq(struct wm8994 *wm8994,
+							int irq)
+{
+	return &wm8994_irqs[irq - wm8994->irq_base];
+}
+
+static void wm8994_irq_lock(unsigned int irq)
+{
+	struct wm8994 *wm8994 = get_irq_chip_data(irq);
+
+	mutex_lock(&wm8994->irq_lock);
+}
+
+static void wm8994_irq_sync_unlock(unsigned int irq)
+{
+	struct wm8994 *wm8994 = get_irq_chip_data(irq);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wm8994->irq_masks_cur); i++) {
+		/* If there's been a change in the mask write it back
+		 * to the hardware. */
+		if (wm8994->irq_masks_cur[i] != wm8994->irq_masks_cache[i]) {
+			wm8994->irq_masks_cache[i] = wm8994->irq_masks_cur[i];
+			wm8994_reg_write(wm8994,
+					 WM8994_INTERRUPT_STATUS_1_MASK + i,
+					 wm8994->irq_masks_cur[i]);
+		}
+	}
+
+	mutex_unlock(&wm8994->irq_lock);
+}
+
+static void wm8994_irq_unmask(unsigned int irq)
+{
+	struct wm8994 *wm8994 = get_irq_chip_data(irq);
+	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994, irq);
+
+	wm8994->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
+}
+
+static void wm8994_irq_mask(unsigned int irq)
+{
+	struct wm8994 *wm8994 = get_irq_chip_data(irq);
+	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994, irq);
+
+	wm8994->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
+}
+
+static struct irq_chip wm8994_irq_chip = {
+	.name = "wm8994",
+	.bus_lock = wm8994_irq_lock,
+	.bus_sync_unlock = wm8994_irq_sync_unlock,
+	.mask = wm8994_irq_mask,
+	.unmask = wm8994_irq_unmask,
+};
+
+/* The processing of the primary interrupt occurs in a thread so that
+ * we can interact with the device over I2C or SPI. */
+static irqreturn_t wm8994_irq_thread(int irq, void *data)
+{
+	struct wm8994 *wm8994 = data;
+	unsigned int i;
+	u16 status[WM8994_NUM_IRQ_REGS];
+	int ret;
+
+	ret = wm8994_bulk_read(wm8994, WM8994_INTERRUPT_STATUS_1,
+			       WM8994_NUM_IRQ_REGS, status);
+	if (ret < 0) {
+		dev_err(wm8994->dev, "Failed to read interrupt status: %d\n",
+			ret);
+		return IRQ_NONE;
+	}
+
+	printk(KERN_CRIT "%x %x\n", status[0], status[1]);
+
+	/* Apply masking */
+	for (i = 0; i < WM8994_NUM_IRQ_REGS; i++)
+		status[i] &= ~wm8994->irq_masks_cur[i];
+
+	/* Report */
+	for (i = 0; i < ARRAY_SIZE(wm8994_irqs); i++) {
+		if (status[wm8994_irqs[i].reg - 1] & wm8994_irqs[i].mask)
+			handle_nested_irq(wm8994->irq_base + i);
+	}
+
+	/* Ack any unmasked IRQs */
+	for (i = 0; i < ARRAY_SIZE(status); i++) {
+		if (status[i])
+			wm8994_reg_write(wm8994, WM8994_INTERRUPT_STATUS_1 + i,
+					 status[i]);
+	}
+
+	return IRQ_HANDLED;
+}
+
+int wm8994_irq_init(struct wm8994 *wm8994)
+{
+	int i, cur_irq, ret;
+
+	mutex_init(&wm8994->irq_lock);
+
+	if (!wm8994->irq) {
+		dev_warn(wm8994->dev,
+			 "No interrupt specified, no interrupts\n");
+		wm8994->irq_base = 0;
+		return 0;
+	}
+
+	if (!wm8994->irq_base) {
+		dev_err(wm8994->dev,
+			"No interrupt base specified, no interrupts\n");
+		return 0;
+	}
+
+	/* Mask the individual interrupt sources */
+	for (i = 0; i < ARRAY_SIZE(wm8994->irq_masks_cur); i++) {
+		wm8994->irq_masks_cur[i] = 0xffff;
+		wm8994->irq_masks_cache[i] = 0xffff;
+		wm8994_reg_write(wm8994, WM8994_INTERRUPT_STATUS_1_MASK + i,
+				 0xffff);
+	}
+
+	/* Register them with genirq */
+	for (cur_irq = wm8994->irq_base;
+	     cur_irq < ARRAY_SIZE(wm8994_irqs) + wm8994->irq_base;
+	     cur_irq++) {
+		set_irq_chip_data(cur_irq, wm8994);
+		set_irq_chip_and_handler(cur_irq, &wm8994_irq_chip,
+					 handle_edge_irq);
+		set_irq_nested_thread(cur_irq, 1);
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
+	ret = request_threaded_irq(wm8994->irq, NULL, wm8994_irq_thread,
+				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				   "wm8994", wm8994);
+	if (ret != 0) {
+		dev_err(wm8994->dev, "Failed to request IRQ %d: %d\n",
+			wm8994->irq, ret);
+		return ret;
+	}
+
+	/* Enable top level interrupt if it was masked */
+	wm8994_reg_write(wm8994, WM8994_INTERRUPT_CONTROL, 0);
+
+	return 0;
+}
+
+void wm8994_irq_exit(struct wm8994 *wm8994)
+{
+	if (wm8994->irq)
+		free_irq(wm8994->irq, wm8994);
+}
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index b06ff28..de79bae 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -15,14 +15,38 @@
 #ifndef __MFD_WM8994_CORE_H__
 #define __MFD_WM8994_CORE_H__
 
+#include <linux/interrupt.h>
+
 struct regulator_dev;
 struct regulator_bulk_data;
 
 #define WM8994_NUM_GPIO_REGS 11
-#define WM8994_NUM_LDO_REGS 2
+#define WM8994_NUM_LDO_REGS   2
+#define WM8994_NUM_IRQ_REGS   2
+
+#define WM8994_IRQ_TEMP_SHUT		0
+#define WM8994_IRQ_MIC1_DET		1
+#define WM8994_IRQ_MIC1_SHRT		2
+#define WM8994_IRQ_MIC2_DET		3
+#define WM8994_IRQ_MIC2_SHRT		4
+#define WM8994_IRQ_FLL1_LOCK		5
+#define WM8994_IRQ_FLL2_LOCK		6
+#define WM8994_IRQ_SRC1_LOCK		7
+#define WM8994_IRQ_SRC2_LOCK		8
+#define WM8994_IRQ_AIF1DRC1_SIG_DET	9
+#define WM8994_IRQ_AIF1DRC2_SIG_DET	10
+#define WM8994_IRQ_AIF2DRC_SIG_DET	11
+#define WM8994_IRQ_FIFOS_ERR		12
+#define WM8994_IRQ_WSEQ_DONE		13
+#define WM8994_IRQ_DCS_DONE		14
+#define WM8994_IRQ_TEMP_WARN		15
+
+/* GPIOs in the chip are numbered from 1-11 */
+#define WM8994_IRQ_GPIO(x) (x + WM8994_IRQ_TEMP_WARN)
 
 struct wm8994 {
 	struct mutex io_lock;
+	struct mutex irq_lock;
 
 	struct device *dev;
 	int (*read_dev)(struct wm8994 *wm8994, unsigned short reg,
@@ -33,6 +57,11 @@ struct wm8994 {
 	void *control_data;
 
 	int gpio_base;
+	int irq_base;
+
+	int irq;
+	u16 irq_masks_cur[WM8994_NUM_IRQ_REGS];
+	u16 irq_masks_cache[WM8994_NUM_IRQ_REGS];
 
 	/* Used over suspend/resume */
 	u16 ldo_regs[WM8994_NUM_LDO_REGS];
@@ -51,4 +80,26 @@ int wm8994_set_bits(struct wm8994 *wm8994, unsigned short reg,
 int wm8994_bulk_read(struct wm8994 *wm8994, unsigned short reg,
 		     int count, u16 *buf);
 
+
+/* Helper to save on boilerplate */
+static inline int wm8994_request_irq(struct wm8994 *wm8994, int irq,
+				     irq_handler_t handler, const char *name,
+				     void *data)
+{
+	if (!wm8994->irq_base)
+		return -EINVAL;
+	return request_threaded_irq(wm8994->irq_base + irq, NULL, handler,
+				    IRQF_TRIGGER_RISING, name,
+				    data);
+}
+static inline void wm8994_free_irq(struct wm8994 *wm8994, int irq, void *data)
+{
+	if (!wm8994->irq_base)
+		return;
+	free_irq(wm8994->irq_base + irq, data);
+}
+
+int wm8994_irq_init(struct wm8994 *wm8994);
+void wm8994_irq_exit(struct wm8994 *wm8994);
+
 #endif
diff --git a/include/linux/mfd/wm8994/pdata.h b/include/linux/mfd/wm8994/pdata.h
index 70d6a86..5c51f36 100644
--- a/include/linux/mfd/wm8994/pdata.h
+++ b/include/linux/mfd/wm8994/pdata.h
@@ -70,6 +70,7 @@ struct wm8994_pdata {
 
 	struct wm8994_ldo_pdata ldo[WM8994_NUM_LDO];
 
+	int irq_base;  /** Base IRQ number for WM8994, required for IRQs */
 
         int num_drc_cfgs;
         struct wm8994_drc_cfg *drc_cfgs;
-- 
1.7.0.3

