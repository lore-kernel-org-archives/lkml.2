Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1FMT6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 15:58:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43899 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1FMT54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 15:57:56 -0400
MIME-Version: 1.0
In-Reply-To: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 13 Jun 2011 13:57:36 -0600
X-Google-Sender-Auth: 0ngkTjnAgPNa5_K1Xxv3mQHWfLI
Message-ID: <BANLkTi=r=N5OwfsVLRuBsNRSpv91pTgeKA@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pinmux subsystem v3
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 10:58 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This creates a subsystem for handling of pinmux devices. These are
> devices that enable and disable groups of pins on primarily PGA and
> BGA type of chip packages and common in embedded systems.
>
> This is being done to depopulate the arch/arm/* directory of such
> custom drivers and try to abstract the infrastructure they all
> need. See the Documentation/pinmux.txt file that is part of this
> patch for more details.

Hi Linus,

Overall (but without a deep dive into the implementation details) I
think I generally like the approach.  To sum up, it looks like the
conceptual model is thus:

- A pinmux driver enumerates and registers all the pins that it has
- Setup code and/or driver code requests blocks of pins (functions)
when it needs them
- If all the pins are available, it gets them, otherwise it the allocation fails
- pins cannot be claimed by more than one device
- it is up to the pinmux driver to actually program the device and
determine whether or not the requested pin mode is actually
configurable.  Even if pins are available, it may be that other
constraints prevent it from actually being programmed

Ultimately, it still is up to the board designer and board port
engineer to ensure that the system can actually provide the requested
pin configuration.

My understanding is that in the majority of cases pinmux will probably
want/need to be setup and machine_init time, and device drivers won't
really know or care about pinmux; it will already be set up for them
when the driver is probed.  Any power management issues will also be
handled by platform/soc code when the dependent devices are in PM
states.

How does that line up with your conceptual model of pinmux?

Other comments below.
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v2->v3:
> - Renamed subsystem folder to "pinctrl" since we will likely
>  want to keep other pin control such as biasing in this
>  subsystem too, so let us keep to something generic even though
>  we're mainly doing pinmux now.
> - As a consequence, register pins as an abstract entity separate
>  from the pinmux. The muxing functions will claim pins out of the
>  pin pool and make sure they do not collide. Pins can now be
>  named by the pinctrl core.
> - Converted the pin lookup from a static array into a radix tree,
>  I agreed with Grant Likely to try to avoid any static allocation
>  (which is crap for device tree stuff) so I just rewrote this
>  to be dynamic, just like irq number descriptors. The
>  platform-wide definition of number of pins goes away - this is
>  now just the sum total of the pins registered to the subsystem.

You should consider still using a bitmap for tracking which pins are
actually available, similar to how irqs are tracked.  A bool in each
pinmux structure is a little wasteful, and requires a lock to be held
for a long time while checking all the structures.

> - Make sure mappings with only a function name and no device
>  works properly.
> +Pinmux drivers
> +==============
> +
> +The driver will for all calls be provided an offset pin number into its own
> +pin range. If you have 2 chips with 8x8 pins, the first chips pins will have
> +numbers 0 thru 63 and the second one pins 64 thru 127, but the driver for the
> +second chip will be passed numbers in the range 0 thru 63 anyway, base offset
> +subtracted.

Wait, do you really want a global numberspace here?  I'd rather see
callers have a direct reference to the pinmux controller instance, and
use local pin numbers.  Given the choice, I would not go with global
numbers for GPIOs again, and I'm not so big a fan of them for irqs
either.

> +
> +Pinmux drivers are required to supply a few callback functions, some are
> +optional. Usually the enable() and disable() functions are implemented,
> +writing values into some certain registers to activate a certain mux setting
> +for a certain pin.
> +
> +A simple driver for the above example will work by setting bits 0, 1 or 2
> +into some register mamed MUX, so it enumerates its available settings and
> +their pin assignments, and expose them like this:
> +
> +#include <linux/pinctrl/pinmux.h>
> +
> +struct foo_pmx_func {
> +       char *name;
> +       const unsigned int *pins;
> +       const unsigned num_pins;
> +};
> +
> +static unsigned int spi0_0_pins[] = { 0, 8, 16, 24 };
> +static unsigned int i2c0_pins[] = { 24, 25 };
> +static unsigned int spi0_1_pins[] = { 38, 46, 54, 62 };
> +
> +static struct foo_pmx_func myfuncs[] = {
> +       {
> +               .name = "spi0-0",
> +               .pins = spi0_0_pins,
> +               .num_pins = ARRAY_SIZE(spi0_1_pins),
> +       },
> +       {
> +               .name = "i2c0",
> +               .pins = i2c0_pins,
> +               .num_pins = ARRAY_SIZE(i2c0_pins),
> +       },
> +       {
> +               .name = "spi0-1",
> +               .pins = spi0_1_pins,
> +               .num_pins = ARRAY_SIZE(spi0_1_pins),
> +       },
> +};
> +
> +int foo_list(struct pinmux_dev *pmxdev, unsigned selector)
> +{
> +       if (selector >= ARRAY_SIZE(myfuncs))
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +const char *foo_get_fname(struct pinmux_dev *pmxdev, unsigned selector)
> +{
> +       if (selector >= ARRAY_SIZE(myfuncs))
> +               return NULL;
> +       return myfuncs[selector].name;
> +}

Is there a method to lookup the function id from the name?  Going from
name to number seems more useful to me than going the other way
around.

> +
> +static int foo_get_pins(struct pinmux_dev *pmxdev, unsigned selector,
> +                       unsigned ** const pins, unsigned * const num_pins)
> +{
> +       if (selector >= ARRAY_SIZE(myfuncs))
> +               return -EINVAL;
> +       *pins = myfuncs[selector].pins;
> +       *num_pins = myfuncs[selector].num_pins;
> +       return 0;
> +}
> +
> +
> +int foo_enable(struct pinmux_dev *pmxdev, unsigned selector)
> +{
> +       if (selector < ARRAY_SIZE(myfuncs))
> +               write((read(MUX)|(1<<selector)), MUX)
> +               return 0;
> +       }
> +       return -EINVAL;
> +}
> +
> +int foo_disable(struct pinmux_dev *pmxdev, unsigned selector)
> +{
> +       if (selector < ARRAY_SIZE(myfuncs))
> +               write((read(MUX) & ~(1<<selector)), MUX)
> +               return 0;
> +       }
> +       return -EINVAL;
> +}
> +
> +struct pinmux_ops ops = {
> +       .list_functions = foo_list,
> +       .get_function_name = foo_get_fname,
> +       .get_function_pins = foo_get_pins,
> +       .enable = foo_enable,
> +       .disable = foo_disable,

Mixing callbacks with data here.  Not bad, but maybe a little odd.

> +};
> +
> +Now the able reader will say: "wait - the driver needs to make sure it
> +can set this and that bit at the same time, because else it will collide
> +and wreak havoc in my electronics, and make sure noone else is using the
> +other setting that it's incompatible with".
> +
> +In the example activating muxing 0 and 1 at the same time setting bits
> +0 and 1, uses one pin in common so they would collide.
> +
> +The beauty of the pinmux subsystem is that since it keeps track of all
> +pins and who is using them, it will already have denied an impossible
> +request like that, so the driver does not need to worry about such
> +things - when it gets a selector passed in, the pinmux subsystem makes
> +sure no other device or GPIO assignment is already using the selected
> +pins.

Sometimes that isn't enough.  Some functions may not actually collide
on the pins they select, but the modes will be mutually exclusive
anyway.  There needs to be runtime checking that the mode can actually
be programmed when it is enabled (of course, it may just be that for
*this* example it doesn't need to worry about it, in which case my
comment is moot).

> +
> +The above functions are mandatory to implement for a pinmux driver.
> +
> +The function list could become long, especially if you can convert every
> +individual pin into a GPIO pin independent of any other pins, then your
> +function array can become 64 entries for each GPIO setting and then the
> +device functions. For this reason there is an additional function you
> +can implement to enable only GPIO on an individual pin: gpio_enable().
> +
> +
> +Pinmux board/machine configuration
> +==================================
> +
> +Boards and machines define how a certain complete running system is put
> +together, including how GPIOs and devices are muxed, how regulators are
> +constrained and how the clock tree looks. Of course pinmux settings are also
> +part of this.
> +
> +A pinmux config for a machine looks pretty much like a simple regulator
> +configuration, so for the example array above we want to enable i2c and
> +spi on the second function mapping:
> +
> +#include <linux/pinctrl/machine.h>
> +
> +static struct pinmux_map pmx_mapping[] = {
> +       {
> +               .function = "spi0-1",
> +               .dev_name = "foo-spi.0",
> +       },
> +       {
> +               .function = "i2c0",
> +               .dev_name = "foo-i2c.0",
> +       },
> +};

I'm wary about this approach, even though I know it is already used by
regulator and clk mappings.  The reason I'm wary is that matching
devices by name becomes tricky for anything that isn't statically
created by the kernel, such as when enumerating from the device tree,
because it assumes that the device name is definitively known.
Specifically, Linux's preferred name for a device is not guaranteed to
be available from the device tree.  We very purposefully do not encode
Linux kernel implementation details into the kernel so that
implementation detail changes don't force dt changes.

/me goes and thinks about the problem some more...

Okay, I think I've got a new approach for the DT domain so that Linux
gets the device names it wants for matching to clocks, regulators and
this stuff.  I'm going to go and code it up now.  I still don't
personally like matching devices by name, but by no measure is it a
show stopper for me.

> +
> +Since the above construct is pretty common there is a helper macro to make
> +it even more compact:
> +
> +static struct pinmux_map pmx_mapping[] = {
> +       PINMUX_MAP("spi0-1", "foo-spi.0"),
> +       PINMUX_MAP("i2c0", "foo-i2c.0"),
> +};
> +
> +The dev_name here matches to the unique device name that can be used to look
> +up the device struct (just like with clockdev or regulators). The function name
> +must match a function provided by the pinmux driver handling this pin range.
> +You register this pinmux mapping to the pinmux subsystem by simply:
> +
> +       ret = pinmux_register_mappings(&pmx_mapping, ARRAY_SIZE(pmx_mapping));
> +
> +
> +Pinmux requests from drivers
> +============================
> +
> +A driver may request a certain mux to be activated, usually just the default
> +mux like this:
> +
> +#include <linux/pinctrl/pinmux.h>
> +
> +foo_probe()
> +{
> +       /* Allocate a state holder named "state" etc */
> +       struct pinmux pmx;
> +
> +       pmx = pinmux_get(&device, NULL);
> +       if IS_ERR(pmx)
> +               return PTR_ERR(pmx);
> +       pinmux_enable(pmx);
> +
> +       state->pmx = pmx;
> +}
> +
> +foo_remove()
> +{
> +       pinmux_disable(state->pmx);
> +       pinmux_put(state->pmx);
> +}
> +
> +If you want a specific mux setting and not just the first one found for this
> +device you can specify a specific mux setting, for example in the above example
> +the second i2c0 setting: pinmux_get(&device, "spi0-2");
> +
> +This get/enable/disable/put sequence can just as well be handled by bus drivers
> +if you don't want each and every driver to handle it and you know the
> +arrangement on your bus.

