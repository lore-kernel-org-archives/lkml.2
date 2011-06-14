Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1FNLdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:33:22 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65450 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab1FNLdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:33:19 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=r=N5OwfsVLRuBsNRSpv91pTgeKA@mail.gmail.com>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTi=r=N5OwfsVLRuBsNRSpv91pTgeKA@mail.gmail.com>
Date: Tue, 14 Jun 2011 13:33:18 +0200
Message-ID: <BANLkTi=sXrqLErXiLn4ry-kjS_-uLEBrhg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pinmux subsystem v3
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 9:57 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

> (...)
> To sum up, it looks like the conceptual model is thus:
>
> - A pinmux driver enumerates and registers all the pins that it has
> - Setup code and/or driver code requests blocks of pins (functions)
> when it needs them
> - If all the pins are available, it gets them, otherwise it the allocation fails
> - pins cannot be claimed by more than one device
> - it is up to the pinmux driver to actually program the device and
> determine whether or not the requested pin mode is actually
> configurable.  Even if pins are available, it may be that other
> constraints prevent it from actually being programmed
>
> Ultimately, it still is up to the board designer and board port
> engineer to ensure that the system can actually provide the requested
> pin configuration.
>
> My understanding is that in the majority of cases pinmux will probably
> want/need to be setup and machine_init time, and device drivers won't
> really know or care about pinmux; it will already be set up for them
> when the driver is probed.  Any power management issues will also be
> handled by platform/soc code when the dependent devices are in PM
> states.
>
> How does that line up with your conceptual model of pinmux?

100% I'd say, so far.

Devil is in the details, below.

>> - Converted the pin lookup from a static array into a radix tree,
>>  I agreed with Grant Likely to try to avoid any static allocation
>>  (which is crap for device tree stuff) so I just rewrote this
>>  to be dynamic, just like irq number descriptors. The
>>  platform-wide definition of number of pins goes away - this is
>>  now just the sum total of the pins registered to the subsystem.
>
> You should consider still using a bitmap for tracking which pins are
> actually available, similar to how irqs are tracked.

Well that is not so simple, because that bitmap needs to have
a size. And that means the stuff we're tracking is not really
dynamic, but either static or a hybrid (roofed bitmap). Let's
recap:

- Either you have a defined number of IRQs (NR_IRQS) defined
  system-wide and then allocate a fixed array of descriptors like
  that: struct irq_desc irq_desc[NR_IRQS] (or for GPIOs:
  static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];)

- Or you dynamically allocate descriptors such as is done with
  sparse IRQs.

The first case is the same way that gpiolib depends on the global
ARCH_NR_GPIOS is used. It inevitably involves roofing the
number of IRQs/GPIOs on systems where they come and go.
That is static allocation, and that is what we wanted to get away
from.

Sparse IRQs also use a bitmap though. But it is not dynamic
at all, it's either static or an assumption-based hybrid.

To use a bitmap you need to know how many IRQs you have, so
you know how large bitmap you need to allocate.

c.f. kernel/irq/irqdesc.c:
static DECLARE_BITMAP(allocated_irqs, IRQ_BITMAP_BITS);

And IRQ_BITMAP_BITS comes from:
kernel/irq/internals.h;
#ifdef CONFIG_SPARSE_IRQ
# define IRQ_BITMAP_BITS        (NR_IRQS + 8196)
#else
# define IRQ_BITMAP_BITS        NR_IRQS
#endif

(Needless to say this assumes you never add more than
8196 irqs on top of the fixed number of IRQs)

So to use this I need to go back to a model where the system
knows how many pins there are anyway or just assume
something like "never more than 8192" and hardcode it
like for sparse IRQs above, then that consumes
8192/32 = 256 words of memory.

> A bool in each
> pinmux structure is a little wasteful,

If I instead have it all-dynamic, and say the boolean field
even consumes 32bits in the desc (which we need anyway)
you need to use more than 256 pins in your system before
this hits you, 32 bits per pin. (Beware I have no clue how
booleans actually are stored in structs.)

It's not *that* bad, especially not compared to starting
to compile in every other driver to get a single booting
binary for several ARM systems, then this is peanuts ...
(OK maybe a crap argument I dunno. It feels to me like
footprint issues are out of fashion on recent ARM systems.)

