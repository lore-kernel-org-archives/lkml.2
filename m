Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab1GTQFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:05:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58946 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752076Ab1GTQFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:05:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Acknowlege all WM831x IRQs before we handle them
Date: Wed, 20 Jul 2011 17:05:13 +0100
Message-Id: <1311177913-4560-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that we never have a window where we've handled an interrupt (and
therefore need to be notified of new events) but haven't yet told the
interrupt controller that this is the case (so any new events will be
discarded).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |   30 +++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 6c3408c..ada1835 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -449,7 +449,7 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 {
 	struct wm831x *wm831x = data;
 	unsigned int i;
-	int primary;
+	int primary, status_addr;
 	int status_regs[WM831X_NUM_IRQ_REGS] = { 0 };
 	int read[WM831X_NUM_IRQ_REGS] = { 0 };
 	int *status;
@@ -484,8 +484,9 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 		/* Hopefully there should only be one register to read
 		 * each time otherwise we ought to do a block read. */
 		if (!read[offset]) {
-			*status = wm831x_reg_read(wm831x,
-				     irq_data_to_status_reg(&wm831x_irqs[i]));
+			status_addr = irq_data_to_status_reg(&wm831x_irqs[i]);
+
+			*status = wm831x_reg_read(wm831x, status_addr);
 			if (*status < 0) {
 				dev_err(wm831x->dev,
 					"Failed to read IRQ status: %d\n",
@@ -494,26 +495,21 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 			}
 
 			read[offset] = 1;
+
+			/* Ignore any bits that we don't think are masked */
+			*status &= ~wm831x->irq_masks_cur[offset];
+
+			/* Acknowledge now so we don't miss
+			 * notifications while we handle.
+			 */
+			wm831x_reg_write(wm831x, status_addr, *status);
 		}
 
-		/* Report it if it isn't masked, or forget the status. */
-		if ((*status & ~wm831x->irq_masks_cur[offset])
-		    & wm831x_irqs[i].mask)
+		if (*status & wm831x_irqs[i].mask)
 			handle_nested_irq(wm831x->irq_base + i);
-		else
-			*status &= ~wm831x_irqs[i].mask;
 	}
 
 out:
-	/* Touchscreen interrupts are handled specially in the driver */
-	status_regs[0] &= ~(WM831X_TCHDATA_EINT | WM831X_TCHPD_EINT);
-
-	for (i = 0; i < ARRAY_SIZE(status_regs); i++) {
-		if (status_regs[i])
-			wm831x_reg_write(wm831x, WM831X_INTERRUPT_STATUS_1 + i,
-					 status_regs[i]);
-	}
-
 	return IRQ_HANDLED;
 }
 
-- 
1.7.5.4

