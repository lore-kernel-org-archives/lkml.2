Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab1FFLjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:39:43 -0400
Received: from smtp-out-228.synserver.de ([212.40.185.228]:1079 "HELO
	smtp-out-224.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755673Ab1FFLji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:39:38 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 13762
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/6] ASoC: AD1836: Add AD1835/AD1837/AD1838/AD1839 support
Date: Mon,  6 Jun 2011 13:38:38 +0200
Message-Id: <1307360320-4727-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307360320-4727-1-git-send-email-lars@metafoo.de>
References: <1307360320-4727-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AD183X codec devices are mostly register compatible and can easily be
supported by the same driver.
The main difference between those devices is the number of DACs and ADCs.

This patch adjusts the driver to allocate the controls, DAPM widgets and
routes for the DACs and ADCs dynamically based on the chip type.

The AD1836 is a bit special in that it supports different modes for its second
ADC, so it needs some special handling. Right now the driver hardcodes the mode
to the differential PGA mode.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad1836.c |  183 +++++++++++++++++++++++++++++++-------------
 1 files changed, 129 insertions(+), 54 deletions(-)

diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
index fde0f17..a443cfe 100644
--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -30,10 +30,17 @@
 #include <linux/spi/spi.h>
 #include "ad1836.h"
 
+enum ad1836_type {
+	AD1835,
+	AD1836,
+	AD1838,
+};
+
 /* codec private data */
 struct ad1836_priv {
 	enum snd_soc_control_type control_type;
 	void *control_data;
+	enum ad1836_type type;
 };
 
 /*
@@ -56,21 +63,48 @@ static const struct soc_enum ad1836_deemp_enum =
 	SOC_DOUBLE("ADC" #x " Capture Switch", AD1836_ADC_CTRL2, \
 		AD1836_MUTE_LEFT(x), AD1836_MUTE_RIGHT(x), 1, 1)
 
-static const struct snd_kcontrol_new ad1836_snd_controls[] = {
-	/* DAC volume control */
+static const struct snd_kcontrol_new ad183x_dac_controls[] = {
 	AD1836_DAC_VOLUME(1),
+	AD1836_DAC_SWITCH(1),
 	AD1836_DAC_VOLUME(2),
+	AD1836_DAC_SWITCH(2),
 	AD1836_DAC_VOLUME(3),
+	AD1836_DAC_SWITCH(3),
+	AD1836_DAC_VOLUME(4),
+	AD1836_DAC_SWITCH(4),
+};
+
+static const struct snd_soc_dapm_widget ad183x_dac_dapm_widgets[] = {
+	SND_SOC_DAPM_OUTPUT("DAC1OUT"),
+	SND_SOC_DAPM_OUTPUT("DAC2OUT"),
+	SND_SOC_DAPM_OUTPUT("DAC3OUT"),
+	SND_SOC_DAPM_OUTPUT("DAC4OUT"),
+};
+
+static const struct snd_soc_dapm_route ad183x_dac_routes[] = {
+	{ "DAC1OUT", NULL, "DAC" },
+	{ "DAC2OUT", NULL, "DAC" },
+	{ "DAC3OUT", NULL, "DAC" },
+	{ "DAC4OUT", NULL, "DAC" },
+};
 
-	/* ADC switch control */
+static const struct snd_kcontrol_new ad183x_adc_controls[] = {
 	AD1836_ADC_SWITCH(1),
 	AD1836_ADC_SWITCH(2),
+	AD1836_ADC_SWITCH(3),
+};
 
-	/* DAC switch control */
-	AD1836_DAC_SWITCH(1),
-	AD1836_DAC_SWITCH(2),
-	AD1836_DAC_SWITCH(3),
+static const struct snd_soc_dapm_widget ad183x_adc_dapm_widgets[] = {
+	SND_SOC_DAPM_INPUT("ADC1IN"),
+	SND_SOC_DAPM_INPUT("ADC2IN"),
+};
+
+static const struct snd_soc_dapm_route ad183x_adc_routes[] = {
+	{ "ADC", NULL, "ADC1IN" },
+	{ "ADC", NULL, "ADC2IN" },
+};
 
