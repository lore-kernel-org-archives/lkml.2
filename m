Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1FMN1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:27:49 -0400
Received: from smtp-out-074.synserver.de ([212.40.185.74]:1053 "HELO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751404Ab1FMN1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:27:36 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 27841
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/3 v2] ASoC: Blackfin: Add bf5xx-adau1701 machine driver
Date: Mon, 13 Jun 2011 15:26:21 +0200
Message-Id: <1307971582-13532-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307971582-13532-1-git-send-email-lars@metafoo.de>
References: <1307971582-13532-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a machine driver to support the ADAU1701 SigmaDSP processors on
Analog Devices BF5XX evaluation boards.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
Changes since v1:
	* Renamed the module to bfin-eval-adau1701.
	* Added eval board specific speaker and line widgets.
	* Reworked the Kconfig text to make it more clear that this driver is for
	  the adau1701 eval board.
---
 sound/soc/blackfin/Kconfig              |   11 +++
 sound/soc/blackfin/Makefile             |    2 +
 sound/soc/blackfin/bfin-eval-adau1701.c |  139 +++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/blackfin/bfin-eval-adau1701.c

diff --git a/sound/soc/blackfin/Kconfig b/sound/soc/blackfin/Kconfig
index ae40359..dcac889 100644
--- a/sound/soc/blackfin/Kconfig
+++ b/sound/soc/blackfin/Kconfig
@@ -17,6 +17,17 @@ config SND_BF5XX_SOC_SSM2602
 	help
 	  Say Y if you want to add support for SoC audio on BF527-EZKIT.
 
+config SND_SOC_BFIN_EVAL_ADAU1701
+	tristate "Support for the EVAL-ADAU1701MINIZ board on Blackfin eval boards"
+	depends on SND_BF5XX_I2S
+	select SND_BF5XX_SOC_I2S
+	select SND_SOC_ADAU1701
+	select I2C
+	help
+	  Say Y if you want to add support for the Analog Devices EVAL-ADAU1701MINIZ
+	  board connected to one of the Blackfin evaluation boards like the
+	  BF5XX-STAMP or BF5XX-EZKIT.
+
 config SND_BF5XX_SOC_AD73311
 	tristate "SoC AD73311 Audio support for Blackfin"
 	depends on SND_BF5XX_I2S
diff --git a/sound/soc/blackfin/Makefile b/sound/soc/blackfin/Makefile
index 49af3f3..f01bff6 100644
--- a/sound/soc/blackfin/Makefile
+++ b/sound/soc/blackfin/Makefile
@@ -21,9 +21,11 @@ snd-ad1980-objs := bf5xx-ad1980.o
 snd-ssm2602-objs := bf5xx-ssm2602.o
 snd-ad73311-objs := bf5xx-ad73311.o
 snd-ad193x-objs := bf5xx-ad193x.o
+snd-soc-bfin-eval-adau1701-objs := bfin-eval-adau1701.o
 
 obj-$(CONFIG_SND_BF5XX_SOC_AD1836) += snd-ad1836.o
 obj-$(CONFIG_SND_BF5XX_SOC_AD1980) += snd-ad1980.o
 obj-$(CONFIG_SND_BF5XX_SOC_SSM2602) += snd-ssm2602.o
 obj-$(CONFIG_SND_BF5XX_SOC_AD73311) += snd-ad73311.o
 obj-$(CONFIG_SND_BF5XX_SOC_AD193X) += snd-ad193x.o
