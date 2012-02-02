Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab2BBRbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47513 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab2BBRbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:07 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Charulatha V <charu@ti.com>
Subject: [PATCH v9 03/25] gpio/omap: make gpio_context part of gpio_bank structure
Date: Thu, 2 Feb 2012 23:00:29 +0530
Message-ID: <1328203851-20435-4-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charulatha V <charu@ti.com>

Currently gpio_context array used to save gpio bank's context, is used only for
OMAP3 architecture. Move gpio_context as part of gpio_bank structure so that it
can be specific to each gpio bank and can be used for any OMAP architecture

Signed-off-by: Charulatha V <charu@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/gpio/gpio-omap.c |   76 ++++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 07efa15..6788c8a 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -30,6 +30,19 @@
 
 static LIST_HEAD(omap_gpio_list);
 
+struct gpio_regs {
+	u32 irqenable1;
+	u32 irqenable2;
+	u32 wake_en;
+	u32 ctrl;
+	u32 oe;
+	u32 leveldetect0;
+	u32 leveldetect1;
+	u32 risingdetect;
+	u32 fallingdetect;
+	u32 dataout;
+};
+
 struct gpio_bank {
 	struct list_head node;
 	unsigned long pbase;
@@ -43,7 +56,7 @@ struct gpio_bank {
 #endif
 	u32 non_wakeup_gpios;
 	u32 enabled_non_wakeup_gpios;
-
+	struct gpio_regs context;
 	u32 saved_datain;
 	u32 saved_fallingdetect;
 	u32 saved_risingdetect;
@@ -66,23 +79,6 @@ struct gpio_bank {
 	struct omap_gpio_reg_offs *regs;
 };
 
-#ifdef CONFIG_ARCH_OMAP3
-struct omap3_gpio_regs {
-	u32 irqenable1;
-	u32 irqenable2;
-	u32 wake_en;
-	u32 ctrl;
-	u32 oe;
-	u32 leveldetect0;
-	u32 leveldetect1;
-	u32 risingdetect;
-	u32 fallingdetect;
-	u32 dataout;
-};
-
-static struct omap3_gpio_regs gpio_context[OMAP34XX_NR_GPIOS];
-#endif
-
 #define GPIO_INDEX(bank, gpio) (gpio % bank->width)
 #define GPIO_BIT(bank, gpio) (1 << GPIO_INDEX(bank, gpio))
 
@@ -1499,33 +1495,31 @@ void omap2_gpio_resume_after_idle(void)
 void omap_gpio_save_context(void)
 {
 	struct gpio_bank *bank;
-	int i = 0;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
-		i++;
 
 		if (!bank->loses_context)
 			continue;
 
-		gpio_context[i].irqenable1 =
+		bank->context.irqenable1 =
 			__raw_readl(bank->base + OMAP24XX_GPIO_IRQENABLE1);
-		gpio_context[i].irqenable2 =
+		bank->context.irqenable2 =
 			__raw_readl(bank->base + OMAP24XX_GPIO_IRQENABLE2);
-		gpio_context[i].wake_en =
+		bank->context.wake_en =
 			__raw_readl(bank->base + OMAP24XX_GPIO_WAKE_EN);
-		gpio_context[i].ctrl =
+		bank->context.ctrl =
 			__raw_readl(bank->base + OMAP24XX_GPIO_CTRL);
-		gpio_context[i].oe =
+		bank->context.oe =
 			__raw_readl(bank->base + OMAP24XX_GPIO_OE);
-		gpio_context[i].leveldetect0 =
+		bank->context.leveldetect0 =
 			__raw_readl(bank->base + OMAP24XX_GPIO_LEVELDETECT0);
-		gpio_context[i].leveldetect1 =
+		bank->context.leveldetect1 =
 			__raw_readl(bank->base + OMAP24XX_GPIO_LEVELDETECT1);
-		gpio_context[i].risingdetect =
+		bank->context.risingdetect =
 			__raw_readl(bank->base + OMAP24XX_GPIO_RISINGDETECT);
-		gpio_context[i].fallingdetect =
+		bank->context.fallingdetect =
 			__raw_readl(bank->base + OMAP24XX_GPIO_FALLINGDETECT);
-		gpio_context[i].dataout =
+		bank->context.dataout =
 			__raw_readl(bank->base + OMAP24XX_GPIO_DATAOUT);
 	}
 }
@@ -1533,33 +1527,31 @@ void omap_gpio_save_context(void)
 void omap_gpio_restore_context(void)
 {
 	struct gpio_bank *bank;
-	int i = 0;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
-		i++;
 
 		if (!bank->loses_context)
 			continue;
 
-		__raw_writel(gpio_context[i].irqenable1,
+		__raw_writel(bank->context.irqenable1,
 				bank->base + OMAP24XX_GPIO_IRQENABLE1);
-		__raw_writel(gpio_context[i].irqenable2,
+		__raw_writel(bank->context.irqenable2,
 				bank->base + OMAP24XX_GPIO_IRQENABLE2);
-		__raw_writel(gpio_context[i].wake_en,
+		__raw_writel(bank->context.wake_en,
 				bank->base + OMAP24XX_GPIO_WAKE_EN);
-		__raw_writel(gpio_context[i].ctrl,
+		__raw_writel(bank->context.ctrl,
 				bank->base + OMAP24XX_GPIO_CTRL);
-		__raw_writel(gpio_context[i].oe,
+		__raw_writel(bank->context.oe,
 				bank->base + OMAP24XX_GPIO_OE);
-		__raw_writel(gpio_context[i].leveldetect0,
+		__raw_writel(bank->context.leveldetect0,
 				bank->base + OMAP24XX_GPIO_LEVELDETECT0);
-		__raw_writel(gpio_context[i].leveldetect1,
+		__raw_writel(bank->context.leveldetect1,
 				bank->base + OMAP24XX_GPIO_LEVELDETECT1);
-		__raw_writel(gpio_context[i].risingdetect,
+		__raw_writel(bank->context.risingdetect,
 				bank->base + OMAP24XX_GPIO_RISINGDETECT);
-		__raw_writel(gpio_context[i].fallingdetect,
+		__raw_writel(bank->context.fallingdetect,
 				bank->base + OMAP24XX_GPIO_FALLINGDETECT);
-		__raw_writel(gpio_context[i].dataout,
+		__raw_writel(bank->context.dataout,
 				bank->base + OMAP24XX_GPIO_DATAOUT);
 	}
 }
-- 
1.7.0.4

