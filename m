Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab2BBRbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57679 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756955Ab2BBRbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:33 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH v9 21/25] gpio/omap: remove omap_gpio_save_context overhead
Date: Thu, 2 Feb 2012 23:00:47 +0530
Message-ID: <1328203851-20435-22-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Context is now saved dynamically in respective functions whenever and
whichever registers are modified. This avoid overhead of saving all
registers context in the runtime suspend callback.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/gpio/gpio-omap.c |   56 +++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 7515382..4056d78 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -101,6 +101,7 @@ static void _set_gpio_direction(struct gpio_bank *bank, int gpio, int is_input)
 	else
 		l &= ~(1 << gpio);
 	__raw_writel(l, reg);
+	bank->context.oe = l;
 }
 
 
@@ -131,6 +132,7 @@ static void _set_gpio_dataout_mask(struct gpio_bank *bank, int gpio, int enable)
 	else
 		l &= ~gpio_bit;
 	__raw_writel(l, reg);
+	bank->context.dataout = l;
 }
 
 static int _get_gpio_datain(struct gpio_bank *bank, int gpio)
@@ -244,8 +246,20 @@ static inline void set_gpio_trigger(struct gpio_bank *bank, int gpio,
 	_gpio_rmw(base, bank->regs->fallingdetect, gpio_bit,
 		  trigger & IRQ_TYPE_EDGE_FALLING);
 
-	if (likely(!(bank->non_wakeup_gpios & gpio_bit)))
+	bank->context.leveldetect0 =
+			__raw_readl(bank->base + bank->regs->leveldetect0);
+	bank->context.leveldetect1 =
+			__raw_readl(bank->base + bank->regs->leveldetect1);
+	bank->context.risingdetect =
+			__raw_readl(bank->base + bank->regs->risingdetect);
+	bank->context.fallingdetect =
+			__raw_readl(bank->base + bank->regs->fallingdetect);
+
+	if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
 		_gpio_rmw(base, bank->regs->wkup_en, gpio_bit, trigger != 0);
+		bank->context.wake_en =
+			__raw_readl(bank->base + bank->regs->wkup_en);
+	}
 
 	/* This part needs to be executed always for OMAP{34xx, 44xx} */
 	if (!bank->regs->irqctrl) {
@@ -338,6 +352,8 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 
 		/* Enable wake-up during idle for dynamic tick */
 		_gpio_rmw(base, bank->regs->wkup_en, 1 << gpio, trigger);
+		bank->context.wake_en =
+			__raw_readl(bank->base + bank->regs->wkup_en);
 		__raw_writel(l, reg);
 	}
 	return 0;
@@ -430,6 +446,7 @@ static void _enable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask)
 	}
 
 	__raw_writel(l, reg);
+	bank->context.irqenable1 = l;
 }
 
 static void _disable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask)
@@ -450,6 +467,7 @@ static void _disable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask)
 	}
 
 	__raw_writel(l, reg);
+	bank->context.irqenable1 = l;
 }
 
 static inline void _set_gpio_irqenable(struct gpio_bank *bank, int gpio, int enable)
@@ -541,6 +559,7 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 		/* Module is enabled, clocks are not gated */
 		ctrl &= ~GPIO_MOD_CTRL_BIT;
 		__raw_writel(ctrl, reg);
+		bank->context.ctrl = ctrl;
 	}
 
 	bank->mod_usage |= 1 << offset;
@@ -558,9 +577,12 @@ static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 
 	spin_lock_irqsave(&bank->lock, flags);
 
-	if (bank->regs->wkup_en)
+	if (bank->regs->wkup_en) {
 		/* Disable wake-up during idle for dynamic tick */
 		_gpio_rmw(base, bank->regs->wkup_en, 1 << offset, 0);
+		bank->context.wake_en =
+			__raw_readl(bank->base + bank->regs->wkup_en);
+	}
 
 	bank->mod_usage &= ~(1 << offset);
 
@@ -572,6 +594,7 @@ static void omap_gpio_free(struct gpio_chip *chip, unsigned offset)
 		/* Module is disabled, clocks are gated */
 		ctrl |= GPIO_MOD_CTRL_BIT;
 		__raw_writel(ctrl, reg);
+		bank->context.ctrl = ctrl;
 	}
 
 	_reset_gpio(bank, bank->chip.base + offset);
@@ -1157,7 +1180,6 @@ static int omap_gpio_resume(struct device *dev)
 }
 
 
-static void omap_gpio_save_context(struct gpio_bank *bank);
 static void omap_gpio_restore_context(struct gpio_bank *bank);
 
 static int omap_gpio_runtime_suspend(struct device *dev)
@@ -1170,7 +1192,7 @@ static int omap_gpio_runtime_suspend(struct device *dev)
 	spin_lock_irqsave(&bank->lock, flags);
 	if (bank->power_mode != OFF_MODE) {
 		bank->power_mode = 0;
-		goto save_gpio_context;
+		goto update_gpio_context_count;
 	}
 	/*
 	 * If going to OFF, remove triggering for all
@@ -1178,7 +1200,7 @@ static int omap_gpio_runtime_suspend(struct device *dev)
 	 * generated.  See OMAP2420 Errata item 1.101.
 	 */
 	if (!(bank->enabled_non_wakeup_gpios))
-		goto save_gpio_context;
+		goto update_gpio_context_count;
 
 	bank->saved_datain = __raw_readl(bank->base +
 						bank->regs->datain);
@@ -1195,12 +1217,11 @@ static int omap_gpio_runtime_suspend(struct device *dev)
 
 	bank->workaround_enabled = true;
 
-save_gpio_context:
+update_gpio_context_count:
 	if (bank->get_context_loss_count)
 		bank->context_loss_count =
 				bank->get_context_loss_count(bank->dev);
 
-	omap_gpio_save_context(bank);
 	_gpio_dbck_disable(bank);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
@@ -1319,27 +1340,6 @@ void omap2_gpio_resume_after_idle(void)
 	}
 }
 
-static void omap_gpio_save_context(struct gpio_bank *bank)
-{
-	bank->context.irqenable1 =
-			__raw_readl(bank->base + bank->regs->irqenable);
-	bank->context.irqenable2 =
-			__raw_readl(bank->base + bank->regs->irqenable2);
-	bank->context.wake_en =
-			__raw_readl(bank->base + bank->regs->wkup_en);
-	bank->context.ctrl = __raw_readl(bank->base + bank->regs->ctrl);
-	bank->context.oe = __raw_readl(bank->base + bank->regs->direction);
-	bank->context.leveldetect0 =
-			__raw_readl(bank->base + bank->regs->leveldetect0);
-	bank->context.leveldetect1 =
-			__raw_readl(bank->base + bank->regs->leveldetect1);
-	bank->context.risingdetect =
-			__raw_readl(bank->base + bank->regs->risingdetect);
-	bank->context.fallingdetect =
-			__raw_readl(bank->base + bank->regs->fallingdetect);
-	bank->context.dataout = __raw_readl(bank->base + bank->regs->dataout);
-}
-
 static void omap_gpio_restore_context(struct gpio_bank *bank)
 {
 	__raw_writel(bank->context.irqenable1,
-- 
1.7.0.4

