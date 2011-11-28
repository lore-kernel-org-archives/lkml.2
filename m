Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1K1WrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:47:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33272 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725Ab1K1WrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:47:16 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert wm8994 to use generic regmap irq_chip
Date: Mon, 28 Nov 2011 22:47:07 +0000
Message-Id: <1322520427-13927-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20111128224017.GA13163@opensource.wolfsonmicro.com>
References: <20111128224017.GA13163@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the irq_chip implementation, substantially reducing the code
size for the driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig             |    1 +
 drivers/mfd/wm8994-irq.c        |  196 +++++++--------------------------------
 include/linux/mfd/wm8994/core.h |    3 +-
 3 files changed, 35 insertions(+), 165 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f1391c2..017f6db 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -477,6 +477,7 @@ config MFD_WM8994
 	bool "Support Wolfson Microelectronics WM8994"
 	select MFD_CORE
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  The WM8994 is a highly integrated hi-fi CODEC designed for
diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index f9dd6b6..46b20c4 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -18,238 +18,127 @@
 #include <linux/irq.h>
 #include <linux/mfd/core.h>
 #include <linux/interrupt.h>
+#include <linux/regmap.h>
 
 #include <linux/mfd/wm8994/core.h>
 #include <linux/mfd/wm8994/registers.h>
 
 #include <linux/delay.h>
 
-struct wm8994_irq_data {
-	int reg;
-	int mask;
-};
-
-static struct wm8994_irq_data wm8994_irqs[] = {
+static struct regmap_irq wm8994_irqs[] = {
 	[WM8994_IRQ_TEMP_SHUT] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_TEMP_SHUT_EINT,
 	},
 	[WM8994_IRQ_MIC1_DET] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_MIC1_DET_EINT,
 	},
 	[WM8994_IRQ_MIC1_SHRT] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_MIC1_SHRT_EINT,
 	},
 	[WM8994_IRQ_MIC2_DET] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_MIC2_DET_EINT,
 	},
 	[WM8994_IRQ_MIC2_SHRT] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_MIC2_SHRT_EINT,
 	},
 	[WM8994_IRQ_FLL1_LOCK] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_FLL1_LOCK_EINT,
 	},
 	[WM8994_IRQ_FLL2_LOCK] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_FLL2_LOCK_EINT,
 	},
 	[WM8994_IRQ_SRC1_LOCK] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_SRC1_LOCK_EINT,
 	},
 	[WM8994_IRQ_SRC2_LOCK] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_SRC2_LOCK_EINT,
 	},
 	[WM8994_IRQ_AIF1DRC1_SIG_DET] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_AIF1DRC1_SIG_DET,
 	},
 	[WM8994_IRQ_AIF1DRC2_SIG_DET] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_AIF1DRC2_SIG_DET_EINT,
 	},
 	[WM8994_IRQ_AIF2DRC_SIG_DET] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_AIF2DRC_SIG_DET_EINT,
 	},
 	[WM8994_IRQ_FIFOS_ERR] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_FIFOS_ERR_EINT,
 	},
 	[WM8994_IRQ_WSEQ_DONE] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_WSEQ_DONE_EINT,
 	},
 	[WM8994_IRQ_DCS_DONE] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_DCS_DONE_EINT,
 	},
 	[WM8994_IRQ_TEMP_WARN] = {
-		.reg = 2,
+		.reg_offset = 1,
 		.mask = WM8994_TEMP_WARN_EINT,
 	},
 	[WM8994_IRQ_GPIO(1)] = {
-		.reg = 1,
 		.mask = WM8994_GP1_EINT,
 	},
 	[WM8994_IRQ_GPIO(2)] = {
-		.reg = 1,
 		.mask = WM8994_GP2_EINT,
 	},
 	[WM8994_IRQ_GPIO(3)] = {
-		.reg = 1,
 		.mask = WM8994_GP3_EINT,
 	},
 	[WM8994_IRQ_GPIO(4)] = {
-		.reg = 1,
 		.mask = WM8994_GP4_EINT,
 	},
 	[WM8994_IRQ_GPIO(5)] = {
-		.reg = 1,
 		.mask = WM8994_GP5_EINT,
 	},
 	[WM8994_IRQ_GPIO(6)] = {
-		.reg = 1,
 		.mask = WM8994_GP6_EINT,
 	},
 	[WM8994_IRQ_GPIO(7)] = {
-		.reg = 1,
 		.mask = WM8994_GP7_EINT,
 	},
 	[WM8994_IRQ_GPIO(8)] = {
-		.reg = 1,
 		.mask = WM8994_GP8_EINT,
 	},
 	[WM8994_IRQ_GPIO(9)] = {
-		.reg = 1,
 		.mask = WM8994_GP8_EINT,
 	},
 	[WM8994_IRQ_GPIO(10)] = {
-		.reg = 1,
 		.mask = WM8994_GP10_EINT,
 	},
 	[WM8994_IRQ_GPIO(11)] = {
-		.reg = 1,
 		.mask = WM8994_GP11_EINT,
 	},
 };
 
