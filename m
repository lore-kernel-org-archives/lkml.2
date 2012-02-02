Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2BBRb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57657 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932715Ab2BBRbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:19 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, Charulatha V <charu@ti.com>
Subject: [PATCH v9 04/25] gpio/omap: handle save/restore context in GPIO driver
Date: Thu, 2 Feb 2012 23:00:30 +0530
Message-ID: <1328203851-20435-5-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify omap_gpio_prepare_for_idle() & omap_gpio_resume_after_idle() functions
to handle save context & restore context respectively in the OMAP GPIO driver
itself instead of calling these functions from pm specific files.
For this, in gpio_prepare_for_idle(), call *_get_context_loss_count() and in
gpio_resume_after_idle() call it again. If the count is different, do restore
context.

Signed-off-by: Charulatha V <charu@ti.com>
Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/gpio.c             |    3 +-
 arch/arm/mach-omap2/pm34xx.c           |   14 ----
 arch/arm/plat-omap/include/plat/gpio.h |    5 +-
 drivers/gpio/gpio-omap.c               |  131 ++++++++++++++------------------
 4 files changed, 63 insertions(+), 90 deletions(-)

diff --git a/arch/arm/mach-omap2/gpio.c b/arch/arm/mach-omap2/gpio.c
index 076be34..f84db8f 100644
--- a/arch/arm/mach-omap2/gpio.c
+++ b/arch/arm/mach-omap2/gpio.c
@@ -23,6 +23,7 @@
 
 #include <plat/omap_hwmod.h>
 #include <plat/omap_device.h>
+#include <plat/omap-pm.h>
 
 #include "powerdomain.h"
 
@@ -55,7 +56,7 @@ static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 	pdata->bank_width = dev_attr->bank_width;
 	pdata->dbck_flag = dev_attr->dbck_flag;
 	pdata->virtual_irq_start = IH_GPIO_BASE + 32 * (id - 1);
-
+	pdata->get_context_loss_count = omap_pm_get_dev_context_loss_count;
 	pdata->regs = kzalloc(sizeof(struct omap_gpio_reg_offs), GFP_KERNEL);
 	if (!pdata) {
 		pr_err("gpio%d: Memory allocation failed\n", id);
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index fc69875..59c6dc1 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -75,16 +75,6 @@ static struct powerdomain *mpu_pwrdm, *neon_pwrdm;
 static struct powerdomain *core_pwrdm, *per_pwrdm;
 static struct powerdomain *cam_pwrdm;
 
-static inline void omap3_per_save_context(void)
-{
-	omap_gpio_save_context();
-}
-
-static inline void omap3_per_restore_context(void)
-{
-	omap_gpio_restore_context();
-}
-
 static void omap3_enable_io_chain(void)
 {
 	int timeout = 0;
@@ -332,8 +322,6 @@ void omap_sram_idle(void)
 	if (per_next_state < PWRDM_POWER_ON) {
 		per_going_off = (per_next_state == PWRDM_POWER_OFF) ? 1 : 0;
 		omap2_gpio_prepare_for_idle(per_going_off);
-		if (per_next_state == PWRDM_POWER_OFF)
-				omap3_per_save_context();
 	}
 
 	/* CORE */
@@ -399,8 +387,6 @@ void omap_sram_idle(void)
 	if (per_next_state < PWRDM_POWER_ON) {
 		per_prev_state = pwrdm_read_prev_pwrst(per_pwrdm);
 		omap2_gpio_resume_after_idle();
-		if (per_prev_state == PWRDM_POWER_OFF)
-			omap3_per_restore_context();
 	}
 
 	/* Disable IO-PAD and IO-CHAIN wakeup */
diff --git a/arch/arm/plat-omap/include/plat/gpio.h b/arch/arm/plat-omap/include/plat/gpio.h
index 6eb035c..c1ddc5a 100644
--- a/arch/arm/plat-omap/include/plat/gpio.h
+++ b/arch/arm/plat-omap/include/plat/gpio.h
@@ -201,14 +201,15 @@ struct omap_gpio_platform_data {
 	bool loses_context;	/* whether the bank would ever lose context */
 
 	struct omap_gpio_reg_offs *regs;
+
+	/* Return context loss count due to PM states changing */
+	int (*get_context_loss_count)(struct device *dev);
 };
 
 extern void omap2_gpio_prepare_for_idle(int off_mode);
 extern void omap2_gpio_resume_after_idle(void);
 extern void omap_set_gpio_debounce(int gpio, int enable);
 extern void omap_set_gpio_debounce_time(int gpio, int enable);
-extern void omap_gpio_save_context(void);
-extern void omap_gpio_restore_context(void);
 /*-------------------------------------------------------------------------*/
 
 /* Wrappers for "new style" GPIO calls, using the new infrastructure
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 6788c8a..a1a3b9d 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -72,9 +72,11 @@ struct gpio_bank {
 	bool loses_context;
 	int stride;
 	u32 width;
+	int context_loss_count;
 	u16 id;
 
 	void (*set_dataout)(struct gpio_bank *bank, int gpio, int enable);
+	int (*get_context_loss_count)(struct device *dev);
 
 	struct omap_gpio_reg_offs *regs;
 };
@@ -1179,6 +1181,7 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
 	bank->stride = pdata->bank_stride;
 	bank->width = pdata->bank_width;
 	bank->loses_context = pdata->loses_context;
+	bank->get_context_loss_count = pdata->get_context_loss_count;
 	bank->regs = pdata->regs;
 
 	if (bank->regs->set_dataout && bank->regs->clr_dataout)
@@ -1323,11 +1326,11 @@ static struct syscore_ops omap_gpio_syscore_ops = {
 
 #ifdef CONFIG_ARCH_OMAP2PLUS
 
-static int workaround_enabled;
+static void omap_gpio_save_context(struct gpio_bank *bank);
+static void omap_gpio_restore_context(struct gpio_bank *bank);
 
 void omap2_gpio_prepare_for_idle(int off_mode)
 {
-	int c = 0;
 	struct gpio_bank *bank;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
@@ -1347,7 +1350,7 @@ void omap2_gpio_prepare_for_idle(int off_mode)
 		 * non-wakeup GPIOs.  Otherwise spurious IRQs will be
 		 * generated.  See OMAP2420 Errata item 1.101. */
 		if (!(bank->enabled_non_wakeup_gpios))
-			continue;
+			goto save_gpio_context;
 
 		if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
 			bank->saved_datain = __raw_readl(bank->base +
@@ -1384,13 +1387,13 @@ void omap2_gpio_prepare_for_idle(int off_mode)
 			__raw_writel(l2, bank->base + OMAP4_GPIO_RISINGDETECT);
 		}
 
-		c++;
-	}
-	if (!c) {
-		workaround_enabled = 0;
-		return;
+save_gpio_context:
+		if (bank->get_context_loss_count)
+			bank->context_loss_count =
+				bank->get_context_loss_count(bank->dev);
+
+		omap_gpio_save_context(bank);
 	}
-	workaround_enabled = 1;
 }
 
 void omap2_gpio_resume_after_idle(void)
