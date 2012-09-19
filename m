Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2ISNeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:34:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41835 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2ISNd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:33:57 -0400
Date: Wed, 19 Sep 2012 15:33:45 +0200
From: Lee Jones <lee.jones@linaro.org>
To: Ola LILJA2 <ola.o.lilja@stericsson.com>
Cc: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com,
        STEricsson_nomadik_linux@list.st.com
Subject: [RESENDING] [PATCH 07/22] ASoC: Ux500: Initialise PCM from MSP probe
 rather than as a device
Message-ID: <20120919133343.GH25694@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-8-git-send-email-lee.jones@linaro.org>
 <CACRpkdbc6bGC4Yp7Bcdfev=Uc=1h4L1v+Lj9RbmJV3F+knQOZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbc6bGC4Yp7Bcdfev=Uc=1h4L1v+Lj9RbmJV3F+knQOZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ola,

As requested:

Author: Lee Jones <lee.jones@linaro.org>
Date:   Tue Jul 31 14:06:19 2012 +0100

    ASoC: Ux500: Initialise PCM from MSP probe rather than as a device
    
    The PCM is a pseudo-device. It doesn't have any of it's own registers
    or hardware. It rather acts as a layer of abstraction for DMA
    transfers. Hence, instead of classifying it as a device in its own
    right, we call the initialisation from the MSP driver.
    
    Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/sound/soc/ux500/mop500.c b/sound/soc/ux500/mop500.c
index 31c4d26..9707f4a 100644
--- a/sound/soc/ux500/mop500.c
+++ b/sound/soc/ux500/mop500.c
@@ -32,7 +32,7 @@ struct snd_soc_dai_link mop500_dai_links[] = {
 		.stream_name = "ab8500_0",
 		.cpu_dai_name = "ux500-msp-i2s.1",
 		.codec_dai_name = "ab8500-codec-dai.0",
-		.platform_name = "ux500-pcm.0",
+		.platform_name = "ux500-msp-i2s.1",
 		.codec_name = "ab8500-codec.0",
 		.init = mop500_ab8500_machine_init,
 		.ops = mop500_ab8500_ops,
@@ -42,7 +42,7 @@ struct snd_soc_dai_link mop500_dai_links[] = {
 		.stream_name = "ab8500_1",
 		.cpu_dai_name = "ux500-msp-i2s.3",
 		.codec_dai_name = "ab8500-codec-dai.1",
-		.platform_name = "ux500-pcm.0",
+		.platform_name = "ux500-msp-i2s.3",
 		.codec_name = "ab8500-codec.0",
 		.init = NULL,
 		.ops = mop500_ab8500_ops,
diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index 772cb19..6afab6c 100644
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
