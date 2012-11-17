Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab2KQJwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 04:52:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:2414 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab2KQJw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 04:52:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,270,1352102400"; 
   d="scan'208";a="169506099"
Date: Sat, 17 Nov 2012 11:55:37 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jean Delvare <khali@linux-fr.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/3 UPDATED] i2c / ACPI: add ACPI enumeration support
Message-ID: <20121117095537.GC17774@intel.com>
References: <2439178.tCj2rUMYJS@vostro.rjw.lan>
 <20121116140357.5e0a6d6b@endymion.delvare>
 <1499062.QDd9DGofy9@vostro.rjw.lan>
 <20121116144256.55b49cae@endymion.delvare>
 <20121116141729.GS17774@intel.com>
 <20121116152332.GV17774@intel.com>
 <20121116174753.67d71043@endymion.delvare>
 <20121116172828.GY17774@intel.com>
 <CAErSpo6f4LtW0Sm8hs8bToyN8r8AhzrovJ_ybv62qDGP6+ABPA@mail.gmail.com>
 <20121117080354.GB17774@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121117080354.GB17774@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 10:03:54AM +0200, Mika Westerberg wrote:
> On Fri, Nov 16, 2012 at 11:46:40PM -0700, Bjorn Helgaas wrote:
> > On Fri, Nov 16, 2012 at 10:28 AM, Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> > > ...
> > > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > Date: Mon, 10 Sep 2012 12:12:32 +0300
> > > Subject: [PATCH] i2c / ACPI: add ACPI enumeration support
> > >
> > > ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
> > > and configure the I2C slave devices behind the I2C controller. This patch
> > > adds helper functions to support I2C slave enumeration.
> > >
> > > An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
> > > in order to get its slave devices enumerated, created and bound to the
> > > corresponding ACPI handle.
> > 
> > I must admit I don't understand the strategy here.  Likely it's only
> > because I haven't been paying enough attention, but I'll ask anyway in
> > case anybody else is similarly confused.
> > 
> > The callchain when we enumerate these slave devices looks like this:
> > 
> >     acpi_i2c_register_devices(struct i2c_adapter *)
> >       acpi_walk_namespace(adapter->dev.acpi_handle, acpi_i2c_add_device)
> >         acpi_i2c_add_device
> >           acpi_bus_get_device
> >           acpi_bus_get_status
> >           acpi_dev_get_resources(..., acpi_i2c_add_resource, ...)
> >           <find IRQ, addr>
> >           acpi_dev_free_resources
> >           i2c_new_device
> >             client = kzalloc
> >             client->dev = ...
> >             device_register(&client->dev)
> > 
> > Is the ACPI namespace in question something like the following?
> > 
> >     Device {                    # i2C master, i.e., the i2c_adapter
> >       _HID PNPmmmm
> >       Device {                  # I2C slave 1, i.e.,  a client
> >         _HID PNPsss1
> >         _CRS
> >           SerialBus/I2C addr addr1, mode mode1
> >           IRQ irq1
> >       }
> >       Device {                  # I2C slave 2
> >         _HID PNPsss2
> >         _CRS
> >           SerialBus/I2C addr addr2, mode mode2
> >           IRQ irq2
> >       }
> >     }
> 
> Yes.
> 
> > _CRS is a device configuration method, so I would expect that it
> > exists within the scope of a Device() object.  The way I'm used to
> > this working is for a driver to specify "I know about PNPsss1
> > devices."
> 
> Yes.
> 
> > But it looks like acpi_i2c_register() walks the namespace below an i2c
> > master device, registering a new i2c device (a slave) for every ACPI
> > device node with a _CRS method that contains a SERIAL_BUS/TYPE_I2C
> > descriptor.  It seems like you're basically claiming those devices
> > nodes based on the contents of their _CRS, not based on their PNP IDs,
> > which seems strange to me.
> 
> Yes, if we only matched the PNP IDs we would get bunch of PNP devices which
> certainly doesn't help us to reuse the existing I2C drivers. So instead of
> creating a new glue driver for ACPI or PNP device we added this enumeration
> method that then creates the I2C devices, just like DT does.

In other words, what this whole thing is trying to achieve is something
along the lines of:

	- Instead of making PNP or ACPI devices out of every device in the
	  ACPI namespace we use the resources returned by the _CRS
	  method for a given device as a hint of what type of device it is.

	- If we find I2CSerialBus() we assume it is an I2C device and
	  create i2c_device (and i2c_client) and register this to the I2C
	  core.

	- If we find SPISerialBus() we assume it is a SPI device and create
	  corresponding spidevice and register it to the SPI core.

	- Devices that don't have a bus are represented as platform devices
	  (based on the table in drivers/acpi/scan.c). The reason for this
	  is that most of the SoC devices have already platform driver so
	  we can easily reuse the existing drivers.

The implementation follows the Device Tree as much as possible so that
adding support for DT and ACPI to a driver would be similar and thus easy
for people who know either method.

An alternative would be to create PNP or ACPI glue drivers for each device
that then create the corresponding real device like platform or I2C which
means that we need add much more lines of unnecessary code to the kernel
compared to adding the ACPI/PNP IDs to the driver which takes only few
lines of code.

We still allow more complex configuration with the means of
dev->acpi_handle. So for example if driver needs to call _DSM in order to
retrieve some parameters for the device it can do so with the help of
dev->acpi_handle.
