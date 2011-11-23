Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1KWJjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 04:39:21 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:54447 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab1KWJjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 04:39:17 -0500
Message-ID: <1322041150.1753.25.camel@x61.thuisdomein>
Subject: [PATCH] sound: drop support for PlayPaq with WM8510
From: Paul Bolle <pebolle@tiscali.nl>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Wed, 23 Nov 2011 10:39:10 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SoC Audio support for PlayPaq with WM8510 got added in commit 9aaca9683b
("[ALSA] Revised AT32 ASoC Patch"). That support depends on
BOARD_PLAYPAQ. That Kconfig symbol didn't exist when that support got
added in v2.6.27. It still doesn't. It has never been possible to even
build this driver. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) "git grep" tested only (but quite thoroughly, I'd like to add).
Actual testing requires checking for collateral damage, for which access
is needed to hardware and toolchains that I do not have.

1) It hasn't been possible to build this driver since v2.6.37 for yet
another reason. Would anyone have tried (after first dropping the
BOARD_PLAYPAQ dependency) the build would have failed on
		goto err_gclk0;

since the label err_gclk0 is not defined anymore since commit f0fba2ad1b
("ASoC: multi-component - ASoC Multi-Component Support").

2) If this patch gets accepted then a follow up could be to drop the
wm8510 codec as it looks unused after this.

 sound/soc/atmel/Kconfig          |   21 +--
 sound/soc/atmel/Makefile         |    4 -
 sound/soc/atmel/playpaq_wm8510.c |  473 --------------------------------------
 3 files changed, 1 insertions(+), 497 deletions(-)
 delete mode 100644 sound/soc/atmel/playpaq_wm8510.c

diff --git a/sound/soc/atmel/Kconfig b/sound/soc/atmel/Kconfig
index bee3c94..d1fcc81 100644
--- a/sound/soc/atmel/Kconfig
+++ b/sound/soc/atmel/Kconfig
@@ -1,6 +1,6 @@
 config SND_ATMEL_SOC
 	tristate "SoC Audio for the Atmel System-on-Chip"
-	depends on ARCH_AT91 || AVR32
+	depends on ARCH_AT91
 	help
 	  Say Y or M if you want to add support for codecs attached to
 	  the ATMEL SSC interface. You will also need
@@ -24,25 +24,6 @@ config SND_AT91_SOC_SAM9G20_WM8731
 	  Say Y if you want to add support for SoC audio on WM8731-based
 	  AT91sam9g20 evaluation board.
 
-config SND_AT32_SOC_PLAYPAQ
-        tristate "SoC Audio support for PlayPaq with WM8510"
-        depends on SND_ATMEL_SOC && BOARD_PLAYPAQ && AT91_PROGRAMMABLE_CLOCKS
-        select SND_ATMEL_SOC_SSC
-        select SND_SOC_WM8510
-        help
-          Say Y or M here if you want to add support for SoC audio
-          on the LRS PlayPaq.
-
-config SND_AT32_SOC_PLAYPAQ_SLAVE
-        bool "Run CODEC on PlayPaq in slave mode"
-        depends on SND_AT32_SOC_PLAYPAQ
-        default n
-        help
-          Say Y if you want to run with the AT32 SSC generating the BCLK
-          and FRAME signals on the PlayPaq.  Unless you want to play
-          with the AT32 as the SSC master, you probably want to say N here,
-          as this will give you better sound quality.
-
 config SND_AT91_SOC_AFEB9260
 	tristate "SoC Audio support for AFEB9260 board"
 	depends on ARCH_AT91 && MACH_AFEB9260 && SND_ATMEL_SOC
diff --git a/sound/soc/atmel/Makefile b/sound/soc/atmel/Makefile
index e7ea56b..a5c0bf1 100644
--- a/sound/soc/atmel/Makefile
+++ b/sound/soc/atmel/Makefile
@@ -8,9 +8,5 @@ obj-$(CONFIG_SND_ATMEL_SOC_SSC) += snd-soc-atmel_ssc_dai.o
 # AT91 Machine Support
 snd-soc-sam9g20-wm8731-objs := sam9g20_wm8731.o
 
