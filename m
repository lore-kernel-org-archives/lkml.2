Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1FGKrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:47:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38850 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751261Ab1FGKrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:47:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Support multiple active WM831x AUXADC conversions
Date: Tue,  7 Jun 2011 11:47:28 +0100
Message-Id: <1307443648-14193-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x AUXADC hardware can schedule multiple conversions at once,
allowing higher performance when more than one source is in use as we
can have the hardware start new conversions without having to wait for
a register write.

Take advantage of this in the interrupt driven case, maintaining a list of
callers that are waiting for AUXADC conversions and completing them all
simultaneously. The external interface of the AUXADC is not changed so
there will be limited use of the feature immediately.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-auxadc.c     |  254 +++++++++++++++++++++++++++------------
 include/linux/mfd/wm831x/core.h |   13 ++-
 2 files changed, 188 insertions(+), 79 deletions(-)

diff --git a/drivers/mfd/wm831x-auxadc.c b/drivers/mfd/wm831x-auxadc.c
index 2fc9531..8721095 100644
--- a/drivers/mfd/wm831x-auxadc.c
+++ b/drivers/mfd/wm831x-auxadc.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/mfd/core.h>
 #include <linux/slab.h>
+#include <linux/list.h>
 
 #include <linux/mfd/wm831x/core.h>
 #include <linux/mfd/wm831x/pdata.h>
@@ -25,19 +26,139 @@
 #include <linux/mfd/wm831x/otp.h>
 #include <linux/mfd/wm831x/regulator.h>
 
-/**
- * wm831x_auxadc_read: Read a value from the WM831x AUXADC
- *
- * @wm831x: Device to read from.
- * @input: AUXADC input to read.
- */
-int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
+struct wm831x_auxadc_req {
+	struct list_head list;
+	enum wm831x_auxadc input;
+	int val;
+	struct completion done;
+};
+
+static int wm831x_auxadc_read_irq(struct wm831x *wm831x,
+				  enum wm831x_auxadc input)
 {
-	int ret, src, irq_masked, timeout;
+	struct wm831x_auxadc_req *req;
+	int ret;
+	bool ena = false;
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	init_completion(&req->done);
+	req->input = input;
+	req->val = -ETIMEDOUT;
+
+	mutex_lock(&wm831x->auxadc_lock);
+
+	/* Enqueue the request */
+	list_add(&req->list, &wm831x->auxadc_pending);
+
+	ena = !wm831x->auxadc_active;
+
+	if (ena) {
+		ret = wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL,
+				      WM831X_AUX_ENA, WM831X_AUX_ENA);
+		if (ret != 0) {
+			dev_err(wm831x->dev, "Failed to enable AUXADC: %d\n",
+				ret);
+			goto out;
+		}
+	}
+
+	/* Enable the conversion if not already running */
+	if (!(wm831x->auxadc_active & (1 << input))) {
+		ret = wm831x_set_bits(wm831x, WM831X_AUXADC_SOURCE,
+				      1 << input, 1 << input);
+		if (ret != 0) {
+			dev_err(wm831x->dev,
+				"Failed to set AUXADC source: %d\n", ret);
+			goto out;
+		}
+
+		wm831x->auxadc_active |= 1 << input;
+	}
+
+	/* We convert at the fastest rate possible */
+	if (ena) {
+		ret = wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL,
+				      WM831X_AUX_CVT_ENA |
+				      WM831X_AUX_RATE_MASK,
+				      WM831X_AUX_CVT_ENA |
+				      WM831X_AUX_RATE_MASK);
+		if (ret != 0) {
+			dev_err(wm831x->dev, "Failed to start AUXADC: %d\n",
+				ret);
+			goto out;
+		}
+	}
+
+	mutex_unlock(&wm831x->auxadc_lock);
+
+	/* Wait for an interrupt */
+	wait_for_completion_timeout(&req->done, msecs_to_jiffies(500));
+
+	mutex_lock(&wm831x->auxadc_lock);
+
+	list_del(&req->list);
+	ret = req->val;
+
+out:
+	mutex_unlock(&wm831x->auxadc_lock);
+
+	kfree(req);
+
+	return ret;
+}
+
+static irqreturn_t wm831x_auxadc_irq(int irq, void *irq_data)
+{
+	struct wm831x *wm831x = irq_data;
+	struct wm831x_auxadc_req *req;
+	int ret, input, val;
+
+	ret = wm831x_reg_read(wm831x, WM831X_AUXADC_DATA);
+	if (ret < 0) {
+		dev_err(wm831x->dev,
+			"Failed to read AUXADC data: %d\n", ret);
+		return IRQ_NONE;
+	}
+
+	input = ((ret & WM831X_AUX_DATA_SRC_MASK)
+		 >> WM831X_AUX_DATA_SRC_SHIFT) - 1;
+
+	if (input == 14)
+		input = WM831X_AUX_CAL;
 
-	/* Are we using the interrupt? */
-	irq_masked = wm831x_reg_read(wm831x, WM831X_INTERRUPT_STATUS_1_MASK);
-	irq_masked &= WM831X_AUXADC_DATA_EINT;
+	val = ret & WM831X_AUX_DATA_MASK;
+
+	mutex_lock(&wm831x->auxadc_lock);
+
+	/* Disable this conversion, we're about to complete all users */
+	wm831x_set_bits(wm831x, WM831X_AUXADC_SOURCE,
+			1 << input, 0);
+	wm831x->auxadc_active &= ~(1 << input);
+
+	/* Turn off the entire convertor if idle */
+	if (!wm831x->auxadc_active)
+		wm831x_reg_write(wm831x, WM831X_AUXADC_CONTROL, 0);
+
+	/* Wake up any threads waiting for this request */
+	list_for_each_entry(req, &wm831x->auxadc_pending, list) {
+		if (req->input == input) {
+			req->val = val;
+			complete(&req->done);
+		}
+	}
+
+	mutex_unlock(&wm831x->auxadc_lock);
+
+	return IRQ_HANDLED;
+}
+
+static int wm831x_auxadc_read_polled(struct wm831x *wm831x,
+				     enum wm831x_auxadc input)
+{
+	int ret, src, timeout;
 
 	mutex_lock(&wm831x->auxadc_lock);
 
@@ -57,9 +178,6 @@ int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
 		goto out;
 	}
 
