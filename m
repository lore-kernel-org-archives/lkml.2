Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1I2BfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 21:35:07 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57672 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab1I2BfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 21:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <4E83AB6A.1090203@gmail.com>
References: <1317218471.8008.3.camel@phoenix>
	<1317218530.8008.4.camel@phoenix>
	<4E83AB6A.1090203@gmail.com>
Date: Thu, 29 Sep 2011 09:35:04 +0800
Message-ID: <CABqxG0dainno-pZiqjMLzTYkWs-bsnt95acfsDMWqSnjTU4mHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: Add BUG() assertion if max98095_get_bq_channel
 returns -EINVAL
From: Dave Young <hidave.darkstar@gmail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Peter Hsiang <peter.hsiang@maxim-ic.com>,
        Jesse Marroquin <jesse.marroquin@maxim-ic.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 7:19 AM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 29/09/11 00:02, Axel Lin wrote:
>> The callers use the return value of max98095_get_bq_channel as array index to
>> access max98095->dai[] array.
>> Add BUG() assertion for out of bound access of max98095->dai[] array.
>
> Same here, fix the problem in the callers.
>
> ----
> Check the return value of max98095_get_bq_channel in the callers and
> propagate any errors up. Remove the BUG_ON(channel > 1) since
> max98095_get_bq_channel never returns a value larger than 1.
>
> Signed-off-by: Ryan Mallon <rmallon@gmail.com>
> ---
>
> diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
> index 668434d..55eccea 100644
> --- a/sound/soc/codecs/max98095.c
> +++ b/sound/soc/codecs/max98095.c
> @@ -2014,7 +2014,8 @@ static int max98095_put_bq_enum(struct snd_kcontrol *kcontrol,
>        int fs, best, best_val, i;
>        int regmask, regsave;
>
> -       BUG_ON(channel > 1);
> +       if (channel < 0)
> +               return channel;

If use BUG() happens in  max98095_get_bq_channel, it will not return here?

>
>        if (!pdata || !max98095->bq_textcnt)
>                return 0;
> @@ -2069,6 +2070,9 @@ static int max98095_get_bq_enum(struct snd_kcontrol *kcontrol,
>        int channel = max98095_get_bq_channel(kcontrol->id.name);
>        struct max98095_cdata *cdata;
>
> +       if (channel < 0)
> +               return channel;
> +
>        cdata = &max98095->dai[channel];
>        ucontrol->value.enumerated.item[0] = cdata->bq_sel;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
Dave
