Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab1FBSUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:20:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36562 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754082Ab1FBSUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:20:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/9] mfd: Support dynamic allocation of IRQ range for wm831x
Date: Thu,  2 Jun 2011 19:18:51 +0100
Message-Id: <1307038735-18788-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110602181808.GA18726@opensource.wolfsonmicro.com>
 <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use irq_allocate_desc() to get the IRQ range, which turns into a noop on
non-sparse systems. Since all existing users are non-sparse there should
be no compatibility issues.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c        |   18 +++++++++++++-----
 include/linux/mfd/wm831x/core.h |    2 +-
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index b23d8d5..1808deb 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -527,13 +527,22 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 				 0xffff);
 	}
 
-	if (!pdata || !pdata->irq_base) {
-		dev_err(wm831x->dev,
-			"No interrupt base specified, no interrupts\n");
+	/* Try to dynamically allocate IRQs if no base is specified */
+	if (!pdata || !pdata->irq_base)
+		wm831x->irq_base = -1;
+	else
+		wm831x->irq_base = pdata->irq_base;
+
+	wm831x->irq_base = irq_alloc_descs(wm831x->irq_base, 0,
+					   WM831X_NUM_IRQS, 0);
+	if (wm831x->irq_base < 0) {
+		dev_warn(wm831x->dev, "Failed to allocate IRQs: %d\n",
+			 wm831x->irq_base);
+		wm831x->irq_base = 0;
 		return 0;
 	}
 
-	if (pdata->irq_cmos)
+	if (pdata && pdata->irq_cmos)
 		i = 0;
 	else
 		i = WM831X_IRQ_OD;
@@ -553,7 +562,6 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 	}
 
 	wm831x->irq = irq;
-	wm831x->irq_base = pdata->irq_base;
 
 	/* Register them with genirq */
 	for (cur_irq = wm831x->irq_base;
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index ebead1c..9564cf3 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -262,7 +262,7 @@ struct wm831x {
 
 	int irq;  /* Our chip IRQ */
 	struct mutex irq_lock;
-	unsigned int irq_base;
+	int irq_base;
 	int irq_masks_cur[WM831X_NUM_IRQ_REGS];   /* Currently active value */
 	int irq_masks_cache[WM831X_NUM_IRQ_REGS]; /* Cached hardware value */
 
-- 
1.7.5.3

