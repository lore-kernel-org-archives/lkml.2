Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab2HMNJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:09:34 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39587 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2HMNJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:09:32 -0400
MIME-Version: 1.0
In-Reply-To: <201208060738.q767ci5c005713@ubuntu>
References: <201208060738.q767ci5c005713@ubuntu>
Date: Mon, 13 Aug 2012 15:09:31 +0200
Message-ID: <CACRpkdYLMRCuZoKPhEwyyoPonUY-mgLOxDvmnoCmCbCxiGHwcA@mail.gmail.com>
Subject: Re: [NEW DRIVER V2 5/7] DA9058 GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anthony, sorry for delayed reply...

On Sun, Aug 5, 2012 at 10:43 PM, Anthony Olech
<anthony.olech.opensource@diasemi.com> wrote:

> This is the GPIO component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC driver.
> It depends on the core DA9058 MFD driver.

OK

> +config GPIO_DA9058
> +       tristate "Dialog DA9058 GPIO"
> +       depends on MFD_DA9058

select IRQ_DOMAIN, you're going to want to use it...

> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 0f55662..209224a 100644
(...)
> +#include <linux/module.h>
> +#include <linux/fs.h>

Really?

> +#include <linux/uaccess.h>

Really?

> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/syscalls.h>

Really?

> +#include <linux/seq_file.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/mfd/core.h>
> +#include <linux/regmap.h>

