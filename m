Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab2BBRel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:34:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47558 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777Ab2BBRbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:25 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH v9 17/25] gpio/omap: optimize suspend and resume functions
Date: Thu, 2 Feb 2012 23:00:43 +0530
Message-ID: <1328203851-20435-18-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to operate on all the banks every time the function is called.
Just operate on the current bank passed by the framework.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/gpio/gpio-omap.c |   54 ++++++++++++++++++++++++---------------------
 1 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index b92a23f..9db892c 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1052,6 +1052,8 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
+	platform_set_drvdata(pdev, bank);
+
 	pm_runtime_enable(bank->dev);
 	pm_runtime_irq_safe(bank->dev);
 	pm_runtime_get_sync(bank->dev);
@@ -1079,44 +1081,46 @@ err_exit:
 
 static int omap_gpio_suspend(struct device *dev)
 {
-	struct gpio_bank *bank;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct gpio_bank *bank = platform_get_drvdata(pdev);
+	void __iomem *base = bank->base;
+	void __iomem *wakeup_enable;
+	unsigned long flags;
 
-	list_for_each_entry(bank, &omap_gpio_list, node) {
-		void __iomem *base = bank->base;
-		void __iomem *wake_status;
-		unsigned long flags;
+	if (!bank->mod_usage || !bank->loses_context)
+		return 0;
 
-		if (!bank->regs->wkup_en)
-			return 0;
+	if (!bank->regs->wkup_en || !bank->suspend_wakeup)
+		return 0;
 
-		wake_status = bank->base + bank->regs->wkup_en;
+	wakeup_enable = bank->base + bank->regs->wkup_en;
 
-		spin_lock_irqsave(&bank->lock, flags);
-		bank->saved_wakeup = __raw_readl(wake_status);
-		_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
-		_gpio_rmw(base, bank->regs->wkup_en, bank->suspend_wakeup, 1);
-		spin_unlock_irqrestore(&bank->lock, flags);
-	}
+	spin_lock_irqsave(&bank->lock, flags);
+	bank->saved_wakeup = __raw_readl(wakeup_enable);
+	_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
+	_gpio_rmw(base, bank->regs->wkup_en, bank->suspend_wakeup, 1);
+	spin_unlock_irqrestore(&bank->lock, flags);
 
 	return 0;
 }
 
 static int omap_gpio_resume(struct device *dev)
 {
-	struct gpio_bank *bank;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct gpio_bank *bank = platform_get_drvdata(pdev);
+	void __iomem *base = bank->base;
+	unsigned long flags;
 
-	list_for_each_entry(bank, &omap_gpio_list, node) {
-		void __iomem *base = bank->base;
-		unsigned long flags;
+	if (!bank->mod_usage || !bank->loses_context)
+		return 0;
 
-		if (!bank->regs->wkup_en)
-			return 0;
+	if (!bank->regs->wkup_en || !bank->saved_wakeup)
+		return 0;
 
-		spin_lock_irqsave(&bank->lock, flags);
-		_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
-		_gpio_rmw(base, bank->regs->wkup_en, bank->saved_wakeup, 1);
-		spin_unlock_irqrestore(&bank->lock, flags);
-	}
+	spin_lock_irqsave(&bank->lock, flags);
+	_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
+	_gpio_rmw(base, bank->regs->wkup_en, bank->saved_wakeup, 1);
+	spin_unlock_irqrestore(&bank->lock, flags);
 
 	return 0;
 }
-- 
1.7.0.4

