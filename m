Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab2BBRbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47535 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab2BBRbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:12 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Charulatha V <charu@ti.com>
Subject: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
Date: Thu, 2 Feb 2012 23:00:27 +0530
Message-ID: <1328203851-20435-2-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charulatha V <charu@ti.com>

The gpio_bank_count is the count of number of GPIO devices in a SoC. Remove this
dependency from the driver by using list. Also remove the dependency on array of
pointers to gpio_bank struct of all GPIO devices.

Signed-off-by: Charulatha V <charu@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/gpio15xx.c         |    1 -
 arch/arm/mach-omap1/gpio16xx.c         |    2 -
 arch/arm/mach-omap1/gpio7xx.c          |    2 -
 arch/arm/mach-omap2/gpio.c             |    1 -
 arch/arm/plat-omap/include/plat/gpio.h |    3 -
 drivers/gpio/gpio-omap.c               |  163 ++++++++++++++++----------------
 6 files changed, 80 insertions(+), 92 deletions(-)

diff --git a/arch/arm/mach-omap1/gpio15xx.c b/arch/arm/mach-omap1/gpio15xx.c
index 399da4c..f8c15ea 100644
--- a/arch/arm/mach-omap1/gpio15xx.c
+++ b/arch/arm/mach-omap1/gpio15xx.c
@@ -115,7 +115,6 @@ static int __init omap15xx_gpio_init(void)
 	platform_device_register(&omap15xx_mpu_gpio);
 	platform_device_register(&omap15xx_gpio);
 
-	gpio_bank_count = 2;
 	return 0;
 }
 postcore_initcall(omap15xx_gpio_init);
diff --git a/arch/arm/mach-omap1/gpio16xx.c b/arch/arm/mach-omap1/gpio16xx.c
index 0f399bd..df4bb44 100644
--- a/arch/arm/mach-omap1/gpio16xx.c
+++ b/arch/arm/mach-omap1/gpio16xx.c
@@ -221,8 +221,6 @@ static int __init omap16xx_gpio_init(void)
 	for (i = 0; i < ARRAY_SIZE(omap16xx_gpio_dev); i++)
 		platform_device_register(omap16xx_gpio_dev[i]);
 
-	gpio_bank_count = ARRAY_SIZE(omap16xx_gpio_dev);
-
 	return 0;
 }
 postcore_initcall(omap16xx_gpio_init);
diff --git a/arch/arm/mach-omap1/gpio7xx.c b/arch/arm/mach-omap1/gpio7xx.c
index 5ab63ea..923eaa1 100644
--- a/arch/arm/mach-omap1/gpio7xx.c
+++ b/arch/arm/mach-omap1/gpio7xx.c
@@ -282,8 +282,6 @@ static int __init omap7xx_gpio_init(void)
 	for (i = 0; i < ARRAY_SIZE(omap7xx_gpio_dev); i++)
 		platform_device_register(omap7xx_gpio_dev[i]);
 
-	gpio_bank_count = ARRAY_SIZE(omap7xx_gpio_dev);
-
 	return 0;
 }
 postcore_initcall(omap7xx_gpio_init);
diff --git a/arch/arm/mach-omap2/gpio.c b/arch/arm/mach-omap2/gpio.c
index 8cbfbc2..07ac648 100644
--- a/arch/arm/mach-omap2/gpio.c
+++ b/arch/arm/mach-omap2/gpio.c
@@ -111,7 +111,6 @@ static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 
 	omap_device_disable_idle_on_suspend(pdev);
 
-	gpio_bank_count++;
 	return 0;
 }
 
diff --git a/arch/arm/plat-omap/include/plat/gpio.h b/arch/arm/plat-omap/include/plat/gpio.h
index 9e86ee0..acf1c77 100644
--- a/arch/arm/plat-omap/include/plat/gpio.h
+++ b/arch/arm/plat-omap/include/plat/gpio.h
@@ -202,9 +202,6 @@ struct omap_gpio_platform_data {
 	struct omap_gpio_reg_offs *regs;
 };
 
