Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1FBSVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:21:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36565 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753864Ab1FBSUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:20:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/9] mfd: Read wm831x AUXADC conversion results before acknowledging interrupt
Date: Thu,  2 Jun 2011 19:18:52 +0100
Message-Id: <1307038735-18788-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110602181808.GA18726@opensource.wolfsonmicro.com>
 <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that there's no possibility of loosing an AUXADC interrupt by reading
the conversion result in the IRQ handler when using interrupts. Otherwise
it's possible that under very heavy load a new conversion could be initiated
before the acknowledgement for a previous interrupt has happened.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c       |   47 +++++++++++++++++++++++++-------------
 include/linux/mfd/wm831x/core.h |    1 +
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 58f033b..480abc1 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -376,6 +376,16 @@ int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
 				goto disable;
 			}
 		}
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
 	} else {
 		/* If we are using interrupts then wait for the
 		 * interrupt to complete.  Use an extremely long
@@ -390,23 +400,18 @@ int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
 		}
 	}
 
-	ret = wm831x_reg_read(wm831x, WM831X_AUXADC_DATA);
-	if (ret < 0) {
-		dev_err(wm831x->dev, "Failed to read AUXADC data: %d\n", ret);
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
 	} else {
-		src = ((ret & WM831X_AUX_DATA_SRC_MASK)
-		       >> WM831X_AUX_DATA_SRC_SHIFT) - 1;
-
-		if (src == 14)
-			src = WM831X_AUX_CAL;
-
-		if (src != input) {
-			dev_err(wm831x->dev, "Data from source %d not %d\n",
-				src, input);
-			ret = -EINVAL;
-		} else {
-			ret &= WM831X_AUX_DATA_MASK;
-		}
+		ret = wm831x->auxadc_data & WM831X_AUX_DATA_MASK;
 	}
 
 disable:
@@ -420,6 +425,16 @@ EXPORT_SYMBOL_GPL(wm831x_auxadc_read);
 static irqreturn_t wm831x_auxadc_irq(int irq, void *irq_data)
 {
 	struct wm831x *wm831x = irq_data;
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
 
 	complete(&wm831x->auxadc_done);
 
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index 9564cf3..592e4fd 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -278,6 +278,7 @@ struct wm831x {
 
 	struct mutex auxadc_lock;
 	struct completion auxadc_done;
+	u16 auxadc_data;
 
 	/* The WM831x has a security key blocking access to certain
 	 * registers.  The mutex is taken by the accessors for locking
-- 
1.7.5.3

