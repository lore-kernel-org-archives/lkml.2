Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2IMWqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:46:11 -0400
Received: from 173-160-178-141-Washington.hfc.comcastbusiness.net ([173.160.178.141]:45782
	"EHLO relay" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753246Ab2IMWqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:46:03 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2012 18:46:03 EDT
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Add a codec driver for SI476X MFD
Date: Thu, 13 Sep 2012 15:40:13 -0700
Message-Id: <1347576013-28832-4-git-send-email-andrey.smirnov@convergeddevices.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net>
References: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit add a sound codec driver for Silicon Laboratories 476x
series of AM/FM radio chips.

Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
---
 sound/soc/codecs/Kconfig  |    4 +
 sound/soc/codecs/Makefile |    2 +
 sound/soc/codecs/si476x.c |  346 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 352 insertions(+)
 create mode 100644 sound/soc/codecs/si476x.c

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 9f8e859..71ab390 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -70,6 +70,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_UDA134X
 	select SND_SOC_UDA1380 if I2C
 	select SND_SOC_WL1273 if MFD_WL1273_CORE
+	select SND_SOC_SI476X if MFD_SI476X_CORE
 	select SND_SOC_WM1250_EV1 if I2C
 	select SND_SOC_WM2000 if I2C
 	select SND_SOC_WM2200 if I2C
@@ -326,6 +327,9 @@ config SND_SOC_UDA1380
 config SND_SOC_WL1273
 	tristate
 
+config SND_SOC_SI476X
+	tristate
+
 config SND_SOC_WM1250_EV1
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 34148bb..aecf09b 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -61,6 +61,7 @@ snd-soc-twl6040-objs := twl6040.o
 snd-soc-uda134x-objs := uda134x.o
 snd-soc-uda1380-objs := uda1380.o
 snd-soc-wl1273-objs := wl1273.o
+snd-soc-si476x-objs := si476x.o
 snd-soc-wm1250-ev1-objs := wm1250-ev1.o
 snd-soc-wm2000-objs := wm2000.o
 snd-soc-wm2200-objs := wm2200.o
@@ -177,6 +178,7 @@ obj-$(CONFIG_SND_SOC_TWL6040)	+= snd-soc-twl6040.o
 obj-$(CONFIG_SND_SOC_UDA134X)	+= snd-soc-uda134x.o
 obj-$(CONFIG_SND_SOC_UDA1380)	+= snd-soc-uda1380.o
 obj-$(CONFIG_SND_SOC_WL1273)	+= snd-soc-wl1273.o
+obj-$(CONFIG_SND_SOC_SI476X)	+= snd-soc-si476x.o
 obj-$(CONFIG_SND_SOC_WM1250_EV1) += snd-soc-wm1250-ev1.o
 obj-$(CONFIG_SND_SOC_WM2000)	+= snd-soc-wm2000.o
 obj-$(CONFIG_SND_SOC_WM2200)	+= snd-soc-wm2200.o
diff --git a/sound/soc/codecs/si476x.c b/sound/soc/codecs/si476x.c
new file mode 100644
index 0000000..beea2ca
--- /dev/null
+++ b/sound/soc/codecs/si476x.c
@@ -0,0 +1,346 @@
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/initval.h>
+
+#include <linux/mfd/si476x-core.h>
+
+#define SI476X_AUDIO_VOLUME			0x0300
+#define SI476X_AUDIO_MUTE			0x0301
+#define SI476X_DIGITAL_IO_OUTPUT_FORMAT		0x0203
+#define SI476X_DIGITAL_IO_OUTPUT_SAMPLE_RATE	0x0202
+
+#define SI476X_DIGITAL_IO_OUTPUT_WIDTH_MASK	~((0b111 << 11) | (0b111 << 8))
+#define SI476X_DIGITAL_IO_OUTPUT_FORMAT_MASK	~(0b1111110)
+
+
+/* codec private data */
+struct si476x_codec {
+	struct si476x_core *core;
+};
+
+static unsigned int si476x_codec_read(struct snd_soc_codec *codec,
+				      unsigned int reg)
+{
+	int err;
+	struct si476x_codec *si476x = snd_soc_codec_get_drvdata(codec);
+	struct si476x_core  *core   = si476x->core;
+
+	si476x_core_lock(core);
+	err = si476x_core_cmd_get_property(core, reg);
+	si476x_core_unlock(core);
+
+	return err;
+}
+
+static int si476x_codec_write(struct snd_soc_codec *codec,
+			      unsigned int reg, unsigned int val)
+{
+	int err;
+	struct si476x_codec *si476x = snd_soc_codec_get_drvdata(codec);
+	struct si476x_core  *core   = si476x->core;
+
+	si476x_core_lock(core);
+	err = si476x_core_cmd_set_property(core, reg, val);
+	si476x_core_unlock(core);
+
+	return err;
+}
+
+
+
+static int si476x_codec_set_daudio_params(struct snd_soc_codec *codec,
+					  int width, int rate)
+{
+	int err;
+	u16 digital_io_output_format = \
+		snd_soc_read(codec,
+			     SI476X_DIGITAL_IO_OUTPUT_FORMAT);
+
+	if ((rate < 32000) || (rate > 48000)) {
+		dev_dbg(codec->dev, "Rate: %d is not supported\n", rate);
+		return -EINVAL;
+	}
+
+	err = snd_soc_write(codec, SI476X_DIGITAL_IO_OUTPUT_SAMPLE_RATE,
+			    rate);
+	if (err < 0) {
+		dev_err(codec->dev, "Failed to set sample rate\n");
+		return err;
+	}
+
+	digital_io_output_format &= SI476X_DIGITAL_IO_OUTPUT_WIDTH_MASK;
+	digital_io_output_format |= (width << 11) | (width << 8);
+
+	return snd_soc_write(codec, SI476X_DIGITAL_IO_OUTPUT_FORMAT,
+			     digital_io_output_format);
+}
+
+static int si476x_codec_volume_get(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+
+	ucontrol->value.integer.value[0] =
+		snd_soc_read(codec, SI476X_AUDIO_VOLUME);
+	return 0;
+}
+
+static int si476x_codec_volume_put(struct snd_kcontrol *kcontrol,
+				   struct snd_ctl_elem_value *ucontrol)
+{
+
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+
+	snd_soc_write(codec, SI476X_AUDIO_VOLUME,
+		      ucontrol->value.integer.value[0]);
+	return 1;
+}
+
+#define SI476X_MAX_VOLUME 63
+
+static const struct snd_kcontrol_new si476x_controls[] = {
+	SOC_SINGLE_EXT("Analog Volume", 0, 0, SI476X_MAX_VOLUME, 0,
+		       si476x_codec_volume_get, si476x_codec_volume_put),
+};
+
+enum si476x_daudio_formats {
+	SI476X_DAUDIO_MODE_I2S     = (0x0 << 1),
+	SI476X_DAUDIO_MODE_DSP_A   = (0x6 << 1),
+	SI476X_DAUDIO_MODE_DSP_B   = (0x7 << 1),
+	SI476X_DAUDIO_MODE_LEFT_J  = (0x8 << 1),
+	SI476X_DAUDIO_MODE_RIGHT_J = (0x9 << 1),
+
+	SI476X_DAUDIO_MODE_IB = (1 << 5),
+	SI476X_DAUDIO_MODE_IF = (1 << 6),
+};
+
+static int si476x_codec_set_dai_fmt(struct snd_soc_dai *codec_dai,
+				    unsigned int fmt)
+{
+	struct snd_soc_codec *codec  = codec_dai->codec;
+	u16 digital_io_output_format = \
+		snd_soc_read(codec,
+			     SI476X_DIGITAL_IO_OUTPUT_FORMAT);
+
+	if ((fmt & SND_SOC_DAIFMT_MASTER_MASK) != SND_SOC_DAIFMT_CBS_CFS)
+		return -EINVAL;
+
+	digital_io_output_format &= SI476X_DIGITAL_IO_OUTPUT_FORMAT_MASK;
+
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_DSP_A:
+		digital_io_output_format |= SI476X_DAUDIO_MODE_DSP_A;
+		break;
+	case SND_SOC_DAIFMT_DSP_B:
+		digital_io_output_format |= SI476X_DAUDIO_MODE_DSP_B;
+		break;
+	case SND_SOC_DAIFMT_I2S:
+		digital_io_output_format |= SI476X_DAUDIO_MODE_I2S;
+		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		digital_io_output_format |= SI476X_DAUDIO_MODE_RIGHT_J;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		digital_io_output_format |= SI476X_DAUDIO_MODE_LEFT_J;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Clock inversion */
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_DSP_A:
+	case SND_SOC_DAIFMT_DSP_B:
+		/* frame inversion not valid for DSP modes */
+		switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+		case SND_SOC_DAIFMT_NB_NF:
+			break;
+		case SND_SOC_DAIFMT_IB_NF:
+			digital_io_output_format |= SI476X_DAUDIO_MODE_IB;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case SND_SOC_DAIFMT_I2S:
+	case SND_SOC_DAIFMT_RIGHT_J:
+	case SND_SOC_DAIFMT_LEFT_J:
+		switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+		case SND_SOC_DAIFMT_NB_NF:
+			break;
+		case SND_SOC_DAIFMT_IB_IF:
+			digital_io_output_format |= SI476X_DAUDIO_MODE_IB |
+				SI476X_DAUDIO_MODE_IF;
+			break;
+		case SND_SOC_DAIFMT_IB_NF:
+			digital_io_output_format |= SI476X_DAUDIO_MODE_IB;
+			break;
+		case SND_SOC_DAIFMT_NB_IF:
+			digital_io_output_format |= SI476X_DAUDIO_MODE_IF;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return snd_soc_write(codec, SI476X_DIGITAL_IO_OUTPUT_FORMAT,
+			     digital_io_output_format);
+}
+
+static int si476x_codec_digital_mute(struct snd_soc_dai *codec_dai, int mute)
+{
+	if (mute)
+		snd_soc_write(codec_dai->codec, SI476X_AUDIO_MUTE, 0x3);
+
+	return 0;
+}
+
+
+enum si476x_pcm_format {
+	SI476X_PCM_FORMAT_S8		= 2,
+	SI476X_PCM_FORMAT_S16_LE	= 4,
+	SI476X_PCM_FORMAT_S20_3LE	= 5,
+	SI476X_PCM_FORMAT_S24_LE	= 6,
+};
+
+static int si476x_codec_hw_params(struct snd_pcm_substream *substream,
+				  struct snd_pcm_hw_params *params,
+				  struct snd_soc_dai *dai)
+{
+	int rate, width, err;
+
+	struct snd_soc_pcm_runtime *rtd    = substream->private_data;
+
+	rate = params_rate(params);
+
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S8:
+		width = SI476X_PCM_FORMAT_S8;
+	case SNDRV_PCM_FORMAT_S16_LE:
+		width = SI476X_PCM_FORMAT_S16_LE;
+		break;
+	case SNDRV_PCM_FORMAT_S20_3LE:
+		width = SI476X_PCM_FORMAT_S20_3LE;
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		width = SI476X_PCM_FORMAT_S24_LE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	err = si476x_codec_set_daudio_params(rtd->codec, width, rate);
+
+	return err;
+}
+
+
+
+static int si476x_codec_probe(struct snd_soc_codec *codec)
+{
+	struct si476x_core **core = codec->dev->platform_data;
+	struct si476x_codec *si476x;
+
+	if (!core) {
+		dev_err(codec->dev, "Platform data is missing.\n");
+		return -EINVAL;
+	}
+
+	si476x = kzalloc(sizeof(*si476x), GFP_KERNEL);
+	if (si476x == NULL) {
+		dev_err(codec->dev, "Cannot allocate memory.\n");
+		return -ENOMEM;
+	}
+
+	si476x->core = *core;
+
+	snd_soc_codec_set_drvdata(codec, si476x);
+
+	return 0;
+}
+
+static int si476x_codec_remove(struct snd_soc_codec *codec)
+{
+	struct si476x_codec *si476x = snd_soc_codec_get_drvdata(codec);
+
+	kfree(si476x);
+
+	return 0;
+}
+
+static struct snd_soc_dai_ops si476x_dai_ops = {
+	.hw_params	= si476x_codec_hw_params,
+	.digital_mute	= si476x_codec_digital_mute,
+	.set_fmt	= si476x_codec_set_dai_fmt,
+};
+
+static struct snd_soc_dai_driver si476x_dai = {
+	.name		= "si476x-codec",
+
+	.capture	= {
+		.stream_name	= "Capture",
+		.channels_min	= 2,
+		.channels_max	= 2,
+
+		.rates = SNDRV_PCM_RATE_32000 |
+		SNDRV_PCM_RATE_44100 |
+		SNDRV_PCM_RATE_48000,
+		.formats = SNDRV_PCM_FMTBIT_S8 |
+		SNDRV_PCM_FMTBIT_S16_LE |
+		SNDRV_PCM_FMTBIT_S20_3LE |
+		SNDRV_PCM_FMTBIT_S24_LE
+	},
+	.ops		= &si476x_dai_ops,
+};
+
+static struct snd_soc_codec_driver soc_codec_dev_si476x = {
+	.probe  = si476x_codec_probe,
+	.remove = si476x_codec_remove,
+	.read   = si476x_codec_read,
+	.write  = si476x_codec_write,
+};
+
+static int __devinit si476x_platform_probe(struct platform_device *pdev)
+{
+	return snd_soc_register_codec(&pdev->dev, &soc_codec_dev_si476x,
+				      &si476x_dai, 1);
+}
+
+static int __devexit si476x_platform_remove(struct platform_device *pdev)
+{
+	snd_soc_unregister_codec(&pdev->dev);
+	return 0;
+}
+
+MODULE_ALIAS("platform:si476x-codec");
+
+static struct platform_driver si476x_platform_driver = {
+	.driver		= {
+		.name	= "si476x-codec",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= si476x_platform_probe,
+	.remove		= __devexit_p(si476x_platform_remove),
+};
+
+static int __init si476x_init(void)
+{
+	return platform_driver_register(&si476x_platform_driver);
+}
+module_init(si476x_init);
+
+static void __exit si476x_exit(void)
+{
+	platform_driver_unregister(&si476x_platform_driver);
+}
+module_exit(si476x_exit);
+
+MODULE_AUTHOR("Andrey Smirnov <andrey.smirnov@convergeddevices.net>");
+MODULE_DESCRIPTION("ASoC Si4761/64 codec driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

