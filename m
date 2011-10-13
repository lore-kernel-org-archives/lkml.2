Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1JMX34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:29:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62513 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab1JMX3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:29:54 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111013225237.GA2952@opensource.wolfsonmicro.com>
References: <1318490575.2857.8.camel@phoenix> <20111013165129.GO5193@opensource.wolfsonmicro.com>
 <CAF+7xWkVLNgToGiEn+xqgnii7QozNu0QAf2U-kXRNRtVK0dkqA@mail.gmail.com> <20111013225237.GA2952@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 14 Oct 2011 07:29:33 +0800
Message-ID: <CAF+7xWm-X6ydYVp5j+HzMZaFkja+2cEMC2BnXRBoNJTqj=x7OA@mail.gmail.com>
Subject: Re: [PATCH 1/3] ASoC: alc5623: Convert codec->hw_read to regmap_read
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Oct 14, 2011 at 06:39:43AM +0800, Axel Lin wrote:
>> 2011/10/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>
>> > Probably the best thing here is to convert all these drivers to use
>> > cache_bypass to read directly through the cache - the same thing will
>> > then work with direct regmap usage.
>
>> I don't complete understand "use cache_bypass to read directly through
>> the cache".
>
> Set the cache_bypass flag in the device struct.
>
Sorry. I still don't get it.

I check the regmap code, it seems cache_bypsss is only set
if map->cache_type == REGCACHE_NONE or by regcache_cache_bypass().

I'm wondering if we can fix it this way:

diff --git a/sound/soc/codecs/alc5623.c b/sound/soc/codecs/alc5623.c
index 557b3af..9e43bb9 100644
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
+       regcache_cache_bypass(codec->control_data, true);
+       for (i = 0 ; i < codec->driver->reg_cache_size ; i += step) {
+               regmap_read(codec->control_data, i, &val);
+               cache[i] = val;
+       }
+       regcache_cache_bypass(codec->control_data, false);
 }

 static inline int alc5623_reset(struct snd_soc_codec *codec)
