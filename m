Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1BCQyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 11:54:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64833 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab1BCQyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 11:54:12 -0500
Date: Thu, 3 Feb 2011 09:54:06 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2] gpio: add new Altera PIO driver
Message-ID: <20110203165406.GA6180@angua.secretlab.ca>
References: <201101262237.p0QMb95f008734@imap1.linux-foundation.org>
 <1296719817-3007-1-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296719817-3007-1-git-send-email-thomas@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 03:56:57PM +0800, Thomas Chou wrote:
> This driver supports the Altera PIO core.
> 
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---
> v2 change compatible vendor to uppercase, ALTR.
>    add dts binding doc.
> 
>  .../devicetree/bindings/gpio/altera_gpio.txt       |    7 +
>  drivers/gpio/Kconfig                               |    6 +
>  drivers/gpio/Makefile                              |    1 +
>  drivers/gpio/altera_gpio.c                         |  233 ++++++++++++++++++++
>  4 files changed, 247 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/altera_gpio.txt
>  create mode 100644 drivers/gpio/altera_gpio.c
> 
> diff --git a/Documentation/devicetree/bindings/gpio/altera_gpio.txt b/Documentation/devicetree/bindings/gpio/altera_gpio.txt
> new file mode 100644
> index 0000000..5ab751a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/altera_gpio.txt
> @@ -0,0 +1,7 @@
> +Altera GPIO
> +
> +Required properties:
> +- compatible : should be "ALTR,pio-1.0".
> +Optional properties:
> +- resetvalue : the reset value of the output port.
> +- width : the width of the port in number of bits.
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 664660e..40271f0 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -70,6 +70,12 @@ config GPIO_MAX730X
>  
>  comment "Memory mapped GPIO expanders:"
>  
> +config GPIO_ALTERA
> +	bool "Altera GPIO"
> +	depends on OF
> +	help
> +	  Say yes here to support the Altera PIO device
> +
>  config GPIO_BASIC_MMIO
>  	tristate "Basic memory-mapped GPIO controllers support"
>  	help
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 3351cf8..ed11932 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -8,6 +8,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
>  
>  obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
>  
> +obj-$(CONFIG_GPIO_ALTERA)	+= altera_gpio.o

This list is mostly alphabetized.  Please move down 2 lines below the
ADP5588 line.

