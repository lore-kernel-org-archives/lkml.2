Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab1FBLwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:52:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56711 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752861Ab1FBLwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:52:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Support dynamic allocation of IRQ range for wm831x
Date: Thu,  2 Jun 2011 12:52:09 +0100
Message-Id: <1307015529-23828-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use irq_allocate_desc() to get the IRQ range, which turns into a noop on
non-sparse systems. Since all existing users are non-sparse there should
be no compatibility issues.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

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
-- 
1.7.5.3

