Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab1AEAn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:43:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49287 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1AEAn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:43:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LnONXZ0/T6zI6yO+mQBF22+bVzG9Vkvmx1zhj0pfcgEM5ly7vKuFDwtNOuDSWFhdxR
         +rlKQyF6eQF0JnVxqbbBiWcYrp0LQm3rEVuHGzrYoy1dRJkF9S7G1tuKbg9Y+L+3M6Dd
         Yvzrpxicc1wgJEe1ndOdVQUEW23Y1dZ2s+rvI=
MIME-Version: 1.0
In-Reply-To: <20110104135651.GD24774@opensource.wolfsonmicro.com>
References: <20101224113805.GI27832@sortiz-mobl>
	<1294118261-18906-4-git-send-email-myungjoo.ham@samsung.com>
	<20110104135651.GD24774@opensource.wolfsonmicro.com>
Date: Wed, 5 Jan 2011 09:43:55 +0900
X-Google-Sender-Auth: 5fAH_9I4IeG8PcLfIArEg5POmwQ
Message-ID: <AANLkTikeQPAELfkGjxu-ve=sG=35cP0uj7ach1VDOSrY@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] MFD MAX8998/LP3974: Support Charger
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Anton Vorontsov <cbou@mail.ru>,
        Lukasz Majewski <l.majewski@samsung.com>,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 10:56 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jan 04, 2011 at 02:17:41PM +0900, MyungJoo Ham wrote:
>> With the new regulator, "CHARGER", users can control charging
>> current and turn on and off the charger. Note that the charger
>> specification of LP3974 is different from that of MAX8998.
>>
>> driver/power/max8998.c supports power supply APIs for
>
> It's probably better to split the power supply driver into a separate
> patch as there should be no build time dependency between the two.  I've
> added Anton to the CCs as he is the drivers/power maintainer.
>
> One thing that jumps out here is that there's no regulator API usage at
> all in the power driver - the power driver just jumps straight in
> and updates registers when it needs to do anything.  Are you sure that
> the regulator API driver is needed at all, if it is I'd expect to see
> use of it in the power API.
>
>> +static const char * const manufacturers[] = {
>> +     [TYPE_MAX8998] = "Maxim",
>> +     [TYPE_LP3974] = "National Semiconductor",
>> +     [TYPE_UNKNOWN] = "Unknown",
>
> Normally this refers to the battery rather than the chip.
>
>> +static void _max8998_update_eoc(struct platform_device *pdev)
>> +{
>> +     struct max8998_battery_data *max8998 = platform_get_drvdata(pdev);
>> +     struct i2c_client *i2c = max8998->iodev->i2c;
>> +     int charge_current = 0;
>> +     int target_eoc_ratio;
>> +     u8 val;
>> +
>> +     /* Nothing to do. User set EOC with % */
>> +     if (max8998->eoc_in_mA == 0)
>> +             return;
>> +
>> +     /* Not initialized. */
>> +     if (!charger_current_map_desc)
>> +             return;
>
> This should be be driver data rather than a global for neatness (though
> in reality the chances of more than one of these chargers in a system
> are pretty low).

Ok. I'll make it possible to have max8998 and lp3974 at the same time
on a board. :)

>
>> --- a/drivers/regulator/max8998.c
>> +++ b/drivers/regulator/max8998.c
>> @@ -86,6 +86,13 @@ static const struct voltage_map_desc buck3_voltage_map_desc = {
>>  static const struct voltage_map_desc buck4_voltage_map_desc = {
>>       .min = 800,     .step = 100,    .max = 2300,
>>  };
>> +static const int charger_current_map_desc_max8998[] = {
>> +     90, 380, 475, 550, 570, 600, 700, 800
>> +};
>> +static const int charger_current_map_desc_lp3974[] = {
>> +     100, 400, 450, 500, 550, 600, 700, 800
>> +};
>> +const int *charger_current_map_desc;
>
> Ah, this is exported from the regulator driver...  That's slightly odd.
> For voltages we've an enumeration API for the supported settings, we
> probably ought to add that for current regulators too.
>
>> +     dev_info(&rdev->dev, "charger current limit = %dmA (%xh)\n",
>> +                     chosen_current, chosen);
>
> dev_dbg() or remove it entirely please, otherwise it might get a bit
> noisy.

Ok.

>
>> +static struct regulator_ops max8998_charger_ops = {
>> +     .is_enabled             = max8998_ldo_is_enabled_negated,
>> +     /* enable and disable are intentionally negated */
>> +     .enable                 = max8998_ldo_disable,
>> +     .disable                = max8998_ldo_enable,
>
> That's really confusing...  why?
>

I've negated max8998_charger_ops's enable/disable because other
max8998 registers use 1 for "ON" while this register use 0 for "ON".

-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
