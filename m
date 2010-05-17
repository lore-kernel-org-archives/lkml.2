Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0EQJwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:52:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54588 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0EQJwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:52:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=ipWUcMehh+9TWLrWpmtYsSWBqBG3N6MMpdaAeVP6UQzniGxIEJdRmIDQmONAIsgnHi
         puoBXu5y+sKNyPjY0mZ5hki82lr7rDkLdB8P2x+7oPZI+pfPdIKS+oWOV+IcXJdevn5v
         c1b/w7pJTl/k3bQ4WQBSORLPt9NbQHW2wBpSg=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20100517111513.f76c0bb9.ospite@studenti.unina.it>
References: <1274060042.17226.2.camel@mola> <20100517111513.f76c0bb9.ospite@studenti.unina.it>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 17 May 2010 17:52:21 +0800
Message-ID: <AANLkTim-OD1bI0GQrZrPym0D3fWVwDRC7dEISNFFg808@mail.gmail.com>
Subject: Re: [PATCH] leds-lp3944: properly handle lp3944_configure fail in 
	lp3944_probe
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Richard Purdie <rpurdie@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/17 Antonio Ospite <ospite@studenti.unina.it>:
> On Mon, 17 May 2010 09:34:02 +0800
> Axel Lin <axel.lin@gmail.com> wrote:
>
>> In current implementation, lp3944_probe return 0 even if lp3944_configure fail.
>> Therefore, led_classdev_unregister will be executed twice ( in error handling of lp3944_configure and lp3944_remove ).
>> This patch properly handles lp3944_configure fail in lp3944_probe.
>>
>
> Hi Axel, thanks for the fix, I agree it's needed.
> There are some minor comments inlined below.
>
> Plus, when possible, I prefer commit messages to be wrapped to 72/80
> characters per line. Please, consider this if you are sending a v2.
ok. done in v2.

>
> Ah, may I ask where you are using this driver? Just curious.
>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>>  drivers/leds/leds-lp3944.c |   10 +++++++++-
>>  1 files changed, 9 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
>> index 8d5ecce..03a24d0 100644
>> --- a/drivers/leds/leds-lp3944.c
>> +++ b/drivers/leds/leds-lp3944.c
>> @@ -379,6 +379,7 @@ static int __devinit lp3944_probe(struct i2c_client *client,
>>  {
>>       struct lp3944_platform_data *lp3944_pdata = client->dev.platform_data;
>>       struct lp3944_data *data;
>> +     int err;
>>
>>       if (lp3944_pdata == NULL) {
>>               dev_err(&client->dev, "no platform data\n");
>> @@ -403,8 +404,15 @@ static int __devinit lp3944_probe(struct i2c_client *client,
>>
>>       dev_info(&client->dev, "lp3944 enabled\n");
>>
>> -     lp3944_configure(client, data, lp3944_pdata);
>> +     err = lp3944_configure(client, data, lp3944_pdata);
>> +     if (err < 0)
>> +             goto err_configure;
>> +
>
> The dev_info(&client->dev, "lp3944 enabled\n"); could now go right
> here, before the return 0, so we don't report the driver as enabled
> even in the case its probe fails.
done in v2.
>
>>       return 0;
>> +
>> +err_configure:
>> +     kfree(data);
>
> add i2c_set_clientdata(client, NULL) here just like in lp3944_remove()

per Wolfram Sang's comment, I skip this part in v2.

>
>> +     return err;
>>  }
>>
>>  static int __devexit lp3944_remove(struct i2c_client *client)
>> --
>> 1.5.4.3
>>
>
> Regards,
>   Antonio
>
> --
> Antonio Ospite
> http://ao2.it
>
> PGP public key ID: 0x4553B001
>
> A: Because it messes up the order in which people normally read text.
>   See http://en.wikipedia.org/wiki/Posting_style
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
