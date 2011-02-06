Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab1BFXDh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:03:37 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1084 "HELO
	smtp-out-016.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754115Ab1BFXDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:03:16 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 15254
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 7/7] ASoC: Samsung: Merge neo1937 and neo1973_gta02 sound board driver
Date: Mon,  7 Feb 2011 00:04:23 +0100
Message-Id: <1297033463-14577-7-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297033463-14577-1-git-send-email-lars@metafoo.de>
References: <1297033463-14577-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The neo1973(GTA01) and neo1973_gta2(GTA02) have a very similar audio hardware
setup. They both use the same codec with the same routing to the gsm modem and
bluetooth chip. But they do use different AMPs though and there are some minor
differences in the speaker setup.

As a result most of the code of those two drivers is identical.
So from a maintenance point of view it makes sense to merge them into a single
driver. It also reduces the size of kernel images supporting both the GTA01 and
GTA02.

As a side-effect of this merge the GTA01 for example gains support for routing
audio to and from the bluetooth DAI.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/samsung/Kconfig                |   17 +-
 sound/soc/samsung/Makefile               |    2 -
 sound/soc/samsung/neo1973_gta02_wm8753.c |  434 ------------------------------
 sound/soc/samsung/neo1973_wm8753.c       |  253 +++++++++++++-----
 4 files changed, 192 insertions(+), 514 deletions(-)
 delete mode 100644 sound/soc/samsung/neo1973_gta02_wm8753.c

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index ba78e26..6deccbd 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -35,23 +35,14 @@ config SND_SAMSUNG_I2S
 	tristate
 
 config SND_SOC_SAMSUNG_NEO1973_WM8753
-	tristate "SoC I2S Audio support for NEO1973 - WM8753"
-	depends on SND_SOC_SAMSUNG && MACH_NEO1973_GTA01
+	tristate "Audio support for Openmoko Neo1973 Smartphones (GTA01/GTA02)"
+	depends on SND_SOC_SAMSUNG && (MACH_NEO1973_GTA01 || MACH_NEO1973_GTA02)
 	select SND_S3C24XX_I2S
 	select SND_SOC_WM8753
 	select SND_SOC_LM4857
 	help
-	  Say Y if you want to add support for SoC audio on smdk2440
-	  with the WM8753.
-
-config SND_SOC_SAMSUNG_NEO1973_GTA02_WM8753
-	tristate "Audio support for the Openmoko Neo FreeRunner (GTA02)"
-	depends on SND_SOC_SAMSUNG && MACH_NEO1973_GTA02
-	select SND_S3C24XX_I2S
-	select SND_SOC_WM8753
-	help
-	  This driver provides audio support for the Openmoko Neo FreeRunner
-	  smartphone.
+	  Say Y here to enable audio support for the Openmoko Neo1973
+	  Smartphones.
 	  
 config SND_SOC_SAMSUNG_JIVE_WM8750
 	tristate "SoC I2S Audio support for Jive"
diff --git a/sound/soc/samsung/Makefile b/sound/soc/samsung/Makefile
index 705d4e8..294dec0 100644
--- a/sound/soc/samsung/Makefile
+++ b/sound/soc/samsung/Makefile
@@ -20,7 +20,6 @@ obj-$(CONFIG_SND_SAMSUNG_I2S) += snd-soc-i2s.o
 # S3C24XX Machine Support
 snd-soc-jive-wm8750-objs := jive_wm8750.o
 snd-soc-neo1973-wm8753-objs := neo1973_wm8753.o
-snd-soc-neo1973-gta02-wm8753-objs := neo1973_gta02_wm8753.o
 snd-soc-smdk2443-wm9710-objs := smdk2443_wm9710.o
 snd-soc-ln2440sbc-alc650-objs := ln2440sbc_alc650.o
 snd-soc-s3c24xx-uda134x-objs := s3c24xx_uda134x.o
@@ -38,7 +37,6 @@ snd-soc-smdk-spdif-objs := smdk_spdif.o
 
 obj-$(CONFIG_SND_SOC_SAMSUNG_JIVE_WM8750) += snd-soc-jive-wm8750.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_NEO1973_WM8753) += snd-soc-neo1973-wm8753.o
-obj-$(CONFIG_SND_SOC_SAMSUNG_NEO1973_GTA02_WM8753) += snd-soc-neo1973-gta02-wm8753.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_SMDK2443_WM9710) += snd-soc-smdk2443-wm9710.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_LN2440SBC_ALC650) += snd-soc-ln2440sbc-alc650.o
 obj-$(CONFIG_SND_SOC_SAMSUNG_S3C24XX_UDA134X) += snd-soc-s3c24xx-uda134x.o
