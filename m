Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab2KHTfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:35:01 -0500
Received: from mga14.intel.com ([143.182.124.37]:8130 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500Ab2KHTe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:34:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,739,1344236400"; 
   d="scan'208";a="166083428"
Date: Thu, 8 Nov 2012 21:38:09 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
Message-ID: <20121108193808.GB16012@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <1351928793-14375-2-git-send-email-mika.westerberg@linux.intel.com>
 <CACxGe6tVcqoSg03JtcTdLP5GakyKM-24D8uK2mQj+1iiSE8Yog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6tVcqoSg03JtcTdLP5GakyKM-24D8uK2mQj+1iiSE8Yog@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 03:55:18PM +0000, Grant Likely wrote:
> Hi Mika,
> 
> On Sat, Nov 3, 2012 at 7:46 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > From: Mathias Nyman <mathias.nyman@linux.intel.com>
> >
> > Add support for translating ACPI GPIO pin numbers to Linux GPIO API pins.
> > Needs a gpio controller driver with the acpi handler hook set.
> >
> > Drivers can use acpi_get_gpio() to translate ACPI5 GpioIO and GpioInt
> > resources to Linux GPIO's.
> 
> How does the mapping work? Is the ACPI gpio number space kept
> completely separate from the Linux GPIO numbers, or is there any
> attempt to line up ACPI and Linux GPIO numbering? From my reading, it
> /looks/ like the ACPI GPIO numbering is controller-local (no single
> large global space) because both a full path and a pin number are
> specified, but I'd like to know for sure.

Yes, the ACPI GPIO number from GpioIO/GpioInt resources are controller
relative and we use the path from the resource to find the actual
controller.

> 
> > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/gpio/Kconfig        |    4 +++
> >  drivers/gpio/Makefile       |    1 +
> >  drivers/gpio/gpiolib-acpi.c |   60 +++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/acpi_gpio.h   |   19 ++++++++++++++
> >  4 files changed, 84 insertions(+)
> >  create mode 100644 drivers/gpio/gpiolib-acpi.c
> >  create mode 100644 include/linux/acpi_gpio.h
> >
> > diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> > index d055cee..2f1905b 100644
> > --- a/drivers/gpio/Kconfig
> > +++ b/drivers/gpio/Kconfig
> > @@ -49,6 +49,10 @@ config OF_GPIO
> >         def_bool y
> >         depends on OF && !SPARC
> >
> > +config ACPI_GPIO
> 
> Nit: Can you flip this around to GPIO_ACPI? I know OF_GPIO is the
> other way around, but it should be changed.

Sure.

> 
> > diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> > new file mode 100644
> > index 0000000..ef56ea4
> > --- /dev/null
> > +++ b/drivers/gpio/gpiolib-acpi.c
> > @@ -0,0 +1,60 @@
> > +/*
> > + * ACPI helpers for GPIO API
> > + *
> > + * Copyright (C) 2012, Intel Corporation
> > + * Author: Mathias Nyman <mathias.nyman@linux.intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/errno.h>
> > +#include <linux/gpio.h>
> > +#include <linux/module.h>
> > +#include <linux/acpi_gpio.h>
> > +#include <linux/acpi.h>
> > +
> > +static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
> > +{
> > +       acpi_handle handle = data;
> > +       acpi_handle gc_handle;
> > +
> > +       if (!gc->dev)
> > +               return false;
> > +
> > +       gc_handle = gc->dev->acpi_handle;
> > +       if (!gc_handle)
> > +               return false;
> 
> This test is redundant with the next one... unless 'handle' is also NULL :-)
> 
> Is it at all possible for multiple gpiochips to be used for a single
> ACPI gpio controller node? Such as if the gpio controller has multiple
> banks that should be controlled separately? If so then this won't be
> sufficient. I've got the same issue with DT support where the find
> function needs to also check if the pin is provided by that specific
> gpiochip.

AFAIK no but I'll let Mathias to answer that as he knows this better.

> Overall the patch looks good, but I need to see how it is used. It
> would be really nice if device drivers could use basically the same
> interface to obtain Linux gpio numbers regardless of if the backing
> data was ACPI or DT. This API is one level below that.

Yeah, this patch just mimics the DT version but in general it would be
better if there was only one API to get the GPIO. There has been discussion
about adding gpio_get() or something similar which could perhaps be used to
abstract away DT or ACPI.

We use this in a driver so that we walk through the ACPI resources for a
given device (if we have the ACPI handle) and parse the GpioIO/GpioInt
resources like:

	struct acpi_resource_gpio *acpi_gpio;
	struct acpi_device *adev;
	acpi_resource *res;
	int gpio;

	/* obtain the ACPI device from handle */
	...

	/* walk through the resources attached to adev */
	...
		switch (res->type) {
		case ACPI_RESOURCE_TYPE_GPIO:
			acpi_gpio = &res->data.gpio;

			gpio = acpi_get_gpio(acpi_gpio->resource_source.string_ptr,
					     acpi_gpio->pin_table[0]);
			...
		}
