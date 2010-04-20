Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0DTQUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:20:07 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43881 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab0DTQUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:20:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sSoR6SFEtz2sKnSdeL19KiaSK5RSWQsGBO1kQEr07kBe2MVXmS/vTj/xozRrePd2Ao
         mDGAUWfMGObs7LcPDbsnqWAZjjVLvKV4pZWVdpWaaQ2dD/iR/Ust7oZjTUWqW78e7Wrt
         h8q56JDc+tav6/jzT/CQIasD3sPO+zPXhYYSE=
MIME-Version: 1.0
In-Reply-To: <20100416161248.GB28863@sortiz.org>
References: <1271113543-7303-1-git-send-email-linus.walleij@stericsson.com>
	 <20100416161248.GB28863@sortiz.org>
Date: Tue, 20 Apr 2010 18:20:00 +0200
Message-ID: <q2t63386a3d1004200920odd7f046fjb4044eb9c5faaebf@mail.gmail.com>
Subject: Re: [PATCH 3/3] MFD: AB3550 core driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com,
       Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel, thanks for the quick review! We'll fix most things, just a few
questions...

2010/4/16 Samuel Ortiz <sameo@linux.intel.com>:

> Some comments:
>
>> diff --git a/arch/arm/mach-u300/i2c.c b/arch/arm/mach-u300/i2c.c
>> index d893ee0..f0394ba 100644
>> --- a/arch/arm/mach-u300/i2c.c
>> +++ b/arch/arm/mach-u300/i2c.c
> I'd like the machine specific files to be part of a separate patch, please.
>
>
>
>> @@ -46,6 +46,7 @@
>>  /* BUCK SLEEP 0xAC: 1.05V, Not used, SLEEP_A and B, Not used */
>>  #define BUCK_SLEEP_SETTING   0xAC
>>
>> +#ifdef CONFIG_AB3100_CORE
>>  static struct regulator_consumer_supply supply_ldo_c[] = {
>>       {
>>               .dev_name = "ab3100-codec",
>> @@ -253,14 +254,68 @@ static struct ab3100_platform_data ab3100_plf_data = {
>>               LDO_D_SETTING,
>>       },
>>  };
>> +#endif
>> +
>> +#ifdef CONFIG_AB3550_CORE
>> +static struct abx500_init_settings ab3550_init_settings[] = {
>> +     {
>> +             .bank = 0,
>> +             .reg = AB3550_IMR1,
>> +             .setting = 0xff
>> +     },
>> +     {
>> +             .bank = 0,
>> +             .reg = AB3550_IMR2,
>> +             .setting = 0xff
>> +     },
>> +     {
>> +             .bank = 0,
>> +             .reg = AB3550_IMR3,
>> +             .setting = 0xff
>> +     },
>> +     {
>> +             .bank = 0,
>> +             .reg = AB3550_IMR4,
>> +             .setting = 0xff
>> +     },
>> +     {
>> +             .bank = 0,
>> +             .reg = AB3550_IMR5,
>> +             /* The two most significant bits are not used */
>> +             .setting = 0x3f
>> +     },
>> +};
>> +
>> +static struct ab3550_platform_data ab3550_plf_data = {
>> +     .irq = {
>> +             .base = IRQ_AB3550_BASE,
>> +             .count = (IRQ_AB3550_END - IRQ_AB3550_BASE + 1),
>> +     },
>> +     .dev_data = {
>> +     },
>> +     .init_settings = ab3550_init_settings,
>> +     .init_settings_sz = ARRAY_SIZE(ab3550_init_settings),
>> +};
>> +#endif
>>
>>  static struct i2c_board_info __initdata bus0_i2c_board_info[] = {
>> +#if defined(CONFIG_AB3550_CORE)
>> +     {
>> +             .type = "ab3550",
>> +             .addr = 0x4A,
>> +             .irq = IRQ_U300_IRQ0_EXT,
>> +             .platform_data = &ab3550_plf_data,
>> +     },
>> +#elif defined(CONFIG_AB3100_CORE)
>>       {
>>               .type = "ab3100",
>>               .addr = 0x48,
>>               .irq = IRQ_U300_IRQ0_EXT,
>>               .platform_data = &ab3100_plf_data,
>>       },
>> +#else
>> +     { },
>> +#endif
>
> All those ifdefs really look like they should be part of your board definition
> files.

It's in arch/arm/mach-ux500/i2c.c which is a board definition file.. or am I
misunderstanding something here?

>> +/**
>> + * struct ab3550_reg_range
>> + * @first: the first address of the range
>> + * @last: the last address of the range
>> + * @perm: access permissions for the range
>> + */
>> +struct ab3550_reg_range {
>> +     u8 first;
>> +     u8 last;
>> +     u8 perm;
>> +};
>
> I wonder if you could simply use struct resource for that purpose.

We're testing it. Will be back with results.

>> +int abx500_set_register_interruptible(struct device *dev, u8 bank, u8 reg,
>> +     u8 value)
>> +{
>> +     return abx500_mask_and_set_register_interruptible(dev, bank, reg, 0xFF,
>> +             value);
>> +}
>> +EXPORT_SYMBOL(abx500_set_register_interruptible);
>> +
>> +int abx500_get_register_interruptible(struct device *dev, u8 bank, u8 reg,
>> +     u8 *value)
>> +{
>> +     struct ab3550 *ab;
>> +     struct ab3550_dev *abdev;
>> +
>> +     abdev = to_ab3550_dev(dev);
>> +     if ((AB3550_NUM_BANKS <= bank) ||
>> +             !reg_read_allowed(&abdev->reg_ranges[bank], reg))
>> +             return -EINVAL;
>> +
>> +     ab = dev_get_drvdata(dev->parent);
>> +     return get_register_interruptible(ab, bank, reg, value);
>> +}
>> +EXPORT_SYMBOL(abx500_get_register_interruptible);
>> +
>> +int abx500_get_register_page_interruptible(struct device *dev, u8 bank,
>> +     u8 first_reg, u8 *regvals, u8 numregs)
>> +{
>> +     struct ab3550 *ab;
>> +     struct ab3550_dev *abdev;
>> +
>> +     abdev = to_ab3550_dev(dev);
>> +     if ((AB3550_NUM_BANKS <= bank) ||
>> +             !page_read_allowed(&abdev->reg_ranges[bank], first_reg,
>> +                     (first_reg + numregs - 1)))
>> +             return -EINVAL;
>> +
>> +     ab = dev_get_drvdata(dev->parent);
>> +     return get_register_page_interruptible(ab, bank, first_reg, regvals,
>> +             numregs);
>> +}
>> +EXPORT_SYMBOL(abx500_get_register_page_interruptible);
>> +
>> +int abx500_mask_and_set_register_interruptible(struct device *dev, u8 bank,
>> +     u8 reg, u8 bitmask, u8 bitvalues)
>> +{
>> +     struct ab3550 *ab;
>> +     struct ab3550_dev *abdev;
>> +
>> +     abdev = to_ab3550_dev(dev);
>> +     if ((AB3550_NUM_BANKS <= bank) ||
>> +             !reg_write_allowed(&abdev->reg_ranges[bank], reg))
>> +             return -EINVAL;
>> +
>> +     ab = dev_get_drvdata(dev->parent);
>> +     return mask_and_set_register_interruptible(ab, bank, reg,
>> +              bitmask, bitvalues);
>> +}
>> +EXPORT_SYMBOL(abx500_mask_and_set_register_interruptible);
>
> All those exports here will conflict with the new ones from your 2nd patch.
> This is not acceptable as there is nothing (and there shouldnt be) preventing
> me from building both at the same time.

Aha, well that's not how it was engineered, since these chips are the kind
that you have only one of in these platforms. So it's exclusive AB3100 or
AB3550 for example, never both at the same time.

> You either have one driver for all those chips or you keep 2 of them but them
> you need to have 2 separate namespaces.

If we separate the namespaces we cannot use common subdrivers for
RTC, charging, ...

So I read it like we *have* to replace mfd/ab3100-core.c with a common file
mfd/abx500-core.c that is used by both AB3100 and AB3550 alike?

It's elegant in a way, but will lead to excessive luggage once the different
drivers start to stack up.

However if this is what you want we can try it.

Yours,
Linus Walleij
