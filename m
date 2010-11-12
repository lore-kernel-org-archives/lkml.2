Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab0KLTTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:19:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38986 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932857Ab0KLTTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:19:36 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Oritz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] mfd: Convert WM831x to new irq_ interrupt methods
Date: Fri, 12 Nov 2010 19:19:30 +0000
Message-Id: <1289589572-19261-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.37 adds new interrupt methods which take a struct irq_data
rather than an irq number. Convert over to these as they will become
mandatory in future.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |   42 ++++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 294183b..eae5272 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -345,16 +345,16 @@ static inline struct wm831x_irq_data *irq_to_wm831x_irq(struct wm831x *wm831x,
 	return &wm831x_irqs[irq - wm831x->irq_base];
 }
 
-static void wm831x_irq_lock(unsigned int irq)
+static void wm831x_irq_lock(struct irq_data *data)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = data->chip_data;
 
 	mutex_lock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_sync_unlock(unsigned int irq)
+static void wm831x_irq_sync_unlock(struct irq_data *data)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = data->chip_data;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
@@ -371,28 +371,30 @@ static void wm831x_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_unmask(unsigned int irq)
+static void wm831x_irq_unmask(struct irq_data *data)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
-	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
+	struct wm831x *wm831x = data->chip_data;
+	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x,
+							     data->irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void wm831x_irq_mask(unsigned int irq)
+static void wm831x_irq_mask(struct irq_data *data)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
-	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
+	struct wm831x *wm831x = data->chip_data;
+	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x,
+							     data->irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
 }
 
-static int wm831x_irq_set_type(unsigned int irq, unsigned int type)
+static int wm831x_irq_set_type(struct irq_data *data, unsigned int type)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
-	int val;
+	struct wm831x *wm831x = data->chip_data;
+	int val, irq;
 
-	irq = irq - wm831x->irq_base;
+	irq = data->irq - wm831x->irq_base;
 
 	if (irq < WM831X_IRQ_GPIO_1 || irq > WM831X_IRQ_GPIO_11) {
 		/* Ignore internal-only IRQs */
@@ -421,12 +423,12 @@ static int wm831x_irq_set_type(unsigned int irq, unsigned int type)
 }
 
 static struct irq_chip wm831x_irq_chip = {
-	.name = "wm831x",
-	.bus_lock = wm831x_irq_lock,
-	.bus_sync_unlock = wm831x_irq_sync_unlock,
-	.mask = wm831x_irq_mask,
-	.unmask = wm831x_irq_unmask,
-	.set_type = wm831x_irq_set_type,
+	.name			= "wm831x",
+	.irq_bus_lock		= wm831x_irq_lock,
+	.irq_bus_sync_unlock	= wm831x_irq_sync_unlock,
+	.irq_mask		= wm831x_irq_mask,
+	.irq_unmask		= wm831x_irq_unmask,
+	.irq_set_type		= wm831x_irq_set_type,
 };
 
 /* The processing of the primary interrupt occurs in a thread so that
-- 
1.7.1

