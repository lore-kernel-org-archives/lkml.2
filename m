Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0F0Giq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 02:38:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40604 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab0F0Gio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 02:38:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vDaaUj1Mvfp9dOY1HYYvy53gSBn+idXELu3jw5FMvzBQ7R5JT7Zn1sDgldhvgnVS7l
         V3/At3/EvUALjTsG4XY/PQyhDvw0BOIBKq6r+FY5h+1ZDJoidRDwFKQkwquj9XI+LMeE
         cQAMl4v4+a85nyrzlMsjjBDF5DTbE0FPe9ZQA=
MIME-Version: 1.0
In-Reply-To: <352874.17151.qm@web180303.mail.gq1.yahoo.com>
References: <1276778870-1065-1-git-send-email-dbaryshkov@gmail.com>
	<352874.17151.qm@web180303.mail.gq1.yahoo.com>
Date: Sun, 27 Jun 2010 10:38:41 +0400
Message-ID: <AANLkTilGXSg4b2a_-4eSOFwzGrZxU4oAdXS8Wc2CdTZO@mail.gmail.com>
Subject: Re: [PATCH] pcf857x: support working w/o platform data
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
       Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 6/25/10, David Brownell <david-b@pacbell.net> wrote:
>
> --- On Thu, 6/17/10, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:
>
>> Provide sane defaults for pcf857x, so
>> the driver can be used w/o
>> providing platform data (and thus can be simply bound via OF tree).
>
>
> Maybe we can get an ack from some OF folk
> who are using it in that way?

Please see arch/powerpc/boot//dts/mpc8349emitx.dts (the platform I'm using it).

>> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> ---
>>  drivers/gpio/pcf857x.c |    9 ++++-----
>>  1 files changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/gpio/pcf857x.c
>> b/drivers/gpio/pcf857x.c
>> index 29f19ce..879b473 100644
>> --- a/drivers/gpio/pcf857x.c
>> +++ b/drivers/gpio/pcf857x.c
>> @@ -190,7 +190,6 @@ static int pcf857x_probe(struct
>> i2c_client *client,
>>      pdata = client->dev.platform_data;
>>      if (!pdata) {
>>
>> dev_dbg(&client->dev, "no platform data\n");
>> -        return -EINVAL;
>>      }
>>
>>      /* Allocate, initialize, and register
>> this gpio_chip. */
>> @@ -200,7 +199,7 @@ static int pcf857x_probe(struct
>> i2c_client *client,
>>
>>      mutex_init(&gpio->lock);
>>
>> -    gpio->chip.base =
>> pdata->gpio_base;
>> +    gpio->chip.base = pdata ?
>> pdata->gpio_base : -1;
>>      gpio->chip.can_sleep = 1;
>>      gpio->chip.dev =
>> &client->dev;
>>      gpio->chip.owner = THIS_MODULE;
>> @@ -278,7 +277,7 @@ static int pcf857x_probe(struct
>> i2c_client *client,
>>       * to zero, our software copy
>> of the "latch" then matches the chip's
>>       * all-ones reset
>> state.  Otherwise it flags pins to be driven low.
>>       */
>> -    gpio->out = ~pdata->n_latch;
>> +    gpio->out = pdata ?
>> ~pdata->n_latch : ~0;
>>
>>      status =
>> gpiochip_add(&gpio->chip);
>>      if (status < 0)
>> @@ -299,7 +298,7 @@ static int pcf857x_probe(struct
>> i2c_client *client,
>>      /* Let platform code set up the GPIOs
>> and their users.
>>       * Now is the first time
>> anyone could use them.
>>       */
>> -    if (pdata->setup) {
>> +    if (pdata && pdata->setup)
>> {
>>          status =
>> pdata->setup(client,
>>
>>     gpio->chip.base, gpio->chip.ngpio,
>>
>>     pdata->context);
>> @@ -322,7 +321,7 @@ static int pcf857x_remove(struct
>> i2c_client *client)
>>      struct pcf857x
>>         *gpio =
>> i2c_get_clientdata(client);
>>      int
>>
>> status = 0;
>>
>> -    if (pdata->teardown) {
>> +    if (pdata &&
>> pdata->teardown) {
>>          status =
>> pdata->teardown(client,
>>
>>     gpio->chip.base, gpio->chip.ngpio,
>>
>>     pdata->context);
>> --
>> 1.7.1
>>
>>
>
>


-- 
With best wishes
Dmitry
