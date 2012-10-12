Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab2JLUxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:53:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39586 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab2JLUxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:53:14 -0400
MIME-Version: 1.0
In-Reply-To: <1349720405.23690.45.camel@trivette>
References: <1348620130-25987-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<CACRpkdaaD6HY2o-NNBRZYCXm97Dts7Njzz13Zj7m2ZycV-Ar5g@mail.gmail.com>
	<1349720405.23690.45.camel@trivette>
Date: Fri, 12 Oct 2012 22:53:13 +0200
Message-ID: <CACRpkdbbungMiZ74o=-CfRoLQj127CaWaYr7adKKSquFd=x5qg@mail.gmail.com>
Subject: Re: [PATCH] gpio: add TS-5500 DIO headers support
From: Linus Walleij <linus.walleij@linaro.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 8:20 PM, Vivien Didelot
<vivien.didelot@savoirfairelinux.com> wrote:
> On Mon, 2012-10-08 at 12:38 +0200, Linus Walleij wrote:
>> On Wed, Sep 26, 2012 at 2:42 AM, Vivien Didelot

>> <vivien.didelot@savoirfairelinux.com> wrote:
>> Part of me dislike that you create one single driver for all
>> three blocks instead of abstracting the driver to handle one
>> block, and register one platform device each, 2-3 times.
>> But given that this is very tied to this one chip it could be the
>> simplest and most readable design so OK...
>
> I agree with you. I thought about that too and it will make it easier to
> support other similar platform DIO headers (such as the ones on the
> TS-5600). But I'm not sure about the implementation, I'm thinking about
> an array of struct ts5500_dio per block, described in a
> MODULE_DEVICE_TABLE. Something like:
>
>         static struct platform_device_id ts5500_device_ids[] = {
>                 { "ts5500-dio1", (kernel_ulong_t) ts5500_dio1 },
>                 { "ts5500-dio2", (kernel_ulong_t) ts5500_dio2 },
>                 { "ts5500-lcd", (kernel_ulong_t) ts5500_lcd },
>                 { }
>         };
>         MODULE_DEVICE_TABLE(platform, ts5500_device_ids);
>
> What do you think?

It basically looks pretty nice, but can't tell until I see the entire
code...

