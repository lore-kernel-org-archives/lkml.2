Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2HEKu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 06:50:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56569 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2HEKuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 06:50:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120730074714.GC15245@avionic-0098.mockup.avionic-design.de>
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de>
	<CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com>
	<20120730074714.GC15245@avionic-0098.mockup.avionic-design.de>
Date: Sun, 5 Aug 2012 12:50:54 +0200
Message-ID: <CACRpkdbrdWw_HR91r72aB_S2+vxiaSBKHwW+Tsmi8pKk9VsgFg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 9:47 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Sun, Jul 29, 2012 at 07:13:57PM +0200, Linus Walleij wrote:
>> On Mon, Jul 23, 2012 at 1:59 PM, Thierry Reding
>> <thierry.reding@avionic-design.de> wrote:

>> > +- interrupt-controller: Marks the device as an interrupt controller.
>> > +- nr-gpios: The number of pins supported by the controller.
>>
>> These two last things look very generic, like something every GPIO
>> driver could want to expose.
>
> As Arnd mentioned, interrupt-controller is a generic property required
> by all interrupt controller nodes. Perhaps it shouldn't be listed in the
> DT binding for this driver.

After reading Rob's etc comments I think nr-gpios should be in this
binding, but interrupt-controller seems like it should go into
Documentation/devicetree/bindings/gpio/gpio.txt
can you take care of this?

(Anyone agains, beat me up...)

>> > +config GPIO_ADNP
>> > +       tristate "Avionic Design N-bit GPIO expander"
>> > +       depends on I2C && OF
>> > +       help
>> > +         This option enables support for N GPIOs found on Avionic Design
>> > +         I2C GPIO expanders. The register space will be extended by powers
>> > +         of two, so the controller will need to accomodate for that. For
>> > +         example: if a controller provides 48 pins, 6 registers will be
>> > +         enough to represent all pins, but the driver will assume a
>> > +         register layout for 64 pins (8 registers).
>> > +
>> > +config GPIO_ADNP_IRQ
>> > +       tristate "Interrupt controller support"
>> > +       depends on GPIO_ADNP
>> > +       help
>> > +         Say yes here to enable the Avionic Design N-bit GPIO expander to
>> > +         be used as an interrupt controller.
>>
>> First: please describe the usecase where the Avionic driver is used
>> without making use of the IRQ, and *why* it should be possible
>> to configure this out. E.g. is there a hardware which isn't using the
>> IRQ portions? If there is no non-irq usecase just drop this
>> config option.
>
> This expander is used in a number of Tegra-based boards and handles
> things like enabling or disabling power to a given IC but on other
> boards it is also used to handle interrupts from input devices or
> card-detect for example.
>
> The controller is synthesized in a CPLD, which is one of the reasons for
> the nr-gpios DT property. There is at least one platform that currently
> doesn't use the interrupt functionality. Mainly I allowed this to be
> configured out in order to reduce the number of interrupts required for
> a platform. Another reason was that at the time I first wrote this, IRQ
> domains hadn't been available, so the driver couldn't be built as a
> module if interrupt support was required. This also no longer applies.
>
> I'm actually fine either way, but I thought it'd be most flexible by
> keeping the IRQ support optional for the above reasons.

We're working on a goal of a "single zImage" (one unified ARM
kernel) which means your platform must be able to handle the
case where this is turned on anyway, so I would suggest you
drop the optional compile-time IRQ support, just make it
optional at runtime instead.

>> > +       u8 *irq_mask;
>> > +       u8 *irq_mask_cur;
>> > +       u8 *irq_level;
>> > +       u8 *irq_rise;
>> > +       u8 *irq_fall;
>> > +       u8 *irq_high;
>> > +       u8 *irq_low;
>>
>> Some or all of this looks like a regmap reimplementation, see below.
>
> Actually none of these represent actual registers, except for irq_mask
> and irq_mask_cur. They are used to emulate various IRQ trigger modes.

OK.

>> When I do this at several places in a driver I usually define
>> a macro like
>>
>> #define to_adnp(foo) container_of(foo, struct adnp, gpio)
>>
>> Used like so:
>>
>> struct adnp *adnp = to_adnp(chip);
>
> Yes, I usually do that as well. I guess this driver has been in the
> works in too many variants for too long. =)