-/* TODO: Analyze removing gpio_bank_count usage from driver code */
-extern int gpio_bank_count;
-
 extern void omap2_gpio_prepare_for_idle(int off_mode);
 extern void omap2_gpio_resume_after_idle(void);
 extern void omap_set_gpio_debounce(int gpio, int enable);
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 0b05629..6ea7390 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -28,7 +28,10 @@
 #include <asm/gpio.h>
 #include <asm/mach/irq.h>
 
+static LIST_HEAD(omap_gpio_list);
+
 struct gpio_bank {
+	struct list_head node;
 	unsigned long pbase;
 	void __iomem *base;
 	u16 irq;
@@ -55,6 +58,7 @@ struct gpio_bank {
 	bool dbck_flag;
 	int stride;
 	u32 width;
+	u16 id;
 
 	void (*set_dataout)(struct gpio_bank *bank, int gpio, int enable);
 
@@ -78,15 +82,6 @@ struct omap3_gpio_regs {
 static struct omap3_gpio_regs gpio_context[OMAP34XX_NR_GPIOS];
 #endif
 
-/*
- * TODO: Cleanup gpio_bank usage as it is having information
- * related to all instances of the device
- */
-static struct gpio_bank *gpio_bank;
-
-/* TODO: Analyze removing gpio_bank_count usage from driver code */
-int gpio_bank_count;
-
 #define GPIO_INDEX(bank, gpio) (gpio % bank->width)
 #define GPIO_BIT(bank, gpio) (1 << GPIO_INDEX(bank, gpio))
 
@@ -869,9 +864,8 @@ static struct platform_device omap_mpuio_device = {
 	/* could list the /proc/iomem resources */
 };
 
-static inline void mpuio_init(void)
+static inline void mpuio_init(struct gpio_bank *bank)
 {
-	struct gpio_bank *bank = &gpio_bank[0];
 	platform_set_drvdata(&omap_mpuio_device, bank);
 
 	if (platform_driver_register(&omap_mpuio_driver) == 0)
@@ -879,13 +873,13 @@ static inline void mpuio_init(void)
 }
 
 #else
-static inline void mpuio_init(void) {}
+static inline void mpuio_init(struct gpio_bank *bank) {}
 #endif	/* 16xx */
 
 #else
 
 #define bank_is_mpuio(bank)	0
-static inline void mpuio_init(void) {}
+static inline void mpuio_init(struct gpio_bank *bank) {}
 
 #endif
 
@@ -1007,20 +1001,8 @@ static void __init omap_gpio_show_rev(struct gpio_bank *bank)
  */
 static struct lock_class_key gpio_lock_class;
 
-static inline int init_gpio_info(struct platform_device *pdev)
-{
-	/* TODO: Analyze removing gpio_bank_count usage from driver code */
-	gpio_bank = kzalloc(gpio_bank_count * sizeof(struct gpio_bank),
-				GFP_KERNEL);
-	if (!gpio_bank) {
-		dev_err(&pdev->dev, "Memory alloc failed for gpio_bank\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
 /* TODO: Cleanup cpu_is_* checks */
-static void omap_gpio_mod_init(struct gpio_bank *bank, int id)
+static void omap_gpio_mod_init(struct gpio_bank *bank)
 {
 	if (cpu_class_is_omap2()) {
 		if (cpu_is_omap44xx()) {
@@ -1044,13 +1026,16 @@ static void omap_gpio_mod_init(struct gpio_bank *bank, int id)
 			static const u32 non_wakeup_gpios[] = {
 				0xe203ffc0, 0x08700040
 			};
-			if (id < ARRAY_SIZE(non_wakeup_gpios))
-				bank->non_wakeup_gpios = non_wakeup_gpios[id];
+			if (bank->id < ARRAY_SIZE(non_wakeup_gpios))
+				bank->non_wakeup_gpios =
+						non_wakeup_gpios[bank->id];
 		}
 	} else if (cpu_class_is_omap1()) {
-		if (bank_is_mpuio(bank))
+		if (bank_is_mpuio(bank)) {
 			__raw_writew(0xffff, bank->base +
 				OMAP_MPUIO_GPIO_MASKIT / bank->stride);
+			mpuio_init(bank);
+		}
 		if (cpu_is_omap15xx() && bank->method == METHOD_GPIO_1510) {
 			__raw_writew(0xffff, bank->base
 						+ OMAP1510_GPIO_INT_MASK);
@@ -1161,35 +1146,35 @@ static void __devinit omap_gpio_chip_init(struct gpio_bank *bank)
 
 static int __devinit omap_gpio_probe(struct platform_device *pdev)
 {
-	static int gpio_init_done;
 	struct omap_gpio_platform_data *pdata;
 	struct resource *res;
-	int id;
 	struct gpio_bank *bank;
+	int ret = 0;
 
-	if (!pdev->dev.platform_data)
-		return -EINVAL;
-
-	pdata = pdev->dev.platform_data;
-
-	if (!gpio_init_done) {
-		int ret;
-
-		ret = init_gpio_info(pdev);
-		if (ret)
-			return ret;
+	if (!pdev->dev.platform_data) {
+		ret = -EINVAL;
+		goto err_exit;
 	}
 
-	id = pdev->id;
-	bank = &gpio_bank[id];
+	bank = kzalloc(sizeof(struct gpio_bank), GFP_KERNEL);
+	if (!bank) {
+		dev_err(&pdev->dev, "Memory alloc failed for gpio_bank\n");
+		ret = -ENOMEM;
+		goto err_exit;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (unlikely(!res)) {
-		dev_err(&pdev->dev, "GPIO Bank %i Invalid IRQ resource\n", id);
-		return -ENODEV;
+		dev_err(&pdev->dev, "GPIO Bank %i Invalid IRQ resource\n",
+				pdev->id);
+		ret = -ENODEV;
+		goto err_free;
 	}
 
 	bank->irq = res->start;
+	bank->id = pdev->id;
+
+	pdata = pdev->dev.platform_data;
 	bank->virtual_irq_start = pdata->virtual_irq_start;
 	bank->method = pdata->bank_type;
 	bank->dev = &pdev->dev;
@@ -1209,39 +1194,46 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
 	/* Static mapping, never released */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (unlikely(!res)) {
-		dev_err(&pdev->dev, "GPIO Bank %i Invalid mem resource\n", id);
-		return -ENODEV;
+		dev_err(&pdev->dev, "GPIO Bank %i Invalid mem resource\n",
+				pdev->id);
+		ret = -ENODEV;
+		goto err_free;
 	}
 
 	bank->base = ioremap(res->start, resource_size(res));
 	if (!bank->base) {
-		dev_err(&pdev->dev, "Could not ioremap gpio bank%i\n", id);
-		return -ENOMEM;
+		dev_err(&pdev->dev, "Could not ioremap gpio bank%i\n",
+				pdev->id);
+		ret = -ENOMEM;
+		goto err_free;
 	}
 
 	pm_runtime_enable(bank->dev);
 	pm_runtime_get_sync(bank->dev);
 
-	omap_gpio_mod_init(bank, id);
+	omap_gpio_mod_init(bank);
 	omap_gpio_chip_init(bank);
 	omap_gpio_show_rev(bank);
 
-	if (!gpio_init_done)
-		gpio_init_done = 1;
+	list_add_tail(&bank->node, &omap_gpio_list);
 
-	return 0;
+	return ret;
+
+err_free:
+	kfree(bank);
+err_exit:
+	return ret;
 }
 
 #if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2PLUS)
 static int omap_gpio_suspend(void)
 {
-	int i;
+	struct gpio_bank *bank;
 
 	if (!cpu_class_is_omap2() && !cpu_is_omap16xx())
 		return 0;
 
-	for (i = 0; i < gpio_bank_count; i++) {
-		struct gpio_bank *bank = &gpio_bank[i];
+	list_for_each_entry(bank, &omap_gpio_list, node) {
 		void __iomem *wake_status;
 		void __iomem *wake_clear;
 		void __iomem *wake_set;
@@ -1285,13 +1277,12 @@ static int omap_gpio_suspend(void)
 
 static void omap_gpio_resume(void)
 {
-	int i;
+	struct gpio_bank *bank;
 
 	if (!cpu_class_is_omap2() && !cpu_is_omap16xx())
 		return;
 
-	for (i = 0; i < gpio_bank_count; i++) {
-		struct gpio_bank *bank = &gpio_bank[i];
+	list_for_each_entry(bank, &omap_gpio_list, node) {
 		void __iomem *wake_clear;
 		void __iomem *wake_set;
 		unsigned long flags;
@@ -1339,17 +1330,17 @@ static int workaround_enabled;
 
 void omap2_gpio_prepare_for_idle(int off_mode)
 {
-	int i, c = 0;
-	int min = 0;
-
-	if (cpu_is_omap34xx())
-		min = 1;
+	int c = 0;
+	struct gpio_bank *bank;
 
-	for (i = min; i < gpio_bank_count; i++) {
-		struct gpio_bank *bank = &gpio_bank[i];
+	list_for_each_entry(bank, &omap_gpio_list, node) {
 		u32 l1 = 0, l2 = 0;
 		int j;
 
+		/* TODO: Do not use cpu_is_omap34xx */
+		if ((cpu_is_omap34xx()) && (bank->id == 0))
+			continue;
+
 		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
 			clk_disable(bank->dbck);
 
@@ -1408,16 +1399,16 @@ void omap2_gpio_prepare_for_idle(int off_mode)
 
 void omap2_gpio_resume_after_idle(void)
 {
-	int i;
-	int min = 0;
+	struct gpio_bank *bank;
 
-	if (cpu_is_omap34xx())
-		min = 1;
-	for (i = min; i < gpio_bank_count; i++) {
-		struct gpio_bank *bank = &gpio_bank[i];
+	list_for_each_entry(bank, &omap_gpio_list, node) {
 		u32 l = 0, gen, gen0, gen1;
 		int j;
 
+		/* TODO: Do not use cpu_is_omap34xx */
+		if ((cpu_is_omap34xx()) && (bank->id == 0))
+			continue;
+
 		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
 			clk_enable(bank->dbck);
 
@@ -1506,14 +1497,17 @@ void omap2_gpio_resume_after_idle(void)
 #endif
 
 #ifdef CONFIG_ARCH_OMAP3
-/* save the registers of bank 2-6 */
 void omap_gpio_save_context(void)
 {
-	int i;
+	struct gpio_bank *bank;
+	int i = 0;
+
+	list_for_each_entry(bank, &omap_gpio_list, node) {
+		i++;
+
+		if (bank->id == 0)
+			continue;
 
-	/* saving banks from 2-6 only since GPIO1 is in WKUP */
-	for (i = 1; i < gpio_bank_count; i++) {
-		struct gpio_bank *bank = &gpio_bank[i];
 		gpio_context[i].irqenable1 =
 			__raw_readl(bank->base + OMAP24XX_GPIO_IRQENABLE1);
 		gpio_context[i].irqenable2 =
@@ -1537,13 +1531,17 @@ void omap_gpio_save_context(void)
 	}
 }
 
-/* restore the required registers of bank 2-6 */
 void omap_gpio_restore_context(void)
 {
-	int i;
+	struct gpio_bank *bank;
+	int i = 0;
+
+	list_for_each_entry(bank, &omap_gpio_list, node) {
+		i++;
+
+		if (bank->id == 0)
+			continue;
 
-	for (i = 1; i < gpio_bank_count; i++) {
-		struct gpio_bank *bank = &gpio_bank[i];
 		__raw_writel(gpio_context[i].irqenable1,
 				bank->base + OMAP24XX_GPIO_IRQENABLE1);
 		__raw_writel(gpio_context[i].irqenable2,
@@ -1588,7 +1586,6 @@ postcore_initcall(omap_gpio_drv_reg);
 
 static int __init omap_gpio_sysinit(void)
 {
-	mpuio_init();
 
 #if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2PLUS)
 	if (cpu_is_omap16xx() || cpu_class_is_omap2())
-- 
1.7.0.4

