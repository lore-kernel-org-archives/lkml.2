Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1L2Qvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:51:41 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60164 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab1L2Qvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:51:38 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 8/10] sound/soc/davinci/davinci-i2s.c: use devm_ functions
Date: Thu, 29 Dec 2011 17:51:22 +0100
Message-Id: <1325177489-13815-4-git-send-email-Julia.Lawall@lip6.fr>
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

In this case, the original code did not contain a call to iounmap, nor does
one appear anywhere else in the file.  I have assumed that it is safe to
use devm_ioremap for the allocation in any case.

Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>

---
 sound/soc/davinci/davinci-i2s.c |   39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2s.c
index ec18710..0a74b95 100644
--- a/sound/soc/davinci/davinci-i2s.c
+++ b/sound/soc/davinci/davinci-i2s.c
@@ -661,18 +661,18 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	ioarea = request_mem_region(mem->start, resource_size(mem),
-				    pdev->name);
+	ioarea = devm_request_mem_region(&pdev->dev, mem->start,
+					 resource_size(mem),
+					 pdev->name);
 	if (!ioarea) {
 		dev_err(&pdev->dev, "McBSP region already claimed\n");
 		return -EBUSY;
 	}
 
-	dev = kzalloc(sizeof(struct davinci_mcbsp_dev), GFP_KERNEL);
-	if (!dev) {
-		ret = -ENOMEM;
-		goto err_release_region;
-	}
+	dev = devm_kzalloc(&pdev->dev, sizeof(struct davinci_mcbsp_dev),
+			   GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
 	if (pdata) {
 		dev->enable_channel_combine = pdata->enable_channel_combine;
 		dev->dma_params[SNDRV_PCM_STREAM_PLAYBACK].sram_size =
@@ -691,13 +691,11 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 	dev->dma_params[SNDRV_PCM_STREAM_CAPTURE].ram_chan_q	= ram_chan_q;
 
 	dev->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(dev->clk)) {
-		ret = -ENODEV;
-		goto err_free_mem;
-	}
+	if (IS_ERR(dev->clk))
+		return -ENODEV;
 	clk_enable(dev->clk);
 
-	dev->base = ioremap(mem->start, resource_size(mem));
+	dev->base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
 	if (!dev->base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -ENOMEM;
@@ -715,7 +713,7 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 	if (!res) {
 		dev_err(&pdev->dev, "no DMA resource\n");
 		ret = -ENXIO;
-		goto err_iounmap;
+		goto err_release_clk;
 	}
 	dev->dma_params[SNDRV_PCM_STREAM_PLAYBACK].channel = res->start;
 
@@ -723,7 +721,7 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 	if (!res) {
 		dev_err(&pdev->dev, "no DMA resource\n");
 		ret = -ENXIO;
-		goto err_iounmap;
+		goto err_release_clk;
 	}
 	dev->dma_params[SNDRV_PCM_STREAM_CAPTURE].channel = res->start;
 	dev->dev = &pdev->dev;
@@ -732,35 +730,24 @@ static int davinci_i2s_probe(struct platform_device *pdev)
 
 	ret = snd_soc_register_dai(&pdev->dev, &davinci_i2s_dai);
 	if (ret != 0)
-		goto err_iounmap;
+		goto err_release_clk;
 
 	return 0;
 
-err_iounmap:
-	iounmap(dev->base);
 err_release_clk:
 	clk_disable(dev->clk);
 	clk_put(dev->clk);
-err_free_mem:
-	kfree(dev);
-err_release_region:
-	release_mem_region(mem->start, resource_size(mem));
-
 	return ret;
 }
 
 static int davinci_i2s_remove(struct platform_device *pdev)
 {
 	struct davinci_mcbsp_dev *dev = dev_get_drvdata(&pdev->dev);
-	struct resource *mem;
 
 	snd_soc_unregister_dai(&pdev->dev);
 	clk_disable(dev->clk);
 	clk_put(dev->clk);
 	dev->clk = NULL;
-	kfree(dev);
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mem->start, resource_size(mem));
 
 	return 0;
 }

