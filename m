Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2BBRbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50436 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685Ab2BBRbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:17 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, Charulatha V <charu@ti.com>
Subject: [PATCH v9 18/25] gpio/omap: cleanup prepare_for_idle and resume_after_idle
Date: Thu, 2 Feb 2012 23:00:44 +0530
Message-ID: <1328203851-20435-19-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since *_prepare_for_idle() and *_resume_after_idle() are called
with interrupts disabled they should be kept as simple as possible.
So, moving most of the stuff to *_runtime_suspend/resume() callbacks.

To avoid invalid context restore happening in *_runtime_resume()
callback as a result of *_get_sync() call in *_gpio_probe(), update
bank->context_loss_count. This would make context restore condition
check false in the callback and skip restore until further
initialization take place. The workaround_enabled static variable
is now a member of struct gpio_bank.

Unlike most GPIO registers the OE has 0xffffffff as the default value.
To make sure invalid context is not restored, updating the OE context
with default value.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Signed-off-by: Charulatha V <charu@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/gpio/gpio-omap.c |  241 +++++++++++++++++++++++++++-------------------
 1 files changed, 143 insertions(+), 98 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 9db892c..8b619fd 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -29,6 +29,8 @@
 #include <asm/gpio.h>
 #include <asm/mach/irq.h>
 
