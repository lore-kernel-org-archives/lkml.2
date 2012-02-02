Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab2BBRb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47560 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab2BBRb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:26 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, Charulatha V <charu@ti.com>
Subject: [PATCH v9 10/25] gpio/omap: cleanup set_gpio_triggering function
Date: Thu, 2 Feb 2012 23:00:36 +0530
Message-ID: <1328203851-20435-11-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting rid of ifdefs within the function by adding register offset intctrl
and associating OMAPXXXX_GPIO_INT_CONTROL in respective SoC specific files.
Also, use wkup_status register consistently instead of referring to wakeup
clear and wakeup set register offsets. Get rid of cpu_is_xxxx checks in
set_gpio_trigger() using irqctrl.

Signed-off-by: Charulatha V <charu@ti.com>
Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/gpio15xx.c         |    2 +
 arch/arm/mach-omap1/gpio16xx.c         |    3 +
 arch/arm/mach-omap1/gpio7xx.c          |    2 +
 arch/arm/plat-omap/include/plat/gpio.h |    3 +
 drivers/gpio/gpio-omap.c               |  157 +++++++++-----------------------
 5 files changed, 53 insertions(+), 114 deletions(-)

diff --git a/arch/arm/mach-omap1/gpio15xx.c b/arch/arm/mach-omap1/gpio15xx.c
index f8c15ea..2adfece 100644
--- a/arch/arm/mach-omap1/gpio15xx.c
+++ b/arch/arm/mach-omap1/gpio15xx.c
@@ -42,6 +42,7 @@ static struct omap_gpio_reg_offs omap15xx_mpuio_regs = {
 	.irqstatus	= OMAP_MPUIO_GPIO_INT,
 	.irqenable	= OMAP_MPUIO_GPIO_MASKIT,
 	.irqenable_inv	= true,
+	.irqctrl	= OMAP_MPUIO_GPIO_INT_EDGE,
 };
 
 static struct __initdata omap_gpio_platform_data omap15xx_mpu_gpio_config = {
@@ -83,6 +84,7 @@ static struct omap_gpio_reg_offs omap15xx_gpio_regs = {
 	.irqstatus	= OMAP1510_GPIO_INT_STATUS,
 	.irqenable	= OMAP1510_GPIO_INT_MASK,
 	.irqenable_inv	= true,
+	.irqctrl	= OMAP1510_GPIO_INT_CONTROL,
 };
 
 static struct __initdata omap_gpio_platform_data omap15xx_gpio_config = {
diff --git a/arch/arm/mach-omap1/gpio16xx.c b/arch/arm/mach-omap1/gpio16xx.c
index 1eb47e2..46bb57a 100644
--- a/arch/arm/mach-omap1/gpio16xx.c
+++ b/arch/arm/mach-omap1/gpio16xx.c
@@ -45,6 +45,7 @@ static struct omap_gpio_reg_offs omap16xx_mpuio_regs = {
 	.irqstatus	= OMAP_MPUIO_GPIO_INT,
 	.irqenable	= OMAP_MPUIO_GPIO_MASKIT,
 	.irqenable_inv	= true,
+	.irqctrl	= OMAP_MPUIO_GPIO_INT_EDGE,
 };
 
 static struct __initdata omap_gpio_platform_data omap16xx_mpu_gpio_config = {
@@ -90,6 +91,8 @@ static struct omap_gpio_reg_offs omap16xx_gpio_regs = {
 	.set_irqenable	= OMAP1610_GPIO_SET_IRQENABLE1,
 	.clr_irqenable	= OMAP1610_GPIO_CLEAR_IRQENABLE1,
 	.wkup_en	= OMAP1610_GPIO_WAKEUPENABLE,
+	.edgectrl1	= OMAP1610_GPIO_EDGE_CTRL1,
+	.edgectrl2	= OMAP1610_GPIO_EDGE_CTRL2,
 };
 
 static struct __initdata omap_gpio_platform_data omap16xx_gpio1_config = {
diff --git a/arch/arm/mach-omap1/gpio7xx.c b/arch/arm/mach-omap1/gpio7xx.c
index 923eaa1..207a23c 100644
--- a/arch/arm/mach-omap1/gpio7xx.c
+++ b/arch/arm/mach-omap1/gpio7xx.c
@@ -47,6 +47,7 @@ static struct omap_gpio_reg_offs omap7xx_mpuio_regs = {
 	.irqstatus	= OMAP_MPUIO_GPIO_INT / 2,
 	.irqenable	= OMAP_MPUIO_GPIO_MASKIT / 2,
 	.irqenable_inv	= true,
+	.irqctrl	= OMAP_MPUIO_GPIO_INT_EDGE >> 1,
 };
 
 static struct __initdata omap_gpio_platform_data omap7xx_mpu_gpio_config = {
@@ -88,6 +89,7 @@ static struct omap_gpio_reg_offs omap7xx_gpio_regs = {
 	.irqstatus	= OMAP7XX_GPIO_INT_STATUS,
 	.irqenable	= OMAP7XX_GPIO_INT_MASK,
 	.irqenable_inv	= true,
+	.irqctrl	= OMAP7XX_GPIO_INT_CONTROL,
 };
 
 static struct __initdata omap_gpio_platform_data omap7xx_gpio1_config = {
diff --git a/arch/arm/plat-omap/include/plat/gpio.h b/arch/arm/plat-omap/include/plat/gpio.h
index 914c976..9e403e5 100644
--- a/arch/arm/plat-omap/include/plat/gpio.h
+++ b/arch/arm/plat-omap/include/plat/gpio.h
@@ -195,6 +195,9 @@ struct omap_gpio_reg_offs {
 	u16 leveldetect1;
 	u16 risingdetect;
 	u16 fallingdetect;
+	u16 irqctrl;
+	u16 edgectrl1;
+	u16 edgectrl2;
 
 	bool irqenable_inv;
 };
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index ceb9edf..f39d9e4 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -199,52 +199,32 @@ static void _set_gpio_debounce(struct gpio_bank *bank, unsigned gpio,
 	__raw_writel(val, reg);
 }
 
-#ifdef CONFIG_ARCH_OMAP2PLUS
-static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio,
+static inline void set_gpio_trigger(struct gpio_bank *bank, int gpio,
 						int trigger)
 {
 	void __iomem *base = bank->base;
 	u32 gpio_bit = 1 << gpio;
 
-	if (cpu_is_omap44xx()) {
-		_gpio_rmw(base, OMAP4_GPIO_LEVELDETECT0, gpio_bit,
-			  trigger & IRQ_TYPE_LEVEL_LOW);
-		_gpio_rmw(base, OMAP4_GPIO_LEVELDETECT1, gpio_bit,
-			  trigger & IRQ_TYPE_LEVEL_HIGH);
-		_gpio_rmw(base, OMAP4_GPIO_RISINGDETECT, gpio_bit,
-			  trigger & IRQ_TYPE_EDGE_RISING);
-		_gpio_rmw(base, OMAP4_GPIO_FALLINGDETECT, gpio_bit,
-			  trigger & IRQ_TYPE_EDGE_FALLING);
-	} else {
-		_gpio_rmw(base, OMAP24XX_GPIO_LEVELDETECT0, gpio_bit,
-			  trigger & IRQ_TYPE_LEVEL_LOW);
-		_gpio_rmw(base, OMAP24XX_GPIO_LEVELDETECT1, gpio_bit,
-			  trigger & IRQ_TYPE_LEVEL_HIGH);
-		_gpio_rmw(base, OMAP24XX_GPIO_RISINGDETECT, gpio_bit,
-			  trigger & IRQ_TYPE_EDGE_RISING);
-		_gpio_rmw(base, OMAP24XX_GPIO_FALLINGDETECT, gpio_bit,
-			  trigger & IRQ_TYPE_EDGE_FALLING);
-	}
-	if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
-		if (cpu_is_omap44xx()) {
-			_gpio_rmw(base, OMAP4_GPIO_IRQWAKEN0, gpio_bit,
-				  trigger != 0);
-		} else {
-			/*
-			 * GPIO wakeup request can only be generated on edge
-			 * transitions
-			 */
-			if (trigger & IRQ_TYPE_EDGE_BOTH)
-				__raw_writel(1 << gpio, bank->base
-					+ OMAP24XX_GPIO_SETWKUENA);
-			else
-				__raw_writel(1 << gpio, bank->base
-					+ OMAP24XX_GPIO_CLEARWKUENA);
-		}
-	}
+	_gpio_rmw(base, bank->regs->leveldetect0, gpio_bit,
+		  trigger & IRQ_TYPE_LEVEL_LOW);
+	_gpio_rmw(base, bank->regs->leveldetect1, gpio_bit,
+		  trigger & IRQ_TYPE_LEVEL_HIGH);
+	_gpio_rmw(base, bank->regs->risingdetect, gpio_bit,
+		  trigger & IRQ_TYPE_EDGE_RISING);
+	_gpio_rmw(base, bank->regs->fallingdetect, gpio_bit,
+		  trigger & IRQ_TYPE_EDGE_FALLING);
+
+	if (likely(!(bank->non_wakeup_gpios & gpio_bit)))
+		_gpio_rmw(base, bank->regs->wkup_en, gpio_bit, trigger != 0);
+
 	/* This part needs to be executed always for OMAP{34xx, 44xx} */
-	if (cpu_is_omap34xx() || cpu_is_omap44xx() ||
-			(bank->non_wakeup_gpios & gpio_bit)) {
+	if (!bank->regs->irqctrl) {
+		/* On omap24xx proceed only when valid GPIO bit is set */
+		if (bank->non_wakeup_gpios) {
+			if (!(bank->non_wakeup_gpios & gpio_bit))
+				goto exit;
+		}
+
 		/*
 		 * Log the edge gpio and manually trigger the IRQ
 		 * after resume if the input level changes
@@ -257,11 +237,11 @@ static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio,
 			bank->enabled_non_wakeup_gpios &= ~gpio_bit;
 	}
 
+exit:
 	bank->level_mask =
 		__raw_readl(bank->base + bank->regs->leveldetect0) |
 		__raw_readl(bank->base + bank->regs->leveldetect1);
 }
-#endif
 
 #ifdef CONFIG_ARCH_OMAP1
 /*
@@ -273,23 +253,10 @@ static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio)
 	void __iomem *reg = bank->base;
 	u32 l = 0;
 
-	switch (bank->method) {
-	case METHOD_MPUIO:
-		reg += OMAP_MPUIO_GPIO_INT_EDGE / bank->stride;
-		break;
-#ifdef CONFIG_ARCH_OMAP15XX
-	case METHOD_GPIO_1510:
-		reg += OMAP1510_GPIO_INT_CONTROL;
-		break;
-#endif
-#if defined(CONFIG_ARCH_OMAP730) || defined(CONFIG_ARCH_OMAP850)
-	case METHOD_GPIO_7XX:
-		reg += OMAP7XX_GPIO_INT_CONTROL;
-		break;
-#endif
-	default:
+	if (!bank->regs->irqctrl)
 		return;
-	}
+
+	reg += bank->regs->irqctrl;
 
 	l = __raw_readl(reg);
 	if ((l >> gpio) & 1)
@@ -299,31 +266,21 @@ static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio)
 
 	__raw_writel(l, reg);
 }
+#else
+static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio) {}
 #endif
 
 static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 {
 	void __iomem *reg = bank->base;
+	void __iomem *base = bank->base;
 	u32 l = 0;
 
-	switch (bank->method) {
-#ifdef CONFIG_ARCH_OMAP1
-	case METHOD_MPUIO:
-		reg += OMAP_MPUIO_GPIO_INT_EDGE / bank->stride;
-		l = __raw_readl(reg);
-		if ((trigger & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
-			bank->toggle_mask |= 1 << gpio;
-		if (trigger & IRQ_TYPE_EDGE_RISING)
-			l |= 1 << gpio;
-		else if (trigger & IRQ_TYPE_EDGE_FALLING)
-			l &= ~(1 << gpio);
-		else
-			goto bad;
-		break;
-#endif
-#ifdef CONFIG_ARCH_OMAP15XX
-	case METHOD_GPIO_1510:
-		reg += OMAP1510_GPIO_INT_CONTROL;
+	if (bank->regs->leveldetect0 && bank->regs->wkup_en) {
+		set_gpio_trigger(bank, gpio, trigger);
+	} else if (bank->regs->irqctrl) {
+		reg += bank->regs->irqctrl;
+
 		l = __raw_readl(reg);
 		if ((trigger & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
 			bank->toggle_mask |= 1 << gpio;
@@ -332,15 +289,15 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 		else if (trigger & IRQ_TYPE_EDGE_FALLING)
 			l &= ~(1 << gpio);
 		else
-			goto bad;
-		break;
-#endif
-#ifdef CONFIG_ARCH_OMAP16XX
-	case METHOD_GPIO_1610:
+			return -EINVAL;
+
+		__raw_writel(l, reg);
+	} else if (bank->regs->edgectrl1) {
 		if (gpio & 0x08)
-			reg += OMAP1610_GPIO_EDGE_CTRL2;
+			reg += bank->regs->edgectrl2;
 		else
-			reg += OMAP1610_GPIO_EDGE_CTRL1;
+			reg += bank->regs->edgectrl1;
+
 		gpio &= 0x07;
 		l = __raw_readl(reg);
 		l &= ~(3 << (gpio << 1));
@@ -348,40 +305,12 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 			l |= 2 << (gpio << 1);
 		if (trigger & IRQ_TYPE_EDGE_FALLING)
 			l |= 1 << (gpio << 1);
-		if (trigger)
-			/* Enable wake-up during idle for dynamic tick */
-			__raw_writel(1 << gpio, bank->base + OMAP1610_GPIO_SET_WAKEUPENA);
-		else
-			__raw_writel(1 << gpio, bank->base + OMAP1610_GPIO_CLEAR_WAKEUPENA);
-		break;
-#endif
-#if defined(CONFIG_ARCH_OMAP730) || defined(CONFIG_ARCH_OMAP850)
-	case METHOD_GPIO_7XX:
-		reg += OMAP7XX_GPIO_INT_CONTROL;
-		l = __raw_readl(reg);
-		if ((trigger & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
-			bank->toggle_mask |= 1 << gpio;
-		if (trigger & IRQ_TYPE_EDGE_RISING)
-			l |= 1 << gpio;
-		else if (trigger & IRQ_TYPE_EDGE_FALLING)
-			l &= ~(1 << gpio);
-		else
-			goto bad;
-		break;
-#endif
-#ifdef CONFIG_ARCH_OMAP2PLUS
-	case METHOD_GPIO_24XX:
-	case METHOD_GPIO_44XX:
-		set_24xx_gpio_triggering(bank, gpio, trigger);
-		return 0;
-#endif
-	default:
-		goto bad;
+
+		/* Enable wake-up during idle for dynamic tick */
+		_gpio_rmw(base, bank->regs->wkup_en, 1 << gpio, trigger);
+		__raw_writel(l, reg);
 	}
-	__raw_writel(l, reg);
 	return 0;
-bad:
-	return -EINVAL;
 }
 
 static int gpio_irq_type(struct irq_data *d, unsigned type)
-- 
1.7.0.4

