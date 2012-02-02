Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab2BBRdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:33:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57673 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab2BBRb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:27 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, Charulatha V <charu@ti.com>
Subject: [PATCH v9 11/25] gpio/omap: cleanup omap_gpio_mod_init function
Date: Thu, 2 Feb 2012 23:00:37 +0530
Message-ID: <1328203851-20435-12-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With register offsets now defined for respective OMAP versions we can get rid
of cpu_class_* checks. This function now has common initialization code for
all OMAP versions. Initialization specific to OMAP16xx has been moved within
omap16xx_gpio_init().

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Signed-off-by: Charulatha V <charu@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/gpio16xx.c |   35 +++++++++++++++++-
 drivers/gpio/gpio-omap.c       |   77 ++++++++++++----------------------------
 2 files changed, 57 insertions(+), 55 deletions(-)

diff --git a/arch/arm/mach-omap1/gpio16xx.c b/arch/arm/mach-omap1/gpio16xx.c
index 46bb57a..86ac415 100644
--- a/arch/arm/mach-omap1/gpio16xx.c
+++ b/arch/arm/mach-omap1/gpio16xx.c
@@ -24,6 +24,9 @@
 #define OMAP1610_GPIO4_BASE		0xfffbbc00
 #define OMAP1_MPUIO_VBASE		OMAP1_MPUIO_BASE
 
