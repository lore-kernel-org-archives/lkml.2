Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab2CIGi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 01:38:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57691 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2CIGi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 01:38:58 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH v6] sound/soc/lapis: add machine driver for ML7213 Carrier Board
Date: Fri,  9 Mar 2012 15:38:11 +0900
Message-Id: <1331275091-31700-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <CANKRQngTNWMGswq3weD1s8O4irVEz+DCr1vzi2gnWaQcoq5SEw@mail.gmail.com>
References: <CANKRQngTNWMGswq3weD1s8O4irVEz+DCr1vzi2gnWaQcoq5SEw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This machine driver is for LAPIS Semiconductor ML7213 Carrier Board.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V6
 - Add master/slave settings
 - Use snd_soc_register_card
 - Move set_clkdiv to dai_hw_params
---
 sound/soc/lapis/Kconfig             |    7 ++
 sound/soc/lapis/Makefile            |    2 +
 sound/soc/lapis/ml7213ioh-machine.c |  179 +++++++++++++++++++++++++++++++++++
 3 files changed, 188 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/lapis/ml7213ioh-machine.c

diff --git a/sound/soc/lapis/Kconfig b/sound/soc/lapis/Kconfig
index 551e385..9bc1b4d 100644
--- a/sound/soc/lapis/Kconfig
+++ b/sound/soc/lapis/Kconfig
@@ -2,3 +2,10 @@ config SND_SOC_ML7213_PLATFORM
 	tristate "ML7213 IOH ASoC platform driver"
 	help
 	  This option enables support for the AC Link Controllers in ML7213 IOH SoC.
+
+config SND_SOC_ML7213_MACHINE
+	tristate "ML7213 IOH ASoC machine driver"
+	select SND_SOC_ML7213_PLATFORM
+	select SND_SOC_ML26124
+	help
+	  This is ASoC machine driver for ML7213 IOH
diff --git a/sound/soc/lapis/Makefile b/sound/soc/lapis/Makefile
index aba1630..7ec4bea 100644
--- a/sound/soc/lapis/Makefile
+++ b/sound/soc/lapis/Makefile
@@ -1,4 +1,6 @@
 # Platform
+snd-soc-ml7213-machine-objs := ml7213ioh-machine.o
 snd-soc-ml7213-plat-objs := ml7213ioh-plat.o
 
 obj-$(CONFIG_SND_SOC_ML7213_PLATFORM) += snd-soc-ml7213-plat.o
