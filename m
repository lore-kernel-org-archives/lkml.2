Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2HOKJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 06:09:02 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:40952 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2HOKJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 06:09:00 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: RE: [NEW DRIVER V2 5/7] DA9058 GPIO driver
Thread-Topic: [NEW DRIVER V2 5/7] DA9058 GPIO driver
Thread-Index: AQHNc6a/Zi3XRU+2jEuZoRuVvokjK5dXsa+AgALfzlA=
Date: Wed, 15 Aug 2012 10:08:56 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51032C651B@NB-EX-MBX02.diasemi.com>
References: <201208060738.q767ci5c005713@ubuntu>
 <CACRpkdYLMRCuZoKPhEwyyoPonUY-mgLOxDvmnoCmCbCxiGHwcA@mail.gmail.com>
In-Reply-To: <CACRpkdYLMRCuZoKPhEwyyoPonUY-mgLOxDvmnoCmCbCxiGHwcA@mail.gmail.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: 13 August 2012 14:10
> To: Opensource [Anthony Olech]
> Cc: Grant Likely; Linus Walleij; Mark Brown; LKML; David Dajun Chen; Samuel
> Ortiz; Lee Jones
> Subject: Re: [NEW DRIVER V2 5/7] DA9058 GPIO driver
> Hi Anthony, sorry for delayed reply... 
> On Sun, Aug 5, 2012 at 10:43 PM, Anthony Olech
> <anthony.olech.opensource@diasemi.com> wrote:
> > This is the GPIO component driver of the Dialog DA9058 PMIC.
> > This driver is just one component of the whole DA9058 PMIC driver.
> > It depends on the core DA9058 MFD driver.
> OK
> > +config GPIO_DA9058
> > +       tristate "Dialog DA9058 GPIO"
> > +       depends on MFD_DA9058
> select IRQ_DOMAIN, you're going to want to use it...
> > diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile index
> > 0f55662..209224a 100644
> (...)
> > +#include <linux/module.h>
> > +#include <linux/fs.h>
> Really?
> > +#include <linux/uaccess.h>
> Really?
> > +#include <linux/platform_device.h>
> > +#include <linux/gpio.h>
> > +#include <linux/syscalls.h>
> Really?
> > +#include <linux/seq_file.h>
> > +#include <linux/slab.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/mfd/core.h>
> > +#include <linux/regmap.h>
> If you're using regmap you better select it in Kconfig too, but it appears you
> don't. You should be using regmap in the main MFD driver in this case (I
> haven't looked at it though.)
> This header set just looks like it was copied from some other file and never
> really proofread, so please go over it in detail.


for some reason against 2.6.2x some of those were required, I just totally
forgot to prune out the unwanted ones when rebasing forwards to 3.5.
Good that you spotted it! Sorry I will try to prune the includes in the future.


> > +#include <linux/mfd/da9058/version.h> #include
> > +<linux/mfd/da9058/registers.h> #include <linux/mfd/da9058/core.h>
> > +#include <linux/mfd/da9058/gpio.h> #include <linux/mfd/da9058/irq.h>
> > +#include <linux/mfd/da9058/pdata.h>
> Samuel will have to comment on this organization of headers, it seems a little
> much. DO you really need all of them?


One of them should have been stripped out by my submit script, but as for the
others you must bear in mind that the DA9058 PMIC is a multifunction device,
and thus some header files are common and some are specific to various
component drivers. The very reason that you picked up on non-relevant include
files surely has implications on the structure of the header files for the DA9058,
in particular struct's and define's that only apply to one component driver should
be in separate header files.


> > +struct da9058_gpio {
> > +       struct da9058 *da9058;
> > +       struct platform_device *pdev;
> > +       struct gpio_chip gp;
> > +       struct mutex lock;
> > +       u8 inp_config;
> > +       u8 out_config;
> > +};
> > +
> > +static struct da9058_gpio *gpio_chip_to_da9058_gpio(struct gpio_chip
> > +*chip) {
> > +       return container_of(chip, struct da9058_gpio, gp); }
> static inline, or a #define, but the compile will probably optimize-inline it
> anyway.


The compiler should optimize it to in-line, but I will change it anyway.


