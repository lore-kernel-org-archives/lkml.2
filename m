Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1I2CGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 22:06:02 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:33929 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab1I2CGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 22:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <4E83D162.2010004@gmail.com>
References: <1317218471.8008.3.camel@phoenix>
	<1317218530.8008.4.camel@phoenix>
	<4E83AB6A.1090203@gmail.com>
	<CABqxG0dainno-pZiqjMLzTYkWs-bsnt95acfsDMWqSnjTU4mHQ@mail.gmail.com>
	<4E83CF74.1040701@gmail.com>
	<CABqxG0eWVMTBAF=Tq_a0USEXFeVYGpR7kRGRTCpUrrfP+0AGmw@mail.gmail.com>
	<4E83D162.2010004@gmail.com>
Date: Thu, 29 Sep 2011 10:06:00 +0800
Message-ID: <CABqxG0f3xo52nrQM9AxWVEaOrNN+aGo1Piygdj+vZ_-uazGZpA@mail.gmail.com>
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

On Thu, Sep 29, 2011 at 10:01 AM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 29/09/11 11:59, Dave Young wrote:
>
>> On Thu, Sep 29, 2011 at 9:52 AM, Ryan Mallon <rmallon@gmail.com> wrote:
>>> On 29/09/11 11:35, Dave Young wrote:
>>>
>>>> On Thu, Sep 29, 2011 at 7:19 AM, Ryan Mallon <rmallon@gmail.com> wrote:
>>>>> On 29/09/11 00:02, Axel Lin wrote:
>>>>>> The callers use the return value of max98095_get_bq_channel as array index to
>>>>>> access max98095->dai[] array.
>>>>>> Add BUG() assertion for out of bound access of max98095->dai[] array.
>>>>>
>>>>> Same here, fix the problem in the callers.
>>>>>
>>>>> ----
>>>>> Check the return value of max98095_get_bq_channel in the callers and
>>>>> propagate any errors up. Remove the BUG_ON(channel > 1) since
>>>>> max98095_get_bq_channel never returns a value larger than 1.
>>>>>
>>>>> Signed-off-by: Ryan Mallon <rmallon@gmail.com>
>>>>> ---
>>>>>
>>>>> diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
>>>>> index 668434d..55eccea 100644
>>>>> --- a/sound/soc/codecs/max98095.c
>>>>> +++ b/sound/soc/codecs/max98095.c
>>>>> @@ -2014,7 +2014,8 @@ static int max98095_put_bq_enum(struct snd_kcontrol *kcontrol,
>>>>>        int fs, best, best_val, i;
>>>>>        int regmask, regsave;
>>>>>
>>>>> -       BUG_ON(channel > 1);
>>>>> +       if (channel < 0)
>>>>> +               return channel;
>>>>
>>>> If use BUG() happens in  max98095_get_bq_channel, it will not return here?
>>>
>>>
>>> Not quite sure what you mean?
>>
>> I means if Axel Lin's patch applied, and CONFIG_BUG is on, it will
>> panic firstly the if condition will be never entered.
>
> My patch is a replacement for Axel's patch, not on top of it. For Axel's
> patch it would panic if channel was less than zero if CONFIG_BUG was
> enabled, but would still have undefined behaviour if CONFIG_BUG was not
> enabled.

So that's good, thanks

>
> ~Ryan
>
>>>
>>> If CONFIG_BUG was not enabled for the original version, then it would
>>> not return at the BUG_ON and would either crash or cause odd behaviour
>>> if it tried to index channel as -1.
>>>
>>> My patch is removing the BUG_ON and replacing it with a proper check and
>>> return. It doesn't need to check > 1 since max98095_get_bq_channel never
>>> returns that.
>>>
>>> My understanding is that device drivers, in general, should not call
>>> BUG. BUG is for unrecoverable errors which leave the kernel in some
>>> unstable state. Here we can just return an error code.
>>
>> Agree
>>
>>>
>>> ~Ryan
>>>
>>>>
>>>>>
>>>>>        if (!pdata || !max98095->bq_textcnt)
>>>>>                return 0;
>>>>> @@ -2069,6 +2070,9 @@ static int max98095_get_bq_enum(struct snd_kcontrol *kcontrol,
>>>>>        int channel = max98095_get_bq_channel(kcontrol->id.name);
>>>>>        struct max98095_cdata *cdata;
>>>>>
>>>>> +       if (channel < 0)
>>>>> +               return channel;
>>>>> +
>>>>>        cdata = &max98095->dai[channel];
>>>>>        ucontrol->value.enumerated.item[0] = cdata->bq_sel;
>>>>>
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>>
>>>>
>>>>
>>>>
>>>
>>>
>>>
>>
>>
>>
>
>
>



-- 
Regards
Dave