+obj-$(CONFIG_SND_SOC_ML7213_MACHINE) += snd-soc-ml7213-machine.o
diff --git a/sound/soc/lapis/ml7213ioh-machine.c b/sound/soc/lapis/ml7213ioh-machine.c
new file mode 100644
index 0000000..eab7e70
--- /dev/null
+++ b/sound/soc/lapis/ml7213ioh-machine.c
@@ -0,0 +1,179 @@
+/*
+ * ml7213ioh-machine.c -- SoC Audio for LAPIS Semiconductor ML7213 IOH CRB
+ *
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/soc.h>
+#include <sound/pcm_params.h>
+#include <linux/i2c.h>
+#include "../codecs/ml26124.h"
+#include "ioh_i2s.h"
+
+static const struct snd_soc_dapm_widget ml7213_dapm_widgets[] = {
+	SND_SOC_DAPM_SPK("Speaker", NULL),
+	SND_SOC_DAPM_LINE("LINEOUT", NULL),
+	SND_SOC_DAPM_LINE("LINEIN", NULL),
+	SND_SOC_DAPM_MIC("AnalogMIC", NULL),
+	SND_SOC_DAPM_MIC("DigitalMIC", NULL),
+};
+
+static const struct snd_soc_dapm_route ml7213_routes[] = {
+	{"Speaker", NULL, "SPOUT"},
+	{"LINEOUT", NULL, "LOUT"},
+	{"MIN", NULL, "AnalogMIC"},
+	{"MDIN", NULL, "DigitalMIC"},
+	{"MIN", NULL, "LINEIN"},
+};
+
+static int ml7213_hw_params(struct snd_pcm_substream *substream,
+			    struct snd_pcm_hw_params *hw_params)
+{
+	int bclkfs;
+	int mclkfs;
+	unsigned int clk;
+	int ret;
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
+	unsigned int channel_map[] = {5, 0, 1, 2, 3, 4};
+
+	/* set cpu DAI channel mapping */
+	ret = snd_soc_dai_set_channel_map(cpu_dai, ARRAY_SIZE(channel_map),
+		channel_map, ARRAY_SIZE(channel_map), channel_map);
+	if (ret < 0)
+		return ret;
+
+	switch (params_rate(hw_params)) {
+	case 16000:
+	case 32000:
+	case 48000:
+		clk = 12288000;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	mclkfs = clk / params_rate(hw_params);
+
+	switch (params_format(hw_params)) {
+	case SNDRV_PCM_FORMAT_U8:
+	case SNDRV_PCM_FORMAT_S16_LE:
+		bclkfs = 32;
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		bclkfs = 64;
+		break;
+	default:
+		pr_err("%s: Failed not support format\n", __func__);
+		return -EINVAL;
+		break;
+	}
+
+	/* set the codec system clock for DAC and ADC */
+	ret = snd_soc_dai_set_sysclk(codec_dai, ML26124_USE_PLL, clk,
+				     SND_SOC_CLOCK_IN);
+	if (ret < 0)
+		return ret;
+
+	/* set codec DAI configuration */
+	ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
+				 SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
+	if (ret < 0)
+		return ret;
+
+	/* set cpu DAI configuration */
+	ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S |
+				 SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static struct snd_soc_ops ml7213_ops = {
+	.hw_params = ml7213_hw_params,
+};
+
+static struct snd_soc_dai_link ml7213crb_dai = {
+	.name = "ml26124",
+	.stream_name = "ML26124",
+	.cpu_dai_name = "ml7213ioh",
+	.codec_dai_name = "ml26124-hifi",
+	.platform_name	= "ml7213-i2s-audio",
+	.codec_name	= "ml26124.1-001a",
+	.ops = &ml7213_ops,
+};
+
+static struct snd_soc_card ml7213crb_card = {
+	.name		= "LAPIS Semiconductor ML7213CRB",
+	.dai_link	= &ml7213crb_dai,
+	.num_links	= 1,
+	.dapm_widgets	= ml7213_dapm_widgets,
+	.num_dapm_widgets	= ARRAY_SIZE(ml7213_dapm_widgets),
+	.dapm_routes	= ml7213_routes,
+	.num_dapm_routes	= ARRAY_SIZE(ml7213_routes),
+};
+
+static int __devinit lapis_ml7213_ml26124_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	ml7213crb_card.dev = &pdev->dev;
+	ret = snd_soc_register_card(&ml7213crb_card);
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card failed %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int __devexit lapis_ml7213_ml26124_remove(struct platform_device *pdev)
+{
+	snd_soc_unregister_card(&ml7213crb_card);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver snd_ml7213crb_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "lapis-ml7213ioh-CRB",
+	},
+	.probe = lapis_ml7213_ml26124_probe,
+	.remove = __devexit_p(lapis_ml7213_ml26124_remove),
+};
+
+static int __init lapis_ml7213_ml26124_init(void)
+{
+	return platform_driver_register(&snd_ml7213crb_driver);
+}
+module_init(lapis_ml7213_ml26124_init);
+
+static void __exit lapis_ml7213_ml26124_exit(void)
+{
+	platform_driver_unregister(&snd_ml7213crb_driver);
+}
+module_exit(lapis_ml7213_ml26124_exit);
+
+MODULE_AUTHOR("Tomoya MORINAGA <tomoya.rohm@gmail.com>");
+MODULE_DESCRIPTION("LAPIS Semiconductor ML7213 IOH ALSA SoC machine driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform: lapis-ml7213ioh-CRB");
-- 
1.7.7.6

