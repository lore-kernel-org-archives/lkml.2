Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab1L2Qv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:51:56 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60198 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab1L2Qvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:51:40 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 9/10] sound/soc/davinci/davinci-mcasp.c: use devm_ functions
Date: Thu, 29 Dec 2011 17:51:21 +0100
Message-Id: <1325177489-13815-3-git-send-email-Julia.Lawall@lip6.fr>
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
 sound/soc/davinci/davinci-mcasp.c |   40 +++++++++++---------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 2152ff5..95441bf 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -865,38 +865,35 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	struct resource *mem, *ioarea, *res;
 	struct snd_platform_data *pdata;
 	struct davinci_audio_dev *dev;
-	int ret = 0;
+	int ret;
 
-	dev = kzalloc(sizeof(struct davinci_audio_dev), GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof(struct davinci_audio_dev),
+			   GFP_KERNEL);
 	if (!dev)
 		return	-ENOMEM;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem) {
 		dev_err(&pdev->dev, "no mem resource?\n");
-		ret = -ENODEV;
-		goto err_release_data;
+		return -ENODEV;
 	}
 
-	ioarea = request_mem_region(mem->start,
+	ioarea = devm_request_mem_region(&pdev->dev, mem->start,
 			resource_size(mem), pdev->name);
 	if (!ioarea) {
 		dev_err(&pdev->dev, "Audio region already claimed\n");
-		ret = -EBUSY;
-		goto err_release_data;
+		return -EBUSY;
 	}
 
 	pdata = pdev->dev.platform_data;
 	dev->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(dev->clk)) {
-		ret = -ENODEV;
-		goto err_release_region;
-	}
+	if (IS_ERR(dev->clk))
+		return -ENODEV;
 
 	clk_enable(dev->clk);
 	dev->clk_active = 1;
 
-	dev->base = ioremap(mem->start, resource_size(mem));
+	dev->base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
 	if (!dev->base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -ENOMEM;
@@ -924,7 +921,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	if (!res) {
 		dev_err(&pdev->dev, "no DMA resource\n");
 		ret = -ENODEV;
-		goto err_iounmap;
+		goto err_release_clk;
 	}
 
 	dma_data->channel = res->start;
@@ -940,7 +937,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	if (!res) {
 		dev_err(&pdev->dev, "no DMA resource\n");
 		ret = -ENODEV;
-		goto err_iounmap;
+		goto err_release_clk;
 	}
 
 	dma_data->channel = res->start;
@@ -948,37 +945,24 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	ret = snd_soc_register_dai(&pdev->dev, &davinci_mcasp_dai[pdata->op_mode]);
 
 	if (ret != 0)
-		goto err_iounmap;
+		goto err_release_clk;
 	return 0;
 
-err_iounmap:
-	iounmap(dev->base);
 err_release_clk:
 	clk_disable(dev->clk);
 	clk_put(dev->clk);
-err_release_region:
-	release_mem_region(mem->start, resource_size(mem));
-err_release_data:
-	kfree(dev);
-
 	return ret;
 }
 
 static int davinci_mcasp_remove(struct platform_device *pdev)
 {
 	struct davinci_audio_dev *dev = dev_get_drvdata(&pdev->dev);
-	struct resource *mem;
 
 	snd_soc_unregister_dai(&pdev->dev);
 	clk_disable(dev->clk);
 	clk_put(dev->clk);
 	dev->clk = NULL;
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mem->start, resource_size(mem));
-
-	kfree(dev);
-
 	return 0;
 }
 

