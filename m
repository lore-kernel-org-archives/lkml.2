Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1LBJqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:46:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40274 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab1LBJqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:46:04 -0500
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
Subject: [PATCH v2] soc/lapis: add machine driver
Date: Fri,  2 Dec 2011 18:45:15 +0900
Message-Id: <1322819115-15808-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add machine driver for LAPIS Semiconductor ML7213 IOH.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V2: Updates Mark's comments.
 - Sorted in Makefile and Kconfig position
 - Import I2C configuration processing from CODEC driver
 - Add widget and route map
 - Add initialization processing (ml26124_set_dai_sysclk)
 - Modify codec_dai_name settins
 - Use snd_soc_register_card not platform_device_alloc
 - Use return platform_driver_register not platform_driver_probe
---
 sound/soc/Kconfig                   |    1 +
 sound/soc/Makefile                  |    1 +
 sound/soc/lapis/Kconfig             |    6 +
 sound/soc/lapis/Makefile            |    4 +
 sound/soc/lapis/ml7213ioh-machine.c |  197 +++++++++++++++++++++++++++++++++++
 5 files changed, 209 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/lapis/Kconfig
 create mode 100644 sound/soc/lapis/Makefile
 create mode 100644 sound/soc/lapis/ml7213ioh-machine.c

diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 1381db8..e8339e6 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -52,6 +52,7 @@ source "sound/soc/jz4740/Kconfig"
 source "sound/soc/nuc900/Kconfig"
 source "sound/soc/omap/Kconfig"
 source "sound/soc/kirkwood/Kconfig"
+source "sound/soc/lapis/Kconfig"
 source "sound/soc/mid-x86/Kconfig"
 source "sound/soc/mxs/Kconfig"
 source "sound/soc/pxa/Kconfig"
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index 9ea8ac8..9592f41 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_SND_SOC)	+= ep93xx/
 obj-$(CONFIG_SND_SOC)	+= fsl/
 obj-$(CONFIG_SND_SOC)   += imx/
 obj-$(CONFIG_SND_SOC)	+= jz4740/
+obj-$(CONFIG_SND_SOC)	+= lapis/
 obj-$(CONFIG_SND_SOC)	+= mid-x86/
 obj-$(CONFIG_SND_SOC)	+= mxs/
 obj-$(CONFIG_SND_SOC)	+= nuc900/
diff --git a/sound/soc/lapis/Kconfig b/sound/soc/lapis/Kconfig
new file mode 100644
index 0000000..1bd5200
--- /dev/null
+++ b/sound/soc/lapis/Kconfig
@@ -0,0 +1,6 @@
+config SND_SOC_ML7213_MACHINE
+	tristate "ML7213 IOH ASoC machine driver"
+	depends on SND_SOC_TXX9ACLC
+	select SND_SOC_ML7213_PLATFORM
+	help
+	  This is ASoC machine driver for ML7213 IOH
diff --git a/sound/soc/lapis/Makefile b/sound/soc/lapis/Makefile
new file mode 100644
index 0000000..468d922
--- /dev/null
+++ b/sound/soc/lapis/Makefile
@@ -0,0 +1,4 @@
+# Platform
+snd-soc-ml7213-machine-objs := ml7213ioh-machine.o
+
+obj-$(CONFIG_SND_SOC_ML7213_MACHINE) += snd-soc-ml7213-plat.o
diff --git a/sound/soc/lapis/ml7213ioh-machine.c b/sound/soc/lapis/ml7213ioh-machine.c
new file mode 100644
index 0000000..9e4690e
--- /dev/null
+++ b/sound/soc/lapis/ml7213ioh-machine.c
@@ -0,0 +1,197 @@
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
+#define CODEC_DEV_ADDR 0x1A
+static struct i2c_board_info ioh_hwmon_info[] = {
+	{I2C_BOARD_INFO("ioh_i2c-0", CODEC_DEV_ADDR + 1)},
+	{I2C_BOARD_INFO("ioh_i2c-1", CODEC_DEV_ADDR + 2)},
+	{I2C_BOARD_INFO("ioh_i2c-2", CODEC_DEV_ADDR + 3)},
+	{I2C_BOARD_INFO("ioh_i2c-3", CODEC_DEV_ADDR + 4)},
+	{I2C_BOARD_INFO("ioh_i2c-4", CODEC_DEV_ADDR + 5)},
+	{I2C_BOARD_INFO("ioh_i2c-5", CODEC_DEV_ADDR + 0)},
+};
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
+static int ml7213_startup(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_codec *codec = rtd->codec;
+	struct i2c_client *i2c;
+	struct i2c_adapter *adapter;
+
+	mutex_lock(&codec->mutex);
+
+	adapter = i2c_get_adapter(1);
+	if (!adapter)
+		return -ENODEV;
+
+	i2c = i2c_new_device(adapter, &ioh_hwmon_info[substream->number]);
+	if (!i2c) {
+		mutex_unlock(&codec->mutex);
+		return -1;
+	}
+	i2c_put_adapter(adapter);
+	mutex_unlock(&codec->mutex);
+
+	return 0;
+}
+
+static int ml7213_hw_params(struct snd_pcm_substream *substream,
+			    struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
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
+	/* set codec DAI configuration */
+	ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
+				SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
+	if (ret < 0)
+		return ret;
+
+	/* set cpu DAI configuration */
+	ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S |
+				SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
+	if (ret < 0)
+		return ret;
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
+	.startup = ml7213_startup,
+	.hw_params = ml7213_hw_params,
+};
+
+static struct snd_soc_dai_link ioh_i2s_dai = {
+	.name = "ML7213",
+	.stream_name = "I2S HiFi",
+	.cpu_dai_name = "ml7213-i2s",
+	.codec_dai_name = "ml26124-hifi",
+	.platform_name	= "ml7213-pcm-audio",
+	.codec_name	= "ml26124-00GD",
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
+	snd_soc_unregister_card(&ioh_i2s_card);
+
+	return 0;
+}
+
+static struct platform_driver ioh_i2s_driver = {
+	.remove = ioh_i2s_remove,
+	.driver = {
+		.name = "ml7213ioh-machine",
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
-- 
1.7.4.4