OK expect it to be changed in v3 then...

>> > +       unsigned int reg = offset >> gpio->reg_shift;
>> > +       unsigned int pos = offset & 7;
>> > +       u8 value;
>> > +       int err;
>> > +
>> > +       mutex_lock(&gpio->i2c_lock);
>>
>> The point of taking this mutex here avoids me.
>> adnp_read() only performs a single transaction.
>
> I think that's a relic from an earlier version that used to access the
> PTR (Pin Tristate Register) as well. At the time I used to return 2 here
> to signify a tristated input, which was dependent on the contents of the
> PTR. Tristating an output is, I believe, better done using pinmux/
> pinctrl nowadays, so I took that code because the only platform where
> this was ever used will probably never be mainlined.

OK so will be gone in v3 I guess.

> On that note, provided there is special additional circuitry, the GPIO
> controller is able to detect tristate on an input. I'm not aware that
> the pinctrl subsystem provides for that functionality yet, right?

pinctrl is usually about *setting* things into tristate, but I'm all
for adding support for getting it as well. But that depends on
the generic pin configurations being adopted first (still most
controllers have their own way of doing pin config, so this
cannot be represented in a generic way).

>> > +       base = kzalloc(regs * 5, GFP_KERNEL);
>>
>> Why kzalloc()/kfree() when you can just use a
>>
>> static u8 base[N];
>>
>> where N is the max number of registers on any HW instead?
>
> As I explained above, the number of pins is configurable, so it'd be
> quite a waste to always assume a maximum of, say, 256 pins if the
> hardware actually only uses 8.

OK but atleast find a way to move this to the probe() function,
what happens if the debugfs file is browsed and you run out
of memory? Not nice, and you were using this to debug as
well...

>> Usually we define the struct gpio_chip as a static const and have
>> the state containter hold a static const struct gpio_chip *chip;
>> entry assigned to point to the static const at probe time.
>
> The problem with a static const is that you can no longer configure the
> number of GPIOs at runtime, which is sort of essential for this driver.

OK keep it like this...

>> All other GPIO drivers #ifdef their debugfs code, this probably
>> works fine too, but never saw it before.
>>
>> I'm ambivalent about this, I sort of like it because it avoids
>> #ifdefs and also makes sure the code is always compiled,
>> so if you like it like this, keep it.
>
> I've started to use this wherever possible because otherwise you have to
> build numerous configurations to ensure complete compile coverage. Then
> again this also has the drawback to potentially hide issues if you don't
> properly separate conditionalized code.

OK I'll adopt to liking this.