>> > +static const char * const ts5500_pinout[38] = {
>> > +       /* DIO1 Header (offset 0-13) */
>> > +       [0]  = "DIO1_0",  /* pin 1  */
>> > +       [1]  = "DIO1_1",  /* pin 3  */
>>
>> Pins pins pins. The pinctrl subsystem has a framework for keeping track of
>> pins and giving them names, which is another reason to convert this to a
>> pinctrl driver.
>>
>> Please consult Documentation/pinctrl.txt
>
> Sounds better then, thanks.

Well that may also be a pretty big step if you just want to mux
one bank of GPIO. I'm a bit ambivalent. But if you want to tie
pin and gpio information together and name all pins, pinctrl
is what should suit you best.

In the GPIO world, things are opaque "gpios" not really pins.

>> > +#ifndef NO_IRQ
>> > +#define NO_IRQ -1
>> > +#endif
>>
>> No. We have very solidly decided that NO_IRQ == 0.
>
> Ho ok, I didn't know that. Many implementations still use -1.

They are bad examples not to be followed.
http://lwn.net/Articles/470820/

>> > +/*
>> > + * This structure is used to describe capabilities of DIO lines,
>> > + * such as available directions, and mapped IRQ (if any).
>> > + */
>> > +struct ts5500_dio {
>> > +       const unsigned long value_addr;
>> > +       const int value_bit;
>> > +       const unsigned long control_addr;
>> > +       const int control_bit;
>>
>> All the above seem like they should be u8 rather than
>> const unsigned or const int.
>
> I used these types here to match {set,clear}_bit function prototypes.
> But I can use const u8 for sure.

Hm hm yes that is true. These functions only work on longs,
as they access the entire word from memory.

If you access these as u8, use direct operators rather than
set/clear_bit & friends.

No big deal really. Do it as it works best for you.

>> > +       const int irq;
>>
>> IRQ numbers shall not be hard-coded into drivers like
>> this, they shall be passed in as resources from the outside
>> just like you pass in other platform data.
>
> Just curious, what's the point of doing this, as IRQ lines are wired?

It's a design pattern that only the platform knows about the IRQs
and they should be retrieved from there.

Resources tied to platform device is one way to get them, if they are
hardcoded.

Device Tree is another way on MIPS e.g.

And ACPI etc is used in some x86's I think.

Just that this kind of stuff which basically pertains to how the interrupt
controller is wired rather than this hardware block per se, means it
should be external.

>> > +       const int direction;
>>
>> Use a bool out for this last thing?
>
> Or two bool in and out instead?

It if can be in and out at the same time, sure.
I'm probably just not getting it.

>> > +};
>> > +
>> > +static const struct ts5500_dio ts5500_dios[] = {
>> > +       /* DIO1 Header (offset 0-13) */
>> > +       [0]  = { 0x7b, 0, 0x7a, 0,  NO_IRQ, IN | OUT },
>>
>> Use C99 syntax and skip the [0] index (etc).
>
> I used this syntax because it is much more clearer to figure out what
> Linux offset corresponds to the physical DIO, but well...

OK you can keep the offset if you like no big deal.

>> static const struct ts5500_dio ts5500_dios[] = {
>>     {
>>         .value_addr = 0x7b,
>>         .value_bit = 0,
>>         .control_addr = 0x7a,
>>         .control_bit = 0,
>>         .direction = OUT,
>>     },
>>     {
>>         .value_addr = 0x7b
>> ....
>>
>> Note absence of NO_IRQ - it's implicit zero in static
>> allocations.
>
> This will make the code longer, but this is more explicit.
> I should maybe group addr/bit pairs in a struct...

I really prefer if you do this because it makes the code way more
maintainable, because else, if you add a member to the struct
in the middle of the others, guess what happens.

>> > +static bool lcd_dio;
>> > +static bool lcd_irq;
>> > +static bool dio1_irq;
>> > +static bool dio2_irq;
>>
>> Document what these are for with some /* comments */
>>
>> But overall this has a singleton problem, this driver is not reentrant.
>> Usually that doesn't matter on a practical system, but we sure
>> prefer if you create a state container:
>>
>> struct ts5500dio_state {
>>   bool lcd_dio;
>>   bool lcd_irq;
>>   bool dio1_irq;
>>   bool dio2_irq;
>> }
>>
>> In .probe:
>>
>> struct ts5500dio_state *my_state = devm_kzalloc(&dev, sizeof(struct
>> foo_state), GFP_KERNEL);
>>
>> my_state->lcd_dio = ...
>>
>> etc.
>
> I agree with you about the singleton problem, but the issue here is that
> gpio_chip_add() can be called before alloc functions exist, if the
> module is built-in.

This sounds plain wrong, a module_platform_driver() is called at the
device init level and memory allocation is available.

> As an usage example, here's my current
> implementation of the TS-5500 platform code:
>
> https://raw.github.com/v0n/linux-ts5500/ts5500/arch/x86/platform/ts5500/ts5500.c
>
> With this module built-in with a kzalloc call, it totally crashes on
> boot.

Wicked, but probably an unrelated problem.
Please find out if it's really kzalloc() that fails and in that case why.

> Would it be the same problem with the pinctrl subsystem? Or is
> there any other workaround? Maybe my platform code should try using a
> later init call, instead of device_initcall().

You should be able to allocate memory at very early init calls,
this is done throughout the kernel and should not be a limitation,
you need to figure out why you can't allocate memory instead
of coding drivers that look odd and awkward just because you try
to avoid allocating memory.

>> > +       __set_bit(bit, &val);
>>
>> Do you have to use the __ variants? Isn't just set_bit() working?
>> (Just checking...)
>
> I used __ variants here because I didn't require it to be atomic, as I
> protect the calls myself with a spinlock.

OK true, that's fine.

And this is one of the calls that won't work if the thing you operate
on isn't a long, so I get this now.

The alternative is to do something explicit like:

#include <linux/bitops.h>

val |= BIT(bit);

which will work just fine also with u8 :-)

>> > +static inline void io_clear_bit(int bit, unsigned long addr)
>> > +{
>> > +       unsigned long val = inb(addr);
>> > +       __clear_bit(bit, &val);

Or

val &= ~BIT(bit);

in this case.

>> > +       /* Some lines cannot be configured as input */
>> > +       if (!(line.direction & IN))
>> > +               return -ENXIO;
>>
>> Why are you using that return code? (Probably OK, just want
>> a rationale...)
>
> I took this return value from another driver. Is there a better one to
> use here?

Nah it's fine as long as there is some rationale.

>> (...)
>> > +static int ts5500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
>> > +{
>> > +       const struct ts5500_dio line = ts5500_dios[offset];
>> > +
>> > +       /* Only a few lines are IRQ-capable */
>> > +       if (line.irq != NO_IRQ)
>> > +               return line.irq;
>> > +
>> > +       /* This allows to bridge a line with the IRQ line of the same header */
>> > +       if (dio1_irq && offset < 13)
>> > +               return ts5500_dios[13].irq;
>> > +       if (dio2_irq && offset > 13 && offset < 26)
>> > +               return ts5500_dios[26].irq;
>> > +       if (lcd_irq && offset > 26 && offset < 37)
>> > +               return ts5500_dios[37].irq;
>>
>> Don't do this. Please use irqdomain for converting physical
>> IRQ numbers to Linux IRQ numbers. (Consult other GPIO
>> drivers for examples.)
>>
>> These magic constants (13, 26, 37) are scary too.
>>
>> You should not try to handle each block as a single
>> IRQ, instead instatiate a struct irq_chip in the driver
>> and let that use irqdomain do demux the IRQ and
>> register a range of Linux IRQ numbers, on per pin,
>> so the GPIO driver will handle the physical IRQ line,
>> then dispatch to a fan-out handler, so drivers that need
>> IRQs from the GPIO chip just register IRQ handlers like
>> anyone else.
>
> Do you mean that I should not return the same IRQ line for the same
> header, but virtual ones? I'll try to find a good example for that.

Basically Linux IRQs (also sometimes called virtual IRQs) are
separate from the physical IRQ numbers of the system.

i.e. what you see in /proc/interrupts has no relation to the physical
interrupt lines.

Keep in mind that we're trying to disallow IRQ 0 altogether and some
platforms use that physical line for stuff.

So we need to use irqdomain to just grab an IRQ number to reference
the physical line. And we often do that for the IRQ controller.

The fact that sometimes the physical line number and the Linux
IRQ number correspond is just misleading...

In this case, since you have individual IRQs you want to check
for different lines, register something with e.g.
irq_domain_add_simple() to handle all these lines as IRQs.

It's a bit complex but pays off: all of a sudden you get statistics
in /proc/interrupts for exactly which GPIO IRQs were fired,
for example, and they get names if you provide that.

Look at the other GPIO drivers for many good examples of
how to do this. gpio-em.c is one example.

Yours,
Linus Walleij
