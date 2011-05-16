Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1EPI3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:29:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49288 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1EPI3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pJwJRhdnlIAZg/zO8UzKctkeQ8nk94PFWUIc9UOCplHVYuQX/gmVESL2HZpa1XgLzD
         SmroTZxQxLz4D3j/Z82uMdA1FP2KFuqIoUXoKPs5ggJjobLB2Y8JSfyQGEef1mQ0ogrZ
         ua7pFbWddciEvURhBLRbiH/s5Cq1WBqj2swEA=
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <BANLkTinkMFeZVJmifEj6_H+ov8HMk_MAzA@mail.gmail.com>
References: <25864346.87131305530134778.JavaMail.weblogic@epml26>
	<BANLkTinkMFeZVJmifEj6_H+ov8HMk_MAzA@mail.gmail.com>
Date: Mon, 16 May 2011 17:29:51 +0900
X-Google-Sender-Auth: iGKa3gATo-yjZ_9Oz36fv7CaJiU
Message-ID: <BANLkTimHr2OOi8RVone+h2yCXAHh2Sm5aQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: Simplify MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS
 macros
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: axel.lin@gmail.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Axel,

On Mon, May 16, 2011 at 5:05 PM, Axel Lin <axel.lin@gmail.com> wrote:
> Hi MyungJoo,
>
> 2011/5/16 함명주 <myungjoo.ham@samsung.com>:
>> Hello,
>>
>>> Sender : Axel Lin<axel.lin@gmail.com>
>>> Date : 2011-05-16 15:52 (GMT+09:00)
>>> Title : [PATCH] regulator: Simplify MAX8997_REG_BUCK1DVS/MAX8997_REG_BUCK2DVS/MAX8997_REG_BUCK5DVS macros
>>>
>>> Looks like the original macro implementation assumes the caller pass the
>>> parameter starting from 1.
>>> Since now we have +1 operation from all the caller, it would be easier to
>>> assume the caller pass the parameter starting from 0.
>>> Then we can simplify the +1 operation from the caller and then -1 operation
>>> in the macro implementation.
>>>
>>> I think this change also improves readability.
>>>
>>> Signed-off-by: Axel Lin
>>
>> Well, I'd rather just change the for loop statement for your purpose, which I also agree.
>>
>> The reason I've used BUCKxDVS1 as the starting point is because of the register names; register names of BUCKxDVS starts from 1, not from 0.
>
> Ok. I got your point for the implementation.
>
>> Thus, in order to maintain the consistency between the code and the chip manual, I'd rather not change that part, but change like this:
>>
>> ---
>> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
>> index b1c1444..aad85e4 100644
>> --- a/drivers/regulator/max8997.c
>> +++ b/drivers/regulator/max8997.c
>> @@ -1031,12 +1031,12 @@ static __devinit int max8997_pmic_probe(struct platform_device *pdev)
>>        }
>>
>>        /* For the safety, set max voltage before setting up */
>> -       for (i = 0; i < 8; i++) {
>> -               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i + 1),
>> +       for (i = 1; i <= 8; i++) {
>> +               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i),
>>                                max_buck1, 0x3f);
>> -               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i + 1),
>> +               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i),
>>                                max_buck2, 0x3f);
>> -               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i + 1),
>> +               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i),
>>                                max_buck5, 0x3f);
>>        }
>>
>> --
>> 1.7.4.1
>>
>> How about this one?
>>
> But it doesn't apply for below case because max8997->buck1_vol[i] is
> start from 0.
>
>
>        for (i = 0; i < 8; i++) {
>                max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i),
>                                max8997->buck1_vol[i],
>                                0x3f);
>
> Maybe consider to remove the macro may make things simpler.
> If you agree, I'll send a v2.

Yes, that looks just fine to me.

Thank you.


- MyungJoo

>
> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
> index b1c1444..10d5a1d 100644
> --- a/drivers/regulator/max8997.c
> +++ b/drivers/regulator/max8997.c
> @@ -1032,11 +1032,11 @@ static __devinit int max8997_pmic_probe(struct
> platform_device *pdev)
>
>        /* For the safety, set max voltage before setting up */
>        for (i = 0; i < 8; i++) {
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
>                                max_buck1, 0x3f);
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
>                                max_buck2, 0x3f);
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
>                                max_buck5, 0x3f);
>        }
>
> @@ -1113,13 +1113,13 @@ static __devinit int max8997_pmic_probe(struct
> platform_device *pdev)
>
>        /* Initialize all the DVS related BUCK registers */
>        for (i = 0; i < 8; i++) {
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
>                                max8997->buck1_vol[i],
>                                0x3f);
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
>                                max8997->buck2_vol[i],
>                                0x3f);
> -               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i + 1),
> +               max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
>                                max8997->buck5_vol[i],
>                                0x3f);
>        }
> diff --git a/include/linux/mfd/max8997-private.h
> b/include/linux/mfd/max8997-private.h
> index 69d1010..5ff2400 100644
> --- a/include/linux/mfd/max8997-private.h
> +++ b/include/linux/mfd/max8997-private.h
> @@ -311,10 +311,6 @@ enum max8997_irq {
>        MAX8997_IRQ_NR,
>  };
>
> -#define MAX8997_REG_BUCK1DVS(x)        (MAX8997_REG_BUCK1DVS1 + (x) - 1)
> -#define MAX8997_REG_BUCK2DVS(x)        (MAX8997_REG_BUCK2DVS1 + (x) - 1)
> -#define MAX8997_REG_BUCK5DVS(x)        (MAX8997_REG_BUCK5DVS1 + (x) - 1)
> -
>  #define MAX8997_NUM_GPIO       12
>  struct max8997_dev {
>        struct device *dev;
>
>
> Regards,
> Axel
>



-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