@@ -1398,6 +1401,7 @@ void omap2_gpio_resume_after_idle(void)
 	struct gpio_bank *bank;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
+		int context_lost_cnt_after;
 		u32 l = 0, gen, gen0, gen1;
 		int j;
 
@@ -1407,8 +1411,13 @@ void omap2_gpio_resume_after_idle(void)
 		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
 			clk_enable(bank->dbck);
 
-		if (!workaround_enabled)
-			continue;
+		if (bank->get_context_loss_count) {
+			context_lost_cnt_after =
+				bank->get_context_loss_count(bank->dev);
+			if (context_lost_cnt_after != bank->context_loss_count
+				|| !context_lost_cnt_after)
+				omap_gpio_restore_context(bank);
+		}
 
 		if (!(bank->enabled_non_wakeup_gpios))
 			continue;
@@ -1486,74 +1495,50 @@ void omap2_gpio_resume_after_idle(void)
 			}
 		}
 	}
-
 }
 
-#endif
-
-#ifdef CONFIG_ARCH_OMAP3
-void omap_gpio_save_context(void)
+static void omap_gpio_save_context(struct gpio_bank *bank)
 {
-	struct gpio_bank *bank;
-
-	list_for_each_entry(bank, &omap_gpio_list, node) {
-
-		if (!bank->loses_context)
-			continue;
-
-		bank->context.irqenable1 =
-			__raw_readl(bank->base + OMAP24XX_GPIO_IRQENABLE1);
-		bank->context.irqenable2 =
-			__raw_readl(bank->base + OMAP24XX_GPIO_IRQENABLE2);
-		bank->context.wake_en =
-			__raw_readl(bank->base + OMAP24XX_GPIO_WAKE_EN);
-		bank->context.ctrl =
-			__raw_readl(bank->base + OMAP24XX_GPIO_CTRL);
-		bank->context.oe =
-			__raw_readl(bank->base + OMAP24XX_GPIO_OE);
-		bank->context.leveldetect0 =
-			__raw_readl(bank->base + OMAP24XX_GPIO_LEVELDETECT0);
-		bank->context.leveldetect1 =
-			__raw_readl(bank->base + OMAP24XX_GPIO_LEVELDETECT1);
-		bank->context.risingdetect =
-			__raw_readl(bank->base + OMAP24XX_GPIO_RISINGDETECT);
-		bank->context.fallingdetect =
-			__raw_readl(bank->base + OMAP24XX_GPIO_FALLINGDETECT);
-		bank->context.dataout =
-			__raw_readl(bank->base + OMAP24XX_GPIO_DATAOUT);
-	}
+	bank->context.irqenable1 =
+		__raw_readl(bank->base + OMAP24XX_GPIO_IRQENABLE1);
+	bank->context.irqenable2 =
+		__raw_readl(bank->base + OMAP24XX_GPIO_IRQENABLE2);
+	bank->context.wake_en =
+		__raw_readl(bank->base + OMAP24XX_GPIO_WAKE_EN);
+	bank->context.ctrl = __raw_readl(bank->base + OMAP24XX_GPIO_CTRL);
+	bank->context.oe = __raw_readl(bank->base + OMAP24XX_GPIO_OE);
+	bank->context.leveldetect0 =
+		__raw_readl(bank->base + OMAP24XX_GPIO_LEVELDETECT0);
+	bank->context.leveldetect1 =
+		__raw_readl(bank->base + OMAP24XX_GPIO_LEVELDETECT1);
+	bank->context.risingdetect =
+		__raw_readl(bank->base + OMAP24XX_GPIO_RISINGDETECT);
+	bank->context.fallingdetect =
+		__raw_readl(bank->base + OMAP24XX_GPIO_FALLINGDETECT);
+	bank->context.dataout =
+		__raw_readl(bank->base + OMAP24XX_GPIO_DATAOUT);
 }
 
