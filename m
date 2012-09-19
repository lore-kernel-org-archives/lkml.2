Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2ISHAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:00:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26031 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab2ISHAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:00:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6839"; a="238452250"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: [PATCH 4/5] gpio: Make gpio-msm-v1 into a platform driver
Date: Wed, 19 Sep 2012 00:00:43 -0700
Message-Id: <1348038044-1790-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.403.gce5cf6f
In-Reply-To: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
References: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing this removes the dependence of this driver on the
msm_iomap.h and cpu.h mach include headers provied by MSM. This
is necessary to support single zImage work in the future and
allows us to remove cpu.h entirely and brings us closer to
removing msm_iomap.h.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/board-halibut.c   |   1 +
 arch/arm/mach-msm/board-msm7x30.c   |   1 +
 arch/arm/mach-msm/board-qsd8x50.c   |   1 +
 arch/arm/mach-msm/board-trout.c     |   1 +
 arch/arm/mach-msm/devices-msm7x00.c |  31 +++++
 arch/arm/mach-msm/devices-msm7x30.c |  31 +++++
 arch/arm/mach-msm/devices-qsd8x50.c |  31 +++++
 arch/arm/mach-msm/devices.h         |   4 +
 drivers/gpio/gpio-msm-v1.c          | 220 ++++++++++++++++++++++++------------
 9 files changed, 250 insertions(+), 71 deletions(-)

