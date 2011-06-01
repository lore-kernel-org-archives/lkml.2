Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778Ab1FAUkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:40:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55814 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758951Ab1FAUkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:40:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Support dynamic allocation of IRQ range for wm831x
Date: Wed,  1 Jun 2011 21:39:32 +0100
Message-Id: <1306960772-329-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use irq_allocate_desc() to get the IRQ range, which turns into a noop on
non-sparse systems. Since all existing users are non-sparse there should
be no compatibility issues.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index b23d8d5..a25a7d5 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -527,9 +527,18 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
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
 
-- 
1.7.5.3

