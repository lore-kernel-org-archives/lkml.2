Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1HOSRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 14:17:51 -0400
Received: from smtp-out-020.synserver.de ([212.40.185.20]:1060 "HELO
	smtp-out-020.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752194Ab1HOSRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 14:17:41 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 10030
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/4] ASoC: Blackfin: ADAU1373 eval board support
Date: Mon, 15 Aug 2011 20:15:23 +0200
Message-Id: <1313432124-22591-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313432124-22591-1-git-send-email-lars@metafoo.de>
References: <1313432124-22591-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a machine driver to support the EVAL-ADAU1373 board connected to a
Analog Devices BF5XX evaluation board.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Changes since v1:
	* Make the drivers Kconfig symbol depend on I2C instead of selecting it
---
 sound/soc/blackfin/Kconfig              |   13 ++
 sound/soc/blackfin/Makefile             |    2 +
 sound/soc/blackfin/bfin-eval-adau1373.c |  202 +++++++++++++++++++++++++++++++
 3 files changed, 217 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/blackfin/bfin-eval-adau1373.c

diff --git a/sound/soc/blackfin/Kconfig b/sound/soc/blackfin/Kconfig
index fe9d548..9f6bc55 100644
--- a/sound/soc/blackfin/Kconfig
+++ b/sound/soc/blackfin/Kconfig
@@ -27,6 +27,19 @@ config SND_SOC_BFIN_EVAL_ADAU1701
 	  board connected to one of the Blackfin evaluation boards like the
 	  BF5XX-STAMP or BF5XX-EZKIT.
 
+config SND_SOC_BFIN_EVAL_ADAU1373
+	tristate "Support for the EVAL-ADAU1373 board on Blackfin eval boards"
+	depends on SND_BF5XX_I2S && I2C
+	select SND_BF5XX_SOC_I2S
+	select SND_SOC_ADAU1373
+	help
+	  Say Y if you want to add support for the Analog Devices EVAL-ADAU1373
+	  board connected to one of the Blackfin evaluation boards like the
+	  BF5XX-STAMP or BF5XX-EZKIT.
+
+	  Note: This driver assumes that first ADAU1373 DAI is connected to the
+	  first SPORT port on the BF5XX board.
+
 config SND_SOC_BFIN_EVAL_ADAV80X
 	tristate "Support for the EVAL-ADAV80X boards on Blackfin eval boards"
 	depends on SND_BF5XX_I2S && (SPI_MASTER || I2C)
diff --git a/sound/soc/blackfin/Makefile b/sound/soc/blackfin/Makefile
index 6018bf5..1bf86cc 100644
--- a/sound/soc/blackfin/Makefile
+++ b/sound/soc/blackfin/Makefile
@@ -21,6 +21,7 @@ snd-ad1980-objs := bf5xx-ad1980.o
 snd-ssm2602-objs := bf5xx-ssm2602.o
 snd-ad73311-objs := bf5xx-ad73311.o
 snd-ad193x-objs := bf5xx-ad193x.o
+snd-soc-bfin-eval-adau1373-objs := bfin-eval-adau1373.o
 snd-soc-bfin-eval-adau1701-objs := bfin-eval-adau1701.o
 snd-soc-bfin-eval-adav80x-objs := bfin-eval-adav80x.o
 
@@ -29,5 +30,6 @@ obj-$(CONFIG_SND_BF5XX_SOC_AD1980) += snd-ad1980.o
 obj-$(CONFIG_SND_BF5XX_SOC_SSM2602) += snd-ssm2602.o
 obj-$(CONFIG_SND_BF5XX_SOC_AD73311) += snd-ad73311.o
 obj-$(CONFIG_SND_BF5XX_SOC_AD193X) += snd-ad193x.o
+obj-$(CONFIG_SND_SOC_BFIN_EVAL_ADAU1373) += snd-soc-bfin-eval-adau1373.o
 obj-$(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701) += snd-soc-bfin-eval-adau1701.o
 obj-$(CONFIG_SND_SOC_BFIN_EVAL_ADAV80X) += snd-soc-bfin-eval-adav80x.o
