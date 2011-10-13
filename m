Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1JMWkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 18:40:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65181 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab1JMWkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 18:40:04 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111013165129.GO5193@opensource.wolfsonmicro.com>
References: <1318490575.2857.8.camel@phoenix> <20111013165129.GO5193@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 14 Oct 2011 06:39:43 +0800
Message-ID: <CAF+7xWkVLNgToGiEn+xqgnii7QozNu0QAf2U-kXRNRtVK0dkqA@mail.gmail.com>
Subject: Re: [PATCH 1/3] ASoC: alc5623: Convert codec->hw_read to regmap_read
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Thu, Oct 13, 2011 at 03:22:55PM +0800, Axel Lin wrote:
>> codec->hw_read is broken now, let's covert to regmap_read.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> I'd rather not fix these like this because when we convert these drivers
> to use regmap directly it won't be quite so obvious what's going on and
> we'll easily introduce bugs where we start using the cached values from
> a regmap level cache.
>
> Probably the best thing here is to convert all these drivers to use
> cache_bypass to read directly through the cache - the same thing will
> then work with direct regmap usage.
>
I don't complete understand "use cache_bypass to read directly through
the cache".
Can you illustrate it?
The purpose of original implementation is to read h/w then fill the cache.
The cache is zeroed before we call alc5623_fill_cache().

Or do you mean changes like below instead of calling regmap_read directly?

diff --git a/sound/soc/codecs/alc5623.c b/sound/soc/codecs/alc5623.c
index 557b3af..43006b3 100644
--- a/sound/soc/codecs/alc5623.c
+++ b/sound/soc/codecs/alc5623.c
@@ -51,10 +51,15 @@ static void alc5623_fill_cache(struct snd_soc_codec *codec)
 {
        int i, step = codec->driver->reg_cache_step;
        u16 *cache = codec->reg_cache;
+       unsigned int val;

        /* not really efficient ... */
-       for (i = 0 ; i < codec->driver->reg_cache_size ; i += step)
-               cache[i] = codec->hw_read(codec, i);
+       codec->cache_bypass = 1;
+       for (i = 0 ; i < codec->driver->reg_cache_size ; i += step) {
+               snd_soc_read(codec, i);
+               cache[i] = val;
+       }
+       codec->cache_bypass = 0;
 }

 static inline int alc5623_reset(struct snd_soc_codec *codec)

Thanks,
Axel
