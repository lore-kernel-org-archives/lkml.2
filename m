Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1L2Qvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:51:43 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60176 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673Ab1L2Qvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:51:38 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 7/10] sound/soc/codecs/jz4740.c: use devm_ functions
Date: Thu, 29 Dec 2011 17:51:23 +0100
Message-Id: <1325177489-13815-5-git-send-email-Julia.Lawall@lip6.fr>
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
 sound/soc/codecs/jz4740.c |   36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/sound/soc/codecs/jz4740.c b/sound/soc/codecs/jz4740.c
index d73d283..ccbf0ac 100644
--- a/sound/soc/codecs/jz4740.c
+++ b/sound/soc/codecs/jz4740.c
@@ -353,29 +353,29 @@ static int __devinit jz4740_codec_probe(struct platform_device *pdev)
 	struct jz4740_codec *jz4740_codec;
 	struct resource *mem;
 
-	jz4740_codec = kzalloc(sizeof(*jz4740_codec), GFP_KERNEL);
+	jz4740_codec = devm_kzalloc(&pdev->dev, sizeof(*jz4740_codec),
+				    GFP_KERNEL);
 	if (!jz4740_codec)
 		return -ENOMEM;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem) {
 		dev_err(&pdev->dev, "Failed to get mmio memory resource\n");
-		ret = -ENOENT;
-		goto err_free_codec;
+		return -ENOENT;
 	}
 
-	mem = request_mem_region(mem->start, resource_size(mem), pdev->name);
+	mem = devm_request_mem_region(&pdev->dev, mem->start,
+				      resource_size(mem), pdev->name);
 	if (!mem) {
 		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		ret = -EBUSY;
-		goto err_free_codec;
+		return -EBUSY;
 	}
 
-	jz4740_codec->base = ioremap(mem->start, resource_size(mem));
+	jz4740_codec->base = devm_ioremap(&pdev->dev, mem->start,
+					  resource_size(mem));
 	if (!jz4740_codec->base) {
 		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
-		ret = -EBUSY;
-		goto err_release_mem_region;
+		return -EBUSY;
 	}
 	jz4740_codec->mem = mem;
 
@@ -385,33 +385,17 @@ static int __devinit jz4740_codec_probe(struct platform_device *pdev)
 			&soc_codec_dev_jz4740_codec, &jz4740_codec_dai, 1);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register codec\n");
-		goto err_iounmap;
+		return ret;
 	}
 
 	return 0;
-
-err_iounmap:
-	iounmap(jz4740_codec->base);
-err_release_mem_region:
-	release_mem_region(mem->start, resource_size(mem));
-err_free_codec:
-	kfree(jz4740_codec);
-
-	return ret;
 }
 
 static int __devexit jz4740_codec_remove(struct platform_device *pdev)
 {
-	struct jz4740_codec *jz4740_codec = platform_get_drvdata(pdev);
-	struct resource *mem = jz4740_codec->mem;
-
 	snd_soc_unregister_codec(&pdev->dev);
 
-	iounmap(jz4740_codec->base);
-	release_mem_region(mem->start, resource_size(mem));
-
 	platform_set_drvdata(pdev, NULL);
-	kfree(jz4740_codec);
 
 	return 0;
 }