diff --git a/sound/soc/blackfin/bfin-eval-adau1373.c b/sound/soc/blackfin/bfin-eval-adau1373.c
new file mode 100644
index 0000000..8df2a3b
--- /dev/null
+++ b/sound/soc/blackfin/bfin-eval-adau1373.c
@@ -0,0 +1,202 @@
+/*
+ * Machine driver for EVAL-ADAU1373 on Analog Devices bfin
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
+#include "../codecs/adau1373.h"
+
+static const struct snd_soc_dapm_widget bfin_eval_adau1373_dapm_widgets[] = {
+	SND_SOC_DAPM_LINE("Line In1", NULL),
+	SND_SOC_DAPM_LINE("Line In2", NULL),
+	SND_SOC_DAPM_LINE("Line In3", NULL),
+	SND_SOC_DAPM_LINE("Line In4", NULL),
+
+	SND_SOC_DAPM_LINE("Line Out1", NULL),
+	SND_SOC_DAPM_LINE("Line Out2", NULL),
+	SND_SOC_DAPM_LINE("Stereo Out", NULL),
+	SND_SOC_DAPM_HP("Headphone", NULL),
+	SND_SOC_DAPM_HP("Earpiece", NULL),
+	SND_SOC_DAPM_SPK("Speaker", NULL),
+};
+
+static const struct snd_soc_dapm_route bfin_eval_adau1373_dapm_routes[] = {
+	{ "AIN1L", NULL, "Line In1" },
+	{ "AIN1R", NULL, "Line In1" },
+	{ "AIN2L", NULL, "Line In2" },
+	{ "AIN2R", NULL, "Line In2" },
+	{ "AIN3L", NULL, "Line In3" },
+	{ "AIN3R", NULL, "Line In3" },
+	{ "AIN4L", NULL, "Line In4" },
+	{ "AIN4R", NULL, "Line In4" },
+
+	/* MICBIAS can be connected via a jumper to the line-in jack, since w
+	   don't know which one is going to be used, just power both. */
+	{ "Line In1", NULL, "MICBIAS1" },
+	{ "Line In2", NULL, "MICBIAS1" },
+	{ "Line In3", NULL, "MICBIAS1" },
+	{ "Line In4", NULL, "MICBIAS1" },
+	{ "Line In1", NULL, "MICBIAS2" },
+	{ "Line In2", NULL, "MICBIAS2" },
+	{ "Line In3", NULL, "MICBIAS2" },
+	{ "Line In4", NULL, "MICBIAS2" },
+
+	{ "Line Out1", NULL, "LOUT1L" },
+	{ "Line Out1", NULL, "LOUT1R" },
+	{ "Line Out2", NULL, "LOUT2L" },
+	{ "Line Out2", NULL, "LOUT2R" },
+	{ "Headphone", NULL, "HPL" },
+	{ "Headphone", NULL, "HPR" },
+	{ "Earpiece", NULL, "EP" },
+	{ "Speaker", NULL, "SPKL" },
+	{ "Stereo Out", NULL, "SPKR" },
+};
+
+static int bfin_eval_adau1373_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	int ret;
+	int pll_rate;
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
+	switch (params_rate(params)) {
+	case 48000:
+	case 8000:
+	case 12000:
+	case 16000:
+	case 24000:
+	case 32000:
+		pll_rate = 48000 * 1024;
+		break;
+	case 44100:
+	case 7350:
+	case 11025:
+	case 14700:
+	case 22050:
+	case 29400:
+		pll_rate = 44100 * 1024;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = snd_soc_dai_set_pll(codec_dai, ADAU1373_PLL1,
+			ADAU1373_PLL_SRC_MCLK1, 12288000, pll_rate);
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dai_set_sysclk(codec_dai, ADAU1373_CLK_SRC_PLL1, pll_rate,
+			SND_SOC_CLOCK_IN);
+
+	return ret;
+}
+
+static int bfin_eval_adau1373_codec_init(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	unsigned int pll_rate = 48000 * 1024;
+	int ret;
+
+	ret = snd_soc_dai_set_pll(codec_dai, ADAU1373_PLL1,
+			ADAU1373_PLL_SRC_MCLK1, 12288000, pll_rate);
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dai_set_sysclk(codec_dai, ADAU1373_CLK_SRC_PLL1, pll_rate,
+			SND_SOC_CLOCK_IN);
+
+	return ret;
+}
+static struct snd_soc_ops bfin_eval_adau1373_ops = {
+	.hw_params = bfin_eval_adau1373_hw_params,
+};
+
+static struct snd_soc_dai_link bfin_eval_adau1373_dai = {
+	.name = "adau1373",
+	.stream_name = "adau1373",
+	.cpu_dai_name = "bfin-i2s.0",
+	.codec_dai_name = "adau1373-aif1",
+	.platform_name = "bfin-i2s-pcm-audio",
+	.codec_name = "adau1373.0-001a",
+	.ops = &bfin_eval_adau1373_ops,
+	.init = bfin_eval_adau1373_codec_init,
+};
+
+static struct snd_soc_card bfin_eval_adau1373 = {
+	.name = "bfin-eval-adau1373",
+	.dai_link = &bfin_eval_adau1373_dai,
+	.num_links = 1,
+
+	.dapm_widgets		= bfin_eval_adau1373_dapm_widgets,
+	.num_dapm_widgets	= ARRAY_SIZE(bfin_eval_adau1373_dapm_widgets),
+	.dapm_routes		= bfin_eval_adau1373_dapm_routes,
+	.num_dapm_routes	= ARRAY_SIZE(bfin_eval_adau1373_dapm_routes),
+};
+
+static int bfin_eval_adau1373_probe(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = &bfin_eval_adau1373;
+
+	card->dev = &pdev->dev;
+
+	return snd_soc_register_card(&bfin_eval_adau1373);
+}
+
+static int __devexit bfin_eval_adau1373_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
+
+	return 0;
+}
+
+static struct platform_driver bfin_eval_adau1373_driver = {
+	.driver = {
+		.name = "bfin-eval-adau1373",
+		.owner = THIS_MODULE,
+		.pm = &snd_soc_pm_ops,
+	},
+	.probe = bfin_eval_adau1373_probe,
+	.remove = __devexit_p(bfin_eval_adau1373_remove),
+};
+
+static int __init bfin_eval_adau1373_init(void)
+{
+	return platform_driver_register(&bfin_eval_adau1373_driver);
+}
+module_init(bfin_eval_adau1373_init);
+
+static void __exit bfin_eval_adau1373_exit(void)
+{
+	platform_driver_unregister(&bfin_eval_adau1373_driver);
+}
+module_exit(bfin_eval_adau1373_exit);
+
+MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
+MODULE_DESCRIPTION("ALSA SoC bfin adau1373 driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:bfin-eval-adau1373");
-- 
1.7.2.5

