Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1CEKs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:48:59 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:58995 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458Ab1CEKs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:48:58 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/5] mfd: fix ab8500-gpadc to measure charger current
Date: Sat, 5 Mar 2011 11:46:45 +0100
Message-ID: <1299322005-6898-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karl Komierowski <karl.komierowski@stericsson.com>

The GPADC in the AB8500 was incorrectly configured when a charger
current channel was selected.

Signed-off-by: Karl Komierowski <karl.komierowski@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index a70201a..2ad3115 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -56,6 +56,7 @@
 #define DIS_GPADC			0x00
 #define SW_AVG_16			0x60
 #define ADC_SW_CONV			0x04
+#define EN_ICHAR			0x80
 #define EN_BUF				0x40
 #define DIS_ZERO			0x00
 #define GPADC_BUSY			0x01
@@ -281,9 +282,23 @@ int ab8500_gpadc_convert(struct ab8500_gpadc *gpadc, u8 input)
 			"gpadc_conversion: set avg samples failed\n");
 		goto out;
 	}
-	/* Enable ADC, Buffering and select rising edge, start Conversion */
-	ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
-		AB8500_GPADC, AB8500_GPADC_CTRL1_REG, EN_BUF, EN_BUF);
+	/*
+	 * Enable ADC, buffering, select rising edge and enable ADC path
+	 * charging current sense if it needed
+	 */
+	switch (input) {
+	case MAIN_CHARGER_C:
+	case USB_CHARGER_C:
+		ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
+			AB8500_GPADC, AB8500_GPADC_CTRL1_REG,
+			EN_BUF | EN_ICHAR,
+			EN_BUF | EN_ICHAR);
+		break;
+	default:
+		ret = abx500_mask_and_set_register_interruptible(gpadc->dev,
+			AB8500_GPADC, AB8500_GPADC_CTRL1_REG, EN_BUF, EN_BUF);
+		break;
+	}
 	if (ret < 0) {
 		dev_err(gpadc->dev,
 			"gpadc_conversion: select falling edge failed\n");
-- 
1.7.3.2

