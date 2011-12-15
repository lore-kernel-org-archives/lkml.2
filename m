Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab1LOSZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:25:38 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65375 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab1LOSZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:25:37 -0500
MIME-Version: 1.0
In-Reply-To: <1323941146.32031.49.camel@dhruva>
References: <C3AE124F08223B42BC95AEB82F0F6CED1F9D0895@KCHJEXMB01.kpit.com> <1323941146.32031.49.camel@dhruva>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 15 Dec 2011 11:25:15 -0700
X-Google-Sender-Auth: 67rzo9ZU5EM4RY16Z94D1dA7S4g
Message-ID: <CACxGe6tfxGToC2ScUdQv7KNu2xdhxA4ZG=Ms=oZZCQ+2A-aiTQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the regmap tree
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dajun <dajun.chen@diasemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 2:25 AM, Ashish Jangam
<ashish.jangam@kpitcummins.com> wrote:
> Fixes DA9052 GPIO errors.
>
> This patch is functionally tested on Samsung SMDKV6410.
>
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
>  drivers/gpio/gpio-da9052.c      |   37 ++++--------------------------
>  include/linux/mfd/da9052/gpio.h |   48 +++++++++++++++++++++++++++++++++++++++

gpio-da9052.c is the only users of mfd/da9052/gpio.h.  Why is this
include file needed?  The #defines can simply stay in the .c file.
I've picked up the patch, but modified it to keep the header defines
in the .c file.  If there is a reason this won't work, then please let
me know.

g.

