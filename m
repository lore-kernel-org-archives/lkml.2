Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab1L3DSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 22:18:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61149 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab1L3DSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 22:18:20 -0500
Message-ID: <1325215093.2569.8.camel@phoenix>
Subject: [PATCH 3/3] ASoC: pxa: Convert corgi to use snd_soc_register_card()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Fri, 30 Dec 2011 11:18:13 +0800
In-Reply-To: <1325214804.2569.3.camel@phoenix>
References: <1325214804.2569.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snd_soc_register_card() instead of creating a "soc-audio" platform device.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-pxa/corgi.c |    9 +++++++++
 sound/soc/pxa/corgi.c     |   43 +++++++++++++++++++++++--------------------
 2 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c
index 66600f0..11f1e73 100644
--- a/arch/arm/mach-pxa/corgi.c
+++ b/arch/arm/mach-pxa/corgi.c
@@ -436,6 +436,14 @@ static struct platform_device corgiled_device = {
 };
 
 /*
+ * Corgi Audio
+ */
+static struct platform_device corgi_audio_device = {
+	.name	= "corgi-audio",
+	.id	= -1,
+};
+
+/*
  * MMC/SD Device
  *
  * The card detect interrupt isn't debounced so we delay it by 250ms
@@ -641,6 +649,7 @@ static struct platform_device *devices[] __initdata = {
 	&corgifb_device,
 	&corgikbd_device,
 	&corgiled_device,
+	&corgi_audio_device,
 	&sharpsl_nand_device,
 	&sharpsl_rom_device,
 };
diff --git a/sound/soc/pxa/corgi.c b/sound/soc/pxa/corgi.c
index 30ebce2..bc21944 100644
--- a/sound/soc/pxa/corgi.c
+++ b/sound/soc/pxa/corgi.c
@@ -291,7 +291,7 @@ static struct snd_soc_dai_link corgi_dai = {
 };
 
 /* corgi audio machine driver */
-static struct snd_soc_card snd_soc_corgi = {
+static struct snd_soc_card corgi = {
 	.name = "Corgi",
 	.owner = THIS_MODULE,
 	.dai_link = &corgi_dai,
@@ -305,38 +305,41 @@ static struct snd_soc_card snd_soc_corgi = {
 	.num_dapm_routes = ARRAY_SIZE(corgi_audio_map),
 };
 
-static struct platform_device *corgi_snd_device;
-
-static int __init corgi_init(void)
+static int __devinit corgi_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &corgi;
 	int ret;
 
-	if (!(machine_is_corgi() || machine_is_shepherd() ||
-	      machine_is_husky()))
-		return -ENODEV;
-
-	corgi_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!corgi_snd_device)
-		return -ENOMEM;
-
-	platform_set_drvdata(corgi_snd_device, &snd_soc_corgi);
-	ret = platform_device_add(corgi_snd_device);
+	card->dev = &pdev->dev;
 
+	ret = snd_soc_register_card(card);
 	if (ret)
-		platform_device_put(corgi_snd_device);
-
+		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
+			ret);
 	return ret;
 }
 
-static void __exit corgi_exit(void)
+static int __devexit corgi_remove(struct platform_device *pdev)
 {
-	platform_device_unregister(corgi_snd_device);
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
+	return 0;
 }
 
-module_init(corgi_init);
-module_exit(corgi_exit);
+static struct platform_driver corgi_driver = {
+	.driver		= {
+		.name	= "corgi-audio",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= corgi_probe,
+	.remove		= __devexit_p(corgi_remove),
+};
+
+module_platform_driver(corgi_driver);
 
 /* Module information */
 MODULE_AUTHOR("Richard Purdie");
 MODULE_DESCRIPTION("ALSA SoC Corgi");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:corgi-audio");
-- 
1.7.5.4



