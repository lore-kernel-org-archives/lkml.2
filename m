Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2KHPzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:55:43 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50714 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2KHPzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:55:39 -0500
MIME-Version: 1.0
In-Reply-To: <1351928793-14375-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <1351928793-14375-2-git-send-email-mika.westerberg@linux.intel.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 8 Nov 2012 15:55:18 +0000
X-Google-Sender-Auth: 1Gb_01ekoLbEomLBczB4DV0TqEI
Message-ID: <CACxGe6tVcqoSg03JtcTdLP5GakyKM-24D8uK2mQj+1iiSE8Yog@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

On Sat, Nov 3, 2012 at 7:46 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> From: Mathias Nyman <mathias.nyman@linux.intel.com>
>
> Add support for translating ACPI GPIO pin numbers to Linux GPIO API pins.
> Needs a gpio controller driver with the acpi handler hook set.
>
> Drivers can use acpi_get_gpio() to translate ACPI5 GpioIO and GpioInt
> resources to Linux GPIO's.

How does the mapping work? Is the ACPI gpio number space kept
completely separate from the Linux GPIO numbers, or is there any
attempt to line up ACPI and Linux GPIO numbering? From my reading, it
/looks/ like the ACPI GPIO numbering is controller-local (no single
large global space) because both a full path and a pin number are
specified, but I'd like to know for sure.

> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/gpio/Kconfig        |    4 +++
>  drivers/gpio/Makefile       |    1 +
>  drivers/gpio/gpiolib-acpi.c |   60 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/acpi_gpio.h   |   19 ++++++++++++++
>  4 files changed, 84 insertions(+)
>  create mode 100644 drivers/gpio/gpiolib-acpi.c
>  create mode 100644 include/linux/acpi_gpio.h
>
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index d055cee..2f1905b 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -49,6 +49,10 @@ config OF_GPIO
>         def_bool y
>         depends on OF && !SPARC
>
> +config ACPI_GPIO

Nit: Can you flip this around to GPIO_ACPI? I know OF_GPIO is the
other way around, but it should be changed.

> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> new file mode 100644
> index 0000000..ef56ea4
> --- /dev/null
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -0,0 +1,60 @@
> +/*
> + * ACPI helpers for GPIO API
> + *
> + * Copyright (C) 2012, Intel Corporation
> + * Author: Mathias Nyman <mathias.nyman@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/gpio.h>
> +#include <linux/module.h>
> +#include <linux/acpi_gpio.h>
> +#include <linux/acpi.h>
> +
> +static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
> +{
> +       acpi_handle handle = data;
> +       acpi_handle gc_handle;
> +
> +       if (!gc->dev)
> +               return false;
> +
> +       gc_handle = gc->dev->acpi_handle;
> +       if (!gc_handle)
> +               return false;

This test is redundant with the next one... unless 'handle' is also NULL :-)

Is it at all possible for multiple gpiochips to be used for a single
ACPI gpio controller node? Such as if the gpio controller has multiple
banks that should be controlled separately? If so then this won't be
sufficient. I've got the same issue with DT support where the find
function needs to also check if the pin is provided by that specific
gpiochip.

Overall the patch looks good, but I need to see how it is used. It
would be really nice if device drivers could use basically the same
interface to obtain Linux gpio numbers regardless of if the backing
data was ACPI or DT. This API is one level below that.

> +
> +       return gc_handle == handle;
> +}
> +
> +/**
> + * acpi_get_gpio() - Translate ACPI GPIO pin to GPIO number usable with GPIO API
> + * @path:      ACPI GPIO controller full path name, (e.g. "\\_SB.GPO1")
> + * @pin:       ACPI GPIO pin number (0-based, controller-relative)
> + *
> + * Returns GPIO number to use with Linux generic GPIO API, or errno error value
> + */
> +
> +int acpi_get_gpio(char *path, int pin)
> +{
> +       struct gpio_chip *chip;
> +       acpi_handle handle;
> +       acpi_status status;
> +
> +       status = acpi_get_handle(NULL, path, &handle);
> +       if (ACPI_FAILURE(status))
> +               return -ENODEV;
> +
> +       chip = gpiochip_find(handle, acpi_gpiochip_find);
> +       if (!chip)
> +               return -ENODEV;
> +
> +       if (!gpio_is_valid(chip->base + pin))
> +               return -EINVAL;
> +
> +       return chip->base + pin;
> +}
> +EXPORT_SYMBOL(acpi_get_gpio);
> diff --git a/include/linux/acpi_gpio.h b/include/linux/acpi_gpio.h
> new file mode 100644
> index 0000000..e025664
> --- /dev/null
> +++ b/include/linux/acpi_gpio.h
> @@ -0,0 +1,19 @@
> +#ifndef _LINUX_ACPI_GPIO_H_
> +#define _LINUX_ACPI_GPIO_H_
> +
> +#include <linux/errno.h>
> +
> +#ifdef CONFIG_ACPI_GPIO
> +
> +int acpi_get_gpio(char *path, int pin);
> +
> +#else /* CONFIG_ACPI_GPIO */
> +
> +static inline int acpi_get_gpio(char *path, int pin)
> +{
> +       return -ENODEV;
> +}
> +
> +#endif /* CONFIG_ACPI_GPIO */
> +
> +#endif /* _LINUX_ACPI_GPIO_H_ */
> --
> 1.7.10.4
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