> and requires a lock to be held
> for a long time while checking all the structures.

I don't get this part. The lock is held when looking up
the desc in the radix tree, just like in the IRQ subsystem
and the radix lookup is fast enough to be in the fastpath.
The only code that actually traverse the entire tree is in
debugfs code or error path, surely that must be an acceptable
traversal?

>> +The driver will for all calls be provided an offset pin number into its own
>> +pin range. If you have 2 chips with 8x8 pins, the first chips pins will have
>> +numbers 0 thru 63 and the second one pins 64 thru 127, but the driver for the
>> +second chip will be passed numbers in the range 0 thru 63 anyway, base offset
>> +subtracted.
>
> Wait, do you really want a global numberspace here?  I'd rather see
> callers have a direct reference to the pinmux controller instance, and
> use local pin numbers.

The pinmux functions that are requested by machine, bus or device
indeed work that way.

> Given the choice, I would not go with global
> numbers for GPIOs again, and I'm not so big a fan of them for irqs
> either.

Two reasons for a global numberspace:

1. We want to handle other stuff that relates to pincontrol in the
  pinctrl API, such as biasing, driver levels, load capacitance and
  whatever the funny pin engineers come up with. Not all pins
  are simultaneously muxable, many are both controlled in
  this way AND muxable, at the same time. Biasing etc
  needs to happen at pin level rather than group/function level.
  muxing and biasing may interact in driver level, BTW.

2. The second reason it is even there is to coexist with the GPIO
  subsystem, since many, many systems need to mux in GPIO
  on single pins today (ux500, OMAP, i.MX31 OTOMH).

Some assorted blather follows:

That is why requesting a singe pin for GPIO with
int pinmux_request_gpio(int pin, unsigned gpio);
that reserved the pin and goes all the way to an (optional)
callback to the driver in
int (*gpio_request_enable) (struct pinmux_dev *pmxdev, unsigned offset);
that asks the hardware to mux in that singe pin as GPIO.

The mentioned hardware indeed has per-pin muxing granularity
BTW, so this will be useful and quick for these usecases.

The alternative is to first define a function for every singular GPIO pin,
and then mux in that function for each pin in the GPIO driver.
This does not solve the biasing etc problems though.

If we were discussing footprint issues before defining a function for
each pin in the system dwarfs that :-)

If instead all GPIOs are requested from the GPIO driver in
ranges, say "these 32 as GPIO please" the problem goes away,
and you don't need to implement your stuff using these function at
all. However I feel it is a bit thick to require that, and in practical
cases I've seen you actually do want to get at the single pins.
(IIRC Sascha confirmed this assumption for i.MX)

>> +const char *foo_get_fname(struct pinmux_dev *pmxdev, unsigned selector)
>> +{
>> +       if (selector >= ARRAY_SIZE(myfuncs))
>> +               return NULL;
>> +       return myfuncs[selector].name;
>> +}
> Is there a method to lookup the function id from the name?  Going from
> name to number seems more useful to me than going the other way
> around.

I don't quite get it, this is based on how the regulator framework
asks it's drivers to enumerate voltages, the name is entirely optional,
more to get visibility of names. Enumerators is what the framework
is using and requiring from the drivers.

