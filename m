Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965230Ab2JCRH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:07:29 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63045 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209Ab2JCRHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:07:23 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: broonie@opensource.wolfsonmicro.com, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [RFC 2/3] mfd: da9052: Introduce da9052-irq.c
Date: Wed,  3 Oct 2012 14:06:58 -0300
Message-Id: <1349284019-31571-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349284019-31571-1-git-send-email-festevam@gmail.com>
References: <1349284019-31571-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a da9052-irq.c file so that it can handle interrupt related operations.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/mfd/Makefile              |    1 +
 drivers/mfd/da9052-core.c         |  323 +------------------------------------
 drivers/mfd/da9052-irq.c          |  304 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/da9052/da9052.h |    6 +
 4 files changed, 319 insertions(+), 315 deletions(-)
 create mode 100644 drivers/mfd/da9052-irq.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 083acf9..1b0e56f 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -85,6 +85,7 @@ obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 
+obj-$(CONFIG_PMIC_DA9052)	+= da9052-irq.o
 obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
 obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
 obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index 6574242..96fbfe4 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -15,8 +15,6 @@
 #include <linux/delay.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
 #include <linux/mfd/core.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -25,16 +23,6 @@
 #include <linux/mfd/da9052/pdata.h>
 #include <linux/mfd/da9052/reg.h>
 
