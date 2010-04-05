Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0DEPO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:14:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45549 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754611Ab0DEPOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:14:23 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Initialise WM831x IRQ masks on chip even if interrupts not in use
Date: Mon,  5 Apr 2010 16:14:17 +0100
Message-Id: <1270480458-2346-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that the hardware has interrupts masked if we are not using
the interrupt controller on the WM831x by initialising the masks
before we check for the setup data required for the IRQ line. This
avoids signalling an unused IRQ line and improves the robustness
of checks that the IRQ is in use.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index b1d66b8..f8b51be 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -460,6 +460,14 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 
 	mutex_init(&wm831x->irq_lock);
 
+	/* Mask the individual interrupt sources */
+	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
+		wm831x->irq_masks_cur[i] = 0xffff;
+		wm831x->irq_masks_cache[i] = 0xffff;
+		wm831x_reg_write(wm831x, WM831X_INTERRUPT_STATUS_1_MASK + i,
+				 0xffff);
+	}
+
 	if (!irq) {
 		dev_warn(wm831x->dev,
 			 "No interrupt specified - functionality limited\n");
@@ -475,14 +483,6 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 	wm831x->irq = irq;
 	wm831x->irq_base = pdata->irq_base;
 
-	/* Mask the individual interrupt sources */
-	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
-		wm831x->irq_masks_cur[i] = 0xffff;
-		wm831x->irq_masks_cache[i] = 0xffff;
-		wm831x_reg_write(wm831x, WM831X_INTERRUPT_STATUS_1_MASK + i,
-				 0xffff);
-	}
-
 	/* Register them with genirq */
 	for (cur_irq = wm831x->irq_base;
 	     cur_irq < ARRAY_SIZE(wm831x_irqs) + wm831x->irq_base;
-- 
1.7.0.3

