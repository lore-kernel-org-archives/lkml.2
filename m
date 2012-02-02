Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab2BBRbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:31:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47565 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab2BBRba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:31:30 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH v9 20/25] gpio/omap: fix incorrect access of debounce module
Date: Thu, 2 Feb 2012 23:00:46 +0530
Message-ID: <1328203851-20435-21-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable debounce clock before writing/reading debounce registers.
Disable the clock at the end so that it is synchronized with the
pm_runtime_get/put_sync calls.

Enable debounce clock per module. This call is mandatory because
in omap_gpio_request() when *_runtime_get_sync() is called,
_gpio_dbck_enable() within runtime callbck fails to turn on dbck
 because dbck_enable_mask used within _gpio_dbck_enable() is still
not initialized at that point. Therefore we have to enable dbck here.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/gpio/gpio-omap.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 0ea3dc9..7515382 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -203,22 +203,30 @@ static void _set_gpio_debounce(struct gpio_bank *bank, unsigned gpio,
 
 	l = GPIO_BIT(bank, gpio);
 
+	clk_enable(bank->dbck);
 	reg = bank->base + bank->regs->debounce;
 	__raw_writel(debounce, reg);
 
 	reg = bank->base + bank->regs->debounce_en;
 	val = __raw_readl(reg);
 
-	if (debounce) {
+	if (debounce)
 		val |= l;
-		clk_enable(bank->dbck);
-	} else {
+	else
 		val &= ~l;
-		clk_disable(bank->dbck);
-	}
 	bank->dbck_enable_mask = val;
 
 	__raw_writel(val, reg);
+	clk_disable(bank->dbck);
+	/*
+	 * Enable debounce clock per module.
+	 * This call is mandatory because in omap_gpio_request() when
+	 * *_runtime_get_sync() is called,  _gpio_dbck_enable() within
+	 * runtime callbck fails to turn on dbck because dbck_enable_mask
+	 * used within _gpio_dbck_enable() is still not initialized at
+	 * that point. Therefore we have to enable dbck here.
+	 */
+	_gpio_dbck_enable(bank);
 }
 
 static inline void set_gpio_trigger(struct gpio_bank *bank, int gpio,
-- 
1.7.0.4

