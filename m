Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab2JKL4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:56:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59308 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758613Ab2JKLzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:55:46 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <peter.ujfalusi@ti.com>
Subject: [PATCH 5/6] MFD: twl6040: Convert to use regmap_irq
Date: Thu, 11 Oct 2012 13:55:32 +0200
Message-ID: <1349956533-6374-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
References: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With regmap_irq it is possibole to remove the twl6040-irq.c file and
simplify the code.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/Kconfig         |   4 +-
 drivers/mfd/Makefile        |   2 +-
 drivers/mfd/twl6040-core.c  |  55 ++++++++----
 drivers/mfd/twl6040-irq.c   | 205 --------------------------------------------
 include/linux/mfd/twl6040.h |  10 +--
 5 files changed, 48 insertions(+), 228 deletions(-)
 delete mode 100644 drivers/mfd/twl6040-irq.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index acab3ef..a0d0758 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -300,10 +300,10 @@ config MFD_TWL4030_AUDIO
 
 config TWL6040_CORE
 	bool "Support for TWL6040 audio codec"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y
 	select MFD_CORE
 	select REGMAP_I2C
-	select IRQ_DOMAIN
+	select REGMAP_IRQ
 	default n
 	help
 	  Say yes here if you want support for Texas Instruments TWL6040 audio
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index d8ccb63..360233f 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -63,7 +63,7 @@ obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
 obj-$(CONFIG_TWL4030_MADC)      += twl4030-madc.o
 obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 obj-$(CONFIG_MFD_TWL4030_AUDIO)	+= twl4030-audio.o
-obj-$(CONFIG_TWL6040_CORE)	+= twl6040-core.o twl6040-irq.o
+obj-$(CONFIG_TWL6040_CORE)	+= twl6040-core.o
 
 obj-$(CONFIG_MFD_MC13XXX)	+= mc13xxx-core.o
 obj-$(CONFIG_MFD_MC13XXX_SPI)	+= mc13xxx-spi.o
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 5817bc6..e5f7b79 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -499,6 +499,25 @@ static struct regmap_config twl6040_regmap_config = {
 	.readable_reg = twl6040_readable_reg,
 };
 
+static const struct regmap_irq twl6040_irqs[] = {
+	{ .reg_offset = 0, .mask = TWL6040_THINT, },
+	{ .reg_offset = 0, .mask = TWL6040_PLUGINT | TWL6040_UNPLUGINT, },
+	{ .reg_offset = 0, .mask = TWL6040_HOOKINT, },
+	{ .reg_offset = 0, .mask = TWL6040_HFINT, },
+	{ .reg_offset = 0, .mask = TWL6040_VIBINT, },
+	{ .reg_offset = 0, .mask = TWL6040_READYINT, },
+};
+
+static struct regmap_irq_chip twl6040_irq_chip = {
+	.name = "twl6040",
+	.irqs = twl6040_irqs,
+	.num_irqs = ARRAY_SIZE(twl6040_irqs),
+
+	.num_regs = 1,
+	.status_base = TWL6040_REG_INTID,
+	.mask_base = TWL6040_REG_INTMR,
+};
+
 static int __devinit twl6040_probe(struct i2c_client *client,
 				     const struct i2c_device_id *id)
 {
@@ -574,21 +593,27 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 			goto gpio_err;
 	}
 
-	/* codec interrupt */
-	ret = twl6040_irq_init(twl6040);
-	if (ret)
+	ret = regmap_add_irq_chip(twl6040->regmap, twl6040->irq,
+			IRQF_ONESHOT, 0, &twl6040_irq_chip,
+			&twl6040->irq_data);
+	if (ret < 0)
 		goto irq_init_err;
 