-void omap_gpio_restore_context(void)
+static void omap_gpio_restore_context(struct gpio_bank *bank)
 {
-	struct gpio_bank *bank;
-
-	list_for_each_entry(bank, &omap_gpio_list, node) {
-
-		if (!bank->loses_context)
-			continue;
-
-		__raw_writel(bank->context.irqenable1,
-				bank->base + OMAP24XX_GPIO_IRQENABLE1);
-		__raw_writel(bank->context.irqenable2,
-				bank->base + OMAP24XX_GPIO_IRQENABLE2);
-		__raw_writel(bank->context.wake_en,
-				bank->base + OMAP24XX_GPIO_WAKE_EN);
-		__raw_writel(bank->context.ctrl,
-				bank->base + OMAP24XX_GPIO_CTRL);
-		__raw_writel(bank->context.oe,
-				bank->base + OMAP24XX_GPIO_OE);
-		__raw_writel(bank->context.leveldetect0,
-				bank->base + OMAP24XX_GPIO_LEVELDETECT0);
-		__raw_writel(bank->context.leveldetect1,
-				bank->base + OMAP24XX_GPIO_LEVELDETECT1);
-		__raw_writel(bank->context.risingdetect,
-				bank->base + OMAP24XX_GPIO_RISINGDETECT);
-		__raw_writel(bank->context.fallingdetect,
-				bank->base + OMAP24XX_GPIO_FALLINGDETECT);
-		__raw_writel(bank->context.dataout,
-				bank->base + OMAP24XX_GPIO_DATAOUT);
-	}
+	__raw_writel(bank->context.irqenable1,
+			bank->base + OMAP24XX_GPIO_IRQENABLE1);
+	__raw_writel(bank->context.irqenable2,
+			bank->base + OMAP24XX_GPIO_IRQENABLE2);
+	__raw_writel(bank->context.wake_en,
+			bank->base + OMAP24XX_GPIO_WAKE_EN);
+	__raw_writel(bank->context.ctrl, bank->base + OMAP24XX_GPIO_CTRL);
+	__raw_writel(bank->context.oe, bank->base + OMAP24XX_GPIO_OE);
+	__raw_writel(bank->context.leveldetect0,
+			bank->base + OMAP24XX_GPIO_LEVELDETECT0);
+	__raw_writel(bank->context.leveldetect1,
+			bank->base + OMAP24XX_GPIO_LEVELDETECT1);
+	__raw_writel(bank->context.risingdetect,
+			bank->base + OMAP24XX_GPIO_RISINGDETECT);
+	__raw_writel(bank->context.fallingdetect,
+			bank->base + OMAP24XX_GPIO_FALLINGDETECT);
+	__raw_writel(bank->context.dataout,
+			bank->base + OMAP24XX_GPIO_DATAOUT);
 }
 #endif
 
-- 
1.7.0.4

