Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab2BBRcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:32:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47569 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948Ab2BBRbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:33 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH v9 19/25] gpio/omap: fix debounce clock handling
Date: Thu, 2 Feb 2012 23:00:45 +0530
Message-ID: <1328203851-20435-20-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dbck_enable_mask indicates which all GPIOs within a bank have debounce
enabled and dbck is enabled/disabled based upon this. But there is no
mechanism to track the dbck state. In order to manage the dbck state we need
additional flag and logic so that turning off/on dbck is synchronized with
pm_runtime_put/get_sync calls.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/gpio/gpio-omap.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 8b619fd..0ea3dc9 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -67,6 +67,7 @@ struct gpio_bank {
 	struct clk *dbck;
 	u32 mod_usage;
 	u32 dbck_enable_mask;
+	bool dbck_enabled;
 	struct device *dev;
 	bool is_mpuio;
 	bool dbck_flag;
@@ -158,6 +159,22 @@ static inline void _gpio_rmw(void __iomem *base, u32 reg, u32 mask, bool set)
 	__raw_writel(l, base + reg);
 }
 
+static inline void _gpio_dbck_enable(struct gpio_bank *bank)
+{
+	if (bank->dbck_enable_mask && !bank->dbck_enabled) {
+		clk_enable(bank->dbck);
+		bank->dbck_enabled = true;
+	}
+}
+
+static inline void _gpio_dbck_disable(struct gpio_bank *bank)
+{
+	if (bank->dbck_enable_mask && bank->dbck_enabled) {
+		clk_disable(bank->dbck);
+		bank->dbck_enabled = false;
+	}
+}
+
 /**
  * _set_gpio_debounce - low level gpio debounce time
  * @bank: the gpio bank we're acting upon
@@ -1176,6 +1193,7 @@ save_gpio_context:
 				bank->get_context_loss_count(bank->dev);
 
 	omap_gpio_save_context(bank);
+	_gpio_dbck_disable(bank);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	return 0;
@@ -1190,6 +1208,7 @@ static int omap_gpio_runtime_resume(struct device *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&bank->lock, flags);
+	_gpio_dbck_enable(bank);
 	if (!bank->enabled_non_wakeup_gpios || !bank->workaround_enabled) {
 		spin_unlock_irqrestore(&bank->lock, flags);
 		return 0;
@@ -1271,16 +1290,11 @@ void omap2_gpio_prepare_for_idle(int pwr_mode)
 	struct gpio_bank *bank;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
-		int j;
-
 		if (!bank->mod_usage || !bank->loses_context)
 			continue;
 
 		bank->power_mode = pwr_mode;
 
-		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
-			clk_disable(bank->dbck);
-
 		pm_runtime_put_sync_suspend(bank->dev);
 	}
 }
@@ -1290,14 +1304,9 @@ void omap2_gpio_resume_after_idle(void)
 	struct gpio_bank *bank;
 
 	list_for_each_entry(bank, &omap_gpio_list, node) {
-		int j;
-
 		if (!bank->mod_usage || !bank->loses_context)
 			continue;
 
-		for (j = 0; j < hweight_long(bank->dbck_enable_mask); j++)
-			clk_enable(bank->dbck);
-
 		pm_runtime_get_sync(bank->dev);
 	}
 }
-- 
1.7.0.4

