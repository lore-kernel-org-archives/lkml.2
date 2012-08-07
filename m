Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2HGS55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:57:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37286 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab2HGS54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:57:56 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Disable control interface error reporting for early devices
Date: Tue,  7 Aug 2012 19:57:53 +0100
Message-Id: <1344365873-13457-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early revisions of the initial Arizona-based devices can generate spurious
control interface errors in certain circumstances. Avoid causing confusion
by disabling the control interface error reporting on these devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |   35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 98ac345..64940c6 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -156,18 +156,35 @@ int arizona_irq_init(struct arizona *arizona)
 	int flags = IRQF_ONESHOT;
 	int ret, i;
 	const struct regmap_irq_chip *aod, *irq;
+	bool ctrlif_error = true;
 
 	switch (arizona->type) {
 #ifdef CONFIG_MFD_WM5102
 	case WM5102:
 		aod = &wm5102_aod;
 		irq = &wm5102_irq;
+
+		switch (arizona->rev) {
+		case 0:
+			ctrlif_error = false;
+			break;
+		default:
+			break;
+		}
 		break;
 #endif
 #ifdef CONFIG_MFD_WM5110
 	case WM5110:
 		aod = &wm5110_aod;
 		irq = &wm5110_irq;
+
+		switch (arizona->rev) {
+		case 0:
+			ctrlif_error = false;
+			break;
+		default:
+			break;
+		}
 		break;
 #endif
 	default:
@@ -226,13 +243,17 @@ int arizona_irq_init(struct arizona *arizona)
 	}
 
 	/* Handle control interface errors in the core */
-	i = arizona_map_irq(arizona, ARIZONA_IRQ_CTRLIF_ERR);
-	ret = request_threaded_irq(i, NULL, arizona_ctrlif_err, IRQF_ONESHOT,
-				   "Control interface error", arizona);
-	if (ret != 0) {
-		dev_err(arizona->dev, "Failed to request boot done %d: %d\n",
-			arizona->irq, ret);
-		goto err_ctrlif;
+	if (ctrlif_error) {
+		i = arizona_map_irq(arizona, ARIZONA_IRQ_CTRLIF_ERR);
+		ret = request_threaded_irq(i, NULL, arizona_ctrlif_err,
+					   IRQF_ONESHOT,
+					   "Control interface error", arizona);
+		if (ret != 0) {
+			dev_err(arizona->dev,
+				"Failed to request CTRLIF_ERR %d: %d\n",
+				arizona->irq, ret);
+			goto err_ctrlif;
+		}
 	}
 
 	ret = request_threaded_irq(arizona->irq, NULL, arizona_irq_thread,
-- 
1.7.10.4

