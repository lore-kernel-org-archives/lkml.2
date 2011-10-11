Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1JKMVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 08:21:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57562 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab1JKMVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 08:21:07 -0400
Subject: [PATCH] ASoC: ak4642: convert to soc-cache
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 20:20:53 +0800
Message-ID: <1318335653.3573.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Kuninori,
This patch converts ak4642 to use soc-cache APIs.
I don't have this hardware, I'd appreciate if you can test this patch.

Thanks,
Axel

 sound/soc/codecs/ak4642.c |   82 ++++++--------------------------------------
 1 files changed, 12 insertions(+), 70 deletions(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 68fc16c..80a9fe8 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -157,7 +157,6 @@ static const struct snd_kcontrol_new ak4642_snd_controls[] = {
 struct ak4642_priv {
 	unsigned int sysclk;
 	enum snd_soc_control_type control_type;
-	void *control_data;
 };
 
 /*
@@ -176,64 +175,6 @@ static const u16 ak4642_reg[AK4642_CACHEREGNUM] = {
 	0x0000,
 };
 
-/*
- * read ak4642 register cache
- */
-static inline unsigned int ak4642_read_reg_cache(struct snd_soc_codec *codec,
-	unsigned int reg)
-{
-	u16 *cache = codec->reg_cache;
-	if (reg >= AK4642_CACHEREGNUM)
-		return -1;
-	return cache[reg];
-}
-
-/*
- * write ak4642 register cache
- */
-static inline void ak4642_write_reg_cache(struct snd_soc_codec *codec,
-	u16 reg, unsigned int value)
-{
-	u16 *cache = codec->reg_cache;
-	if (reg >= AK4642_CACHEREGNUM)
-		return;
-
-	cache[reg] = value;
-}
-
-/*
- * write to the AK4642 register space
- */
-static int ak4642_write(struct snd_soc_codec *codec, unsigned int reg,
-	unsigned int value)
-{
-	u8 data[2];
-
-	/* data is
-	 *   D15..D8 AK4642 register offset
-	 *   D7...D0 register data
-	 */
-	data[0] = reg & 0xff;
-	data[1] = value & 0xff;
-
-	if (codec->hw_write(codec->control_data, data, 2) == 2) {
-		ak4642_write_reg_cache(codec, reg, value);
-		return 0;
-	} else
-		return -EIO;
-}
-
-static int ak4642_sync(struct snd_soc_codec *codec)
-{
-	u16 *cache = codec->reg_cache;
-	int i, r = 0;
-
-	for (i = 0; i < AK4642_CACHEREGNUM; i++)
-		r |= ak4642_write(codec, i, cache[i]);
-
-	return r;
-};
-
 static int ak4642_dai_startup(struct snd_pcm_substream *substream,
 			      struct snd_soc_dai *dai)
 {
@@ -253,8 +194,8 @@ static int ak4642_dai_startup(struct snd_pcm_substream *substream,
 		 */
 		snd_soc_update_bits(codec, MD_CTL4, DACH, DACH);
 		snd_soc_update_bits(codec, MD_CTL3, BST1, BST1);
-		ak4642_write(codec, L_IVC, 0x91); /* volume */
-		ak4642_write(codec, R_IVC, 0x91); /* volume */
+		snd_soc_write(codec, L_IVC, 0x91); /* volume */
+		snd_soc_write(codec, R_IVC, 0x91); /* volume */
 		snd_soc_update_bits(codec, PW_MGMT1, PMVCM | PMMIN | PMDAC,
 						     PMVCM | PMMIN | PMDAC);
 		snd_soc_update_bits(codec, PW_MGMT2, PMHP_MASK,	PMHP);
@@ -273,9 +214,9 @@ static int ak4642_dai_startup(struct snd_pcm_substream *substream,
 		 * This operation came from example code of
 		 * "ASAHI KASEI AK4642" (japanese) manual p94.
 		 */
-		ak4642_write(codec, SG_SL1, PMMP | MGAIN0);
-		ak4642_write(codec, TIMER, ZTM(0x3) | WTM(0x3));
-		ak4642_write(codec, ALC_CTL1, ALC | LMTH0);
+		snd_soc_write(codec, SG_SL1, PMMP | MGAIN0);
+		snd_soc_write(codec, TIMER, ZTM(0x3) | WTM(0x3));
+		snd_soc_write(codec, ALC_CTL1, ALC | LMTH0);
 		snd_soc_update_bits(codec, PW_MGMT1, PMVCM | PMADL,
 						     PMVCM | PMADL);
 		snd_soc_update_bits(codec, PW_MGMT3, PMADR, PMADR);
@@ -463,7 +404,7 @@ static struct snd_soc_dai_driver ak4642_dai = {
 
 static int ak4642_resume(struct snd_soc_codec *codec)
 {
-	ak4642_sync(codec);
+	snd_soc_cache_sync(codec);
 	return 0;
 }
 
@@ -471,11 +412,15 @@ static int ak4642_resume(struct snd_soc_codec *codec)
 static int ak4642_probe(struct snd_soc_codec *codec)
 {
 	struct ak4642_priv *ak4642 = snd_soc_codec_get_drvdata(codec);
+	int ret;
 
 	dev_info(codec->dev, "AK4642 Audio Codec %s", AK4642_VERSION);
 
-	codec->hw_write		= (hw_write_t)i2c_master_send;
-	codec->control_data	= ak4642->control_data;
+	ret = snd_soc_codec_set_cache_io(codec, 8, 8, ak4642->control_type);
+	if (ret < 0) {
+		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
+		return ret;
+	}
 
 	snd_soc_add_controls(codec, ak4642_snd_controls,
 			     ARRAY_SIZE(ak4642_snd_controls));
@@ -486,8 +431,6 @@ static int ak4642_probe(struct snd_soc_codec *codec)
 static struct snd_soc_codec_driver soc_codec_dev_ak4642 = {
 	.probe			= ak4642_probe,
 	.resume			= ak4642_resume,
-	.read			= ak4642_read_reg_cache,
-	.write			= ak4642_write,
 	.reg_cache_size		= ARRAY_SIZE(ak4642_reg),
 	.reg_word_size		= sizeof(u8),
 	.reg_cache_default	= ak4642_reg,
@@ -505,7 +448,6 @@ static __devinit int ak4642_i2c_probe(struct i2c_client *i2c,
 		return -ENOMEM;
 
 	i2c_set_clientdata(i2c, ak4642);
-	ak4642->control_data = i2c;
 	ak4642->control_type = SND_SOC_I2C;
 
 	ret =  snd_soc_register_codec(&i2c->dev,
-- 
1.7.4.1



