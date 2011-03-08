Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1CHN0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 08:26:16 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55625 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1CHN0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:26:15 -0500
MIME-Version: 1.0
In-Reply-To: <20110308115640.GC20944@opensource.wolfsonmicro.com>
References: <1299577320-31389-1-git-send-email-linus.walleij@stericsson.com>
	<20110308115640.GC20944@opensource.wolfsonmicro.com>
Date: Tue, 8 Mar 2011 14:26:14 +0100
Message-ID: <AANLkTin7qD7O70u5HQVgWXQZTFR1O8dUOqyKWmn6sU1b@mail.gmail.com>
Subject: Re: [PATCH 2/3] regulator: add a subdriver for TI TPS6105x regulator portions
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 12:56 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Tue, Mar 08, 2011 at 10:42:00AM +0100, Linus Walleij wrote:
>
>> +static int tps6105x_regulator_get_voltage(struct regulator_dev *rdev)
>> +{
>
> It'd probably simplify things to use the _sel variants for the voltage
> operations.

Good idea. Fixed it.

>> +static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
>> +{
>> +     struct tps6105x *tps6105x = platform_get_drvdata(pdev);
>> +     struct tps6105x_platform_data *pdata = tps6105x->pdata;
>> +     int ret;
>> +
>> +     /* This instance is not set for regulator mode so bail out */
>> +     if (pdata->mode != TPS6105X_MODE_VOLTAGE)
>> +             return 0;
>
> -ENODEV?  Logging to explain why we're bombing out might be helpful too.

Not in this case actually, the chip is configured by platform data to
operate as regulator, LED or flashgun. All three drivers may be
compiled in at some point, and a system may have three TPS chips
performing each function. They will spawn three children each,
but only one of them should probe.

So the fact that the regulator driver doesn't probe doesn't mean any
failure, some other driver will likely probe successfully for the chip.

>> +     /* Set lowest voltage 4.5V to begin */
>> +     ret = tps6105x_mask_and_set(tps6105x, TPS6105X_REG_0,
>> +             TPS6105X_REG0_VOLTAGE_MASK,
>> +             TPS6105X_REG0_VOLTAGE_450 << TPS6105X_REG0_VOLTAGE_SHIFT);
>> +     if (ret)
>> +             return ret;
>
> Don't do this, if the user wants to set a defualt voltage they can use
> constraints but if the driver does it then it may disrupt a running
> system.

OK dropped it.

>> +#if 0
>> +     /* Activate voltage mode - use to check if voltage comes out */
>> +     ret = tps6105x_mask_and_set(tps6105x, TPS6105X_REG_0,
>> +             TPS6105X_REG0_MODE_MASK,
>> +             TPS6105X_REG0_MODE_VOLTAGE << TPS6105X_REG0_MODE_SHIFT);
>> +     if (ret)
>> +             return ret;
>> +#endif
>
> Don't include if 0 code.

Dropped it.

>> +subsys_initcall(tps6105x_regulator_init);
>> +module_exit(tps6105x_regulator_exit);
>
> These usually go next to the functions.

Reordered.

Thanks Mark,
Linus Walleij