If you're using regmap you better select it in Kconfig
too, but it appears you don't. You should be using regmap in the
main MFD driver in this case (I haven't looked at it though.)

This header set just looks like it was copied from some other
file and never really proofread, so please go over it in detail.

> +#include <linux/mfd/da9058/version.h>
> +#include <linux/mfd/da9058/registers.h>
> +#include <linux/mfd/da9058/core.h>
> +#include <linux/mfd/da9058/gpio.h>
> +#include <linux/mfd/da9058/irq.h>
> +#include <linux/mfd/da9058/pdata.h>

Samuel will have to comment on this organization of headers, it seems a
little much. DO you really need all of them?

> +struct da9058_gpio {
> +       struct da9058 *da9058;
> +       struct platform_device *pdev;
> +       struct gpio_chip gp;
> +       struct mutex lock;
> +       u8 inp_config;
> +       u8 out_config;
> +};
> +
> +static struct da9058_gpio *gpio_chip_to_da9058_gpio(struct gpio_chip *chip)
> +{
> +       return container_of(chip, struct da9058_gpio, gp);
> +}

static inline, or a #define, but the compile will probably optimize-inline
it anyway.

> +static int da9058_gpio_get(struct gpio_chip *gc, unsigned offset)
> +{
> +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> +       struct da9058 *da9058 = gpio->da9058;
> +       unsigned int gpio_level;
> +       int ret;
> +
> +       if (offset > 1)
> +               return -EINVAL;

So there are two GPIO pins, 0 and 1? That seems odd, but OK.

> +
> +       mutex_lock(&gpio->lock);
> +       ret = da9058_reg_read(da9058, DA9058_STATUSC_REG, &gpio_level);
> +       mutex_unlock(&gpio->lock);
> +       if (ret < 0)
> +               return ret;
> +
> +       if (offset) {
> +               if (gpio_level & DA9058_STATUSC_GPI1)
> +                       return 1;
> +               else
> +                       return 0;
> +       } else {
> +               if (gpio_level & DA9058_STATUSC_GPI0)
> +                       return 1;
> +               else
> +                       return 0;
> +       }
> +}
> +
> +static void da9058_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
> +{
> +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> +       struct da9058 *da9058 = gpio->da9058;
> +       unsigned int gpio_cntrl;
> +       int ret;
> +
> +       if (offset > 1) {
> +               dev_err(da9058->dev,
> +                       "Failed to set GPIO%d output=%d because illegal GPIO\n",
> +                       offset, value);
> +               return;
> +       }
> +
> +       mutex_lock(&gpio->lock);
> +
> +       ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
> +       if (ret)
> +               goto exit;
> +
> +       if (offset) {

So this is for GPIO 1

> +               u8 value_bits = value ? 0x80 : 0x00;

These "value_bits" are just confusing. Just delete this and use the
direct value below.

> +
> +               gpio->out_config &= ~0x80;

A better way of writing &= ~0x80; is &= 0x7F

> +               gpio->out_config |= value_bits;

gpio->out_config = value ? 0x80 : 0x00;

So, less confusing.

> +               if (!(gpio_cntrl & 0x20))
> +                       goto exit;

Please insert a comment explaining what this bit is doing and
why you're just exiting if it's not set. I don't understand one thing.

Maybe this would be better if you didn't use so many magic values,
what about:

#include <linux/bitops.h>

#define FOO_FLAG BIT(3) /* This is a flag for foo */

> +
> +               gpio_cntrl &= ~0xF0;

A better way to write &= ~F0 is to write &= 0x0F;

If you don't #define the constants this way of negating numbers
just get confusing.

So this is OK:

  foo &= ~FOO_FLAG;
  foo |= set ? FOO_FLAG : 0;

This is just hard to read:

  foo &= ~0x55;
  foo |= set ? 0x55 : 0;

And is better off

   foo &= 0xAA;
   foo |= set ? 0x55 : 0;

I prefer that you #define the registers but it's your pick.


> +               gpio_cntrl |= 0xF0 & gpio->out_config;
> +
> +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
> +       } else {
> +               u8 value_bits = value ? 0x08 : 0x00;

Same here, delete this.

> +               gpio->out_config &= ~0x08;

&= 0xF7;

or use some <linux/bitops.h> and #defines ...

> +               gpio->out_config |= value_bits;

Just
gpio->out_config |= value ? 0x08 : 0x00;

> +               if (!(gpio_cntrl & 0x02))
> +                       goto exit;

Same thing, explain that flag.

> +
> +               gpio_cntrl &= ~0x0F;

Just &= 0xF0;

> +               gpio_cntrl |= 0x0F & gpio->out_config;
> +
> +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);

Further, if you're checking that flag just in order to avoid doing this
write if it's not necessary, it's the wrong solution. The right solution
is to implement regmap in the MFD driver so it quickly sees that
the right value is already in the register and bounces off.

> +       }
> +exit:
> +       mutex_unlock(&gpio->lock);
> +       if (ret)
> +               dev_err(da9058->dev,
> +                       "Failed to set GPIO%d output=%d error=%d\n",
> +                       offset, value, ret);
> +       return;
> +}
> +
> +static int da9058_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
> +{
> +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> +       struct da9058 *da9058 = gpio->da9058;
> +       unsigned int gpio_cntrl;
> +       int ret;
> +
> +       if (offset > 1)
> +               return -EINVAL;
> +
> +       mutex_lock(&gpio->lock);
> +
> +       ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
> +       if (ret)
> +               goto exit;
> +
> +       if (offset) {
> +               gpio_cntrl &= ~0xF0;

&= 0x0F; or #define the flag... FOO_MASK.

> +               gpio_cntrl |= 0xF0 & gpio->inp_config;
> +
> +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
> +       } else {
> +               gpio_cntrl &= ~0x0F;

&= 0xF0;

> +               gpio_cntrl |= 0x0F & gpio->inp_config;
> +
> +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
> +       }
> +exit:
> +       mutex_unlock(&gpio->lock);
> +       if (ret)
> +               dev_err(da9058->dev,
> +                       "Failed to set GPIO%d to output error=%d\n",
> +                       offset, ret);
> +       return ret;
> +}
> +
> +static int da9058_gpio_direction_output(struct gpio_chip *gc,
> +                                       unsigned offset, int value)
> +{
> +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> +       struct da9058 *da9058 = gpio->da9058;
> +       unsigned int gpio_cntrl;
> +       int ret;
> +
> +       if (offset > 1)
> +               return -EINVAL;
> +
> +       mutex_lock(&gpio->lock);
> +
> +       ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
> +       if (ret)
> +               goto exit;
> +
> +       if (offset) {
> +               gpio_cntrl &= ~0xF0;
> +               gpio_cntrl |= 0xF0 & gpio->out_config;
> +
> +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
> +       } else {
> +               gpio_cntrl &= ~0x0F;
> +               gpio_cntrl |= 0x0F & gpio->out_config;
> +
> +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
> +       }
> +exit:
> +       mutex_unlock(&gpio->lock);
> +       if (ret)
> +               dev_err(da9058->dev,
> +                       "Failed to set GPIO%d to input error=%d\n",
> +                       offset, ret);
> +       return ret;
> +}

