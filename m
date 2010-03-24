Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0CXMBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:01:19 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38899 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab0CXMBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:01:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=WBrRo8KWAl+K+9WyHWGksdBrPf5TkwXE0Qs8d4QtJHqXZpmQt7rOPk17jfaPNnke1n
         XC6/5Pa2ne4aTc+ZHQ2Dty/JFb/FMqjQmpzanZk/j2ckr9AB2eaDODy6dHG9eHCy0U1E
         8KvudreIuyxEf7AFF0tdEd9BTf+Rny+1Bvs/Y=
Date: Wed, 24 Mar 2010 15:01:07 +0300
From: Dan Carpenter <error27@gmail.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Joonyoung Shim <jy0922.shim@samsung.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [rfc patch] wm8994: range checking issue
Message-ID: <20100324120107.GH21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complained about BUG_ON(reg > WM8994_MAX_REGISTER) because the
actual number of elements in the array was WM8994_REG_CACHE_SIZE + 1.

I changed the BUG_ON() to return -EINVAL.

I was confused why WM8994_REG_CACHE_SIZE was different from the actual
size of ->reg_cache and I was concerned because some places used 
ARRAY_SIZE() to find the end of the array and other places used 
WM8994_REG_CACHE_SIZE.  In my patch, I made them the same.

I don't have the hardware to test this and some of this patch is just 
guess work.

For example, I left it in, but why is there a -1 here?
  3711          /* Fill the cache with physical values we inherited; don't reset */
  3712          ret = wm8994_bulk_read(codec->control_data, 0,
  3713                                 ARRAY_SIZE(wm8994->reg_cache) - 1,
  3714                                 codec->reg_cache);

I didn't sign this off because I figured I'd probably need to send a
second version after I hear the feed back.

regards,
dan carpenter

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 29f3771..d9c179a 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -59,13 +59,13 @@ static int wm8994_retune_mobile_base[] = {
 	WM8994_AIF2_EQ_GAINS_1,
 };
 
-#define WM8994_REG_CACHE_SIZE  0x621
+#define WM8994_REG_CACHE_SIZE  0x622
 
 /* codec private data */
 struct wm8994_priv {
 	struct wm_hubs_data hubs;
 	struct snd_soc_codec codec;
-	u16 reg_cache[WM8994_REG_CACHE_SIZE + 1];
+	u16 reg_cache[WM8994_REG_CACHE_SIZE];
 	int sysclk[2];
 	int sysclk_rate[2];
 	int mclk[2];
@@ -1697,7 +1697,8 @@ static int wm8994_write(struct snd_soc_codec *codec, unsigned int reg,
 {
 	struct wm8994_priv *wm8994 = codec->private_data;
 
-	BUG_ON(reg > WM8994_MAX_REGISTER);
+	if (reg >= WM8994_REG_CACHE_SIZE)
+		return -EINVAL;
 
 	if (!wm8994_volatile(reg))
 		wm8994->reg_cache[reg] = value;
@@ -1710,7 +1711,8 @@ static unsigned int wm8994_read(struct snd_soc_codec *codec,
 {
 	u16 *reg_cache = codec->reg_cache;
 
-	BUG_ON(reg > WM8994_MAX_REGISTER);
+	if (reg >= WM8994_REG_CACHE_SIZE)
+		return -EINVAL;
 
 	if (wm8994_volatile(reg))
 		return wm8994_reg_read(codec->control_data, reg);
@@ -3700,7 +3702,7 @@ static int wm8994_codec_probe(struct platform_device *pdev)
 	codec->set_bias_level = wm8994_set_bias_level;
 	codec->dai = &wm8994_dai[0];
 	codec->num_dai = 3;
-	codec->reg_cache_size = WM8994_MAX_REGISTER;
+	codec->reg_cache_size = WM8994_REG_CACHE_SIZE;
 	codec->reg_cache = &wm8994->reg_cache;
 	codec->dev = &pdev->dev;
 