>  obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
>  obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
>  obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
> diff --git a/drivers/gpio/altera_gpio.c b/drivers/gpio/altera_gpio.c
> new file mode 100644
> index 0000000..a173eb3
> --- /dev/null
> +++ b/drivers/gpio/altera_gpio.c
> @@ -0,0 +1,233 @@
> +/*
> + * Altera GPIO driver
> + *
> + * Copyright (C) 2011 Thomas Chou <thomas@wytron.com.tw>
> + *
> + * Based on Xilinx gpio driver, which is
> + * Copyright 2008 Xilinx, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/of_device.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_gpio.h>
> +#include <linux/io.h>
> +#include <linux/gpio.h>
> +#include <linux/slab.h>
> +
> +#define DRV_NAME "altera_gpio"
> +
> +/* Register Offset Definitions */
> +#define ALTERA_GPIO_DATA_OFFSET   0x0	/* Data register  */
> +#define ALTERA_GPIO_DIR_OFFSET    0x4	/* I/O direction register  */
> +
> +struct altera_gpio_instance {
> +	struct of_mm_gpio_chip mmchip;
> +	u32 gpio_state;		/* GPIO state shadow register */
> +	u32 gpio_dir;		/* GPIO direction shadow register */
> +	spinlock_t gpio_lock;	/* Lock used for synchronization */
> +};
> +
> +/*
> + * altera_gpio_get - Read the specified signal of the GPIO device.

Kerneldoc format is 2 asterisks on the first line of a function
documentation block, like this:

/**
 * altera_gpio_get - Read the specified signal of the GPIO device.

> + * @gc:     Pointer to gpio_chip device structure.
> + * @gpio:   GPIO signal number.
> + *
> + * This function reads the specified signal of the GPIO device. It returns 0 if
> + * the signal clear, 1 if signal is set or negative value on error.
> + */
> +static int altera_gpio_get(struct gpio_chip *gc, unsigned int gpio)
> +{
> +	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
> +
> +	return (readl(mm_gc->regs + ALTERA_GPIO_DATA_OFFSET) >> gpio) & 1;
> +}
> +
> +/*
> + * altera_gpio_set - Write the specified signal of the GPIO device.
> + * @gc:     Pointer to gpio_chip device structure.
> + * @gpio:   GPIO signal number.
> + * @val:    Value to be written to specified signal.
> + *
> + * This function writes the specified value in to the specified signal of the
> + * GPIO device.
> + */
> +static void altera_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
> +{
> +	unsigned long flags;
> +	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
> +	struct altera_gpio_instance *chip =
> +	    container_of(mm_gc, struct altera_gpio_instance, mmchip);
> +
> +	spin_lock_irqsave(&chip->gpio_lock, flags);
> +
> +	/* Write to shadow register and output */
> +	if (val)
> +		chip->gpio_state |= 1 << gpio;
> +	else
> +		chip->gpio_state &= ~(1 << gpio);
> +	writel(chip->gpio_state, mm_gc->regs + ALTERA_GPIO_DATA_OFFSET);
> +
> +	spin_unlock_irqrestore(&chip->gpio_lock, flags);
> +}
> +
> +/*
> + * altera_gpio_dir_in - Set the direction of the specified GPIO signal as input.
> + * @gc:     Pointer to gpio_chip device structure.
> + * @gpio:   GPIO signal number.
> + *
> + * This function sets the direction of specified GPIO signal as input.
> + * It returns 0 if direction of GPIO signals is set as input otherwise it
> + * returns negative error value.
> + */
> +static int altera_gpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
> +{
> +	unsigned long flags;
> +	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
> +	struct altera_gpio_instance *chip =
> +	    container_of(mm_gc, struct altera_gpio_instance, mmchip);
> +
> +	spin_lock_irqsave(&chip->gpio_lock, flags);
> +
> +	/* Clear the GPIO bit in shadow register and set direction as input */
> +	chip->gpio_dir &= ~(1 << gpio);
> +	writel(chip->gpio_dir, mm_gc->regs + ALTERA_GPIO_DIR_OFFSET);
> +
> +	spin_unlock_irqrestore(&chip->gpio_lock, flags);
> +
> +	return 0;
> +}
> +
> +/*
> + * altera_gpio_dir_out - Set the direction of the specified GPIO as output.
> + * @gc:     Pointer to gpio_chip device structure.
> + * @gpio:   GPIO signal number.
> + * @val:    Value to be written to specified signal.
> + *
> + * This function sets the direction of specified GPIO signal as output. If all
> + * GPIO signals of GPIO chip is configured as input then it returns
> + * error otherwise it returns 0.
> + */
> +static int altera_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
> +{
> +	unsigned long flags;
> +	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
> +	struct altera_gpio_instance *chip =
> +	    container_of(mm_gc, struct altera_gpio_instance, mmchip);
> +
> +	spin_lock_irqsave(&chip->gpio_lock, flags);
> +
> +	/* Write state of GPIO signal */
> +	if (val)
> +		chip->gpio_state |= 1 << gpio;
> +	else
> +		chip->gpio_state &= ~(1 << gpio);
> +	writel(chip->gpio_state, mm_gc->regs + ALTERA_GPIO_DATA_OFFSET);
> +
> +	/* Set the GPIO bit in shadow register and set direction as output */
> +	chip->gpio_dir |= (1 << gpio);
> +	writel(chip->gpio_dir, mm_gc->regs + ALTERA_GPIO_DIR_OFFSET);
> +
> +	spin_unlock_irqrestore(&chip->gpio_lock, flags);
> +
> +	return 0;
> +}
> +
> +/*
> + * altera_gpio_save_regs - Set initial values of GPIO pins
> + * @mm_gc: pointer to memory mapped GPIO chip structure
> + */
> +static void altera_gpio_save_regs(struct of_mm_gpio_chip *mm_gc)
> +{
> +	struct altera_gpio_instance *chip =
> +	    container_of(mm_gc, struct altera_gpio_instance, mmchip);

This container_of is used several times.  It would be worth creating a
to_altera_gpio() macro.

> +
> +	writel(chip->gpio_state, mm_gc->regs + ALTERA_GPIO_DATA_OFFSET);
> +	writel(chip->gpio_dir, mm_gc->regs + ALTERA_GPIO_DIR_OFFSET);
> +}
> +
> +/*
> + * altera_gpio_of_probe - Probe method for the GPIO device.
> + * @np: pointer to device tree node
> + *
> + * This function probes the GPIO device in the device tree. It initializes the
> + * driver data structure. It returns 0, if the driver is bound to the GPIO
> + * device, or a negative value if there is an error.
> + */
> +static int __devinit altera_gpio_of_probe(struct device_node *np)
> +{
> +	struct altera_gpio_instance *chip;
> +	int status = 0;
> +	const u32 *tree_info;

const __be32 *tree_info;

> +
> +	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> +	if (!chip)
> +		return -ENOMEM;
> +
> +	/* Update GPIO state shadow register with default value */
> +	tree_info = of_get_property(np, "resetvalue", NULL);
> +	if (tree_info)
> +		chip->gpio_state = be32_to_cpup(tree_info);

This would be better:
	tree_info = of_get_property(np, "resetvalue", &len);
	if (tree_info & len >= sizeof(u32))
		chip->gpio_state = be32_to_cpup(tree_info);

> +
> +	/* Update GPIO direction shadow register with default value */
> +	chip->gpio_dir = 0; /* By default, all pins are inputs */
> +
> +	/* Check device node for device width */
> +	chip->mmchip.gc.ngpio = 32; /* By default assume full GPIO controller */
> +	tree_info = of_get_property(np, "width", NULL);
> +	if (tree_info)
> +		chip->mmchip.gc.ngpio = be32_to_cpup(tree_info);
> +
> +	spin_lock_init(&chip->gpio_lock);
> +
> +	chip->mmchip.gc.direction_input = altera_gpio_dir_in;
> +	chip->mmchip.gc.direction_output = altera_gpio_dir_out;
> +	chip->mmchip.gc.get = altera_gpio_get;
> +	chip->mmchip.gc.set = altera_gpio_set;
> +
> +	chip->mmchip.save_regs = altera_gpio_save_regs;
> +
> +	/* Call the OF gpio helper to setup and register the GPIO device */
> +	status = of_mm_gpiochip_add(np, &chip->mmchip);
> +	if (status) {
> +		kfree(chip);
> +		pr_err("%s: error in probe function with status %d\n",
> +		       np->full_name, status);
> +		return status;
> +	}
> +	pr_info(DRV_NAME ": %s: registered\n", np->full_name);
> +	return 0;
> +}
> +
> +static struct of_device_id altera_gpio_of_match[] __devinitdata = {
> +	{ .compatible = "ALTR,pio-1.0", },
> +	{},
> +};
> +
> +static int __init altera_gpio_init(void)
> +{
> +	struct device_node *np;
> +
> +	for_each_matching_node(np, altera_gpio_of_match)
> +		altera_gpio_of_probe(np);
> +
> +	return 0;
> +}
> +
> +/* Make sure we get initialized before anyone else tries to use us */
> +subsys_initcall(altera_gpio_init);

Ugh.  I'd *really* rather see this implemented as a platform_driver,
but I understand the dependency requirements that it be done before
anyone tries to use it and there isn't a generic solution for
dependency management yet.

However, calling the subsys_initcall() from inside the driver code and
blindly looking for gpio chips is definitely not a good idea because
it doesn't provide architecture code the opportunity to override the
device registration if it needs to.  The altera_gpio_init() and
subsys_initcall() functions should be omitted from this patch and
instead be explicitly called from the board support code.

Otherwise the driver looks good.

g.

> +/* No exit call at the moment as we cannot unregister of GPIO chips */
> +
> +MODULE_DESCRIPTION("Altera GPIO driver");
> +MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:" DRV_NAME);
> -- 
> 1.7.3.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
