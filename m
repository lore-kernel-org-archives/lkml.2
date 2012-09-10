Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab2IJKqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:46:20 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:60789 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757105Ab2IJKqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:46:15 -0400
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
Subject: [PATCH v4 02/14] MFD: twl4030-audio: Convert to use devm_kzalloc
Date: Mon, 10 Sep 2012 13:46:20 +0300
Message-Id: <1347273992-9107-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To clean up the module probe and remove functions.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-audio.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index ac04b4f..efa2d42 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -188,7 +188,8 @@ static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 	twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
 					val, TWL4030_REG_APLL_CTL);
 
-	audio = kzalloc(sizeof(struct twl4030_audio), GFP_KERNEL);
+	audio = devm_kzalloc(&pdev->dev, sizeof(struct twl4030_audio),
+			     GFP_KERNEL);
 	if (!audio)
 		return -ENOMEM;
 
@@ -229,22 +230,18 @@ static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 	}
 
-	if (!ret)
-		return 0;
+	if (ret) {
+		platform_set_drvdata(pdev, NULL);
+		twl4030_audio_dev = NULL;
+	}
 
-	platform_set_drvdata(pdev, NULL);
-	kfree(audio);
-	twl4030_audio_dev = NULL;
 	return ret;
 }
 
 static int __devexit twl4030_audio_remove(struct platform_device *pdev)
 {
-	struct twl4030_audio *audio = platform_get_drvdata(pdev);
-
 	mfd_remove_devices(&pdev->dev);
 	platform_set_drvdata(pdev, NULL);
-	kfree(audio);
 	twl4030_audio_dev = NULL;
 
 	return 0;
-- 
1.7.12