diff --git a/sound/soc/samsung/neo1973_gta02_wm8753.c b/sound/soc/samsung/neo1973_gta02_wm8753.c
deleted file mode 100644
index a82779b..0000000
--- a/sound/soc/samsung/neo1973_gta02_wm8753.c
+++ /dev/null
@@ -1,434 +0,0 @@
-/*
- * neo1973_gta02_wm8753.c  --  SoC audio for Openmoko Freerunner(GTA02)
- *
- * Copyright 2007 Openmoko Inc
- * Author: Graeme Gregory <graeme@openmoko.org>
- * Copyright 2007 Wolfson Microelectronics PLC.
- * Author: Graeme Gregory <linux@wolfsonmicro.com>
- * Copyright 2009 Wolfson Microelectronics
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-
-#include <linux/gpio.h>
-
-#include <sound/soc.h>
-
-#include <asm/mach-types.h>
-#include <plat/regs-iis.h>
-#include <mach/gta02.h>
-
-#include "../codecs/wm8753.h"
-#include "s3c24xx-i2s.h"
-
-static struct snd_soc_card neo1973_gta02;
-
-static int neo1973_gta02_hifi_hw_params(struct snd_pcm_substream *substream,
-	struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->codec_dai;
-	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
-	unsigned int pll_out = 0, bclk = 0;
-	int ret = 0;
-	unsigned long iis_clkrate;
-
-	iis_clkrate = s3c24xx_i2s_get_clockrate();
-
-	switch (params_rate(params)) {
-	case 8000:
-	case 16000:
-		pll_out = 12288000;
-		break;
-	case 48000:
-		bclk = WM8753_BCLK_DIV_4;
-		pll_out = 12288000;
-		break;
-	case 96000:
-		bclk = WM8753_BCLK_DIV_2;
-		pll_out = 12288000;
-		break;
-	case 11025:
-		bclk = WM8753_BCLK_DIV_16;
-		pll_out = 11289600;
-		break;
-	case 22050:
-		bclk = WM8753_BCLK_DIV_8;
-		pll_out = 11289600;
-		break;
-	case 44100:
-		bclk = WM8753_BCLK_DIV_4;
-		pll_out = 11289600;
-		break;
-	case 88200:
-		bclk = WM8753_BCLK_DIV_2;
-		pll_out = 11289600;
-		break;
-	}
-
-	/* set codec DAI configuration */
-	ret = snd_soc_dai_set_fmt(codec_dai,
-		SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
-		SND_SOC_DAIFMT_CBM_CFM);
-	if (ret < 0)
-		return ret;
-
-	/* set cpu DAI configuration */
-	ret = snd_soc_dai_set_fmt(cpu_dai,
-		SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
-		SND_SOC_DAIFMT_CBM_CFM);
-	if (ret < 0)
-		return ret;
-
-	/* set the codec system clock for DAC and ADC */
-	ret = snd_soc_dai_set_sysclk(codec_dai, WM8753_MCLK, pll_out,
-		SND_SOC_CLOCK_IN);
-	if (ret < 0)
-		return ret;
-
-	/* set MCLK division for sample rate */
-	ret = snd_soc_dai_set_clkdiv(cpu_dai, S3C24XX_DIV_MCLK,
-		S3C2410_IISMOD_32FS);
-	if (ret < 0)
-		return ret;
-
-	/* set codec BCLK division for sample rate */
-	ret = snd_soc_dai_set_clkdiv(codec_dai,
-					WM8753_BCLKDIV, bclk);
-	if (ret < 0)
-		return ret;
-
-	/* set prescaler division for sample rate */
-	ret = snd_soc_dai_set_clkdiv(cpu_dai, S3C24XX_DIV_PRESCALER,
-		S3C24XX_PRESCALE(4, 4));
-	if (ret < 0)
-		return ret;
-
-	/* codec PLL input is PCLK/4 */
-	ret = snd_soc_dai_set_pll(codec_dai, WM8753_PLL1, 0,
-		iis_clkrate / 4, pll_out);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static int neo1973_gta02_hifi_hw_free(struct snd_pcm_substream *substream)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->codec_dai;
-
-	/* disable the PLL */
-	return snd_soc_dai_set_pll(codec_dai, WM8753_PLL1, 0, 0, 0);
-}
-
-/*
- * Neo1973 WM8753 HiFi DAI opserations.
- */
-static struct snd_soc_ops neo1973_gta02_hifi_ops = {
-	.hw_params = neo1973_gta02_hifi_hw_params,
-	.hw_free = neo1973_gta02_hifi_hw_free,
-};
-
-static int neo1973_gta02_voice_hw_params(
-	struct snd_pcm_substream *substream,
-	struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->codec_dai;
-	unsigned int pcmdiv = 0;
-	int ret = 0;
-	unsigned long iis_clkrate;
-
-	iis_clkrate = s3c24xx_i2s_get_clockrate();
-
-	if (params_rate(params) != 8000)
-		return -EINVAL;
-	if (params_channels(params) != 1)
-		return -EINVAL;
-
-	pcmdiv = WM8753_PCM_DIV_6; /* 2.048 MHz */
-
-	/* todo: gg check mode (DSP_B) against CSR datasheet */
-	/* set codec DAI configuration */
-	ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_DSP_B |
-		SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
-	if (ret < 0)
-		return ret;
-
-	/* set the codec system clock for DAC and ADC */
-	ret = snd_soc_dai_set_sysclk(codec_dai, WM8753_PCMCLK,
-		12288000, SND_SOC_CLOCK_IN);
-	if (ret < 0)
-		return ret;
-
-	/* set codec PCM division for sample rate */
-	ret = snd_soc_dai_set_clkdiv(codec_dai, WM8753_PCMDIV,
-					pcmdiv);
-	if (ret < 0)
-		return ret;
-
-	/* configure and enable PLL for 12.288MHz output */
-	ret = snd_soc_dai_set_pll(codec_dai, WM8753_PLL2, 0,
-		iis_clkrate / 4, 12288000);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static int neo1973_gta02_voice_hw_free(struct snd_pcm_substream *substream)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->codec_dai;
-
-	/* disable the PLL */
-	return snd_soc_dai_set_pll(codec_dai, WM8753_PLL2, 0, 0, 0);
-}
-
-static struct snd_soc_ops neo1973_gta02_voice_ops = {
-	.hw_params = neo1973_gta02_voice_hw_params,
-	.hw_free = neo1973_gta02_voice_hw_free,
-};
-
-static int gta02_speaker_enabled;
-
-static int lm4853_set_spk(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	gta02_speaker_enabled = ucontrol->value.integer.value[0];
-
-	gpio_set_value(GTA02_GPIO_HP_IN, !gta02_speaker_enabled);
-
-	return 0;
-}
-
-static int lm4853_get_spk(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	ucontrol->value.integer.value[0] = gta02_speaker_enabled;
-	return 0;
-}
-
-static int lm4853_event(struct snd_soc_dapm_widget *w,
-			struct snd_kcontrol *k, int event)
-{
-	gpio_set_value(GTA02_GPIO_AMP_SHUT, SND_SOC_DAPM_EVENT_OFF(event));
-
-	return 0;
-}
-
-static const struct snd_soc_dapm_widget wm8753_dapm_widgets[] = {
-	SND_SOC_DAPM_SPK("Stereo Out", lm4853_event),
-	SND_SOC_DAPM_LINE("GSM Line Out", NULL),
-	SND_SOC_DAPM_LINE("GSM Line In", NULL),
-	SND_SOC_DAPM_MIC("Headset Mic", NULL),
-	SND_SOC_DAPM_MIC("Handset Mic", NULL),
-	SND_SOC_DAPM_SPK("Handset Spk", NULL),
-};
-
-
-/* example machine audio_mapnections */
-static const struct snd_soc_dapm_route audio_map[] = {
-
-	/* Connections to the lm4853 amp */
-	{"Stereo Out", NULL, "LOUT1"},
-	{"Stereo Out", NULL, "ROUT1"},
-
-	/* Connections to the GSM Module */
-	{"GSM Line Out", NULL, "MONO1"},
-	{"GSM Line Out", NULL, "MONO2"},
-	{"RXP", NULL, "GSM Line In"},
-	{"RXN", NULL, "GSM Line In"},
-
-	/* Connections to Headset */
-	{"MIC1", NULL, "Mic Bias"},
-	{"Mic Bias", NULL, "Headset Mic"},
-
-	/* Call Mic */
-	{"MIC2", NULL, "Mic Bias"},
-	{"MIC2N", NULL, "Mic Bias"},
-	{"Mic Bias", NULL, "Handset Mic"},
-
-	/* Call Speaker */
-	{"Handset Spk", NULL, "LOUT2"},
-	{"Handset Spk", NULL, "ROUT2"},
-
-	/* Connect the ALC pins */
-	{"ACIN", NULL, "ACOP"},
-};
-
-static const struct snd_kcontrol_new wm8753_neo1973_gta02_controls[] = {
-	SOC_DAPM_PIN_SWITCH("Stereo Out"),
-	SOC_DAPM_PIN_SWITCH("GSM Line Out"),
-	SOC_DAPM_PIN_SWITCH("GSM Line In"),
-	SOC_DAPM_PIN_SWITCH("Headset Mic"),
-	SOC_DAPM_PIN_SWITCH("Handset Mic"),
-	SOC_DAPM_PIN_SWITCH("Handset Spk"),
-
-	SOC_SINGLE_BOOL_EXT("Amp Spk Switch", 0,
-		lm4853_get_spk,
-		lm4853_set_spk),
-};
-
-/*
- * This is an example machine initialisation for a wm8753 connected to a
- * neo1973 GTA02.
- */
-static int neo1973_gta02_wm8753_init(struct snd_soc_pcm_runtime *rtd)
-{
-	struct snd_soc_codec *codec = rtd->codec;
-	struct snd_soc_dapm_context *dapm = &codec->dapm;
-	int err;
-
-	/* set up NC codec pins */
-	snd_soc_dapm_nc_pin(dapm, "OUT3");
-	snd_soc_dapm_nc_pin(dapm, "OUT4");
-	snd_soc_dapm_nc_pin(dapm, "LINE1");
-	snd_soc_dapm_nc_pin(dapm, "LINE2");
-
-	/* Add neo1973 gta02 specific widgets */
-	snd_soc_dapm_new_controls(dapm, wm8753_dapm_widgets,
-				  ARRAY_SIZE(wm8753_dapm_widgets));
-
-	/* add neo1973 gta02 specific controls */
-	err = snd_soc_add_controls(codec, wm8753_neo1973_gta02_controls,
-		ARRAY_SIZE(wm8753_neo1973_gta02_controls));
-
-	if (err < 0)
-		return err;
-
-	/* set up neo1973 gta02 specific audio path audio_map */
-	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
-
-	/* set endpoints to default off mode */
-	snd_soc_dapm_disable_pin(dapm, "Stereo Out");
-	snd_soc_dapm_disable_pin(dapm, "GSM Line Out");
-	snd_soc_dapm_disable_pin(dapm, "GSM Line In");
-	snd_soc_dapm_disable_pin(dapm, "Headset Mic");
-	snd_soc_dapm_disable_pin(dapm, "Handset Mic");
-	snd_soc_dapm_disable_pin(dapm, "Handset Spk");
-
-	/* allow audio paths from the GSM modem to run during suspend */
-	snd_soc_dapm_ignore_suspend(dapm, "Stereo Out");
-	snd_soc_dapm_ignore_suspend(dapm, "GSM Line Out");
-	snd_soc_dapm_ignore_suspend(dapm, "GSM Line In");
-	snd_soc_dapm_ignore_suspend(dapm, "Headset Mic");
-	snd_soc_dapm_ignore_suspend(dapm, "Handset Mic");
-	snd_soc_dapm_ignore_suspend(dapm, "Handset Spk");
-
-	snd_soc_dapm_sync(dapm);
-
-	return 0;
-}
-
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
-static struct snd_soc_dai_link neo1973_gta02_dai[] = {
-{ /* Hifi Playback - for similatious use with voice below */
-	.name = "WM8753",
-	.stream_name = "WM8753 HiFi",
-	.cpu_dai_name = "s3c24xx-iis",
-	.codec_dai_name = "wm8753-hifi",
-	.init = neo1973_gta02_wm8753_init,
-	.platform_name = "samsung-audio",
-	.codec_name = "wm8753-codec.0-001a",
-	.ops = &neo1973_gta02_hifi_ops,
-},
-{ /* Voice via BT */
-	.name = "Bluetooth",
-	.stream_name = "Voice",
-	.cpu_dai_name = "bluetooth-dai",
-	.codec_dai_name = "wm8753-voice",
-	.ops = &neo1973_gta02_voice_ops,
-	.codec_name = "wm8753-codec.0-001a",
-	.platform_name = "samsung-audio",
-},
-};
-
-static struct snd_soc_card neo1973_gta02 = {
-	.name = "neo1973-gta02",
-	.dai_link = neo1973_gta02_dai,
-	.num_links = ARRAY_SIZE(neo1973_gta02_dai),
-};
-
-static const struct gpio neo1973_gta02_gpios[] = {
-	{ GTA02_GPIO_HP_IN, GPIOF_OUT_INIT_HIGH, "GTA02_HP_IN" },
-	{ GTA02_GPIO_AMP_SHUT, GPIOF_OUT_INIT_HIGH, "GTA02_AMP_SHUT" },
-};
-
-static struct platform_device *neo1973_gta02_snd_device;
-
-static int __init neo1973_gta02_init(void)
-{
-	int ret;
-
-	if (!machine_is_neo1973_gta02()) {
-		printk(KERN_INFO
-		       "Only GTA02 is supported by this ASoC driver\n");
-		return -ENODEV;
-	}
-
-	neo1973_gta02_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!neo1973_gta02_snd_device)
-		return -ENOMEM;
-
-	platform_set_drvdata(neo1973_gta02_snd_device, &neo1973_gta02);
-	ret = platform_device_add(neo1973_gta02_snd_device);
-	if (ret) {
-		platform_device_del(neo1973_gta02_snd_device);
-		return ret;
-	}
-
-	/* register bluetooth DAI here */
-	ret = snd_soc_register_dais(&neo1973_gta02_snd_device->dev, &bt_dai, 1);
-	if (ret)
-		goto err_unregister_device;
-
-	ret = gpio_request_array(neo1973_gta02_gpios,
-				ARRAY_SIZE(neo1973_gta02_gpios));
-	if (ret) {
-		pr_err("gta02_wm8753: Failed to request gpio\n");
-		goto err_unregister_dai;
-	}
-
-	return 0;
-
-err_unregister_dai:
-	snd_soc_unregister_dai(&neo1973_gta02_snd_device->dev);
-err_unregister_device:
-	platform_device_unregister(neo1973_gta02_snd_device);
-	return ret;
-}
-module_init(neo1973_gta02_init);
-
-static void __exit neo1973_gta02_exit(void)
-{
-	gpio_free_array(neo1973_gta02_gpios, ARRAY_SIZE(neo1973_gta02_gpios));
-	snd_soc_unregister_dais(&neo1973_gta02_snd_device->dev);
-	platform_device_unregister(neo1973_gta02_snd_device);
-}
-module_exit(neo1973_gta02_exit);
-
-/* Module information */
-MODULE_AUTHOR("Graeme Gregory, graeme@openmoko.org");
-MODULE_DESCRIPTION("ALSA SoC WM8753 Neo1973 GTA02");
-MODULE_LICENSE("GPL");
diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
index 21e85b0..fa20ee6 100644
--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -1,42 +1,33 @@
 /*
- * neo1973_wm8753.c  --  SoC audio for Neo1973
+ * neo1973_wm8753.c  --  SoC audio for Openmoko Neo1973 and Freerunner devices
  *
+ * Copyright 2007 Openmoko Inc
+ * Author: Graeme Gregory <graeme@openmoko.org>
  * Copyright 2007 Wolfson Microelectronics PLC.
  * Author: Graeme Gregory
  *         graeme.gregory@wolfsonmicro.com or linux@wolfsonmicro.com
+ * Copyright 2009 Wolfson Microelectronics
  *
  *  This program is free software; you can redistribute  it and/or modify it
  *  under  the terms of  the GNU General  Public License as published by the
  *  Free Software Foundation;  either version 2 of the  License, or (at your
  *  option) any later version.
- *
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/timer.h>
-#include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <sound/core.h>
-#include <sound/pcm.h>
+#include <linux/gpio.h>
+
 #include <sound/soc.h>
 
 #include <asm/mach-types.h>
-#include <mach/regs-clock.h>
-#include <mach/regs-gpio.h>
-#include <mach/hardware.h>
-#include <linux/io.h>
-#include <mach/spi-gpio.h>
-
 #include <plat/regs-iis.h>
+#include <mach/gta02.h>
 
 #include "../codecs/wm8753.h"
 #include "../codecs/lm4857.h"
-#include "dma.h"
 #include "s3c24xx-i2s.h"
 
-static struct snd_soc_card neo1973;
-
 static int neo1973_hifi_hw_params(struct snd_pcm_substream *substream,
 	struct snd_pcm_hw_params *params)
 {
@@ -47,8 +38,6 @@ static int neo1973_hifi_hw_params(struct snd_pcm_substream *substream,
 	int ret = 0;
 	unsigned long iis_clkrate;
 
-	pr_debug("Entered %s\n", __func__);
-
 	iis_clkrate = s3c24xx_i2s_get_clockrate();
 
 	switch (params_rate(params)) {
@@ -133,8 +122,6 @@ static int neo1973_hifi_hw_free(struct snd_pcm_substream *substream)
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_dai *codec_dai = rtd->codec_dai;
 
-	pr_debug("Entered %s\n", __func__);
-
 	/* disable the PLL */
 	return snd_soc_dai_set_pll(codec_dai, WM8753_PLL1, 0, 0, 0);
 }
