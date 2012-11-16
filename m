Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab2KPICo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:02:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:41747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab2KPICm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:02:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,262,1352102400"; 
   d="scan'208";a="169098703"
Date: Fri, 16 Nov 2012 10:05:49 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 1/3] gpio / ACPI: add ACPI support
Message-ID: <20121116080549.GO17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
 <1352977397-2280-2-git-send-email-mika.westerberg@linux.intel.com>
 <3699628.UkRaSOtjaA@vostro.rjw.lan>
 <20121116065448.GN17774@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116065448.GN17774@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 08:54:48AM +0200, Mika Westerberg wrote:
> On Fri, Nov 16, 2012 at 02:34:22AM +0100, Rafael J. Wysocki wrote:
> > On Thursday, November 15, 2012 01:03:15 PM Mika Westerberg wrote:
> > > From: Mathias Nyman <mathias.nyman@linux.intel.com>
> > > 
> > > Add support for translating ACPI GPIO pin numbers to Linux GPIO API pins.
> > > Needs a gpio controller driver with the acpi handler hook set.
> > > 
> > > Drivers can use acpi_get_gpio() to translate ACPI5 GpioIO and GpioInt
> > > resources to Linux GPIO's.
> > > 
> > > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > ---
> > >  drivers/gpio/Kconfig        |    4 ++++
> > >  drivers/gpio/Makefile       |    1 +
> > >  drivers/gpio/gpiolib-acpi.c |   56 +++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/acpi_gpio.h   |   19 +++++++++++++++
> > >  4 files changed, 80 insertions(+)
> > >  create mode 100644 drivers/gpio/gpiolib-acpi.c
> > >  create mode 100644 include/linux/acpi_gpio.h
> > > 
> > > diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> > > index f11d8e3..5c9b384 100644
> > > --- a/drivers/gpio/Kconfig
> > > +++ b/drivers/gpio/Kconfig
> > > @@ -49,6 +49,10 @@ config OF_GPIO
> > >  	def_bool y
> > >  	depends on OF
> > >  
> > > +config GPIO_ACPI
> > > +	def_bool y
> > > +	depends on ACPI
> > > +
> > >  config DEBUG_GPIO
> > >  	bool "Debug GPIO calls"
> > >  	depends on DEBUG_KERNEL
> > > diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> > > index 9aeed67..420dbac 100644
> > > --- a/drivers/gpio/Makefile
> > > +++ b/drivers/gpio/Makefile
> > > @@ -4,6 +4,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
> > >  
> > >  obj-$(CONFIG_GPIOLIB)		+= gpiolib.o devres.o
> > >  obj-$(CONFIG_OF_GPIO)		+= gpiolib-of.o
> > > +obj-$(CONFIG_GPIO_ACPI)		+= gpiolib-acpi.o
> > >  
> > >  # Device drivers. Generally keep list sorted alphabetically
> > >  obj-$(CONFIG_GPIO_GENERIC)	+= gpio-generic.o
> > > diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> > > new file mode 100644
> > > index 0000000..8ef9831
> > > --- /dev/null
> > > +++ b/drivers/gpio/gpiolib-acpi.c
> > > @@ -0,0 +1,56 @@
> > > +/*
> > > + * ACPI helpers for GPIO API
> > > + *
> > > + * Copyright (C) 2012, Intel Corporation
> > > + * Authors: Mathias Nyman <mathias.nyman@linux.intel.com>
> > > + *          Mika Westerberg <mika.westerberg@linux.intel.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + */
> > > +
> > > +#include <linux/errno.h>
> > > +#include <linux/gpio.h>
> > > +#include <linux/export.h>
> > > +#include <linux/acpi_gpio.h>
> > > +#include <linux/acpi.h>
> > > +
> > > +static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
> > > +{
> > > +	acpi_handle handle = data;
> > > +
> > > +	if (!gc->dev)
> > > +		return false;
> > > +
> > > +	return gc->dev->acpi_handle == handle;
> > 
> > I'd prefer DEVICE_ACPI_HANDLE() to be used in such places, we may want to
> > replace it with something else in the future or make it work differently.
> 
> Sure but then we need to make it available for drivers as well when
> !CONFIG_ACPI. Something like below is needed.

One more thing, sometimes we want to assign the handle like in the case of
SPI controller driver we set the master->dev.acpi_handle. In that case we
can't use DEVICE_ACPI_HANDLE() as is. Should we just do something like:

	master->dev.acpi_handle = pdev->dev.acpi_handle;

or should we introduce some new macro that supports this?