I would *strongly* recommend against individual device drivers
accessing the pinmux api.  This is system level configuration code,
and should be handled at the system level.

> +
> +The pins are allocated for your device when you issue the pinmux_get() call,
> +after this you should be able to see this in the debugfs listing of all pins.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 29801f7..5caea5a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4933,6 +4933,11 @@ L:       linux-mtd@lists.infradead.org
>  S:     Maintained
>  F:     drivers/mtd/devices/phram.c
>
> +PINMUX SUBSYSTEM
> +M:     Linus Walleij <linus.walleij@linaro.org>
> +S:     Maintained
> +F:     drivers/pinmux/
> +
>  PKTCDVD DRIVER
>  M:     Peter Osterlund <petero2@telia.com>
>  S:     Maintained
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 3bb154d..6998d78 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -56,6 +56,10 @@ source "drivers/pps/Kconfig"
>
>  source "drivers/ptp/Kconfig"
>
> +# pinctrl before gpio - gpio drivers may need it

GPIO controllers are just other devices, I don't think there is
anything special here when compared with SPI or I2C.  I don't think
gpio drivers should be accessing the pinmux api directly.

In my mind, the gpio layer is only about abstracting the gpio control
interface to drivers.  Whether or not or how the pin is routed outside
the chip package is irrelevant to the driver or the gpio api.

