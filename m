Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1L2QwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:52:01 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60239 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673Ab1L2Qvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:51:44 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 2/10] sound/soc/au1x/dbdma2.c: use devm_ functions
Date: Thu, 29 Dec 2011 17:51:28 +0100
Message-Id: <1325177489-13815-10-git-send-email-Julia.Lawall@lip6.fr>
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
 sound/soc/au1x/dbdma2.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/sound/soc/au1x/dbdma2.c b/sound/soc/au1x/dbdma2.c
index 92bc1b0..8372cd3 100644
--- a/sound/soc/au1x/dbdma2.c
+++ b/sound/soc/au1x/dbdma2.c
@@ -350,27 +350,21 @@ static struct snd_soc_platform_driver au1xpsc_soc_platform = {
 static int __devinit au1xpsc_pcm_drvprobe(struct platform_device *pdev)
 {
 	struct au1xpsc_audio_dmadata *dmadata;
-	int ret;
 
-	dmadata = kzalloc(2 * sizeof(struct au1xpsc_audio_dmadata), GFP_KERNEL);
+	dmadata = devm_kzalloc(&pdev->dev,
+			       2 * sizeof(struct au1xpsc_audio_dmadata),
+			       GFP_KERNEL);
 	if (!dmadata)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, dmadata);
 
-	ret = snd_soc_register_platform(&pdev->dev, &au1xpsc_soc_platform);
-	if (ret)
-		kfree(dmadata);
-
-	return ret;
+	return snd_soc_register_platform(&pdev->dev, &au1xpsc_soc_platform);
 }
 
 static int __devexit au1xpsc_pcm_drvremove(struct platform_device *pdev)
 {
-	struct au1xpsc_audio_dmadata *dmadata = platform_get_drvdata(pdev);
-
 	snd_soc_unregister_platform(&pdev->dev);
-	kfree(dmadata);
 
 	return 0;
 }

