Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2KQIAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 03:00:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:18930 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab2KQIAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 03:00:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,268,1352102400"; 
   d="scan'208";a="248609071"
Date: Sat, 17 Nov 2012 10:03:54 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jean Delvare <khali@linux-fr.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/3 UPDATED] i2c / ACPI: add ACPI enumeration support
Message-ID: <20121117080354.GB17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
 <2439178.tCj2rUMYJS@vostro.rjw.lan>
 <20121116140357.5e0a6d6b@endymion.delvare>
 <1499062.QDd9DGofy9@vostro.rjw.lan>
 <20121116144256.55b49cae@endymion.delvare>
 <20121116141729.GS17774@intel.com>
 <20121116152332.GV17774@intel.com>
 <20121116174753.67d71043@endymion.delvare>
 <20121116172828.GY17774@intel.com>
 <CAErSpo6f4LtW0Sm8hs8bToyN8r8AhzrovJ_ybv62qDGP6+ABPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6f4LtW0Sm8hs8bToyN8r8AhzrovJ_ybv62qDGP6+ABPA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 11:46:40PM -0700, Bjorn Helgaas wrote:
> On Fri, Nov 16, 2012 at 10:28 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > ...
> > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Date: Mon, 10 Sep 2012 12:12:32 +0300
> > Subject: [PATCH] i2c / ACPI: add ACPI enumeration support
> >
> > ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
> > and configure the I2C slave devices behind the I2C controller. This patch
> > adds helper functions to support I2C slave enumeration.
> >
> > An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
> > in order to get its slave devices enumerated, created and bound to the
> > corresponding ACPI handle.
> 
> I must admit I don't understand the strategy here.  Likely it's only
> because I haven't been paying enough attention, but I'll ask anyway in
> case anybody else is similarly confused.
> 
> The callchain when we enumerate these slave devices looks like this:
> 
>     acpi_i2c_register_devices(struct i2c_adapter *)
>       acpi_walk_namespace(adapter->dev.acpi_handle, acpi_i2c_add_device)
>         acpi_i2c_add_device
>           acpi_bus_get_device
>           acpi_bus_get_status
>           acpi_dev_get_resources(..., acpi_i2c_add_resource, ...)
>           <find IRQ, addr>
>           acpi_dev_free_resources
>           i2c_new_device
>             client = kzalloc
>             client->dev = ...
>             device_register(&client->dev)
> 
> Is the ACPI namespace in question something like the following?
> 
>     Device {                    # i2C master, i.e., the i2c_adapter
>       _HID PNPmmmm
>       Device {                  # I2C slave 1, i.e.,  a client
>         _HID PNPsss1
>         _CRS
>           SerialBus/I2C addr addr1, mode mode1
>           IRQ irq1
>       }
>       Device {                  # I2C slave 2
>         _HID PNPsss2
>         _CRS
>           SerialBus/I2C addr addr2, mode mode2
>           IRQ irq2
>       }
>     }

Yes.

> _CRS is a device configuration method, so I would expect that it
> exists within the scope of a Device() object.  The way I'm used to
> this working is for a driver to specify "I know about PNPsss1
> devices."

Yes.

> But it looks like acpi_i2c_register() walks the namespace below an i2c
> master device, registering a new i2c device (a slave) for every ACPI
> device node with a _CRS method that contains a SERIAL_BUS/TYPE_I2C
> descriptor.  It seems like you're basically claiming those devices
> nodes based on the contents of their _CRS, not based on their PNP IDs,
> which seems strange to me.

Yes, if we only matched the PNP IDs we would get bunch of PNP devices which
certainly doesn't help us to reuse the existing I2C drivers. So instead of
creating a new glue driver for ACPI or PNP device we added this enumeration
method that then creates the I2C devices, just like DT does.

> We have to be able to hook device enumeration into udev so we can
> autoload drivers.  It's obvious how to do that with _HID and _CID --
> we just emit a uevent saying "we found a new device with PNP IDs
> x,y,z".  I don't see how to do anything similar based on the _CRS
> contents.  Again, probably I'm completely missing the point here, and
> I'm sorry to be dense.

If you remember the concrete example, I gave you few mails back, it shows
how we are planning to the matching in an existing (or new driver). So we
match with _HID and _CID but that matching is done in the core of each bus
in question (platform, I2C and SPI).

> I guess this isn't really "enumeration" -- the ACPI core has
> previously walked this namespace and built acpi_devices for the
> Device() nodes, and I think it emits uevents at that time.  So this is
> more of a "claim" than an "enumerate."  But the Device() node for the
> I2C slave still exists, and it has _HID/_CID, doesn't it?  Do we use
> that _HID anywhere?

The matching is done using those _HID and _CIDs in the ACPI namespace, we
just now allow any driver to match any device using and not limit it to
ACPI device drivers (this is done with the help of drv->acpi_match_table).

> In any event, after acpi_i2c_register(), I think we have a set of
> i2c_client devices (with the above namespace, I assume we'd have two
> of them).  I guess acpi_i2c_find_device() is useful now -- it looks
> like it takes a "struct device *" (e.g., &client->dev from a struct
> i2c_client), and and gives you back the acpi_handle corresponding to
> it?
> 
> Here's the callchain of that path:
> 
>     acpi_i2c_find_device(struct device *)       # acpi_i2c_bus.find_device
>       i2c_verify_client(dev)
>       acpi_walk_namespace
>         acpi_i2c_find_child
>           acpi_bus_get_device
>           acpi_bus_get_status
>           acpi_dev_get_resources(..., acpi_i2c_find_child_address, ...)
>             acpi_i2c_find_child_address
>             found if (SERIAL_BUS && SERIAL_TYPE_I2C && slave_address == xx)
>           acpi_dev_free_resource_list
>       *handle = handle
> 
> That seems like an awful lot of work to do just to map a struct device
> * back to the acpi_handle.  But I don't have any suggestion; just that
> observation.

We had similar discussion internally about not using that
drivers/acpi/glue.c but we decided to use it for now, even if it really
backwards and makes things hard (like you observed as well). A much better
way would be just to assign the handle once we make the device but it
seemed not to be that simple after all.