Besides, this is kconfig.  The order of this file has zero bearing on
the resultant kernel.  It does matter for the Makefile though.

> +
> +source "drivers/pinctrl/Kconfig"
> +
>  source "drivers/gpio/Kconfig"
>
>  source "drivers/w1/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 09f3232..a590a01 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -5,6 +5,8 @@
>  # Rewritten to use lists instead of if-statements.
>  #
>
> +# GPIO must come after pinctrl as gpios may need to mux pins etc
> +obj-y                          += pinctrl/
>  obj-y                          += gpio/
>  obj-$(CONFIG_PCI)              += pci/
>  obj-$(CONFIG_PARISC)           += parisc/
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> new file mode 100644
> index 0000000..8050fdf
> --- /dev/null
> +++ b/drivers/pinctrl/Kconfig
> @@ -0,0 +1,29 @@
> +#
> +# PINCTRL infrastructure and drivers
> +#
> +
> +menuconfig PINCTRL
> +       bool "PINCTRL Support"
> +       depends on SYSFS && EXPERIMENTAL

Hold off on the sysfs stuff.  Lay down the basic API without sysfs,
and add the sysfs bits as a separate patch.  This becomes a
kernel->userspace abi issue, and you don't want to mess that up.

Is a pinmux sysfs abi really needed?  What is the use-case?