>> +struct pinmux_ops ops = {
>> +       .list_functions = foo_list,
>> +       .get_function_name = foo_get_fname,
>> +       .get_function_pins = foo_get_pins,
>> +       .enable = foo_enable,
>> +       .disable = foo_disable,
>
> Mixing callbacks with data here.  Not bad, but maybe a little odd.

? The above are all functions ?

>> +The beauty of the pinmux subsystem is that since it keeps track of all
>> +pins and who is using them, it will already have denied an impossible
>> +request like that, so the driver does not need to worry about such
>> +things - when it gets a selector passed in, the pinmux subsystem makes
>> +sure no other device or GPIO assignment is already using the selected
>> +pins.
>
> Sometimes that isn't enough.  Some functions may not actually collide
> on the pins they select, but the modes will be mutually exclusive
> anyway.  There needs to be runtime checking that the mode can actually
> be programmed when it is enabled (of course, it may just be that for
> *this* example it doesn't need to worry about it, in which case my
> comment is moot).

Yeah the driver will have to take care of that and return some
-EBUSY or so.

>> +#include <linux/pinctrl/machine.h>
>> +
>> +static struct pinmux_map pmx_mapping[] = {
>> +       {
>> +               .function = "spi0-1",
>> +               .dev_name = "foo-spi.0",
>> +       },
>> +       {
>> +               .function = "i2c0",
>> +               .dev_name = "foo-i2c.0",
>> +       },
>> +};
>
> I'm wary about this approach, even though I know it is already used by
> regulator and clk mappings.  The reason I'm wary is that matching
> devices by name becomes tricky for anything that isn't statically
> created by the kernel, such as when enumerating from the device tree,
> because it assumes that the device name is definitively known.
> Specifically, Linux's preferred name for a device is not guaranteed to
> be available from the device tree.  We very purposefully do not encode
> Linux kernel implementation details into the kernel so that
> implementation detail changes don't force dt changes.
>
> /me goes and thinks about the problem some more...
>
> Okay, I think I've got a new approach for the DT domain so that Linux
> gets the device names it wants for matching to clocks, regulators and
> this stuff.  I'm going to go and code it up now.  I still don't
> personally like matching devices by name, but by no measure is it a
> show stopper for me.

We can enforce it for DT-based pinmuxing and live with this
name matcing for existing boardfiles I assume?

>> +This get/enable/disable/put sequence can just as well be handled by bus drivers
>> +if you don't want each and every driver to handle it and you know the
>> +arrangement on your bus.
>
> I would *strongly* recommend against individual device drivers
> accessing the pinmux api.  This is system level configuration code,
> and should be handled at the system level.

As explained by Russell in earlier mails (and in my own experience
too) there exist systems that need to alter muxing at runtime, say
mux this thing out, mux that thing in. So it was a design
requirement.

Some devices will need to demux in response to runtime_pm
hooks though. And the other functions of pincontrol, like
biasing, definately need to happen in rutime on request from
a single device.

But I can try to write the doc so that it emphasize doing this in
machine/system/board code or wherever you first have an
opportunity to ask for something with your struct device *
as an argument, OK?

It could also be in the system-specific callbacks to board
code, of course.

Another argument for system files to handled this is that
you often mux things out/in on suspend/resume, and that
may be suitable for an entity that knows about all devices.

Most systems I've seen don't have such centralized control
over device creation, and it seems this leads to the implicit
requirement that anyone wanting to so that from the board
need to move away from any statically allocated devices
first?

Or am I getting it backwards here?

>> --- a/drivers/Kconfig
>> +++ b/drivers/Kconfig
>> @@ -56,6 +56,10 @@ source "drivers/pps/Kconfig"
>>
>>  source "drivers/ptp/Kconfig"
>>
>> +# pinctrl before gpio - gpio drivers may need it
>
> GPIO controllers are just other devices, I don't think there is
> anything special here when compared with SPI or I2C.  I don't think
> gpio drivers should be accessing the pinmux api directly.
>
> In my mind, the gpio layer is only about abstracting the gpio control
> interface to drivers.  Whether or not or how the pin is routed outside
> the chip package is irrelevant to the driver or the gpio api.
>
> Besides, this is kconfig.  The order of this file has zero bearing on
> the resultant kernel.  It does matter for the Makefile though.

See earlier discussion, I think. If you look in the current
drivers/gpio/gpio-nomadik.c you see that all muxing is actually
done in that GPIO driver, since it is using the same register
range. (So it was natural not to break that part out, as there
was no other natural place to put it anyway.)

The only reason why others don't do that is (I guess) that
they have a special register range for muxing. In
arch/arm/mach-pxa/mfp-pxa.c you find the same kind
of strong coupling between GPIO and pinmux.

Actually some of my generalization work for GPIO is
exactly related to this, which is in practice a custom call to
the GPIO driver. Main problem - since the GPIO driver
can make any pin a GPIO, it needs to interact with
GPIO code to make sure it is not used for some GPIO -
since we don't have a pinmux subsystem that can take care
of that. So if I had that  ... a bit chicken and egg problem
here. (There are other custom GPIO stuff for sure though,
not just this.)

And doing a generic pin control subsystem is also for this
reason - get biasing, drive modes and load capacitances out
of the gpio subsystem and into something apropriate.

I think doing this from GPIO drivers for individual pins need
to be some intermediate step to consolidate the functionality
to drivers/pinctrl/*, else too many requirements on how things
shall be done start spreading across the board, but I'll surely
try to make it as autonomous as possible.

>> +menuconfig PINCTRL
>> +       bool "PINCTRL Support"
>> +       depends on SYSFS && EXPERIMENTAL
>
> Hold off on the sysfs stuff.  Lay down the basic API without sysfs,
> and add the sysfs bits as a separate patch.  This becomes a
> kernel->userspace abi issue, and you don't want to mess that up.

It is just exposing a name right now, say "you have this pinmux
with this name"

> Is a pinmux sysfs abi really needed?  What is the use-case?

Same as for userspace GPIO control I guess.

If you want to do GPIO control on a certain pin from userspace,
then surely you want to be able to mux it in, and I just heard
that the GPIO driver should not be able to do that itself... heh.

And configuring it statically muxed-in does not make sense
since you don't know whether userspace will actually use it
and default mux-enabling it will consumer more power in some
cases so doing it statically is not OK etc etc.

>> +config PINMUX_U300
>> +       bool "U300 pinmux driver"
>> +       depends on ARCH_U300
>> +       help
>> +         Say Y here to enable the U300 pinmux driver
>> +
>
> PINMUX_U300 should not be here in the infrastructure patch.

Mea culpa. I fix.

>> +obj-$(CONFIG_PINMUX_U300)      += pinmux-u300.o

This too!

>> +# generic pinmux support
>> +
>> +ccflags-$(CONFIG_DEBUG_PINMUX) += -DDEBUG
>> +
>> +obj-$(CONFIG_PINCTRL)          += core.o
>
> Consider calling this pinmux.o; particularly if there is ever a chance
> of it becoming a module.  It is conceivable that pinmux will be used
> for peripheral chips in a way that can/should be loaded at runtime.

Right now I haven't broken the pin registration API that will be
reused by generic pincontrol and actual pinmux framework into
different .c files, maybe I should?

The idea is that the pin infrastructure is static and pinmux
could actually be a module.

>> +/* Global lookup of per-pin descriptors, one for each physical pin */
>> +static DEFINE_SPINLOCK(pin_desc_tree_lock);
>> +static RADIX_TREE(pin_desc_tree, GFP_KERNEL);
>
> The radix tree should probably be per-pinmux controller local.  Of
> course, if you make all the pinmux numbering local to the controller,
> then the need for a radix tree could very well go away entirely, and
> it would simplify everything.

See earlier discussion about a global numberspace I guess.

If we were only doing pinmuxing with no global numberspace to
avoid also correlating needs with biasing etc, this would be true,
but pinmux is too glued into other stuff IMHO.

>> +int pin_is_valid(int pin)
>> +{
>> +       return pin >= 0 && pin < num_pins;
>> +}
>> +EXPORT_SYMBOL_GPL(pin_is_valid);
>
> A "pin_" prefix is very generic sounding.  Though it doesn't read as
> well, the pinmux_ prefix should probably be used consistently.

This is changed. pin_* prefix is for the generic top-level
pinctrl API, pinmux_* is specifically for the pinmux stuff.

>> pinctrl_register_pins_sparse/dense
>
> Why two different methods for registering pins?

Explained in the kerneldoc I guess, basically some systems can control
all pins from 0 ... NR_PINS_ON_THIS_SYSTEM whereas others
actually have holes in this map, or may want to fill them in with
several pinctrl_register_pins_sparse() calls, such as for platforms
registering some pins that are common across a few boards and
then a few board-specific pins.

> Also the previous two export symbol statements give the wrong functions.

Fixed that, saw it on the previous review mail from Joe P.

> Okay, enough comments for now.  I think that covers the big stuff, and
> I've got to get some other work done.

Thanks!

I bet that other work is deciding on whether to expose gpio_to_chip()
or not, hehe :-)

Yours,
Linus Walleij