-	ret = request_threaded_irq(twl6040->irq_base + TWL6040_IRQ_READY,
-				   NULL, twl6040_readyint_handler, IRQF_ONESHOT,
+	twl6040->irq_ready = regmap_irq_get_virq(twl6040->irq_data,
+					       TWL6040_IRQ_READY);
+	twl6040->irq_th = regmap_irq_get_virq(twl6040->irq_data,
+					       TWL6040_IRQ_TH);
+
+	ret = request_threaded_irq(twl6040->irq_ready, NULL,
+				   twl6040_readyint_handler, IRQF_ONESHOT,
 				   "twl6040_irq_ready", twl6040);
 	if (ret) {
 		dev_err(twl6040->dev, "READY IRQ request failed: %d\n", ret);
 		goto readyirq_err;
 	}
 
-	ret = request_threaded_irq(twl6040->irq_base + TWL6040_IRQ_TH,
-				   NULL, twl6040_thint_handler, IRQF_ONESHOT,
+	ret = request_threaded_irq(twl6040->irq_th, NULL,
+				   twl6040_thint_handler, IRQF_ONESHOT,
 				   "twl6040_irq_th", twl6040);
 	if (ret) {
 		dev_err(twl6040->dev, "Thermal IRQ request failed: %d\n", ret);
@@ -604,7 +629,7 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	 * The ASoC codec can work without pdata, pass the platform_data only if
 	 * it has been provided.
 	 */
-	irq = twl6040->irq_base + TWL6040_IRQ_PLUG;
+	irq = regmap_irq_get_virq(twl6040->irq_data, TWL6040_IRQ_PLUG);
 	cell = &twl6040->cells[children];
 	cell->name = "twl6040-codec";
 	twl6040_codec_rsrc[0].start = irq;
@@ -618,7 +643,7 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	children++;
 
 	if (twl6040_has_vibra(pdata, node)) {
-		irq = twl6040->irq_base + TWL6040_IRQ_VIB;
+		irq = regmap_irq_get_virq(twl6040->irq_data, TWL6040_IRQ_VIB);
 
 		cell = &twl6040->cells[children];
 		cell->name = "twl6040-vibra";
@@ -657,11 +682,11 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	return 0;
 
 mfd_err:
-	free_irq(twl6040->irq_base + TWL6040_IRQ_TH, twl6040);
+	free_irq(twl6040->irq_th, twl6040);
 thirq_err:
-	free_irq(twl6040->irq_base + TWL6040_IRQ_READY, twl6040);
+	free_irq(twl6040->irq_ready, twl6040);
 readyirq_err:
-	twl6040_irq_exit(twl6040);
+	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
 irq_init_err:
 	if (gpio_is_valid(twl6040->audpwron))
 		gpio_free(twl6040->audpwron);
@@ -685,9 +710,9 @@ static int __devexit twl6040_remove(struct i2c_client *client)
 	if (gpio_is_valid(twl6040->audpwron))
 		gpio_free(twl6040->audpwron);
 
-	free_irq(twl6040->irq_base + TWL6040_IRQ_READY, twl6040);
-	free_irq(twl6040->irq_base + TWL6040_IRQ_TH, twl6040);
-	twl6040_irq_exit(twl6040);
+	free_irq(twl6040->irq_ready, twl6040);
+	free_irq(twl6040->irq_th, twl6040);
+	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
 
 	mfd_remove_devices(&client->dev);
 	i2c_set_clientdata(client, NULL);
diff --git a/drivers/mfd/twl6040-irq.c b/drivers/mfd/twl6040-irq.c
deleted file mode 100644
index 4b42543..0000000
--- a/drivers/mfd/twl6040-irq.c
+++ /dev/null
@@ -1,205 +0,0 @@
-/*
- * Interrupt controller support for TWL6040
- *
- * Author:     Misael Lopez Cruz <misael.lopez@ti.com>
- *
- * Copyright:   (C) 2011 Texas Instruments, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/err.h>
-#include <linux/irq.h>
-#include <linux/of.h>
-#include <linux/irqdomain.h>
-#include <linux/interrupt.h>
-#include <linux/mfd/core.h>
-#include <linux/mfd/twl6040.h>
-
-struct twl6040_irq_data {
-	int mask;
-	int status;
-};
-
-static struct twl6040_irq_data twl6040_irqs[] = {
-	{
-		.mask = TWL6040_THMSK,
-		.status = TWL6040_THINT,
-	},
-	{
-		.mask = TWL6040_PLUGMSK,
-		.status = TWL6040_PLUGINT | TWL6040_UNPLUGINT,
-	},
-	{
-		.mask = TWL6040_HOOKMSK,
-		.status = TWL6040_HOOKINT,
-	},
-	{
-		.mask = TWL6040_HFMSK,
-		.status = TWL6040_HFINT,
-	},
-	{
-		.mask = TWL6040_VIBMSK,
-		.status = TWL6040_VIBINT,
-	},
-	{
-		.mask = TWL6040_READYMSK,
-		.status = TWL6040_READYINT,
-	},
-};
-
-static inline
-struct twl6040_irq_data *irq_to_twl6040_irq(struct twl6040 *twl6040,
-					    int irq)
-{
-	return &twl6040_irqs[irq - twl6040->irq_base];
-}
-
-static void twl6040_irq_lock(struct irq_data *data)
-{
-	struct twl6040 *twl6040 = irq_data_get_irq_chip_data(data);
-
-	mutex_lock(&twl6040->irq_mutex);
-}
-
-static void twl6040_irq_sync_unlock(struct irq_data *data)
-{
-	struct twl6040 *twl6040 = irq_data_get_irq_chip_data(data);
-
-	/* write back to hardware any change in irq mask */
-	if (twl6040->irq_masks_cur != twl6040->irq_masks_cache) {
-		twl6040->irq_masks_cache = twl6040->irq_masks_cur;
-		twl6040_reg_write(twl6040, TWL6040_REG_INTMR,
-				  twl6040->irq_masks_cur);
-	}
-
-	mutex_unlock(&twl6040->irq_mutex);
-}
-
-static void twl6040_irq_enable(struct irq_data *data)
-{
-	struct twl6040 *twl6040 = irq_data_get_irq_chip_data(data);
-	struct twl6040_irq_data *irq_data = irq_to_twl6040_irq(twl6040,
-							       data->irq);
-
-	twl6040->irq_masks_cur &= ~irq_data->mask;
-}
-
-static void twl6040_irq_disable(struct irq_data *data)
-{
-	struct twl6040 *twl6040 = irq_data_get_irq_chip_data(data);
-	struct twl6040_irq_data *irq_data = irq_to_twl6040_irq(twl6040,
-							       data->irq);
-
-	twl6040->irq_masks_cur |= irq_data->mask;
-}
-
-static struct irq_chip twl6040_irq_chip = {
-	.name			= "twl6040",
-	.irq_bus_lock		= twl6040_irq_lock,
-	.irq_bus_sync_unlock	= twl6040_irq_sync_unlock,
-	.irq_enable		= twl6040_irq_enable,
-	.irq_disable		= twl6040_irq_disable,
-};
-
-static irqreturn_t twl6040_irq_thread(int irq, void *data)
-{
-	struct twl6040 *twl6040 = data;
-	u8 intid;
-	int i;
-
-	intid = twl6040_reg_read(twl6040, TWL6040_REG_INTID);
-
-	/* apply masking and report (backwards to handle READYINT first) */
-	for (i = ARRAY_SIZE(twl6040_irqs) - 1; i >= 0; i--) {
-		if (twl6040->irq_masks_cur & twl6040_irqs[i].mask)
-			intid &= ~twl6040_irqs[i].status;
-		if (intid & twl6040_irqs[i].status)
-			handle_nested_irq(twl6040->irq_base + i);
-	}
-
-	/* ack unmasked irqs */
-	twl6040_reg_write(twl6040, TWL6040_REG_INTID, intid);
-
-	return IRQ_HANDLED;
-}
-
-int twl6040_irq_init(struct twl6040 *twl6040)
-{
-	struct device_node *node = twl6040->dev->of_node;
-	int i, nr_irqs, irq_base, ret;
-	u8 val;
-
-	mutex_init(&twl6040->irq_mutex);
-
-	/* mask the individual interrupt sources */
-	twl6040->irq_masks_cur = TWL6040_ALLINT_MSK;
-	twl6040->irq_masks_cache = TWL6040_ALLINT_MSK;
-	twl6040_reg_write(twl6040, TWL6040_REG_INTMR, TWL6040_ALLINT_MSK);
-
-	nr_irqs = ARRAY_SIZE(twl6040_irqs);
-
-	irq_base = irq_alloc_descs(-1, 0, nr_irqs, 0);
-	if (IS_ERR_VALUE(irq_base)) {
-		dev_err(twl6040->dev, "Fail to allocate IRQ descs\n");
-		return irq_base;
-	}
-	twl6040->irq_base = irq_base;
-
-	irq_domain_add_legacy(node, ARRAY_SIZE(twl6040_irqs), irq_base, 0,
-			      &irq_domain_simple_ops, NULL);
-
-	/* Register them with genirq */
-	for (i = irq_base; i < irq_base + nr_irqs; i++) {
-		irq_set_chip_data(i, twl6040);
-		irq_set_chip_and_handler(i, &twl6040_irq_chip,
-					 handle_level_irq);
-		irq_set_nested_thread(i, 1);
-
-		/* ARM needs us to explicitly flag the IRQ as valid
-		 * and will set them noprobe when we do so. */
-#ifdef CONFIG_ARM
-		set_irq_flags(i, IRQF_VALID);
-#else
-		irq_set_noprobe(i);
-#endif
-	}
-
-	ret = request_threaded_irq(twl6040->irq, NULL, twl6040_irq_thread,
-				   IRQF_ONESHOT, "twl6040", twl6040);
-	if (ret) {
-		dev_err(twl6040->dev, "failed to request IRQ %d: %d\n",
-			twl6040->irq, ret);
-		return ret;
-	}
-
-	/* reset interrupts */
-	val = twl6040_reg_read(twl6040, TWL6040_REG_INTID);
-
-	/* interrupts cleared on write */
-	twl6040_clear_bits(twl6040, TWL6040_REG_ACCCTL, TWL6040_INTCLRMODE);
-
-	return 0;
-}
-EXPORT_SYMBOL(twl6040_irq_init);
-
-void twl6040_irq_exit(struct twl6040 *twl6040)
-{
-	free_irq(twl6040->irq, twl6040);
-}
-EXPORT_SYMBOL(twl6040_irq_exit);
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index a8eff4a..94ac944 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -207,10 +207,12 @@ struct twl6040_platform_data {
 };
 
 struct regmap;
+struct regmap_irq_chips_data;
 
 struct twl6040 {
 	struct device *dev;
 	struct regmap *regmap;
+	struct regmap_irq_chip_data *irq_data;
 	struct regulator_bulk_data supplies[2]; /* supplies for vio, v2v1 */
 	struct mutex mutex;
 	struct mutex irq_mutex;
@@ -228,9 +230,8 @@ struct twl6040 {
 	unsigned int mclk;
 
 	unsigned int irq;
-	unsigned int irq_base;
-	u8 irq_masks_cur;
-	u8 irq_masks_cache;
+	unsigned int irq_ready;
+	unsigned int irq_th;
 };
 
 int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg);
@@ -245,8 +246,7 @@ int twl6040_set_pll(struct twl6040 *twl6040, int pll_id,
 		    unsigned int freq_in, unsigned int freq_out);
 int twl6040_get_pll(struct twl6040 *twl6040);
 unsigned int twl6040_get_sysclk(struct twl6040 *twl6040);
-int twl6040_irq_init(struct twl6040 *twl6040);
-void twl6040_irq_exit(struct twl6040 *twl6040);
+
 /* Get the combined status of the vibra control register */
 int twl6040_get_vibralr_status(struct twl6040 *twl6040);
 
-- 
1.7.12