> +       help
> +         This enables the PINCTRL subsystem for controlling pins
> +         on chip packages, for example multiplexing pins on primarily
> +         PGA and BGA packages for systems on chip.
> +
> +         If unsure, say N.
> +
> +if PINCTRL
> +
> +config DEBUG_PINCTRL
> +       bool "Debug PINCTRL calls"
> +       depends on DEBUG_KERNEL
> +       help
> +         Say Y here to add some extra checks and diagnostics to PINCTRL calls.
> +
> +config PINMUX_U300
> +       bool "U300 pinmux driver"
> +       depends on ARCH_U300
> +       help
> +         Say Y here to enable the U300 pinmux driver
> +

PINMUX_U300 should not be here in the infrastructure patch.

> +endif
> diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
> new file mode 100644
> index 0000000..44d8933
> --- /dev/null
> +++ b/drivers/pinctrl/Makefile
> @@ -0,0 +1,6 @@
> +# generic pinmux support
> +
> +ccflags-$(CONFIG_DEBUG_PINMUX) += -DDEBUG
> +
> +obj-$(CONFIG_PINCTRL)          += core.o

Consider calling this pinmux.o; particularly if there is ever a chance
of it becoming a module.  It is conceivable that pinmux will be used
for peripheral chips in a way that can/should be loaded at runtime.

> +obj-$(CONFIG_PINMUX_U300)      += pinmux-u300.o
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> new file mode 100644
> index 0000000..8fd1437
> --- /dev/null
> +++ b/drivers/pinctrl/core.c
> @@ -0,0 +1,1028 @@
> +/*
> + * Core driver for the pinmux subsystem
> + *
> + * Copyright (C) 2011 ST-Ericsson SA
> + * Written on behalf of Linaro for ST-Ericsson
> + * Based on bits of regulator core, gpio core and clk core
> + *
> + * Author: Linus Walleij <linus.walleij@linaro.org>
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +#define pr_fmt(fmt) "pinctrl core: " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/radix-tree.h>
> +#include <linux/err.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
> +#include <linux/sysfs.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/pinctrl/machine.h>
> +#include <linux/pinctrl/pinmux.h>
> +
> +/* Global list of pinmuxes */
> +static DEFINE_MUTEX(pinmux_list_mutex);
> +static LIST_HEAD(pinmux_list);
> +
> +/* Global list of pinmux devices */
> +static DEFINE_MUTEX(pinmuxdev_list_mutex);
> +static LIST_HEAD(pinmuxdev_list);
> +
> +/**
> + * struct pin_desc - pin descriptor for each physical pin in the arch
> + * @pmxdev: corresponding pinmux device
> + * @requested: whether the pin is already requested by pinmux or not
> + * @name: a name for the pin, e.g. the name of the pin/pad/finger on a
> + *     datasheet or such
> + * @function: a named muxing function for the pin that will be passed to
> + *     subdrivers and shown in debugfs etc
> + */
> +struct pin_desc {
> +       struct pinmux_dev *pmxdev;
> +       bool    requested;
> +       char    name[16];
> +       char    function[16];
> +};
> +/* Global lookup of per-pin descriptors, one for each physical pin */
> +static DEFINE_SPINLOCK(pin_desc_tree_lock);
> +static RADIX_TREE(pin_desc_tree, GFP_KERNEL);

