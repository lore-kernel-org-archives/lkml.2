Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab1IOMko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:40:44 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:53580 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933506Ab1IOMkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:18 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 04/17] MFD: twl6040: Fix power on GPIO handling
Date: Thu, 15 Sep 2011 15:39:26 +0300
Message-Id: <1316090379-30760-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid requesting the audpwron gpio in case of ES1.0
revision.
In the past we requested the gpio, but we did not
free it up, since we made the check for the revision
later. This results later checks for gpio validity to
fail, leaving the gpio reserved (even after the driver
has been removed).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040-core.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 51c3b47..7dc8c47 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -470,7 +470,6 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, twl6040);
 
 	twl6040->dev = &pdev->dev;
-	twl6040->audpwron = pdata->audpwron_gpio;
 	twl6040->irq = pdata->naudint_irq;
 	twl6040->irq_base = pdata->irq_base;
 
@@ -480,6 +479,12 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 
 	twl6040->rev = twl6040_reg_read(twl6040, TWL6040_REG_ASICREV);
 
+	/* ERRATA: Automatic power-up is not possible in ES1.0 */
+	if (twl6040_get_revid(twl6040) > TWL6040_REV_ES1_0)
+		twl6040->audpwron = pdata->audpwron_gpio;
+	else
+		twl6040->audpwron = -EINVAL;
+
 	if (gpio_is_valid(twl6040->audpwron)) {
 		ret = gpio_request(twl6040->audpwron, "audpwron");
 		if (ret)
@@ -490,10 +495,6 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 			goto gpio2_err;
 	}
 
-	/* ERRATA: Automatic power-up is not possible in ES1.0 */
-	if (twl6040_get_revid(twl6040) == TWL6040_REV_ES1_0)
-		twl6040->audpwron = -EINVAL;
-
 	/* codec interrupt */
 	ret = twl6040_irq_init(twl6040);
 	if (ret)
-- 
1.7.6.1

