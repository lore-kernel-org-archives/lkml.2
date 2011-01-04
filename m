Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab1ADIQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:16:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1ADIQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:16:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SetdjgfwEWwqFiTbpCts2//5dyHKVxmPpJWCgn6xKTrRpQVofm9sZNGfWfacuDb0MS
         i49H5RrEK1/PHlxOw3n7BqRPjUTsjvSmVjGJNR9ucEwAabQv6MHv5mIDNY6z07HWe3Hj
         qdgZtNqbxgNZNrIhvts0o8bT4RpzVvN3yBOuE=
MIME-Version: 1.0
In-Reply-To: <20110104084904.5765cd9e@lmajewski.digital.local>
References: <20101224113805.GI27832@sortiz-mobl>
	<1294118261-18906-3-git-send-email-myungjoo.ham@samsung.com>
	<20110104084904.5765cd9e@lmajewski.digital.local>
Date: Tue, 4 Jan 2011 17:16:56 +0900
X-Google-Sender-Auth: IY9szT3E31IV90y3SRKqQFdvOQQ
Message-ID: <AANLkTi=dJ83par+U8YfbpC3HVjEkc9rfPU8pxSFN_mTb@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] regulator MAX8998/LP3974: Support DVS-GPIO.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 4:49 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:
> On Tue, 04 Jan 2011 14:17:40 +0900
> MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>
> Hi all,
>
> I've posted some comments below:
>
> if (gpio_is_valid(pdata->buck2_set3)) {
>> -                     if (max8998->buck2_vol[0] == i) {
>> -                             max8998->buck2_idx = 0;
>> -                             buck2_gpio_set(pdata->buck2_set3, 0);
>> -                     } else {
>> -                             max8998->buck2_idx = 1;
>> -                             ret =
>> max8998_get_voltage_register(rdev, &reg, -
>> &shift,
>> -
>> &mask);
>> -                             ret = max8998_write_reg(i2c, reg, i);
>> -                             max8998->buck2_vol[1] = i;
>> -                             buck2_gpio_set(pdata->buck2_set3, 1);
>> +
>> +                     /* check if requested voltage */
>> +                     /* value is already defined */
>> +                     for (j = 0; j <
>> ARRAY_SIZE(max8998->buck2_vol); j++) {
>> +                             if (max8998->buck2_vol[j] == i) {
>> +                                     max8998->buck2_idx = j;
>> +
>> buck2_gpio_set(pdata->buck2_set3, j);
>> +                                     goto buck2_exit;
>> +                             }
>>                       }
>> +
>> +                     if (pdata->buck_voltage_lock)
>> +                             return -EINVAL;
>> +
>> +                     max8998_get_voltage_register(rdev,
>> +                                     &reg, &shift, &mask);
>> +                     ret = max8998_write_reg(i2c, reg, i);
>> +                     max8998->buck2_vol[max8998->buck2_idx] = i;
>> +
>> buck2_gpio_set(pdata->buck2_set3,max8998->buck2_idx); +buck2_exit:
>> dev_dbg(max8998->dev, "%s: SET3:%d\n", i2c->name,
> gpio_get_value(pdata->buck2_set3));
>
> Maybe only the matter of taste. The "for" loop for only two elements?

It was only for the look; to appear more symmetric with buck1.

>
>> + * @buck_voltage_lock: Do NOT change the values of the following six
>> + *   registers set by buck?_voltage?. The voltage of BUCK1/2 cannot
>> + *   be other than the preset values.
>> + * @buck1_voltage1: BUCK1 DVS mode 1 voltage register
>> + * @buck1_voltage2: BUCK1 DVS mode 2 voltage register
>> + * @buck1_voltage3: BUCK1 DVS mode 3 voltage register
>> + * @buck1_voltage4: BUCK1 DVS mode 4 voltage register
>> + * @buck2_voltage1: BUCK2 DVS mode 1 voltage register
>> + * @buck2_voltage2: BUCK2 DVS mode 2 voltage register
>
> Is it desirable to define all four for BUCK1 and two for BUCK2 DVS
> voltages in platform code?

In case a system with 4 buck1 preset voltages and 2 buck2 preset
voltages, it is desirable. :)

>
> Why the "general purpose" slots approach for user changeable/definable
> voltages (as it was done previously) have been replaced? Is the current
> approach faster?

As long as "buck_voltage_lock" is not set, user may use voltages not
defined as a preset (buckx_voltagex).

If buck_voltage_lock is true, any voltage not predefined is
rejected.However, if not, undefined voltages are accepted and from the
point where an undefined voltage is submitted, presets are not
guaranteed to be kept (any of preset values may be overwritten.)

>
>
> --
> Best regards,
>
> Lukasz Majewski
>
> Samsung Poland R&D Center
> Platform Group
>

Thanks.

-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
