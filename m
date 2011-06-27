Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab1F0PFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:05:42 -0400
Received: from smtp-out-056.synserver.de ([212.40.185.56]:1052 "HELO
	smtp-out-056.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751118Ab1F0PFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:05:25 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 21528
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 2/3] ASoC: Blackfin: Add machine driver for EVAL-ADAV80X boards
Date: Mon, 27 Jun 2011 17:04:02 +0200
Message-Id: <1309187043-30914-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309187043-30914-1-git-send-email-lars@metafoo.de>
References: <1309187043-30914-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a machine driver to support the EVAL-ADAV801 and EVAL-ADAV803 boards
connected to a Analog Devices BF5XX evaluation board.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/blackfin/Kconfig             |   13 +++
 sound/soc/blackfin/Makefile            |    2 +
 sound/soc/blackfin/bfin-eval-adav80x.c |  173 ++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/blackfin/bfin-eval-adav80x.c

diff --git a/sound/soc/blackfin/Kconfig b/sound/soc/blackfin/Kconfig
index fa6a6d2..fe9d548 100644
--- a/sound/soc/blackfin/Kconfig
+++ b/sound/soc/blackfin/Kconfig
@@ -27,6 +27,19 @@ config SND_SOC_BFIN_EVAL_ADAU1701
 	  board connected to one of the Blackfin evaluation boards like the
 	  BF5XX-STAMP or BF5XX-EZKIT.
 
+config SND_SOC_BFIN_EVAL_ADAV80X
+	tristate "Support for the EVAL-ADAV80X boards on Blackfin eval boards"
+	depends on SND_BF5XX_I2S && (SPI_MASTER || I2C)
+	select SND_BF5XX_SOC_I2S
+	select SND_SOC_ADAV80X
+	help
+	  Say Y if you want to add support for the Analog Devices EVAL-ADAV801 or
+	  EVAL-ADAV803 board connected to one of the Blackfin evaluation boards
+	  like the BF5XX-STAMP or BF5XX-EZKIT.
+
+	  Note: This driver assumes that the ADAV80X digital record and playback
+	  interfaces are connected to the first SPORT port on the BF5XX board.
+
 config SND_BF5XX_SOC_AD73311
 	tristate "SoC AD73311 Audio support for Blackfin"
 	depends on SND_BF5XX_I2S
diff --git a/sound/soc/blackfin/Makefile b/sound/soc/blackfin/Makefile
index f01bff6..6018bf5 100644
--- a/sound/soc/blackfin/Makefile
+++ b/sound/soc/blackfin/Makefile
@@ -22,6 +22,7 @@ snd-ssm2602-objs := bf5xx-ssm2602.o
 snd-ad73311-objs := bf5xx-ad73311.o
 snd-ad193x-objs := bf5xx-ad193x.o
 snd-soc-bfin-eval-adau1701-objs := bfin-eval-adau1701.o
+snd-soc-bfin-eval-adav80x-objs := bfin-eval-adav80x.o
 
 obj-$(CONFIG_SND_BF5XX_SOC_AD1836) += snd-ad1836.o
 obj-$(CONFIG_SND_BF5XX_SOC_AD1980) += snd-ad1980.o
@@ -29,3 +30,4 @@ obj-$(CONFIG_SND_BF5XX_SOC_SSM2602) += snd-ssm2602.o
 obj-$(CONFIG_SND_BF5XX_SOC_AD73311) += snd-ad73311.o
 obj-$(CONFIG_SND_BF5XX_SOC_AD193X) += snd-ad193x.o
 obj-$(CONFIG_SND_SOC_BFIN_EVAL_ADAU1701) += snd-soc-bfin-eval-adau1701.o