-	/* Clear any notification from a very late arriving interrupt */
-	try_wait_for_completion(&wm831x->auxadc_done);
-
 	ret = wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL,
 			      WM831X_AUX_CVT_ENA, WM831X_AUX_CVT_ENA);
 	if (ret < 0) {
@@ -67,59 +185,42 @@ int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
 		goto disable;
 	}
 
-	if (irq_masked) {
-		/* If we're not using interrupts then poll the
-		 * interrupt status register */
-		timeout = 5;
-		while (timeout) {
-			msleep(1);
-
-			ret = wm831x_reg_read(wm831x,
-					      WM831X_INTERRUPT_STATUS_1);
-			if (ret < 0) {
-				dev_err(wm831x->dev,
-					"ISR 1 read failed: %d\n", ret);
-				goto disable;
-			}
-
-			/* Did it complete? */
-			if (ret & WM831X_AUXADC_DATA_EINT) {
-				wm831x_reg_write(wm831x,
-						 WM831X_INTERRUPT_STATUS_1,
-						 WM831X_AUXADC_DATA_EINT);
-				break;
-			} else {
-				dev_err(wm831x->dev,
-					"AUXADC conversion timeout\n");
-				ret = -EBUSY;
-				goto disable;
-			}
-		}
+	/* If we're not using interrupts then poll the
+	 * interrupt status register */
+	timeout = 5;
+	while (timeout) {
+		msleep(1);
 
-		ret = wm831x_reg_read(wm831x, WM831X_AUXADC_DATA);
+		ret = wm831x_reg_read(wm831x,
+				      WM831X_INTERRUPT_STATUS_1);
 		if (ret < 0) {
 			dev_err(wm831x->dev,
-				"Failed to read AUXADC data: %d\n", ret);
+				"ISR 1 read failed: %d\n", ret);
 			goto disable;
 		}
 
-		wm831x->auxadc_data = ret;
-
-	} else {
-		/* If we are using interrupts then wait for the
-		 * interrupt to complete.  Use an extremely long
-		 * timeout to handle situations with heavy load where
-		 * the notification of the interrupt may be delayed by
-		 * threaded IRQ handling. */
-		if (!wait_for_completion_timeout(&wm831x->auxadc_done,
-						 msecs_to_jiffies(500))) {
-			dev_err(wm831x->dev, "Timed out waiting for AUXADC\n");
+		/* Did it complete? */
+		if (ret & WM831X_AUXADC_DATA_EINT) {
+			wm831x_reg_write(wm831x,
+					 WM831X_INTERRUPT_STATUS_1,
+					 WM831X_AUXADC_DATA_EINT);
+			break;
+		} else {
+			dev_err(wm831x->dev,
+				"AUXADC conversion timeout\n");
 			ret = -EBUSY;
 			goto disable;
 		}
 	}
 
-	src = ((wm831x->auxadc_data & WM831X_AUX_DATA_SRC_MASK)
+	ret = wm831x_reg_read(wm831x, WM831X_AUXADC_DATA);
+	if (ret < 0) {
+		dev_err(wm831x->dev,
+			"Failed to read AUXADC data: %d\n", ret);
+		goto disable;
+	}
+
+	src = ((ret & WM831X_AUX_DATA_SRC_MASK)
 	       >> WM831X_AUX_DATA_SRC_SHIFT) - 1;
 
 	if (src == 14)
@@ -130,7 +231,7 @@ int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
 			src, input);
 		ret = -EINVAL;
 	} else {
-		ret = wm831x->auxadc_data & WM831X_AUX_DATA_MASK;
+		ret &= WM831X_AUX_DATA_MASK;
 	}
 
 disable:
@@ -139,26 +240,18 @@ out:
 	mutex_unlock(&wm831x->auxadc_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(wm831x_auxadc_read);
 
-static irqreturn_t wm831x_auxadc_irq(int irq, void *irq_data)
+/**
+ * wm831x_auxadc_read: Read a value from the WM831x AUXADC
+ *
+ * @wm831x: Device to read from.
+ * @input: AUXADC input to read.
+ */
+int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
 {
-	struct wm831x *wm831x = irq_data;
-	int ret;
-
-	ret = wm831x_reg_read(wm831x, WM831X_AUXADC_DATA);
-	if (ret < 0) {
-		dev_err(wm831x->dev,
-			"Failed to read AUXADC data: %d\n", ret);
-		wm831x->auxadc_data = 0xffff;
-	} else {
-		wm831x->auxadc_data = ret;
-	}
-
-	complete(&wm831x->auxadc_done);
-
-	return IRQ_HANDLED;
+	return wm831x->auxadc_read(wm831x, input);
 }
+EXPORT_SYMBOL_GPL(wm831x_auxadc_read);
 
 /**
  * wm831x_auxadc_read_uv: Read a voltage from the WM831x AUXADC
@@ -185,15 +278,22 @@ void wm831x_auxadc_init(struct wm831x *wm831x)
 	int ret;
 
 	mutex_init(&wm831x->auxadc_lock);
-	init_completion(&wm831x->auxadc_done);
+	INIT_LIST_HEAD(&wm831x->auxadc_pending);
+
+	if (wm831x->irq && wm831x->irq_base) {
+		wm831x->auxadc_read = wm831x_auxadc_read_irq;
 
-	if (wm831x->irq_base) {
 		ret = request_threaded_irq(wm831x->irq_base +
 					   WM831X_IRQ_AUXADC_DATA,
 					   NULL, wm831x_auxadc_irq, 0,
 					   "auxadc", wm831x);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(wm831x->dev, "AUXADC IRQ request failed: %d\n",
 				ret);
+			wm831x->auxadc_read = NULL;
+		}
 	}
+
+	if (!wm831x->auxadc_read)
+		wm831x->auxadc_read = wm831x_auxadc_read_polled;
 }
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index d6fdefa..8dda8de 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -17,6 +17,7 @@
 
 #include <linux/completion.h>
 #include <linux/interrupt.h>
+#include <linux/list.h>
 
 /*
  * Register values.
@@ -350,6 +351,12 @@ enum wm831x_parent {
 	WM8326 = 0x8326,
 };
 
+struct wm831x;
+enum wm831x_auxadc;
+
+typedef int (*wm831x_auxadc_read_fn)(struct wm831x *wm831x,
+				     enum wm831x_auxadc input);
+
 struct wm831x {
 	struct mutex io_lock;
 
@@ -378,8 +385,9 @@ struct wm831x {
 	int gpio_update[WM831X_NUM_GPIO_REGS];
 
 	struct mutex auxadc_lock;
-	struct completion auxadc_done;
-	u16 auxadc_data;
+	struct list_head auxadc_pending;
+	u16 auxadc_active;
+	wm831x_auxadc_read_fn auxadc_read;
 
 	/* The WM831x has a security key blocking access to certain
 	 * registers.  The mutex is taken by the accessors for locking
@@ -406,5 +414,6 @@ void wm831x_device_exit(struct wm831x *wm831x);
 int wm831x_device_suspend(struct wm831x *wm831x);
 int wm831x_irq_init(struct wm831x *wm831x, int irq);
 void wm831x_irq_exit(struct wm831x *wm831x);
+void wm831x_auxadc_init(struct wm831x *wm831x);
 
 #endif
-- 
1.7.5.3