> > +static int da9058_gpio_get(struct gpio_chip *gc, unsigned offset) {
> > +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> > +       struct da9058 *da9058 = gpio->da9058;
> > +       unsigned int gpio_level;
> > +       int ret;
> > +
> > +       if (offset > 1)
> > +               return -EINVAL; 
> So there are two GPIO pins, 0 and 1? That seems odd, but OK.


That is a feature of the hardware. I believe that calling them "0" and
"1" is the correct thing to do. Correct me if they should have been
called "1" and "2", or something else.


> > +       if (offset) { 
> So this is for GPIO 1


Yes, it seemed the obvious thing to do.


> > +               u8 value_bits = value ? 0x80 : 0x00;
> 
> These "value_bits" are just confusing. Just delete this and use the direct value
> below.


Will do. It was done for diagnostics that have since been stripped out.


> > +
> > +               gpio->out_config &= ~0x80;
> A better way of writing &= ~0x80; is &= 0x7F
> > +               gpio->out_config |= value_bits;
> gpio->out_config = value ? 0x80 : 0x00;
> So, less confusing.


see HANDLING NIBBLES below


> > +               if (!(gpio_cntrl & 0x20))
> > +                       goto exit;
> Please insert a comment explaining what this bit is doing and why you're just
> exiting if it's not set. I don't understand one thing.


I have explained why in the driver source in the next submission attempt

 
> Maybe this would be better if you didn't use so many magic values, what about:
> #include <linux/bitops.h>
> #define FOO_FLAG BIT(3) /* This is a flag for foo */
> > +
> > +               gpio_cntrl &= ~0xF0;
> A better way to write &= ~F0 is to write &= 0x0F;
> If you don't #define the constants this way of negating numbers just get
> confusing.
> So this is OK:
>   foo &= ~FOO_FLAG;
>   foo |= set ? FOO_FLAG : 0;
> This is just hard to read:
>   foo &= ~0x55;
>   foo |= set ? 0x55 : 0;
> And is better off
>    foo &= 0xAA;
>    foo |= set ? 0x55 : 0;
> I prefer that you #define the registers but it's your pick.
> > +               gpio_cntrl |= 0xF0 & gpio->out_config;
> > +
> > +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG,
> gpio_cntrl);
> > +       } else {
> > +               u8 value_bits = value ? 0x08 : 0x00;
> Same here, delete this.
> > +               gpio->out_config &= ~0x08;
> &= 0xF7;
> or use some <linux/bitops.h> and #defines ...


see HANDLING NIBBLES below


> > +               gpio->out_config |= value_bits;
> Just
> gpio->out_config |= value ? 0x08 : 0x00;


done in next submission attempt


> > +               if (!(gpio_cntrl & 0x02))
> > +                       goto exit; 
> Same thing, explain that flag.


added explanation next submission attempt


> > +
> > +               gpio_cntrl &= ~0x0F;
> Just &= 0xF0;



see HANDLING NIBBLES below



> > +               gpio_cntrl |= 0x0F & gpio->out_config;
> > +
> > +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG,
> > + gpio_cntrl);
> 
> Further, if you're checking that flag just in order to avoid doing this write if it's
> not necessary, it's the wrong solution. The right solution is to implement
> regmap in the MFD driver so it quickly sees that the right value is already in the
> register and bounces off.



added explanation next submission attempt


[...]
> > +/*
> > + *  da9058_gpio_to_irq is an implementation of the GPIO Hook
> > + *  @to_irq: supporting non-static gpio_to_irq() mappings
> > + *  whose implementation may not sleep. This hook is called
> > + *  when setting up the threaded GPIO irq handler.
> > + */
> > +static int da9058_gpio_to_irq(struct gpio_chip *gc, u32 offset) {
> > +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> > +       struct da9058 *da9058 = gpio->da9058;
> > +
> > +       if (offset > 1)
> > +               return -EINVAL;
> > +
> > +       if (offset)
> > +               return da9058_to_virt_irq_num(da9058, DA9058_IRQ_EGPI1);
> > +       else
> > +               return da9058_to_virt_irq_num(da9058,
> > +DA9058_IRQ_EGPI0); }
> Lee Jones and Mark Brown discussed these virtual IRQ mapping functions
> recently, and I think the outcome was to patch irqdomain to do the work and
> not sprinkle these custom interfaces to fetch virtual IRQs all over the place.


The DA9058 driver does use the virtual IRQ domains


> > +static int da9058_gpio_set_debounce(struct gpio_chip *gc, unsigned offset,
> > +                               unsigned debounce) {
> > +       struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
> > +       struct da9058 *da9058 = gpio->da9058;
> > +       int ret;
> > +       unsigned int gpio_cntrl;
> > +
> > +       if (offset > 1)
> > +               return -EINVAL;
> > +
> > +       mutex_lock(&gpio->lock);
> > +
> > +       ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
> > +       if (ret)
> > +               goto exit;
> > +
> > +       if (offset) {
> > +               u8 debounce_bits = debounce ? 0x80 : 0x00;
> > +
> > +               gpio->inp_config &= ~0x80;
> > +               gpio->inp_config |= debounce_bits;
> > +
> > +               if (gpio_cntrl & 0x20)
> > +                       goto exit;
> > +
> > +               gpio_cntrl &= ~0xF0;
> > +               gpio_cntrl |= 0xF0 & gpio->inp_config;
> > +
> > +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG,
> gpio_cntrl);
> > +       } else {
> > +               u8 debounce_bits = debounce ? 0x08 : 0x00;
> > +
> > +               gpio->inp_config &= ~0x08;
> > +               gpio->inp_config |= debounce_bits;
> > +
> > +               if (gpio_cntrl & 0x02)
> > +                       goto exit;
> > +
> > +               gpio_cntrl &= ~0x0F;
> > +               gpio_cntrl |= 0x0F & gpio->inp_config;
> > +
> > +               ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG,
> gpio_cntrl);
> > +       }
> > +exit:
> > +       mutex_unlock(&gpio->lock);
> > +       if (ret)
> > +               dev_err(da9058->dev,
> > +                       "Failed to set GPIO%d bounce=%d error=%d\n",
> > +                       offset, debounce, ret);
> > +       return ret;
> > + }
> Apart from the same comments as above, debounce is actually pin control
> territory and not part of <linux/gpio.h>. Now this is a very small interface, but I
> still want you to consider using pin control for these portions.
> The good thing about doing it with pin control is that you can have it set up on
> boot using hogs and need to think anymor about the pin config business.


PIN CONTROL ???, are there any example drivers that I could/should base it on?


> The rest looks nice!
> Yours,
> Linus Walleij


Thanks for reviewing this DA9058 component driver, that just leaves the
contentious point:

HANDLING NIBBLES
================

The handling of nibbles within a byte follows the rule that constants
for the nibble NOT being operated on have those bits set to zero,
and thus only bits being operated on may be non-zero. Thus to set,
for example, the value 0xB into the MSH the operation is:
        byte &= ~0xF0
        byte |= 0xB0
it being obvious that it is the upper nibble being operated on.

It seems that you are following a different rule for handling nibbles,
and I can't find any standard for doing so in the kernel, so could
you send me your reference documents?

Tony Olech
