Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab1JZON3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 10:13:29 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54018 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab1JZON2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 10:13:28 -0400
Message-ID: <1319638397.6637.2.camel@phoenix>
Subject: [PATCH] ASoC: tlv320aic3x: Use snd_soc_update_bits for
 read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jhnikula@gmail.com>,
        Vladimir Barinov <vbarinov@embeddedalley.com>,
        alsa-devel@alsa-project.org
Date: Wed, 26 Oct 2011 22:13:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snd_soc_update_bits for read-modify-write register access instead of
open-coding it using snd_soc_read and snd_soc_write

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/tlv320aic3x.c |   41 +++++++++++++--------------------------
 1 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 7a49390..a77f6ea 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -833,7 +833,6 @@ static int aic3x_hw_params(struct snd_pcm_substream *substream,
 	int codec_clk = 0, bypass_pll = 0, fsref, last_clk = 0;
 	u8 data, j, r, p, pll_q, pll_p = 1, pll_r = 1, pll_j = 1;
 	u16 d, pll_d = 1;
-	u8 reg;
 	int clk;
 
 	/* select data word length */
@@ -869,14 +868,13 @@ static int aic3x_hw_params(struct snd_pcm_substream *substream,
 		snd_soc_write(codec, AIC3X_PLL_PROGA_REG, pll_q << PLLQ_SHIFT);
 		snd_soc_write(codec, AIC3X_GPIOB_REG, CODEC_CLKIN_CLKDIV);
 		/* disable PLL if it is bypassed */
-		reg = snd_soc_read(codec, AIC3X_PLL_PROGA_REG);
-		snd_soc_write(codec, AIC3X_PLL_PROGA_REG, reg & ~PLL_ENABLE);
+		snd_soc_update_bits(codec, AIC3X_PLL_PROGA_REG, PLL_ENABLE, 0);
 
 	} else {
 		snd_soc_write(codec, AIC3X_GPIOB_REG, CODEC_CLKIN_PLLDIV);
 		/* enable PLL when it is used */
-		reg = snd_soc_read(codec, AIC3X_PLL_PROGA_REG);
-		snd_soc_write(codec, AIC3X_PLL_PROGA_REG, reg | PLL_ENABLE);
+		snd_soc_update_bits(codec, AIC3X_PLL_PROGA_REG,
+				    PLL_ENABLE, PLL_ENABLE);
 	}
 
 	/* Route Left DAC to left channel input and
@@ -1155,7 +1153,6 @@ static int aic3x_set_bias_level(struct snd_soc_codec *codec,
 				enum snd_soc_bias_level level)
 {
 	struct aic3x_priv *aic3x = snd_soc_codec_get_drvdata(codec);
-	u8 reg;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
@@ -1164,9 +1161,8 @@ static int aic3x_set_bias_level(struct snd_soc_codec *codec,
 		if (codec->dapm.bias_level == SND_SOC_BIAS_STANDBY &&
 		    aic3x->master) {
 			/* enable pll */
-			reg = snd_soc_read(codec, AIC3X_PLL_PROGA_REG);
-			snd_soc_write(codec, AIC3X_PLL_PROGA_REG,
-				      reg | PLL_ENABLE);
+			snd_soc_update_bits(codec, AIC3X_PLL_PROGA_REG,
+					    PLL_ENABLE, PLL_ENABLE);
 		}
 		break;
 	case SND_SOC_BIAS_STANDBY:
@@ -1175,9 +1171,8 @@ static int aic3x_set_bias_level(struct snd_soc_codec *codec,
 		if (codec->dapm.bias_level == SND_SOC_BIAS_PREPARE &&
 		    aic3x->master) {
 			/* disable pll */
-			reg = snd_soc_read(codec, AIC3X_PLL_PROGA_REG);
-			snd_soc_write(codec, AIC3X_PLL_PROGA_REG,
-				      reg & ~PLL_ENABLE);
+			snd_soc_update_bits(codec, AIC3X_PLL_PROGA_REG,
+					    PLL_ENABLE, 0);
 		}
 		break;
 	case SND_SOC_BIAS_OFF:
@@ -1294,7 +1289,6 @@ static int aic3x_resume(struct snd_soc_codec *codec)
 static int aic3x_init(struct snd_soc_codec *codec)
 {
 	struct aic3x_priv *aic3x = snd_soc_codec_get_drvdata(codec);
-	int reg;
 
 	snd_soc_write(codec, AIC3X_PAGE_SELECT, PAGE0_SELECT);
 	snd_soc_write(codec, AIC3X_RESET, SOFT_RESET);
@@ -1316,20 +1310,13 @@ static int aic3x_init(struct snd_soc_codec *codec)
 	snd_soc_write(codec, DACR1_2_MONOLOPM_VOL, DEFAULT_VOL | ROUTE_ON);
 
 	/* unmute all outputs */
-	reg = snd_soc_read(codec, LLOPM_CTRL);
-	snd_soc_write(codec, LLOPM_CTRL, reg | UNMUTE);
-	reg = snd_soc_read(codec, RLOPM_CTRL);
-	snd_soc_write(codec, RLOPM_CTRL, reg | UNMUTE);
-	reg = snd_soc_read(codec, MONOLOPM_CTRL);
-	snd_soc_write(codec, MONOLOPM_CTRL, reg | UNMUTE);
-	reg = snd_soc_read(codec, HPLOUT_CTRL);
-	snd_soc_write(codec, HPLOUT_CTRL, reg | UNMUTE);
-	reg = snd_soc_read(codec, HPROUT_CTRL);
-	snd_soc_write(codec, HPROUT_CTRL, reg | UNMUTE);
-	reg = snd_soc_read(codec, HPLCOM_CTRL);
-	snd_soc_write(codec, HPLCOM_CTRL, reg | UNMUTE);
-	reg = snd_soc_read(codec, HPRCOM_CTRL);
-	snd_soc_write(codec, HPRCOM_CTRL, reg | UNMUTE);
+	snd_soc_update_bits(codec, LLOPM_CTRL, UNMUTE, UNMUTE);
+	snd_soc_update_bits(codec, RLOPM_CTRL, UNMUTE, UNMUTE);
+	snd_soc_update_bits(codec, MONOLOPM_CTRL, UNMUTE, UNMUTE);
+	snd_soc_update_bits(codec, HPLOUT_CTRL, UNMUTE, UNMUTE);
+	snd_soc_update_bits(codec, HPROUT_CTRL, UNMUTE, UNMUTE);
+	snd_soc_update_bits(codec, HPLCOM_CTRL, UNMUTE, UNMUTE);
+	snd_soc_update_bits(codec, HPRCOM_CTRL, UNMUTE, UNMUTE);
 
 	/* ADC default volume and unmute */
 	snd_soc_write(codec, LADC_VOL, DEFAULT_GAIN);
-- 
1.7.5.4



