Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2GaNjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:39:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33375 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab2GaNj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:39:29 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/19] ASoC: Ux500: Initialise PCM from MSP probe rather than as a device
Date: Tue, 31 Jul 2012 14:38:58 +0100
Message-Id: <1343741953-17828-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCM is a pseudo-device. It doesn't have any of it's own registers
or hardware. It rather acts as a layer of abstraction for DMA
transfers. Hence, instead of classifying it as a device in its own
right, we call the initialisation from the MSP driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/ux500/mop500.c        |    4 ++--
 sound/soc/ux500/ux500_msp_dai.c |   14 +++++++++++++-
 sound/soc/ux500/ux500_pcm.c     |   19 ++++---------------
 sound/soc/ux500/ux500_pcm.h     |    3 +++
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 821f2a9..69bd69a 100644
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
index 0f7dd49..3476d6a 100644
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

