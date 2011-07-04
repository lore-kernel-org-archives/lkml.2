Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab1GDKGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:06:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44222 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128Ab1GDKGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:06:10 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 4/6] ASoC: twl6040: Configure PLL only once
Date: Mon, 4 Jul 2011 13:05:56 +0300
Message-ID: <1309773958-14608-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
References: <1309773958-14608-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid configuring the PLL several times during audio startup.
We can configure the PLL at prepare time with parameters collected
earlier hw_param, and set_dai_sysclk calls.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |   72 ++++++++++++++++---------------------------
 1 files changed, 27 insertions(+), 45 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 9229049..407c79e 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -1342,9 +1342,6 @@ static int twl6040_set_bias_level(struct snd_soc_codec *codec,
 		break;
 	}
 
-	/* get PLL and sysclk after power transition */
-	priv->pll = twl6040_get_pll(twl6040);
-	priv->sysclk = twl6040_get_sysclk(twl6040);
 	codec->dapm.bias_level = level;
 
 	return 0;
@@ -1370,14 +1367,8 @@ static int twl6040_hw_params(struct snd_pcm_substream *substream,
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_codec *codec = rtd->codec;
-	struct twl6040 *twl6040 = codec->control_data;
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
-	unsigned int sysclk;
-	int rate, ret;
-
-	/* nothing to do for high-perf pll, it supports only 48 kHz */
-	if (priv->pll == TWL6040_HPPLL_ID)
-		return 0;
+	int rate;
 
 	rate = params_rate(params);
 	switch (rate) {
@@ -1385,26 +1376,33 @@ static int twl6040_hw_params(struct snd_pcm_substream *substream,
 	case 22500:
 	case 44100:
 	case 88200:
-		sysclk = 17640000;
+		/* These rates are not supported when HPPLL is in use */
+		if (unlikely(priv->pll == TWL6040_SYSCLK_SEL_HPPLL)) {
+			dev_err(codec->dev, "HPPLL does not support rate %d\n",
+				rate);
+			return -EINVAL;
+		}
+		/* Capture is not supported with 17.64MHz sysclk */
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
+			dev_err(codec->dev,
+				"capture mode is not supported at %dHz\n",
+				rate);
+			return -EINVAL;
+		}
+		priv->sysclk = 17640000;
 		break;
 	case 8000:
 	case 16000:
 	case 32000:
 	case 48000:
 	case 96000:
-		sysclk = 19200000;
+		priv->sysclk = 19200000;
 		break;
 	default:
 		dev_err(codec->dev, "unsupported rate %d\n", rate);
 		return -EINVAL;
 	}
 
-	ret = twl6040_set_pll(twl6040, TWL6040_LPPLL_ID, priv->clk_in, sysclk);
-	if (ret)
-		return ret;
-
-	priv->sysclk = twl6040_get_sysclk(twl6040);
-
 	return 0;
 }
 
@@ -1413,7 +1411,9 @@ static int twl6040_prepare(struct snd_pcm_substream *substream,
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_codec *codec = rtd->codec;
+	struct twl6040 *twl6040 = codec->control_data;
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
+	int ret;
 
 	if (!priv->sysclk) {
 		dev_err(codec->dev,
@@ -1421,24 +1421,19 @@ static int twl6040_prepare(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
-	/*
-	 * capture is not supported at 17.64 MHz,
-	 * it's reserved for headset low-power playback scenario
-	 */
-	if ((priv->sysclk == 17640000) &&
-			substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
-		dev_err(codec->dev,
-			"capture mode is not supported at %dHz\n",
-			priv->sysclk);
-		return -EINVAL;
-	}
-
 	if ((priv->sysclk == 17640000) && priv->non_lp) {
 			dev_err(codec->dev,
 				"some enabled paths aren't supported at %dHz\n",
 				priv->sysclk);
 			return -EPERM;
 	}
+
+	ret = twl6040_set_pll(twl6040, priv->pll, priv->clk_in, priv->sysclk);
+	if (ret) {
+		dev_err(codec->dev, "Can not set PLL (%d)\n", ret);
+		return -EPERM;
+	}
+
 	return 0;
 }
 
@@ -1446,32 +1441,19 @@ static int twl6040_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 		int clk_id, unsigned int freq, int dir)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	struct twl6040 *twl6040 = codec->control_data;
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
-	int ret = 0;
 
 	switch (clk_id) {
 	case TWL6040_SYSCLK_SEL_LPPLL:
-		ret = twl6040_set_pll(twl6040, TWL6040_LPPLL_ID,
-				      freq, priv->sysclk);
-		if (ret)
-			return ret;
-		break;
 	case TWL6040_SYSCLK_SEL_HPPLL:
-		ret = twl6040_set_pll(twl6040, TWL6040_HPPLL_ID,
-				      freq, priv->sysclk);
-		if (ret)
-			return ret;
+		priv->pll = clk_id;
+		priv->clk_in = freq;
 		break;
 	default:
 		dev_err(codec->dev, "unknown clk_id %d\n", clk_id);
 		return -EINVAL;
 	}
 
-	priv->pll = twl6040_get_pll(twl6040);
-	priv->clk_in = freq;
-	priv->sysclk = twl6040_get_sysclk(twl6040);
-
 	return 0;
 }
 
-- 
1.7.6