-static inline struct wm8994_irq_data *irq_to_wm8994_irq(struct wm8994 *wm8994,
-							int irq)
-{
-	return &wm8994_irqs[irq - wm8994->irq_base];
-}
-
-static void wm8994_irq_lock(struct irq_data *data)
-{
-	struct wm8994 *wm8994 = irq_data_get_irq_chip_data(data);
-
-	mutex_lock(&wm8994->irq_lock);
-}
-
-static void wm8994_irq_sync_unlock(struct irq_data *data)
-{
-	struct wm8994 *wm8994 = irq_data_get_irq_chip_data(data);
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(wm8994->irq_masks_cur); i++) {
-		/* If there's been a change in the mask write it back
-		 * to the hardware. */
-		if (wm8994->irq_masks_cur[i] != wm8994->irq_masks_cache[i]) {
-			wm8994->irq_masks_cache[i] = wm8994->irq_masks_cur[i];
-			wm8994_reg_write(wm8994,
-					 WM8994_INTERRUPT_STATUS_1_MASK + i,
-					 wm8994->irq_masks_cur[i]);
-		}
-	}
-
-	mutex_unlock(&wm8994->irq_lock);
-}
-
-static void wm8994_irq_enable(struct irq_data *data)
-{
-	struct wm8994 *wm8994 = irq_data_get_irq_chip_data(data);
-	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994,
-							     data->irq);
-
-	wm8994->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
-}
-
-static void wm8994_irq_disable(struct irq_data *data)
-{
-	struct wm8994 *wm8994 = irq_data_get_irq_chip_data(data);
-	struct wm8994_irq_data *irq_data = irq_to_wm8994_irq(wm8994,
-							     data->irq);
-
-	wm8994->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
-}
+static struct regmap_irq_chip wm8994_irq_chip = {
+	.name = "wm8994",
+	.irqs = wm8994_irqs,
+	.num_irqs = ARRAY_SIZE(wm8994_irqs),
 
-static struct irq_chip wm8994_irq_chip = {
-	.name			= "wm8994",
-	.irq_bus_lock		= wm8994_irq_lock,
-	.irq_bus_sync_unlock	= wm8994_irq_sync_unlock,
-	.irq_disable		= wm8994_irq_disable,
-	.irq_enable		= wm8994_irq_enable,
+	.num_regs = 2,
+	.status_base = WM8994_INTERRUPT_STATUS_1,
+	.mask_base = WM8994_INTERRUPT_STATUS_1_MASK,
+	.ack_base = WM8994_INTERRUPT_STATUS_1,
 };
 
-/* The processing of the primary interrupt occurs in a thread so that
- * we can interact with the device over I2C or SPI. */
-static irqreturn_t wm8994_irq_thread(int irq, void *data)
-{
-	struct wm8994 *wm8994 = data;
-	unsigned int i;
-	u16 status[WM8994_NUM_IRQ_REGS];
-	int ret;
-
-	ret = wm8994_bulk_read(wm8994, WM8994_INTERRUPT_STATUS_1,
-			       WM8994_NUM_IRQ_REGS, status);
-	if (ret < 0) {
-		dev_err(wm8994->dev, "Failed to read interrupt status: %d\n",
-			ret);
-		return IRQ_NONE;
-	}
-
-	/* Bit swap and apply masking */
-	for (i = 0; i < WM8994_NUM_IRQ_REGS; i++) {
-		status[i] = be16_to_cpu(status[i]);
-		status[i] &= ~wm8994->irq_masks_cur[i];
-	}
-
-	/* Ack any unmasked IRQs */
-	for (i = 0; i < ARRAY_SIZE(status); i++) {
-		if (status[i])
-			wm8994_reg_write(wm8994, WM8994_INTERRUPT_STATUS_1 + i,
-					 status[i]);
-	}
-
-	/* Report */
-	for (i = 0; i < ARRAY_SIZE(wm8994_irqs); i++) {
-		if (status[wm8994_irqs[i].reg - 1] & wm8994_irqs[i].mask)
-			handle_nested_irq(wm8994->irq_base + i);
-	}
-
-	return IRQ_HANDLED;
-}
-
 int wm8994_irq_init(struct wm8994 *wm8994)
 {
-	int i, cur_irq, ret;
-
-	mutex_init(&wm8994->irq_lock);
-
-	/* Mask the individual interrupt sources */
-	for (i = 0; i < ARRAY_SIZE(wm8994->irq_masks_cur); i++) {
-		wm8994->irq_masks_cur[i] = 0xffff;
-		wm8994->irq_masks_cache[i] = 0xffff;
-		wm8994_reg_write(wm8994, WM8994_INTERRUPT_STATUS_1_MASK + i,
-				 0xffff);
-	}
+	int ret;
 
 	if (!wm8994->irq) {
 		dev_warn(wm8994->dev,
@@ -264,30 +153,12 @@ int wm8994_irq_init(struct wm8994 *wm8994)
 		return 0;
 	}
 
-	/* Register them with genirq */
-	for (cur_irq = wm8994->irq_base;
-	     cur_irq < ARRAY_SIZE(wm8994_irqs) + wm8994->irq_base;
-	     cur_irq++) {
-		irq_set_chip_data(cur_irq, wm8994);
-		irq_set_chip_and_handler(cur_irq, &wm8994_irq_chip,
-					 handle_edge_irq);
-		irq_set_nested_thread(cur_irq, 1);
-
-		/* ARM needs us to explicitly flag the IRQ as valid
-		 * and will set them noprobe when we do so. */
-#ifdef CONFIG_ARM
-		set_irq_flags(cur_irq, IRQF_VALID);
-#else
-		irq_set_noprobe(cur_irq);
-#endif
-	}
-
-	ret = request_threaded_irq(wm8994->irq, NULL, wm8994_irq_thread,
-				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-				   "wm8994", wm8994);
+	ret = regmap_add_irq_chip(wm8994->regmap, wm8994->irq,
+				  IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				  wm8994->irq_base, &wm8994_irq_chip,
+				  &wm8994->irq_data);
 	if (ret != 0) {
-		dev_err(wm8994->dev, "Failed to request IRQ %d: %d\n",
-			wm8994->irq, ret);
+		dev_err(wm8994->dev, "Failed to register IRQ chip: %d\n", ret);
 		return ret;
 	}
 
@@ -299,6 +170,5 @@ int wm8994_irq_init(struct wm8994 *wm8994)
 
 void wm8994_irq_exit(struct wm8994 *wm8994)
 {
-	if (wm8994->irq)
-		free_irq(wm8994->irq, wm8994);
+	regmap_del_irq_chip(wm8994->irq, wm8994->irq_data);
 }
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index d98593d..b9a44e7 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -65,8 +65,7 @@ struct wm8994 {
 	int irq_base;
 
 	int irq;
-	u16 irq_masks_cur[WM8994_NUM_IRQ_REGS];
-	u16 irq_masks_cache[WM8994_NUM_IRQ_REGS];
+	struct regmap_irq_chip_data *irq_data;
 
 	/* Used over suspend/resume */
 	bool suspended;
-- 
1.7.7.3

