Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2KTMmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:42:09 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:55334 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab2KTMmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:42:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, w.sang@pengutronix.de,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, broonie@opensource.wolfsonmicro.com,
        khali@linux-fr.org, ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 1/3] gpio / ACPI: add ACPI support
Date: Tue, 20 Nov 2012 13:46:32 +0100
Message-ID: <3506312.K8Cp3lqijn@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353407384-26880-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com> <1353407384-26880-2-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 20, 2012 12:29:42 PM Mika Westerberg wrote:
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
> ---
>  drivers/gpio/Kconfig        |    4 ++++
>  drivers/gpio/Makefile       |    1 +
>  drivers/gpio/gpiolib-acpi.c |   56 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/acpi_gpio.h   |   19 +++++++++++++++
>  4 files changed, 80 insertions(+)
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
> index 0000000..8285144
> --- /dev/null
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -0,0 +1,56 @@
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
> +	acpi_handle handle = data;
> +
> +	if (!gc->dev)
> +		return false;
> +
> +	return ACPI_HANDLE(gc->dev) == handle;

I would compare ACPI_HANDLE(gc->dev) to data directly here, but that's just
a matter of cleanliness. :-)

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

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