Same comments as above, and you need a blank line here.

> +/*
> + *  da9058_gpio_to_irq is an implementation of the GPIO Hook
> + *  @to_irq: supporting non-static gpio_to_irq() mappings
> + *  whose implementation may not sleep. This hook is called
> + *  when setting up the threaded GPIO irq handler.
> + */
> +static int da9058_gpio_to_irq(struct gpio_chip *gc, u32 offset)
> +{
> +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> +       struct da9058 *da9058 = gpio->da9058;
> +
> +       if (offset > 1)
> +               return -EINVAL;
> +
> +       if (offset)
> +               return da9058_to_virt_irq_num(da9058, DA9058_IRQ_EGPI1);
> +       else
> +               return da9058_to_virt_irq_num(da9058, DA9058_IRQ_EGPI0);
> +}

Lee Jones and Mark Brown discussed these virtual IRQ mapping functions
recently, and I think the outcome was to patch irqdomain to do the work
and not sprinkle these custom interfaces to fetch virtual IRQs all over the
place.

> +static int da9058_gpio_set_debounce(struct gpio_chip *gc, unsigned offset,
> +                               unsigned debounce)
> +{
> +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> +       struct da9058 *da9058 = gpio->da9058;
> +       int ret;
> +       unsigned int gpio_cntrl;
> +
> +       if (offset > 1)
> +               return -EINVAL;
> +
> +       mutex_lock(&gpio->lock);
> +
> +       ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
> +       if (ret)
> +               goto exit;
> +
> +       if (offset) {
> +               u8 debounce_bits = debounce ? 0x80 : 0x00;
> +
> +               gpio->inp_config &= ~0x80;
> +               gpio->inp_config |= debounce_bits;
> +
> +               if (gpio_cntrl & 0x20)
> +                       goto exit;
> +
> +               gpio_cntrl &= ~0xF0;
> +               gpio_cntrl |= 0xF0 & gpio->inp_config;
> +
> +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
> +       } else {
> +               u8 debounce_bits = debounce ? 0x08 : 0x00;
> +
> +               gpio->inp_config &= ~0x08;
> +               gpio->inp_config |= debounce_bits;
> +
> +               if (gpio_cntrl & 0x02)
> +                       goto exit;
> +
> +               gpio_cntrl &= ~0x0F;
> +               gpio_cntrl |= 0x0F & gpio->inp_config;
> +
> +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
> +       }
> +exit:
> +       mutex_unlock(&gpio->lock);
> +       if (ret)
> +               dev_err(da9058->dev,
> +                       "Failed to set GPIO%d bounce=%d error=%d\n",
> +                       offset, debounce, ret);
> +       return ret;
> + }

Apart from the same comments as above, debounce is actually pin control
territory and not part of <linux/gpio.h>. Now this is a very small interface,
but I still want you to consider using pin control for these portions.

The good thing about doing it with pin control is that you can have it
set up on boot using hogs and need to think anymor about the pin
config business.

The rest looks nice!

Yours,
Linus Walleij