+obj-$(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701) += snd-soc-bfin-eval-adau1701.o
diff --git a/sound/soc/blackfin/bfin-eval-adau1701.c b/sound/soc/blackfin/bfin-eval-adau1701.c
new file mode 100644
index 0000000..e5550ac
--- /dev/null
+++ b/sound/soc/blackfin/bfin-eval-adau1701.c
@@ -0,0 +1,139 @@
+/*
+ * Machine driver for EVAL-ADAU1701MINIZ on Analog Devices bfin
+ * evaluation boards.
+ *
+ * Copyright 2011 Analog Devices Inc.
+ * Author: Lars-Peter Clausen <lars@metafoo.de>
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/soc.h>
+#include <sound/pcm_params.h>
+
+#include "../codecs/adau1701.h"
+
+static const struct snd_soc_dapm_widget bfin_eval_adau1701_dapm_widgets[] = {
+	SND_SOC_DAPM_SPK("Speaker", NULL),
+	SND_SOC_DAPM_LINE("Line Out", NULL),
+	SND_SOC_DAPM_LINE("Line In", NULL),
+};
+
+static const struct snd_soc_dapm_route bfin_eval_adau1701_dapm_routes[] = {
+	{ "Speaker", NULL, "OUT0" },
+	{ "Speaker", NULL, "OUT1" },
+	{ "Line Out", NULL, "OUT2" },
+	{ "Line Out", NULL, "OUT3" },
+
+	{ "IN0", NULL, "Line In" },
+	{ "IN1", NULL, "Line In" },
+};
+
+static int bfin_eval_adau1701_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	int ret;
+
+	ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S |
+			SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
+			SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dai_set_sysclk(codec_dai, ADAU1701_CLK_SRC_OSC, 12288000,
+			SND_SOC_CLOCK_IN);
+
+	return ret;
+}
+
+static struct snd_soc_ops bfin_eval_adau1701_ops = {
+	.hw_params = bfin_eval_adau1701_hw_params,
+};
+
+static struct snd_soc_dai_link bfin_eval_adau1701_dai[] = {
+	{
+		.name = "adau1701",
+		.stream_name = "adau1701",
+		.cpu_dai_name = "bfin-i2s.0",
+		.codec_dai_name = "adau1701",
+		.platform_name = "bfin-i2s-pcm-audio",
+		.codec_name = "adau1701.0-0034",
+		.ops = &bfin_eval_adau1701_ops,
+	},
+	{
+		.name = "adau1701",
+		.stream_name = "adau1701",
+		.cpu_dai_name = "bfin-i2s.1",
+		.codec_dai_name = "adau1701",
+		.platform_name = "bfin-i2s-pcm-audio",
+		.codec_name = "adau1701.0-0034",
+		.ops = &bfin_eval_adau1701_ops,
+	},
+};
+
+static struct snd_soc_card bfin_eval_adau1701 = {
+	.name = "bfin-eval-adau1701",
+	.dai_link = &bfin_eval_adau1701_dai[CONFIG_SND_BF5XX_SPORT_NUM],
+	.num_links = 1,
+
+	.dapm_widgets		= bfin_eval_adau1701_dapm_widgets,
+	.num_dapm_widgets	= ARRAY_SIZE(bfin_eval_adau1701_dapm_widgets),
+	.dapm_routes		= bfin_eval_adau1701_dapm_routes,
+	.num_dapm_routes	= ARRAY_SIZE(bfin_eval_adau1701_dapm_routes),
+};
+
+static int bfin_eval_adau1701_probe(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = &bfin_eval_adau1701;
+
+	card->dev = &pdev->dev;
+
+	return snd_soc_register_card(&bfin_eval_adau1701);
+}
+
+static int __devexit bfin_eval_adau1701_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
+
+	return 0;
+}
+
+static struct platform_driver bfin_eval_adau1701_driver = {
+	.driver = {
+		.name = "bfin-eval-adau1701",
+		.owner = THIS_MODULE,
+		.pm = &snd_soc_pm_ops,
+	},
+	.probe = bfin_eval_adau1701_probe,
+	.remove = __devexit_p(bfin_eval_adau1701_remove),
+};
+
+static int __init bfin_eval_adau1701_init(void)
+{
+	return platform_driver_register(&bfin_eval_adau1701_driver);
+}
+module_init(bfin_eval_adau1701_init);
+
+static void __exit bfin_eval_adau1701_exit(void)
+{
+	platform_driver_unregister(&bfin_eval_adau1701_driver);
+}
+module_exit(bfin_eval_adau1701_exit);
+
+MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
+MODULE_DESCRIPTION("ALSA SoC bfin ADAU1701 driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:bfin-eval-adau1701");
-- 
1.7.2.5

