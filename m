Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab2K3LVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:21:07 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50172 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab2K3LVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:21:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 1/3] gpio / ACPI: add ACPI support
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linus.walleij@linaro.org, w.sang@pengutronix.de,
        rafael.j.wysocki@intel.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
        broonie@opensource.wolfsonmicro.com, khali@linux-fr.org,
        ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
In-Reply-To: <1353435212-15325-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com> <1353435212-15325-1-git-send-email-mika.westerberg@linux.intel.com> <1353435212-15325-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Fri, 30 Nov 2012 11:20:57 +0000
Message-Id: <20121130112057.D34CA3E14C4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 20:13:30 +0200, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> From: Mathias Nyman <mathias.nyman@linux.intel.com>
> 
> Add support for translating ACPI GPIO pin numbers to Linux GPIO API pins.
> Needs a gpio controller driver with the acpi handler hook set.
> 
> Drivers can use acpi_get_gpio() to translate ACPI5 GpioIO and GpioInt
> resources to Linux GPIO's.
> 
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

This series goes together, so feel free to take it in whatever tree the
rest are merged through.

g.

> ---
>  drivers/gpio/Kconfig        |    4 ++++
>  drivers/gpio/Makefile       |    1 +
>  drivers/gpio/gpiolib-acpi.c |   54 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/acpi_gpio.h   |   19 +++++++++++++++
>  4 files changed, 78 insertions(+)
>  create mode 100644 drivers/gpio/gpiolib-acpi.c
>  create mode 100644 include/linux/acpi_gpio.h
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index f11d8e3..5c9b384 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -49,6 +49,10 @@ config OF_GPIO
>  	def_bool y
>  	depends on OF
>  
> +config GPIO_ACPI
> +	def_bool y
> +	depends on ACPI
> +
>  config DEBUG_GPIO
>  	bool "Debug GPIO calls"
>  	depends on DEBUG_KERNEL
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 9aeed67..420dbac 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -4,6 +4,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
>  
>  obj-$(CONFIG_GPIOLIB)		+= gpiolib.o devres.o
>  obj-$(CONFIG_OF_GPIO)		+= gpiolib-of.o
> +obj-$(CONFIG_GPIO_ACPI)		+= gpiolib-acpi.o
>  
>  # Device drivers. Generally keep list sorted alphabetically
>  obj-$(CONFIG_GPIO_GENERIC)	+= gpio-generic.o
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> new file mode 100644
> index 0000000..cbad6e9
> --- /dev/null
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -0,0 +1,54 @@
> +/*
> + * ACPI helpers for GPIO API
> + *
> + * Copyright (C) 2012, Intel Corporation
> + * Authors: Mathias Nyman <mathias.nyman@linux.intel.com>
> + *          Mika Westerberg <mika.westerberg@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/gpio.h>
> +#include <linux/export.h>
> +#include <linux/acpi_gpio.h>
> +#include <linux/acpi.h>
> +
> +static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
> +{
> +	if (!gc->dev)
> +		return false;
> +
> +	return ACPI_HANDLE(gc->dev) == data;
> +}
> +
> +/**
> + * acpi_get_gpio() - Translate ACPI GPIO pin to GPIO number usable with GPIO API
> + * @path:	ACPI GPIO controller full path name, (e.g. "\\_SB.GPO1")
> + * @pin:	ACPI GPIO pin number (0-based, controller-relative)
> + *
> + * Returns GPIO number to use with Linux generic GPIO API, or errno error value
> + */
> +
> +int acpi_get_gpio(char *path, int pin)
> +{
> +	struct gpio_chip *chip;
> +	acpi_handle handle;
> +	acpi_status status;
> +
> +	status = acpi_get_handle(NULL, path, &handle);
> +	if (ACPI_FAILURE(status))
> +		return -ENODEV;
> +
> +	chip = gpiochip_find(handle, acpi_gpiochip_find);
> +	if (!chip)
> +		return -ENODEV;
> +
> +	if (!gpio_is_valid(chip->base + pin))
> +		return -EINVAL;
> +
> +	return chip->base + pin;
> +}
> +EXPORT_SYMBOL_GPL(acpi_get_gpio);
> diff --git a/include/linux/acpi_gpio.h b/include/linux/acpi_gpio.h
> new file mode 100644
> index 0000000..91615a3
> --- /dev/null
> +++ b/include/linux/acpi_gpio.h
> @@ -0,0 +1,19 @@
> +#ifndef _LINUX_ACPI_GPIO_H_
> +#define _LINUX_ACPI_GPIO_H_
> +
> +#include <linux/errno.h>
> +
> +#ifdef CONFIG_GPIO_ACPI
> +
> +int acpi_get_gpio(char *path, int pin);
> +
> +#else /* CONFIG_GPIO_ACPI */
> +
> +static inline int acpi_get_gpio(char *path, int pin)
> +{
> +	return -ENODEV;
> +}
> +
> +#endif /* CONFIG_GPIO_ACPI */
> +
> +#endif /* _LINUX_ACPI_GPIO_H_ */
> -- 
> 1.7.10.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
