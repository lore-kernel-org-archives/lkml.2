Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab1KXRR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 12:17:27 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:49834 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1KXRR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 12:17:26 -0500
Message-ID: <1322155037.25125.61.camel@x61.thuisdomein>
Subject: [PATCH] ASoC: samsung: drop unknown Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Jassi Brar <jassisinghbrar@gmail.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Thu, 24 Nov 2011 18:17:17 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no Kconfig symbol 'MACH_NEO1973_GTA01'. So drop all Kconfig
references to that symbol and all code that depends on
CONFIG_MACH_NEO1973_GTA01. This also allows for some related cleanups
(eg, drop some checks for CONFIG_MACH_NEO1973_GTA02, as they have become
useless). Update a few strings too, to make clear that the Openmoko Neo
Freerunner (GTA02) is supported while the Openmoko Neo 1973 (GTA01)
isn't.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This needs thorough testing: I have got neither the hardware nor the
toolchain needed to do that. Also note that the ASoC subsystem is a bit
of a mystery to me.  

1) There were a surprising number of GTA01 related commits in mainline.
I'm not going to list all these here. But there were no commits that
actually added support for that machine. See the output of this command:
    git log --no-merges -p | grep -w -e MACH_GTA01 -e MACH_NEO1973_GTA01

(Is there an easier - or quicker - way to do that?) That won't contain a
line like:
    +config MACH_NEO1973_GTA01

which one would expect if support had ever been added.

2) A follow up to this patch might be a patch to drop support for the
lm4857 codec, as it seems GTA01 specific. (There's currently still a few
references to lm4857 in the code, which look a bit strange to me. I
simply wasn't sure if they are actually - elaborate - nops and could
also be removed.)

 sound/soc/samsung/Kconfig          |    9 ++--
 sound/soc/samsung/neo1973_wm8753.c |   94 +++++------------------------------
 2 files changed, 18 insertions(+), 85 deletions(-)

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 53aaa69..2983ed6 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -35,15 +35,14 @@ config SND_SAMSUNG_I2S
 	tristate
 
 config SND_SOC_SAMSUNG_NEO1973_WM8753
-	tristate "Audio support for Openmoko Neo1973 Smartphones (GTA01/GTA02)"
-	depends on SND_SOC_SAMSUNG && (MACH_NEO1973_GTA01 || MACH_NEO1973_GTA02)
+	tristate "Audio support for Openmoko Neo Freerunner Smartphone (GTA02)"
+	depends on SND_SOC_SAMSUNG && MACH_NEO1973_GTA02
 	select SND_S3C24XX_I2S
 	select SND_SOC_WM8753
-	select SND_SOC_LM4857 if MACH_NEO1973_GTA01
 	select SND_SOC_DFBMCS320
 	help
-	  Say Y here to enable audio support for the Openmoko Neo1973
-	  Smartphones.
+	  Say Y here to enable audio support for the Openmoko Neo Freerunner
+	  Smartphone (GTA02).
 
 config SND_SOC_SAMSUNG_JIVE_WM8750
 	tristate "SoC I2S Audio support for Jive"
diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
index 7207189..b1c6c79 100644
--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -1,5 +1,5 @@
 /*
- * neo1973_wm8753.c  --  SoC audio for Openmoko Neo1973 and Freerunner devices
+ * neo1973_wm8753.c  --  SoC audio for Openmoko Neo Freerunner devices
  *
  * Copyright 2007 Openmoko Inc
  * Author: Graeme Gregory <graeme@openmoko.org>
@@ -228,10 +228,6 @@ static const struct snd_kcontrol_new neo1973_wm8753_controls[] = {
 	SOC_DAPM_PIN_SWITCH("Handset Mic"),
 };
 
-/* GTA02 specific routes and controls */
-
-#ifdef CONFIG_MACH_NEO1973_GTA02
-
 static int gta02_speaker_enabled;
 
 static int lm4853_set_spk(struct snd_kcontrol *kcontrol,
@@ -311,10 +307,6 @@ static int neo1973_gta02_wm8753_init(struct snd_soc_codec *codec)
 	return 0;
 }
 
