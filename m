Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1IWFXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 01:23:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41858 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1IWFXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 01:23:17 -0400
Subject: [PATCH] ASoC: Add missed free_irq in wm5100_remove and
 wm5100_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 13:23:10 +0800
Message-ID: <1316755390.3012.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm5100.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 576081a..58f043c 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -2418,6 +2418,8 @@ static int wm5100_probe(struct snd_soc_codec *codec)
 	return 0;
 
 err_gpio:
+	if (i2c->irq)
+		free_irq(i2c->irq, codec);
 	wm5100_free_gpio(codec);
 err_reset:
 	if (wm5100->pdata.reset) {
@@ -2444,11 +2446,14 @@ err_core:
 static int wm5100_remove(struct snd_soc_codec *codec)
 {
 	struct wm5100_priv *wm5100 = snd_soc_codec_get_drvdata(codec);
+	struct i2c_client *i2c = to_i2c_client(codec->dev);
 
 	wm5100_set_bias_level(codec, SND_SOC_BIAS_OFF);
 	if (wm5100->pdata.hp_pol) {
 		gpio_free(wm5100->pdata.hp_pol);
 	}
+	if (i2c->irq)
+		free_irq(i2c->irq, codec);
 	wm5100_free_gpio(codec);
 	if (wm5100->pdata.reset) {
 		gpio_set_value_cansleep(wm5100->pdata.reset, 1);
-- 
1.7.4.1



