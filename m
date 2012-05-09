Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761227Ab2EIVNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:13:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52725 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678Ab2EIVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:13:42 -0400
Date: Wed, 9 May 2012 14:13:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Manohar Vanga <manohar.vanga@cern.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v4 1/3] Staging: IndustryPack bus for the Linux Kernel
Message-ID: <20120509211338.GA23322@kroah.com>
References: <1336570041-32724-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336570041-32724-1-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 03:27:19PM +0200, Samuel Iglesias Gonsalvez wrote:
> Add IndustryPack bus support for the Linux Kernel.
> 
> This is a virtual bus that allows to perform all the operations between
> carrier and mezzanine boards.

Note, I've accepted this patch, just a few comments that you might want
to fix up in future patches you send to me:

> +++ b/drivers/staging/Kconfig
> @@ -24,6 +24,8 @@ menuconfig STAGING
>  
>  if STAGING
>  
> +source "drivers/staging/ipack/Kconfig"
> +
>  source "drivers/staging/et131x/Kconfig"
>  
>  source "drivers/staging/slicoss/Kconfig"

Why put yourself at the front of the list, and not at the end?

> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index ffe7d44..23eb56b 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_OCTEON_ETHERNET)	+= octeon/
>  obj-$(CONFIG_VT6655)		+= vt6655/
>  obj-$(CONFIG_VT6656)		+= vt6656/
>  obj-$(CONFIG_VME_BUS)		+= vme/
> +obj-$(CONFIG_IPACK_BUS)		+= ipack/
>  obj-$(CONFIG_DX_SEP)            += sep/
>  obj-$(CONFIG_IIO)		+= iio/
>  obj-$(CONFIG_ZRAM)		+= zram/

Same here, why not at the end?

> diff --git a/drivers/staging/ipack/Kconfig b/drivers/staging/ipack/Kconfig
> new file mode 100644
> index 0000000..e20187f
> --- /dev/null
> +++ b/drivers/staging/ipack/Kconfig
> @@ -0,0 +1,9 @@
> +#
> +# IPACK configuration.
> +#
> +
> +menuconfig IPACK_BUS
> +	tristate "IndustryPack bus support"
> +	---help---
> +	  If you say Y here you get support for the IndustryPack Framework.
> +

You are going to have to flush this help out more, you do know that,
right?

> diff --git a/drivers/staging/ipack/Makefile b/drivers/staging/ipack/Makefile
> new file mode 100644
> index 0000000..56e2340
> --- /dev/null
> +++ b/drivers/staging/ipack/Makefile
> @@ -0,0 +1,4 @@
> +#
> +# Makefile for the IPACK bridge device drivers.
> +#
> +obj-$(CONFIG_IPACK_BUS)		+= ipack.o
> diff --git a/drivers/staging/ipack/TODO b/drivers/staging/ipack/TODO
> new file mode 100644
> index 0000000..167ae4d
> --- /dev/null
> +++ b/drivers/staging/ipack/TODO
> @@ -0,0 +1,21 @@
> +				TODO
> +				====
> +Introduction
> +============
> +
> +These drivers add support for IndustryPack devices: carrier and mezzanine
> +boards.
> +
> +The ipack driver is just an abstraction of the bus providing the common
> +operations between the two kind of boards.
> +
> +TODO
> +====
> +
> +Ipack
> +-----
> +
> +* The structures and API exported can be improved a lot. For example, the
> +  way to unregistering mezzanine devices, doing the mezzanine driver a call to
> +  remove_device() to notify the carrier driver, or the opposite with the call to
> +  the ipack_driver_ops' remove() function could be improved.

I need an email address in this file for who to cc: patches to, look at
the other TODO files in drivers/staging/ for examples of what needs to
be here.


> diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
> new file mode 100644
> index 0000000..a54bfd7
> --- /dev/null
> +++ b/drivers/staging/ipack/ipack.c
> @@ -0,0 +1,175 @@
> +/*
> + * Industry-pack bus support functions.
> + *
> + * (C) 2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
> + * (C) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.

Do you really mean "any later version"?  If so, fine, just be aware of
this please.

> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include "ipack.h"
> +
> +#define to_ipack_dev(device) container_of(device, struct ipack_device, dev)
> +#define to_ipack_driver(drv) container_of(drv, struct ipack_driver, driver)
> +
> +/* used when allocating bus numbers */
> +#define IPACK_MAXBUS              64
> +
> +static DEFINE_MUTEX(ipack_mutex);
> +
> +struct ipack_busmap {
> +	unsigned long busmap[IPACK_MAXBUS / (8*sizeof(unsigned long))];
> +};
> +static struct ipack_busmap busmap;
> +
> +static int ipack_bus_match(struct device *device, struct device_driver *driver)
> +{
> +	int ret;
> +	struct ipack_device *dev = to_ipack_dev(device);
> +	struct ipack_driver *drv = to_ipack_driver(driver);
> +
> +	if (!drv->ops->match)
> +		return -EINVAL;
> +
> +	ret = drv->ops->match(dev);
> +	if (ret)
> +		dev->driver = drv;
> +
> +	return 0;
> +}
> +
> +static int ipack_bus_probe(struct device *device)
> +{
> +	struct ipack_device *dev = to_ipack_dev(device);
> +
> +	if (!dev->driver->ops->probe)
> +		return -EINVAL;
> +
> +	return dev->driver->ops->probe(dev);
> +}
> +
> +static int ipack_bus_remove(struct device *device)
> +{
> +	struct ipack_device *dev = to_ipack_dev(device);
> +
> +	if (!dev->driver->ops->remove)
> +		return -EINVAL;
> +
> +	dev->driver->ops->remove(dev);
> +	return 0;
> +}
> +
> +static struct bus_type ipack_bus_type = {
> +	.name  = "ipack",
> +	.probe = ipack_bus_probe,
> +	.match = ipack_bus_match,
> +	.remove = ipack_bus_remove,
> +};
> +
> +static int ipack_assign_bus_number(void)
> +{
> +	int busnum;
> +
> +	mutex_lock(&ipack_mutex);
> +	busnum = find_next_zero_bit(busmap.busmap, IPACK_MAXBUS, 1);

Nice, but you also can use the ics interface as well, that keeps you
from having to have MAXBUS busses, if you want to.


> +
> +	if (busnum >= IPACK_MAXBUS) {
> +		pr_err("too many buses\n");
> +		busnum = -1;
> +		goto error_find_busnum;
> +	}
> +
> +	set_bit(busnum, busmap.busmap);
> +
> +error_find_busnum:
> +	mutex_unlock(&ipack_mutex);
> +	return busnum;
> +}
> +
> +int ipack_bus_register(struct ipack_bus_device *bus)
> +{
> +	int bus_nr;
> +
> +	bus_nr = ipack_assign_bus_number();
> +	if (bus_nr < 0)
> +		return -1;
> +
> +	bus->bus_nr = bus_nr;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipack_bus_register);

Don't you need to register the bus with the driver core here?

> +
> +int ipack_bus_unregister(struct ipack_bus_device *bus)
> +{
> +	mutex_lock(&ipack_mutex);
> +	clear_bit(bus->bus_nr, busmap.busmap);
> +	mutex_unlock(&ipack_mutex);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipack_bus_unregister);

And unregister it here?

> +
> +int ipack_driver_register(struct ipack_driver *edrv)
> +{
> +	edrv->driver.bus = &ipack_bus_type;
> +	return driver_register(&edrv->driver);
> +}
> +EXPORT_SYMBOL_GPL(ipack_driver_register);
> +
> +void ipack_driver_unregister(struct ipack_driver *edrv)
> +{
> +	driver_unregister(&edrv->driver);
> +}
> +EXPORT_SYMBOL_GPL(ipack_driver_unregister);
> +
> +static void ipack_device_release(struct device *dev)
> +{
> +}

Weee.  As per the in-kernel documentation, I get to publically mock you
for doing something as foolish as thinking you are smarter than the
kernel by just creating an empty function for the release callback.

Did you think this really is the solution for when the kernel is
complaining to you about the fact that you need a callback function
here?  Surely I didn't just put that logic in the core for no good
reason now, right?

Please fix this up NOW.

> +++ b/drivers/staging/ipack/ipack.h
> @@ -0,0 +1,183 @@
> +/*
> + * Industry-pack bus.
> + *
> + * (C) 2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
> + * (C) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.

Again, "any later version", are you sure?  Be very sure about this
please.

> +struct ipack_device {
> +	char board_name[IPACK_BOARD_NAME_SIZE];

Why not use dev->name?

> +	char bus_name[IPACK_BOARD_NAME_SIZE];
> +	unsigned int bus_nr;
> +	unsigned int slot;
> +	unsigned int irq;
> +	struct ipack_driver *driver;
> +	struct ipack_bus_ops *ops;
> +	struct ipack_addr_space id_space;
> +	struct ipack_addr_space io_space;
> +	struct ipack_addr_space mem_space;
> +	struct device dev;
> +};

thanks,

greg k-h
