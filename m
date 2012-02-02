Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab2BBRds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:33:48 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34238 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932803Ab2BBRb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:27 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, Charulatha V <charu@ti.com>
Subject: [PATCH v9 16/25] gpio/omap: use pm-runtime framework
Date: Thu, 2 Feb 2012 23:00:42 +0530
Message-ID: <1328203851-20435-17-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call runtime pm APIs pm_runtime_get_sync() and pm_runtime_put()
for enabling/disabling clocks appropriately. Remove syscore_ops and
instead use SET_RUNTIME_PM_OPS macro.

There is no more need to call omap_device_disable_idle_on_suspend
since driver is PM runtime adapted now.

Signed-off-by: Charulatha V <charu@ti.com>
Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mach-omap2/gpio.c |    2 -
 drivers/gpio/gpio-omap.c   |   65 ++++++++++++++++++++++++++++---------------
 2 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-omap2/gpio.c b/arch/arm/mach-omap2/gpio.c
index dfda6b3..1e0b750 100644
--- a/arch/arm/mach-omap2/gpio.c
+++ b/arch/arm/mach-omap2/gpio.c
@@ -136,8 +136,6 @@ static int omap2_gpio_dev_init(struct omap_hwmod *oh, void *unused)
 		return PTR_ERR(pdev);
 	}
 
-	omap_device_disable_idle_on_suspend(pdev);
-
 	return 0;
 }
 
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 951d784..b92a23f 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -21,6 +21,7 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm.h>
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
@@ -483,8 +484,14 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 	struct gpio_bank *bank = container_of(chip, struct gpio_bank, chip);
 	unsigned long flags;
 
-	spin_lock_irqsave(&bank->lock, flags);
+	/*
+	 * If this is the first gpio_request for the bank,
+	 * enable the bank module.
+	 */
+	if (!bank->mod_usage)
+		pm_runtime_get_sync(bank->dev);
 
+	spin_lock_irqsave(&bank->lock, flags);
 	/* Set trigger to none. You need to enable the desired trigger with
 	 * request_irq() or set_irq_type().
 	 */
@@ -540,6 +547,13 @@ static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 
 	_reset_gpio(bank, bank->chip.base + offset);
 	spin_unlock_irqrestore(&bank->lock, flags);
+
+	/*
+	 * If this is the last gpio to be freed in the bank,
+	 * disable the bank module.
+	 */
+	if (!bank->mod_usage)
+		pm_runtime_put(bank->dev);
 }
 
 /*
@@ -565,6 +579,7 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 
 	bank = irq_get_handler_data(irq);
 	isr_reg = bank->base + bank->regs->irqstatus;
+	pm_runtime_get_sync(bank->dev);
 
 	if (WARN_ON(!isr_reg))
 		goto exit;
@@ -625,6 +640,7 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 exit:
 	if (!unmasked)
 		chained_irq_exit(chip, desc);
+	pm_runtime_put(bank->dev);
 }
 
 static void gpio_irq_shutdown(struct irq_data *d)
@@ -1037,6 +1053,7 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_enable(bank->dev);
+	pm_runtime_irq_safe(bank->dev);
 	pm_runtime_get_sync(bank->dev);
 
 	if (bank->is_mpuio)
@@ -1046,6 +1063,8 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
 	omap_gpio_chip_init(bank);
 	omap_gpio_show_rev(bank);
 
+	pm_runtime_put(bank->dev);
+
 	list_add_tail(&bank->node, &omap_gpio_list);
 
 	return ret;
@@ -1056,7 +1075,9 @@ err_exit:
 	return ret;
 }
 
-static int omap_gpio_suspend(void)
+#ifdef CONFIG_ARCH_OMAP2PLUS
+
+static int omap_gpio_suspend(struct device *dev)
 {
 	struct gpio_bank *bank;
 
@@ -1080,7 +1101,7 @@ static int omap_gpio_suspend(void)
 	return 0;
 }
 
-static void omap_gpio_resume(void)
+static int omap_gpio_resume(struct device *dev)
 {
 	struct gpio_bank *bank;
 
@@ -1089,21 +1110,17 @@ static void omap_gpio_resume(void)
 		unsigned long flags;
 
 		if (!bank->regs->wkup_en)
-			return;
+			return 0;
 
 		spin_lock_irqsave(&bank->lock, flags);
 		_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
 		_gpio_rmw(base, bank->regs->wkup_en, bank->saved_wakeup, 1);
 		spin_unlock_irqrestore(&bank->lock, flags);
 	}
+
+	return 0;
 }
 
-static struct syscore_ops omap_gpio_syscore_ops = {
-	.suspend	= omap_gpio_suspend,
-	.resume		= omap_gpio_resume,
-};
-
-#ifdef CONFIG_ARCH_OMAP2PLUS
 
 static void omap_gpio_save_context(struct gpio_bank *bank);
 static void omap_gpio_restore_context(struct gpio_bank *bank);
@@ -1145,11 +1162,15 @@ void omap2_gpio_prepare_for_idle(int off_mode)
 		__raw_writel(l2, bank->base + bank->regs->risingdetect);
 
 save_gpio_context:
+
 		if (bank->get_context_loss_count)
 			bank->context_loss_count =
 				bank->get_context_loss_count(bank->dev);
 
 		omap_gpio_save_context(bank);
+
+		if (!pm_runtime_suspended(bank->dev))
+			pm_runtime_put(bank->dev);
 	}
 }
 
@@ -1168,6 +1189,9 @@ void omap2_gpio_resume_after_idle(void)
 		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
 			clk_enable(bank->dbck);
 
+		if (pm_runtime_suspended(bank->dev))
+			pm_runtime_get_sync(bank->dev);
+
 		if (bank->get_context_loss_count) {
 			context_lost_cnt_after =
 				bank->get_context_loss_count(bank->dev);
@@ -1274,12 +1298,20 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
 				bank->base + bank->regs->fallingdetect);
 	__raw_writel(bank->context.dataout, bank->base + bank->regs->dataout);
 }
+#else
+#define omap_gpio_suspend NULL
+#define omap_gpio_resume NULL
 #endif
 
+static const struct dev_pm_ops gpio_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(omap_gpio_suspend, omap_gpio_resume)
+};
+
 static struct platform_driver omap_gpio_driver = {
 	.probe		= omap_gpio_probe,
 	.driver		= {
 		.name	= "omap_gpio",
+		.pm	= &gpio_pm_ops,
 	},
 };
 
@@ -1293,16 +1325,3 @@ static int __init omap_gpio_drv_reg(void)
 	return platform_driver_register(&omap_gpio_driver);
 }
 postcore_initcall(omap_gpio_drv_reg);
-
-static int __init omap_gpio_sysinit(void)
-{
-
-#if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2PLUS)
-	if (cpu_is_omap16xx() || cpu_class_is_omap2())
-		register_syscore_ops(&omap_gpio_syscore_ops);
-#endif
-
-	return 0;
-}
-
-arch_initcall(omap_gpio_sysinit);
-- 
1.7.0.4

