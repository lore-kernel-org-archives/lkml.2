Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab1FBSVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:21:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36564 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754180Ab1FBSUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:20:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 7/9] mfd: Refactor wm831x AUXADC handling into a separate file
Date: Thu,  2 Jun 2011 19:18:53 +0100
Message-Id: <1307038735-18788-7-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110602181808.GA18726@opensource.wolfsonmicro.com>
 <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for some additional work on the wm831x AUXADC code move the
support into a separate file. This is a simple code motion patch, there
should be no functional changes.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/wm831x-auxadc.c |  199 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/wm831x-core.c   |  167 +------------------------------------
 3 files changed, 201 insertions(+), 166 deletions(-)
 create mode 100644 drivers/mfd/wm831x-auxadc.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index efe3cc3..9f41923 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_MFD_TC6393XB)	+= tc6393xb.o tmio_core.o
 
 obj-$(CONFIG_MFD_WM8400)	+= wm8400-core.o
 wm831x-objs			:= wm831x-core.o wm831x-irq.o wm831x-otp.o
+wm831x-objs			+= wm831x-auxadc.o
 obj-$(CONFIG_MFD_WM831X)	+= wm831x.o
 obj-$(CONFIG_MFD_WM831X_I2C)	+= wm831x-i2c.o
 obj-$(CONFIG_MFD_WM831X_SPI)	+= wm831x-spi.o
