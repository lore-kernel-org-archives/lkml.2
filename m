Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab1JQWb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:31:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52738 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab1JQWb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:31:58 -0400
Message-ID: <1318890308.15935.0.camel@phoenix>
Subject: [PATCH v2] ASoC: ad193x: Use snd_soc_update_bits for
 read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Barry Song <21cnbao@gmail.com>,
        alsa-devel@alsa-project.org
Date: Tue, 18 Oct 2011 06:25:08 +0800
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
 sound/soc/codecs/ad193x.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index 39056ce..1206021 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -103,12 +103,14 @@ static const struct snd_soc_dapm_route audio_paths[] = {
 static int ad193x_mute(struct snd_soc_dai *dai, int mute)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	int reg;
 
-	reg = snd_soc_read(codec, AD193X_DAC_CTRL2);
-	reg = (mute > 0) ? reg | AD193X_DAC_MASTER_MUTE : reg &
-		(~AD193X_DAC_MASTER_MUTE);
-	snd_soc_write(codec, AD193X_DAC_CTRL2, reg);
+	if (mute)
+		snd_soc_update_bits(codec, AD193X_DAC_CTRL2,
+				    AD193X_DAC_MASTER_MUTE,
+				    AD193X_DAC_MASTER_MUTE);
+	else
+		snd_soc_update_bits(codec, AD193X_DAC_CTRL2,
+				    AD193X_DAC_MASTER_MUTE, 0);
 
 	return 0;
 }
@@ -262,7 +264,7 @@ static int ad193x_hw_params(struct snd_pcm_substream *substream,
 		struct snd_pcm_hw_params *params,
 		struct snd_soc_dai *dai)
 {
-	int word_len = 0, reg = 0, master_rate = 0;
+	int word_len = 0, master_rate = 0;
 
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_codec *codec = rtd->codec;
@@ -297,18 +299,15 @@ static int ad193x_hw_params(struct snd_pcm_substream *substream,
 		break;
 	}
 
-	reg = snd_soc_read(codec, AD193X_PLL_CLK_CTRL0);
-	reg = (reg & (~AD193X_PLL_INPUT_MASK)) | master_rate;
-	snd_soc_write(codec, AD193X_PLL_CLK_CTRL0, reg);
+	snd_soc_update_bits(codec, AD193X_PLL_CLK_CTRL0,
+			    AD193X_PLL_INPUT_MASK, master_rate);
 
-	reg = snd_soc_read(codec, AD193X_DAC_CTRL2);
-	reg = (reg & (~AD193X_DAC_WORD_LEN_MASK))
-		| (word_len << AD193X_DAC_WORD_LEN_SHFT);
-	snd_soc_write(codec, AD193X_DAC_CTRL2, reg);
+	snd_soc_update_bits(codec, AD193X_DAC_CTRL2,
+			    AD193X_DAC_WORD_LEN_MASK,
+			    word_len << AD193X_DAC_WORD_LEN_SHFT);
 
-	reg = snd_soc_read(codec, AD193X_ADC_CTRL1);
-	reg = (reg & (~AD193X_ADC_WORD_LEN_MASK)) | word_len;
-	snd_soc_write(codec, AD193X_ADC_CTRL1, reg);
+	snd_soc_update_bits(codec, AD193X_ADC_CTRL1,
+			    AD193X_ADC_WORD_LEN_MASK, word_len);
 
 	return 0;
 }
-- 
1.7.5.4