@@ -156,8 +143,6 @@ static int neo1973_voice_hw_params(struct snd_pcm_substream *substream,
 	int ret = 0;
 	unsigned long iis_clkrate;
 
-	pr_debug("Entered %s\n", __func__);
-
 	iis_clkrate = s3c24xx_i2s_get_clockrate();
 
 	if (params_rate(params) != 8000)
@@ -199,8 +184,6 @@ static int neo1973_voice_hw_free(struct snd_pcm_substream *substream)
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_dai *codec_dai = rtd->codec_dai;
 
-	pr_debug("Entered %s\n", __func__);
-
 	/* disable the PLL */
 	return snd_soc_dai_set_pll(codec_dai, WM8753_PLL2, 0, 0, 0);
 }
@@ -210,20 +193,21 @@ static struct snd_soc_ops neo1973_voice_ops = {
 	.hw_free = neo1973_voice_hw_free,
 };
 
+/* Shared routes and controls */
+
 static const struct snd_soc_dapm_widget wm8753_dapm_widgets[] = {
-	SND_SOC_DAPM_LINE("Audio Out", NULL),
 	SND_SOC_DAPM_LINE("GSM Line Out", NULL),
 	SND_SOC_DAPM_LINE("GSM Line In", NULL),
 	SND_SOC_DAPM_MIC("Headset Mic", NULL),
-	SND_SOC_DAPM_MIC("Call Mic", NULL),
+	SND_SOC_DAPM_MIC("Handset Mic", NULL),
 };
 
 
