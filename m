Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1L2QxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:53:07 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60230 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab1L2Qvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:51:42 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 3/10] sound/soc/au1x/dma.c: use devm_ functions
Date: Thu, 29 Dec 2011 17:51:27 +0100
Message-Id: <1325177489-13815-9-git-send-email-Julia.Lawall@lip6.fr>
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
 sound/soc/au1x/dma.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/sound/soc/au1x/dma.c b/sound/soc/au1x/dma.c
index c4017bd..0a91b18 100644
--- a/sound/soc/au1x/dma.c
+++ b/sound/soc/au1x/dma.c
@@ -325,27 +325,19 @@ static struct snd_soc_platform_driver alchemy_pcm_soc_platform = {
 static int __devinit alchemy_pcm_drvprobe(struct platform_device *pdev)
 {
 	struct alchemy_pcm_ctx *ctx;
-	int ret;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, ctx);
 
-	ret = snd_soc_register_platform(&pdev->dev, &alchemy_pcm_soc_platform);
-	if (ret)
-		kfree(ctx);
-
-	return ret;
+	return snd_soc_register_platform(&pdev->dev, &alchemy_pcm_soc_platform);
 }
 
 static int __devexit alchemy_pcm_drvremove(struct platform_device *pdev)
 {
-	struct alchemy_pcm_ctx *ctx = platform_get_drvdata(pdev);
-
 	snd_soc_unregister_platform(&pdev->dev);
-	kfree(ctx);
 
 	return 0;
 }

