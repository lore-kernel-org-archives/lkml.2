Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab2KMOHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:07:09 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2452 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2KMOHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:07:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 13 Nov 2012 06:07:01 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 RESEND 3/4] mfd: tps65910: move interrupt implementation code to mfd file
Date: Tue, 13 Nov 2012 19:33:58 +0530
Message-ID: <1352815439-26040-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
References: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In place of implementing the irq support in separate file,
moving implementation to main mfd file.
The irq files only contains the table and init steps only
and does not need extra file to have this only for this
purpose.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
No change from V1, just rearrange this patch.
It was already reviwed by Mark and hence adding his reviewed by.
 
No change from V2.

 drivers/mfd/Makefile         |    2 +-
 drivers/mfd/tps65910-irq.c   |  243 ------------------------------------------
 drivers/mfd/tps65910.c       |  216 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65910.h |    4 -
 4 files changed, 217 insertions(+), 248 deletions(-)
 delete mode 100644 drivers/mfd/tps65910-irq.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 296817c..b64d8f5 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_TPS6105X)		+= tps6105x.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_TPS6507X)		+= tps6507x.o
 obj-$(CONFIG_MFD_TPS65217)	+= tps65217.o
-obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-irq.o
+obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o
 tps65912-objs                   := tps65912-core.o tps65912-irq.o
 obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o
 obj-$(CONFIG_MFD_TPS65912_I2C)	+= tps65912-i2c.o
diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
deleted file mode 100644
index 554543a..0000000
--- a/drivers/mfd/tps65910-irq.c
+++ /dev/null
@@ -1,243 +0,0 @@
-/*
- * tps65910-irq.c  --  TI TPS6591x
- *
- * Copyright 2010 Texas Instruments Inc.
- *
- * Author: Graeme Gregory <gg@slimlogic.co.uk>
- * Author: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
- *
- *  This program is free software; you can redistribute it and/or modify it
- *  under  the terms of the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the License, or (at your
- *  option) any later version.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/bug.h>
-#include <linux/device.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
-#include <linux/gpio.h>
-#include <linux/mfd/tps65910.h>
-
-
-static const struct regmap_irq tps65911_irqs[] = {
-	/* INT_STS */
-	[TPS65911_IRQ_PWRHOLD_F] = {
-		.mask = INT_MSK_PWRHOLD_F_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65911_IRQ_VBAT_VMHI] = {
-		.mask = INT_MSK_VMBHI_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65911_IRQ_PWRON] = {
-		.mask = INT_MSK_PWRON_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65911_IRQ_PWRON_LP] = {
-		.mask = INT_MSK_PWRON_LP_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65911_IRQ_PWRHOLD_R] = {
-		.mask = INT_MSK_PWRHOLD_R_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65911_IRQ_HOTDIE] = {
-		.mask = INT_MSK_HOTDIE_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65911_IRQ_RTC_ALARM] = {
-		.mask = INT_MSK_RTC_ALARM_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65911_IRQ_RTC_PERIOD] = {
-		.mask = INT_MSK_RTC_PERIOD_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-
-	/* INT_STS2 */
-	[TPS65911_IRQ_GPIO0_R] = {
-		.mask = INT_MSK2_GPIO0_R_IT_MSK_MASK,
-		.reg_offset = 1,
-	},
-	[TPS65911_IRQ_GPIO0_F] = {
-		.mask = INT_MSK2_GPIO0_F_IT_MSK_MASK,
-		.reg_offset = 1,
-	},
-	[TPS65911_IRQ_GPIO1_R] = {
-		.mask = INT_MSK2_GPIO1_R_IT_MSK_MASK,
-		.reg_offset = 1,
-	},
-	[TPS65911_IRQ_GPIO1_F] = {
-		.mask = INT_MSK2_GPIO1_F_IT_MSK_MASK,
-		.reg_offset = 1,
-	},
-	[TPS65911_IRQ_GPIO2_R] = {
-		.mask = INT_MSK2_GPIO2_R_IT_MSK_MASK,
-		.reg_offset = 1,
-	},
-	[TPS65911_IRQ_GPIO2_F] = {
-		.mask = INT_MSK2_GPIO2_F_IT_MSK_MASK,
-		.reg_offset = 1,
-	},
-	[TPS65911_IRQ_GPIO3_R] = {
-		.mask = INT_MSK2_GPIO3_R_IT_MSK_MASK,
-		.reg_offset = 1,
-	},
-	[TPS65911_IRQ_GPIO3_F] = {
-		.mask = INT_MSK2_GPIO3_F_IT_MSK_MASK,
-		.reg_offset = 1,
-	},
-
-	/* INT_STS3 */
-	[TPS65911_IRQ_GPIO4_R] = {
-		.mask = INT_MSK3_GPIO4_R_IT_MSK_MASK,
-		.reg_offset = 2,
-	},
-	[TPS65911_IRQ_GPIO4_F] = {
-		.mask = INT_MSK3_GPIO4_F_IT_MSK_MASK,
-		.reg_offset = 2,
-	},
-	[TPS65911_IRQ_GPIO5_R] = {
-		.mask = INT_MSK3_GPIO5_R_IT_MSK_MASK,
-		.reg_offset = 2,
-	},
-	[TPS65911_IRQ_GPIO5_F] = {
-		.mask = INT_MSK3_GPIO5_F_IT_MSK_MASK,
-		.reg_offset = 2,
-	},
-	[TPS65911_IRQ_WTCHDG] = {
-		.mask = INT_MSK3_WTCHDG_IT_MSK_MASK,
-		.reg_offset = 2,
-	},
-	[TPS65911_IRQ_VMBCH2_H] = {
-		.mask = INT_MSK3_VMBCH2_H_IT_MSK_MASK,
-		.reg_offset = 2,
-	},
-	[TPS65911_IRQ_VMBCH2_L] = {
-		.mask = INT_MSK3_VMBCH2_L_IT_MSK_MASK,
-		.reg_offset = 2,
-	},
-	[TPS65911_IRQ_PWRDN] = {
-		.mask = INT_MSK3_PWRDN_IT_MSK_MASK,
-		.reg_offset = 2,
-	},
-};
-
-static const struct regmap_irq tps65910_irqs[] = {
-	/* INT_STS */
-	[TPS65910_IRQ_VBAT_VMBDCH] = {
-		.mask = TPS65910_INT_MSK_VMBDCH_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65910_IRQ_VBAT_VMHI] = {
-		.mask = TPS65910_INT_MSK_VMBHI_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65910_IRQ_PWRON] = {
-		.mask = TPS65910_INT_MSK_PWRON_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65910_IRQ_PWRON_LP] = {
-		.mask = TPS65910_INT_MSK_PWRON_LP_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65910_IRQ_PWRHOLD] = {
-		.mask = TPS65910_INT_MSK_PWRHOLD_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65910_IRQ_HOTDIE] = {
-		.mask = TPS65910_INT_MSK_HOTDIE_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65910_IRQ_RTC_ALARM] = {
-		.mask = TPS65910_INT_MSK_RTC_ALARM_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-	[TPS65910_IRQ_RTC_PERIOD] = {
-		.mask = TPS65910_INT_MSK_RTC_PERIOD_IT_MSK_MASK,
-		.reg_offset = 0,
-	},
-
-	/* INT_STS2 */
-	[TPS65910_IRQ_GPIO_R] = {
-		.mask = TPS65910_INT_MSK2_GPIO0_F_IT_MSK_MASK,
-		.reg_offset = 1,
-	},
-	[TPS65910_IRQ_GPIO_F] = {
-		.mask = TPS65910_INT_MSK2_GPIO0_R_IT_MSK_MASK,
-		.reg_offset = 1,
-	},
-};
-
-static struct regmap_irq_chip tps65911_irq_chip = {
-	.name = "tps65910",
-	.irqs = tps65911_irqs,
-	.num_irqs = ARRAY_SIZE(tps65911_irqs),
-	.num_regs = 3,
-	.irq_reg_stride = 2,
-	.status_base = TPS65910_INT_STS,
-	.mask_base = TPS65910_INT_MSK,
-	.ack_base = TPS65910_INT_MSK,
-};
-
-static struct regmap_irq_chip tps65910_irq_chip = {
-	.name = "tps65910",
-	.irqs = tps65910_irqs,
-	.num_irqs = ARRAY_SIZE(tps65910_irqs),
-	.num_regs = 2,
-	.irq_reg_stride = 2,
-	.status_base = TPS65910_INT_STS,
-	.mask_base = TPS65910_INT_MSK,
-	.ack_base = TPS65910_INT_MSK,
-};
-
-int tps65910_irq_init(struct tps65910 *tps65910, int irq,
-		    struct tps65910_platform_data *pdata)
-{
-	int ret = 0;
-	static struct regmap_irq_chip *tps6591x_irqs_chip;
-
-	if (!irq) {
-		dev_warn(tps65910->dev, "No interrupt support, no core IRQ\n");
-		return -EINVAL;
-	}
-
-	if (!pdata) {
-		dev_warn(tps65910->dev, "No interrupt support, no pdata\n");
-		return -EINVAL;
-	}
-
-
-	switch (tps65910_chip_id(tps65910)) {
-	case TPS65910:
-		tps6591x_irqs_chip = &tps65910_irq_chip;
-		break;
-	case TPS65911:
-		tps6591x_irqs_chip = &tps65911_irq_chip;
-		break;
-	}
-
-	tps65910->chip_irq = irq;
-	ret = regmap_add_irq_chip(tps65910->regmap, tps65910->chip_irq,
-		IRQF_ONESHOT, pdata->irq_base,
-		tps6591x_irqs_chip, &tps65910->irq_data);
-	if (ret < 0) {
-		dev_warn(tps65910->dev,
-				"Failed to add irq_chip %d\n", ret);
-		return ret;
-	}
-	return ret;
-}
-
-int tps65910_irq_exit(struct tps65910 *tps65910)
-{
-	if (tps65910->chip_irq > 0)
-		regmap_del_irq_chip(tps65910->chip_irq, tps65910->irq_data);
-	return 0;
-}
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 27fbbe5..d4d4eb5 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -19,6 +19,9 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/mfd/core.h>
 #include <linux/regmap.h>
 #include <linux/mfd/tps65910.h>
@@ -50,6 +53,219 @@ static struct mfd_cell tps65910s[] = {
 };
 
 
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
+	/* INT_STS2 */
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
+
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
+
+static struct regmap_irq_chip tps65911_irq_chip = {
+	.name = "tps65910",
+	.irqs = tps65911_irqs,
+	.num_irqs = ARRAY_SIZE(tps65911_irqs),
+	.num_regs = 3,
+	.irq_reg_stride = 2,
+	.status_base = TPS65910_INT_STS,
+	.mask_base = TPS65910_INT_MSK,
+	.ack_base = TPS65910_INT_MSK,
+};
+
+static struct regmap_irq_chip tps65910_irq_chip = {
+	.name = "tps65910",
+	.irqs = tps65910_irqs,
+	.num_irqs = ARRAY_SIZE(tps65910_irqs),
+	.num_regs = 2,
+	.irq_reg_stride = 2,
+	.status_base = TPS65910_INT_STS,
+	.mask_base = TPS65910_INT_MSK,
+	.ack_base = TPS65910_INT_MSK,
+};
+
+static int tps65910_irq_init(struct tps65910 *tps65910, int irq,
+		    struct tps65910_platform_data *pdata)
+{
+	int ret = 0;
+	static struct regmap_irq_chip *tps6591x_irqs_chip;
+
+	if (!irq) {
+		dev_warn(tps65910->dev, "No interrupt support, no core IRQ\n");
+		return -EINVAL;
+	}
+
+	if (!pdata) {
+		dev_warn(tps65910->dev, "No interrupt support, no pdata\n");
+		return -EINVAL;
+	}
+
+	switch (tps65910_chip_id(tps65910)) {
+	case TPS65910:
+		tps6591x_irqs_chip = &tps65910_irq_chip;
+		break;
+	case TPS65911:
+		tps6591x_irqs_chip = &tps65911_irq_chip;
+		break;
+	}
+
+	tps65910->chip_irq = irq;
+	ret = regmap_add_irq_chip(tps65910->regmap, tps65910->chip_irq,
+		IRQF_ONESHOT, pdata->irq_base,
+		tps6591x_irqs_chip, &tps65910->irq_data);
+	if (ret < 0)
+		dev_warn(tps65910->dev, "Failed to add irq_chip %d\n", ret);
+	return ret;
+}
+
+static int tps65910_irq_exit(struct tps65910 *tps65910)
+{
+	if (tps65910->chip_irq > 0)
+		regmap_del_irq_chip(tps65910->chip_irq, tps65910->irq_data);
+	return 0;
+}
+
 static bool is_volatile_reg(struct device *dev, unsigned int reg)
 {
 	struct tps65910 *tps65910 = dev_get_drvdata(dev);
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index b564ac2..0b16903 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -915,10 +915,6 @@ struct tps65910_platform_data {
 	int irq_base;
 };
 
-int tps65910_irq_init(struct tps65910 *tps65910, int irq,
-		struct tps65910_platform_data *pdata);
-int tps65910_irq_exit(struct tps65910 *tps65910);
-
 static inline int tps65910_chip_id(struct tps65910 *tps65910)
 {
 	return tps65910->id;
-- 
1.7.1.1

