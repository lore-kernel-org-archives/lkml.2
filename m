Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab2KMOH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:07:56 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2448 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab2KMOHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:07:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Nov 2012 06:06:59 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND V3 2/4] mfd: tps65910: use regmap irq framework for interrupt support
Date: Tue, 13 Nov 2012 19:33:57 +0530
Message-ID: <1352815439-26040-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
References: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement irq support of tps65910 with regmap irq framework
in place of implementing locally.
This reduces the code size significantly and easy to maintain.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
No change from V1, just rearrange this patch.
It was already reviwed by Mark and hence adding his reviewed by.
  
No change from V2.

 drivers/mfd/tps65910-irq.c   |  375 ++++++++++++++++++++----------------------
 include/linux/mfd/tps65910.h |  139 +++++++++++-----
 2 files changed, 278 insertions(+), 236 deletions(-)

diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
index 09aab3e..554543a 100644
--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -24,171 +24,184 @@
 #include <linux/gpio.h>
 #include <linux/mfd/tps65910.h>
 
-/*
- * This is a threaded IRQ handler so can access I2C/SPI.  Since all
- * interrupts are clear on read the IRQ line will be reasserted and
- * the physical IRQ will be handled again if another interrupt is
- * asserted while we run - in the normal course of events this is a
- * rare occurrence so we save I2C/SPI reads.  We're also assuming that
- * it's rare to get lots of interrupts firing simultaneously so try to
- * minimise I/O.
- */
-static irqreturn_t tps65910_irq(int irq, void *irq_data)
-{
-	struct tps65910 *tps65910 = irq_data;
-	unsigned int reg;
-	u32 irq_sts;
-	u32 irq_mask;
-	int i;
-
-	tps65910_reg_read(tps65910, TPS65910_INT_STS, &reg);
-	irq_sts = reg;
-	tps65910_reg_read(tps65910, TPS65910_INT_STS2, &reg);
-	irq_sts |= reg << 8;
-	switch (tps65910_chip_id(tps65910)) {
-	case TPS65911:
-		tps65910_reg_read(tps65910, TPS65910_INT_STS3, &reg);
-		irq_sts |= reg << 16;
-	}
-
-	tps65910_reg_read(tps65910, TPS65910_INT_MSK, &reg);
-	irq_mask = reg;
-	tps65910_reg_read(tps65910, TPS65910_INT_MSK2, &reg);
-	irq_mask |= reg << 8;
-	switch (tps65910_chip_id(tps65910)) {
-	case TPS65911:
-		tps65910_reg_read(tps65910, TPS65910_INT_MSK3, &reg);
-		irq_mask |= reg << 16;
-	}
-
-	irq_sts &= ~irq_mask;
-
-	if (!irq_sts)
-		return IRQ_NONE;
-
-	for (i = 0; i < tps65910->irq_num; i++) {
-
-		if (!(irq_sts & (1 << i)))
-			continue;
-
-		handle_nested_irq(irq_find_mapping(tps65910->domain, i));
-	}
-
-	/* Write the STS register back to clear IRQs we handled */
-	reg = irq_sts & 0xFF;
-	irq_sts >>= 8;
-	tps65910_reg_write(tps65910, TPS65910_INT_STS, reg);
-	reg = irq_sts & 0xFF;
-	tps65910_reg_write(tps65910, TPS65910_INT_STS2, reg);
-	switch (tps65910_chip_id(tps65910)) {
-	case TPS65911:
-		reg = irq_sts >> 8;
-		tps65910_reg_write(tps65910, TPS65910_INT_STS3, reg);
-	}
-
-	return IRQ_HANDLED;
-}
-
-static void tps65910_irq_lock(struct irq_data *data)
-{
-	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
-
-	mutex_lock(&tps65910->irq_lock);
-}
-
-static void tps65910_irq_sync_unlock(struct irq_data *data)
-{
-	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
-	u32 reg_mask;
-	unsigned int reg;
-
-	tps65910_reg_read(tps65910, TPS65910_INT_MSK, &reg);
-	reg_mask = reg;
-	tps65910_reg_read(tps65910, TPS65910_INT_MSK2, &reg);
-	reg_mask |= reg << 8;
-	switch (tps65910_chip_id(tps65910)) {
-	case TPS65911:
-		tps65910_reg_read(tps65910, TPS65910_INT_MSK3, &reg);
-		reg_mask |= reg << 16;
-	}
 
-	if (tps65910->irq_mask != reg_mask) {
-		reg = tps65910->irq_mask & 0xFF;
-		tps65910_reg_write(tps65910, TPS65910_INT_MSK, reg);
-		reg = tps65910->irq_mask >> 8 & 0xFF;
-		tps65910_reg_write(tps65910, TPS65910_INT_MSK2, reg);
-		switch (tps65910_chip_id(tps65910)) {
-		case TPS65911:
-			reg = tps65910->irq_mask >> 16;
-			tps65910_reg_write(tps65910, TPS65910_INT_MSK3, reg);
-		}
-	}
-	mutex_unlock(&tps65910->irq_lock);
-}
-
-static void tps65910_irq_enable(struct irq_data *data)
-{
-	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
-
-	tps65910->irq_mask &= ~(1 << data->hwirq);
-}
-
-static void tps65910_irq_disable(struct irq_data *data)
-{
-	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
-
-	tps65910->irq_mask |= (1 << data->hwirq);
-}
+static const struct regmap_irq tps65911_irqs[] = {
+	/* INT_STS */
+	[TPS65911_IRQ_PWRHOLD_F] = {
+		.mask = INT_MSK_PWRHOLD_F_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65911_IRQ_VBAT_VMHI] = {
+		.mask = INT_MSK_VMBHI_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65911_IRQ_PWRON] = {
+		.mask = INT_MSK_PWRON_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65911_IRQ_PWRON_LP] = {
+		.mask = INT_MSK_PWRON_LP_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65911_IRQ_PWRHOLD_R] = {
+		.mask = INT_MSK_PWRHOLD_R_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65911_IRQ_HOTDIE] = {
+		.mask = INT_MSK_HOTDIE_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65911_IRQ_RTC_ALARM] = {
+		.mask = INT_MSK_RTC_ALARM_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65911_IRQ_RTC_PERIOD] = {
+		.mask = INT_MSK_RTC_PERIOD_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+
+	/* INT_STS2 */
+	[TPS65911_IRQ_GPIO0_R] = {
+		.mask = INT_MSK2_GPIO0_R_IT_MSK_MASK,
+		.reg_offset = 1,
+	},
+	[TPS65911_IRQ_GPIO0_F] = {
+		.mask = INT_MSK2_GPIO0_F_IT_MSK_MASK,
+		.reg_offset = 1,
+	},
+	[TPS65911_IRQ_GPIO1_R] = {
+		.mask = INT_MSK2_GPIO1_R_IT_MSK_MASK,
+		.reg_offset = 1,
+	},
+	[TPS65911_IRQ_GPIO1_F] = {
+		.mask = INT_MSK2_GPIO1_F_IT_MSK_MASK,
+		.reg_offset = 1,
+	},
+	[TPS65911_IRQ_GPIO2_R] = {
+		.mask = INT_MSK2_GPIO2_R_IT_MSK_MASK,
+		.reg_offset = 1,
+	},
+	[TPS65911_IRQ_GPIO2_F] = {
+		.mask = INT_MSK2_GPIO2_F_IT_MSK_MASK,
+		.reg_offset = 1,
+	},
+	[TPS65911_IRQ_GPIO3_R] = {
+		.mask = INT_MSK2_GPIO3_R_IT_MSK_MASK,
+		.reg_offset = 1,
+	},
+	[TPS65911_IRQ_GPIO3_F] = {
+		.mask = INT_MSK2_GPIO3_F_IT_MSK_MASK,
+		.reg_offset = 1,
+	},
+
+	/* INT_STS3 */
+	[TPS65911_IRQ_GPIO4_R] = {
+		.mask = INT_MSK3_GPIO4_R_IT_MSK_MASK,
+		.reg_offset = 2,
+	},
+	[TPS65911_IRQ_GPIO4_F] = {
+		.mask = INT_MSK3_GPIO4_F_IT_MSK_MASK,
+		.reg_offset = 2,
+	},
+	[TPS65911_IRQ_GPIO5_R] = {
+		.mask = INT_MSK3_GPIO5_R_IT_MSK_MASK,
+		.reg_offset = 2,
+	},
+	[TPS65911_IRQ_GPIO5_F] = {
+		.mask = INT_MSK3_GPIO5_F_IT_MSK_MASK,
+		.reg_offset = 2,
+	},
+	[TPS65911_IRQ_WTCHDG] = {
+		.mask = INT_MSK3_WTCHDG_IT_MSK_MASK,
+		.reg_offset = 2,
+	},
+	[TPS65911_IRQ_VMBCH2_H] = {
+		.mask = INT_MSK3_VMBCH2_H_IT_MSK_MASK,
+		.reg_offset = 2,
+	},
+	[TPS65911_IRQ_VMBCH2_L] = {
+		.mask = INT_MSK3_VMBCH2_L_IT_MSK_MASK,
+		.reg_offset = 2,
+	},
+	[TPS65911_IRQ_PWRDN] = {
+		.mask = INT_MSK3_PWRDN_IT_MSK_MASK,
+		.reg_offset = 2,
+	},
+};
 
-#ifdef CONFIG_PM_SLEEP
-static int tps65910_irq_set_wake(struct irq_data *data, unsigned int enable)
-{
-	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
-	return irq_set_irq_wake(tps65910->chip_irq, enable);
-}
-#else
-#define tps65910_irq_set_wake NULL
-#endif
+static const struct regmap_irq tps65910_irqs[] = {
+	/* INT_STS */
+	[TPS65910_IRQ_VBAT_VMBDCH] = {
+		.mask = TPS65910_INT_MSK_VMBDCH_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65910_IRQ_VBAT_VMHI] = {
+		.mask = TPS65910_INT_MSK_VMBHI_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65910_IRQ_PWRON] = {
+		.mask = TPS65910_INT_MSK_PWRON_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65910_IRQ_PWRON_LP] = {
+		.mask = TPS65910_INT_MSK_PWRON_LP_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65910_IRQ_PWRHOLD] = {
+		.mask = TPS65910_INT_MSK_PWRHOLD_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65910_IRQ_HOTDIE] = {
+		.mask = TPS65910_INT_MSK_HOTDIE_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65910_IRQ_RTC_ALARM] = {
+		.mask = TPS65910_INT_MSK_RTC_ALARM_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+	[TPS65910_IRQ_RTC_PERIOD] = {
+		.mask = TPS65910_INT_MSK_RTC_PERIOD_IT_MSK_MASK,
+		.reg_offset = 0,
+	},
+
+	/* INT_STS2 */
+	[TPS65910_IRQ_GPIO_R] = {
+		.mask = TPS65910_INT_MSK2_GPIO0_F_IT_MSK_MASK,
+		.reg_offset = 1,
+	},
+	[TPS65910_IRQ_GPIO_F] = {
+		.mask = TPS65910_INT_MSK2_GPIO0_R_IT_MSK_MASK,
+		.reg_offset = 1,
+	},
+};
 
-static struct irq_chip tps65910_irq_chip = {
+static struct regmap_irq_chip tps65911_irq_chip = {
 	.name = "tps65910",
-	.irq_bus_lock = tps65910_irq_lock,
-	.irq_bus_sync_unlock = tps65910_irq_sync_unlock,
-	.irq_disable = tps65910_irq_disable,
-	.irq_enable = tps65910_irq_enable,
-	.irq_set_wake = tps65910_irq_set_wake,
+	.irqs = tps65911_irqs,
+	.num_irqs = ARRAY_SIZE(tps65911_irqs),
+	.num_regs = 3,
+	.irq_reg_stride = 2,
+	.status_base = TPS65910_INT_STS,
+	.mask_base = TPS65910_INT_MSK,
+	.ack_base = TPS65910_INT_MSK,
 };
 
-static int tps65910_irq_map(struct irq_domain *h, unsigned int virq,
-				irq_hw_number_t hw)
-{
-	struct tps65910 *tps65910 = h->host_data;
-
-	irq_set_chip_data(virq, tps65910);
-	irq_set_chip_and_handler(virq, &tps65910_irq_chip, handle_edge_irq);
-	irq_set_nested_thread(virq, 1);
-
-	/* ARM needs us to explicitly flag the IRQ as valid
-	 * and will set them noprobe when we do so. */
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
-	irq_set_noprobe(virq);
-#endif
-
-	return 0;
-}
-
-static struct irq_domain_ops tps65910_domain_ops = {
-	.map	= tps65910_irq_map,
-	.xlate	= irq_domain_xlate_twocell,
+static struct regmap_irq_chip tps65910_irq_chip = {
+	.name = "tps65910",
+	.irqs = tps65910_irqs,
+	.num_irqs = ARRAY_SIZE(tps65910_irqs),
+	.num_regs = 2,
+	.irq_reg_stride = 2,
+	.status_base = TPS65910_INT_STS,
+	.mask_base = TPS65910_INT_MSK,
+	.ack_base = TPS65910_INT_MSK,
 };
 
 int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		    struct tps65910_platform_data *pdata)
 {
-	int ret;
-	int flags = IRQF_ONESHOT;
+	int ret = 0;
+	static struct regmap_irq_chip *tps6591x_irqs_chip;
 
 	if (!irq) {
 		dev_warn(tps65910->dev, "No interrupt support, no core IRQ\n");
@@ -200,61 +213,31 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		return -EINVAL;
 	}
 
+
 	switch (tps65910_chip_id(tps65910)) {
 	case TPS65910:
-		tps65910->irq_num = TPS65910_NUM_IRQ;
+		tps6591x_irqs_chip = &tps65910_irq_chip;
 		break;
 	case TPS65911:
-		tps65910->irq_num = TPS65911_NUM_IRQ;
+		tps6591x_irqs_chip = &tps65911_irq_chip;
 		break;
 	}
 
-	if (pdata->irq_base > 0) {
-		pdata->irq_base = irq_alloc_descs(pdata->irq_base, 0,
-					tps65910->irq_num, -1);
-		if (pdata->irq_base < 0) {
-			dev_warn(tps65910->dev, "Failed to alloc IRQs: %d\n",
-					pdata->irq_base);
-			return pdata->irq_base;
-		}
-	}
-
-	tps65910->irq_mask = 0xFFFFFF;
-
-	mutex_init(&tps65910->irq_lock);
 	tps65910->chip_irq = irq;
-	tps65910->irq_base = pdata->irq_base;
-
-	if (pdata->irq_base > 0)
-		tps65910->domain = irq_domain_add_legacy(tps65910->dev->of_node,
-					tps65910->irq_num,
-					pdata->irq_base,
-					0,
-					&tps65910_domain_ops, tps65910);
-	else
-		tps65910->domain = irq_domain_add_linear(tps65910->dev->of_node,
-					tps65910->irq_num,
-					&tps65910_domain_ops, tps65910);
-
-	if (!tps65910->domain) {
-		dev_err(tps65910->dev, "Failed to create IRQ domain\n");
-		return -ENOMEM;
+	ret = regmap_add_irq_chip(tps65910->regmap, tps65910->chip_irq,
+		IRQF_ONESHOT, pdata->irq_base,
+		tps6591x_irqs_chip, &tps65910->irq_data);
+	if (ret < 0) {
+		dev_warn(tps65910->dev,
+				"Failed to add irq_chip %d\n", ret);
+		return ret;
 	}
-
-	ret = request_threaded_irq(irq, NULL, tps65910_irq, flags,
-				   "tps65910", tps65910);
-
-	irq_set_irq_type(irq, IRQ_TYPE_LEVEL_LOW);
-
-	if (ret != 0)
-		dev_err(tps65910->dev, "Failed to request IRQ: %d\n", ret);
-
 	return ret;
 }
 
 int tps65910_irq_exit(struct tps65910 *tps65910)
 {
-	if (tps65910->chip_irq)
-		free_irq(tps65910->chip_irq, tps65910);
+	if (tps65910->chip_irq > 0)
+		regmap_del_irq_chip(tps65910->chip_irq, tps65910->irq_data);
 	return 0;
 }
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 02e894f..b564ac2 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -572,6 +572,49 @@
 #define SPARE_SPARE_MASK				0xFF
 #define SPARE_SPARE_SHIFT				0
 
+#define TPS65910_INT_STS_RTC_PERIOD_IT_MASK			0x80
+#define TPS65910_INT_STS_RTC_PERIOD_IT_SHIFT			7
+#define TPS65910_INT_STS_RTC_ALARM_IT_MASK			0x40
+#define TPS65910_INT_STS_RTC_ALARM_IT_SHIFT			6
+#define TPS65910_INT_STS_HOTDIE_IT_MASK				0x20
+#define TPS65910_INT_STS_HOTDIE_IT_SHIFT			5
+#define TPS65910_INT_STS_PWRHOLD_F_IT_MASK			0x10
+#define TPS65910_INT_STS_PWRHOLD_F_IT_SHIFT			4
+#define TPS65910_INT_STS_PWRON_LP_IT_MASK			0x08
+#define TPS65910_INT_STS_PWRON_LP_IT_SHIFT			3
+#define TPS65910_INT_STS_PWRON_IT_MASK				0x04
+#define TPS65910_INT_STS_PWRON_IT_SHIFT				2
+#define TPS65910_INT_STS_VMBHI_IT_MASK				0x02
+#define TPS65910_INT_STS_VMBHI_IT_SHIFT				1
+#define TPS65910_INT_STS_VMBDCH_IT_MASK				0x01
+#define TPS65910_INT_STS_VMBDCH_IT_SHIFT			0
+
+#define TPS65910_INT_MSK_RTC_PERIOD_IT_MSK_MASK			0x80
+#define TPS65910_INT_MSK_RTC_PERIOD_IT_MSK_SHIFT		7
+#define TPS65910_INT_MSK_RTC_ALARM_IT_MSK_MASK			0x40
+#define TPS65910_INT_MSK_RTC_ALARM_IT_MSK_SHIFT			6
+#define TPS65910_INT_MSK_HOTDIE_IT_MSK_MASK			0x20
+#define TPS65910_INT_MSK_HOTDIE_IT_MSK_SHIFT			5
+#define TPS65910_INT_MSK_PWRHOLD_IT_MSK_MASK			0x10
+#define TPS65910_INT_MSK_PWRHOLD_IT_MSK_SHIFT			4
+#define TPS65910_INT_MSK_PWRON_LP_IT_MSK_MASK			0x08
+#define TPS65910_INT_MSK_PWRON_LP_IT_MSK_SHIFT			3
+#define TPS65910_INT_MSK_PWRON_IT_MSK_MASK			0x04
+#define TPS65910_INT_MSK_PWRON_IT_MSK_SHIFT			2
+#define TPS65910_INT_MSK_VMBHI_IT_MSK_MASK			0x02
+#define TPS65910_INT_MSK_VMBHI_IT_MSK_SHIFT			1
+#define TPS65910_INT_MSK_VMBDCH_IT_MSK_MASK			0x01
+#define TPS65910_INT_MSK_VMBDCH_IT_MSK_SHIFT			0
+
+#define TPS65910_INT_STS2_GPIO0_F_IT_SHIFT			2
+#define TPS65910_INT_STS2_GPIO0_F_IT_MASK			0x02
+#define TPS65910_INT_STS2_GPIO0_R_IT_SHIFT			1
+#define TPS65910_INT_STS2_GPIO0_R_IT_MASK			0x01
+
+#define TPS65910_INT_MSK2_GPIO0_F_IT_MSK_SHIFT			2
+#define TPS65910_INT_MSK2_GPIO0_F_IT_MSK_MASK			0x02
+#define TPS65910_INT_MSK2_GPIO0_R_IT_MSK_SHIFT			1
+#define TPS65910_INT_MSK2_GPIO0_R_IT_MSK_MASK			0x01
 
 /*Register INT_STS  (0x80) register.RegisterDescription */
 #define INT_STS_RTC_PERIOD_IT_MASK			0x80
@@ -580,16 +623,16 @@
 #define INT_STS_RTC_ALARM_IT_SHIFT			6
 #define INT_STS_HOTDIE_IT_MASK				0x20
 #define INT_STS_HOTDIE_IT_SHIFT				5
-#define INT_STS_PWRHOLD_IT_MASK				0x10
-#define INT_STS_PWRHOLD_IT_SHIFT			4
+#define INT_STS_PWRHOLD_R_IT_MASK			0x10
+#define INT_STS_PWRHOLD_R_IT_SHIFT			4
 #define INT_STS_PWRON_LP_IT_MASK			0x08
 #define INT_STS_PWRON_LP_IT_SHIFT			3
 #define INT_STS_PWRON_IT_MASK				0x04
 #define INT_STS_PWRON_IT_SHIFT				2
 #define INT_STS_VMBHI_IT_MASK				0x02
 #define INT_STS_VMBHI_IT_SHIFT				1
-#define INT_STS_VMBDCH_IT_MASK				0x01
-#define INT_STS_VMBDCH_IT_SHIFT				0
+#define INT_STS_PWRHOLD_F_IT_MASK			0x01
+#define INT_STS_PWRHOLD_F_IT_SHIFT			0
 
 
 /*Register INT_MSK  (0x80) register.RegisterDescription */
@@ -599,16 +642,16 @@
 #define INT_MSK_RTC_ALARM_IT_MSK_SHIFT			6
 #define INT_MSK_HOTDIE_IT_MSK_MASK			0x20
 #define INT_MSK_HOTDIE_IT_MSK_SHIFT			5
-#define INT_MSK_PWRHOLD_IT_MSK_MASK			0x10
-#define INT_MSK_PWRHOLD_IT_MSK_SHIFT			4
+#define INT_MSK_PWRHOLD_R_IT_MSK_MASK			0x10
+#define INT_MSK_PWRHOLD_R_IT_MSK_SHIFT			4
 #define INT_MSK_PWRON_LP_IT_MSK_MASK			0x08
 #define INT_MSK_PWRON_LP_IT_MSK_SHIFT			3
 #define INT_MSK_PWRON_IT_MSK_MASK			0x04
 #define INT_MSK_PWRON_IT_MSK_SHIFT			2
 #define INT_MSK_VMBHI_IT_MSK_MASK			0x02
 #define INT_MSK_VMBHI_IT_MSK_SHIFT			1
-#define INT_MSK_VMBDCH_IT_MSK_MASK			0x01
-#define INT_MSK_VMBDCH_IT_MSK_SHIFT			0
+#define INT_MSK_PWRHOLD_F_IT_MSK_MASK			0x01
+#define INT_MSK_PWRHOLD_F_IT_MSK_SHIFT			0
 
 
 /*Register INT_STS2  (0x80) register.RegisterDescription */
@@ -650,6 +693,14 @@
 
 
 /*Register INT_STS3  (0x80) register.RegisterDescription */
+#define INT_STS3_PWRDN_IT_MASK				0x80
+#define INT_STS3_PWRDN_IT_SHIFT				7
+#define INT_STS3_VMBCH2_L_IT_MASK			0x40
+#define INT_STS3_VMBCH2_L_IT_SHIFT			6
+#define INT_STS3_VMBCH2_H_IT_MASK			0x20
+#define INT_STS3_VMBCH2_H_IT_SHIFT			5
+#define INT_STS3_WTCHDG_IT_MASK				0x10
+#define INT_STS3_WTCHDG_IT_SHIFT			4
 #define INT_STS3_GPIO5_F_IT_MASK			0x08
 #define INT_STS3_GPIO5_F_IT_SHIFT			3
 #define INT_STS3_GPIO5_R_IT_MASK			0x04
@@ -661,6 +712,14 @@
 
 
 /*Register INT_MSK3  (0x80) register.RegisterDescription */
+#define INT_MSK3_PWRDN_IT_MSK_MASK			0x80
+#define INT_MSK3_PWRDN_IT_MSK_SHIFT			7
+#define INT_MSK3_VMBCH2_L_IT_MSK_MASK			0x40
+#define INT_MSK3_VMBCH2_L_IT_MSK_SHIFT			6
+#define INT_MSK3_VMBCH2_H_IT_MSK_MASK			0x20
+#define INT_MSK3_VMBCH2_H_IT_MSK_SHIFT			5
+#define INT_MSK3_WTCHDG_IT_MSK_MASK			0x10
+#define INT_MSK3_WTCHDG_IT_MSK_SHIFT			4
 #define INT_MSK3_GPIO5_F_IT_MSK_MASK			0x08
 #define INT_MSK3_GPIO5_F_IT_MSK_SHIFT			3
 #define INT_MSK3_GPIO5_R_IT_MSK_MASK			0x04
@@ -721,34 +780,32 @@
 #define TPS65910_IRQ_GPIO_F				9
 #define TPS65910_NUM_IRQ				10
 
-#define TPS65911_IRQ_VBAT_VMBDCH			0
-#define TPS65911_IRQ_VBAT_VMBDCH2L			1
-#define TPS65911_IRQ_VBAT_VMBDCH2H			2
-#define TPS65911_IRQ_VBAT_VMHI				3
-#define TPS65911_IRQ_PWRON				4
-#define TPS65911_IRQ_PWRON_LP				5
-#define TPS65911_IRQ_PWRHOLD_F				6
-#define TPS65911_IRQ_PWRHOLD_R				7
-#define TPS65911_IRQ_HOTDIE				8
-#define TPS65911_IRQ_RTC_ALARM				9
-#define TPS65911_IRQ_RTC_PERIOD				10
-#define TPS65911_IRQ_GPIO0_R				11
-#define TPS65911_IRQ_GPIO0_F				12
-#define TPS65911_IRQ_GPIO1_R				13
-#define TPS65911_IRQ_GPIO1_F				14
-#define TPS65911_IRQ_GPIO2_R				15
-#define TPS65911_IRQ_GPIO2_F				16
-#define TPS65911_IRQ_GPIO3_R				17
-#define TPS65911_IRQ_GPIO3_F				18
-#define TPS65911_IRQ_GPIO4_R				19
-#define TPS65911_IRQ_GPIO4_F				20
-#define TPS65911_IRQ_GPIO5_R				21
-#define TPS65911_IRQ_GPIO5_F				22
-#define TPS65911_IRQ_WTCHDG				23
-#define TPS65911_IRQ_PWRDN				24
-
-#define TPS65911_NUM_IRQ				25
-
+#define TPS65911_IRQ_PWRHOLD_F				0
+#define TPS65911_IRQ_VBAT_VMHI				1
+#define TPS65911_IRQ_PWRON				2
+#define TPS65911_IRQ_PWRON_LP				3
+#define TPS65911_IRQ_PWRHOLD_R				4
+#define TPS65911_IRQ_HOTDIE				5
+#define TPS65911_IRQ_RTC_ALARM				6
+#define TPS65911_IRQ_RTC_PERIOD				7
+#define TPS65911_IRQ_GPIO0_R				8
+#define TPS65911_IRQ_GPIO0_F				9
+#define TPS65911_IRQ_GPIO1_R				10
+#define TPS65911_IRQ_GPIO1_F				11
+#define TPS65911_IRQ_GPIO2_R				12
+#define TPS65911_IRQ_GPIO2_F				13
+#define TPS65911_IRQ_GPIO3_R				14
+#define TPS65911_IRQ_GPIO3_F				15
+#define TPS65911_IRQ_GPIO4_R				16
+#define TPS65911_IRQ_GPIO4_F				17
+#define TPS65911_IRQ_GPIO5_R				18
+#define TPS65911_IRQ_GPIO5_F				19
+#define TPS65911_IRQ_WTCHDG				20
+#define TPS65911_IRQ_VMBCH2_H				21
+#define TPS65911_IRQ_VMBCH2_L				22
+#define TPS65911_IRQ_PWRDN				23
+
+#define TPS65911_NUM_IRQ				24
 
 /* GPIO Register Definitions */
 #define TPS65910_GPIO_DEB				BIT(2)
@@ -848,11 +905,8 @@ struct tps65910 {
 	struct tps65910_board *of_plat_data;
 
 	/* IRQ Handling */
-	struct mutex irq_lock;
 	int chip_irq;
-	int irq_base;
-	int irq_num;
-	u32 irq_mask;
+	struct regmap_irq_chip_data *irq_data;
 	struct irq_domain *domain;
 };
 
@@ -900,4 +954,9 @@ static inline int tps65910_reg_update_bits(struct tps65910 *tps65910, u8 reg,
 	return regmap_update_bits(tps65910->regmap, reg, mask, val);
 }
 
+static inline int tps65910_irq_get_virq(struct tps65910 *tps65910, int irq)
+{
+	return regmap_irq_get_virq(tps65910->irq_data, irq);
+}
+
 #endif /*  __LINUX_MFD_TPS65910_H */
-- 
1.7.1.1

