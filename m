Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab2BHROb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:14:31 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:42973 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab2BHROa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:14:30 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        B29396@freescale.com
Subject: [PATCH] sound/soc/mxs/mxs-saif.c: use devm_ functions
Date: Wed,  8 Feb 2012 18:14:22 +0100
Message-Id: <1328721262-20993-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
patch against git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git

 sound/soc/mxs/mxs-saif.c |   51 ++++++++++-------------------------------------
 1 file changed, 11 insertions(+), 40 deletions(-)

diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 76dc74d..63b0a81 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -632,7 +632,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
 			return ret;
 	}
 
-	saif = kzalloc(sizeof(*saif), GFP_KERNEL);
+	saif = devm_kzalloc(&pdev->dev, sizeof(*saif), GFP_KERNEL);
 	if (!saif)
 		return -ENOMEM;
 
@@ -652,29 +652,16 @@ static int mxs_saif_probe(struct platform_device *pdev)
 		ret = PTR_ERR(saif->clk);
 		dev_err(&pdev->dev, "Cannot get the clock: %d\n",
 			ret);
-		goto failed_clk;
+		return ret;
 	}
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!iores) {
-		ret = -ENODEV;
-		dev_err(&pdev->dev, "failed to get io resource: %d\n",
-			ret);
-		goto failed_get_resource;
-	}
 
-	if (!request_mem_region(iores->start, resource_size(iores),
-				"mxs-saif")) {
-		dev_err(&pdev->dev, "request_mem_region failed\n");
-		ret = -EBUSY;
-		goto failed_get_resource;
-	}
-
-	saif->base = ioremap(iores->start, resource_size(iores));
+	saif->base = devm_request_and_ioremap(&pdev->dev, iores);
 	if (!saif->base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -ENODEV;
-		goto failed_ioremap;
+		goto failed_get_resource;
 	}
 
 	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
@@ -682,7 +669,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		dev_err(&pdev->dev, "failed to get dma resource: %d\n",
 			ret);
-		goto failed_ioremap;
+		goto failed_get_resource;
 	}
 	saif->dma_param.chan_num = dmares->start;
 
@@ -691,14 +678,15 @@ static int mxs_saif_probe(struct platform_device *pdev)
 		ret = saif->irq;
 		dev_err(&pdev->dev, "failed to get irq resource: %d\n",
 			ret);
-		goto failed_get_irq1;
+		goto failed_get_resource;
 	}
 
 	saif->dev = &pdev->dev;
-	ret = request_irq(saif->irq, mxs_saif_irq, 0, "mxs-saif", saif);
+	ret = devm_request_irq(&pdev->dev, saif->irq, mxs_saif_irq, 0,
+			       "mxs-saif", saif);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		goto failed_get_irq1;
+		goto failed_get_resource;
 	}
 
 	saif->dma_param.chan_irq = platform_get_irq(pdev, 1);
@@ -706,7 +694,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
 		ret = saif->dma_param.chan_irq;
 		dev_err(&pdev->dev, "failed to get dma irq resource: %d\n",
 			ret);
-		goto failed_get_irq2;
+		goto failed_get_resource;
 	}
 
 	platform_set_drvdata(pdev, saif);
@@ -714,7 +702,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
 	ret = snd_soc_register_dai(&pdev->dev, &mxs_saif_dai);
 	if (ret) {
 		dev_err(&pdev->dev, "register DAI failed\n");
-		goto failed_register;
+		goto failed_get_resource;
 	}
 
 	saif->soc_platform_pdev = platform_device_alloc(
@@ -737,36 +725,19 @@ failed_pdev_add:
 	platform_device_put(saif->soc_platform_pdev);
 failed_pdev_alloc:
 	snd_soc_unregister_dai(&pdev->dev);
-failed_register:
-failed_get_irq2:
-	free_irq(saif->irq, saif);
-failed_get_irq1:
-	iounmap(saif->base);
-failed_ioremap:
-	release_mem_region(iores->start, resource_size(iores));
 failed_get_resource:
 	clk_put(saif->clk);
-failed_clk:
-	kfree(saif);
 
 	return ret;
 }
 
 static int __devexit mxs_saif_remove(struct platform_device *pdev)
 {
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct mxs_saif *saif = platform_get_drvdata(pdev);
 
 	platform_device_unregister(saif->soc_platform_pdev);
-
 	snd_soc_unregister_dai(&pdev->dev);
-
-	iounmap(saif->base);
-	release_mem_region(res->start, resource_size(res));
-	free_irq(saif->irq, saif);
-
 	clk_put(saif->clk);
-	kfree(saif);
 
 	return 0;
 }