diff --git a/drivers/mfd/wm831x-auxadc.c b/drivers/mfd/wm831x-auxadc.c
new file mode 100644
index 0000000..2fc9531
--- /dev/null
+++ b/drivers/mfd/wm831x-auxadc.c
@@ -0,0 +1,199 @@
+/*
+ * wm831x-auxadc.c  --  AUXADC for Wolfson WM831x PMICs
+ *
+ * Copyright 2009-2011 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/mfd/core.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/wm831x/core.h>
+#include <linux/mfd/wm831x/pdata.h>
+#include <linux/mfd/wm831x/irq.h>
+#include <linux/mfd/wm831x/auxadc.h>
+#include <linux/mfd/wm831x/otp.h>
+#include <linux/mfd/wm831x/regulator.h>
+
+/**
+ * wm831x_auxadc_read: Read a value from the WM831x AUXADC
+ *
+ * @wm831x: Device to read from.
+ * @input: AUXADC input to read.
+ */
+int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
+{
+	int ret, src, irq_masked, timeout;
+
+	/* Are we using the interrupt? */
+	irq_masked = wm831x_reg_read(wm831x, WM831X_INTERRUPT_STATUS_1_MASK);
+	irq_masked &= WM831X_AUXADC_DATA_EINT;
+
+	mutex_lock(&wm831x->auxadc_lock);
+
+	ret = wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL,
+			      WM831X_AUX_ENA, WM831X_AUX_ENA);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to enable AUXADC: %d\n", ret);
+		goto out;
+	}
+
+	/* We force a single source at present */
+	src = input;
+	ret = wm831x_reg_write(wm831x, WM831X_AUXADC_SOURCE,
+			       1 << src);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to set AUXADC source: %d\n", ret);
+		goto out;
+	}
+
+	/* Clear any notification from a very late arriving interrupt */
+	try_wait_for_completion(&wm831x->auxadc_done);
+
+	ret = wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL,
+			      WM831X_AUX_CVT_ENA, WM831X_AUX_CVT_ENA);
+	if (ret < 0) {
+		dev_err(wm831x->dev, "Failed to start AUXADC: %d\n", ret);
+		goto disable;
+	}
+
+	if (irq_masked) {
+		/* If we're not using interrupts then poll the
+		 * interrupt status register */
+		timeout = 5;
+		while (timeout) {
+			msleep(1);
+
+			ret = wm831x_reg_read(wm831x,
+					      WM831X_INTERRUPT_STATUS_1);
+			if (ret < 0) {
+				dev_err(wm831x->dev,
+					"ISR 1 read failed: %d\n", ret);
+				goto disable;
+			}
+
+			/* Did it complete? */
+			if (ret & WM831X_AUXADC_DATA_EINT) {
+				wm831x_reg_write(wm831x,
+						 WM831X_INTERRUPT_STATUS_1,
+						 WM831X_AUXADC_DATA_EINT);
+				break;
+			} else {
+				dev_err(wm831x->dev,
+					"AUXADC conversion timeout\n");
+				ret = -EBUSY;
+				goto disable;
+			}
+		}
+
+		ret = wm831x_reg_read(wm831x, WM831X_AUXADC_DATA);
+		if (ret < 0) {
+			dev_err(wm831x->dev,
+				"Failed to read AUXADC data: %d\n", ret);
+			goto disable;
+		}
+
+		wm831x->auxadc_data = ret;
+
+	} else {
+		/* If we are using interrupts then wait for the
+		 * interrupt to complete.  Use an extremely long
+		 * timeout to handle situations with heavy load where
+		 * the notification of the interrupt may be delayed by
+		 * threaded IRQ handling. */
+		if (!wait_for_completion_timeout(&wm831x->auxadc_done,
+						 msecs_to_jiffies(500))) {
+			dev_err(wm831x->dev, "Timed out waiting for AUXADC\n");
+			ret = -EBUSY;
+			goto disable;
+		}
+	}
+
+	src = ((wm831x->auxadc_data & WM831X_AUX_DATA_SRC_MASK)
+	       >> WM831X_AUX_DATA_SRC_SHIFT) - 1;
+
+	if (src == 14)
+		src = WM831X_AUX_CAL;
+
+	if (src != input) {
+		dev_err(wm831x->dev, "Data from source %d not %d\n",
+			src, input);
+		ret = -EINVAL;
+	} else {
+		ret = wm831x->auxadc_data & WM831X_AUX_DATA_MASK;
+	}
+
+disable:
+	wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL, WM831X_AUX_ENA, 0);
+out:
+	mutex_unlock(&wm831x->auxadc_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm831x_auxadc_read);
+
+static irqreturn_t wm831x_auxadc_irq(int irq, void *irq_data)
+{
+	struct wm831x *wm831x = irq_data;
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, WM831X_AUXADC_DATA);
+	if (ret < 0) {
+		dev_err(wm831x->dev,
+			"Failed to read AUXADC data: %d\n", ret);
+		wm831x->auxadc_data = 0xffff;
+	} else {
+		wm831x->auxadc_data = ret;
+	}
+
+	complete(&wm831x->auxadc_done);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * wm831x_auxadc_read_uv: Read a voltage from the WM831x AUXADC
+ *
+ * @wm831x: Device to read from.
+ * @input: AUXADC input to read.
+ */
+int wm831x_auxadc_read_uv(struct wm831x *wm831x, enum wm831x_auxadc input)
+{
+	int ret;
+
+	ret = wm831x_auxadc_read(wm831x, input);
+	if (ret < 0)
+		return ret;
+
+	ret *= 1465;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm831x_auxadc_read_uv);
+
+void wm831x_auxadc_init(struct wm831x *wm831x)
+{
+	int ret;
+
+	mutex_init(&wm831x->auxadc_lock);
+	init_completion(&wm831x->auxadc_done);
+
+	if (wm831x->irq_base) {
+		ret = request_threaded_irq(wm831x->irq_base +
+					   WM831X_IRQ_AUXADC_DATA,
+					   NULL, wm831x_auxadc_irq, 0,
+					   "auxadc", wm831x);
+		if (ret < 0)
+			dev_err(wm831x->dev, "AUXADC IRQ request failed: %d\n",
+				ret);
+	}
+}
diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 480abc1..772fe58 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -306,161 +306,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(wm831x_set_bits);
 
