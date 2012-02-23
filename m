Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2BWFr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 00:47:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55837 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab2BWFrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 00:47:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.68.129.162 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH v5] sound/soc/lapis: add machine driver for ML7213 Carrier Board
Date: Thu, 23 Feb 2012 14:46:51 +0900
Message-Id: <1329976011-2251-3-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This machine driver is for LAPIS Semiconductor ML7213 Carrier Board.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V5
 - Add channe_map function
 - Use error macro (e.g. -ENOMEM) not negative integer value
 - Add clock configuration for codec
---
 sound/soc/lapis/Kconfig             |    5 +
 sound/soc/lapis/Makefile            |    2 +
 sound/soc/lapis/ml7213ioh-machine.c |  209 +++++++++++++++++++++++++++++++++++
 3 files changed, 216 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/lapis/ml7213ioh-machine.c

diff --git a/sound/soc/lapis/Kconfig b/sound/soc/lapis/Kconfig
index 551e385..e869e0c 100644
--- a/sound/soc/lapis/Kconfig
+++ b/sound/soc/lapis/Kconfig
@@ -2,3 +2,8 @@ config SND_SOC_ML7213_PLATFORM
 	tristate "ML7213 IOH ASoC platform driver"
 	help
 	  This option enables support for the AC Link Controllers in ML7213 IOH SoC.
+config SND_SOC_ML7213_MACHINE
+	tristate "ML7213 IOH ASoC machine driver"
+	select SND_SOC_ML7213_PLATFORM
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
index 0000000..9fa9e5a
--- /dev/null
+++ b/sound/soc/lapis/ml7213ioh-machine.c
@@ -0,0 +1,209 @@
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
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS0, bclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS1, bclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS2, bclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS3, bclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS4, bclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_BCLKFS5, bclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS0, mclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS1, mclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS2, mclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS3, mclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS4, mclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(cpu_dai, ML7213IOH_MCLKFS5, mclkfs);
+	if (ret < 0)
+		return ret;
+
+	ret = snd_soc_dai_set_clkdiv(codec_dai, ML26124_MCLK, ML26124_USE_PLL);
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
+static struct snd_soc_dai_link ioh_i2s_dai = {
+	.name = "ml26124",
+	.stream_name = "ML26124",
+	.cpu_dai_name = "ml7213ioh",
+	.codec_dai_name = "ml26124-hifi",
+	.platform_name	= "ml7213-i2s-audio",
+	.codec_name	= "ml26124-codec.1-001a",
+	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
+					SND_SOC_DAIFMT_CBM_CFM,
+	.ops = &ml7213_ops,
+};
+
+static struct snd_soc_card ioh_i2s_card = {
+	.name		= "LAPIS Semiconductor ML7213CRB",
+	.dai_link	= &ioh_i2s_dai,
+	.num_links	= 1,
+	.dapm_widgets	= ml7213_dapm_widgets,
+	.num_dapm_widgets	= ARRAY_SIZE(ml7213_dapm_widgets),
+	.dapm_routes	= ml7213_routes,
+	.num_dapm_routes	= ARRAY_SIZE(ml7213_routes),
+};
+
+static struct platform_device *ioh_snd_device;
+
+
+static int __init ioh_i2s_init(void)
+{
+	int ret;
+	ioh_snd_device = platform_device_alloc("soc-audio", -1);
+	if (!ioh_snd_device)
+		return -ENOMEM;
+
+	platform_set_drvdata(ioh_snd_device, &ioh_i2s_card);
+	ret = platform_device_add(ioh_snd_device);
+
+	if (ret) {
+		printk(KERN_ERR"%s: error out:\n", __func__);
+		platform_device_put(ioh_snd_device);
+		return -1;
+	}
+
+	return 0;
+}
+
+static void __exit ioh_i2s_exit(void)
+{
+	return platform_device_unregister(ioh_snd_device);
+}
+
+module_init(ioh_i2s_init);
+module_exit(ioh_i2s_exit);
+
+MODULE_AUTHOR("Tomoya MORINAGA <tomoya.rohm@gmail.com>");
+MODULE_DESCRIPTION("LAPIS Semiconductor ML7213 IOH ALSA SoC machine driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform: ml7213ioh-i2s");
-- 
1.7.7.6