The radix tree should probably be per-pinmux controller local.  Of
course, if you make all the pinmux numbering local to the controller,
then the need for a radix tree could very well go away entirely, and
it would simplify everything.

> +static unsigned int num_pins = 0;
> +
> +/**
> + * struct pinmux - per-device pinmux state holder
> + * @node: global list node - only for internal use
> + * @dev: the device using this pinmux
> + * @pmxdev: the pinmux device controlling this pinmux
> + * @map: corresponding pinmux map active for this pinmux setting
> + * @usecount: the number of active users of this mux setting, used to keep
> + *     track of nested use cases
> + * @pins: an array of discrete physical pins used in this mapping, taken
> + *     from the global pin enumeration space (copied from pinmux map)
> + * @num_pins: the number of pins in this mapping array, i.e. the number of
> + *     elements in .pins so we can iterate over that array (copied from
> + *     pinmux map)
> + * @pmxdev: pinmux device handling this pinmux
> + * @pmxdev_selector: the selector for the pinmux device handling this pinmux
> + * @mutex: a lock for the pinmux state holder
> + */
> +struct pinmux {
> +       struct list_head node;
> +       struct device *dev;
> +       struct pinmux_map const *map;
> +       unsigned usecount;
> +       struct pinmux_dev *pmxdev;
> +       unsigned pmxdev_selector;
> +       struct mutex mutex;
> +};
> +
> +int pin_is_valid(int pin)
> +{
> +       return pin >= 0 && pin < num_pins;
> +}
> +EXPORT_SYMBOL_GPL(pin_is_valid);

A "pin_" prefix is very generic sounding.  Though it doesn't read as
well, the pinmux_ prefix should probably be used consistently.

