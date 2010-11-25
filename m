Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab0KYHIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:08:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58480 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab0KYHIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:08:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WU3zh7wbfqAnjIfXORTeJgVMQC42b5y6iPx2/WAk8n/U/wie3/a3Rm1kOm0Mo+xSOp
         CYl2Q2uxdosRg6Qc2BTWYgQJe5e935ycEbrTroB9Lt+zRkhxRahXSq/+/clBEs3zaqap
         QWLq2JNxBbWgwAeQ5FdjLZvct76ukbt7kyXQw=
Subject: [PATCH 8/8] ASoC: phycore-ac97: fix resource leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290668785.30158.7.camel@mola>
References: <1290668785.30158.7.camel@mola>
Content-Type: text/plain
Date: Thu, 25 Nov 2010 15:14:03 +0800
Message-Id: <1290669243.30158.22.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix imx_phycore_init() error path and imx_phycore_exit() to properly free
allocated resources.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/imx/phycore-ac97.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/sound/soc/imx/phycore-ac97.c b/sound/soc/imx/phycore-ac97.c
index db157f7..a7deb5c 100644
--- a/sound/soc/imx/phycore-ac97.c
+++ b/sound/soc/imx/phycore-ac97.c
@@ -42,6 +42,7 @@ static struct snd_soc_card imx_phycore = {
 	.num_links	= ARRAY_SIZE(imx_phycore_dai_ac97),
 };
 
+static struct platform_device *imx_phycore_snd_ac97_device;
 static struct platform_device *imx_phycore_snd_device;
 
 static int __init imx_phycore_init(void)
@@ -52,29 +53,42 @@ static int __init imx_phycore_init(void)
 		/* return happy. We might run on a totally different machine */
 		return 0;
 
-	imx_phycore_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!imx_phycore_snd_device)
+	imx_phycore_snd_ac97_device = platform_device_alloc("soc-audio", -1);
+	if (!imx_phycore_snd_ac97_device)
 		return -ENOMEM;
 
-	platform_set_drvdata(imx_phycore_snd_device, &imx_phycore);
-	ret = platform_device_add(imx_phycore_snd_device);
+	platform_set_drvdata(imx_phycore_snd_ac97_device, &imx_phycore);
+	ret = platform_device_add(imx_phycore_snd_ac97_device);
+	if (ret)
+		goto fail1;
 
 	imx_phycore_snd_device = platform_device_alloc("wm9712-codec", -1);
-	if (!imx_phycore_snd_device)
-		return -ENOMEM;
+	if (!imx_phycore_snd_device) {
+		ret = -ENOMEM;
+		goto fail2;
+	}
 	ret = platform_device_add(imx_phycore_snd_device);
 
 	if (ret) {
 		printk(KERN_ERR "ASoC: Platform device allocation failed\n");
-		platform_device_put(imx_phycore_snd_device);
+		goto fail3;
 	}
 
+	return 0;
+
+fail3:
+	platform_device_put(imx_phycore_snd_device);
+fail2:
+	platform_device_del(imx_phycore_snd_ac97_device);
+fail1:
+	platform_device_put(imx_phycore_snd_ac97_device);
 	return ret;
 }
 
 static void __exit imx_phycore_exit(void)
 {
 	platform_device_unregister(imx_phycore_snd_device);
+	platform_device_unregister(imx_phycore_snd_ac97_device);
 }
 
 late_initcall(imx_phycore_init);
-- 
1.7.2