>  2 files changed, 53 insertions(+), 32 deletions(-)
>  create mode 100644 include/linux/mfd/da9052/gpio.h
> diff --git a/drivers/gpio/gpio-da9052.c b/drivers/gpio/gpio-da9052.c
> index 038f5eb..a404ebd 100644
> --- a/drivers/gpio/gpio-da9052.c
> +++ b/drivers/gpio/gpio-da9052.c
> @@ -24,26 +24,6 @@
>  #include <linux/mfd/da9052/pdata.h>
>  #include <linux/mfd/da9052/gpio.h>
>
> -#define DA9052_INPUT                           1
> -#define DA9052_OUTPUT_OPENDRAIN                2
> -#define DA9052_OUTPUT_PUSHPULL                 3
> -
> -#define DA9052_SUPPLY_VDD_IO1                  0
> -
> -#define DA9052_DEBOUNCING_OFF                  0
> -#define DA9052_DEBOUNCING_ON                   1
> -
> -#define DA9052_OUTPUT_LOWLEVEL                 0
> -
> -#define DA9052_ACTIVE_LOW                      0
> -#define DA9052_ACTIVE_HIGH                     1
> -
> -#define DA9052_GPIO_MAX_PORTS_PER_REGISTER     8
> -#define DA9052_GPIO_SHIFT_COUNT(no)            (no%8)
> -#define DA9052_GPIO_MASK_UPPER_NIBBLE          0xF0
> -#define DA9052_GPIO_MASK_LOWER_NIBBLE          0x0F
> -#define DA9052_GPIO_NIBBLE_SHIFT               4
> -
>  struct da9052_gpio {
>        struct da9052 *da9052;
>        struct gpio_chip gp;
> @@ -104,33 +84,26 @@ static int da9052_gpio_get(struct gpio_chip *gc, unsigned offset)
>  static void da9052_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
>  {
>        struct da9052_gpio *gpio = to_da9052_gpio(gc);
> -       unsigned char register_value = 0;
>        int ret;
>
>        if (da9052_gpio_port_odd(offset)) {
> -               if (value) {
> -                       register_value = DA9052_GPIO_ODD_PORT_MODE;
>                        ret = da9052_reg_update(gpio->da9052, (offset >> 1) +
>                                                DA9052_GPIO_0_1_REG,
>                                                DA9052_GPIO_ODD_PORT_MODE,
> -                                               register_value);
> +                                               value << DA9052_GPIO_ODD_SHIFT);
>                        if (ret != 0)
>                                dev_err(gpio->da9052->dev,
>                                        "Failed to updated gpio odd reg,%d",
>                                        ret);
> -               }
>        } else {
> -               if (value) {
> -                       register_value = DA9052_GPIO_EVEN_PORT_MODE;
>                        ret = da9052_reg_update(gpio->da9052, (offset >> 1) +
>                                                DA9052_GPIO_0_1_REG,
>                                                DA9052_GPIO_EVEN_PORT_MODE,
> -                                               register_value);
> +                                               value << DA9052_GPIO_EVEN_SHIFT);
>                        if (ret != 0)
>                                dev_err(gpio->da9052->dev,
>                                        "Failed to updated gpio even reg,%d",
>                                        ret);
> -               }
>        }
>  }
>
> @@ -201,9 +174,9 @@ static struct gpio_chip reference_gp __devinitdata = {
>        .direction_input = da9052_gpio_direction_input,
>        .direction_output = da9052_gpio_direction_output,
>        .to_irq = da9052_gpio_to_irq,
> -       .can_sleep = 1;
> -       .ngpio = 16;
> -       .base = -1;
> +       .can_sleep = 1,
> +       .ngpio = 16,
> +       .base = -1,
>  };
>
>  static int __devinit da9052_gpio_probe(struct platform_device *pdev)
> diff --git a/include/linux/mfd/da9052/gpio.h b/include/linux/mfd/da9052/gpio.h
> new file mode 100644
> index 0000000..c427670
> --- /dev/null
> +++ b/include/linux/mfd/da9052/gpio.h
> @@ -0,0 +1,48 @@
> +/*
> + * GPIO module declarations for DA9052 PMICs.
> + *
> + * Copyright(c) 2011 Dialog Semiconductor Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +#ifndef __LINUX_MFD_DA9052_GPIO_H
> +#define __LINUX_MFD_DA9052_GPIO_H
> +
> +#define DA9052_INPUT                           1
> +#define DA9052_OUTPUT_OPENDRAIN                2
> +#define DA9052_OUTPUT_PUSHPULL                 3
> +
> +#define DA9052_SUPPLY_VDD_IO1                  0
> +
> +#define DA9052_DEBOUNCING_OFF                  0
> +#define DA9052_DEBOUNCING_ON                   1
> +
> +#define DA9052_OUTPUT_LOWLEVEL                 0
> +
> +#define DA9052_ACTIVE_LOW                      0
> +#define DA9052_ACTIVE_HIGH                     1
> +
> +#define DA9052_GPIO_MAX_PORTS_PER_REGISTER     8
> +#define DA9052_GPIO_SHIFT_COUNT(no)            (no%8)
> +#define DA9052_GPIO_MASK_UPPER_NIBBLE          0xF0
> +#define DA9052_GPIO_MASK_LOWER_NIBBLE          0x0F
> +#define DA9052_GPIO_NIBBLE_SHIFT               4
> +#define DA9052_IRQ_GPI0                        16
> +#define DA9052_GPIO_ODD_SHIFT                  7
> +#define DA9052_GPIO_EVEN_SHIFT                 3
> +
> +#endif /* __LINUX_MFD_DA9052_GPIO_H */
> ---
> On Thu, 2011-12-15 at 14:31 +0530, Ashish Jangam wrote:
>>
>> Hi Mark,
>>
>> After merging the regmap tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> drivers/gpio/gpio-da9052.c:25:35: fatal error: linux/mfd/da9052/gpio.h: No such file or directory
>>
>> So, it looks like this would never have built
>> (include/linux/mfd/da9052/gpio.h never existed) but noone ever enabled
>> CONFIG_PMIC_DA9052 before (which CONFIG_GPIO_DA9052 depends on).
>>
>> drivers/gpio/gpio-da9052.c was added with commit 07bfc9152365 ("GPIO:
>> DA9052 GPIO module v3") in v3.1-rc1.
>>
>> I have added this patch for today:
>>
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Thu, 15 Dec 2011 16:59:59 +1100
>> Subject: [PATCH] gpio: disable broken driver
>>
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> ---
>>  drivers/gpio/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> index 79199f4..e338013 100644
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -70,7 +70,7 @@ config GPIO_GENERIC
>>
>>  config GPIO_DA9052
>>       tristate "Dialog DA9052 GPIO"
>> -     depends on PMIC_DA9052
>> +     depends on PMIC_DA9052 && BROKEN
>>       help
>>         Say yes here to enable the GPIO driver for the DA9052 chip.
>>
>> --
>> 1.7.7.3
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
