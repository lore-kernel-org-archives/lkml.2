Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2EZQRH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 12:17:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44512 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2EZQRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 12:17:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120526002500.CA3123E14E9@localhost>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com>
	<1337952980-14621-4-git-send-email-b29396@freescale.com>
	<20120526002500.CA3123E14E9@localhost>
Date: Sat, 26 May 2012 09:17:04 -0700
Message-ID: <CAA+hA=QOC4_bWzDfbdLEwHBDw_CBjcd-iQOTp9TU0h3j_qwyxw@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] gpio: introduce lock mechanism for gpiochip_find
From: Dong Aisheng <dongas86@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 5:25 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, 25 May 2012 21:36:18 +0800, Dong Aisheng <b29396@freescale.com> wrote:
>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>
>> The module lock will be automatically claimed for gpiochip_find function
>> in case the gpio module is removed during the using of gpiochip instance.
>> Users are responsible to call gpiochip_put to release the lock after
>> the using.
>>
>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
>
> Hey Dong,
>
> Does this actually protect anything?  From what I can see the gpio_lock
> is held for the entire time of iterating over gpio_chips when the
> match function is called and the gpio number is fully resolved before
> gpiochip_find returns when called from of_get_named_gpio_flags().
>
Correct, the of_get_named_gpio_flags() has no issues.
The problem is the gpiochip pointer is returned and user may use it
with no lock which may possible already been released.
I got this suggestion from Stephen Warren originally and i agreed with him.

> Also, it doesn't do anything to protect against the gpio_chip being
> removed after the gpio number is resolved, which means the gpio number
> may no longer be valid, or may no longer point to the same gpio chip.
Can you help explain this case a bit more?
The module lock used here is only prevent the gpio module to be
removed which causes
the gpiochip to be release during the using.
You mean except module remove, the gpio_chip can also be removed by other case?

> It looks like the locking protection needs to be wider to be useful.
>
> Or is this patch to fix something in the mach-mx35-3ds.c, which is the
> only other use of gpiochip_find().
>
Formerly it's used for patch 6 since it used the gpiochip_find function.
But yes, mach-mx35-3ds.c should also need the lock if this is an issue.

Regards
Dong Aisheng
>
>> ---
>>  drivers/gpio/gpiolib-of.c  |    5 ++++-
>>  drivers/gpio/gpiolib.c     |   17 +++++++++++++++++
>>  include/asm-generic/gpio.h |    2 +-
>>  3 files changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
>> index b8010a9..d521452 100644
>> --- a/drivers/gpio/gpiolib-of.c
>> +++ b/drivers/gpio/gpiolib-of.c
>> @@ -63,6 +63,7 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
>>                             int index, enum of_gpio_flags *flags)
>>  {
>>       struct gg_data gg_data = { .flags = flags, .out_gpio = -ENODEV };
>> +     struct gpio_chip *chip;
>>       int ret;
>>
>>       /* .of_xlate might decide to not fill in the flags, so clear it. */
>> @@ -76,7 +77,9 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
>>               return -EINVAL;
>>       }
>>
>> -     gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
>> +     chip = gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
>> +     if (chip)
>> +             gpiochip_put(chip);
>>
>>       of_node_put(gg_data.gpiospec.np);
>>       pr_debug("%s exited with status %d\n", __func__, ret);
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index 120b2a0..6453d43 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -1144,6 +1144,18 @@ int gpiochip_remove(struct gpio_chip *chip)
>>  EXPORT_SYMBOL_GPL(gpiochip_remove);
>>
>>  /**
>> + * gpiochip_put() - release a gpio_chip
>> + * @chip: the chip to release
>> + */
>> +inline void gpiochip_put(struct gpio_chip *chip)
>> +{
>> +     BUG_ON(!chip);
>> +
>> +     module_put(chip->owner);
>> +}
>> +EXPORT_SYMBOL_GPL(gpiochip_put);
>> +
>> +/**
>>   * gpiochip_find() - iterator for locating a specific gpio_chip
>>   * @data: data to pass to match function
>>   * @callback: Callback function to check gpio_chip
>> @@ -1153,6 +1165,9 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
>>   * 0 if the device doesn't match and non-zero if it does.  If the callback is
>>   * non-zero, this function will return to the caller and not iterate over any
>>   * more gpio_chips.
>> + *
>> + * Note the gpio_chip is returned with the module locked, users are responsible
>> + * to release the lock with gpiochip_put(chip) after using it.
>>   */
>>  struct gpio_chip *gpiochip_find(void *data,
>>                               int (*match)(struct gpio_chip *chip,
>> @@ -1169,6 +1184,8 @@ struct gpio_chip *gpiochip_find(void *data,
>>
>>               if (match(gpio_desc[i].chip, data)) {
>>                       chip = gpio_desc[i].chip;
>> +                     if (!try_module_get(chip->owner))
>> +                             chip = NULL;
>>                       break;
>>               }
>>       }
>> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
>> index 365ea09..af372be 100644
>> --- a/include/asm-generic/gpio.h
>> +++ b/include/asm-generic/gpio.h
>> @@ -145,7 +145,7 @@ extern int __must_check gpiochip_remove(struct gpio_chip *chip);
>>  extern struct gpio_chip *gpiochip_find(void *data,
>>                                       int (*match)(struct gpio_chip *chip,
>>                                                    void *data));
>> -
>> +extern void gpiochip_put(struct gpio_chip *chip);
>>
>>  /* Always use the library code for GPIO management calls,
>>   * or when sleeping may be involved.
>> --
>> 1.7.0.4
>>
>>
>
> --
> Grant Likely, B.Sc, P.Eng.
> Secret Lab Technologies, Ltd.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
