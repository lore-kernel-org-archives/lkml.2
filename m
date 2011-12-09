Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1LILFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:05:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62093 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1LILFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:05:47 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH v3] sound/soc/lapis: add machine driver v3 updated
Date: Fri,  9 Dec 2011 20:03:52 +0900
Message-Id: <1323428632-29309-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V3 Update Mark's comments
 - Delete i2c_board_info data structure.
 - Delete i2c_new_device/i2c_put_adapter.
 - Delete .startup method.
 - Add error processing for failure of snd_soc_unregister_card.
 - Add MODULE_ALIAS
 - Change platform_driver name
 - Set to .dai_fmt of snd_soc_dai_link not use snd_soc_dai_set_fmt
---
 sound/soc/Kconfig                   |    1 +
 sound/soc/Makefile                  |    1 +
 sound/soc/lapis/Kconfig             |    5 +
 sound/soc/lapis/Makefile            |    5 +
 sound/soc/lapis/ml7213ioh-machine.c |  158 +++++++++++++++++++++++++++++++++++
 5 files changed, 170 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/lapis/Kconfig
 create mode 100644 sound/soc/lapis/Makefile
 create mode 100644 sound/soc/lapis/ml7213ioh-machine.c

diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 35e662d..63f8582 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -34,6 +34,7 @@ source "sound/soc/ep93xx/Kconfig"
 source "sound/soc/fsl/Kconfig"
 source "sound/soc/imx/Kconfig"
 source "sound/soc/jz4740/Kconfig"
+source "sound/soc/lapis/Kconfig"
 source "sound/soc/nuc900/Kconfig"
 source "sound/soc/omap/Kconfig"
 source "sound/soc/kirkwood/Kconfig"
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index 9ea8ac8..002951f 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_SND_SOC)	+= ep93xx/
 obj-$(CONFIG_SND_SOC)	+= fsl/
 obj-$(CONFIG_SND_SOC)   += imx/
 obj-$(CONFIG_SND_SOC)	+= jz4740/
+obj-$(CONFIG_SND_SOC)   += lapis/
 obj-$(CONFIG_SND_SOC)	+= mid-x86/
 obj-$(CONFIG_SND_SOC)	+= mxs/
 obj-$(CONFIG_SND_SOC)	+= nuc900/
diff --git a/sound/soc/lapis/Kconfig b/sound/soc/lapis/Kconfig
new file mode 100644
index 0000000..f6c2fe5
--- /dev/null
+++ b/sound/soc/lapis/Kconfig
@@ -0,0 +1,5 @@
+config SND_SOC_ML7213_MACHINE
+	tristate "ML7213 IOH ASoC machine driver"
+	select SND_SOC_ML7213_PLATFORM
+	help
+	  This is ASoC machine driver for ML7213 IOH
diff --git a/sound/soc/lapis/Makefile b/sound/soc/lapis/Makefile
new file mode 100644
index 0000000..3560bd7
--- /dev/null
+++ b/sound/soc/lapis/Makefile
@@ -0,0 +1,5 @@
+# Platform
+snd-soc-ml7213-machine-objs := ml7213ioh-machine.o
+
+obj-$(CONFIG_SND_SOC_ML7213_PLATFORM) += snd-soc-ml7213-machine.o
+
diff --git a/sound/soc/lapis/ml7213ioh-machine.c b/sound/soc/lapis/ml7213ioh-machine.c
new file mode 100644
index 0000000..28e7919
--- /dev/null
+++ b/sound/soc/lapis/ml7213ioh-machine.c
@@ -0,0 +1,158 @@
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
+#include <linux/i2c.h>
+#include "../codecs/ml26124.h"
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
+static int ml7213_ioh_init(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_soc_codec *codec = rtd->codec;
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
+
+	snd_soc_dapm_new_controls(dapm, ml7213_dapm_widgets,
+				  ARRAY_SIZE(ml7213_dapm_widgets));
+
+	snd_soc_dapm_add_routes(dapm, ml7213_routes, ARRAY_SIZE(ml7213_routes));
+	snd_soc_dapm_sync(dapm);
+
+	return 0;
+}
+
+static int ml7213_hw_params(struct snd_pcm_substream *substream,
+			    struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	unsigned int clk = 0;
+	int ret = 0;
+
+	switch (params_rate(params)) {
+	case 16000:
+	case 32000:
+	case 48000:
+		clk = 12288800;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* set the codec system clock for DAC and ADC */
+	ret = snd_soc_dai_set_sysclk(codec_dai, ML26124_USE_PLL, clk,
+				     SND_SOC_CLOCK_IN);
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
+	.name = "ML7213",
+	.stream_name = "I2S HiFi",
+	.cpu_dai_name = "ml7213-i2s",
+	.codec_dai_name = "ml26124-hifi",
+	.platform_name	= "ml7213-i2s-pcm-audio",
+	.codec_name	= "ml26124-00GD",
+	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
+					SND_SOC_DAIFMT_CBS_CFS,
+	.init = ml7213_ioh_init,
+	.ops = &ml7213_ops,
+};
+
+static struct snd_soc_card ioh_i2s_card = {
+	.name		= "ml7213",
+	.dai_link	= &ioh_i2s_dai,
+	.num_links	= 1,
+	.dapm_widgets	= ml7213_dapm_widgets,
+	.num_dapm_widgets	= ARRAY_SIZE(ml7213_dapm_widgets),
+	.dapm_routes	= ml7213_routes,
+	.num_dapm_routes	= ARRAY_SIZE(ml7213_routes),
+};
+
+static int __init ioh_i2s_probe(struct platform_device *pdev)
+{
+	ioh_i2s_card.dev = &pdev->dev;
+	snd_soc_register_card(&ioh_i2s_card);
+
+	return 0;
+}
+
+static int __exit ioh_i2s_remove(struct platform_device *pdev)
+{
+	int ret = snd_soc_unregister_card(&ioh_i2s_card);
+
+	if (ret) {
+		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", ret);
+		ioh_i2s_card.dev = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct platform_driver ioh_i2s_driver = {
+	.remove = ioh_i2s_remove,
+	.driver = {
+		.name = "ml7213ioh-i2s",
+		.owner = THIS_MODULE,
+	},
+	.probe	= ioh_i2s_probe,
+	.remove	= __devexit_p(ioh_i2s_remove),
+};
+
+static int __init ioh_i2s_init(void)
+{
+	return platform_driver_register(&ioh_i2s_driver);
+}
+
+static void __exit ioh_i2s_exit(void)
+{
+	return platform_driver_unregister(&ioh_i2s_driver);
+}
+
+module_init(ioh_i2s_init);
+module_exit(ioh_i2s_exit);
+
+MODULE_AUTHOR("Tomoya MORINAGA <tomoya.rohm@gmail.com>");
+MODULE_DESCRIPTION("LAPIS Semiconductor ML7213 IOH ALSA SoC machine driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ml7213ioh-i2s");
-- 
1.7.4.4

