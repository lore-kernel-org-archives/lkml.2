Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab2CZXBC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:01:02 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:7832 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2CZXAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:00:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-127.messagelabs.com!1332802806!1541125!17
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ASoC: ep93xx-i2s: use devm_* helpers to cleanup probe
Date: Mon, 26 Mar 2012 16:00:17 -0700
User-Agent: KMail/1.9.9
CC: <alsa-devel@alsa-project.org>, <mika.westerberg@iki.fi>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203261600.17787.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the devm_* helpers to cleanup the probe routine. This also eliminates
having to carry the mem value in the private data for the remove.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jaroslav Kysela <perex@perex.cz>
CC: Takashi Iwai <tiwai@suse.de>
Cc: Vinod Koul <vinod.koul@intel.com>

---

diff --git a/sound/soc/ep93xx/ep93xx-i2s.c b/sound/soc/ep93xx/ep93xx-i2s.c
index f7a6234..8df8f6d 100644
--- a/sound/soc/ep93xx/ep93xx-i2s.c
+++ b/sound/soc/ep93xx/ep93xx-i2s.c
@@ -63,7 +63,6 @@ struct ep93xx_i2s_info {
 	struct clk			*sclk;
 	struct clk			*lrclk;
 	struct ep93xx_pcm_dma_params	*dma_params;
-	struct resource			*mem;
 	void __iomem			*regs;
 };
 
@@ -373,38 +372,22 @@ static int ep93xx_i2s_probe(struct platform_device *pdev)
 	struct resource *res;
 	int err;
 
-	info = kzalloc(sizeof(struct ep93xx_i2s_info), GFP_KERNEL);
-	if (!info) {
-		err = -ENOMEM;
-		goto fail;
-	}
-
-	dev_set_drvdata(&pdev->dev, info);
-	info->dma_params = ep93xx_i2s_dma_params;
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		err = -ENODEV;
-		goto fail_free_info;
-	}
+	if (!res)
+		return -ENODEV;
 
-	info->mem = request_mem_region(res->start, resource_size(res),
-				       pdev->name);
-	if (!info->mem) {
-		err = -EBUSY;
-		goto fail_free_info;
-	}
-
-	info->regs = ioremap(info->mem->start, resource_size(info->mem));
-	if (!info->regs) {
-		err = -ENXIO;
-		goto fail_release_mem;
-	}
+	info->regs = devm_request_and_ioremap(&pdev->dev, res);
+	if (!info->regs)
+		return -ENXIO;
 
 	info->mclk = clk_get(&pdev->dev, "mclk");
 	if (IS_ERR(info->mclk)) {
 		err = PTR_ERR(info->mclk);
-		goto fail_unmap_mem;
+		goto fail;
 	}
 
 	info->sclk = clk_get(&pdev->dev, "sclk");
@@ -419,6 +402,9 @@ static int ep93xx_i2s_probe(struct platform_device *pdev)
 		goto fail_put_sclk;
 	}
 
+	dev_set_drvdata(&pdev->dev, info);
+	info->dma_params = ep93xx_i2s_dma_params;
+
 	err = snd_soc_register_dai(&pdev->dev, &ep93xx_i2s_dai);
 	if (err)
 		goto fail_put_lrclk;
@@ -426,17 +412,12 @@ static int ep93xx_i2s_probe(struct platform_device *pdev)
 	return 0;
 
 fail_put_lrclk:
+	dev_set_drvdata(&pdev->dev, NULL);
 	clk_put(info->lrclk);
 fail_put_sclk:
 	clk_put(info->sclk);
 fail_put_mclk:
 	clk_put(info->mclk);
-fail_unmap_mem:
-	iounmap(info->regs);
-fail_release_mem:
-	release_mem_region(info->mem->start, resource_size(info->mem));
-fail_free_info:
-	kfree(info);
 fail:
 	return err;
 }
@@ -446,12 +427,10 @@ static int __devexit ep93xx_i2s_remove(struct platform_device *pdev)
 	struct ep93xx_i2s_info *info = dev_get_drvdata(&pdev->dev);
 
 	snd_soc_unregister_dai(&pdev->dev);
+	dev_set_drvdata(&pdev->dev, NULL);
 	clk_put(info->lrclk);
 	clk_put(info->sclk);
 	clk_put(info->mclk);
-	iounmap(info->regs);
-	release_mem_region(info->mem->start, resource_size(info->mem));
-	kfree(info);
 	return 0;
 }
 
