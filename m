Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1JNJDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:03:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55769 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1JNJDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:03:14 -0400
Subject: [PATCH 2/2] ASoC: ad193x: Use snd_soc_update_bits for
 read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Barry Song <21cnbao@gmail.com>, alsa-devel@alsa-project.org
In-Reply-To: <1318582919.19976.1.camel@phoenix>
References: <1318582919.19976.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 17:03:07 +0800
Message-ID: <1318582987.19976.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snd_soc_update_bits for read-modify-write register access instead of
open-coding it using snd_soc_read and snd_soc_write

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ad193x.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index 39056ce..1dc8404 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -106,8 +106,10 @@ static int ad193x_mute(struct snd_soc_dai *dai, int mute)
 	int reg;
 
 	reg = snd_soc_read(codec, AD193X_DAC_CTRL2);
-	reg = (mute > 0) ? reg | AD193X_DAC_MASTER_MUTE : reg &
-		(~AD193X_DAC_MASTER_MUTE);
+	if (mute)
+		reg |= AD193X_DAC_MASTER_MUTE;
+	else
+		reg &= ~AD193X_DAC_MASTER_MUTE;
 	snd_soc_write(codec, AD193X_DAC_CTRL2, reg);
 
 	return 0;
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
1.7.4.1



