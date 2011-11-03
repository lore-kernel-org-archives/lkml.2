Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1KCNlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:41:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51293 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040Ab1KCNlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:41:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Disable more pulls on WM8994
Date: Thu,  3 Nov 2011 13:41:14 +0000
Message-Id: <1320327674-23116-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable more pulls by default on WM8994 for a small current saving. Since
some designs do leave SPKMODE floating provide platform data to allow that
to be left enabled.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c        |   11 ++++++++---
 include/linux/mfd/wm8994/pdata.h |    6 ++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 772027d..fe7f071 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -337,6 +337,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
 	const char *devname;
 	int ret, i;
+	int pulls = 0;
 
 	dev_set_drvdata(wm8994->dev, wm8994);
 
@@ -479,12 +480,16 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		}
 
 		wm8994->ldo_ena_always_driven = pdata->ldo_ena_always_driven;
+
+		if (pdata->spkmode_pu)
+			pulls |= WM8994_SPKMODE_PU;
 	}
 
-	/* Disable LDO pulldowns while the device is active */
+	/* Disable unneeded pulls */
 	wm8994_set_bits(wm8994, WM8994_PULL_CONTROL_2,
-			WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD,
-			0);
+			WM8994_LDO1ENA_PD | WM8994_LDO2ENA_PD |
+			WM8994_SPKMODE_PU | WM8994_CSNADDR_PD,
+			pulls);
 
 	/* In some system designs where the regulators are not in use,
 	 * we can achieve a small reduction in leakage currents by
diff --git a/include/linux/mfd/wm8994/pdata.h b/include/linux/mfd/wm8994/pdata.h
index ea32f30..54e2fef 100644
--- a/include/linux/mfd/wm8994/pdata.h
+++ b/include/linux/mfd/wm8994/pdata.h
@@ -174,6 +174,12 @@ struct wm8994_pdata {
 	 * consumption will rise.
 	 */
 	bool ldo_ena_always_driven;
+
+	/*
+	 * SPKMODE must be pulled internally by the device on this
+	 * system.
+	 */
+	bool spkmode_pu;
 };
 
 #endif
-- 
1.7.7.1

