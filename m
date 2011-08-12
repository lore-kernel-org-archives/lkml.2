Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1HLBqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 21:46:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39653 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750741Ab1HLBqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 21:46:31 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Allow WM8994 LDO enable pulls to be disabled
Date: Fri, 12 Aug 2011 10:18:20 +0900
Message-Id: <1313111900-9166-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In systems where the LDO enables are always driven (for example, being
connected to an always on supply rail or a GPIO which is driven by the
CPU even in suspend) then we can disable the pull downs on the LDO for
a small power savings.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c        |   19 +++++++++++++++++++
 include/linux/mfd/wm8994/core.h  |    2 ++
 include/linux/mfd/wm8994/pdata.h |    7 +++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index b03be1d..5690102 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -217,6 +217,13 @@ static int wm8994_suspend(struct device *dev)
 		return 0;
 	}
 
+	/* Disable LDO pulldowns while the device is suspended if we
+	 * don't know that something will be driving them. */
+	if (!wm8994->ldo_ena_always_driven)
+		wm8994_set_bits(wm8994, WM8994_PULL_CONTROL_2,
+				WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD,
+				WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD);
+
 	/* GPIO configuration state is saved here since we may be configuring
 	 * the GPIO alternate functions even if we're not using the gpiolib
 	 * driver for them.
@@ -286,6 +293,11 @@ static int wm8994_resume(struct device *dev)
 	if (ret < 0)
 		dev_err(dev, "Failed to restore GPIO registers: %d\n", ret);
 
+	/* Disable LDO pulldowns while the device is active */
+	wm8994_set_bits(wm8994, WM8994_PULL_CONTROL_2,
+			WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD,
+			0);
+
 	wm8994->suspended = false;
 
 	return 0;
@@ -467,8 +479,15 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 						pdata->gpio_defaults[i]);
 			}
 		}
+
+		wm8994->ldo_ena_always_driven = pdata->ldo_ena_always_driven;
 	}
 
+	/* Disable LDO pulldowns while the device is active */
+	wm8994_set_bits(wm8994, WM8994_PULL_CONTROL_2,
+			WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD,
+			0);
+
 	/* In some system designs where the regulators are not in use,
 	 * we can achieve a small reduction in leakage currents by
 	 * floating LDO outputs.  This bit makes no difference if the
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index 6268091..f44bdb7 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -59,6 +59,8 @@ struct wm8994 {
 	struct device *dev;
 	struct regmap *regmap;
 
+	bool ldo_ena_always_driven;
+
 	int gpio_base;
 	int irq_base;
 
diff --git a/include/linux/mfd/wm8994/pdata.h b/include/linux/mfd/wm8994/pdata.h
index 97cf4f2..ea32f30 100644
--- a/include/linux/mfd/wm8994/pdata.h
+++ b/include/linux/mfd/wm8994/pdata.h
@@ -167,6 +167,13 @@ struct wm8994_pdata {
 
 	/* WM8958 microphone bias configuration */
 	int micbias[2];
+
+	/* Disable the internal pull downs on the LDOs if they are
+	 * always driven (eg, connected to an always on supply or
+	 * GPIO that always drives an output.  If they float power
+	 * consumption will rise.
+	 */
+	bool ldo_ena_always_driven;
 };
 
 #endif
-- 
1.7.5.4