-# AT32 Machine Support
-snd-soc-playpaq-objs := playpaq_wm8510.o
-
 obj-$(CONFIG_SND_AT91_SOC_SAM9G20_WM8731) += snd-soc-sam9g20-wm8731.o
-obj-$(CONFIG_SND_AT32_SOC_PLAYPAQ) += snd-soc-playpaq.o
 obj-$(CONFIG_SND_AT91_SOC_AFEB9260) += snd-soc-afeb9260.o
diff --git a/sound/soc/atmel/playpaq_wm8510.c b/sound/soc/atmel/playpaq_wm8510.c
deleted file mode 100644
index 73ae99a..0000000
--- a/sound/soc/atmel/playpaq_wm8510.c
+++ /dev/null
@@ -1,473 +0,0 @@
-/* sound/soc/at32/playpaq_wm8510.c
- * ASoC machine driver for PlayPaq using WM8510 codec
- *
- * Copyright (C) 2008 Long Range Systems
- *    Geoffrey Wossum <gwossum@acm.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This code is largely inspired by sound/soc/at91/eti_b1_wm8731.c
- *
- * NOTE: If you don't have the AT32 enhanced portmux configured (which
- * isn't currently in the mainline or Atmel patched kernel), you will
- * need to set the MCLK pin (PA30) to peripheral A in your board initialization
- * code.  Something like:
- *	at32_select_periph(GPIO_PIN_PA(30), GPIO_PERIPH_A, 0);
- *
- */
-
-/* #define DEBUG */
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/clk.h>
-#include <linux/timer.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-
-#include <sound/core.h>
-#include <sound/pcm.h>
-#include <sound/pcm_params.h>
-#include <sound/soc.h>
-
-#include <mach/at32ap700x.h>
-#include <mach/portmux.h>
-
-#include "../codecs/wm8510.h"
-#include "atmel-pcm.h"
-#include "atmel_ssc_dai.h"
-
-
-/*-------------------------------------------------------------------------*\
- * constants
-\*-------------------------------------------------------------------------*/
-#define MCLK_PIN		GPIO_PIN_PA(30)
-#define MCLK_PERIPH		GPIO_PERIPH_A
-
-
-/*-------------------------------------------------------------------------*\
- * data types
-\*-------------------------------------------------------------------------*/
-/* SSC clocking data */
-struct ssc_clock_data {
-	/* CMR div */
-	unsigned int cmr_div;
-
-	/* Frame period (as needed by xCMR.PERIOD) */
-	unsigned int period;
-
-	/* The SSC clock rate these settings where calculated for */
-	unsigned long ssc_rate;
-};
-
-
-/*-------------------------------------------------------------------------*\
- * module data
-\*-------------------------------------------------------------------------*/
-static struct clk *_gclk0;
-static struct clk *_pll0;
-
-#define CODEC_CLK (_gclk0)
-
-
-/*-------------------------------------------------------------------------*\
- * Sound SOC operations
-\*-------------------------------------------------------------------------*/
-#if defined CONFIG_SND_AT32_SOC_PLAYPAQ_SLAVE
-static struct ssc_clock_data playpaq_wm8510_calc_ssc_clock(
-	struct snd_pcm_hw_params *params,
-	struct snd_soc_dai *cpu_dai)
-{
-	struct at32_ssc_info *ssc_p = snd_soc_dai_get_drvdata(cpu_dai);
-	struct ssc_device *ssc = ssc_p->ssc;
-	struct ssc_clock_data cd;
-	unsigned int rate, width_bits, channels;
-	unsigned int bitrate, ssc_div;
-	unsigned actual_rate;
-
-
-	/*
-	 * Figure out required bitrate
-	 */
-	rate = params_rate(params);
-	channels = params_channels(params);
-	width_bits = snd_pcm_format_physical_width(params_format(params));
-	bitrate = rate * width_bits * channels;
-
-
-	/*
-	 * Figure out required SSC divider and period for required bitrate
-	 */
-	cd.ssc_rate = clk_get_rate(ssc->clk);
-	ssc_div = cd.ssc_rate / bitrate;
-	cd.cmr_div = ssc_div / 2;
-	if (ssc_div & 1) {
-		/* round cmr_div up */
-		cd.cmr_div++;
-	}
-	cd.period = width_bits - 1;
-
-
-	/*
-	 * Find actual rate, compare to requested rate
-	 */
-	actual_rate = (cd.ssc_rate / (cd.cmr_div * 2)) / (2 * (cd.period + 1));
-	pr_debug("playpaq_wm8510: Request rate = %u, actual rate = %u\n",
-		 rate, actual_rate);
-
-
-	return cd;
-}
-#endif /* CONFIG_SND_AT32_SOC_PLAYPAQ_SLAVE */
-
-
-
-static int playpaq_wm8510_hw_params(struct snd_pcm_substream *substream,
-				    struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->codec_dai;
-	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
-	struct at32_ssc_info *ssc_p = snd_soc_dai_get_drvdata(cpu_dai);
-	struct ssc_device *ssc = ssc_p->ssc;
-	unsigned int pll_out = 0, bclk = 0, mclk_div = 0;
-	int ret;
-
-
-	/* Due to difficulties with getting the correct clocks from the AT32's
-	 * PLL0, we're going to let the CODEC be in charge of all the clocks
-	 */
-#if !defined CONFIG_SND_AT32_SOC_PLAYPAQ_SLAVE
-	const unsigned int fmt = (SND_SOC_DAIFMT_I2S |
-				  SND_SOC_DAIFMT_NB_NF |
-				  SND_SOC_DAIFMT_CBM_CFM);
-#else
-	struct ssc_clock_data cd;
-	const unsigned int fmt = (SND_SOC_DAIFMT_I2S |
-				  SND_SOC_DAIFMT_NB_NF |
-				  SND_SOC_DAIFMT_CBS_CFS);
-#endif
-
-	if (ssc == NULL) {
-		pr_warning("playpaq_wm8510_hw_params: ssc is NULL!\n");
-		return -EINVAL;
-	}
-
-
-	/*
-	 * Figure out PLL and BCLK dividers for WM8510
-	 */
-	switch (params_rate(params)) {
-	case 48000:
-		pll_out = 24576000;
-		mclk_div = WM8510_MCLKDIV_2;
-		bclk = WM8510_BCLKDIV_8;
-		break;
-
-	case 44100:
-		pll_out = 22579200;
-		mclk_div = WM8510_MCLKDIV_2;
-		bclk = WM8510_BCLKDIV_8;
-		break;
-
-	case 22050:
-		pll_out = 22579200;
-		mclk_div = WM8510_MCLKDIV_4;
-		bclk = WM8510_BCLKDIV_8;
-		break;
-
-	case 16000:
-		pll_out = 24576000;
-		mclk_div = WM8510_MCLKDIV_6;
-		bclk = WM8510_BCLKDIV_8;
-		break;
-
-	case 11025:
-		pll_out = 22579200;
-		mclk_div = WM8510_MCLKDIV_8;
-		bclk = WM8510_BCLKDIV_8;
-		break;
-
-	case 8000:
-		pll_out = 24576000;
-		mclk_div = WM8510_MCLKDIV_12;
-		bclk = WM8510_BCLKDIV_8;
-		break;
-
-	default:
-		pr_warning("playpaq_wm8510: Unsupported sample rate %d\n",
-			   params_rate(params));
-		return -EINVAL;
-	}
-
-
-	/*
-	 * set CPU and CODEC DAI configuration
-	 */
-	ret = snd_soc_dai_set_fmt(codec_dai, fmt);
-	if (ret < 0) {
-		pr_warning("playpaq_wm8510: "
-			   "Failed to set CODEC DAI format (%d)\n",
-			   ret);
-		return ret;
-	}
-	ret = snd_soc_dai_set_fmt(cpu_dai, fmt);
-	if (ret < 0) {
-		pr_warning("playpaq_wm8510: "
-			   "Failed to set CPU DAI format (%d)\n",
-			   ret);
-		return ret;
-	}
-
-
-	/*
-	 * Set CPU clock configuration
-	 */
-#if defined CONFIG_SND_AT32_SOC_PLAYPAQ_SLAVE
-	cd = playpaq_wm8510_calc_ssc_clock(params, cpu_dai);
-	pr_debug("playpaq_wm8510: cmr_div = %d, period = %d\n",
-		 cd.cmr_div, cd.period);
-	ret = snd_soc_dai_set_clkdiv(cpu_dai, AT32_SSC_CMR_DIV, cd.cmr_div);
-	if (ret < 0) {
-		pr_warning("playpaq_wm8510: Failed to set CPU CMR_DIV (%d)\n",
-			   ret);
-		return ret;
-	}
-	ret = snd_soc_dai_set_clkdiv(cpu_dai, AT32_SSC_TCMR_PERIOD,
-					  cd.period);
-	if (ret < 0) {
-		pr_warning("playpaq_wm8510: "
-			   "Failed to set CPU transmit period (%d)\n",
-			   ret);
-		return ret;
-	}
-#endif /* CONFIG_SND_AT32_SOC_PLAYPAQ_SLAVE */
-
-
-	/*
-	 * Set CODEC clock configuration
-	 */
-	pr_debug("playpaq_wm8510: "
-		 "pll_in = %ld, pll_out = %u, bclk = %x, mclk = %x\n",
-		 clk_get_rate(CODEC_CLK), pll_out, bclk, mclk_div);
-
-
-#if !defined CONFIG_SND_AT32_SOC_PLAYPAQ_SLAVE
-	ret = snd_soc_dai_set_clkdiv(codec_dai, WM8510_BCLKDIV, bclk);
-	if (ret < 0) {
-		pr_warning
-		    ("playpaq_wm8510: Failed to set CODEC DAI BCLKDIV (%d)\n",
-		     ret);
-		return ret;
-	}
-#endif /* CONFIG_SND_AT32_SOC_PLAYPAQ_SLAVE */
-
-
-	ret = snd_soc_dai_set_pll(codec_dai, 0, 0,
-					 clk_get_rate(CODEC_CLK), pll_out);
-	if (ret < 0) {
-		pr_warning("playpaq_wm8510: Failed to set CODEC DAI PLL (%d)\n",
-			   ret);
-		return ret;
-	}
-
-
-	ret = snd_soc_dai_set_clkdiv(codec_dai, WM8510_MCLKDIV, mclk_div);
-	if (ret < 0) {
-		pr_warning("playpaq_wm8510: Failed to set CODEC MCLKDIV (%d)\n",
-			   ret);
-		return ret;
-	}
-
-
-	return 0;
-}
-
-
-
-static struct snd_soc_ops playpaq_wm8510_ops = {
-	.hw_params = playpaq_wm8510_hw_params,
-};
-
-
-
-static const struct snd_soc_dapm_widget playpaq_dapm_widgets[] = {
-	SND_SOC_DAPM_MIC("Int Mic", NULL),
-	SND_SOC_DAPM_SPK("Ext Spk", NULL),
-};
-
-
-
-static const struct snd_soc_dapm_route intercon[] = {
-	/* speaker connected to SPKOUT */
-	{"Ext Spk", NULL, "SPKOUTP"},
-	{"Ext Spk", NULL, "SPKOUTN"},
-
-	{"Mic Bias", NULL, "Int Mic"},
-	{"MICN", NULL, "Mic Bias"},
-	{"MICP", NULL, "Mic Bias"},
-};
-
-
-
-static int playpaq_wm8510_init(struct snd_soc_pcm_runtime *rtd)
-{
-	struct snd_soc_codec *codec = rtd->codec;
-	struct snd_soc_dapm_context *dapm = &codec->dapm;
-	int i;
-
-	/*
-	 * Add DAPM widgets
-	 */
-	for (i = 0; i < ARRAY_SIZE(playpaq_dapm_widgets); i++)
-		snd_soc_dapm_new_control(dapm, &playpaq_dapm_widgets[i]);
-
-
-
-	/*
-	 * Setup audio path interconnects
-	 */
-	snd_soc_dapm_add_routes(dapm, intercon, ARRAY_SIZE(intercon));
-
-
-
-	/* always connected pins */
-	snd_soc_dapm_enable_pin(dapm, "Int Mic");
-	snd_soc_dapm_enable_pin(dapm, "Ext Spk");
-
-
-
-	/* Make CSB show PLL rate */
-	snd_soc_dai_set_clkdiv(rtd->codec_dai, WM8510_OPCLKDIV,
-				       WM8510_OPCLKDIV_1 | 4);
-
-	return 0;
-}
-
-
-
-static struct snd_soc_dai_link playpaq_wm8510_dai = {
-	.name = "WM8510",
-	.stream_name = "WM8510 PCM",
-	.cpu_dai_name= "atmel-ssc-dai.0",
-	.platform_name = "atmel-pcm-audio",
-	.codec_name = "wm8510-codec.0-0x1a",
-	.codec_dai_name = "wm8510-hifi",
-	.init = playpaq_wm8510_init,
-	.ops = &playpaq_wm8510_ops,
-};
-
-
-
-static struct snd_soc_card snd_soc_playpaq = {
-	.name = "LRS_PlayPaq_WM8510",
-	.dai_link = &playpaq_wm8510_dai,
-	.num_links = 1,
-};
-
-static struct platform_device *playpaq_snd_device;
-
-
-static int __init playpaq_asoc_init(void)
-{
-	int ret = 0;
-
-	/*
-	 * Configure MCLK for WM8510
-	 */
-	_gclk0 = clk_get(NULL, "gclk0");
-	if (IS_ERR(_gclk0)) {
-		_gclk0 = NULL;
-		ret = PTR_ERR(_gclk0);
-		goto err_gclk0;
-	}
-	_pll0 = clk_get(NULL, "pll0");
-	if (IS_ERR(_pll0)) {
-		_pll0 = NULL;
-		ret = PTR_ERR(_pll0);
-		goto err_pll0;
-	}
-	ret = clk_set_parent(_gclk0, _pll0);
-	if (ret) {
-		pr_warning("snd-soc-playpaq: "
-			   "Failed to set PLL0 as parent for DAC clock\n");
-		goto err_set_clk;
-	}
-	clk_set_rate(CODEC_CLK, 12000000);
-	clk_enable(CODEC_CLK);
-
-#if defined CONFIG_AT32_ENHANCED_PORTMUX
-	at32_select_periph(MCLK_PIN, MCLK_PERIPH, 0);
-#endif
-
-
-	/*
-	 * Create and register platform device
-	 */
-	playpaq_snd_device = platform_device_alloc("soc-audio", 0);
-	if (playpaq_snd_device == NULL) {
-		ret = -ENOMEM;
-		goto err_device_alloc;
-	}
-
-	platform_set_drvdata(playpaq_snd_device, &snd_soc_playpaq);
-
-	ret = platform_device_add(playpaq_snd_device);
-	if (ret) {
-		pr_warning("playpaq_wm8510: platform_device_add failed (%d)\n",
-			   ret);
-		goto err_device_add;
-	}
-
-	return 0;
-
-
-err_device_add:
-	if (playpaq_snd_device != NULL) {
-		platform_device_put(playpaq_snd_device);
-		playpaq_snd_device = NULL;
-	}
-err_device_alloc:
-err_set_clk:
-	if (_pll0 != NULL) {
-		clk_put(_pll0);
-		_pll0 = NULL;
-	}
-err_pll0:
-	if (_gclk0 != NULL) {
-		clk_put(_gclk0);
-		_gclk0 = NULL;
-	}
-	return ret;
-}
-
-
-static void __exit playpaq_asoc_exit(void)
-{
-	if (_gclk0 != NULL) {
-		clk_put(_gclk0);
-		_gclk0 = NULL;
-	}
-	if (_pll0 != NULL) {
-		clk_put(_pll0);
-		_pll0 = NULL;
-	}
-
-#if defined CONFIG_AT32_ENHANCED_PORTMUX
-	at32_free_pin(MCLK_PIN);
-#endif
-
-	platform_device_unregister(playpaq_snd_device);
-	playpaq_snd_device = NULL;
-}
-
-module_init(playpaq_asoc_init);
-module_exit(playpaq_asoc_exit);
-
-MODULE_AUTHOR("Geoffrey Wossum <gwossum@acm.org>");
-MODULE_DESCRIPTION("ASoC machine driver for LRS PlayPaq");
-MODULE_LICENSE("GPL");
-- 
1.7.7.3



