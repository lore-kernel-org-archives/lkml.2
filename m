Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1EGVDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 17:03:19 -0400
Received: from mail.df.lth.se ([194.47.250.12]:16230 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1EGVCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 17:02:45 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 May 2011 17:02:45 EDT
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/3] mfd/ab8500-gpadc: Added manual batt temp activation for AB8500 3.0
Date: Sun,  8 May 2011 00:55:31 +0200
Message-Id: <1304808931-12737-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karl Komierowski <karl.komierowski@stericsson.com>

In AB8500 3.0 the pull-up supplying the NTC must be manually activated.
Add enumerators to chip version detection logic.

Signed-off-by: Kalle Komierowski <karl.komierowski@stericsson.com>
Reviewed-by: Johan Palsson <johan.palsson@stericsson.com>
Reviewed-by: Daniel Willerud <daniel.willerud@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 6421ad1..82708c1 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -57,6 +57,7 @@
 #define SW_AVG_16			0x60
 #define ADC_SW_CONV			0x04
 #define EN_ICHAR			0x80
+#define BATTEMP_PULLUP			0x04
 #define EN_BUF				0x40
 #define DIS_ZERO			0x00
 #define GPADC_BUSY			0x01
@@ -101,6 +102,7 @@ struct adc_cal_data {
 
 /**
  * struct ab8500_gpadc - AB8500 GPADC device information
+ * @chip_id			ABB chip id
  * @dev:			pointer to the struct device
  * @node:			a list of AB8500 GPADCs, hence prepared for
 				reentrance
@@ -112,6 +114,7 @@ struct adc_cal_data {
  * @cal_data			array of ADC calibration data structs
  */
 struct ab8500_gpadc {
+	u8 chip_id;
 	struct device *dev;
 	struct list_head node;
 	struct completion ab8500_gpadc_complete;
@@ -274,6 +277,7 @@ int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 		dev_err(gpadc->dev, "gpadc_conversion: enable gpadc failed\n");
 		goto out;
 	}
+
 	/* Select the input source and set average samples to 16 */
 	ret = abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_CTRL2_REG, (input | SW_AVG_16));
@@ -282,9 +286,11 @@ int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 			"gpadc_conversion: set avg samples failed\n");
 		goto out;
 	}
+
 	/*
 	 * Enable ADC, buffering, select rising edge and enable ADC path
-	 * charging current sense if it needed
+	 * charging current sense if it needed, ABB 3.0 needs some special
+	 * treatment too.
 	 */
 	switch (input) {
 	case MAIN_CHARGER_C:
@@ -294,6 +300,23 @@ int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 			EN_BUF | EN_ICHAR,
 			EN_BUF | EN_ICHAR);
 		break;
+	case BTEMP_BALL:
+		if (gpadc->chip_id >= AB8500_CUT3P0) {
+			/* Turn on btemp pull-up on ABB 3.0 */
+			ret = abx500_mask_and_set_register_interruptible(
+				gpadc->dev,
+				AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+				EN_BUF | BATTEMP_PULLUP,
+				EN_BUF | BATTEMP_PULLUP);
+
+		 /*
+		  * Delay might be needed for ABB8500 cut 3.0, if not, remove
+		  * when hardware will be availible
+		  */
+			msleep(1);
+			break;
+		}
+		/* Intentional fallthrough */
 	default:
 		ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
 			AB8500_GPADC, AB8500_GPADC_CTRL1_REG, EN_BUF, EN_BUF);
@@ -304,6 +327,7 @@ int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 			"gpadc_conversion: select falling edge failed\n");
 		goto out;
 	}
+
 	ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
 		AB8500_GPADC, AB8500_GPADC_CTRL1_REG, ADC_SW_CONV, ADC_SW_CONV);
 	if (ret < 0) {
@@ -552,6 +576,14 @@ static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
 		goto fail;
 	}
 
+	/* Get Chip ID of the ABB ASIC  */
+	ret = abx500_get_chip_id(gpadc->dev);
+	if (ret < 0) {
+		dev_err(gpadc->dev, "failed to get chip ID\n");
+		goto fail_irq;
+	}
+	gpadc->chip_id = (u8) ret;
+
 	/* VTVout LDO used to power up ab8500-GPADC */
 	gpadc->regu = regulator_get(&pdev->dev, "vddadc");
 	if (IS_ERR(gpadc->regu)) {
-- 
1.7.5

