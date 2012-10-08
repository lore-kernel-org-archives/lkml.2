Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2JHSUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 14:20:13 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:40108 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab2JHSUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 14:20:10 -0400
Message-ID: <1349720405.23690.45.camel@trivette>
Subject: Re: [PATCH] gpio: add TS-5500 DIO headers support
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Date: Mon, 08 Oct 2012 14:20:05 -0400
In-Reply-To: <CACRpkdaaD6HY2o-NNBRZYCXm97Dts7Njzz13Zj7m2ZycV-Ar5g@mail.gmail.com>
References: <1348620130-25987-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <CACRpkdaaD6HY2o-NNBRZYCXm97Dts7Njzz13Zj7m2ZycV-Ar5g@mail.gmail.com>
Organization: Savoir-faire Linux Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, 2012-10-08 at 12:38 +0200, Linus Walleij wrote:
> On Wed, Sep 26, 2012 at 2:42 AM, Vivien Didelot
> <vivien.didelot@savoirfairelinux.com> wrote:
> 
> > The Technologic Systems TS-5500 platform provides 3 digital I/O headers:
> > DIO1, DIO2, and the LCD port, that may be used as a DIO header.
> >
> > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > Signed-off-by: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
> (...)
> > + * The TS-5500 platform has 38 Digital Input/Output lines (DIO), exposed by 3
> > + * DIO headers: DIO1, DIO2, and the LCD port which may be used as a DIO header.
> 
> Header? Is that like a socket or something?

Digital Input/Output header is the term given in the platform datasheet
to describe a block. I can use "block" if it's more explicit.

> 
> The ability to swith the LCD port into DIO is a pin control property
> and if this gets implemented the driver should technically be
> in drivers/pinctrl. (It can implement GPIO too, no problem.)
> 
> Part of me dislike that you create one single driver for all
> three blocks instead of abstracting the driver to handle one
> block, and register one platform device each, 2-3 times.
> But given that this is very tied to this one chip it could be the
> simplest and most readable design so OK...

I agree with you. I thought about that too and it will make it easier to
support other similar platform DIO headers (such as the ones on the
TS-5600). But I'm not sure about the implementation, I'm thinking about
an array of struct ts5500_dio per block, described in a
MODULE_DEVICE_TABLE. Something like:

	static struct platform_device_id ts5500_device_ids[] = { 
		{ "ts5500-dio1", (kernel_ulong_t) ts5500_dio1 },
		{ "ts5500-dio2", (kernel_ulong_t) ts5500_dio2 },
		{ "ts5500-lcd", (kernel_ulong_t) ts5500_lcd },
		{ }
	};
	MODULE_DEVICE_TABLE(platform, ts5500_device_ids);

What do you think?