+#define OFF_MODE	1
+
 static LIST_HEAD(omap_gpio_list);
 
 struct gpio_regs {
@@ -73,6 +75,8 @@ struct gpio_bank {
 	u32 width;
 	int context_loss_count;
 	u16 id;
+	int power_mode;
+	bool workaround_enabled;
 
 	void (*set_dataout)(struct gpio_bank *bank, int gpio, int enable);
 	int (*get_context_loss_count)(struct device *dev);
@@ -905,6 +909,8 @@ static void omap_gpio_mod_init(struct gpio_bank *bank)
 	if (bank->regs->debounce_en)
 		_gpio_rmw(base, bank->regs->debounce_en, 0, 1);
 
+	/* Save OE default value (0xffffffff) in the context */
+	bank->context.oe = __raw_readl(bank->base + bank->regs->direction);
 	 /* Initialize interface clk ungated, module enabled */
 	if (bank->regs->ctrl)
 		_gpio_rmw(base, bank->regs->ctrl, 0, 1);
@@ -1129,135 +1135,170 @@ static int omap_gpio_resume(struct device *dev)
 static void omap_gpio_save_context(struct gpio_bank *bank);
 static void omap_gpio_restore_context(struct gpio_bank *bank);
 
-void omap2_gpio_prepare_for_idle(int off_mode)
+static int omap_gpio_runtime_suspend(struct device *dev)
 {
-	struct gpio_bank *bank;
-
-	list_for_each_entry(bank, &omap_gpio_list, node) {
-		u32 l1 = 0, l2 = 0;
-		int j;
-
-		if (!bank->loses_context)
-			continue;
-
-		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
-			clk_disable(bank->dbck);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct gpio_bank *bank = platform_get_drvdata(pdev);
+	u32 l1 = 0, l2 = 0;
+	unsigned long flags;
 
-		if (!off_mode)
-			continue;
+	spin_lock_irqsave(&bank->lock, flags);
+	if (bank->power_mode != OFF_MODE) {
+		bank->power_mode = 0;
+		goto save_gpio_context;
+	}
+	/*
+	 * If going to OFF, remove triggering for all
+	 * non-wakeup GPIOs.  Otherwise spurious IRQs will be
+	 * generated.  See OMAP2420 Errata item 1.101.
+	 */
+	if (!(bank->enabled_non_wakeup_gpios))
+		goto save_gpio_context;
 
-		/* If going to OFF, remove triggering for all
-		 * non-wakeup GPIOs.  Otherwise spurious IRQs will be
-		 * generated.  See OMAP2420 Errata item 1.101. */
-		if (!(bank->enabled_non_wakeup_gpios))
-			goto save_gpio_context;
+	bank->saved_datain = __raw_readl(bank->base +
+						bank->regs->datain);
+	l1 = __raw_readl(bank->base + bank->regs->fallingdetect);
+	l2 = __raw_readl(bank->base + bank->regs->risingdetect);
 
-		bank->saved_datain = __raw_readl(bank->base +
-							bank->regs->datain);
-		l1 = __raw_readl(bank->base + bank->regs->fallingdetect);
-		l2 = __raw_readl(bank->base + bank->regs->risingdetect);
+	bank->saved_fallingdetect = l1;
+	bank->saved_risingdetect = l2;
+	l1 &= ~bank->enabled_non_wakeup_gpios;
+	l2 &= ~bank->enabled_non_wakeup_gpios;
 
-		bank->saved_fallingdetect = l1;
-		bank->saved_risingdetect = l2;
-		l1 &= ~bank->enabled_non_wakeup_gpios;
-		l2 &= ~bank->enabled_non_wakeup_gpios;
+	__raw_writel(l1, bank->base + bank->regs->fallingdetect);
+	__raw_writel(l2, bank->base + bank->regs->risingdetect);
 
-		__raw_writel(l1, bank->base + bank->regs->fallingdetect);
-		__raw_writel(l2, bank->base + bank->regs->risingdetect);
+	bank->workaround_enabled = true;
 
 save_gpio_context:
-
-		if (bank->get_context_loss_count)
-			bank->context_loss_count =
+	if (bank->get_context_loss_count)
+		bank->context_loss_count =
 				bank->get_context_loss_count(bank->dev);
 
-		omap_gpio_save_context(bank);
+	omap_gpio_save_context(bank);
+	spin_unlock_irqrestore(&bank->lock, flags);
 
-		if (!pm_runtime_suspended(bank->dev))
-			pm_runtime_put(bank->dev);
-	}
+	return 0;
 }
 
-void omap2_gpio_resume_after_idle(void)
+static int omap_gpio_runtime_resume(struct device *dev)
 {
-	struct gpio_bank *bank;
-
-	list_for_each_entry(bank, &omap_gpio_list, node) {
-		int context_lost_cnt_after;
-		u32 l = 0, gen, gen0, gen1;
-		int j;
-
-		if (!bank->loses_context)
-			continue;
-
-		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
-			clk_enable(bank->dbck);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct gpio_bank *bank = platform_get_drvdata(pdev);
+	int context_lost_cnt_after;
+	u32 l = 0, gen, gen0, gen1;
+	unsigned long flags;
 
-		if (pm_runtime_suspended(bank->dev))
-			pm_runtime_get_sync(bank->dev);
+	spin_lock_irqsave(&bank->lock, flags);
+	if (!bank->enabled_non_wakeup_gpios || !bank->workaround_enabled) {
+		spin_unlock_irqrestore(&bank->lock, flags);
+		return 0;
+	}
 
-		if (bank->get_context_loss_count) {
-			context_lost_cnt_after =
-				bank->get_context_loss_count(bank->dev);
-			if (context_lost_cnt_after != bank->context_loss_count
-				|| !context_lost_cnt_after)
-				omap_gpio_restore_context(bank);
+	if (bank->get_context_loss_count) {
+		context_lost_cnt_after =
+			bank->get_context_loss_count(bank->dev);
+		if (context_lost_cnt_after != bank->context_loss_count ||
+						!context_lost_cnt_after) {
+			omap_gpio_restore_context(bank);
+		} else {
+			spin_unlock_irqrestore(&bank->lock, flags);
+			return 0;
 		}
+	}
 
-		if (!(bank->enabled_non_wakeup_gpios))
-			continue;
+	__raw_writel(bank->saved_fallingdetect,
+			bank->base + bank->regs->fallingdetect);
+	__raw_writel(bank->saved_risingdetect,
+			bank->base + bank->regs->risingdetect);
+	l = __raw_readl(bank->base + bank->regs->datain);
 
-		__raw_writel(bank->saved_fallingdetect,
-				bank->base + bank->regs->fallingdetect);
-		__raw_writel(bank->saved_risingdetect,
-				bank->base + bank->regs->risingdetect);
-		l = __raw_readl(bank->base + bank->regs->datain);
+	/*
+	 * Check if any of the non-wakeup interrupt GPIOs have changed
+	 * state.  If so, generate an IRQ by software.  This is
+	 * horribly racy, but it's the best we can do to work around
+	 * this silicon bug.
+	 */
+	l ^= bank->saved_datain;
+	l &= bank->enabled_non_wakeup_gpios;
 
-		/* Check if any of the non-wakeup interrupt GPIOs have changed
-		 * state.  If so, generate an IRQ by software.  This is
-		 * horribly racy, but it's the best we can do to work around
-		 * this silicon bug. */
-		l ^= bank->saved_datain;
-		l &= bank->enabled_non_wakeup_gpios;
+	/*
+	 * No need to generate IRQs for the rising edge for gpio IRQs
+	 * configured with falling edge only; and vice versa.
+	 */
+	gen0 = l & bank->saved_fallingdetect;
+	gen0 &= bank->saved_datain;
 
-		/*
-		 * No need to generate IRQs for the rising edge for gpio IRQs
-		 * configured with falling edge only; and vice versa.
-		 */
-		gen0 = l & bank->saved_fallingdetect;
-		gen0 &= bank->saved_datain;
+	gen1 = l & bank->saved_risingdetect;
+	gen1 &= ~(bank->saved_datain);
 
-		gen1 = l & bank->saved_risingdetect;
-		gen1 &= ~(bank->saved_datain);
+	/* FIXME: Consider GPIO IRQs with level detections properly! */
+	gen = l & (~(bank->saved_fallingdetect) & ~(bank->saved_risingdetect));
+	/* Consider all GPIO IRQs needed to be updated */
+	gen |= gen0 | gen1;
 
-		/* FIXME: Consider GPIO IRQs with level detections properly! */
-		gen = l & (~(bank->saved_fallingdetect) &
-				~(bank->saved_risingdetect));
-		/* Consider all GPIO IRQs needed to be updated */
-		gen |= gen0 | gen1;
+	if (gen) {
+		u32 old0, old1;
 
-		if (gen) {
-			u32 old0, old1;
+		old0 = __raw_readl(bank->base + bank->regs->leveldetect0);
+		old1 = __raw_readl(bank->base + bank->regs->leveldetect1);
 
-			old0 = __raw_readl(bank->base +
+		if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
+			__raw_writel(old0 | gen, bank->base +
 						bank->regs->leveldetect0);
-			old1 = __raw_readl(bank->base +
+			__raw_writel(old1 | gen, bank->base +
 						bank->regs->leveldetect1);
+		}
 
-			if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
-				old0 |= gen;
-				old1 |= gen;
-			}
-
-			if (cpu_is_omap44xx()) {
-				old0 |= l;
-				old1 |= l;
-			}
-			__raw_writel(old0, bank->base +
+		if (cpu_is_omap44xx()) {
+			__raw_writel(old0 | l, bank->base +
 						bank->regs->leveldetect0);
-			__raw_writel(old1, bank->base +
+			__raw_writel(old1 | l, bank->base +
 						bank->regs->leveldetect1);
 		}
+		__raw_writel(old0, bank->base + bank->regs->leveldetect0);
+		__raw_writel(old1, bank->base + bank->regs->leveldetect1);
+	}
+
+	bank->workaround_enabled = false;
+	spin_unlock_irqrestore(&bank->lock, flags);
+
+	return 0;
+}
+
+void omap2_gpio_prepare_for_idle(int pwr_mode)
+{
+	struct gpio_bank *bank;
+
+	list_for_each_entry(bank, &omap_gpio_list, node) {
+		int j;
+
+		if (!bank->mod_usage || !bank->loses_context)
+			continue;
+
+		bank->power_mode = pwr_mode;
+
+		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
+			clk_disable(bank->dbck);
+
+		pm_runtime_put_sync_suspend(bank->dev);
+	}
+}
+
+void omap2_gpio_resume_after_idle(void)
+{
+	struct gpio_bank *bank;
+
+	list_for_each_entry(bank, &omap_gpio_list, node) {
+		int j;
+
+		if (!bank->mod_usage || !bank->loses_context)
+			continue;
+
+		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
+			clk_enable(bank->dbck);
+
+		pm_runtime_get_sync(bank->dev);
 	}
 }
 
@@ -1305,10 +1346,14 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
 #else
 #define omap_gpio_suspend NULL
 #define omap_gpio_resume NULL
+#define omap_gpio_runtime_suspend NULL
+#define omap_gpio_runtime_resume NULL
 #endif
 
 static const struct dev_pm_ops gpio_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(omap_gpio_suspend, omap_gpio_resume)
+	SET_RUNTIME_PM_OPS(omap_gpio_runtime_suspend, omap_gpio_runtime_resume,
+									NULL)
 };
 
 static struct platform_driver omap_gpio_driver = {
-- 
1.7.0.4