-#define DA9052_NUM_IRQ_REGS		4
-#define DA9052_IRQ_MASK_POS_1		0x01
-#define DA9052_IRQ_MASK_POS_2		0x02
-#define DA9052_IRQ_MASK_POS_3		0x04
-#define DA9052_IRQ_MASK_POS_4		0x08
-#define DA9052_IRQ_MASK_POS_5		0x10
-#define DA9052_IRQ_MASK_POS_6		0x20
-#define DA9052_IRQ_MASK_POS_7		0x40
-#define DA9052_IRQ_MASK_POS_8		0x80
-
 static bool da9052_reg_readable(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -365,51 +353,6 @@ static const int32_t tbat_lookup[255] = {
 	-11823, -11903, -11982
 };
 
-static void da9052_irq_enable(struct irq_data *data)
-{
-}
-
-static void da9052_irq_disable(struct irq_data *data)
-{
-}
-
-static struct irq_chip da9052_irq_chip = {
-	.name			= "da9052",
-	.irq_disable		= da9052_irq_disable,
-	.irq_enable		= da9052_irq_enable,
-};
-
-static int da9052_irq_map(struct irq_domain *h, unsigned int virq,
-			      irq_hw_number_t hw)
-{
-	struct regmap_irq_chip_data *data = h->host_data;
-
-	irq_set_chip_data(virq, data);
-	irq_set_chip_and_handler(virq, &da9052_irq_chip, handle_edge_irq);
-	irq_set_nested_thread(virq, 1);
-
-	/* 
-	 * ARM needs us to explicitly flag the IRQ as valid
-	 * and will set them noprobe when we do so.
-	 */
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
-	irq_set_noprobe(virq);
-#endif
-
-	return 0;
-}
-
-static struct irq_domain_ops da9052_domain_ops = {
-	.map	= da9052_irq_map,
-	.xlate	= irq_domain_xlate_twocell,
-};
-
-static int da9052_map_irq(struct da9052 *da9052, int irq)
-{
-	return regmap_irq_get_virq(da9052->irq_data, irq);
-}
 
 static const u8 chan_mux[DA9052_ADC_VBBAT + 1] = {
 	[DA9052_ADC_VDDOUT]	= DA9052_ADC_MAN_MUXSEL_VDDOUT,
@@ -472,15 +415,6 @@ err:
 }
 EXPORT_SYMBOL_GPL(da9052_adc_manual_read);
 
-static irqreturn_t da9052_auxadc_irq(int irq, void *irq_data)
-{
-	struct da9052 *da9052 = irq_data;
-
-	complete(&da9052->done);
-
-	return IRQ_HANDLED;
-}
-
 int da9052_adc_read_temp(struct da9052 *da9052)
 {
 	int tbat;
@@ -494,74 +428,6 @@ int da9052_adc_read_temp(struct da9052 *da9052)
 }
 EXPORT_SYMBOL_GPL(da9052_adc_read_temp);
 
-static struct resource da9052_rtc_resource = {
-	.name = "ALM",
-	.start = DA9052_IRQ_ALARM,
-	.end   = DA9052_IRQ_ALARM,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct resource da9052_onkey_resource = {
-	.name = "ONKEY",
-	.start = DA9052_IRQ_NONKEY,
-	.end   = DA9052_IRQ_NONKEY,
-	.flags = IORESOURCE_IRQ,
-};
-
-static struct resource da9052_bat_resources[] = {
-	{
-		.name = "BATT TEMP",
-		.start = DA9052_IRQ_TBAT,
-		.end   = DA9052_IRQ_TBAT,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name = "DCIN DET",
-		.start = DA9052_IRQ_DCIN,
-		.end   = DA9052_IRQ_DCIN,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name = "DCIN REM",
-		.start = DA9052_IRQ_DCINREM,
-		.end   = DA9052_IRQ_DCINREM,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name = "VBUS DET",
-		.start = DA9052_IRQ_VBUS,
-		.end   = DA9052_IRQ_VBUS,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name = "VBUS REM",
-		.start = DA9052_IRQ_VBUSREM,
-		.end   = DA9052_IRQ_VBUSREM,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name = "CHG END",
-		.start = DA9052_IRQ_CHGEND,
-		.end   = DA9052_IRQ_CHGEND,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct resource da9052_tsi_resources[] = {
-	{
-		.name = "PENDWN",
-		.start = DA9052_IRQ_PENDOWN,
-		.end   = DA9052_IRQ_PENDOWN,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.name = "TSIRDY",
-		.start = DA9052_IRQ_TSIREADY,
-		.end   = DA9052_IRQ_TSIREADY,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
 static struct mfd_cell __devinitdata da9052_subdev_info[] = {
 	{
 		.name = "da9052-regulator",
@@ -621,13 +487,9 @@ static struct mfd_cell __devinitdata da9052_subdev_info[] = {
 	},
 	{
 		.name = "da9052-onkey",
-		.resources = &da9052_onkey_resource,
-		.num_resources = 1,
 	},
 	{
 		.name = "da9052-rtc",
-		.resources = &da9052_rtc_resource,
-		.num_resources = 1,
 	},
 	{
 		.name = "da9052-gpio",
@@ -649,160 +511,15 @@ static struct mfd_cell __devinitdata da9052_subdev_info[] = {
 	},
 	{
 		.name = "da9052-tsi",
-		.resources = da9052_tsi_resources,
-		.num_resources = ARRAY_SIZE(da9052_tsi_resources),
 	},
 	{
 		.name = "da9052-bat",
-		.resources = da9052_bat_resources,
-		.num_resources = ARRAY_SIZE(da9052_bat_resources),
 	},
 	{
 		.name = "da9052-watchdog",
 	},
 };
 
-static struct regmap_irq da9052_irqs[] = {
-	[DA9052_IRQ_DCIN] = {
-		.reg_offset = 0,
-		.mask = DA9052_IRQ_MASK_POS_1,
-	},
-	[DA9052_IRQ_VBUS] = {
-		.reg_offset = 0,
-		.mask = DA9052_IRQ_MASK_POS_2,
-	},
-	[DA9052_IRQ_DCINREM] = {
-		.reg_offset = 0,
-		.mask = DA9052_IRQ_MASK_POS_3,
-	},
-	[DA9052_IRQ_VBUSREM] = {
-		.reg_offset = 0,
-		.mask = DA9052_IRQ_MASK_POS_4,
-	},
-	[DA9052_IRQ_VDDLOW] = {
-		.reg_offset = 0,
-		.mask = DA9052_IRQ_MASK_POS_5,
-	},
-	[DA9052_IRQ_ALARM] = {
-		.reg_offset = 0,
-		.mask = DA9052_IRQ_MASK_POS_6,
-	},
-	[DA9052_IRQ_SEQRDY] = {
-		.reg_offset = 0,
-		.mask = DA9052_IRQ_MASK_POS_7,
-	},
-	[DA9052_IRQ_COMP1V2] = {
-		.reg_offset = 0,
-		.mask = DA9052_IRQ_MASK_POS_8,
-	},
-	[DA9052_IRQ_NONKEY] = {
-		.reg_offset = 1,
-		.mask = DA9052_IRQ_MASK_POS_1,
-	},
-	[DA9052_IRQ_IDFLOAT] = {
-		.reg_offset = 1,
-		.mask = DA9052_IRQ_MASK_POS_2,
-	},
-	[DA9052_IRQ_IDGND] = {
-		.reg_offset = 1,
-		.mask = DA9052_IRQ_MASK_POS_3,
-	},
-	[DA9052_IRQ_CHGEND] = {
-		.reg_offset = 1,
-		.mask = DA9052_IRQ_MASK_POS_4,
-	},
-	[DA9052_IRQ_TBAT] = {
-		.reg_offset = 1,
-		.mask = DA9052_IRQ_MASK_POS_5,
-	},
-	[DA9052_IRQ_ADC_EOM] = {
-		.reg_offset = 1,
-		.mask = DA9052_IRQ_MASK_POS_6,
-	},
-	[DA9052_IRQ_PENDOWN] = {
-		.reg_offset = 1,
-		.mask = DA9052_IRQ_MASK_POS_7,
-	},
-	[DA9052_IRQ_TSIREADY] = {
-		.reg_offset = 1,
-		.mask = DA9052_IRQ_MASK_POS_8,
-	},
-	[DA9052_IRQ_GPI0] = {
-		.reg_offset = 2,
-		.mask = DA9052_IRQ_MASK_POS_1,
-	},
-	[DA9052_IRQ_GPI1] = {
-		.reg_offset = 2,
-		.mask = DA9052_IRQ_MASK_POS_2,
-	},
-	[DA9052_IRQ_GPI2] = {
-		.reg_offset = 2,
-		.mask = DA9052_IRQ_MASK_POS_3,
-	},
-	[DA9052_IRQ_GPI3] = {
-		.reg_offset = 2,
-		.mask = DA9052_IRQ_MASK_POS_4,
-	},
-	[DA9052_IRQ_GPI4] = {
-		.reg_offset = 2,
-		.mask = DA9052_IRQ_MASK_POS_5,
-	},
-	[DA9052_IRQ_GPI5] = {
-		.reg_offset = 2,
-		.mask = DA9052_IRQ_MASK_POS_6,
-	},
-	[DA9052_IRQ_GPI6] = {
-		.reg_offset = 2,
-		.mask = DA9052_IRQ_MASK_POS_7,
-	},
-	[DA9052_IRQ_GPI7] = {
-		.reg_offset = 2,
-		.mask = DA9052_IRQ_MASK_POS_8,
-	},
-	[DA9052_IRQ_GPI8] = {
-		.reg_offset = 3,
-		.mask = DA9052_IRQ_MASK_POS_1,
-	},
-	[DA9052_IRQ_GPI9] = {
-		.reg_offset = 3,
-		.mask = DA9052_IRQ_MASK_POS_2,
-	},
-	[DA9052_IRQ_GPI10] = {
-		.reg_offset = 3,
-		.mask = DA9052_IRQ_MASK_POS_3,
-	},
-	[DA9052_IRQ_GPI11] = {
-		.reg_offset = 3,
-		.mask = DA9052_IRQ_MASK_POS_4,
-	},
-	[DA9052_IRQ_GPI12] = {
-		.reg_offset = 3,
-		.mask = DA9052_IRQ_MASK_POS_5,
-	},
-	[DA9052_IRQ_GPI13] = {
-		.reg_offset = 3,
-		.mask = DA9052_IRQ_MASK_POS_6,
-	},
-	[DA9052_IRQ_GPI14] = {
-		.reg_offset = 3,
-		.mask = DA9052_IRQ_MASK_POS_7,
-	},
-	[DA9052_IRQ_GPI15] = {
-		.reg_offset = 3,
-		.mask = DA9052_IRQ_MASK_POS_8,
-	},
-};
-
-static struct regmap_irq_chip da9052_regmap_irq_chip = {
-	.name = "da9052_irq",
-	.status_base = DA9052_EVENT_A_REG,
-	.mask_base = DA9052_IRQ_MASK_A_REG,
-	.ack_base = DA9052_EVENT_A_REG,
-	.num_regs = DA9052_NUM_IRQ_REGS,
-	.irqs = da9052_irqs,
-	.num_irqs = ARRAY_SIZE(da9052_irqs),
-};
-
 struct regmap_config da9052_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -819,7 +536,7 @@ EXPORT_SYMBOL_GPL(da9052_regmap_config);
 int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 {
 	struct da9052_pdata *pdata = da9052->dev->platform_data;
-	int ret, i;
+	int ret;
 
 	mutex_init(&da9052->auxadc_lock);
 	init_completion(&da9052->done);
@@ -829,31 +546,12 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 
 	da9052->chip_id = chip_id;
 
-	/* Allocate a virtual IRQ domain to distribute to the regmap domains */
-	da9052->virq = irq_domain_add_linear(NULL, ARRAY_SIZE(da9052_irqs), 
-						&da9052_domain_ops, da9052);
-	if (!da9052->virq) {
-		ret = -EINVAL;
-		goto regmap_err;
+	ret = da9052_irq_init(da9052);
+	if (ret != 0) {
+		dev_err(da9052->dev, "da9052_irq_init failed: %d\n", ret);
+		return ret;
 	}
 
-	ret = regmap_add_irq_chip(da9052->regmap, 
-				  irq_create_mapping(da9052->virq, 1),
-				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				  -1, &da9052_regmap_irq_chip,
-				  &da9052->irq_data);
-	if (ret < 0) {
-		dev_err(da9052->dev, "regmap_add_irq_chip failed: %d\n", ret);
-		goto regmap_err;
-	}
-
-	i = da9052_map_irq(da9052, DA9052_IRQ_ADC_EOM);
-	ret = request_threaded_irq(i, NULL, da9052_auxadc_irq,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   "adc-irq", da9052);
-	if (ret != 0)
-		dev_err(da9052->dev, "DA9052 ADC IRQ failed ret=%d\n", ret);
-
 	ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
 			      ARRAY_SIZE(da9052_subdev_info), NULL, 0, NULL);
 	if (ret) {
@@ -864,20 +562,15 @@ int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 	return 0;
 
 err:
-	free_irq(da9052_map_irq(da9052, DA9052_IRQ_ADC_EOM), da9052);
-	regmap_del_irq_chip(irq_create_mapping(da9052->virq, 0),
-			    da9052->irq_data);
-	mfd_remove_devices(da9052->dev);
-regmap_err:
+	da9052_irq_exit(da9052);
+
 	return ret;
 }
 
 void da9052_device_exit(struct da9052 *da9052)
 {
-	free_irq(da9052_map_irq(da9052, DA9052_IRQ_ADC_EOM), da9052);
-	regmap_del_irq_chip(irq_create_mapping(da9052->virq, 0),
-			    da9052->irq_data);
 	mfd_remove_devices(da9052->dev);
+	da9052_irq_exit(da9052);
 }
 
 MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
diff --git a/drivers/mfd/da9052-irq.c b/drivers/mfd/da9052-irq.c
new file mode 100644
index 0000000..e5a14cf
--- /dev/null
+++ b/drivers/mfd/da9052-irq.c
@@ -0,0 +1,304 @@
+/*
+ * DA9052 interrupt support
+ *
+ * Author: Fabio Estevam <fabio.estevam@freescale.com>
+ * Based on arizona-irq.c, which is:
+ *
+ * Copyright 2012 Wolfson Microelectronics plc
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+#include <linux/mfd/da9052/da9052.h>
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
+static void da9052_irq_enable(struct irq_data *data)
+{
+}
+
+static void da9052_irq_disable(struct irq_data *data)
+{
+}
+
+static struct irq_chip da9052_irq_chip = {
+	.name			= "da9052",
+	.irq_disable		= da9052_irq_disable,
+	.irq_enable		= da9052_irq_enable,
+};
+
+static int da9052_irq_map(struct irq_domain *h, unsigned int virq,
+			      irq_hw_number_t hw)
+{
+	struct regmap_irq_chip_data *data = h->host_data;
+
+	irq_set_chip_data(virq, data);
+	irq_set_chip_and_handler(virq, &da9052_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
+
+	/*
+	 * ARM needs us to explicitly flag the IRQ as valid
+	 * and will set them noprobe when we do so.
+	 */
+#ifdef CONFIG_ARM
+	set_irq_flags(virq, IRQF_VALID);
+#else
+	irq_set_noprobe(virq);
+#endif
+
+	return 0;
+}
+
+static struct irq_domain_ops da9052_domain_ops = {
+	.map	= da9052_irq_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+static int da9052_map_irq(struct da9052 *da9052, int irq)
+{
+	return regmap_irq_get_virq(da9052->irq_data, irq);
+}
+
+int da9052_request_irq(struct da9052 *da9052, int irq, char *name,
+			   irq_handler_t handler, void *data)
+{
+	irq = da9052_map_irq(da9052, irq);
+	if (irq < 0)
+		return irq;
+
+	return request_threaded_irq(irq, NULL, handler,
+				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				     name, data);
+}
+EXPORT_SYMBOL_GPL(da9052_request_irq);
+
+void da9052_free_irq(struct da9052 *da9052, int irq, void *data)
+{
+	irq = da9052_map_irq(da9052, irq);
+	if (irq < 0)
+		return;
+
+	free_irq(irq, data);
+}
+EXPORT_SYMBOL_GPL(da9052_free_irq);
+
+static irqreturn_t da9052_auxadc_irq(int irq, void *irq_data)
+{
+	struct da9052 *da9052 = irq_data;
+
+	complete(&da9052->done);
+
+	return IRQ_HANDLED;
+}
+
+int da9052_irq_init(struct da9052 *da9052)
+{
+	int ret;
+
+	/* Allocate a virtual IRQ domain to distribute to the regmap domains */
+	da9052->virq = irq_domain_add_linear(NULL, ARRAY_SIZE(da9052_irqs),
+						&da9052_domain_ops, da9052);
+	if (!da9052->virq) {
+		ret = -EINVAL;
+		goto regmap_err;
+	}
+
+	ret = regmap_add_irq_chip(da9052->regmap,
+				  irq_create_mapping(da9052->virq, 0),
+				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				  -1, &da9052_regmap_irq_chip,
+				  &da9052->irq_data);
+	if (ret < 0) {
+		dev_err(da9052->dev, "regmap_add_irq_chip failed: %d\n", ret);
+		goto regmap_err;
+	}
+
+	ret = da9052_request_irq(da9052, DA9052_IRQ_ADC_EOM, "adc-irq",
+			    da9052_auxadc_irq, da9052);
+
+	if (ret != 0) {
+		dev_err(da9052->dev, "DA9052_IRQ_ADC_EOM failed: %d\n", ret);
+		goto request_irq_err;
+	}
+
+	return 0;
+
+request_irq_err:
+	regmap_del_irq_chip(irq_create_mapping(da9052->virq, 0),
+			    da9052->irq_data);
+regmap_err:
+	return ret;
+
+}
+
+int da9052_irq_exit(struct da9052 *da9052)
+{
+	da9052_free_irq(da9052, DA9052_IRQ_ADC_EOM , da9052);
+	regmap_del_irq_chip(irq_create_mapping(da9052->virq, 0),
+			    da9052->irq_data);
+
+	return 0;
+}
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 7fbcb6d..5deb64c 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -147,4 +147,10 @@ void da9052_device_exit(struct da9052 *da9052);
 
 extern struct regmap_config da9052_regmap_config;
 
+int da9052_irq_init(struct da9052 *da9052);
+int da9052_irq_exit(struct da9052 *da9052);
+int da9052_request_irq(struct da9052 *da9052, int irq, char *name,
+			   irq_handler_t handler, void *data);
+void da9052_free_irq(struct da9052 *da9052, int irq, void *data);
+
 #endif /* __MFD_DA9052_DA9052_H */
-- 
1.7.9.5