diff --git a/arch/arm/mach-msm/board-halibut.c b/arch/arm/mach-msm/board-halibut.c
index 6ce542e..a87976e 100644
--- a/arch/arm/mach-msm/board-halibut.c
+++ b/arch/arm/mach-msm/board-halibut.c
@@ -59,6 +59,7 @@ static struct platform_device smc91x_device = {
 };
 
 static struct platform_device *devices[] __initdata = {
+	&msm_device_gpio_7201,
 	&msm_device_uart3,
 	&msm_device_smd,
 	&msm_device_nand,
diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index effa6f4..c94778e 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -89,6 +89,7 @@ struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
 };
 
 static struct platform_device *devices[] __initdata = {
+	&msm_device_gpio_7x30,
 #if defined(CONFIG_SERIAL_MSM) || defined(CONFIG_MSM_SERIAL_DEBUGGER)
         &msm_device_uart2,
 #endif
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index b16b71a..98e2804 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -89,6 +89,7 @@ static struct msm_otg_platform_data msm_otg_pdata = {
 };
 
 static struct platform_device *devices[] __initdata = {
+	&msm_device_gpio_8x50,
 	&msm_device_uart3,
 	&msm_device_smd,
 	&msm_device_otg,
diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index 4ba0800..247d1b8 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -36,6 +36,7 @@
 extern int trout_init_mmc(unsigned int);
 
 static struct platform_device *devices[] __initdata = {
+	&msm_device_gpio_7201,
 	&msm_device_uart3,
 	&msm_device_smd,
 	&msm_device_nand,
diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index 993780f..d47d763 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -29,6 +29,37 @@
 #include "clock-pcom.h"
 #include <mach/mmc.h>
 
+static struct resource msm_gpio_resources[] = {
+	{
+		.start	= 32 + 0,
+		.end	= 32 + 0,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= 32 + 1,
+		.end	= 32 + 1,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= 0xa9200800,
+		.end	= 0xa9200800 + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+		.name  = "gpio1"
+	},
+	{
+		.start	= 0xa9300C00,
+		.end	= 0xa9300C00 + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+		.name  = "gpio2"
+	},
+};
+
+struct platform_device msm_device_gpio_7201 = {
+	.name	= "gpio-msm-7201",
+	.num_resources	= ARRAY_SIZE(msm_gpio_resources),
+	.resource	= msm_gpio_resources,
+};
+
 static struct resource resources_uart1[] = {
 	{
 		.start	= INT_UART1,
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index 09b4f14..872dbcd 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -33,6 +33,37 @@
 
 #include <mach/mmc.h>
 
+static struct resource msm_gpio_resources[] = {
+	{
+		.start	= 32 + 18,
+		.end	= 32 + 18,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= 32 + 19,
+		.end	= 32 + 19,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= 0xac001000,
+		.end	= 0xac001000 + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+		.name  = "gpio1"
+	},
+	{
+		.start	= 0xac101400,
+		.end	= 0xac101400 + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+		.name  = "gpio2"
+	},
+};
+
+struct platform_device msm_device_gpio_7x30 = {
+	.name	= "gpio-msm-7x30",
+	.num_resources	= ARRAY_SIZE(msm_gpio_resources),
+	.resource	= msm_gpio_resources,
+};
+
 static struct resource resources_uart2[] = {
 	{
 		.start	= INT_UART2,
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 131633b..20ff5b0 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -30,6 +30,37 @@
 #include <mach/mmc.h>
 #include "clock-pcom.h"
 
+static struct resource msm_gpio_resources[] = {
+	{
+		.start	= 64 + 165 + 9,
+		.end	= 64 + 165 + 9,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= 64 + 165 + 10,
+		.end	= 64 + 165 + 10,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= 0xa9000800,
+		.end	= 0xa9000800 + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+		.name  = "gpio1"
+	},
+	{
+		.start	= 0xa9100C00,
+		.end	= 0xa9100C00 + SZ_4K - 1,
+		.flags	= IORESOURCE_MEM,
+		.name  = "gpio2"
+	},
+};
+
+struct platform_device msm_device_gpio_8x50 = {
+	.name	= "gpio-msm-8x50",
+	.num_resources	= ARRAY_SIZE(msm_gpio_resources),
+	.resource	= msm_gpio_resources,
+};
+
 static struct resource resources_uart3[] = {
 	{
 		.start	= INT_UART3,
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index 9545c19..da902cf 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -20,6 +20,10 @@
 
 #include "clock.h"
 
+extern struct platform_device msm_device_gpio_7201;
+extern struct platform_device msm_device_gpio_7x30;
+extern struct platform_device msm_device_gpio_8x50;
+
 extern struct platform_device msm_device_uart1;
 extern struct platform_device msm_device_uart2;
 extern struct platform_device msm_device_uart3;
diff --git a/drivers/gpio/gpio-msm-v1.c b/drivers/gpio/gpio-msm-v1.c
index 52a4d42..5a8561c 100644
--- a/drivers/gpio/gpio-msm-v1.c
+++ b/drivers/gpio/gpio-msm-v1.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2009-2011, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2009-2012, The Linux Foundation. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -19,9 +19,10 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/module.h>
-#include <mach/cpu.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+
 #include <mach/msm_gpiomux.h>
-#include <mach/msm_iomap.h>
 
 /* see 80-VA736-2 Rev C pp 695-751
 **
@@ -34,10 +35,10 @@
 ** macros.
 */
 
-#define MSM_GPIO1_REG(off) (MSM_GPIO1_BASE + (off))
-#define MSM_GPIO2_REG(off) (MSM_GPIO2_BASE + 0x400 + (off))
-#define MSM_GPIO1_SHADOW_REG(off) (MSM_GPIO1_BASE + 0x800 + (off))
-#define MSM_GPIO2_SHADOW_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
+#define MSM_GPIO1_REG(off) (off)
+#define MSM_GPIO2_REG(off) (off)
+#define MSM_GPIO1_SHADOW_REG(off) (off)
+#define MSM_GPIO2_SHADOW_REG(off) (off)
 
 /*
  * MSM7X00 registers
@@ -276,16 +277,14 @@
 
 #define MSM_GPIO_BANK(soc, bank, first, last)				\
 	{								\
-		.regs = {						\
-			.out =         soc##_GPIO_OUT_##bank,		\
-			.in =          soc##_GPIO_IN_##bank,		\
-			.int_status =  soc##_GPIO_INT_STATUS_##bank,	\
-			.int_clear =   soc##_GPIO_INT_CLEAR_##bank,	\
-			.int_en =      soc##_GPIO_INT_EN_##bank,	\
-			.int_edge =    soc##_GPIO_INT_EDGE_##bank,	\
-			.int_pos =     soc##_GPIO_INT_POS_##bank,	\
-			.oe =          soc##_GPIO_OE_##bank,		\
-		},							\
+		.regs[MSM_GPIO_OUT] =         soc##_GPIO_OUT_##bank,	\
+		.regs[MSM_GPIO_IN] =          soc##_GPIO_IN_##bank,	\
+		.regs[MSM_GPIO_INT_STATUS] =  soc##_GPIO_INT_STATUS_##bank, \
+		.regs[MSM_GPIO_INT_CLEAR] =   soc##_GPIO_INT_CLEAR_##bank, \
+		.regs[MSM_GPIO_INT_EN] =      soc##_GPIO_INT_EN_##bank,	\
+		.regs[MSM_GPIO_INT_EDGE] =    soc##_GPIO_INT_EDGE_##bank, \
+		.regs[MSM_GPIO_INT_POS] =     soc##_GPIO_INT_POS_##bank, \
+		.regs[MSM_GPIO_OE] =          soc##_GPIO_OE_##bank,	\
 		.chip = {						\
 			.base = (first),				\
 			.ngpio = (last) - (first) + 1,			\
@@ -301,39 +300,57 @@
 
 #define MSM_GPIO_BROKEN_INT_CLEAR 1
 
-struct msm_gpio_regs {
-	void __iomem *out;
-	void __iomem *in;
-	void __iomem *int_status;
-	void __iomem *int_clear;
-	void __iomem *int_en;
-	void __iomem *int_edge;
-	void __iomem *int_pos;
-	void __iomem *oe;
+enum msm_gpio_reg {
+	MSM_GPIO_IN,
+	MSM_GPIO_OUT,
+	MSM_GPIO_INT_STATUS,
+	MSM_GPIO_INT_CLEAR,
+	MSM_GPIO_INT_EN,
+	MSM_GPIO_INT_EDGE,
+	MSM_GPIO_INT_POS,
+	MSM_GPIO_OE,
+	MSM_GPIO_REG_NR
 };
 
 struct msm_gpio_chip {
 	spinlock_t		lock;
 	struct gpio_chip	chip;
-	struct msm_gpio_regs	regs;
+	unsigned long		regs[MSM_GPIO_REG_NR];
 #if MSM_GPIO_BROKEN_INT_CLEAR
 	unsigned                int_status_copy;
 #endif
 	unsigned int            both_edge_detect;
 	unsigned int            int_enable[2]; /* 0: awake, 1: sleep */
+	void __iomem		*base;
+};
+
+struct msm_gpio_initdata {
+	struct msm_gpio_chip *chips;
+	int count;
 };
 
+static void msm_gpio_writel(struct msm_gpio_chip *chip, u32 val,
+			    enum msm_gpio_reg reg)
+{
+	writel(val, chip->base + chip->regs[reg]);
+}
+
+static u32 msm_gpio_readl(struct msm_gpio_chip *chip, enum msm_gpio_reg reg)
+{
+	return readl(chip->base + chip->regs[reg]);
+}
+
 static int msm_gpio_write(struct msm_gpio_chip *msm_chip,
 			  unsigned offset, unsigned on)
 {
 	unsigned mask = BIT(offset);
 	unsigned val;
 
-	val = readl(msm_chip->regs.out);
+	val = msm_gpio_readl(msm_chip, MSM_GPIO_OUT);
 	if (on)
-		writel(val | mask, msm_chip->regs.out);
+		msm_gpio_writel(msm_chip, val | mask, MSM_GPIO_OUT);
 	else
-		writel(val & ~mask, msm_chip->regs.out);
+		msm_gpio_writel(msm_chip, val & ~mask, MSM_GPIO_OUT);
 	return 0;
 }
 
@@ -342,13 +359,13 @@ static void msm_gpio_update_both_edge_detect(struct msm_gpio_chip *msm_chip)
 	int loop_limit = 100;
 	unsigned pol, val, val2, intstat;
 	do {
-		val = readl(msm_chip->regs.in);
-		pol = readl(msm_chip->regs.int_pos);
+		val = msm_gpio_readl(msm_chip, MSM_GPIO_IN);
+		pol = msm_gpio_readl(msm_chip, MSM_GPIO_INT_POS);
 		pol = (pol & ~msm_chip->both_edge_detect) |
 		      (~val & msm_chip->both_edge_detect);
-		writel(pol, msm_chip->regs.int_pos);
-		intstat = readl(msm_chip->regs.int_status);
-		val2 = readl(msm_chip->regs.in);
+		msm_gpio_writel(msm_chip, pol, MSM_GPIO_INT_POS);
+		intstat = msm_gpio_readl(msm_chip, MSM_GPIO_INT_STATUS);
+		val2 = msm_gpio_readl(msm_chip, MSM_GPIO_IN);
 		if (((val ^ val2) & msm_chip->both_edge_detect & ~intstat) == 0)
 			return;
 	} while (loop_limit-- > 0);
@@ -365,10 +382,11 @@ static int msm_gpio_clear_detect_status(struct msm_gpio_chip *msm_chip,
 	/* Save interrupts that already triggered before we loose them. */
 	/* Any interrupt that triggers between the read of int_status */
 	/* and the write to int_clear will still be lost though. */
-	msm_chip->int_status_copy |= readl(msm_chip->regs.int_status);
+	msm_chip->int_status_copy |=
+		msm_gpio_readl(msm_chip, MSM_GPIO_INT_STATUS);
 	msm_chip->int_status_copy &= ~bit;
 #endif
-	writel(bit, msm_chip->regs.int_clear);
+	msm_gpio_writel(msm_chip, bit, MSM_GPIO_INT_CLEAR);
 	msm_gpio_update_both_edge_detect(msm_chip);
 	return 0;
 }
@@ -377,10 +395,12 @@ static int msm_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	struct msm_gpio_chip *msm_chip;
 	unsigned long irq_flags;
+	u32 val;
 
 	msm_chip = container_of(chip, struct msm_gpio_chip, chip);
 	spin_lock_irqsave(&msm_chip->lock, irq_flags);
-	writel(readl(msm_chip->regs.oe) & ~BIT(offset), msm_chip->regs.oe);
+	val = msm_gpio_readl(msm_chip, MSM_GPIO_OE) & ~BIT(offset);
+	msm_gpio_writel(msm_chip, val, MSM_GPIO_OE);
 	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
 	return 0;
 }
@@ -390,11 +410,13 @@ msm_gpio_direction_output(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct msm_gpio_chip *msm_chip;
 	unsigned long irq_flags;
+	u32 val;
 
 	msm_chip = container_of(chip, struct msm_gpio_chip, chip);
 	spin_lock_irqsave(&msm_chip->lock, irq_flags);
 	msm_gpio_write(msm_chip, offset, value);
-	writel(readl(msm_chip->regs.oe) | BIT(offset), msm_chip->regs.oe);
+	val = msm_gpio_readl(msm_chip, MSM_GPIO_OE) | BIT(offset);
+	msm_gpio_writel(msm_chip, val, MSM_GPIO_OE);
 	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
 	return 0;
 }
@@ -404,7 +426,7 @@ static int msm_gpio_get(struct gpio_chip *chip, unsigned offset)
 	struct msm_gpio_chip *msm_chip;
 
 	msm_chip = container_of(chip, struct msm_gpio_chip, chip);
-	return (readl(msm_chip->regs.in) & (1U << offset)) ? 1 : 0;
+	return (msm_gpio_readl(msm_chip, MSM_GPIO_IN) & (1U << offset)) ? 1 : 0;
 }
 
 static void msm_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
@@ -450,6 +472,11 @@ static struct msm_gpio_chip msm_gpio_chips_msm7x01[] = {
 	MSM_GPIO_BANK(MSM7X00, 5, 107, 121),
 };
 
+static struct msm_gpio_initdata msm_gpio_7x01_init = {
+	.chips = msm_gpio_chips_msm7x01,
+	.count = ARRAY_SIZE(msm_gpio_chips_msm7x01),
+};
+
 static struct msm_gpio_chip msm_gpio_chips_msm7x30[] = {
 	MSM_GPIO_BANK(MSM7X30, 0,   0,  15),
 	MSM_GPIO_BANK(MSM7X30, 1,  16,  43),
@@ -461,6 +488,11 @@ static struct msm_gpio_chip msm_gpio_chips_msm7x30[] = {
 	MSM_GPIO_BANK(MSM7X30, 7, 151, 181),
 };
 
+static struct msm_gpio_initdata msm_gpio_7x30_init = {
+	.chips = msm_gpio_chips_msm7x30,
+	.count = ARRAY_SIZE(msm_gpio_chips_msm7x30),
+};
+
 static struct msm_gpio_chip msm_gpio_chips_qsd8x50[] = {
 	MSM_GPIO_BANK(QSD8X50, 0,   0,  15),
 	MSM_GPIO_BANK(QSD8X50, 1,  16,  42),
@@ -472,6 +504,11 @@ static struct msm_gpio_chip msm_gpio_chips_qsd8x50[] = {
 	MSM_GPIO_BANK(QSD8X50, 7, 153, 164),
 };
 
+static struct msm_gpio_initdata msm_gpio_8x50_init = {
+	.chips = msm_gpio_chips_qsd8x50,
+	.count = ARRAY_SIZE(msm_gpio_chips_qsd8x50),
+};
+
 static void msm_gpio_irq_ack(struct irq_data *d)
 {
 	unsigned long irq_flags;
@@ -490,10 +527,10 @@ static void msm_gpio_irq_mask(struct irq_data *d)
 
 	spin_lock_irqsave(&msm_chip->lock, irq_flags);
 	/* level triggered interrupts are also latched */
-	if (!(readl(msm_chip->regs.int_edge) & BIT(offset)))
+	if (!(msm_gpio_readl(msm_chip, MSM_GPIO_INT_EDGE) & BIT(offset)))
 		msm_gpio_clear_detect_status(msm_chip, offset);
 	msm_chip->int_enable[0] &= ~BIT(offset);
-	writel(msm_chip->int_enable[0], msm_chip->regs.int_en);
+	msm_gpio_writel(msm_chip, msm_chip->int_enable[0], MSM_GPIO_INT_EN);
 	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
 }
 
@@ -505,10 +542,10 @@ static void msm_gpio_irq_unmask(struct irq_data *d)
 
 	spin_lock_irqsave(&msm_chip->lock, irq_flags);
 	/* level triggered interrupts are also latched */
-	if (!(readl(msm_chip->regs.int_edge) & BIT(offset)))
+	if (!(msm_gpio_readl(msm_chip, MSM_GPIO_INT_EDGE) & BIT(offset)))
 		msm_gpio_clear_detect_status(msm_chip, offset);
 	msm_chip->int_enable[0] |= BIT(offset);
-	writel(msm_chip->int_enable[0], msm_chip->regs.int_en);
+	msm_gpio_writel(msm_chip, msm_chip->int_enable[0], MSM_GPIO_INT_EN);
 	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
 }
 
@@ -537,12 +574,12 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int flow_type)
 	unsigned val, mask = BIT(offset);
 
 	spin_lock_irqsave(&msm_chip->lock, irq_flags);
-	val = readl(msm_chip->regs.int_edge);
+	val = msm_gpio_readl(msm_chip, MSM_GPIO_INT_EDGE);
 	if (flow_type & IRQ_TYPE_EDGE_BOTH) {
-		writel(val | mask, msm_chip->regs.int_edge);
+		msm_gpio_writel(msm_chip, val | mask, MSM_GPIO_INT_EDGE);
 		__irq_set_handler_locked(d->irq, handle_edge_irq);
 	} else {
-		writel(val & ~mask, msm_chip->regs.int_edge);
+		msm_gpio_writel(msm_chip, val & ~mask, MSM_GPIO_INT_EDGE);
 		__irq_set_handler_locked(d->irq, handle_level_irq);
 	}
 	if ((flow_type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH) {
@@ -550,11 +587,12 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int flow_type)
 		msm_gpio_update_both_edge_detect(msm_chip);
 	} else {
 		msm_chip->both_edge_detect &= ~mask;
-		val = readl(msm_chip->regs.int_pos);
+		val = msm_gpio_readl(msm_chip, MSM_GPIO_INT_POS);
 		if (flow_type & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_HIGH))
-			writel(val | mask, msm_chip->regs.int_pos);
+			val |= mask;
 		else
-			writel(val & ~mask, msm_chip->regs.int_pos);
+			val &= ~mask;
+		msm_gpio_writel(msm_chip, val, MSM_GPIO_INT_POS);
 	}
 	spin_unlock_irqrestore(&msm_chip->lock, irq_flags);
 	return 0;
@@ -567,7 +605,7 @@ static void msm_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 
 	for (i = 0; i < msm_gpio_count; i++) {
 		struct msm_gpio_chip *msm_chip = &msm_gpio_chips[i];
-		val = readl(msm_chip->regs.int_status);
+		val = msm_gpio_readl(msm_chip, MSM_GPIO_INT_STATUS);
 		val &= msm_chip->int_enable[0];
 		while (val) {
 			mask = val & -val;
@@ -592,22 +630,36 @@ static struct irq_chip msm_gpio_irq_chip = {
 	.irq_set_type  = msm_gpio_irq_set_type,
 };
 
-static int __init msm_init_gpio(void)
+static int __devinit gpio_msm_v1_probe(struct platform_device *pdev)
 {
 	int i, j = 0;
-
-	if (cpu_is_msm7x01()) {
-		msm_gpio_chips = msm_gpio_chips_msm7x01;
-		msm_gpio_count = ARRAY_SIZE(msm_gpio_chips_msm7x01);
-	} else if (cpu_is_msm7x30()) {
-		msm_gpio_chips = msm_gpio_chips_msm7x30;
-		msm_gpio_count = ARRAY_SIZE(msm_gpio_chips_msm7x30);
-	} else if (cpu_is_qsd8x50()) {
-		msm_gpio_chips = msm_gpio_chips_qsd8x50;
-		msm_gpio_count = ARRAY_SIZE(msm_gpio_chips_qsd8x50);
-	} else {
-		return 0;
-	}
+	const struct platform_device_id *dev_id = platform_get_device_id(pdev);
+	struct msm_gpio_initdata *data;
+	int irq1, irq2;
+	struct resource *res;
+	void __iomem *base1, __iomem *base2;
+
+	data = (struct msm_gpio_initdata *)dev_id->driver_data;
+	msm_gpio_chips = data->chips;
+	msm_gpio_count = data->count;
+
+	irq1 = platform_get_irq(pdev, 0);
+	if (irq1 < 0)
+		return irq1;
+
+	irq2 = platform_get_irq(pdev, 1);
+	if (irq2 < 0)
+		return irq2;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base1 = devm_request_and_ioremap(&pdev->dev, res);
+	if (!base1)
+		return -EADDRNOTAVAIL;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	base2 = devm_request_and_ioremap(&pdev->dev, res);
+	if (!base2)
+		return -EADDRNOTAVAIL;
 
 	for (i = FIRST_GPIO_IRQ; i < FIRST_GPIO_IRQ + NR_GPIO_IRQS; i++) {
 		if (i - FIRST_GPIO_IRQ >=
@@ -621,16 +673,42 @@ static int __init msm_init_gpio(void)
 	}
 
 	for (i = 0; i < msm_gpio_count; i++) {
+		if (i == 1)
+			msm_gpio_chips[i].base = base2;
+		else
+			msm_gpio_chips[i].base = base1;
 		spin_lock_init(&msm_gpio_chips[i].lock);
-		writel(0, msm_gpio_chips[i].regs.int_en);
+		msm_gpio_writel(&msm_gpio_chips[i], 0, MSM_GPIO_INT_EN);
 		gpiochip_add(&msm_gpio_chips[i].chip);
 	}
 
-	irq_set_chained_handler(INT_GPIO_GROUP1, msm_gpio_irq_handler);
-	irq_set_chained_handler(INT_GPIO_GROUP2, msm_gpio_irq_handler);
-	irq_set_irq_wake(INT_GPIO_GROUP1, 1);
-	irq_set_irq_wake(INT_GPIO_GROUP2, 2);
+	irq_set_chained_handler(irq1, msm_gpio_irq_handler);
+	irq_set_chained_handler(irq2, msm_gpio_irq_handler);
+	irq_set_irq_wake(irq1, 1);
+	irq_set_irq_wake(irq2, 2);
 	return 0;
 }
 
-postcore_initcall(msm_init_gpio);
+static struct platform_device_id gpio_msm_v1_device_ids[] = {
+	{ "gpio-msm-7201", (unsigned long)&msm_gpio_7x01_init },
+	{ "gpio-msm-7x30", (unsigned long)&msm_gpio_7x30_init },
+	{ "gpio-msm-8x50", (unsigned long)&msm_gpio_8x50_init },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, gpio_msm_v1_device_ids);
+
+static struct platform_driver gpio_msm_v1_driver = {
+	.driver = {
+		.name = "gpio-msm-v1",
+		.owner = THIS_MODULE,
+	},
+	.probe = gpio_msm_v1_probe,
+	.id_table = gpio_msm_v1_device_ids,
+};
+
+static int __init gpio_msm_v1_init(void)
+{
+	return platform_driver_register(&gpio_msm_v1_driver);
+}
+postcore_initcall(gpio_msm_v1_init);
+MODULE_LICENSE("GPL v2");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

