Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab0LIXex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:34:53 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:44206 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756470Ab0LIXew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:34:52 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/LTvoHDMPLNuhcnoRwgApqt11WvKytF2i7p1UwCH
	eXvqFTCXTv2YRD
From: Peter Huewe <peterhuewe@gmx.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>, Stable <stable@kernel.org>
Subject: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and fix build failure
Date: Fri, 10 Dec 2010 00:34:47 +0100
Message-Id: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a build failure[1] by converting the driver to use the
new irq_chip functions.
The old functions are deprecated and masked by GENERIC_HARDIRQS_NO__DO_IRQ

Cc: Stable <stable@kernel.org>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-20101209

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/3607671/

 drivers/mfd/wm831x-irq.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 294183b..018b9ec 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -345,16 +345,16 @@ static inline struct wm831x_irq_data *irq_to_wm831x_irq(struct wm831x *wm831x,
 	return &wm831x_irqs[irq - wm831x->irq_base];
 }
 
-static void wm831x_irq_lock(unsigned int irq)
+static void wm831x_irq_lock(struct irq_data *data)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = get_irq_chip_data(data->irq);
 
 	mutex_lock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_sync_unlock(unsigned int irq)
+static void wm831x_irq_sync_unlock(struct irq_data *data)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = get_irq_chip_data(data->irq);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
@@ -371,32 +371,32 @@ static void wm831x_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_unmask(unsigned int irq)
+static void wm831x_irq_unmask(struct irq_data *data)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
-	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
+	struct wm831x *wm831x = get_irq_chip_data(data->irq);
+	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, data->irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void wm831x_irq_mask(unsigned int irq)
+static void wm831x_irq_mask(struct irq_data *data)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
-	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
+	struct wm831x *wm831x = get_irq_chip_data(data->irq);
+	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, data->irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
 }
 
-static int wm831x_irq_set_type(unsigned int irq, unsigned int type)
+static int wm831x_irq_set_type(struct irq_data *data, unsigned int type)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = get_irq_chip_data(data->irq);
 	int val;
 
-	irq = irq - wm831x->irq_base;
+	data->irq = data->irq - wm831x->irq_base;
 
-	if (irq < WM831X_IRQ_GPIO_1 || irq > WM831X_IRQ_GPIO_11) {
+	if (data->irq < WM831X_IRQ_GPIO_1 || data->irq > WM831X_IRQ_GPIO_11) {
 		/* Ignore internal-only IRQs */
-		if (irq >= 0 && irq < WM831X_NUM_IRQS)
+		if (data->irq >= 0 && data->irq < WM831X_NUM_IRQS)
 			return 0;
 		else
 			return -EINVAL;
@@ -416,17 +416,17 @@ static int wm831x_irq_set_type(unsigned int irq, unsigned int type)
 		return -EINVAL;
 	}
 
-	return wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + irq,
+	return wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + data->irq,
 			       WM831X_GPN_INT_MODE | WM831X_GPN_POL, val);
 }
 
 static struct irq_chip wm831x_irq_chip = {
 	.name = "wm831x",
-	.bus_lock = wm831x_irq_lock,
-	.bus_sync_unlock = wm831x_irq_sync_unlock,
-	.mask = wm831x_irq_mask,
-	.unmask = wm831x_irq_unmask,
-	.set_type = wm831x_irq_set_type,
+	.irq_bus_lock = wm831x_irq_lock,
+	.irq_bus_sync_unlock = wm831x_irq_sync_unlock,
+	.irq_mask = wm831x_irq_mask,
+	.irq_unmask = wm831x_irq_unmask,
+	.irq_set_type = wm831x_irq_set_type,
 };
 
 /* The processing of the primary interrupt occurs in a thread so that
-- 
1.7.2.2