> 
> > + * The datasheet is available at:
> > + * http://embeddedx86.com/documentation/ts-5500-manual.pdf.
> 
> Drop the period after the URL. It makes it hard to browse...
> 
> > +/*
> > + * This array describes the names of the DIO lines, but also the mapping between
> > + * the datasheet, and corresponding offsets exposed by the driver.
> > + */
> > +static const char * const ts5500_pinout[38] = {
> > +       /* DIO1 Header (offset 0-13) */
> > +       [0]  = "DIO1_0",  /* pin 1  */
> > +       [1]  = "DIO1_1",  /* pin 3  */
> 
> Pins pins pins. The pinctrl subsystem has a framework for keeping track of
> pins and giving them names, which is another reason to convert this to a
> pinctrl driver.
> 
> Please consult Documentation/pinctrl.txt

Sounds better then, thanks.

> 
> > +#define IN     (1 << 0)
> > +#define OUT    (1 << 1)
> 
> Why not use a bool named "out" then it's out if true
> else input.

Because there are 3 possible cases: input-only, input-output and
output-only. Would it be better to have 2 booleans, "in" and "out"?

> 
> > +#ifndef NO_IRQ
> > +#define NO_IRQ -1
> > +#endif
> 
> No. We have very solidly decided that NO_IRQ == 0.

Ho ok, I didn't know that. Many implementations still use -1.
> 
> > +/*
> > + * This structure is used to describe capabilities of DIO lines,
> > + * such as available directions, and mapped IRQ (if any).
> > + */
> > +struct ts5500_dio {
> > +       const unsigned long value_addr;
> > +       const int value_bit;
> > +       const unsigned long control_addr;
> > +       const int control_bit;
> 
> All the above seem like they should be u8 rather than
> const unsigned or const int.

I used these types here to match {set,clear}_bit function prototypes.
But I can use const u8 for sure.

> 
> > +       const int irq;
> 
> IRQ numbers shall not be hard-coded into drivers like
> this, they shall be passed in as resources from the outside
> just like you pass in other platform data.

Just curious, what's the point of doing this, as IRQ lines are wired?

> 
> > +       const int direction;
> 
> Use a bool out for this last thing?

Or two bool in and out instead?

> 
> > +};
> > +
> > +static const struct ts5500_dio ts5500_dios[] = {
> > +       /* DIO1 Header (offset 0-13) */
> > +       [0]  = { 0x7b, 0, 0x7a, 0,  NO_IRQ, IN | OUT },
> 
> Use C99 syntax and skip the [0] index (etc).

I used this syntax because it is much more clearer to figure out what
Linux offset corresponds to the physical DIO, but well...

> 
> static const struct ts5500_dio ts5500_dios[] = {
>     {
>         .value_addr = 0x7b,
>         .value_bit = 0,
>         .control_addr = 0x7a,
>         .control_bit = 0,
>         .direction = OUT,
>     },
>     {
>         .value_addr = 0x7b
> ....
> 
> Note absence of NO_IRQ - it's implicit zero in static
> allocations.

This will make the code longer, but this is more explicit.
I should maybe group addr/bit pairs in a struct...

> 
> > +static bool lcd_dio;
> > +static bool lcd_irq;
> > +static bool dio1_irq;
> > +static bool dio2_irq;
> 
> Document what these are for with some /* comments */
> 
> But overall this has a singleton problem, this driver is not reentrant.
> Usually that doesn't matter on a practical system, but we sure
> prefer if you create a state container:
> 
> struct ts5500dio_state {
>   bool lcd_dio;
>   bool lcd_irq;
>   bool dio1_irq;
>   bool dio2_irq;
> }
> 
> In .probe:
> 
> struct ts5500dio_state *my_state = devm_kzalloc(&dev, sizeof(struct
> foo_state), GFP_KERNEL);
> 
> my_state->lcd_dio = ...
> 
> etc.

I agree with you about the singleton problem, but the issue here is that
gpio_chip_add() can be called before alloc functions exist, if the
module is built-in. As an usage example, here's my current
implementation of the TS-5500 platform code:

https://raw.github.com/v0n/linux-ts5500/ts5500/arch/x86/platform/ts5500/ts5500.c

With this module built-in with a kzalloc call, it totally crashes on
boot. Would it be the same problem with the pinctrl subsystem? Or is
there any other workaround? Maybe my platform code should try using a
later init call, instead of device_initcall().

> 
> > +static DEFINE_SPINLOCK(lock);
> 
> This would also go into the state container.
> 
> > +static inline void io_set_bit(int bit, unsigned long addr)
> 
> io_set_bit() is too generic, use something like ts5500dio_set_bit()
> 
> > +{
> > +       unsigned long val = inb(addr);
> 
> I'm not familiar with inb() and friends, I guess it's IO-space
> accessors so I just buy into it...
> 
> > +       __set_bit(bit, &val);
> 
> Do you have to use the __ variants? Isn't just set_bit() working?
> (Just checking...)

I used __ variants here because I didn't require it to be atomic, as I
protect the calls myself with a spinlock.

> 
> > +       outb(val, addr);
> > +}
> > +
> > +static inline void io_clear_bit(int bit, unsigned long addr)
> > +{
> > +       unsigned long val = inb(addr);
> > +       __clear_bit(bit, &val);
> > +       outb(val, addr);
> > +}
> 
> Same comments.
> 
> > +static int ts5500_gpio_input(struct gpio_chip *chip, unsigned offset)
> > +{
> > +       unsigned long flags;
> > +       const struct ts5500_dio line = ts5500_dios[offset];
> > +
> > +       /* Some lines cannot be configured as input */
> > +       if (!(line.direction & IN))
> > +               return -ENXIO;
> 
> Why are you using that return code? (Probably OK, just want
> a rationale...)

I took this return value from another driver. Is there a better one to
use here?

> 
> (...)
> > +static int ts5500_gpio_get(struct gpio_chip *chip, unsigned offset)
> > +{
> > +       const struct ts5500_dio line = ts5500_dios[offset];
> > +
> > +       return (inb(line.value_addr) >> line.value_bit) & 1;
> 
> Use this idiom:
> 
> return !!(inb(line.value_addr) & line.value_bit);
> 
> It's quite a common way to clamp a numeral to a bool int.

Ok.

> 
> (...)
> > +static int ts5500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> > +{
> > +       const struct ts5500_dio line = ts5500_dios[offset];
> > +
> > +       /* Only a few lines are IRQ-capable */
> > +       if (line.irq != NO_IRQ)
> > +               return line.irq;
> > +
> > +       /* This allows to bridge a line with the IRQ line of the same header */
> > +       if (dio1_irq && offset < 13)
> > +               return ts5500_dios[13].irq;
> > +       if (dio2_irq && offset > 13 && offset < 26)
> > +               return ts5500_dios[26].irq;
> > +       if (lcd_irq && offset > 26 && offset < 37)
> > +               return ts5500_dios[37].irq;
> 
> Don't do this. Please use irqdomain for converting physical
> IRQ numbers to Linux IRQ numbers. (Consult other GPIO
> drivers for examples.)
> 
> These magic constants (13, 26, 37) are scary too.
> 
> You should not try to handle each block as a single
> IRQ, instead instatiate a struct irq_chip in the driver
> and let that use irqdomain do demux the IRQ and
> register a range of Linux IRQ numbers, on per pin,
> so the GPIO driver will handle the physical IRQ line,
> then dispatch to a fan-out handler, so drivers that need
> IRQs from the GPIO chip just register IRQ handlers like
> anyone else.

Do you mean that I should not return the same IRQ line for the same
header, but virtual ones? I'll try to find a good example for that.

> 
> (...)
> > +static int __devinit ts5500_gpio_probe(struct platform_device *pdev)
> > +{
> > +       int ret;
> > +       unsigned long flags;
> > +       struct ts5500_gpio_platform_data *pdata = pdev->dev.platform_data;
> 
> This is where you should allocate you state container dynamically.
> 
> (...)
> > +       /* Enable IRQ generation */
> > +       spin_lock_irqsave(&lock, flags);
> > +       io_set_bit(7, 0x7a); /* DIO1_13 on IRQ7 */
> > +       io_set_bit(7, 0x7d); /* DIO2_13 on IRQ6 */
> > +       if (lcd_dio) {
> > +               io_clear_bit(4, 0x7d); /* LCD Header usage as DIO */
> > +               io_set_bit(6, 0x7d); /* LCD_RS on IRQ1 */
> > +       }
> 
> This is pincontrol ... but well. It's very very little after all.
> 
> > +/**
> > + * struct ts5500_gpio_platform_data - TS-5500 GPIO configuration
> > + * @base:      The GPIO base number to use.
> > + * @lcd_dio:   Use the LCD port as 11 additional digital I/O lines.
> > + * @lcd_irq:   Return IRQ1 for every line of LCD DIO header.
> > + * @dio1_irq:  Return IRQ7 for every line of DIO1 header.
> > + * @dio2_irq:  Return IRQ6 for every line of DIO2 header.
> > + */
> > +struct ts5500_gpio_platform_data {
> > +       int base;
> > +       bool lcd_dio;
> > +       bool lcd_irq;
> > +       bool dio1_irq;
> > +       bool dio2_irq;
> > +};
> 
> So I don't like how this hardcodes IRQ 1, 7, 6 to be used for this
> purpose, it's better to pass that in as resources from the platform.
> 
> Yours,
> Linus Walleij

Thanks for your comments,
Vivien


