Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab1L2Qvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:51:49 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60189 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab1L2Qvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:51:38 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 10/10] sound/soc/davinci/davinci-vcif.c: use devm_ functions
Date: Thu, 29 Dec 2011 17:51:20 +0100
Message-Id: <1325177489-13815-2-git-send-email-Julia.Lawall@lip6.fr>
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
 sound/soc/davinci/davinci-vcif.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/sound/soc/davinci/davinci-vcif.c b/sound/soc/davinci/davinci-vcif.c
index 70ce10c..da030ff 100644
--- a/sound/soc/davinci/davinci-vcif.c
+++ b/sound/soc/davinci/davinci-vcif.c
@@ -210,7 +210,9 @@ static int davinci_vcif_probe(struct platform_device *pdev)
 	struct davinci_vcif_dev *davinci_vcif_dev;
 	int ret;
 
-	davinci_vcif_dev = kzalloc(sizeof(struct davinci_vcif_dev), GFP_KERNEL);
+	davinci_vcif_dev = devm_kzalloc(&pdev->dev,
+					sizeof(struct davinci_vcif_dev),
+					GFP_KERNEL);
 	if (!davinci_vcif_dev) {
 		dev_dbg(&pdev->dev,
 			"could not allocate memory for private data\n");
@@ -235,23 +237,15 @@ static int davinci_vcif_probe(struct platform_device *pdev)
 	ret = snd_soc_register_dai(&pdev->dev, &davinci_vcif_dai);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "could not register dai\n");
-		goto fail;
+		return ret;
 	}
 
 	return 0;
-
-fail:
-	kfree(davinci_vcif_dev);
-
-	return ret;
 }
 
 static int davinci_vcif_remove(struct platform_device *pdev)
 {
-	struct davinci_vcif_dev *davinci_vcif_dev = dev_get_drvdata(&pdev->dev);
-
 	snd_soc_unregister_dai(&pdev->dev);
-	kfree(davinci_vcif_dev);
 
 	return 0;
 }

