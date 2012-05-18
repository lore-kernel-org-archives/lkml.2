Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2ERQCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:02:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59411 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757634Ab2ERQCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:02:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm831x: Emulate active low IRQs as well as active high IRQs
Date: Fri, 18 May 2012 17:02:02 +0100
Message-Id: <1337356922-21650-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As with the existing emulation this should not be used in production
systems but is useful for test purposes.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c        |   24 +++++++++++++++++++-----
 include/linux/mfd/wm831x/core.h |    3 ++-
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index ecc9d6d..804e56e 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -413,22 +413,25 @@ static int wm831x_irq_set_type(struct irq_data *data, unsigned int type)
 	 * do the update here as we can be called with the bus lock
 	 * held.
 	 */
+	wm831x->gpio_level_low[irq] = false;
+	wm831x->gpio_level_high[irq] = false;
 	switch (type) {
 	case IRQ_TYPE_EDGE_BOTH:
 		wm831x->gpio_update[irq] = 0x10000 | WM831X_GPN_INT_MODE;
-		wm831x->gpio_level[irq] = false;
 		break;
 	case IRQ_TYPE_EDGE_RISING:
 		wm831x->gpio_update[irq] = 0x10000 | WM831X_GPN_POL;
-		wm831x->gpio_level[irq] = false;
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
 		wm831x->gpio_update[irq] = 0x10000;
-		wm831x->gpio_level[irq] = false;
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
 		wm831x->gpio_update[irq] = 0x10000 | WM831X_GPN_POL;
-		wm831x->gpio_level[irq] = true;
+		wm831x->gpio_level_high[irq] = true;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		wm831x->gpio_update[irq] = 0x10000;
+		wm831x->gpio_level_low[irq] = true;
 		break;
 	default:
 		return -EINVAL;
@@ -517,7 +520,7 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 		 * status.  This is sucky but improves interoperability.
 		 */
 		if (primary == WM831X_GP_INT &&
-		    wm831x->gpio_level[i - WM831X_IRQ_GPIO_1]) {
+		    wm831x->gpio_level_high[i - WM831X_IRQ_GPIO_1]) {
 			ret = wm831x_reg_read(wm831x, WM831X_GPIO_LEVEL);
 			while (ret & 1 << (i - WM831X_IRQ_GPIO_1)) {
 				handle_nested_irq(irq_find_mapping(wm831x->irq_domain,
@@ -526,6 +529,17 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 						      WM831X_GPIO_LEVEL);
 			}
 		}
+
+		if (primary == WM831X_GP_INT &&
+		    wm831x->gpio_level_low[i - WM831X_IRQ_GPIO_1]) {
+			ret = wm831x_reg_read(wm831x, WM831X_GPIO_LEVEL);
+			while (!(ret & 1 << (i - WM831X_IRQ_GPIO_1))) {
+				handle_nested_irq(irq_find_mapping(wm831x->irq_domain,
+								   i));
+				ret = wm831x_reg_read(wm831x,
+						      WM831X_GPIO_LEVEL);
+			}
+		}
 	}
 
 out:
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index 736191c..4a3b83a 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -384,7 +384,8 @@ struct wm831x {
 
 	/* Used by the interrupt controller code to post writes */
 	int gpio_update[WM831X_NUM_GPIO_REGS];
-	bool gpio_level[WM831X_NUM_GPIO_REGS];
+	bool gpio_level_high[WM831X_NUM_GPIO_REGS];
+	bool gpio_level_low[WM831X_NUM_GPIO_REGS];
 
 	struct mutex auxadc_lock;
 	struct list_head auxadc_pending;
-- 
1.7.10