+obj-$(CONFIG_SND_SOC_BFIN_EVAL_ADAV80X) += snd-soc-bfin-eval-adav80x.o
diff --git a/sound/soc/blackfin/bfin-eval-adav80x.c b/sound/soc/blackfin/bfin-eval-adav80x.c
new file mode 100644
index 0000000..8d014d0
--- /dev/null
+++ b/sound/soc/blackfin/bfin-eval-adav80x.c
@@ -0,0 +1,173 @@
+/*
+ * Machine driver for EVAL-ADAV801 and EVAL-ADAV803 on Analog Devices bfin
+ * evaluation boards.
+ *
+ * Copyright 2011 Analog Devices Inc.
+ * Author: Lars-Peter Clausen <lars@metafoo.de>
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/soc.h>
+
+#include "../codecs/adav80x.h"
+
+static const struct snd_soc_dapm_widget bfin_eval_adav80x_dapm_widgets[] = {
+	SND_SOC_DAPM_LINE("Line Out", NULL),
+	SND_SOC_DAPM_LINE("Line In", NULL),
+};
+
+static const struct snd_soc_dapm_route bfin_eval_adav80x_dapm_routes[] = {
+	{ "Line Out", NULL, "VOUTL" },
+	{ "Line Out", NULL, "VOUTR" },
+
+	{ "VINL", NULL, "Line In" },
+	{ "VINR", NULL, "Line In" },
+};
+
+static int bfin_eval_adav80x_hw_params(struct snd_pcm_substream *substream,
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
+	ret = snd_soc_dai_set_pll(codec_dai, ADAV80X_PLL1, ADAV80X_PLL_SRC_XTAL,
+			27000000, params_rate(params) * 256);
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dai_set_sysclk(codec_dai, ADAV80X_CLK_PLL1,
+			params_rate(params) * 256, SND_SOC_CLOCK_IN);
+
+	return ret;
+}
+
+static int bfin_eval_adav80x_codec_init(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+
+	snd_soc_dai_set_sysclk(codec_dai, ADAV80X_CLK_SYSCLK1, 0,
+	    SND_SOC_CLOCK_OUT);
+	snd_soc_dai_set_sysclk(codec_dai, ADAV80X_CLK_SYSCLK2, 0,
+	    SND_SOC_CLOCK_OUT);
+	snd_soc_dai_set_sysclk(codec_dai, ADAV80X_CLK_SYSCLK3, 0,
+	    SND_SOC_CLOCK_OUT);
+
+	snd_soc_dai_set_sysclk(codec_dai, ADAV80X_CLK_XTAL, 2700000, 0);
+
+	return 0;
+}
+
+static struct snd_soc_ops bfin_eval_adav80x_ops = {
+	.hw_params = bfin_eval_adav80x_hw_params,
+};
+
+static struct snd_soc_dai_link bfin_eval_adav80x_dais[] = {
+	{
+		.name = "adav80x",
+		.stream_name = "ADAV80x HiFi",
+		.cpu_dai_name = "bfin-i2s.0",
+		.codec_dai_name = "adav80x-hifi",
+		.platform_name = "bfin-i2s-pcm-audio",
+		.init = bfin_eval_adav80x_codec_init,
+		.ops = &bfin_eval_adav80x_ops,
+	},
+};
+
+static struct snd_soc_card bfin_eval_adav80x = {
+	.name = "bfin-eval-adav80x",
+	.dai_link = bfin_eval_adav80x_dais,
+	.num_links = ARRAY_SIZE(bfin_eval_adav80x_dais),
+
+	.dapm_widgets		= bfin_eval_adav80x_dapm_widgets,
+	.num_dapm_widgets	= ARRAY_SIZE(bfin_eval_adav80x_dapm_widgets),
+	.dapm_routes		= bfin_eval_adav80x_dapm_routes,
+	.num_dapm_routes	= ARRAY_SIZE(bfin_eval_adav80x_dapm_routes),
+};
+
+enum bfin_eval_adav80x_type {
+	BFIN_EVAL_ADAV801,
+	BFIN_EVAL_ADAV803,
+};
+
+static int bfin_eval_adav80x_probe(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = &bfin_eval_adav80x;
+	const char *codec_name;
+
+	switch (platform_get_device_id(pdev)->driver_data) {
+	case BFIN_EVAL_ADAV801:
+		codec_name = "spi0.1";
+		break;
+	case BFIN_EVAL_ADAV803:
+		codec_name = "adav803.0-0034";
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	bfin_eval_adav80x_dais[0].codec_name = codec_name;
+
+	card->dev = &pdev->dev;
+
+	return snd_soc_register_card(&bfin_eval_adav80x);
+}
+
+static int __devexit bfin_eval_adav80x_remove(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
+	snd_soc_unregister_card(card);
+
+	return 0;
+}
+
+static const struct platform_device_id bfin_eval_adav80x_ids[] = {
+	{ "bfin-eval-adav801", BFIN_EVAL_ADAV801 },
+	{ "bfin-eval-adav803", BFIN_EVAL_ADAV803 },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, bfin_eval_adav80x_ids);
+
+static struct platform_driver bfin_eval_adav80x_driver = {
+	.driver = {
+		.name = "bfin-eval-adav80x",
+		.owner = THIS_MODULE,
+		.pm = &snd_soc_pm_ops,
+	},
+	.probe = bfin_eval_adav80x_probe,
+	.remove = __devexit_p(bfin_eval_adav80x_remove),
+	.id_table = bfin_eval_adav80x_ids,
+};
+
+static int __init bfin_eval_adav80x_init(void)
+{
+	return platform_driver_register(&bfin_eval_adav80x_driver);
+}
+module_init(bfin_eval_adav80x_init);
+
+static void __exit bfin_eval_adav80x_exit(void)
+{
+	platform_driver_unregister(&bfin_eval_adav80x_driver);
+}
+module_exit(bfin_eval_adav80x_exit);
+
+MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
+MODULE_DESCRIPTION("ALSA SoC bfin adav80x driver");
+MODULE_LICENSE("GPL");
-- 
1.7.2.5