>> (...)
>> > +static void adnp_irq_update_mask(struct adnp *gpio)
>> > +{
>> > +       unsigned int regs = 1 << gpio->reg_shift;
>> > +       bool equal = true;
>> > +       unsigned int i;
>> > +
>> > +       for (i = 0; i < regs; i++) {
>> > +               if (gpio->irq_mask[i] != gpio->irq_mask_cur[i]) {
>> > +                       equal = false;
>> > +                       break;
>> > +               }
>> > +       }
>>
>> This is not looking good. It looks like you're reimplementing
>> parts of regmap.
>>
>> In that case, please use <linux/regmap.h> to cache registers
>> instead.
>>
>> But I'm not sure ...
>>
>> (...)
>> > +static void adnp_irq_bus_lock(struct irq_data *data)
>> > +{
>> > +       struct adnp *gpio = irq_data_get_irq_chip_data(data);
>> > +       unsigned int regs = 1 << gpio->reg_shift;
>> > +
>> > +       mutex_lock(&gpio->irq_lock);
>> > +       memcpy(gpio->irq_mask_cur, gpio->irq_mask, regs);
>> > +}
>> > +
>> > +static void adnp_irq_bus_unlock(struct irq_data *data)
>> > +{
>> > +       struct adnp *gpio = irq_data_get_irq_chip_data(data);
>> > +
>> > +       adnp_irq_update_mask(gpio);
>> > +       mutex_unlock(&gpio->irq_lock);
>> > +}
>>
>> Actually I'm not following why the IRQ mask registers are shadowed
>> at bus_lock and restored at bus_unlock().
>>
>> A comment describing why that's needed and how it works is
>> definately needed.
>
> I'm not sure that this is required anymore. IIRC I did copy this from
> some other driver at the time. This is probably supposed to be an
> optimization, but I think I can live without it.

If it's an optimization, please see if you can live without it and
add it back in using regmap if you want it later. regmap rocks...

>> > +       gpio->irq_mask = devm_kzalloc(chip->dev, regs * 7, GFP_KERNEL);
>> > +       if (!gpio->irq_mask)
>> > +               return -ENOMEM;
>> > +
>> > +       gpio->irq_mask_cur = gpio->irq_mask + (regs * 1);
>> > +       gpio->irq_level = gpio->irq_mask + (regs * 2);
>> > +       gpio->irq_rise = gpio->irq_mask + (regs * 3);
>> > +       gpio->irq_fall = gpio->irq_mask + (regs * 4);
>> > +       gpio->irq_high = gpio->irq_mask + (regs * 5);
>> > +       gpio->irq_low = gpio->irq_mask + (regs * 6);
>>
>> I'm not following this regs * 1, regs * 2 ... regs *7 stuff. What are you doing
>> here? Explain with some comment atleast.
>
> Basically I need at least irq_level, irq_rise, irq_fall, irq_high and
> irq_low to keep track of the current level and trigger modes for each
> interrupt. Instead of allocating small chunks for each of these I
> allocate one chunk and just make the others point into that.

Maybe you said this would go away in this case not comments
of course.

But I wasn't getting the multiplication part. I understand the
allocation, 7 registers time the number of registers (hm, there
is something about the naming too....)

You're storing the things in such an awkward way: all
current masks for all registers sets, then all levels for
all register etc.

Instead could you store all the flags for *one* instance
then the next set of registers etc.

>> > +       for (i = 0; i < regs; i++) {
>> > +               err = adnp_read(gpio, GPIO_PLR(gpio) + i, &gpio->irq_level[i]);
>> > +               if (err < 0)
>> > +                       return err;
>> > +       }
>>
>> Looks like regmap reimplementation.
>
> This is used to obtain the initial pin levels, which in turn is required
> to check for rising and falling edges.

Yeah sorry I misread this code.

>> > +       err = request_threaded_irq(gpio->client->irq, NULL, adnp_irq,
>> > +                                  IRQF_TRIGGER_RISING | IRQF_ONESHOT,
>> > +                                  dev_name(chip->dev), gpio);
>>
>> Since you're using devm_* above use it here too:
>> devm_request_threaded_irq().
>> > (...)
>> > +static void adnp_irq_teardown(struct adnp *gpio)
>> > +{
>> > +       unsigned int irq, i;
>> > +
>> > +       free_irq(gpio->client->irq, gpio);
>>
>> If you're using devm to grab the IRQ this is not needed.
>
> I don't think that'll work. In this case the interrupt needs to be freed
> before cleaning up, because otherwise the interrupt handler may still be
> run after the IRQ domain has already been removed.

Hm. Paging Grant on this one.

Grant: can't we add devm_* managed IRQ domains so this
ordering etc goes into the core as well?

>> > +               return -EPROBE_DEFER;
>>
>> Why would you defer in this case? If the IRQ controller appear later
>> than the GPIO driver?
>
> Yes. In particular when using DT it can happen that the parent interrupt
> controller is probed later than this.

OK.

>> > +       if (IS_ENABLED(CONFIG_GPIO_ADNP_IRQ)) {
>> > +               err = adnp_irq_setup(gpio);
>> > +               if (err < 0)
>> > +                       goto teardown;
>> > +       }
>>
>> And that activates the question why this should be conditional,
>> please elaborate.
>
> I think I've answered this before.

Yep, and I suggest to make this 100% runtime, not compile-time.

> Thanks for reviewing. I'll fixup the problems you've pointed out and
> will have to retest.

Thanks, waiting for v3.

Yours,
Linus Walleij
