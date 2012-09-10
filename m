Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2IJKq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:46:27 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:39906 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757150Ab2IJKqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:46:20 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/14] MFD: twl4030-audio: Rearange and clean-up the probe function
Date: Mon, 10 Sep 2012 13:46:21 +0300
Message-Id: <1347273992-9107-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To facilitate the device tree support the probe function need to be rearanged.
Small cleanup in the APLL frequency selection part as well.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-audio.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index efa2d42..ca2d669 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -169,35 +169,30 @@ static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	audio = devm_kzalloc(&pdev->dev, sizeof(struct twl4030_audio),
+			     GFP_KERNEL);
+	if (!audio)
+		return -ENOMEM;
+
+	mutex_init(&audio->mutex);
+	audio->audio_mclk = pdata->audio_mclk;
+
 	/* Configure APLL_INFREQ and disable APLL if enabled */
-	val = 0;
-	switch (pdata->audio_mclk) {
+	switch (audio->audio_mclk) {
 	case 19200000:
-		val |= TWL4030_APLL_INFREQ_19200KHZ;
+		val = TWL4030_APLL_INFREQ_19200KHZ;
 		break;
 	case 26000000:
-		val |= TWL4030_APLL_INFREQ_26000KHZ;
+		val = TWL4030_APLL_INFREQ_26000KHZ;
 		break;
 	case 38400000:
-		val |= TWL4030_APLL_INFREQ_38400KHZ;
+		val = TWL4030_APLL_INFREQ_38400KHZ;
 		break;
 	default:
 		dev_err(&pdev->dev, "Invalid audio_mclk\n");
 		return -EINVAL;
 	}
-	twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
-					val, TWL4030_REG_APLL_CTL);
-
-	audio = devm_kzalloc(&pdev->dev, sizeof(struct twl4030_audio),
-			     GFP_KERNEL);
-	if (!audio)
-		return -ENOMEM;
-
-	platform_set_drvdata(pdev, audio);
-
-	twl4030_audio_dev = pdev;
-	mutex_init(&audio->mutex);
-	audio->audio_mclk = pdata->audio_mclk;
+	twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE, val, TWL4030_REG_APLL_CTL);
 
 	/* Codec power */
 	audio->resource[TWL4030_AUDIO_RES_POWER].reg = TWL4030_REG_CODEC_MODE;
@@ -222,6 +217,9 @@ static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 		childs++;
 	}
 
+	platform_set_drvdata(pdev, audio);
+	twl4030_audio_dev = pdev;
+
 	if (childs)
 		ret = mfd_add_devices(&pdev->dev, pdev->id, audio->cells,
 				      childs, NULL, 0);
-- 
1.7.12

