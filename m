Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1HRHbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:31:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57492 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab1HRHbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:31:13 -0400
Subject: [PATCH] ASoC: sta32x: Move resource allocation and release to the
 corresponding callback functions
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Johannes Stezenbach <js@sig21.net>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 15:31:04 +0800
Message-ID: <1313652664.2917.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below small fixes:

1. Move sta32x_set_bias_level() from sta32x_i2c_remove() to sta32x_remove().
2. Remove a redundant regulator_bulk_free() call in sta32x_i2c_remove(),
   as we will call regulator_bulk_free() in sta32x_remove().
3. Remove unneeded snd_soc_codec_set_drvdata(codec, NULL) in sta32x_i2c_remove.
   The i2c core will set the clientdata to NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
hi,
I don't have this hardware handy. I appreciate if someone can test this patch.

Axel
 sound/soc/codecs/sta32x.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 3d155f5..5c7def3 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -812,6 +812,7 @@ static int sta32x_remove(struct snd_soc_codec *codec)
 {
 	struct sta32x_priv *sta32x = snd_soc_codec_get_drvdata(codec);
 
+	sta32x_set_bias_level(codec, SND_SOC_BIAS_OFF);
 	regulator_bulk_disable(ARRAY_SIZE(sta32x->supplies), sta32x->supplies);
 	regulator_bulk_free(ARRAY_SIZE(sta32x->supplies), sta32x->supplies);
 
@@ -871,18 +872,8 @@ static __devinit int sta32x_i2c_probe(struct i2c_client *i2c,
 static __devexit int sta32x_i2c_remove(struct i2c_client *client)
 {
 	struct sta32x_priv *sta32x = i2c_get_clientdata(client);
-	struct snd_soc_codec *codec = sta32x->codec;
-
-	if (codec)
-		sta32x_set_bias_level(codec, SND_SOC_BIAS_OFF);
-
-	regulator_bulk_free(ARRAY_SIZE(sta32x->supplies), sta32x->supplies);
-
-	if (codec) {
-		snd_soc_unregister_codec(&client->dev);
-		snd_soc_codec_set_drvdata(codec, NULL);
-	}
 
+	snd_soc_unregister_codec(&client->dev);
 	kfree(sta32x);
 	return 0;
 }
-- 
1.7.4.1



