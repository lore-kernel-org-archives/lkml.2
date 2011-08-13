Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1HMGca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 02:32:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34714 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751121Ab1HMGc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 02:32:28 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Add more checks for WM8994 being active during suspend
Date: Sat, 13 Aug 2011 14:37:48 +0900
Message-Id: <1313213868-14824-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhancements to the WM8994 audio driver and new features on more modern
devices in the series mean that we can no longer rely on VMID being active
as an indication that the device is active. Add further checks for digital
paths and microphone detection.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 5690102..5d6ba13 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -217,6 +217,40 @@ static int wm8994_suspend(struct device *dev)
 		return 0;
 	}
 
+	ret = wm8994_reg_read(wm8994, WM8994_POWER_MANAGEMENT_4);
+	if (ret < 0) {
+		dev_err(dev, "Failed to read power status: %d\n", ret);
+	} else if (ret & (WM8994_AIF2ADCL_ENA | WM8994_AIF2ADCR_ENA |
+			  WM8994_AIF1ADC2L_ENA | WM8994_AIF1ADC2R_ENA |
+			  WM8994_AIF1ADC1L_ENA | WM8994_AIF1ADC1R_ENA)) {
+		dev_dbg(dev, "CODEC still active, ignoring suspend\n");
+		return 0;
+	}
+
+	ret = wm8994_reg_read(wm8994, WM8994_POWER_MANAGEMENT_5);
+	if (ret < 0) {
+		dev_err(dev, "Failed to read power status: %d\n", ret);
+	} else if (ret & (WM8994_AIF2DACL_ENA | WM8994_AIF2DACR_ENA |
+			  WM8994_AIF1DAC2L_ENA | WM8994_AIF1DAC2R_ENA |
+			  WM8994_AIF1DAC1L_ENA | WM8994_AIF1DAC1R_ENA)) {
+		dev_dbg(dev, "CODEC still active, ignoring suspend\n");
+		return 0;
+	}
+
+	switch (wm8994->type) {
+	case WM8958:
+		ret = wm8994_reg_read(wm8994, WM8958_MIC_DETECT_1);
+		if (ret < 0) {
+			dev_err(dev, "Failed to read power status: %d\n", ret);
+		} else if (ret & WM8958_MICD_ENA) {
+			dev_dbg(dev, "CODEC still active, ignoring suspend\n");
+			return 0;
+		}
+		break;
+	default:
+		break;
+	}
+
 	/* Disable LDO pulldowns while the device is suspended if we
 	 * don't know that something will be driving them. */
 	if (!wm8994->ldo_ena_always_driven)
-- 
1.7.5.4

