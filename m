Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2BWMLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:11:14 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46323 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab2BWMKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:10:44 -0500
From: Tarun Kanti DebBarma <tarun.kanti@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <khilman@ti.com>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>
Subject: [PATCH 1/6] gpio/omap: remove saved_fallingdetect, saved_risingdetect fields
Date: Thu, 23 Feb 2012 17:40:26 +0530
Message-ID: <1329999031-6914-2-git-send-email-tarun.kanti@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we already have context.fallingdetect and context.risingdetect
there is no more need to have these additional fields. Also, getting
rid of extra reads associated with them.

Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
---
 drivers/gpio/gpio-omap.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index f29252f..40a1fb2 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -59,8 +59,6 @@ struct gpio_bank {
 	u32 enabled_non_wakeup_gpios;
 	struct gpio_regs context;
 	u32 saved_datain;
-	u32 saved_fallingdetect;
-	u32 saved_risingdetect;
 	u32 level_mask;
 	u32 toggle_mask;
 	spinlock_t lock;
@@ -1224,11 +1222,9 @@ static int omap_gpio_runtime_suspend(struct device *dev)
 
 	bank->saved_datain = __raw_readl(bank->base +
 						bank->regs->datain);
-	l1 = __raw_readl(bank->base + bank->regs->fallingdetect);
-	l2 = __raw_readl(bank->base + bank->regs->risingdetect);
+	l1 = bank->context.fallingdetect;
+	l2 = bank->context.risingdetect;
 
-	bank->saved_fallingdetect = l1;
-	bank->saved_risingdetect = l2;
 	l1 &= ~bank->enabled_non_wakeup_gpios;
 	l2 &= ~bank->enabled_non_wakeup_gpios;
 
@@ -1287,9 +1283,9 @@ static int omap_gpio_runtime_resume(struct device *dev)
 		}
 	}
 
-	__raw_writel(bank->saved_fallingdetect,
+	__raw_writel(bank->context.fallingdetect,
 			bank->base + bank->regs->fallingdetect);
-	__raw_writel(bank->saved_risingdetect,
+	__raw_writel(bank->context.risingdetect,
 			bank->base + bank->regs->risingdetect);
 	l = __raw_readl(bank->base + bank->regs->datain);
 
@@ -1306,14 +1302,15 @@ static int omap_gpio_runtime_resume(struct device *dev)
 	 * No need to generate IRQs for the rising edge for gpio IRQs
 	 * configured with falling edge only; and vice versa.
 	 */
-	gen0 = l & bank->saved_fallingdetect;
+	gen0 = l & bank->context.fallingdetect;
 	gen0 &= bank->saved_datain;
 
-	gen1 = l & bank->saved_risingdetect;
+	gen1 = l & bank->context.risingdetect;
 	gen1 &= ~(bank->saved_datain);
 
 	/* FIXME: Consider GPIO IRQs with level detections properly! */
-	gen = l & (~(bank->saved_fallingdetect) & ~(bank->saved_risingdetect));
+	gen = l & (~(bank->context.fallingdetect) &
+					 ~(bank->context.risingdetect));
 	/* Consider all GPIO IRQs needed to be updated */
 	gen |= gen0 | gen1;
 
-- 
1.7.0.4

