Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab0GOGTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 02:19:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41384 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0GOGTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 02:19:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=TNOhEbiby5PHowYsfM19DsWSyfwcv234LXB1Yhjutfb5cmj2P5SL4CGZT/cI0D56+e
         P74UYf28KBjxcvZ3SMOD9ISKVHubcbUuPviXfcPgaeooempU232eBo9rqHngh5A9m0hQ
         m6qAQ4veK0y0K4iAzcV3pYeZoUIfgW7EnL2Ww=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <w3p4og1mgt3.wl%kuninori.morimoto.gx@renesas.com>
References: <1279162147.29294.2.camel@mola> <1279162329.29294.6.camel@mola> 
	<w3p4og1mgt3.wl%kuninori.morimoto.gx@renesas.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 15 Jul 2010 14:19:02 +0800
Message-ID: <AANLkTilmp28xbK1Kja6YiA7DwlMpIBAyeOjTq2L1mR6o@mail.gmail.com>
Subject: Re: [PATCH 2/12] ak4642: fix a memory leak if failed to initialise 
	AK4642
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kuninori,

2010/7/15 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>:
>
> Dear Axel
>
> Thanks about this patch
>
>> --- a/sound/soc/codecs/ak4642.c
>> +++ b/sound/soc/codecs/ak4642.c
>> @@ -491,8 +491,10 @@ static int ak4642_i2c_probe(struct i2c_client *i2c,
>>       codec->control_data = i2c;
>>
>>       ret = ak4642_init(ak4642);
>> -     if (ret < 0)
>> +     if (ret < 0) {
>>               printk(KERN_ERR "failed to initialise AK4642\n");
>> +             kfree(ak4642);
>> +     }
>>
>>       return ret;
>>  }
>
> Indeed. this operation is needed when error case.
>
> I think
> i2c_set_clientdata(i2c, NULL); is needed here too.
> (da7210 also)

I think the i2c core will take care of it now.
see below commit log:
commit e4a7b9b04de15f6b63da5ccdd373ffa3057a3681
Author: Wolfram Sang <w.sang@pengutronix.de>
Date:   Tue May 4 11:09:27 2010 +0200

    i2c-core: Erase pointer to clientdata on removal

    After discovering that a lot of i2c-drivers leave the pointer to their
    clientdata dangling, it was decided to let the core handle this issue.
    It is assumed that the core may access the private data after remove()
    as there are no guarantees for the lifetime of such pointers anyhow (see
    thread starting at http://lkml.org/lkml/2010/3/21/68)

    Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
    Signed-off-by: Jean Delvare <khali@linux-fr.org>


>
> And why ak4642's patch doesn't have
> snd_soc_unregister_codec fix like da7210 ?
> I think ak4642 have same issue

In ak4642_init, current implementation will call
snd_soc_unregister_codec(codec);  before goto reg_cache_err;
Therefore, it should be no problem.

Or do you mean just using goto style cleanup instead of mixed
in-line and goto style cleanup?
I can fix it if you like this change.


Regards,
Axel

>
> Best regards
> --
> Kuninori Morimoto
>
>
