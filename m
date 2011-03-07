Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1CGHEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 02:04:20 -0500
Received: from smtp-out-189.synserver.de ([212.40.185.189]:1138 "HELO
	smtp-out-189.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754063Ab1CGHEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 02:04:01 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 8276
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Jassi Brar <jassi.brar@samsung.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/7] ASoC: Add driver for the dfbmcs320 bluetooth module
Date: Mon,  7 Mar 2011 08:04:59 +0100
Message-Id: <1299481500-5481-6-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299481500-5481-1-git-send-email-lars@metafoo.de>
References: <1299481500-5481-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a codec driver for the dfbmcs320 bluetooth module, which is used
on the neo1973 boards.

The patch also modifies the neo1937_wm8753 sound board driver to use the new
driver instead of registering the bluetooth DAI manually.
Previously there was a name mismatch between the bluetooth DAI and the bluetooth
DAI link and the sound card was not instantiated, with this patch the issue is
no longer present and sound support works again.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/Kconfig           |    5 ++-
 sound/soc/codecs/Makefile          |    2 +
 sound/soc/codecs/dfbmcs320.c       |   72 ++++++++++++++++++++++++++++++++++++
 sound/soc/samsung/Kconfig          |    1 +
 sound/soc/samsung/neo1973_wm8753.c |   35 +++--------------
 5 files changed, 86 insertions(+), 29 deletions(-)
 create mode 100644 sound/soc/codecs/dfbmcs320.c

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 37035e6..212859c 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -29,6 +29,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_CS4271 if SND_SOC_I2C_AND_SPI
 	select SND_SOC_CX20442
 	select SND_SOC_DA7210 if I2C
+	select SND_SOC_DFBMCS320
 	select SND_SOC_JZ4740_CODEC if SOC_JZ4740
 	select SND_SOC_MAX98088 if I2C
 	select SND_SOC_MAX9877 if I2C
@@ -175,6 +176,9 @@ config SND_SOC_L3
 config SND_SOC_DA7210
         tristate
 
+config SND_SOC_DFBMCS320
+	tristate
+
 config SND_SOC_DMIC
 	tristate
 
@@ -361,4 +365,3 @@ config SND_SOC_WM2000
 
 config SND_SOC_WM9090
 	tristate
-
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 0663d22..ebb059c 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -15,6 +15,7 @@ snd-soc-cs4270-objs := cs4270.o
 snd-soc-cs4271-objs := cs4271.o
 snd-soc-cx20442-objs := cx20442.o
 snd-soc-da7210-objs := da7210.o
+snd-soc-dfbmcs320-objs := dfbmcs320.o
 snd-soc-dmic-objs := dmic.o
 snd-soc-l3-objs := l3.o
 snd-soc-max98088-objs := max98088.o
@@ -101,6 +102,7 @@ obj-$(CONFIG_SND_SOC_CS4270)	+= snd-soc-cs4270.o
 obj-$(CONFIG_SND_SOC_CS4271)	+= snd-soc-cs4271.o
 obj-$(CONFIG_SND_SOC_CX20442)	+= snd-soc-cx20442.o
 obj-$(CONFIG_SND_SOC_DA7210)	+= snd-soc-da7210.o
+obj-$(CONFIG_SND_SOC_DFBMCS320)	+= snd-soc-dfbmcs320.o
 obj-$(CONFIG_SND_SOC_DMIC)	+= snd-soc-dmic.o
 obj-$(CONFIG_SND_SOC_L3)	+= snd-soc-l3.o
 obj-$(CONFIG_SND_SOC_JZ4740_CODEC)	+= snd-soc-jz4740-codec.o