+static const struct snd_kcontrol_new ad183x_controls[] = {
 	/* ADC high-pass filter */
 	SOC_SINGLE("ADC High Pass Filter Switch", AD1836_ADC_CTRL1,
 			AD1836_ADC_HIGHPASS_FILTER, 1, 0),
@@ -79,27 +113,17 @@ static const struct snd_kcontrol_new ad1836_snd_controls[] = {
 	SOC_ENUM("Playback Deemphasis", ad1836_deemp_enum),
 };
 
-static const struct snd_soc_dapm_widget ad1836_dapm_widgets[] = {
+static const struct snd_soc_dapm_widget ad183x_dapm_widgets[] = {
 	SND_SOC_DAPM_DAC("DAC", "Playback", AD1836_DAC_CTRL1,
 				AD1836_DAC_POWERDOWN, 1),
 	SND_SOC_DAPM_ADC("ADC", "Capture", SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_SUPPLY("ADC_PWR", AD1836_ADC_CTRL1,
 				AD1836_ADC_POWERDOWN, 1, NULL, 0),
-	SND_SOC_DAPM_OUTPUT("DAC1OUT"),
-	SND_SOC_DAPM_OUTPUT("DAC2OUT"),
-	SND_SOC_DAPM_OUTPUT("DAC3OUT"),
-	SND_SOC_DAPM_INPUT("ADC1IN"),
-	SND_SOC_DAPM_INPUT("ADC2IN"),
 };
 
-static const struct snd_soc_dapm_route audio_paths[] = {
+static const struct snd_soc_dapm_route ad183x_dapm_routes[] = {
 	{ "DAC", NULL, "ADC_PWR" },
 	{ "ADC", NULL, "ADC_PWR" },
-	{ "DAC1OUT", "DAC1 Switch", "DAC" },
-	{ "DAC2OUT", "DAC2 Switch", "DAC" },
-	{ "DAC3OUT", "DAC3 Switch", "DAC" },
-	{ "ADC", "ADC1 Switch", "ADC1IN" },
-	{ "ADC", "ADC2 Switch", "ADC2IN" },
 };
 
 /*
@@ -194,33 +218,44 @@ static struct snd_soc_dai_ops ad1836_dai_ops = {
 	.set_fmt = ad1836_set_dai_fmt,
 };
 
-/* codec DAI instance */
-static struct snd_soc_dai_driver ad1836_dai = {
-	.name = "ad1836-hifi",
-	.playback = {
-		.stream_name = "Playback",
-		.channels_min = 2,
-		.channels_max = 6,
-		.rates = SNDRV_PCM_RATE_48000,
-		.formats = SNDRV_PCM_FMTBIT_S32_LE | SNDRV_PCM_FMTBIT_S16_LE |
-			SNDRV_PCM_FMTBIT_S20_3LE | SNDRV_PCM_FMTBIT_S24_LE,
-	},
-	.capture = {
-		.stream_name = "Capture",
-		.channels_min = 2,
-		.channels_max = 4,
-		.rates = SNDRV_PCM_RATE_48000,
-		.formats = SNDRV_PCM_FMTBIT_S32_LE | SNDRV_PCM_FMTBIT_S16_LE |
-			SNDRV_PCM_FMTBIT_S20_3LE | SNDRV_PCM_FMTBIT_S24_LE,
-	},
-	.ops = &ad1836_dai_ops,
+#define AD183X_DAI(_name, num_dacs, num_adcs) \
+{ \
+	.name = _name "-hifi", \
+	.playback = { \
+		.stream_name = "Playback", \
+		.channels_min = 2, \
+		.channels_max = (num_dacs) * 2, \
+		.rates = SNDRV_PCM_RATE_48000,  \
+		.formats = SNDRV_PCM_FMTBIT_S32_LE | SNDRV_PCM_FMTBIT_S16_LE | \
+			SNDRV_PCM_FMTBIT_S20_3LE | SNDRV_PCM_FMTBIT_S24_LE, \
+	}, \
+	.capture = { \
+		.stream_name = "Capture", \
+		.channels_min = 2, \
+		.channels_max = (num_adcs) * 2, \
+		.rates = SNDRV_PCM_RATE_48000, \
+		.formats = SNDRV_PCM_FMTBIT_S32_LE | SNDRV_PCM_FMTBIT_S16_LE | \
+			SNDRV_PCM_FMTBIT_S20_3LE | SNDRV_PCM_FMTBIT_S24_LE, \
+	}, \
+	.ops = &ad1836_dai_ops, \
+}
+
+static struct snd_soc_dai_driver ad183x_dais[] = {
+	[AD1835] = AD183X_DAI("ad1835", 4, 1),
+	[AD1836] = AD183X_DAI("ad1836", 3, 2),
+	[AD1838] = AD183X_DAI("ad1838", 3, 1),
 };
 
 static int ad1836_probe(struct snd_soc_codec *codec)
 {
 	struct ad1836_priv *ad1836 = snd_soc_codec_get_drvdata(codec);
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
+	int num_dacs, num_adcs;
 	int ret = 0;
+	int i;
+
+	num_dacs = ad183x_dais[ad1836->type].playback.channels_max / 2;
+	num_adcs = ad183x_dais[ad1836->type].capture.channels_max / 2;
 
 	codec->control_data = ad1836->control_data;
 	ret = snd_soc_codec_set_cache_io(codec, 4, 12, SND_SOC_SPI);
@@ -239,21 +274,42 @@ static int ad1836_probe(struct snd_soc_codec *codec)
 	snd_soc_write(codec, AD1836_ADC_CTRL1, 0x100);
 	/* unmute adc channles, adc aux mode */
 	snd_soc_write(codec, AD1836_ADC_CTRL2, 0x180);
-	/* left/right diff:PGA/MUX */
-	snd_soc_write(codec, AD1836_ADC_CTRL3, 0x3A);
 	/* volume */
-	snd_soc_write(codec, AD1836_DAC_L_VOL(1), 0x3FF);
-	snd_soc_write(codec, AD1836_DAC_R_VOL(1), 0x3FF);
-	snd_soc_write(codec, AD1836_DAC_L_VOL(2), 0x3FF);
-	snd_soc_write(codec, AD1836_DAC_R_VOL(2), 0x3FF);
-	snd_soc_write(codec, AD1836_DAC_L_VOL(3), 0x3FF);
-	snd_soc_write(codec, AD1836_DAC_R_VOL(3), 0x3FF);
-
-	snd_soc_add_controls(codec, ad1836_snd_controls,
-			     ARRAY_SIZE(ad1836_snd_controls));
-	snd_soc_dapm_new_controls(dapm, ad1836_dapm_widgets,
-				  ARRAY_SIZE(ad1836_dapm_widgets));
-	snd_soc_dapm_add_routes(dapm, audio_paths, ARRAY_SIZE(audio_paths));
+	for (i = 1; i <= num_dacs; ++i) {
+		snd_soc_write(codec, AD1836_DAC_L_VOL(i), 0x3FF);
+		snd_soc_write(codec, AD1836_DAC_R_VOL(i), 0x3FF);
+	}
+
+	if (ad1836->type == AD1836) {
+		/* left/right diff:PGA/MUX */
+		snd_soc_write(codec, AD1836_ADC_CTRL3, 0x3A);
+	} else {
+		snd_soc_write(codec, AD1836_ADC_CTRL3, 0x00);
+	}
+
+	ret = snd_soc_add_controls(codec, ad183x_dac_controls, num_dacs * 2);
+	if (ret)
+		return ret;
+
+	ret = snd_soc_add_controls(codec, ad183x_adc_controls, num_adcs);
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dapm_new_controls(dapm, ad183x_dac_dapm_widgets, num_dacs);
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dapm_new_controls(dapm, ad183x_adc_dapm_widgets, num_adcs);
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dapm_add_routes(dapm, ad183x_dac_routes, num_dacs);
+	if (ret)
+		return ret;
+
+	ret = snd_soc_dapm_add_routes(dapm, ad183x_adc_routes, num_adcs);
+	if (ret)
+		return ret;
 
 	return ret;
 }
@@ -273,6 +329,13 @@ static struct snd_soc_codec_driver soc_codec_dev_ad1836 = {
 	.resume =       ad1836_soc_resume,
 	.reg_cache_size = AD1836_NUM_REGS,
 	.reg_word_size = sizeof(u16),
+
+	.controls = ad183x_controls,
+	.num_controls = ARRAY_SIZE(ad183x_controls),
+	.dapm_widgets = ad183x_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(ad183x_dapm_widgets),
+	.dapm_routes = ad183x_dapm_routes,
+	.num_dapm_routes = ARRAY_SIZE(ad183x_dapm_routes),
 };
 
 static int __devinit ad1836_spi_probe(struct spi_device *spi)
@@ -284,12 +347,14 @@ static int __devinit ad1836_spi_probe(struct spi_device *spi)
 	if (ad1836 == NULL)
 		return -ENOMEM;
 
+	ad1836->type = spi_get_device_id(spi)->driver_data;
+
 	spi_set_drvdata(spi, ad1836);
 	ad1836->control_data = spi;
 	ad1836->control_type = SND_SOC_SPI;
 
 	ret = snd_soc_register_codec(&spi->dev,
-			&soc_codec_dev_ad1836, &ad1836_dai, 1);
+			&soc_codec_dev_ad1836, &ad183x_dais[ad1836->type], 1);
 	if (ret < 0)
 		kfree(ad1836);
 	return ret;
@@ -301,6 +366,15 @@ static int __devexit ad1836_spi_remove(struct spi_device *spi)
 	kfree(spi_get_drvdata(spi));
 	return 0;
 }
+static const struct spi_device_id ad1836_ids[] = {
+	{ "ad1835", AD1835 },
+	{ "ad1836", AD1836 },
+	{ "ad1837", AD1835 },
+	{ "ad1838", AD1838 },
+	{ "ad1839", AD1838 },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, ad1836_ids);
 
 static struct spi_driver ad1836_spi_driver = {
 	.driver = {
@@ -309,6 +383,7 @@ static struct spi_driver ad1836_spi_driver = {
 	},
 	.probe		= ad1836_spi_probe,
 	.remove		= __devexit_p(ad1836_spi_remove),
+	.id_table	= ad1836_ids,
 };
 
 static int __init ad1836_init(void)
-- 
1.7.2.5

