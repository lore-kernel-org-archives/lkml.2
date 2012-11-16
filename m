Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023Ab2KPGvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:51:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:51162 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab2KPGvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:51:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,261,1352102400"; 
   d="scan'208";a="218583933"
Date: Fri, 16 Nov 2012 08:54:48 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 1/3] gpio / ACPI: add ACPI support
Message-ID: <20121116065448.GN17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
 <1352977397-2280-2-git-send-email-mika.westerberg@linux.intel.com>
 <3699628.UkRaSOtjaA@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3699628.UkRaSOtjaA@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 02:34:22AM +0100, Rafael J. Wysocki wrote:
> On Thursday, November 15, 2012 01:03:15 PM Mika Westerberg wrote:
> > From: Mathias Nyman <mathias.nyman@linux.intel.com>
> > 
> > Add support for translating ACPI GPIO pin numbers to Linux GPIO API pins.
> > Needs a gpio controller driver with the acpi handler hook set.
> > 
> > Drivers can use acpi_get_gpio() to translate ACPI5 GpioIO and GpioInt
> > resources to Linux GPIO's.
> > 
> > Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/gpio/Kconfig        |    4 ++++
> >  drivers/gpio/Makefile       |    1 +
> >  drivers/gpio/gpiolib-acpi.c |   56 +++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/acpi_gpio.h   |   19 +++++++++++++++
> >  4 files changed, 80 insertions(+)
> >  create mode 100644 drivers/gpio/gpiolib-acpi.c
> >  create mode 100644 include/linux/acpi_gpio.h
> > 
> > diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> > index f11d8e3..5c9b384 100644
> > --- a/drivers/gpio/Kconfig
> > +++ b/drivers/gpio/Kconfig
> > @@ -49,6 +49,10 @@ config OF_GPIO
> >  	def_bool y
> >  	depends on OF
> >  
> > +config GPIO_ACPI
> > +	def_bool y
> > +	depends on ACPI
> > +
> >  config DEBUG_GPIO
> >  	bool "Debug GPIO calls"
> >  	depends on DEBUG_KERNEL
> > diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> > index 9aeed67..420dbac 100644
> > --- a/drivers/gpio/Makefile
> > +++ b/drivers/gpio/Makefile
> > @@ -4,6 +4,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
> >  
> >  obj-$(CONFIG_GPIOLIB)		+= gpiolib.o devres.o
> >  obj-$(CONFIG_OF_GPIO)		+= gpiolib-of.o
> > +obj-$(CONFIG_GPIO_ACPI)		+= gpiolib-acpi.o
> >  
> >  # Device drivers. Generally keep list sorted alphabetically
> >  obj-$(CONFIG_GPIO_GENERIC)	+= gpio-generic.o
> > diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> > new file mode 100644
> > index 0000000..8ef9831
> > --- /dev/null
> > +++ b/drivers/gpio/gpiolib-acpi.c
> > @@ -0,0 +1,56 @@
> > +/*
> > + * ACPI helpers for GPIO API
> > + *
> > + * Copyright (C) 2012, Intel Corporation
> > + * Authors: Mathias Nyman <mathias.nyman@linux.intel.com>
> > + *          Mika Westerberg <mika.westerberg@linux.intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/errno.h>
> > +#include <linux/gpio.h>
> > +#include <linux/export.h>
> > +#include <linux/acpi_gpio.h>
> > +#include <linux/acpi.h>
> > +
> > +static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
> > +{
> > +	acpi_handle handle = data;
> > +
> > +	if (!gc->dev)
> > +		return false;
> > +
> > +	return gc->dev->acpi_handle == handle;
> 
> I'd prefer DEVICE_ACPI_HANDLE() to be used in such places, we may want to
> replace it with something else in the future or make it work differently.

Sure but then we need to make it available for drivers as well when
!CONFIG_ACPI. Something like below is needed.

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 2dca46f..01a26f9 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -416,7 +416,6 @@ acpi_handle acpi_get_child(acpi_handle, u64);
 int acpi_is_root_bridge(acpi_handle);
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
-#define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->acpi_handle))
 
 int acpi_enable_wakeup_device_power(struct acpi_device *dev, int state);
 int acpi_disable_wakeup_device_power(struct acpi_device *dev);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index b4c9984..c4c58ff 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -28,6 +28,8 @@
 #include <linux/ioport.h>	/* for struct resource */
 #include <linux/device.h>
 
+#define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->acpi_handle))
+
 #ifdef	CONFIG_ACPI
 
 #ifndef _LINUX