diff --git a/sound/soc/codecs/dfbmcs320.c b/sound/soc/codecs/dfbmcs320.c
new file mode 100644
index 0000000..704bbde
--- /dev/null
+++ b/sound/soc/codecs/dfbmcs320.c
@@ -0,0 +1,72 @@
+/*
+ * Driver for the DFBM-CS320 bluetooth module
+ * Copyright 2011 Lars-Peter Clausen <lars@metafoo.de>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <sound/soc.h>
+
+static struct snd_soc_dai_driver dfbmcs320_dai = {
+	.name = "dfbmcs320-pcm",
+	.playback = {
+		.channels_min = 1,
+		.channels_max = 1,
+		.rates = SNDRV_PCM_RATE_8000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE,
+	},
+	.capture = {
+		.channels_min = 1,
+		.channels_max = 1,
+		.rates = SNDRV_PCM_RATE_8000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE,
+	},
+};
+
+static struct snd_soc_codec_driver soc_codec_dev_dfbmcs320;
+
+static int __devinit dfbmcs320_probe(struct platform_device *pdev)
+{
+	return snd_soc_register_codec(&pdev->dev, &soc_codec_dev_dfbmcs320,
+			&dfbmcs320_dai, 1);
+}
+
+static int __devexit dfbmcs320_remove(struct platform_device *pdev)
+{
+	snd_soc_unregister_codec(&pdev->dev);
+
+	return 0;
+}
+
+static struct platform_driver dfmcs320_driver = {
+	.driver = {
+		.name = "dfbmcs320",
+		.owner = THIS_MODULE,
+	},
+	.probe = dfbmcs320_probe,
+	.remove = __devexit_p(dfbmcs320_remove),
+};
+
+static int __init dfbmcs320_init(void)
+{
+	return platform_driver_register(&dfmcs320_driver);
+}
+module_init(dfbmcs320_init);
+
+static void __exit dfbmcs320_exit(void)
+{
+	platform_driver_unregister(&dfmcs320_driver);
+}
+module_exit(dfbmcs320_exit);
+
+MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
+MODULE_DESCRIPTION("ASoC DFBM-CS320 bluethooth module driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index c3014e8..a08237a 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -40,6 +40,7 @@ config SND_SOC_SAMSUNG_NEO1973_WM8753
 	select SND_S3C24XX_I2S
 	select SND_SOC_WM8753
 	select SND_SOC_LM4857 if MACH_NEO1973_GTA01
+	select SND_SOC_DFBMCS320
 	help
 	  Say Y here to enable audio support for the Openmoko Neo1973
 	  Smartphones.
diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
index 37cfbb8..78bfdb3 100644
--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -418,23 +418,6 @@ static int neo1973_lm4857_init(struct snd_soc_dapm_context *dapm)
 static int neo1973_lm4857_init(struct snd_soc_dapm_context *dapm) { return 0; };
 #endif
 
-/*
- * BT Codec DAI
- */
-static struct snd_soc_dai_driver bt_dai = {
-	.name = "bluetooth-dai",
-	.playback = {
-		.channels_min = 1,
-		.channels_max = 1,
-		.rates = SNDRV_PCM_RATE_8000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE,},
-	.capture = {
-		.channels_min = 1,
-		.channels_max = 1,
-		.rates = SNDRV_PCM_RATE_8000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE,},
-};
-
 static struct snd_soc_dai_link neo1973_dai[] = {
 { /* Hifi Playback - for similatious use with voice below */
 	.name = "WM8753",
@@ -450,7 +433,7 @@ static struct snd_soc_dai_link neo1973_dai[] = {
 	.name = "Bluetooth",
 	.stream_name = "Voice",
 	.platform_name = "samsung-audio",
-	.cpu_dai_name = "bluetooth-dai",
+	.cpu_dai_name = "dfbmcs320-pcm",
 	.codec_dai_name = "wm8753-voice",
 	.codec_name = "wm8753-codec.0-001a",
 	.ops = &neo1973_voice_ops,
@@ -459,6 +442,10 @@ static struct snd_soc_dai_link neo1973_dai[] = {
 
 static struct snd_soc_aux_dev neo1973_aux_devs[] = {
 	{
+		.name = "dfbmcs320",
+		.codec_name = "dfbmcs320.0",
+	},
+	{
 		.name = "lm4857",
 		.codec_name = "lm4857.0-007c",
 		.init = neo1973_lm4857_init,
@@ -502,7 +489,7 @@ static int __init neo1973_init(void)
 
 	if (machine_is_neo1973_gta02()) {
 		neo1973.name = "neo1973gta02";
-		neo1973.num_aux_devs = 0;
+		neo1973.num_aux_devs = 1;
 
 		ret = gpio_request_array(neo1973_gta02_gpios,
 				ARRAY_SIZE(neo1973_gta02_gpios));
@@ -516,21 +503,14 @@ static int __init neo1973_init(void)
 		goto err_gpio_free;
 	}
 
-	/* register bluetooth DAI here */
-	ret = snd_soc_register_dai(&neo1973_snd_device->dev, &bt_dai);
-	if (ret)
-		goto err_put_device;
-
 	platform_set_drvdata(neo1973_snd_device, &neo1973);
 	ret = platform_device_add(neo1973_snd_device);
 
 	if (ret)
-		goto err_unregister_dai;
+		goto err_put_device;
 
 	return 0;
 
-err_unregister_dai:
-	snd_soc_unregister_dai(&neo1973_snd_device->dev);
 err_put_device:
 	platform_device_put(neo1973_snd_device);
 err_gpio_free:
@@ -544,7 +524,6 @@ module_init(neo1973_init);
 
 static void __exit neo1973_exit(void)
 {
-	snd_soc_unregister_dai(&neo1973_snd_device->dev);
 	platform_device_unregister(neo1973_snd_device);
 
 	if (machine_is_neo1973_gta02()) {
-- 
1.7.2.3

