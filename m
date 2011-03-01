Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab1CAUM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:12:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36974 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753415Ab1CAUM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:12:27 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] mfd: Convert WM831x interrupt masking to enable/disable operations
Date: Tue,  1 Mar 2011 20:12:44 +0000
Message-Id: <1299010366-31453-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x interrupt masking support is a much better match for the genirq
enable and disable operations than for the mask and unmask operations. The
latter are intended to used during interrupt handling for temporary changes
which isn't really practical on a slow bus. Convert the operations over to
match this.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 2e45f60..a5cd17e 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -352,6 +352,10 @@ static void wm831x_irq_sync_unlock(struct irq_data *data)
 		/* If there's been a change in the mask write it back
 		 * to the hardware. */
 		if (wm831x->irq_masks_cur[i] != wm831x->irq_masks_cache[i]) {
+			dev_dbg(wm831x->dev, "IRQ mask sync: %x = %x\n",
+				WM831X_INTERRUPT_STATUS_1_MASK + i,
+				wm831x->irq_masks_cur[i]);
+
 			wm831x->irq_masks_cache[i] = wm831x->irq_masks_cur[i];
 			wm831x_reg_write(wm831x,
 					 WM831X_INTERRUPT_STATUS_1_MASK + i,
@@ -362,7 +366,7 @@ static void wm831x_irq_sync_unlock(struct irq_data *data)
 	mutex_unlock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_unmask(struct irq_data *data)
+static void wm831x_irq_enable(struct irq_data *data)
 {
 	struct wm831x *wm831x = irq_data_get_irq_chip_data(data);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x,
@@ -371,7 +375,7 @@ static void wm831x_irq_unmask(struct irq_data *data)
 	wm831x->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void wm831x_irq_mask(struct irq_data *data)
+static void wm831x_irq_disable(struct irq_data *data)
 {
 	struct wm831x *wm831x = irq_data_get_irq_chip_data(data);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x,
@@ -417,8 +421,8 @@ static struct irq_chip wm831x_irq_chip = {
 	.name			= "wm831x",
 	.irq_bus_lock		= wm831x_irq_lock,
 	.irq_bus_sync_unlock	= wm831x_irq_sync_unlock,
-	.irq_mask		= wm831x_irq_mask,
-	.irq_unmask		= wm831x_irq_unmask,
+	.irq_disable		= wm831x_irq_disable,
+	.irq_enable		= wm831x_irq_enable,
 	.irq_set_type		= wm831x_irq_set_type,
 };
 
-- 
1.7.2.3

