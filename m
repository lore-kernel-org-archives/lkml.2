Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2G2ROA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 13:14:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48474 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2G2RN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 13:13:58 -0400
MIME-Version: 1.0
In-Reply-To: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de>
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de>
Date: Sun, 29 Jul 2012 19:13:57 +0200
Message-ID: <CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 1:59 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:

> This commit adds a driver for the Avionic Design N-bit GPIO expander.
> The expander provides a variable number of GPIO pins with interrupt
> support.
(...)
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-adnp.txt b/Documentation/devicetree/bindings/gpio/gpio-adnp.txt
> new file mode 100644
> index 0000000..513a18e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-adnp.txt
> @@ -0,0 +1,38 @@
> +Avionic Design N-bit GPIO expander bindings
> +
> +Required properties:
> +- compatible: should be "ad,gpio-adnp"
> +- reg: The I2C slave address for this device.
> +- interrupt-parent: phandle of the parent interrupt controller.
> +- interrupts: Interrupt specifier for the controllers interrupt.
> +- #gpio-cells: Should be 2. The first cell is the GPIO number and the
> +  second cell is used to specify optional parameters:
> +  - bit 0: polarity (0: normal, 1: inverted)
> +- gpio-controller: Marks the device as a GPIO controller
> +- #interrupt-cells: Should be 2. The first cell contains the GPIO number,
> +  whereas the second cell is used to specify flags:
> +    bits[3:0] trigger type and level flags
> +      1 = low-to-high edge triggered
> +      2 = high-to-low edge triggered
> +      4 = active high level-sensitive
> +      8 = active low level-sensitive

Why on earth would a bunch of flags be an "interrupt cell"?

Maybe there is something about DT bindings I don't get so
please educate me.

I can see that OMAP is doing this, but is it a good idea?
I really need Rob/Grant to comment on this.

> +- interrupt-controller: Marks the device as an interrupt controller.
> +- nr-gpios: The number of pins supported by the controller.

These two last things look very generic, like something every GPIO
driver could want to expose.

I'd really like to have Grant's word on GPIO DT bindings and how these
should look, I had some discussion with Wolfram (the I2C maintainer)
about bindings turning out less generic than they ought to be, so we
need some discussion on this.

Arnd recently consolidated some MMC props, maybe we need to do
the same for GPIO drivers.

(...)
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 502b5ea..d1b0f7d 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -444,6 +444,24 @@ config GPIO_ADP5588_IRQ
>           Say yes here to enable the adp5588 to be used as an interrupt
>           controller. It requires the driver to be built in the kernel.
>
> +config GPIO_ADNP
> +       tristate "Avionic Design N-bit GPIO expander"
> +       depends on I2C && OF
> +       help
> +         This option enables support for N GPIOs found on Avionic Design
> +         I2C GPIO expanders. The register space will be extended by powers
> +         of two, so the controller will need to accomodate for that. For
> +         example: if a controller provides 48 pins, 6 registers will be
> +         enough to represent all pins, but the driver will assume a
> +         register layout for 64 pins (8 registers).
> +
> +config GPIO_ADNP_IRQ
> +       tristate "Interrupt controller support"
> +       depends on GPIO_ADNP
> +       help
> +         Say yes here to enable the Avionic Design N-bit GPIO expander to
> +         be used as an interrupt controller.

First: please describe the usecase where the Avionic driver is used
without making use of the IRQ, and *why* it should be possible
to configure this out. E.g. is there a hardware which isn't using the
IRQ portions? If there is no non-irq usecase just drop this
config option.

If you're keeping it:

Now this is going to appear as a single line under the ADNP driver
config entry saying "Interrupt controller support", which is too
generic.

Please make it expand to a submenu so that it gets indented below the
controller driver.

