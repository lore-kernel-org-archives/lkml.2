Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2KIDs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 22:48:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:23434 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab2KIDsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 22:48:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,741,1344236400"; 
   d="scan'208";a="246247681"
Date: Fri, 9 Nov 2012 05:51:34 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c / ACPI: add ACPI enumeration support
Message-ID: <20121109035134.GG16012@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <1351928793-14375-4-git-send-email-mika.westerberg@linux.intel.com>
 <CACxGe6vgKrqu9UwDc3gytMWpODhV4Q6yezQRwQmg730BpBxXrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6vgKrqu9UwDc3gytMWpODhV4Q6yezQRwQmg730BpBxXrA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 06:58:47PM +0000, Grant Likely wrote:
> On Sat, Nov 3, 2012 at 7:46 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
> > and configure the I2C slave devices behind the I2C controller. This patch
> > adds helper functions to support I2C slave enumeration.
> >
> > An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
> > in order to get its slave devices enumerated, created and bound to the
> > corresponding ACPI handle.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/Kconfig     |    6 ++
> >  drivers/acpi/Makefile    |    1 +
> >  drivers/acpi/acpi_i2c.c  |  234 ++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/i2c/i2c-core.c   |    9 ++
> >  include/linux/acpi_i2c.h |   29 ++++++
> >  5 files changed, 279 insertions(+)
> >  create mode 100644 drivers/acpi/acpi_i2c.c
> >  create mode 100644 include/linux/acpi_i2c.h
> >
> > diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> > index 119d58d..0300bf6 100644
> > --- a/drivers/acpi/Kconfig
> > +++ b/drivers/acpi/Kconfig
> > @@ -181,6 +181,12 @@ config ACPI_DOCK
> >           This driver supports ACPI-controlled docking stations and removable
> >           drive bays such as the IBM Ultrabay and the Dell Module Bay.
> >
> > +config ACPI_I2C
> > +       def_tristate I2C
> > +       depends on I2C
> > +       help
> > +         ACPI I2C enumeration support.
> > +
> >  config ACPI_PROCESSOR
> >         tristate "Processor"
> >         select THERMAL
> > diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
> > index a7badb5..8573346 100644
> > --- a/drivers/acpi/Makefile
> > +++ b/drivers/acpi/Makefile
> > @@ -69,6 +69,7 @@ obj-$(CONFIG_ACPI_HED)                += hed.o
> >  obj-$(CONFIG_ACPI_EC_DEBUGFS)  += ec_sys.o
> >  obj-$(CONFIG_ACPI_CUSTOM_METHOD)+= custom_method.o
> >  obj-$(CONFIG_ACPI_BGRT)                += bgrt.o
> > +obj-$(CONFIG_ACPI_I2C)         += acpi_i2c.o
> >
> >  # processor has its own "processor." module_param namespace
> >  processor-y                    := processor_driver.o processor_throttling.o
> > diff --git a/drivers/acpi/acpi_i2c.c b/drivers/acpi/acpi_i2c.c
> > new file mode 100644
> > index 0000000..dc6997e
> > --- /dev/null
> > +++ b/drivers/acpi/acpi_i2c.c
> > @@ -0,0 +1,234 @@
> > +/*
> > + * ACPI I2C enumeration support
> > + *
> > + * Copyright (C) 2012, Intel Corporation
> > + * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/acpi.h>
> > +#include <linux/i2c.h>
> > +#include <linux/module.h>
> > +
> > +struct acpi_i2c {
> > +       acpi_status (*callback)(struct acpi_device *, void *);
> > +       void *data;
> > +};
> > +
> > +static acpi_status acpi_i2c_enumerate_device(acpi_handle handle, u32 level,
> > +                                            void *data, void **return_value)
> > +{
> > +       struct acpi_i2c *acpi_i2c = data;
> > +       struct acpi_device *adev;
> > +
> > +       if (acpi_bus_get_device(handle, &adev))
> > +               return AE_OK;
> > +       if (acpi_bus_get_status(adev) || !adev->status.present)
> > +               return AE_OK;
> > +
> > +       return acpi_i2c->callback(adev, acpi_i2c->data);
> > +}
> > +
> > +static acpi_status acpi_i2c_enumerate(acpi_handle handle,
> > +       acpi_status (*callback)(struct acpi_device *, void *), void *data)
> > +{
> > +       struct acpi_i2c acpi_i2c;
> > +
> > +       acpi_i2c.callback = callback;
> > +       acpi_i2c.data = data;
> > +
> > +       return acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
> > +                                  acpi_i2c_enumerate_device, NULL,
> > +                                  &acpi_i2c, NULL);
> > +}
> 
> Same comment here as for the SPI patch. The two levels of indirection
> is more convoluted than it needs to be. Can acpi_i2c_find_client and
> acpi_i2c_add_device be passed directly to acpi_walk_namespace?

Yes they can, I'll do that in the next version. Thanks.
