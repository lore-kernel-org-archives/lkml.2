Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1L2Qxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:53:49 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60204 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744Ab1L2Qvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:51:41 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 5/10] sound/soc/au1x/psc-ac97.c: use devm_ functions
Date: Thu, 29 Dec 2011 17:51:25 +0100
Message-Id: <1325177489-13815-7-git-send-email-Julia.Lawall@lip6.fr>
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
 sound/soc/au1x/psc-ac97.c |   41 ++++++++++++++---------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/sound/soc/au1x/psc-ac97.c b/sound/soc/au1x/psc-ac97.c
index 87daf45..476b79a 100644
--- a/sound/soc/au1x/psc-ac97.c
+++ b/sound/soc/au1x/psc-ac97.c
@@ -368,35 +368,35 @@ static int __devinit au1xpsc_ac97_drvprobe(struct platform_device *pdev)
 	unsigned long sel;
 	struct au1xpsc_audio_data *wd;
 
-	wd = kzalloc(sizeof(struct au1xpsc_audio_data), GFP_KERNEL);
+	wd = devm_kzalloc(&pdev->dev, sizeof(struct au1xpsc_audio_data),
+			  GFP_KERNEL);
 	if (!wd)
 		return -ENOMEM;
 
 	mutex_init(&wd->lock);
 
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
 
-	wd->mmio = ioremap(iores->start, resource_size(iores));
+	wd->mmio = devm_ioremap(&pdev->dev, iores->start,
+				resource_size(iores));
 	if (!wd->mmio)
-		goto out1;
+		return -EBUSY;
 
 	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (!dmares)
-		goto out2;
+		return -EBUSY;
 	wd->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = dmares->start;
 
 	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 1);
 	if (!dmares)
-		goto out2;
+		return -EBUSY;
 	wd->dmaids[SNDRV_PCM_STREAM_CAPTURE] = dmares->start;
 
 	/* configuration: max dma trigger threshold, enable ac97 */
@@ -421,24 +421,15 @@ static int __devinit au1xpsc_ac97_drvprobe(struct platform_device *pdev)
 
 	ret = snd_soc_register_dai(&pdev->dev, &wd->dai_drv);
 	if (ret)
-		goto out2;
+		return ret;
 
 	au1xpsc_ac97_workdata = wd;
 	return 0;
-
-out2:
-	iounmap(wd->mmio);
-out1:
-	release_mem_region(iores->start, resource_size(iores));
-out0:
-	kfree(wd);
-	return ret;
 }
 
 static int __devexit au1xpsc_ac97_drvremove(struct platform_device *pdev)
 {
 	struct au1xpsc_audio_data *wd = platform_get_drvdata(pdev);
-	struct resource *r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	snd_soc_unregister_dai(&pdev->dev);
 
@@ -448,10 +439,6 @@ static int __devexit au1xpsc_ac97_drvremove(struct platform_device *pdev)
 	au_writel(PSC_CTRL_DISABLE, PSC_CTRL(wd));
 	au_sync();
 
-	iounmap(wd->mmio);
-	release_mem_region(r->start, resource_size(r));
-	kfree(wd);
-
 	au1xpsc_ac97_workdata = NULL;	/* MDEV */
 
 	return 0;