-#else
-static int neo1973_gta02_wm8753_init(struct snd_soc_code *codec) { return 0; }
-#endif
-
 static int neo1973_wm8753_init(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_soc_codec *codec = rtd->codec;
@@ -322,10 +314,6 @@ static int neo1973_wm8753_init(struct snd_soc_pcm_runtime *rtd)
 	int ret;
 
 	/* set up NC codec pins */
-	if (machine_is_neo1973_gta01()) {
-		snd_soc_dapm_nc_pin(dapm, "LOUT2");
-		snd_soc_dapm_nc_pin(dapm, "ROUT2");
-	}
 	snd_soc_dapm_nc_pin(dapm, "OUT3");
 	snd_soc_dapm_nc_pin(dapm, "OUT4");
 	snd_soc_dapm_nc_pin(dapm, "LINE1");
@@ -361,58 +349,14 @@ static int neo1973_wm8753_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_ignore_suspend(dapm, "Headset Mic");
 	snd_soc_dapm_ignore_suspend(dapm, "Handset Mic");
 
-	if (machine_is_neo1973_gta02()) {
-		ret = neo1973_gta02_wm8753_init(codec);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-/* GTA01 specific controls */
-
-#ifdef CONFIG_MACH_NEO1973_GTA01
-
-static const struct snd_soc_dapm_route neo1973_lm4857_routes[] = {
-	{"Amp IN", NULL, "ROUT1"},
-	{"Amp IN", NULL, "LOUT1"},
-
-	{"Handset Spk", NULL, "Amp EP"},
-	{"Stereo Out", NULL, "Amp LS"},
-	{"Headphone", NULL, "Amp HP"},
-};
-
-static const struct snd_soc_dapm_widget neo1973_lm4857_dapm_widgets[] = {
-	SND_SOC_DAPM_SPK("Handset Spk", NULL),
-	SND_SOC_DAPM_SPK("Stereo Out", NULL),
-	SND_SOC_DAPM_HP("Headphone", NULL),
-};
-
-static int neo1973_lm4857_init(struct snd_soc_dapm_context *dapm)
-{
-	int ret;
-
-	ret = snd_soc_dapm_new_controls(dapm, neo1973_lm4857_dapm_widgets,
-			ARRAY_SIZE(neo1973_lm4857_dapm_widgets));
+	ret = neo1973_gta02_wm8753_init(codec);
 	if (ret)
 		return ret;
 
-	ret = snd_soc_dapm_add_routes(dapm, neo1973_lm4857_routes,
-			ARRAY_SIZE(neo1973_lm4857_routes));
-	if (ret)
-		return ret;
-
-	snd_soc_dapm_ignore_suspend(dapm, "Stereo Out");
-	snd_soc_dapm_ignore_suspend(dapm, "Handset Spk");
-	snd_soc_dapm_ignore_suspend(dapm, "Headphone");
-
 	return 0;
 }
 
-#else
 static int neo1973_lm4857_init(struct snd_soc_dapm_context *dapm) { return 0; };
-#endif
 
 static struct snd_soc_dai_link neo1973_dai[] = {
 { /* Hifi Playback - for similatious use with voice below */
@@ -454,14 +398,10 @@ static struct snd_soc_codec_conf neo1973_codec_conf[] = {
 	},
 };
 
-#ifdef CONFIG_MACH_NEO1973_GTA02
 static const struct gpio neo1973_gta02_gpios[] = {
 	{ GTA02_GPIO_HP_IN, GPIOF_OUT_INIT_HIGH, "GTA02_HP_IN" },
 	{ GTA02_GPIO_AMP_SHUT, GPIOF_OUT_INIT_HIGH, "GTA02_AMP_SHUT" },
 };
-#else
-static const struct gpio neo1973_gta02_gpios[] = {};
-#endif
 
 static struct snd_soc_card neo1973 = {
 	.name = "neo1973",
@@ -479,18 +419,16 @@ static int __init neo1973_init(void)
 {
 	int ret;
 
-	if (!machine_is_neo1973_gta01() && !machine_is_neo1973_gta02())
+	if (!machine_is_neo1973_gta02())
 		return -ENODEV;
 
-	if (machine_is_neo1973_gta02()) {
-		neo1973.name = "neo1973gta02";
-		neo1973.num_aux_devs = 1;
+	neo1973.name = "neo1973gta02";
+	neo1973.num_aux_devs = 1;
 
-		ret = gpio_request_array(neo1973_gta02_gpios,
-				ARRAY_SIZE(neo1973_gta02_gpios));
-		if (ret)
-			return ret;
-	}
+	ret = gpio_request_array(neo1973_gta02_gpios,
+			ARRAY_SIZE(neo1973_gta02_gpios));
+	if (ret)
+		return ret;
 
 	neo1973_snd_device = platform_device_alloc("soc-audio", -1);
 	if (!neo1973_snd_device) {
@@ -509,10 +447,8 @@ static int __init neo1973_init(void)
 err_put_device:
 	platform_device_put(neo1973_snd_device);
 err_gpio_free:
-	if (machine_is_neo1973_gta02()) {
-		gpio_free_array(neo1973_gta02_gpios,
-				ARRAY_SIZE(neo1973_gta02_gpios));
-	}
+	gpio_free_array(neo1973_gta02_gpios,
+			ARRAY_SIZE(neo1973_gta02_gpios));
 	return ret;
 }
 module_init(neo1973_init);
@@ -521,14 +457,12 @@ static void __exit neo1973_exit(void)
 {
 	platform_device_unregister(neo1973_snd_device);
 
-	if (machine_is_neo1973_gta02()) {
-		gpio_free_array(neo1973_gta02_gpios,
-				ARRAY_SIZE(neo1973_gta02_gpios));
-	}
+	gpio_free_array(neo1973_gta02_gpios,
+			ARRAY_SIZE(neo1973_gta02_gpios));
 }
 module_exit(neo1973_exit);
 
 /* Module information */
 MODULE_AUTHOR("Graeme Gregory, graeme@openmoko.org, www.openmoko.org");
-MODULE_DESCRIPTION("ALSA SoC WM8753 Neo1973 and Frerunner");
+MODULE_DESCRIPTION("ALSA SoC WM8753 Neo Freerunner");
 MODULE_LICENSE("GPL");
-- 
1.7.7.3

