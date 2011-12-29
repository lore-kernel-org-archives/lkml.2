Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1L2QxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:53:12 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60221 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab1L2Qvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:51:42 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 4/10] sound/soc/au1x/i2sc.c: use devm_ functions
Date: Thu, 29 Dec 2011 17:51:26 +0100
Message-Id: <1325177489-13815-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1325177489-13815-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1325177489-13815-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia.lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses devm_kzalloc, devm_request_mem_region and
devm_ioremap for data that is allocated in the probe function of a platform
device and is only freed in the remove function.

Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>

---
 sound/soc/au1x/i2sc.c |   45 +++++++++++++--------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff --git a/sound/soc/au1x/i2sc.c b/sound/soc/au1x/i2sc.c
index cb53ad8..d4b9e36 100644
--- a/sound/soc/au1x/i2sc.c
+++ b/sound/soc/au1x/i2sc.c
@@ -227,69 +227,50 @@ static struct snd_soc_dai_driver au1xi2s_dai_driver = {
 
 static int __devinit au1xi2s_drvprobe(struct platform_device *pdev)
 {
-	int ret;
 	struct resource *iores, *dmares;
 	struct au1xpsc_audio_data *ctx;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!iores) {
-		ret = -ENODEV;
-		goto out0;
-	}
+	if (!iores)
+		return -ENODEV;
 
-	ret = -EBUSY;
-	if (!request_mem_region(iores->start, resource_size(iores),
-				pdev->name))
-		goto out0;
+	if (!devm_request_mem_region(&pdev->dev, iores->start,
+				     resource_size(iores),
+				     pdev->name))
+		return -EBUSY;
 
-	ctx->mmio = ioremap_nocache(iores->start, resource_size(iores));
+	ctx->mmio = devm_ioremap_nocache(&pdev->dev, iores->start,
+					 resource_size(iores));
 	if (!ctx->mmio)
-		goto out1;
+		return -EBUSY;
 
 	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (!dmares)
-		goto out2;
+		return -EBUSY;
 	ctx->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = dmares->start;
 
 	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 1);
 	if (!dmares)
-		goto out2;
+		return -EBUSY;
 	ctx->dmaids[SNDRV_PCM_STREAM_CAPTURE] = dmares->start;
 
 	platform_set_drvdata(pdev, ctx);
 
-	ret = snd_soc_register_dai(&pdev->dev, &au1xi2s_dai_driver);
-	if (ret)
-		goto out2;
-
-	return 0;
-
-out2:
-	iounmap(ctx->mmio);
-out1:
-	release_mem_region(iores->start, resource_size(iores));
-out0:
-	kfree(ctx);
-	return ret;
+	return snd_soc_register_dai(&pdev->dev, &au1xi2s_dai_driver);
 }
 
 static int __devexit au1xi2s_drvremove(struct platform_device *pdev)
 {
 	struct au1xpsc_audio_data *ctx = platform_get_drvdata(pdev);
-	struct resource *r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	snd_soc_unregister_dai(&pdev->dev);
 
 	WR(ctx, I2S_ENABLE, EN_D);	/* clock off, disable */
 
-	iounmap(ctx->mmio);
-	release_mem_region(r->start, resource_size(r));
-	kfree(ctx);
-
 	return 0;
 }
 