(...)
> diff --git a/drivers/gpio/gpio-adnp.c b/drivers/gpio/gpio-adnp.c
> new file mode 100644
> index 0000000..c122ff4
> --- /dev/null
> +++ b/drivers/gpio/gpio-adnp.c
> @@ -0,0 +1,615 @@
> +/*
> + * Copyright (C) 2011-2012 Avionic Design GmbH
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/gpio.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/irqdomain.h>

Good!

> +#include <linux/module.h>
> +#include <linux/of_irq.h>
> +#include <linux/seq_file.h>
> +#include <linux/slab.h>
> +
> +#define GPIO_DDR(gpio) (0x00 << (gpio)->reg_shift)
> +#define GPIO_PLR(gpio) (0x01 << (gpio)->reg_shift)
> +#define GPIO_IER(gpio) (0x02 << (gpio)->reg_shift)
> +#define GPIO_ISR(gpio) (0x03 << (gpio)->reg_shift)
> +#define GPIO_PTR(gpio) (0x04 << (gpio)->reg_shift)
> +
> +struct adnp {
> +       struct i2c_client *client;
> +       struct gpio_chip gpio;
> +       unsigned int reg_shift;
> +
> +       struct mutex i2c_lock;
> +
> +       struct irq_domain *domain;
> +       struct mutex irq_lock;
> +
> +       u8 *irq_mask;
> +       u8 *irq_mask_cur;
> +       u8 *irq_level;
> +       u8 *irq_rise;
> +       u8 *irq_fall;
> +       u8 *irq_high;
> +       u8 *irq_low;

Some or all of this looks like a regmap reimplementation, see below.

> +};
> +
> +static int adnp_read(struct adnp *gpio, unsigned offset, uint8_t *value)

I don't know why you name the struct adnp variable "gpio" everywhere,
that is quite ambigous. Why not name this variable "adnp" consequently
everywhere?

> +{
> +       int err;
> +
> +       err = i2c_smbus_read_byte_data(gpio->client, offset);
> +       if (err < 0) {
> +               dev_err(gpio->gpio.dev, "%s failed: %d\n",
> +                       "i2c_smbus_read_byte_data()", err);
> +               return err;
> +       }
> +
> +       *value = err;
> +       return 0;
> +}
> +
> +static int adnp_write(struct adnp *gpio, unsigned offset, uint8_t value)
> +{
> +       int err;
> +
> +       err = i2c_smbus_write_byte_data(gpio->client, offset, value);
> +       if (err < 0) {
> +               dev_err(gpio->gpio.dev, "%s failed: %d\n",
> +                       "i2c_smbus_write_byte_data()", err);
> +               return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static int adnp_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct adnp *gpio = container_of(chip, struct adnp, gpio);

When I do this at several places in a driver I usually define
a macro like

#define to_adnp(foo) container_of(foo, struct adnp, gpio)

Used like so:

struct adnp *adnp = to_adnp(chip);

> +       unsigned int reg = offset >> gpio->reg_shift;
> +       unsigned int pos = offset & 7;
> +       u8 value;
> +       int err;
> +
> +       mutex_lock(&gpio->i2c_lock);

The point of taking this mutex here avoids me.
adnp_read() only performs a single transaction.

> +
> +       err = adnp_read(gpio, GPIO_PLR(gpio) + reg, &value);
> +       if (err < 0)
> +               goto out;
> +
> +       err = (value & BIT(pos)) ? 1 : 0;
> +
> +out:
> +       mutex_unlock(&gpio->i2c_lock);
> +       return err;
> +}
> +
> +static void adnp_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +       struct adnp *gpio = container_of(chip, struct adnp, gpio);

to_adnp()

> +       unsigned int reg = offset >> gpio->reg_shift;
> +       unsigned int pos = offset & 7;
> +       int err;
> +       u8 val;
> +
> +       mutex_lock(&gpio->i2c_lock);

But here the mutex is needed, I can see that...
(etc)

(...)
> +static void adnp_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
> +{
> +       struct adnp *gpio = container_of(chip, struct adnp, gpio);
> +       u8 *base, *ddr, *plr, *ier, *isr, *ptr;
> +       unsigned int regs, i, j;
> +       int err;
> +
> +       regs = 1 << gpio->reg_shift;
> +
> +       base = kzalloc(regs * 5, GFP_KERNEL);

Why kzalloc()/kfree() when you can just use a

static u8 base[N];

where N is the max number of registers on any HW instead?

> +       if (!base)
> +               return;
> +
> +       ddr = base + (regs * 0);
> +       plr = base + (regs * 1);
> +       ier = base + (regs * 2);
> +       isr = base + (regs * 3);
> +       ptr = base + (regs * 4);
> +
> +       for (i = 0; i < regs; i++) {
> +               err = adnp_read(gpio, GPIO_DDR(gpio) + i, &ddr[i]);
> +               if (err < 0)
> +                       goto out;
> +
> +               err = adnp_read(gpio, GPIO_PLR(gpio) + i, &plr[i]);
> +               if (err < 0)
> +                       goto out;
> +
> +               err = adnp_read(gpio, GPIO_IER(gpio) + i, &ier[i]);
> +               if (err < 0)
> +                       goto out;
> +
> +               err = adnp_read(gpio, GPIO_ISR(gpio) + i, &isr[i]);
> +               if (err < 0)
> +                       goto out;
> +
> +               err = adnp_read(gpio, GPIO_PTR(gpio) + i, &ptr[i]);
> +               if (err < 0)
> +                       goto out;
> +       }

You must take the mutex around this for-loop, don't you?

Else browing debugfs will sporadically corrupt transfers,
or something like that. Or was this intended to cut into any
ongoing transfer couple?

> +       for (i = 0; i < regs; i++) {
> +               for (j = 0; j < 8; j++) {
> +                       unsigned int bit = (i << gpio->reg_shift) + j;
> +                       const char *direction = "input ";
> +                       const char *level = "low ";
> +                       const char *interrupt = "disabled";
> +                       const char *pending = "";
> +
> +                       if (ddr[i] & BIT(j))
> +                               direction = "output";
> +
> +                       if (plr[i] & BIT(j))
> +                               level = "high";
> +
> +                       if (ier[i] & BIT(j))
> +                               interrupt = "enabled ";
> +
> +                       if (isr[i] & BIT(j))
> +                               pending = "pending";
> +
> +                       seq_printf(s, "%2u: %s %s IRQ %s %s\n", bit,
> +                                  direction, level, interrupt, pending);
> +               }
> +       }
> +
> +out:
> +       kfree(base);
> +}
> +
> +static int adnp_gpio_setup(struct adnp *gpio, unsigned int num_gpios)
> +{
> +       struct gpio_chip *chip = &gpio->gpio;
> +
> +       gpio->reg_shift = get_count_order(num_gpios) - 3;
> +
> +       chip->direction_input = adnp_gpio_direction_input;
> +       chip->direction_output = adnp_gpio_direction_output;
> +       chip->get = adnp_gpio_get;
> +       chip->set = adnp_gpio_set;
> +       chip->can_sleep = 1;
> +       if (IS_ENABLED(CONFIG_DEBUG_FS))
> +               chip->dbg_show = adnp_gpio_dbg_show;
> +
> +       chip->base = -1;
> +       chip->ngpio = num_gpios;
> +       chip->label = gpio->client->name;
> +       chip->dev = &gpio->client->dev;
> +       chip->of_node = chip->dev->of_node;
> +       chip->owner = THIS_MODULE;

Usually we define the struct gpio_chip as a static const and have
the state containter hold a static const struct gpio_chip *chip;
entry assigned to point to the static const at probe time.

All other GPIO drivers #ifdef their debugfs code, this probably
works fine too, but never saw it before.

I'm ambivalent about this, I sort of like it because it avoids
#ifdefs and also makes sure the code is always compiled,
so if you like it like this, keep it.

(...)
> +static void adnp_irq_update_mask(struct adnp *gpio)
> +{
> +       unsigned int regs = 1 << gpio->reg_shift;
> +       bool equal = true;
> +       unsigned int i;
> +
> +       for (i = 0; i < regs; i++) {
> +               if (gpio->irq_mask[i] != gpio->irq_mask_cur[i]) {
> +                       equal = false;
> +                       break;
> +               }
> +       }

This is not looking good. It looks like you're reimplementing
parts of regmap.

In that case, please use <linux/regmap.h> to cache registers
instead.

But I'm not sure ...

(...)
> +static void adnp_irq_bus_lock(struct irq_data *data)
> +{
> +       struct adnp *gpio = irq_data_get_irq_chip_data(data);
> +       unsigned int regs = 1 << gpio->reg_shift;
> +
> +       mutex_lock(&gpio->irq_lock);
> +       memcpy(gpio->irq_mask_cur, gpio->irq_mask, regs);
> +}
> +
> +static void adnp_irq_bus_unlock(struct irq_data *data)
> +{
> +       struct adnp *gpio = irq_data_get_irq_chip_data(data);
> +
> +       adnp_irq_update_mask(gpio);
> +       mutex_unlock(&gpio->irq_lock);
> +}

Actually I'm not following why the IRQ mask registers are shadowed
at bus_lock and restored at bus_unlock().

A comment describing why that's needed and how it works is
definately needed.

(...)
> +static const struct irq_domain_ops adnp_irq_domain_ops = {
> +       .map = adnp_irq_map,
> +       .xlate = irq_domain_xlate_twocell,
> +};
> +
> +static int adnp_irq_setup(struct adnp *gpio)
> +{
> +       unsigned int regs = 1 << gpio->reg_shift, i;
> +       struct gpio_chip *chip = &gpio->gpio;
> +       int err;
> +
> +       mutex_init(&gpio->irq_lock);
> +
> +       gpio->irq_mask = devm_kzalloc(chip->dev, regs * 7, GFP_KERNEL);
> +       if (!gpio->irq_mask)
> +               return -ENOMEM;
> +
> +       gpio->irq_mask_cur = gpio->irq_mask + (regs * 1);
> +       gpio->irq_level = gpio->irq_mask + (regs * 2);
> +       gpio->irq_rise = gpio->irq_mask + (regs * 3);
> +       gpio->irq_fall = gpio->irq_mask + (regs * 4);
> +       gpio->irq_high = gpio->irq_mask + (regs * 5);
> +       gpio->irq_low = gpio->irq_mask + (regs * 6);

I'm not following this regs * 1, regs * 2 ... regs *7 stuff. What are you doing
here? Explain with some comment atleast.

> +
> +       for (i = 0; i < regs; i++) {
> +               err = adnp_read(gpio, GPIO_PLR(gpio) + i, &gpio->irq_level[i]);
> +               if (err < 0)
> +                       return err;
> +       }

Looks like regmap reimplementation.

> +       gpio->domain = irq_domain_add_linear(chip->of_node, chip->ngpio,
> +                                            &adnp_irq_domain_ops, gpio);
> +
> +       err = request_threaded_irq(gpio->client->irq, NULL, adnp_irq,
> +                                  IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> +                                  dev_name(chip->dev), gpio);

Since you're using devm_* above use it here too:
devm_request_threaded_irq().

> +       if (err != 0) {
> +               dev_err(chip->dev, "can't request IRQ#%d: %d\n",
> +                       gpio->client->irq, err);
> +               goto error;
> +       }
> +
> +       gpio->gpio.to_irq = adnp_gpio_to_irq;
> +       return 0;
> +
> +error:
> +       irq_domain_remove(gpio->domain);
> +       return err;
> +}
> +
> +static void adnp_irq_teardown(struct adnp *gpio)
> +{
> +       unsigned int irq, i;
> +
> +       free_irq(gpio->client->irq, gpio);

If you're using devm to grab the IRQ this is not needed.

> +
> +       for (i = 0; i < gpio->gpio.ngpio; i++) {
> +               irq = irq_find_mapping(gpio->domain, i);
> +               if (irq > 0)
> +                       irq_dispose_mapping(irq);
> +       }
> +
> +       irq_domain_remove(gpio->domain);
> +}
> +
> +static __devinit int adnp_i2c_probe(struct i2c_client *client,
> +                                   const struct i2c_device_id *id)
> +{
> +       struct adnp *gpio;
> +       u32 num_gpios;
> +       int err;
> +
> +       err = of_property_read_u32(client->dev.of_node, "nr-gpios",
> +                                  &num_gpios);
> +       if (err < 0)
> +               return err;
> +
> +       client->irq = irq_of_parse_and_map(client->dev.of_node, 0);
> +       if (client->irq == NO_IRQ)

Just if (!client->irq) since NO_IRQ is 0 nowadays.

> +               return -EPROBE_DEFER;

Why would you defer in this case? If the IRQ controller appear later
than the GPIO driver?

> +       gpio = devm_kzalloc(&client->dev, sizeof(*gpio), GFP_KERNEL);
> +       if (!gpio)
> +               return -ENOMEM;
> +
> +       mutex_init(&gpio->i2c_lock);
> +       gpio->client = client;
> +
> +       err = adnp_gpio_setup(gpio, num_gpios);
> +       if (err < 0)
> +               return err;
> +
> +       if (IS_ENABLED(CONFIG_GPIO_ADNP_IRQ)) {
> +               err = adnp_irq_setup(gpio);
> +               if (err < 0)
> +                       goto teardown;
> +       }

And that activates the question why this should be conditional,
please elaborate.

> +       err = gpiochip_add(&gpio->gpio);
> +       if (err < 0)
> +               goto teardown;
> +
> +       i2c_set_clientdata(client, gpio);
> +       return 0;
> +
> +teardown:
> +       if (IS_ENABLED(CONFIG_GPIO_ADNP_IRQ))
> +               adnp_irq_teardown(gpio);

Here too.

> +
> +       return err;
> +}

Most of the driver looks very good though! The code is
clean and easy to read and maintain.

But we need to iron out the details.

Yours,
Linus Walleij
