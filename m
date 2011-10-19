Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1JSGHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 02:07:43 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50428 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1JSGHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 02:07:42 -0400
Message-ID: <1319004451.16275.1.camel@phoenix>
Subject: [PATCH] ASoC: ssm2602: Use snd_soc_update_bits for read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Date: Wed, 19 Oct 2011 14:07:31 +0800
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
 sound/soc/codecs/ssm2602.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/sound/soc/codecs/ssm2602.c b/sound/soc/codecs/ssm2602.c
index e149ec6..3cb3271 100644
--- a/sound/soc/codecs/ssm2602.c
+++ b/sound/soc/codecs/ssm2602.c
@@ -343,12 +343,14 @@ static void ssm2602_shutdown(struct snd_pcm_substream *substream,
 static int ssm2602_mute(struct snd_soc_dai *dai, int mute)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	u16 mute_reg = snd_soc_read(codec, SSM2602_APDIGI) & ~APDIGI_ENABLE_DAC_MUTE;
+
 	if (mute)
-		snd_soc_write(codec, SSM2602_APDIGI,
-				mute_reg | APDIGI_ENABLE_DAC_MUTE);
+		snd_soc_update_bits(codec, SSM2602_APDIGI,
+				    APDIGI_ENABLE_DAC_MUTE,
+				    APDIGI_ENABLE_DAC_MUTE);
 	else
-		snd_soc_write(codec, SSM2602_APDIGI, mute_reg);
+		snd_soc_update_bits(codec, SSM2602_APDIGI,
+				    APDIGI_ENABLE_DAC_MUTE, 0);
 	return 0;
 }
 
@@ -540,12 +542,12 @@ static int ssm2602_resume(struct snd_soc_codec *codec)
 static int ssm2602_probe(struct snd_soc_codec *codec)
 {
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
-	int ret, reg;
+	int ret;
 
-	reg = snd_soc_read(codec, SSM2602_LOUT1V);
-	snd_soc_write(codec, SSM2602_LOUT1V, reg | LOUT1V_LRHP_BOTH);
-	reg = snd_soc_read(codec, SSM2602_ROUT1V);
-	snd_soc_write(codec, SSM2602_ROUT1V, reg | ROUT1V_RLHP_BOTH);
+	snd_soc_update_bits(codec, SSM2602_LOUT1V,
+			    LOUT1V_LRHP_BOTH, LOUT1V_LRHP_BOTH);
+	snd_soc_update_bits(codec, SSM2602_ROUT1V,
+			    ROUT1V_RLHP_BOTH, ROUT1V_RLHP_BOTH);
 
 	ret = snd_soc_add_controls(codec, ssm2602_snd_controls,
 			ARRAY_SIZE(ssm2602_snd_controls));
@@ -578,7 +580,7 @@ static int ssm2604_probe(struct snd_soc_codec *codec)
 static int ssm260x_probe(struct snd_soc_codec *codec)
 {
 	struct ssm2602_priv *ssm2602 = snd_soc_codec_get_drvdata(codec);
-	int ret, reg;
+	int ret;
 
 	pr_info("ssm2602 Audio Codec %s", SSM2602_VERSION);
 
@@ -595,10 +597,10 @@ static int ssm260x_probe(struct snd_soc_codec *codec)
 	}
 
 	/* set the update bits */
-	reg = snd_soc_read(codec, SSM2602_LINVOL);
-	snd_soc_write(codec, SSM2602_LINVOL, reg | LINVOL_LRIN_BOTH);
-	reg = snd_soc_read(codec, SSM2602_RINVOL);
-	snd_soc_write(codec, SSM2602_RINVOL, reg | RINVOL_RLIN_BOTH);
+	snd_soc_update_bits(codec, SSM2602_LINVOL,
+			    LINVOL_LRIN_BOTH, LINVOL_LRIN_BOTH);
+	snd_soc_update_bits(codec, SSM2602_RINVOL,
+			    RINVOL_RLIN_BOTH, RINVOL_RLIN_BOTH);
 	/*select Line in as default input*/
 	snd_soc_write(codec, SSM2602_APANA, APANA_SELECT_DAC |
 			APANA_ENABLE_MIC_BOOST);
-- 
1.7.5.4



