Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2BWMLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:11:15 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46321 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab2BWMKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:10:44 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH 2/6] gpio/omap: remove saved_wakeup field from struct gpio_bank
Date: Thu, 23 Feb 2012 17:40:27 +0530
Message-ID: <1329999031-6914-3-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no more need to have saved_wakeup. Instead we can use
context.wake_en which holds the current wakeup enable register
context. This also means that the read from wakeup enable register
is not needed.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
---
 drivers/gpio/gpio-omap.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 40a1fb2..64f15d5 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -54,7 +54,6 @@ struct gpio_bank {
 	u16 irq;
 	u16 virtual_irq_start;
 	u32 suspend_wakeup;
-	u32 saved_wakeup;
 	u32 non_wakeup_gpios;
 	u32 enabled_non_wakeup_gpios;
 	struct gpio_regs context;
@@ -772,7 +771,7 @@ static int omap_mpuio_suspend_noirq(struct device *dev)
 	unsigned long		flags;
 
 	spin_lock_irqsave(&bank->lock, flags);
-	bank->saved_wakeup = __raw_readl(mask_reg);
+	bank->context.wake_en = __raw_readl(mask_reg);
 	__raw_writel(0xffff & ~bank->suspend_wakeup, mask_reg);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
@@ -788,7 +787,7 @@ static int omap_mpuio_resume_noirq(struct device *dev)
 	unsigned long		flags;
 
 	spin_lock_irqsave(&bank->lock, flags);
-	__raw_writel(bank->saved_wakeup, mask_reg);
+	__raw_writel(bank->context.wake_en, mask_reg);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	return 0;
@@ -1133,7 +1132,6 @@ static int omap_gpio_suspend(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct gpio_bank *bank = platform_get_drvdata(pdev);
 	void __iomem *base = bank->base;
-	void __iomem *wakeup_enable;
 	unsigned long flags;
 
 	if (!bank->mod_usage || !bank->loses_context)
@@ -1142,10 +1140,7 @@ static int omap_gpio_suspend(struct device *dev)
 	if (!bank->regs->wkup_en || !bank->suspend_wakeup)
 		return 0;
 
-	wakeup_enable = bank->base + bank->regs->wkup_en;
-
 	spin_lock_irqsave(&bank->lock, flags);
-	bank->saved_wakeup = __raw_readl(wakeup_enable);
 	_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
 	_gpio_rmw(base, bank->regs->wkup_en, bank->suspend_wakeup, 1);
 	spin_unlock_irqrestore(&bank->lock, flags);
@@ -1163,12 +1158,12 @@ static int omap_gpio_resume(struct device *dev)
 	if (!bank->mod_usage || !bank->loses_context)
 		return 0;
 
-	if (!bank->regs->wkup_en || !bank->saved_wakeup)
+	if (!bank->regs->wkup_en || !bank->context.wake_en)
 		return 0;
 
 	spin_lock_irqsave(&bank->lock, flags);
 	_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
-	_gpio_rmw(base, bank->regs->wkup_en, bank->saved_wakeup, 1);
+	_gpio_rmw(base, bank->regs->wkup_en, bank->context.wake_en, 1);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	return 0;
-- 
1.7.0.4

