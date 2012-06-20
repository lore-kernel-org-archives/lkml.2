Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2FTSXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:23:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab2FTSXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:23:43 -0400
Message-Id: <20120620173024.960946765@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:31:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 47/61] ASoC: wm8904: Fix GPIO and MICBIAS initialisation for regmap conversion
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 433897f7408b556f7dfbb98c94deea02e634d2a7 upstream.

We no longer have a flat ASoC cache so can't peer directly into the array
any more but should instead use the register I/O functions to update the
cache.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8904.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -2084,7 +2084,6 @@ static int wm8904_probe(struct snd_soc_c
 {
 	struct wm8904_priv *wm8904 = snd_soc_codec_get_drvdata(codec);
 	struct wm8904_pdata *pdata = wm8904->pdata;
-	u16 *reg_cache = codec->reg_cache;
 	int ret, i;
 
 	codec->cache_sync = 1;
@@ -2180,14 +2179,18 @@ static int wm8904_probe(struct snd_soc_c
 			if (!pdata->gpio_cfg[i])
 				continue;
 
-			reg_cache[WM8904_GPIO_CONTROL_1 + i]
-				= pdata->gpio_cfg[i] & 0xffff;
+			regmap_update_bits(wm8904->regmap,
+					   WM8904_GPIO_CONTROL_1 + i,
+					   0xffff,
+					   pdata->gpio_cfg[i]);
 		}
 
 		/* Zero is the default value for these anyway */
 		for (i = 0; i < WM8904_MIC_REGS; i++)
-			reg_cache[WM8904_MIC_BIAS_CONTROL_0 + i]
-				= pdata->mic_cfg[i];
+			regmap_update_bits(wm8904->regmap,
+					   WM8904_MIC_BIAS_CONTROL_0 + i,
+					   0xffff,
+					   pdata->mic_cfg[i]);
 	}
 
 	/* Set Class W by default - this will be managed by the Class