-static const struct snd_soc_dapm_route dapm_routes[] = {
+static const struct snd_soc_dapm_route audio_map[] = {
 
-	/* Connections to the lm4857 amp */
-	{"Audio Out", NULL, "LOUT1"},
-	{"Audio Out", NULL, "ROUT1"},
+	/* Connections to the amp */
+	{"Stereo Out", NULL, "LOUT1"},
+	{"Stereo Out", NULL, "ROUT1"},
 
 	/* Connections to the GSM Module */
 	{"GSM Line Out", NULL, "MONO1"},
@@ -238,28 +222,109 @@ static const struct snd_soc_dapm_route dapm_routes[] = {
 	/* Call Mic */
 	{"MIC2", NULL, "Mic Bias"},
 	{"MIC2N", NULL, "Mic Bias"},
-	{"Mic Bias", NULL, "Call Mic"},
+	{"Mic Bias", NULL, "Handset Mic"},
 
 	/* Connect the ALC pins */
 	{"ACIN", NULL, "ACOP"},
 };
 
-/*
- * This is an example machine initialisation for a wm8753 connected to a
- * neo1973 II. It is missing logic to detect hp/mic insertions and logic
- * to re-route the audio in such an event.
- */
+static const struct snd_kcontrol_new wm8753_neo1973_controls[] = {
+	SOC_DAPM_PIN_SWITCH("Stereo Out"),
+	SOC_DAPM_PIN_SWITCH("GSM Line Out"),
+	SOC_DAPM_PIN_SWITCH("GSM Line In"),
+	SOC_DAPM_PIN_SWITCH("Headset Mic"),
+	SOC_DAPM_PIN_SWITCH("Handset Mic"),
+};
+
+/* GTA01 specific controlls */
+
+#ifdef CONFIG_MACH_NEO1973_GTA01
+
+static const struct snd_soc_dapm_widget wm8753_dapm_widgets_gta01[] = {
+	SND_SOC_DAPM_SPK("Stereo Out", NULL),
+};
+
+#else
+static const struct snd_soc_dapm_widget wm8753_dapm_widgets_gta01[] = {};
+#endif
+
+/* GTA02 specific routes and controlls */
+
+#ifdef CONFIG_MACH_NEO1973_GTA02
+
+static int gta02_speaker_enabled;
+
+static int lm4853_set_spk(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	gta02_speaker_enabled = ucontrol->value.integer.value[0];
+
+	gpio_set_value(GTA02_GPIO_HP_IN, !gta02_speaker_enabled);
+
+	return 0;
+}
+
+static int lm4853_get_spk(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	ucontrol->value.integer.value[0] = gta02_speaker_enabled;
+	return 0;
+}
+
+static int lm4853_event(struct snd_soc_dapm_widget *w,
+			struct snd_kcontrol *k, int event)
+{
+	gpio_set_value(GTA02_GPIO_AMP_SHUT, SND_SOC_DAPM_EVENT_OFF(event));
+
+	return 0;
+}
+
+static const struct snd_soc_dapm_route audio_map_gta02[] = {
+	/* Call Speaker */
+	{"Handset Spk", NULL, "LOUT2"},
+	{"Handset Spk", NULL, "ROUT2"},
+};
+
+static const struct snd_kcontrol_new wm8753_neo1973_gta02_controls[] = {
+	SOC_DAPM_PIN_SWITCH("Handset Spk"),
+
+	SOC_SINGLE_BOOL_EXT("Amp Spk Switch", 0,
+		lm4853_get_spk,
+		lm4853_set_spk),
+};
+
+static const struct snd_soc_dapm_widget wm8753_dapm_widgets_gta02[] = {
+	SND_SOC_DAPM_SPK("Stereo Out", lm4853_event),
+	SND_SOC_DAPM_SPK("Handset Spk", NULL),
+};
+
+#else
+static const struct snd_soc_dapm_route audio_map_gta02[] = {};
+static const struct snd_kcontrol_new wm8753_neo1973_gta02_controls[] = {};
+static const struct snd_soc_dapm_widget wm8753_dapm_widgets_gta02[] = {};
+#endif
+
 static int neo1973_wm8753_init(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_soc_codec *codec = rtd->codec;
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int err;
-
-	pr_debug("Entered %s\n", __func__);
+	const struct snd_soc_dapm_widget *machine_widgets;
+	size_t num_machine_widgets;
+
+	if (machine_is_neo1973_gta01()) {
+		machine_widgets		= wm8753_dapm_widgets_gta01;
+		num_machine_widgets	= ARRAY_SIZE(wm8753_dapm_widgets_gta01);
+	} else {
+		machine_widgets		= wm8753_dapm_widgets_gta02;
+		num_machine_widgets	= ARRAY_SIZE(wm8753_dapm_widgets_gta02);
+	}
 
 	/* set up NC codec pins */
-	snd_soc_dapm_nc_pin(dapm, "LOUT2");
-	snd_soc_dapm_nc_pin(dapm, "ROUT2");
+	if (machine_is_neo1973_gta01()) {
+		snd_soc_dapm_nc_pin(dapm, "LOUT2");
+		snd_soc_dapm_nc_pin(dapm, "ROUT2");
+	}
 	snd_soc_dapm_nc_pin(dapm, "OUT3");
 	snd_soc_dapm_nc_pin(dapm, "OUT4");
 	snd_soc_dapm_nc_pin(dapm, "LINE1");
@@ -269,21 +334,52 @@ static int neo1973_wm8753_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_new_controls(dapm, wm8753_dapm_widgets,
 				  ARRAY_SIZE(wm8753_dapm_widgets));
 
-	/* set endpoints to default mode */
-	snd_soc_dapm_disable_pin(codec, "Audio Out");
-	snd_soc_dapm_disable_pin(codec, "GSM Line Out");
-	snd_soc_dapm_disable_pin(codec, "GSM Line In");
-	snd_soc_dapm_disable_pin(codec, "Headset Mic");
-	snd_soc_dapm_disable_pin(codec, "Call Mic");
+	snd_soc_dapm_new_controls(dapm, machine_widgets, num_machine_widgets);
+
 
 	/* add neo1973 specific controls */
-	err = lm4857_add_controls(codec);
+	err = snd_soc_add_controls(codec, wm8753_neo1973_controls,
+					ARRAY_SIZE(wm8753_neo1973_controls));
+
+	if (err < 0)
+		return err;
+
+	if (machine_is_neo1973_gta01()) {
+		err = lm4857_add_controls(codec);
+	} else {
+		err = snd_soc_add_controls(codec, wm8753_neo1973_gta02_controls,
+			ARRAY_SIZE(wm8753_neo1973_gta02_controls));
+	}
+
 	if (err < 0)
 		return err;
 
-	/* set up neo1973 specific audio routes */
-	err = snd_soc_dapm_add_routes(dapm, dapm_routes,
-				      ARRAY_SIZE(dapm_routes));
+	/* set up neo1973 gta02 specific audio path audio_map */
+	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
+
+	if (machine_is_neo1973_gta02()) {
+		snd_soc_dapm_add_routes(dapm, audio_map_gta02,
+			ARRAY_SIZE(audio_map_gta02));
+	}
+
+	/* set endpoints to default off mode */
+	snd_soc_dapm_disable_pin(dapm, "Stereo Out");
+	snd_soc_dapm_disable_pin(dapm, "GSM Line Out");
+	snd_soc_dapm_disable_pin(dapm, "GSM Line In");
+	snd_soc_dapm_disable_pin(dapm, "Headset Mic");
+	snd_soc_dapm_disable_pin(dapm, "Handset Mic");
+
+	/* allow audio paths from the GSM modem to run during suspend */
+	snd_soc_dapm_ignore_suspend(dapm, "Stereo Out");
+	snd_soc_dapm_ignore_suspend(dapm, "GSM Line Out");
+	snd_soc_dapm_ignore_suspend(dapm, "GSM Line In");
+	snd_soc_dapm_ignore_suspend(dapm, "Headset Mic");
+	snd_soc_dapm_ignore_suspend(dapm, "Handset Mic");
+
+	if (machine_is_neo1973_gta02()) {
+		snd_soc_dapm_disable_pin(dapm, "Handset Spk");
+		snd_soc_dapm_ignore_suspend(dapm, "Handset Spk");
+	}
 
 	snd_soc_dapm_sync(dapm);
 	return 0;
@@ -292,18 +388,20 @@ static int neo1973_wm8753_init(struct snd_soc_pcm_runtime *rtd)
 /*
  * BT Codec DAI
  */
-static struct snd_soc_dai bt_dai = {
+static struct snd_soc_dai_driver bt_dai = {
 	.name = "bluetooth-dai",
 	.playback = {
 		.channels_min = 1,
 		.channels_max = 1,
 		.rates = SNDRV_PCM_RATE_8000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE,},
+		.formats = SNDRV_PCM_FMTBIT_S16_LE,
+	},
 	.capture = {
 		.channels_min = 1,
 		.channels_max = 1,
 		.rates = SNDRV_PCM_RATE_8000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE,},
+		.formats = SNDRV_PCM_FMTBIT_S16_LE,
+	},
 };
 
 static struct snd_soc_dai_link neo1973_dai[] = {
@@ -336,17 +434,24 @@ static struct snd_soc_card neo1973 = {
 
 static struct platform_device *neo1973_snd_device;
 
+#ifdef CONFIG_MACH_NEO1973_GTA02
+static const struct gpio neo1973_gta02_gpios[] = {
+	{ GTA02_GPIO_HP_IN, GPIOF_OUT_INIT_HIGH, "GTA02_HP_IN" },
+	{ GTA02_GPIO_AMP_SHUT, GPIOF_OUT_INIT_HIGH, "GTA02_AMP_SHUT" },
+};
+#else
+static const struct gpio neo1973_gta02_gpios[] = {};
+#endif
+
 static int __init neo1973_init(void)
 {
 	int ret;
 
-	pr_debug("Entered %s\n", __func__);
-
-	if (!machine_is_neo1973_gta01()) {
-		printk(KERN_INFO
-			"Only GTA01 hardware supported by ASoC driver\n");
+	if (!machine_is_neo1973_gta01() && !machine_is_neo1973_gta02())
 		return -ENODEV;
-	}
+
+	if (machine_is_neo1973_gta02())
+		neo1973.name = "neo1973gta02";
 
 	neo1973_snd_device = platform_device_alloc("soc-audio", -1);
 	if (!neo1973_snd_device)
@@ -360,23 +465,41 @@ static int __init neo1973_init(void)
 		return ret;
 	}
 
-	if (ret != 0)
-		platform_device_unregister(neo1973_snd_device);
+	/* register bluetooth DAI here */
+	ret = snd_soc_register_dais(&neo1973_snd_device->dev, &bt_dai, 1);
+	if (ret)
+		goto err_unregister_device;
 
+	if (machine_is_neo1973_gta02()) {
+		ret = gpio_request_array(neo1973_gta02_gpios,
+				ARRAY_SIZE(neo1973_gta02_gpios));
+		if (ret)
+			goto err_unregister_dais;
+	}
+
+	return 0;
+
+err_unregister_dais:
+	snd_soc_unregister_dais(&neo1973_snd_device->dev, 1);
+err_unregister_device:
+	platform_device_unregister(neo1973_snd_device);
 	return ret;
 }
+module_init(neo1973_init);
 
 static void __exit neo1973_exit(void)
 {
-	pr_debug("Entered %s\n", __func__);
+	if (machine_is_neo1973_gta02()) {
+		gpio_free_array(neo1973_gta02_gpios,
+				ARRAY_SIZE(neo1973_gta02_gpios));
+	}
 
+	snd_soc_unregister_dais(&neo1973_snd_device->dev, 1);
 	platform_device_unregister(neo1973_snd_device);
 }
-
-module_init(neo1973_init);
 module_exit(neo1973_exit);
 
 /* Module information */
 MODULE_AUTHOR("Graeme Gregory, graeme@openmoko.org, www.openmoko.org");
-MODULE_DESCRIPTION("ALSA SoC WM8753 Neo1973");
+MODULE_DESCRIPTION("ALSA SoC WM8753 Neo1973 and Frerunner");
 MODULE_LICENSE("GPL");
-- 
1.7.2.3

