Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2KDIuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 03:50:52 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:9170 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2KDIut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 03:50:49 -0500
Date: Sun, 4 Nov 2012 09:50:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/3] i2c / ACPI: add ACPI enumeration support
Message-ID: <20121104095031.5e6465ae@endymion.delvare>
In-Reply-To: <20121104072316.GR16648@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
	<1351928793-14375-4-git-send-email-mika.westerberg@linux.intel.com>
	<20121103225246.66d4f094@endymion.delvare>
	<20121104072316.GR16648@intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2012 09:23:17 +0200, Mika Westerberg wrote:
> On Sat, Nov 03, 2012 at 10:52:46PM +0100, Jean Delvare wrote:
> > On Sat,  3 Nov 2012 09:46:33 +0200, Mika Westerberg wrote:
> > > --- /dev/null
> > > +++ b/drivers/acpi/acpi_i2c.c
> > > @@ -0,0 +1,234 @@
> > > +/*
> > > + * ACPI I2C enumeration support
> > > + *
> > > + * Copyright (C) 2012, Intel Corporation
> > > + * Author: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + */
> > > +
> > > +#include <linux/acpi.h>
> > > +#include <linux/i2c.h>
> > > +#include <linux/module.h>
> > 
> > You also need <linux/device.h> for dev_err() etc., and <linux/err.h> for
> > ENODEV etc.
> 
> I think <acpi.h> already includes <device.h> but I'll double check. At
> least this compiles without those headers in place :)

That's not really the point. You never know which header inclusions
will be removed from other header files in the future, so you should
include what you need explicitly. This avoids future build breakages as
well as build breakages on other architectures.

> > > (...)
> > > +static acpi_status acpi_i2c_add_device(struct acpi_device *adev, void *data)
> > > +{
> > > +	struct acpi_i2c_device_info info;
> > > +	struct i2c_adapter *adapter = data;
> > > +	acpi_status status;
> > > +
> > > +	memset(&info, 0, sizeof(info));
> > > +	info.gsi = -1;
> > > +
> > > +	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
> > > +				     acpi_i2c_add_resources, &info);
> > > +	if (ACPI_FAILURE(status) || !info.valid)
> > > +		return status;
> > > +
> > > +	strlcpy(info.board.type, acpi_device_hid(adev),
> > > +		sizeof(info.board.type));
> > 
> > I very much doubt the ACPI HID names will match the Linux i2c device
> > names. In other words you are instantiating devices no driver will want
> > to bind to. How do you plan to solve this issue?
> 
> We use ACPI IDs (_HID, _CID) for matching in a similar way than the Device
> Tree does. Typicaly you add following code to the existing I2C driver:
> 
> #ifdef CONFIG_ACPI
> static struct acpi_device_id mydrv_acpi_match[] = {
> 	{ "CHRGR00", 0 },
> 	...
> 	{ }
> };
> MODULE_DEVICE_TABLE(acpi, mydrv_acpi_match);
> #endif
> 
> static struct i2c_driver mydrv = {
> 	.driver = {
> 		.acpi_match_table = ACPI_PTR(mydrv_acpi_match),
> 	},
> 	...
> };
> 
> in order to get the driver matched to the device. If the driver needs to
> perform some ACPI specific things, like call _DSM method - it gets the ACPI
> handle from dev->acpi_handle (analoguous to Device Tree dev->of_node).
> 
> The same thing applies to platform and SPI busses as well.

OK, very nice, that should work just fine :)

Thanks,
-- 
Jean Delvare
