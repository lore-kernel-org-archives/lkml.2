Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0DEPOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:14:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45551 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755311Ab0DEPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:14:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Ensure WM831x charger interrupts are acknowledged when suspending
Date: Mon,  5 Apr 2010 16:14:18 +0100
Message-Id: <1270480458-2346-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1270480458-2346-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1270480458-2346-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charger interrupts on the WM831x are unconditionally a wake source
for the system. If the power driver is not able to monitor them (for
example, due to the IRQ line not having been wired up on the system)
then any charger interrupt will prevent the system suspending for any
meaningful amount of time since nothing will ack them.

Avoid this issue by manually acknowledging these interrupts when we
suspend the WM831x core device if they are masked. If software is
actually using the interrupts then they will be unmasked and this
change will have no effect.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c       |   47 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/core.h |    5 ++-
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index f8a8cdf..8152529 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1493,6 +1493,7 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	case WM8310:
 		parent = WM8310;
 		wm831x->num_gpio = 16;
+		wm831x->charger_irq_wake = 1;
 		if (rev > 0) {
 			wm831x->has_gpio_ena = 1;
 			wm831x->has_cs_sts = 1;
@@ -1504,6 +1505,7 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	case WM8311:
 		parent = WM8311;
 		wm831x->num_gpio = 16;
+		wm831x->charger_irq_wake = 1;
 		if (rev > 0) {
 			wm831x->has_gpio_ena = 1;
 			wm831x->has_cs_sts = 1;
@@ -1515,6 +1517,7 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	case WM8312:
 		parent = WM8312;
 		wm831x->num_gpio = 16;
+		wm831x->charger_irq_wake = 1;
 		if (rev > 0) {
 			wm831x->has_gpio_ena = 1;
 			wm831x->has_cs_sts = 1;
@@ -1653,6 +1656,42 @@ static void wm831x_device_exit(struct wm831x *wm831x)
 	kfree(wm831x);
 }
 
+static int wm831x_device_suspend(struct wm831x *wm831x)
+{
+	int reg, mask;
+
+	/* If the charger IRQs are a wake source then make sure we ack
+	 * them even if they're not actively being used (eg, no power
+	 * driver or no IRQ line wired up) then acknowledge the
+	 * interrupts otherwise suspend won't last very long.
+	 */
+	if (wm831x->charger_irq_wake) {
+		reg = wm831x_reg_read(wm831x, WM831X_INTERRUPT_STATUS_2_MASK);
+
+		mask = WM831X_CHG_BATT_HOT_EINT |
+			WM831X_CHG_BATT_COLD_EINT |
+			WM831X_CHG_BATT_FAIL_EINT |
+			WM831X_CHG_OV_EINT | WM831X_CHG_END_EINT |
+			WM831X_CHG_TO_EINT | WM831X_CHG_MODE_EINT |
+			WM831X_CHG_START_EINT;
+
+		/* If any of the interrupts are masked read the statuses */
+		if (reg & mask)
+			reg = wm831x_reg_read(wm831x,
+					      WM831X_INTERRUPT_STATUS_2);
+
+		if (reg & mask) {
+			dev_info(wm831x->dev,
+				 "Acknowledging masked charger IRQs: %x\n",
+				 reg & mask);
+			wm831x_reg_write(wm831x, WM831X_INTERRUPT_STATUS_2,
+					 reg & mask);
+		}
+	}
+
+	return 0;
+}
+
 static int wm831x_i2c_read_device(struct wm831x *wm831x, unsigned short reg,
 				  int bytes, void *dest)
 {
@@ -1727,6 +1766,13 @@ static int wm831x_i2c_remove(struct i2c_client *i2c)
 	return 0;
 }
 
+static int wm831x_i2c_suspend(struct i2c_client *i2c)
+{
+	struct wm831x *wm831x = i2c_get_clientdata(i2c);
+
+	return wm831x_device_suspend(wm831x);
+}
+
 static const struct i2c_device_id wm831x_i2c_id[] = {
 	{ "wm8310", WM8310 },
 	{ "wm8311", WM8311 },
@@ -1744,6 +1790,7 @@ static struct i2c_driver wm831x_i2c_driver = {
 	},
 	.probe = wm831x_i2c_probe,
 	.remove = wm831x_i2c_remove,
+	.suspend = wm831x_i2c_suspend,
 	.id_table = wm831x_i2c_id,
 };
 
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index 5915f6e..eb5bd4e 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -256,8 +256,9 @@ struct wm831x {
 	int irq_masks_cache[WM831X_NUM_IRQ_REGS]; /* Cached hardware value */
 
 	/* Chip revision based flags */
-	unsigned has_gpio_ena:1;  /* Has GPIO enable bit */
-	unsigned has_cs_sts:1;    /* Has current sink status bit */
+	unsigned has_gpio_ena:1;         /* Has GPIO enable bit */
+	unsigned has_cs_sts:1;           /* Has current sink status bit */
+	unsigned charger_irq_wake:1;     /* Are charger IRQs a wake source? */
 
 	int num_gpio;
 
-- 
1.7.0.3

