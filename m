Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0DBPbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 11:31:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47082 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751519Ab0DBPbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 11:31:08 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Improve WM831x AUXADC completion handling
Date: Fri,  2 Apr 2010 16:31:03 +0100
Message-Id: <1270222263-14203-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently completion of WM831x AUXADC conversions is monitored by
checking for convertor enable. Due to the mechanism used to ensure
data corruption is avoided when reading AUXADC data there may under
heavy I/O be a window where this bit has cleared but the conversion
results have not been updated. Data availability is only guaranteed
after the AUXADC data interrupt has been asserted.

Avoid this by always using the interrupt to detect completion. If the
chip IRQ is not set up then we poll the IRQ status register for up to
5ms. If it is set up then we rely on the data done interrupt with a
vastly increased timeout, failing the conversion if the interrupt is
not generated.

This also saves a register read when using interrupts.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |   65 +++++++++++++++++++++++++++++++++------------
 1 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index f2ab025..da00ca9 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -322,7 +322,11 @@ EXPORT_SYMBOL_GPL(wm831x_set_bits);
  */
 int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
 {
-	int ret, src;
+	int ret, src, irq_masked, timeout;
+
+	/* Are we using the interrupt? */
+	irq_masked = wm831x_reg_read(wm831x, WM831X_INTERRUPT_STATUS_1_MASK);
+	irq_masked &= WM831X_AUXADC_DATA_EINT;
 
 	mutex_lock(&wm831x->auxadc_lock);
 
@@ -342,6 +346,9 @@ int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
 		goto out;
 	}
 
+	/* Clear any notification from a very late arriving interrupt */
+	try_wait_for_completion(&wm831x->auxadc_done);
+
 	ret = wm831x_set_bits(wm831x, WM831X_AUXADC_CONTROL,
 			      WM831X_AUX_CVT_ENA, WM831X_AUX_CVT_ENA);
 	if (ret < 0) {
@@ -349,22 +356,46 @@ int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
 		goto disable;
 	}
 
-	/* If an interrupt arrived late clean up after it */
-	try_wait_for_completion(&wm831x->auxadc_done);
-
-	/* Ignore the result to allow us to soldier on without IRQ hookup */
-	wait_for_completion_timeout(&wm831x->auxadc_done, msecs_to_jiffies(5));
-
-	ret = wm831x_reg_read(wm831x, WM831X_AUXADC_CONTROL);
-	if (ret < 0) {
-		dev_err(wm831x->dev, "AUXADC status read failed: %d\n", ret);
-		goto disable;
-	}
-
-	if (ret & WM831X_AUX_CVT_ENA) {
-		dev_err(wm831x->dev, "Timed out reading AUXADC\n");
-		ret = -EBUSY;
-		goto disable;
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
 	}
 
 	ret = wm831x_reg_read(wm831x, WM831X_AUXADC_DATA);
-- 
1.7.0.3