-/**
- * wm831x_auxadc_read: Read a value from the WM831x AUXADC
- *
- * @wm831x: Device to read from.
- * @input: AUXADC input to read.
- */
-int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
-{
-	int ret, src, irq_masked, timeout;
-
-	/* Are we using the interrupt? */
-	irq_masked = wm831x_reg_read(wm831x, WM831X_INTERRUPT_STATUS_1_MASK);
-	irq_masked &= WM831X_AUXADC_DATA_EINT;
-
-	mutex_lock(&wm831x->auxadc_lock);
-
-	ret = wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL,
-			      WM831X_AUX_ENA, WM831X_AUX_ENA);
-	if (ret < 0) {
-		dev_err(wm831x->dev, "Failed to enable AUXADC: %d\n", ret);
-		goto out;
-	}
-
-	/* We force a single source at present */
-	src = input;
-	ret = wm831x_reg_write(wm831x, WM831X_AUXADC_SOURCE,
-			       1 << src);
-	if (ret < 0) {
-		dev_err(wm831x->dev, "Failed to set AUXADC source: %d\n", ret);
-		goto out;
-	}
-
-	/* Clear any notification from a very late arriving interrupt */
-	try_wait_for_completion(&wm831x->auxadc_done);
-
-	ret = wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL,
-			      WM831X_AUX_CVT_ENA, WM831X_AUX_CVT_ENA);
-	if (ret < 0) {
-		dev_err(wm831x->dev, "Failed to start AUXADC: %d\n", ret);
-		goto disable;
-	}
-
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
-
-		ret = wm831x_reg_read(wm831x, WM831X_AUXADC_DATA);
-		if (ret < 0) {
-			dev_err(wm831x->dev,
-				"Failed to read AUXADC data: %d\n", ret);
-			goto disable;
-		}
-
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
-			ret = -EBUSY;
-			goto disable;
-		}
-	}
-
-	src = ((wm831x->auxadc_data & WM831X_AUX_DATA_SRC_MASK)
-	       >> WM831X_AUX_DATA_SRC_SHIFT) - 1;
-
-	if (src == 14)
-		src = WM831X_AUX_CAL;
-
-	if (src != input) {
-		dev_err(wm831x->dev, "Data from source %d not %d\n",
-			src, input);
-		ret = -EINVAL;
-	} else {
-		ret = wm831x->auxadc_data & WM831X_AUX_DATA_MASK;
-	}
-
-disable:
-	wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL, WM831X_AUX_ENA, 0);
-out:
-	mutex_unlock(&wm831x->auxadc_lock);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(wm831x_auxadc_read);
-
-static irqreturn_t wm831x_auxadc_irq(int irq, void *irq_data)
-{
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
-}
-
-/**
- * wm831x_auxadc_read_uv: Read a voltage from the WM831x AUXADC
- *
- * @wm831x: Device to read from.
- * @input: AUXADC input to read.
- */
-int wm831x_auxadc_read_uv(struct wm831x *wm831x, enum wm831x_auxadc input)
-{
-	int ret;
-
-	ret = wm831x_auxadc_read(wm831x, input);
-	if (ret < 0)
-		return ret;
-
-	ret *= 1465;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(wm831x_auxadc_read_uv);
-
 static struct resource wm831x_dcdc1_resources[] = {
 	{
 		.start = WM831X_DC1_CONTROL_1,
@@ -1447,8 +1292,6 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 
 	mutex_init(&wm831x->io_lock);
 	mutex_init(&wm831x->key_lock);
-	mutex_init(&wm831x->auxadc_lock);
-	init_completion(&wm831x->auxadc_done);
 	dev_set_drvdata(wm831x->dev, wm831x);
 
 	ret = wm831x_reg_read(wm831x, WM831X_PARENT_ID);
@@ -1603,15 +1446,7 @@ int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	if (ret != 0)
 		goto err;
 
-	if (wm831x->irq_base) {
-		ret = request_threaded_irq(wm831x->irq_base +
-					   WM831X_IRQ_AUXADC_DATA,
-					   NULL, wm831x_auxadc_irq, 0,
-					   "auxadc", wm831x);
-		if (ret < 0)
-			dev_err(wm831x->dev, "AUXADC IRQ request failed: %d\n",
-				ret);
-	}
+	wm831x_auxadc_init(wm831x);
 
 	/* The core device is up, instantiate the subdevices. */
 	switch (parent) {
-- 
1.7.5.3