+/* smart idle, enable wakeup */
+#define SYSCONFIG_WORD			0x14
+
 /* mpu gpio */
 static struct __initdata resource omap16xx_mpu_gpio_resources[] = {
 	{
@@ -218,12 +221,42 @@ static struct __initdata platform_device * omap16xx_gpio_dev[] = {
 static int __init omap16xx_gpio_init(void)
 {
 	int i;
+	void __iomem *base;
+	struct resource *res;
+	struct platform_device *pdev;
+	struct omap_gpio_platform_data *pdata;
 
 	if (!cpu_is_omap16xx())
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(omap16xx_gpio_dev); i++)
+	for (i = 0; i < ARRAY_SIZE(omap16xx_gpio_dev); i++) {
+		pdev = omap16xx_gpio_dev[i];
+		pdata = pdev->dev.platform_data;
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		if (unlikely(!res)) {
+			dev_err(&pdev->dev, "Invalid mem resource.\n");
+			return -ENODEV;
+		}
+
+		base = ioremap(res->start, resource_size(res));
+		if (unlikely(!base)) {
+			dev_err(&pdev->dev, "ioremap failed.\n");
+			return -ENOMEM;
+		}
+
+		__raw_writel(SYSCONFIG_WORD, base + OMAP1610_GPIO_SYSCONFIG);
+		iounmap(base);
+
+		/*
+		 * Enable system clock for GPIO module.
+		 * The CAM_CLK_CTRL *is* really the right place.
+		 */
+		omap_writel(omap_readl(ULPD_CAM_CLK_CTRL) | 0x04,
+					ULPD_CAM_CLK_CTRL);
+
 		platform_device_register(omap16xx_gpio_dev[i]);
+	}
 
 	return 0;
 }
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index f39d9e4..a948351 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -610,7 +610,6 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 			if (!(isr & 1))
 				continue;
 
-#ifdef CONFIG_ARCH_OMAP1
 			/*
 			 * Some chips can't respond to both rising and falling
 			 * at the same time.  If this irq was requested with
@@ -620,7 +619,6 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 			 */
 			if (bank->toggle_mask & (1 << gpio_index))
 				_toggle_gpio_edge_triggering(bank, gpio_index);
-#endif
 
 			generic_handle_irq(gpio_irq);
 		}
@@ -898,62 +896,30 @@ static void __init omap_gpio_show_rev(struct gpio_bank *bank)
  */
 static struct lock_class_key gpio_lock_class;
 
-/* TODO: Cleanup cpu_is_* checks */
 static void omap_gpio_mod_init(struct gpio_bank *bank)
 {
-	if (cpu_class_is_omap2()) {
-		if (cpu_is_omap44xx()) {
-			__raw_writel(0xffffffff, bank->base +
-					OMAP4_GPIO_IRQSTATUSCLR0);
-			__raw_writel(0x00000000, bank->base +
-					 OMAP4_GPIO_DEBOUNCENABLE);
-			/* Initialize interface clk ungated, module enabled */
-			__raw_writel(0, bank->base + OMAP4_GPIO_CTRL);
-		} else if (cpu_is_omap34xx()) {
-			__raw_writel(0x00000000, bank->base +
-					OMAP24XX_GPIO_IRQENABLE1);
-			__raw_writel(0xffffffff, bank->base +
-					OMAP24XX_GPIO_IRQSTATUS1);
-			__raw_writel(0x00000000, bank->base +
-					OMAP24XX_GPIO_DEBOUNCE_EN);
-
-			/* Initialize interface clk ungated, module enabled */
-			__raw_writel(0, bank->base + OMAP24XX_GPIO_CTRL);
-		}
-	} else if (cpu_class_is_omap1()) {
-		if (bank_is_mpuio(bank)) {
-			__raw_writew(0xffff, bank->base +
-				OMAP_MPUIO_GPIO_MASKIT / bank->stride);
-			mpuio_init(bank);
-		}
-		if (cpu_is_omap15xx() && bank->method == METHOD_GPIO_1510) {
-			__raw_writew(0xffff, bank->base
-						+ OMAP1510_GPIO_INT_MASK);
-			__raw_writew(0x0000, bank->base
-						+ OMAP1510_GPIO_INT_STATUS);
-		}
-		if (cpu_is_omap16xx() && bank->method == METHOD_GPIO_1610) {
-			__raw_writew(0x0000, bank->base
-						+ OMAP1610_GPIO_IRQENABLE1);
-			__raw_writew(0xffff, bank->base
-						+ OMAP1610_GPIO_IRQSTATUS1);
-			__raw_writew(0x0014, bank->base
-						+ OMAP1610_GPIO_SYSCONFIG);
+	void __iomem *base = bank->base;
+	u32 l = 0xffffffff;
 
-			/*
-			 * Enable system clock for GPIO module.
-			 * The CAM_CLK_CTRL *is* really the right place.
-			 */
-			omap_writel(omap_readl(ULPD_CAM_CLK_CTRL) | 0x04,
-						ULPD_CAM_CLK_CTRL);
-		}
-		if (cpu_is_omap7xx() && bank->method == METHOD_GPIO_7XX) {
-			__raw_writel(0xffffffff, bank->base
-						+ OMAP7XX_GPIO_INT_MASK);
-			__raw_writel(0x00000000, bank->base
-						+ OMAP7XX_GPIO_INT_STATUS);
-		}
+	if (bank->width == 16)
+		l = 0xffff;
+
+	if (bank_is_mpuio(bank)) {
+		__raw_writel(l, bank->base + bank->regs->irqenable);
+		return;
 	}
+
+	_gpio_rmw(base, bank->regs->irqenable, l, bank->regs->irqenable_inv);
+	_gpio_rmw(base, bank->regs->irqstatus, l,
+					bank->regs->irqenable_inv == false);
+	_gpio_rmw(base, bank->regs->irqenable, l, bank->regs->debounce_en != 0);
+	_gpio_rmw(base, bank->regs->irqenable, l, bank->regs->ctrl != 0);
+	if (bank->regs->debounce_en)
+		_gpio_rmw(base, bank->regs->debounce_en, 0, 1);
+
+	 /* Initialize interface clk ungated, module enabled */
+	if (bank->regs->ctrl)
+		_gpio_rmw(base, bank->regs->ctrl, 0, 1);
 }
 
 static __init void
@@ -1104,6 +1070,9 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
 	pm_runtime_enable(bank->dev);
 	pm_runtime_get_sync(bank->dev);
 
+	if (bank_is_mpuio(bank))
+		mpuio_init(bank);
+
 	omap_gpio_mod_init(bank);
 	omap_gpio_chip_init(bank);
 	omap_gpio_show_rev(bank);
-- 
1.7.0.4

