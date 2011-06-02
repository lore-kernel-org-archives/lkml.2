Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1FBSUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:20:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36557 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754063Ab1FBSUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:20:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/9] mfd: Fix bus lock interaction for WM831x IRQ set_type() operation
Date: Thu,  2 Jun 2011 19:18:47 +0100
Message-Id: <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <20110602181808.GA18726@opensource.wolfsonmicro.com>
References: <20110602181808.GA18726@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x IRQ set_type() operation is doing a direct register write when
called but since set_type() is called with the bus lock held this isn't
legal and could cause deadlocks in the IRQ core.

Fix this by posting the updates into an array and syncing in the
bus_sync_unlock() callback.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c        |   24 ++++++++++++++++++------
 include/linux/mfd/wm831x/core.h |    4 ++++
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 42b928e..b23d8d5 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -348,6 +348,15 @@ static void wm831x_irq_sync_unlock(struct irq_data *data)
 	struct wm831x *wm831x = irq_data_get_irq_chip_data(data);
 	int i;
 
+	for (i = 0; i < ARRAY_SIZE(wm831x->gpio_update); i++) {
+		if (wm831x->gpio_update[i]) {
+			wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + i,
+					WM831X_GPN_INT_MODE | WM831X_GPN_POL,
+					wm831x->gpio_update[i]);
+			wm831x->gpio_update[i] = 0;
+		}
+	}
+
 	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
 		/* If there's been a change in the mask write it back
 		 * to the hardware. */
@@ -387,7 +396,7 @@ static void wm831x_irq_disable(struct irq_data *data)
 static int wm831x_irq_set_type(struct irq_data *data, unsigned int type)
 {
 	struct wm831x *wm831x = irq_data_get_irq_chip_data(data);
-	int val, irq;
+	int irq;
 
 	irq = data->irq - wm831x->irq_base;
 
@@ -399,22 +408,25 @@ static int wm831x_irq_set_type(struct irq_data *data, unsigned int type)
 			return -EINVAL;
 	}
 
+	/* We set the high bit to flag that we need an update; don't
+	 * do the update here as we can be called with the bus lock
+	 * held.
+	 */
 	switch (type) {
 	case IRQ_TYPE_EDGE_BOTH:
-		val = WM831X_GPN_INT_MODE;
+		wm831x->gpio_update[irq] = 0x10000 | WM831X_GPN_INT_MODE;
 		break;
 	case IRQ_TYPE_EDGE_RISING:
-		val = WM831X_GPN_POL;
+		wm831x->gpio_update[irq] = 0x10000 | WM831X_GPN_POL;
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
-		val = 0;
+		wm831x->gpio_update[irq] = 0x10000;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	return wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + irq,
-			       WM831X_GPN_INT_MODE | WM831X_GPN_POL, val);
+	return 0;
 }
 
 static struct irq_chip wm831x_irq_chip = {
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index 0d515ee..ebead1c 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -237,6 +237,7 @@
 struct regulator_dev;
 
 #define WM831X_NUM_IRQ_REGS 5
+#define WM831X_NUM_GPIO_REGS 16
 
 enum wm831x_parent {
 	WM8310 = 0x8310,
@@ -272,6 +273,9 @@ struct wm831x {
 
 	int num_gpio;
 
+	/* Used by the interrupt controller code to post writes */
+	int gpio_update[WM831X_NUM_GPIO_REGS];
+
 	struct mutex auxadc_lock;
 	struct completion auxadc_done;
 
-- 
1.7.5.3

