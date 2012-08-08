Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342Ab2HHJmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:42:44 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:34646 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030303Ab2HHJmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:42:13 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH 10/11] ASoC: twl4030: Add pointer to pdata within the private data
Date: Wed,  8 Aug 2012 12:41:26 +0300
Message-Id: <1344418887-5262-11-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Access the pdata via a pointer within the twl4030_priv structure.
In preparation for DeviceTree support.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl4030.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 6a00c01..bf0240d 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -153,8 +153,7 @@ struct twl4030_priv {
 	u8 predrivel_enabled, predriver_enabled;
 	u8 carkitl_enabled, carkitr_enabled;
 
-	/* Delay needed after enabling the digimic interface */
-	unsigned int digimic_delay;
+	struct twl4030_codec_data *pdata;
 };
 
 /*
@@ -350,7 +349,7 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 	if (!pdata)
 		return;
 
-	twl4030->digimic_delay = pdata->digimic_delay;
+	twl4030->pdata = pdata;
 
 	reg = twl4030_read_reg_cache(codec, TWL4030_REG_HS_POPN_SET);
 	reg &= ~TWL4030_RAMP_DELAY;
@@ -751,9 +750,9 @@ static int aif_event(struct snd_soc_dapm_widget *w,
 
 static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 {
-	struct twl4030_codec_data *pdata = codec->dev->platform_data;
 	unsigned char hs_gain, hs_pop;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
+	struct twl4030_codec_data *pdata = twl4030->pdata;
 	/* Base values for ramp delay calculation: 2^19 - 2^26 */
 	unsigned int ramp_base[] = {524288, 1048576, 2097152, 4194304,
 				    8388608, 16777216, 33554432, 67108864};
@@ -868,9 +867,10 @@ static int digimic_event(struct snd_soc_dapm_widget *w,
 		struct snd_kcontrol *kcontrol, int event)
 {
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(w->codec);
+	struct twl4030_codec_data *pdata = twl4030->pdata;
 
-	if (twl4030->digimic_delay)
-		twl4030_wait_ms(twl4030->digimic_delay);
+	if (pdata && pdata->digimic_delay)
+		twl4030_wait_ms(pdata->digimic_delay);
 	return 0;
 }
 
@@ -2252,8 +2252,8 @@ static int twl4030_soc_probe(struct snd_soc_codec *codec)
 
 static int twl4030_soc_remove(struct snd_soc_codec *codec)
 {
-	struct twl4030_codec_data *pdata = dev_get_platdata(codec->dev);
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
+	struct twl4030_codec_data *pdata = twl4030->pdata;
 
 	/* Reset registers to their chip default before leaving */
 	twl4030_reset_registers(codec);
-- 
1.7.8.6

