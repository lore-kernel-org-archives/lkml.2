Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517Ab1IOMkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:40:20 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:58564 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554Ab1IOMkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:10 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 01/17] MFD: twl6040: Remove global pointer for platform_device
Date: Thu, 15 Sep 2011 15:39:23 +0300
Message-Id: <1316090379-30760-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to keep global pointer for the platform
device, since it is only used for dev_* prints, and the
device pointer available within the twl6040 structure.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 24d436c..b0519e6 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -34,8 +34,6 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
 
-static struct platform_device *twl6040_dev;
-
 int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 {
 	int ret;
@@ -203,11 +201,11 @@ static irqreturn_t twl6040_naudint_handler(int irq, void *data)
 	if (intid & TWL6040_THINT) {
 		status = twl6040_reg_read(twl6040, TWL6040_REG_STATUS);
 		if (status & TWL6040_TSHUTDET) {
-			dev_warn(&twl6040_dev->dev,
+			dev_warn(twl6040->dev,
 				 "Thermal shutdown, powering-off");
 			twl6040_power(twl6040, 0);
 		} else {
-			dev_warn(&twl6040_dev->dev,
+			dev_warn(twl6040->dev,
 				 "Leaving thermal shutdown, powering-on");
 			twl6040_power(twl6040, 1);
 		}
@@ -227,7 +225,7 @@ static int twl6040_power_up_completion(struct twl6040 *twl6040,
 	if (!time_left) {
 		intid = twl6040_reg_read(twl6040, TWL6040_REG_INTID);
 		if (!(intid & TWL6040_READYINT)) {
-			dev_err(&twl6040_dev->dev,
+			dev_err(twl6040->dev,
 				"timeout waiting for READYINT\n");
 			return -ETIMEDOUT;
 		}
@@ -255,7 +253,7 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 			/* wait for power-up completion */
 			ret = twl6040_power_up_completion(twl6040, naudint);
 			if (ret) {
-				dev_err(&twl6040_dev->dev,
+				dev_err(twl6040->dev,
 					"automatic power-down failed\n");
 				twl6040->power_count = 0;
 				goto out;
@@ -264,7 +262,7 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 			/* use manual power-up sequence */
 			ret = twl6040_power_up(twl6040);
 			if (ret) {
-				dev_err(&twl6040_dev->dev,
+				dev_err(twl6040->dev,
 					"manual power-up failed\n");
 				twl6040->power_count = 0;
 				goto out;
@@ -276,7 +274,7 @@ int twl6040_power(struct twl6040 *twl6040, int on)
 	} else {
 		/* already powered-down */
 		if (!twl6040->power_count) {
-			dev_err(&twl6040_dev->dev,
+			dev_err(twl6040->dev,
 				"device is already powered-off\n");
 			ret = -EPERM;
 			goto out;
@@ -326,7 +324,7 @@ int twl6040_set_pll(struct twl6040 *twl6040, int pll_id,
 			lppllctl &= ~TWL6040_LPLLFIN;
 			break;
 		default:
-			dev_err(&twl6040_dev->dev,
+			dev_err(twl6040->dev,
 				"freq_out %d not supported\n", freq_out);
 			ret = -EINVAL;
 			goto pll_out;
@@ -347,7 +345,7 @@ int twl6040_set_pll(struct twl6040 *twl6040, int pll_id,
 					  hppllctl);
 			break;
 		default:
-			dev_err(&twl6040_dev->dev,
+			dev_err(twl6040->dev,
 				"freq_in %d not supported\n", freq_in);
 			ret = -EINVAL;
 			goto pll_out;
@@ -356,7 +354,7 @@ int twl6040_set_pll(struct twl6040 *twl6040, int pll_id,
 	case TWL6040_SYSCLK_SEL_HPPLL:
 		/* high-performance PLL can provide only 19.2 MHz */
 		if (freq_out != 19200000) {
-			dev_err(&twl6040_dev->dev,
+			dev_err(twl6040->dev,
 				"freq_out %d not supported\n", freq_out);
 			ret = -EINVAL;
 			goto pll_out;
@@ -389,7 +387,7 @@ int twl6040_set_pll(struct twl6040 *twl6040, int pll_id,
 				    TWL6040_HPLLENA;
 			break;
 		default:
-			dev_err(&twl6040_dev->dev,
+			dev_err(twl6040->dev,
 				"freq_in %d not supported\n", freq_in);
 			ret = -EINVAL;
 			goto pll_out;
@@ -406,7 +404,7 @@ int twl6040_set_pll(struct twl6040 *twl6040, int pll_id,
 		twl6040_reg_write(twl6040, TWL6040_REG_LPPLLCTL, lppllctl);
 		break;
 	default:
-		dev_err(&twl6040_dev->dev, "unknown pll id %d\n", pll_id);
+		dev_err(twl6040->dev, "unknown pll id %d\n", pll_id);
 		ret = -EINVAL;
 		goto pll_out;
 	}
@@ -471,7 +469,6 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, twl6040);
 
-	twl6040_dev = pdev;
 	twl6040->dev = &pdev->dev;
 	twl6040->audpwron = pdata->audpwron_gpio;
 	twl6040->irq = pdata->naudint_irq;
@@ -566,7 +563,6 @@ gpio2_err:
 gpio1_err:
 	platform_set_drvdata(pdev, NULL);
 	kfree(twl6040);
-	twl6040_dev = NULL;
 	return ret;
 }
 
@@ -586,7 +582,6 @@ static int __devexit twl6040_remove(struct platform_device *pdev)
 	mfd_remove_devices(&pdev->dev);
 	platform_set_drvdata(pdev, NULL);
 	kfree(twl6040);
-	twl6040_dev = NULL;
 
 	return 0;
 }
-- 
1.7.6.1

