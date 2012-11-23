Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2KWNFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 08:05:51 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46913 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2KWNFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 08:05:50 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ola LILJA2 <ola.o.lilja@stericsson.com>, alsa-devel@alsa-project.org
Subject: [PATCH 1/1] ASoC: Ux500: Initialise PCM from MSP probe rather than as a device
Date: Fri, 23 Nov 2012 13:05:41 +0000
Message-Id: <1353675941-7303-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCM is a pseudo-device. It doesn't have any of it's own registers
or hardware. It rather acts as a layer of abstraction for DMA
transfers. Hence, instead of classifying it as a device in its own
right, we call the initialisation from the MSP driver.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ola LILJA2 <ola.o.lilja@stericsson.com>
Cc: alsa-devel@alsa-project.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/mop500.c        |    4 ++--
 sound/soc/ux500/ux500_msp_dai.c |   14 +++++++++++++-
 sound/soc/ux500/ux500_pcm.c     |   19 ++++---------------
 sound/soc/ux500/ux500_pcm.h     |    3 +++
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 54f7e25..651a52a 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -33,7 +33,7 @@ struct snd_soc_dai_link mop500_dai_links[] = {
 		.stream_name = "ab8500_0",
 		.cpu_dai_name = "ux500-msp-i2s.1",
 		.codec_dai_name = "ab8500-codec-dai.0",
-		.platform_name = "ux500-pcm.0",
+		.platform_name = "ux500-msp-i2s.1",
 		.codec_name = "ab8500-codec.0",
 		.init = mop500_ab8500_machine_init,
 		.ops = mop500_ab8500_ops,
@@ -43,7 +43,7 @@ struct snd_soc_dai_link mop500_dai_links[] = {
 		.stream_name = "ab8500_1",
 		.cpu_dai_name = "ux500-msp-i2s.3",
 		.codec_dai_name = "ab8500-codec-dai.1",
-		.platform_name = "ux500-pcm.0",
+		.platform_name = "ux500-msp-i2s.3",
 		.codec_name = "ab8500-codec.0",
 		.init = NULL,
 		.ops = mop500_ab8500_ops,
diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index be94bf9..66ca889 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -28,6 +28,7 @@
 
 #include "ux500_msp_i2s.h"
 #include "ux500_msp_dai.h"
+#include "ux500_pcm.h"
 
 static int setup_pcm_multichan(struct snd_soc_dai *dai,
 			struct ux500_msp_config *msp_config)
@@ -806,11 +807,20 @@ static int __devinit ux500_msp_drv_probe(struct platform_device *pdev)
 		goto err_init_msp;
 	}
 
+	ret = ux500_pcm_register_platform(pdev);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Error: %s: Failed to register PCM platform device!\n",
+			__func__);
+		goto err_reg_plat;
+	}
+
 	return 0;
 
+err_reg_plat:
+	snd_soc_unregister_dais(&pdev->dev, ARRAY_SIZE(ux500_msp_dai_drv));
 err_init_msp:
 	clk_put(drvdata->clk);
-
 err_clk:
 	devm_regulator_put(drvdata->reg_vape);
 
@@ -821,6 +831,8 @@ static int __devexit ux500_msp_drv_remove(struct platform_device *pdev)
 {
 	struct ux500_msp_i2s_drvdata *drvdata = dev_get_drvdata(&pdev->dev);
 
+	ux500_pcm_unregister_platform(pdev);
+
 	snd_soc_unregister_dais(&pdev->dev, ARRAY_SIZE(ux500_msp_dai_drv));
 
 	devm_regulator_put(drvdata->reg_vape);
diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index 1a04e24..894c9f4 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -282,7 +282,7 @@ static struct snd_soc_platform_driver ux500_pcm_soc_drv = {
 	.pcm_new        = ux500_pcm_new,
 };
 
-static int __devexit ux500_pcm_drv_probe(struct platform_device *pdev)
+int __devinit ux500_pcm_register_platform(struct platform_device *pdev)
 {
 	int ret;
 
@@ -296,23 +296,12 @@ static int __devexit ux500_pcm_drv_probe(struct platform_device *pdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ux500_pcm_register_platform);
 
-static int __devinit ux500_pcm_drv_remove(struct platform_device *pdev)
+int __devexit ux500_pcm_unregister_platform(struct platform_device *pdev)
 {
 	snd_soc_unregister_platform(&pdev->dev);
 
 	return 0;
 }
-
-static struct platform_driver ux500_pcm_driver = {
-	.driver = {
-		.name = "ux500-pcm",
-		.owner = THIS_MODULE,
-	},
-
-	.probe = ux500_pcm_drv_probe,
-	.remove = __devexit_p(ux500_pcm_drv_remove),
-};
-module_platform_driver(ux500_pcm_driver);
-
-MODULE_LICENSE("GPL v2");
+EXPORT_SYMBOL_GPL(ux500_pcm_unregister_platform);
diff --git a/sound/soc/ux500/ux500_pcm.h b/sound/soc/ux500/ux500_pcm.h
index 77ed44d..76d3444 100644
--- a/sound/soc/ux500/ux500_pcm.h
+++ b/sound/soc/ux500/ux500_pcm.h
@@ -32,4 +32,7 @@
 #define UX500_PLATFORM_PERIODS_MAX		48
 #define UX500_PLATFORM_BUFFER_BYTES_MAX		(2048 * PAGE_SIZE)
 
+int ux500_pcm_register_platform(struct platform_device *pdev);
+int ux500_pcm_unregister_platform(struct platform_device *pdev);
+
 #endif
-- 
1.7.9.5

