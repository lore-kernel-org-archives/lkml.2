Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1DDNcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:32:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47330 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753116Ab1DDNcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:32:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Continue with IRQ setup even if we don't have PMIC main IRQ
Date: Mon,  4 Apr 2011 11:59:57 +0900
Message-Id: <1301885997-1612-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fact that we can't actually raise any interrupts doesn't stop us
setting up the IRQs we're exporting. While this isn't actually going
to do anything it allows us to proceed further through device setup
during board bringup and avoids issues with the MFD core not letting
us suppress the configuration of IRQ resources.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 23e66af..42b928e 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -515,12 +515,6 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 				 0xffff);
 	}
 
-	if (!irq) {
-		dev_warn(wm831x->dev,
-			 "No interrupt specified - functionality limited\n");
-		return 0;
-	}
-
 	if (!pdata || !pdata->irq_base) {
 		dev_err(wm831x->dev,
 			"No interrupt base specified, no interrupts\n");
@@ -567,15 +561,22 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 #endif
 	}
 
-	ret = request_threaded_irq(irq, NULL, wm831x_irq_thread,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   "wm831x", wm831x);
-	if (ret != 0) {
-		dev_err(wm831x->dev, "Failed to request IRQ %d: %d\n",
-			irq, ret);
-		return ret;
+	if (irq) {
+		ret = request_threaded_irq(irq, NULL, wm831x_irq_thread,
+					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					   "wm831x", wm831x);
+		if (ret != 0) {
+			dev_err(wm831x->dev, "Failed to request IRQ %d: %d\n",
+				irq, ret);
+			return ret;
+		}
+	} else {
+		dev_warn(wm831x->dev,
+			 "No interrupt specified - functionality limited\n");
 	}
 
+
+
 	/* Enable top level interrupts, we mask at secondary level */
 	wm831x_reg_write(wm831x, WM831X_SYSTEM_INTERRUPTS_MASK, 0);
 
-- 
1.7.4.1

