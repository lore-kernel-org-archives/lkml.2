Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab2BBRbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50452 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756949Ab2BBRbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:33 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, Charulatha V <charu@ti.com>
Subject: [PATCH v9 07/25] gpio/omap: further cleanup using wkup_en register
Date: Thu, 2 Feb 2012 23:00:33 +0530
Message-ID: <1328203851-20435-8-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wakeup enable register offset initialized according to OMAP versions
during device registration. Use this to avoid version checks.
Starting with OMAP4, legacy registers should not be used in combination
with the updated regsiters. Use wkup_en register consistently for
all SoCs wherever applicable.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Signed-off-by: Charulatha V <charu@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/gpio16xx.c         |    1 +
 arch/arm/mach-omap2/gpio.c             |    2 +
 arch/arm/plat-omap/include/plat/gpio.h |    1 +
 drivers/gpio/gpio-omap.c               |  110 ++++++--------------------------
 4 files changed, 25 insertions(+), 89 deletions(-)

diff --git a/arch/arm/mach-omap1/gpio16xx.c b/arch/arm/mach-omap1/gpio16xx.c
index df4bb44..1eb47e2 100644
--- a/arch/arm/mach-omap1/gpio16xx.c
+++ b/arch/arm/mach-omap1/gpio16xx.c
@@ -89,6 +89,7 @@ static struct omap_gpio_reg_offs omap16xx_gpio_regs = {
 	.irqenable	= OMAP1610_GPIO_IRQENABLE1,
 	.set_irqenable	= OMAP1610_GPIO_SET_IRQENABLE1,
 	.clr_irqenable	= OMAP1610_GPIO_CLEAR_IRQENABLE1,
+	.wkup_en	= OMAP1610_GPIO_WAKEUPENABLE,
 };
 
 static struct __initdata omap_gpio_platform_data omap16xx_gpio1_config = {
diff --git a/arch/arm/mach-omap2/gpio.c b/arch/arm/mach-omap2/gpio.c
index bc9271a..4877b52 100644
--- a/arch/arm/mach-omap2/gpio.c
+++ b/arch/arm/mach-omap2/gpio.c
@@ -89,6 +89,7 @@ static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 		pdata->regs->debounce = OMAP24XX_GPIO_DEBOUNCE_VAL;
 		pdata->regs->debounce_en = OMAP24XX_GPIO_DEBOUNCE_EN;
 		pdata->regs->ctrl = OMAP24XX_GPIO_CTRL;
+		pdata->regs->wkup_en = OMAP24XX_GPIO_WAKE_EN;
 		break;
 	case 2:
 		pdata->bank_type = METHOD_GPIO_44XX;
@@ -106,6 +107,7 @@ static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 		pdata->regs->debounce = OMAP4_GPIO_DEBOUNCINGTIME;
 		pdata->regs->debounce_en = OMAP4_GPIO_DEBOUNCENABLE;
 		pdata->regs->ctrl = OMAP4_GPIO_CTRL;
+		pdata->regs->wkup_en = OMAP4_GPIO_IRQWAKEN0;
 		break;
 	default:
 		WARN(1, "Invalid gpio bank_type\n");
diff --git a/arch/arm/plat-omap/include/plat/gpio.h b/arch/arm/plat-omap/include/plat/gpio.h
index db94bd1..2b54bca 100644
--- a/arch/arm/plat-omap/include/plat/gpio.h
+++ b/arch/arm/plat-omap/include/plat/gpio.h
@@ -189,6 +189,7 @@ struct omap_gpio_reg_offs {
 	u16 debounce;
 	u16 debounce_en;
 	u16 ctrl;
+	u16 wkup_en;
 
 	bool irqenable_inv;
 };
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 5cc2c04..3daedff 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -51,9 +51,7 @@ struct gpio_bank {
 	u16 virtual_irq_start;
 	int method;
 	u32 suspend_wakeup;
-#if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2PLUS)
 	u32 saved_wakeup;
-#endif
 	u32 non_wakeup_gpios;
 	u32 enabled_non_wakeup_gpios;
 	struct gpio_regs context;
@@ -598,30 +596,15 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 {
 	struct gpio_bank *bank = container_of(chip, struct gpio_bank, chip);
+	void __iomem *base = bank->base;
 	unsigned long flags;
 
 	spin_lock_irqsave(&bank->lock, flags);
-#ifdef CONFIG_ARCH_OMAP16XX
-	if (bank->method == METHOD_GPIO_1610) {
-		/* Disable wake-up during idle for dynamic tick */
-		void __iomem *reg = bank->base + OMAP1610_GPIO_CLEAR_WAKEUPENA;
-		__raw_writel(1 << offset, reg);
-	}
-#endif
-#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
-	if (bank->method == METHOD_GPIO_24XX) {
-		/* Disable wake-up during idle for dynamic tick */
-		void __iomem *reg = bank->base + OMAP24XX_GPIO_CLEARWKUENA;
-		__raw_writel(1 << offset, reg);
-	}
-#endif
-#ifdef CONFIG_ARCH_OMAP4
-	if (bank->method == METHOD_GPIO_44XX) {
+
+	if (bank->regs->wkup_en)
 		/* Disable wake-up during idle for dynamic tick */
-		void __iomem *reg = bank->base + OMAP4_GPIO_IRQWAKEN0;
-		__raw_writel(1 << offset, reg);
-	}
-#endif
+		_gpio_rmw(base, bank->regs->wkup_en, 1 << offset, 0);
+
 	bank->mod_usage &= ~(1 << offset);
 
 	if (bank->regs->ctrl && !bank->mod_usage) {
@@ -1071,8 +1054,8 @@ omap_mpuio_alloc_gc(struct gpio_bank *bank, unsigned int irq_start,
 	ct->chip.irq_mask = irq_gc_mask_set_bit;
 	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
 	ct->chip.irq_set_type = gpio_irq_type;
-	/* REVISIT: assuming only 16xx supports MPUIO wake events */
-	if (cpu_is_omap16xx())
+
+	if (bank->regs->wkup_en)
 		ct->chip.irq_set_wake = gpio_wake_enable,
 
 	ct->regs.mask = OMAP_MPUIO_GPIO_INT / bank->stride;
@@ -1101,7 +1084,8 @@ static void __devinit omap_gpio_chip_init(struct gpio_bank *bank)
 	if (bank_is_mpuio(bank)) {
 		bank->chip.label = "mpuio";
 #ifdef CONFIG_ARCH_OMAP16XX
-		bank->chip.dev = &omap_mpuio_device.dev;
+		if (bank->regs->wkup_en)
+			bank->chip.dev = &omap_mpuio_device.dev;
 #endif
 		bank->chip.base = OMAP_MPUIO(0);
 	} else {
@@ -1212,50 +1196,24 @@ err_exit:
 	return ret;
 }
 
-#if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2PLUS)
 static int omap_gpio_suspend(void)
 {
 	struct gpio_bank *bank;
 
-	if (!cpu_class_is_omap2() && !cpu_is_omap16xx())
-		return 0;
-
 	list_for_each_entry(bank, &omap_gpio_list, node) {
+		void __iomem *base = bank->base;
 		void __iomem *wake_status;
-		void __iomem *wake_clear;
-		void __iomem *wake_set;
 		unsigned long flags;
 
-		switch (bank->method) {
-#ifdef CONFIG_ARCH_OMAP16XX
-		case METHOD_GPIO_1610:
-			wake_status = bank->base + OMAP1610_GPIO_WAKEUPENABLE;
-			wake_clear = bank->base + OMAP1610_GPIO_CLEAR_WAKEUPENA;
-			wake_set = bank->base + OMAP1610_GPIO_SET_WAKEUPENA;
-			break;
-#endif
-#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
-		case METHOD_GPIO_24XX:
-			wake_status = bank->base + OMAP24XX_GPIO_WAKE_EN;
-			wake_clear = bank->base + OMAP24XX_GPIO_CLEARWKUENA;
-			wake_set = bank->base + OMAP24XX_GPIO_SETWKUENA;
-			break;
-#endif
-#ifdef CONFIG_ARCH_OMAP4
-		case METHOD_GPIO_44XX:
-			wake_status = bank->base + OMAP4_GPIO_IRQWAKEN0;
-			wake_clear = bank->base + OMAP4_GPIO_IRQWAKEN0;
-			wake_set = bank->base + OMAP4_GPIO_IRQWAKEN0;
-			break;
-#endif
-		default:
-			continue;
-		}
+		if (!bank->regs->wkup_en)
+			return 0;
+
+		wake_status = bank->base + bank->regs->wkup_en;
 
 		spin_lock_irqsave(&bank->lock, flags);
 		bank->saved_wakeup = __raw_readl(wake_status);
-		__raw_writel(0xffffffff, wake_clear);
-		__raw_writel(bank->suspend_wakeup, wake_set);
+		_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
+		_gpio_rmw(base, bank->regs->wkup_en, bank->suspend_wakeup, 1);
 		spin_unlock_irqrestore(&bank->lock, flags);
 	}
 
@@ -1266,40 +1224,16 @@ static void omap_gpio_resume(void)
 {
 	struct gpio_bank *bank;
 
-	if (!cpu_class_is_omap2() && !cpu_is_omap16xx())
-		return;
-
 	list_for_each_entry(bank, &omap_gpio_list, node) {
-		void __iomem *wake_clear;
-		void __iomem *wake_set;
+		void __iomem *base = bank->base;
 		unsigned long flags;
 
-		switch (bank->method) {
-#ifdef CONFIG_ARCH_OMAP16XX
-		case METHOD_GPIO_1610:
-			wake_clear = bank->base + OMAP1610_GPIO_CLEAR_WAKEUPENA;
-			wake_set = bank->base + OMAP1610_GPIO_SET_WAKEUPENA;
-			break;
-#endif
-#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
-		case METHOD_GPIO_24XX:
-			wake_clear = bank->base + OMAP24XX_GPIO_CLEARWKUENA;
-			wake_set = bank->base + OMAP24XX_GPIO_SETWKUENA;
-			break;
-#endif
-#ifdef CONFIG_ARCH_OMAP4
-		case METHOD_GPIO_44XX:
-			wake_clear = bank->base + OMAP4_GPIO_IRQWAKEN0;
-			wake_set = bank->base + OMAP4_GPIO_IRQWAKEN0;
-			break;
-#endif
-		default:
-			continue;
-		}
+		if (!bank->regs->wkup_en)
+			return;
 
 		spin_lock_irqsave(&bank->lock, flags);
-		__raw_writel(0xffffffff, wake_clear);
-		__raw_writel(bank->saved_wakeup, wake_set);
+		_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
+		_gpio_rmw(base, bank->regs->wkup_en, bank->saved_wakeup, 1);
 		spin_unlock_irqrestore(&bank->lock, flags);
 	}
 }
@@ -1309,8 +1243,6 @@ static struct syscore_ops omap_gpio_syscore_ops = {
 	.resume		= omap_gpio_resume,
 };
 
-#endif
-
 #ifdef CONFIG_ARCH_OMAP2PLUS
 
 static void omap_gpio_save_context(struct gpio_bank *bank);
-- 
1.7.0.4

