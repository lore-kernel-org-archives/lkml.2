Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1IPMVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:21:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53966 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751820Ab1IPMVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:21:51 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Oritz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Simulate active high IRQs with wm831x
Date: Fri, 16 Sep 2011 13:21:47 +0100
Message-Id: <1316175707-17871-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to ease system integration provide a simulation of active high
IRQs on the GPIOs by polling the GPIO status when an IRQ is generated.

This isn't ideal on several fronts and will miss initially active IRQs in
the current implementation but it should work well for most cases.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c        |   22 +++++++++++++++++++++-
 include/linux/mfd/wm831x/core.h |    1 +
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index a10937c..f4747a4 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -420,12 +420,19 @@ static int wm831x_irq_set_type(struct irq_data *data, unsigned int type)
 	switch (type) {
 	case IRQ_TYPE_EDGE_BOTH:
 		wm831x->gpio_update[irq] = 0x10000 | WM831X_GPN_INT_MODE;
+		wm831x->gpio_level[irq] = false;
 		break;
 	case IRQ_TYPE_EDGE_RISING:
 		wm831x->gpio_update[irq] = 0x10000 | WM831X_GPN_POL;
+		wm831x->gpio_level[irq] = false;
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
 		wm831x->gpio_update[irq] = 0x10000;
+		wm831x->gpio_level[irq] = false;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		wm831x->gpio_update[irq] = 0x10000 | WM831X_GPN_POL;
+		wm831x->gpio_level[irq] = true;
 		break;
 	default:
 		return -EINVAL;
@@ -449,7 +456,7 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 {
 	struct wm831x *wm831x = data;
 	unsigned int i;
-	int primary, status_addr;
+	int primary, status_addr, ret;
 	int status_regs[WM831X_NUM_IRQ_REGS] = { 0 };
 	int read[WM831X_NUM_IRQ_REGS] = { 0 };
 	int *status;
@@ -507,6 +514,19 @@ static irqreturn_t wm831x_irq_thread(int irq, void *data)
 
 		if (*status & wm831x_irqs[i].mask)
 			handle_nested_irq(wm831x->irq_base + i);
+
+		/* Simulate an edge triggered IRQ by polling the input
+		 * status.  This is sucky but improves interoperability.
+		 */
+		if (primary == WM831X_GP_INT &&
+		    wm831x->gpio_level[i - WM831X_IRQ_GPIO_1]) {
+			ret = wm831x_reg_read(wm831x, WM831X_GPIO_LEVEL);
+			while (ret & 1 << (i - WM831X_IRQ_GPIO_1)) {
+				handle_nested_irq(wm831x->irq_base + i);
+				ret = wm831x_reg_read(wm831x,
+						      WM831X_GPIO_LEVEL);
+			}
+		}
 	}
 
 out:
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index ed8fe0d..4b12118 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -382,6 +382,7 @@ struct wm831x {
 
 	/* Used by the interrupt controller code to post writes */
 	int gpio_update[WM831X_NUM_GPIO_REGS];
+	bool gpio_level[WM831X_NUM_GPIO_REGS];
 
 	struct mutex auxadc_lock;
 	struct list_head auxadc_pending;
-- 
1.7.6.3