> +
> +static ssize_t pinmux_name_show(struct device *dev,
> +                               struct device_attribute *attr, char *buf)
> +{
> +       struct pinmux_dev *pmxdev = dev_get_drvdata(dev);
> +
> +       return sprintf(buf, "%s\n", pmxdev_get_name(pmxdev));
> +}
> +
> +static struct device_attribute pinmux_dev_attrs[] = {
> +       __ATTR(name, 0444, pinmux_name_show, NULL),
> +       __ATTR_NULL,
> +};
> +
> +static void pinmux_dev_release(struct device *dev)
> +{
> +       struct pinmux_dev *pmxdev = dev_get_drvdata(dev);
> +       kfree(pmxdev);
> +}
> +
> +static struct class pinmux_class = {
> +       .name = "pinmux",
> +       .dev_release = pinmux_dev_release,
> +       .dev_attrs = pinmux_dev_attrs,
> +};
> +
> +/* Deletes a range of pin descriptors */
> +static void pinctrl_free_pindescs(struct pinctrl_pin_desc const *pins,
> +                                 unsigned num_pins)
> +{
> +       int i;
> +
> +       for (i = 0; i < num_pins; i++) {
> +               struct pin_desc *pindesc;
> +
> +               spin_lock(&pin_desc_tree_lock);
> +               pindesc = radix_tree_lookup(&pin_desc_tree, pins[i].number);
> +               if (pindesc != NULL) {
> +                       radix_tree_delete(&pin_desc_tree, pins[i].number);
> +                       num_pins --;
> +               }
> +               spin_unlock(&pin_desc_tree_lock);
> +               kfree(pindesc);
> +       }
> +}
> +
> +static int pinctrl_register_one_pin(unsigned number, const char *name)
> +{
> +       struct pin_desc *pindesc;
> +
> +       spin_lock(&pin_desc_tree_lock);
> +       pindesc = radix_tree_lookup(&pin_desc_tree, number);
> +       spin_unlock(&pin_desc_tree_lock);
> +
> +       if (pindesc != NULL) {
> +               pr_err("pin %d already registered\n", number);
> +               return -EINVAL;
> +       }
> +
> +       pindesc = kzalloc(sizeof(*pindesc), GFP_KERNEL);
> +       if (pindesc == NULL)
> +               return -ENOMEM;
> +
> +       /* Copy optional basic pin info */
> +       if (name) {
> +               strncpy(pindesc->name, name, 16);
> +               pindesc->name[15] = '\0';
> +       }
> +
> +       spin_lock(&pin_desc_tree_lock);
> +       radix_tree_insert(&pin_desc_tree, number, pindesc);
> +       num_pins ++;
> +       spin_unlock(&pin_desc_tree_lock);
> +       return 0;
> +}
> +
> +/* Passing in 0 num_pins means "sparse" */
> +static int pinctrl_register_pins(struct pinctrl_pin_desc const *pins,
> +                                unsigned num_descs, unsigned num_pins)
> +{
> +       unsigned i;
> +       int ret = 0;
> +
> +       for (i = 0; i < num_descs; i++) {
> +               ret = pinctrl_register_one_pin(pins[i].number, pins[i].name);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       if (num_pins == 0)
> +               return 0;
> +
> +       /*
> +        * If we are registerering dense pinlists, fill in all holes with
> +        * anonymous pins.
> +        */
> +       for (i = 0; i < num_pins; i++) {
> +               char pinname[16];
> +               struct pin_desc *pindesc;
> +
> +               spin_lock(&pin_desc_tree_lock);
> +               pindesc = radix_tree_lookup(&pin_desc_tree, i);
> +               spin_unlock(&pin_desc_tree_lock);
> +               /* Already registered this one, take next */
> +               if (pindesc)
> +                       continue;
> +
> +               snprintf(pinname, 15, "anonymous %u", i);
> +               pinname[15] = '\0';
> +
> +               ret = pinctrl_register_one_pin(i, pinname);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * pinctrl_register_pins_sparse() - register a range of pins for a
> + *     board/machine with potential holes in the pin map. The pins in
> + *     the holes will not be usable.
> + * @pins: a range of pins to register
> + * @num_descs: the number of pins descriptors passed in through the previous
> + *     pointer
> + */
> +int pinctrl_register_pins_sparse(struct pinctrl_pin_desc const *pins,
> +                         unsigned num_descs)
> +{
> +       int ret;
> +
> +       ret = pinctrl_register_pins(pins, num_descs, 0);
> +       if (ret)
> +               pinctrl_free_pindescs(pins, num_descs);
> +       return ret;
> +
> +}
> +EXPORT_SYMBOL_GPL(pinctrl_register_pins);
> +
> +/**
> + * pinctrl_register_pins_dense() - register a range of pins for a
> + *     board/machine, if there are holes in the pin map, they will be
> + *     allocated by anonymous pins.
> + * @pins: a range of pins to register
> + * @num_descs: the number of pins descriptors passed in through the previous
> + *     pointer
> + * @num_pins: the total number of pins including holes in the pin map and
> + *     any "air" at the end of the map, all pins from 0 to this number
> + *     will be allocated, the ones that does not have descriptors passed
> + *     in will be marked "anonymous"
> + */
> +int pinctrl_register_pins_dense(struct pinctrl_pin_desc const *pins,
> +                                unsigned num_descs, unsigned num_pins)
> +{
> +       int ret;
> +       unsigned i;
> +
> +       ret = pinctrl_register_pins(pins, num_descs, num_pins);
> +       if (ret) {
> +               for (i = 0; i < num_pins; i++) {
> +                       struct pin_desc *pindesc;
> +
> +                       spin_lock(&pin_desc_tree_lock);
> +                       pindesc = radix_tree_lookup(&pin_desc_tree, i);
> +                       if (pindesc != NULL) {
> +                               radix_tree_delete(&pin_desc_tree, i);
> +                               num_pins --;
> +                       }
> +                       spin_unlock(&pin_desc_tree_lock);
> +                       kfree(pindesc);
> +               }
> +       }
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(pinctrl_register_pins_sparse);

Why two different methods for registering pins?

Also the previous two export symbol statements give the wrong functions.

Okay, enough comments for now.  I think that covers the big stuff, and
I've got to get some other work done.

g.
