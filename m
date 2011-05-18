Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab1ERPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:25:27 -0400
Received: from smtp16.mail.ru ([94.100.176.153]:51047 "EHLO smtp16.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab1ERPZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:25:18 -0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Eric Miao <eric.y.miao@gmail.com>, Harald Welte <laforge@gnumonks.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 2/3] ASoC: add iPAQ hx4700 machine driver
Date: Wed, 18 May 2011 19:25:10 +0400
Message-Id: <1305732311-17639-3-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1305732311-17639-1-git-send-email-mad_soft@inbox.ru>
References: <1305732311-17639-1-git-send-email-mad_soft@inbox.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AK4641 connected via I2S and I2C, jack detection via GPIO.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 sound/soc/pxa/Kconfig  |    9 ++
 sound/soc/pxa/Makefile |    2 +
 sound/soc/pxa/hx4700.c |  255 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 266 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/pxa/hx4700.c

diff --git a/sound/soc/pxa/Kconfig b/sound/soc/pxa/Kconfig
index 580f485..33ebc46 100644
--- a/sound/soc/pxa/Kconfig
+++ b/sound/soc/pxa/Kconfig
@@ -155,6 +155,15 @@ config SND_SOC_RAUMFELD
 	help
 	  Say Y if you want to add support for SoC audio on Raumfeld devices
 
+config SND_PXA2XX_SOC_HX4700
+	tristate "SoC Audio support for HP iPAQ hx4700"
+	depends on SND_PXA2XX_SOC && MACH_H4700
+	select SND_PXA2XX_SOC_I2S
+	select SND_SOC_AK4641
+	help
+	  Say Y if you want to add support for SoC audio on the
+	  HP iPAQ hx4700.
+
 config SND_PXA2XX_SOC_MAGICIAN
 	tristate "SoC Audio support for HTC Magician"
 	depends on SND_PXA2XX_SOC && MACH_MAGICIAN
diff --git a/sound/soc/pxa/Makefile b/sound/soc/pxa/Makefile
index 0766016..af35762 100644
--- a/sound/soc/pxa/Makefile
+++ b/sound/soc/pxa/Makefile
@@ -22,6 +22,7 @@ snd-soc-palm27x-objs := palm27x.o
 snd-soc-saarb-objs := saarb.o
 snd-soc-tavorevb3-objs := tavorevb3.o
 snd-soc-zylonite-objs := zylonite.o
+snd-soc-hx4700-objs := hx4700.o
 snd-soc-magician-objs := magician.o
 snd-soc-mioa701-objs := mioa701_wm9713.o
 snd-soc-z2-objs := z2.o
@@ -37,6 +38,7 @@ obj-$(CONFIG_SND_PXA2XX_SOC_E800) += snd-soc-e800.o
 obj-$(CONFIG_SND_PXA2XX_SOC_SPITZ) += snd-soc-spitz.o
 obj-$(CONFIG_SND_PXA2XX_SOC_EM_X270) += snd-soc-em-x270.o
 obj-$(CONFIG_SND_PXA2XX_SOC_PALM27X) += snd-soc-palm27x.o
+obj-$(CONFIG_SND_PXA2XX_SOC_HX4700) += snd-soc-hx4700.o
 obj-$(CONFIG_SND_PXA2XX_SOC_MAGICIAN) += snd-soc-magician.o
 obj-$(CONFIG_SND_PXA2XX_SOC_MIOA701) += snd-soc-mioa701.o
 obj-$(CONFIG_SND_PXA2XX_SOC_Z2) += snd-soc-z2.o
diff --git a/sound/soc/pxa/hx4700.c b/sound/soc/pxa/hx4700.c
new file mode 100644
index 0000000..65c1248
--- /dev/null
+++ b/sound/soc/pxa/hx4700.c
@@ -0,0 +1,255 @@
+/*
+ * SoC audio for HP iPAQ hx4700
+ *
+ * Copyright (c) 2009 Philipp Zabel
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+
+#include <sound/core.h>
+#include <sound/jack.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+
+#include <mach/hx4700.h>
+#include <asm/mach-types.h>
+#include "pxa2xx-i2s.h"
+
+#include "../codecs/ak4641.h"
+
+static struct snd_soc_jack hs_jack;
+
+/* Headphones jack detection DAPM pin */
+static struct snd_soc_jack_pin hs_jack_pin[] = {
+	{
+		.pin	= "Headphone Jack",
+		.mask	= SND_JACK_HEADPHONE,
+	},
+	{
+		.pin	= "Speaker",
+		/* disable speaker when hp jack is inserted */
+		.mask   = SND_JACK_HEADPHONE,
+		.invert	= 1,
+	},
+};
+
+/* Headphones jack detection GPIO */
+static struct snd_soc_jack_gpio hs_jack_gpio = {
+	.gpio		= GPIO75_HX4700_EARPHONE_nDET,
+	.invert		= true,
+	.name		= "hp-gpio",
+	.report		= SND_JACK_HEADPHONE,
+	.debounce_time	= 200,
+};
+
+/*
+ * iPAQ hx4700 uses I2S for capture and playback.
+ */
+static int hx4700_hw_params(struct snd_pcm_substream *substream,
+			    struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
+	int ret = 0;
+
+	/* set codec DAI configuration */
+	ret = snd_soc_dai_set_fmt(codec_dai,
+			SND_SOC_DAIFMT_MSB | SND_SOC_DAIFMT_NB_NF |
+			SND_SOC_DAIFMT_CBS_CFS);
+	if (ret < 0)
+		return ret;
+
+	/* set cpu DAI configuration */
+	ret = snd_soc_dai_set_fmt(cpu_dai,
+			SND_SOC_DAIFMT_MSB | SND_SOC_DAIFMT_NB_NF |
+			SND_SOC_DAIFMT_CBS_CFS);
+	if (ret < 0)
+		return ret;
+
+	/* set the I2S system clock as output */
+	ret = snd_soc_dai_set_sysclk(cpu_dai, PXA2XX_I2S_SYSCLK, 0,
+			SND_SOC_CLOCK_OUT);
+	if (ret < 0)
+		return ret;
+
+	/* inform codec driver about clock freq *
+	 * (PXA I2S always uses divider 256)    */
+	ret = snd_soc_dai_set_sysclk(codec_dai, 0, 256 * params_rate(params),
+			SND_SOC_CLOCK_IN);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static struct snd_soc_ops hx4700_ops = {
+	.hw_params = hx4700_hw_params,
+};
+
+static int hx4700_spk_power(struct snd_soc_dapm_widget *w,
+			    struct snd_kcontrol *k, int event)
+{
+	gpio_set_value(GPIO107_HX4700_SPK_nSD, !!SND_SOC_DAPM_EVENT_ON(event));
+	return 0;
+}
+
+static int hx4700_hp_power(struct snd_soc_dapm_widget *w,
+			   struct snd_kcontrol *k, int event)
+{
+	gpio_set_value(GPIO92_HX4700_HP_DRIVER, !!SND_SOC_DAPM_EVENT_ON(event));
+	return 0;
+}
+
+/* hx4700 machine dapm widgets */
+static const struct snd_soc_dapm_widget hx4700_dapm_widgets[] = {
+	SND_SOC_DAPM_HP("Headphone Jack", hx4700_hp_power),
+	SND_SOC_DAPM_SPK("Speaker", hx4700_spk_power),
+	SND_SOC_DAPM_MIC("Built-in Microphone", NULL),
+};
+
+/* hx4700 machine audio_map */
+static const struct snd_soc_dapm_route hx4700_audio_map[] = {
+
+	/* Headphone connected to LOUT, ROUT */
+	{"Headphone Jack", NULL, "LOUT"},
+	{"Headphone Jack", NULL, "ROUT"},
+
+	/* Speaker connected to MOUT2 */
+	{"Speaker", NULL, "MOUT2"},
+
+	/* Microphone connected to MICIN */
+	{"MICIN", NULL, "Built-in Microphone"},
+	{"AIN", NULL, "MICOUT"},
+};
+
+/*
+ * Logic for a ak4641 as connected on a HP iPAQ hx4700
+ */
+static int hx4700_ak4641_init(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_soc_codec *codec = rtd->codec;
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
+	int err;
+
+	/* NC codec pins */
+	/* FIXME: is anything connected here? */
+	snd_soc_dapm_nc_pin(dapm, "MOUT1");
+	snd_soc_dapm_nc_pin(dapm, "MICEXT");
+	snd_soc_dapm_nc_pin(dapm, "AUX");
+
+	/* Jack detection API stuff */
+	err = snd_soc_jack_new(codec, "Headphone Jack",
+				SND_JACK_HEADPHONE, &hs_jack);
+	if (err)
+		return err;
+
+	err = snd_soc_jack_add_pins(&hs_jack, ARRAY_SIZE(hs_jack_pin),
+					hs_jack_pin);
+	if (err)
+		return err;
+
+	err = snd_soc_jack_add_gpios(&hs_jack, 1, &hs_jack_gpio);
+
+	return err;
+}
+
+/* hx4700 digital audio interface glue - connects codec <--> CPU */
+static struct snd_soc_dai_link hx4700_dai = {
+	.name = "ak4641",
+	.stream_name = "AK4641",
+	.cpu_dai_name = "pxa2xx-i2s",
+	.codec_dai_name = "ak4641-hifi",
+	.platform_name = "pxa-pcm-audio",
+	.codec_name = "ak4641.0-0012",
+	.init = hx4700_ak4641_init,
+	.ops = &hx4700_ops,
+};
+
+/* hx4700 audio machine driver */
+static struct snd_soc_card snd_soc_card_hx4700 = {
+	.name			= "iPAQ hx4700",
+	.dai_link		= &hx4700_dai,
+	.num_links		= 1,
+	.dapm_widgets		= hx4700_dapm_widgets,
+	.num_dapm_widgets	= ARRAY_SIZE(hx4700_dapm_widgets),
+	.dapm_routes		= hx4700_audio_map,
+	.num_dapm_routes	= ARRAY_SIZE(hx4700_audio_map),
+};
+
+static struct gpio hx4700_audio_gpios[] = {
+	{ GPIO107_HX4700_SPK_nSD, GPIOF_OUT_INIT_HIGH, "SPK_POWER" },
+	{ GPIO92_HX4700_HP_DRIVER, GPIOF_OUT_INIT_LOW, "EP_POWER" },
+};
+
+static int __devinit hx4700_audio_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	if (!machine_is_h4700())
+		return -ENODEV;
+
+	ret = gpio_request_array(hx4700_audio_gpios,
+				ARRAY_SIZE(hx4700_audio_gpios));
+	if (ret)
+		return ret;
+
+	snd_soc_card_hx4700.dev = &pdev->dev;
+	ret = snd_soc_register_card(&snd_soc_card_hx4700);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int __devexit hx4700_audio_remove(struct platform_device *pdev)
+{
+	snd_soc_jack_free_gpios(&hs_jack, 1, &hs_jack_gpio);
+	snd_soc_unregister_card(&snd_soc_card_hx4700);
+
+	gpio_set_value(GPIO92_HX4700_HP_DRIVER, 0);
+	gpio_set_value(GPIO107_HX4700_SPK_nSD, 0);
+
+	gpio_free_array(hx4700_audio_gpios, ARRAY_SIZE(hx4700_audio_gpios));
+	return 0;
+}
+
+static struct platform_driver hx4700_audio_driver = {
+	.driver	= {
+		.name = "hx4700-audio",
+		.owner = THIS_MODULE,
+		.pm = &snd_soc_pm_ops,
+	},
+	.probe	= hx4700_audio_probe,
+	.remove	= __devexit_p(hx4700_audio_remove),
+};
+
+static int __init hx4700_modinit(void)
+{
+	return platform_driver_register(&hx4700_audio_driver);
+}
+module_init(hx4700_modinit);
+
+static void __exit hx4700_modexit(void)
+{
+	platform_driver_unregister(&hx4700_audio_driver);
+}
+
+module_exit(hx4700_modexit);
+
+MODULE_AUTHOR("Philipp Zabel");
+MODULE_DESCRIPTION("ALSA SoC iPAQ hx4700");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:hx4700-audio");
-- 
1.7.4.rc3

