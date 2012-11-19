Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2KSWtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:49:50 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49132 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab2KSWtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:49:47 -0500
MIME-Version: 1.0
In-Reply-To: <20121117095537.GC17774@intel.com>
References: <2439178.tCj2rUMYJS@vostro.rjw.lan> <20121116140357.5e0a6d6b@endymion.delvare>
 <1499062.QDd9DGofy9@vostro.rjw.lan> <20121116144256.55b49cae@endymion.delvare>
 <20121116141729.GS17774@intel.com> <20121116152332.GV17774@intel.com>
 <20121116174753.67d71043@endymion.delvare> <20121116172828.GY17774@intel.com>
 <CAErSpo6f4LtW0Sm8hs8bToyN8r8AhzrovJ_ybv62qDGP6+ABPA@mail.gmail.com>
 <20121117080354.GB17774@intel.com> <20121117095537.GC17774@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 19 Nov 2012 15:49:25 -0700
Message-ID: <CAErSpo46YMLg=AJgtx=bouWJKz0eMTm5GA3s3+=8Z8-_GLu-9g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3 UPDATED] i2c / ACPI: add ACPI enumeration support
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 2:55 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Sat, Nov 17, 2012 at 10:03:54AM +0200, Mika Westerberg wrote:
>> On Fri, Nov 16, 2012 at 11:46:40PM -0700, Bjorn Helgaas wrote:
>> > On Fri, Nov 16, 2012 at 10:28 AM, Mika Westerberg
>> > <mika.westerberg@linux.intel.com> wrote:
>> > > ...
>> > > From: Mika Westerberg <mika.westerberg@linux.intel.com>
>> > > Date: Mon, 10 Sep 2012 12:12:32 +0300
>> > > Subject: [PATCH] i2c / ACPI: add ACPI enumeration support
>> > >
>> > > ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
>> > > and configure the I2C slave devices behind the I2C controller. This patch
>> > > adds helper functions to support I2C slave enumeration.
>> > >
>> > > An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
>> > > in order to get its slave devices enumerated, created and bound to the
>> > > corresponding ACPI handle.
>> >
>> > I must admit I don't understand the strategy here.  Likely it's only
>> > because I haven't been paying enough attention, but I'll ask anyway in
>> > case anybody else is similarly confused.
>> >
>> > The callchain when we enumerate these slave devices looks like this:
>> >
>> >     acpi_i2c_register_devices(struct i2c_adapter *)
>> >       acpi_walk_namespace(adapter->dev.acpi_handle, acpi_i2c_add_device)
>> >         acpi_i2c_add_device
>> >           acpi_bus_get_device
>> >           acpi_bus_get_status
>> >           acpi_dev_get_resources(..., acpi_i2c_add_resource, ...)
>> >           <find IRQ, addr>
>> >           acpi_dev_free_resources
>> >           i2c_new_device
>> >             client = kzalloc
>> >             client->dev = ...
>> >             device_register(&client->dev)
>> >
>> > Is the ACPI namespace in question something like the following?
>> >
>> >     Device {                    # i2C master, i.e., the i2c_adapter
>> >       _HID PNPmmmm
>> >       Device {                  # I2C slave 1, i.e.,  a client
>> >         _HID PNPsss1
>> >         _CRS
>> >           SerialBus/I2C addr addr1, mode mode1
>> >           IRQ irq1
>> >       }
>> >       Device {                  # I2C slave 2
>> >         _HID PNPsss2
>> >         _CRS
>> >           SerialBus/I2C addr addr2, mode mode2
>> >           IRQ irq2
>> >       }
>> >     }
>>
>> Yes.
>>
>> > _CRS is a device configuration method, so I would expect that it
>> > exists within the scope of a Device() object.  The way I'm used to
>> > this working is for a driver to specify "I know about PNPsss1
>> > devices."
>>
>> Yes.
>>
>> > But it looks like acpi_i2c_register() walks the namespace below an i2c
>> > master device, registering a new i2c device (a slave) for every ACPI
>> > device node with a _CRS method that contains a SERIAL_BUS/TYPE_I2C
>> > descriptor.  It seems like you're basically claiming those devices
>> > nodes based on the contents of their _CRS, not based on their PNP IDs,
>> > which seems strange to me.
>>
>> Yes, if we only matched the PNP IDs we would get bunch of PNP devices which
>> certainly doesn't help us to reuse the existing I2C drivers. So instead of
>> creating a new glue driver for ACPI or PNP device we added this enumeration
>> method that then creates the I2C devices, just like DT does.
>
> In other words, what this whole thing is trying to achieve is something
> along the lines of:
>
>         - Instead of making PNP or ACPI devices out of every device in the
>           ACPI namespace we use the resources returned by the _CRS
>           method for a given device as a hint of what type of device it is.
>
>         - If we find I2CSerialBus() we assume it is an I2C device and
>           create i2c_device (and i2c_client) and register this to the I2C
>           core.
>
>         - If we find SPISerialBus() we assume it is a SPI device and create
>           corresponding spidevice and register it to the SPI core.
>
>         - Devices that don't have a bus are represented as platform devices
>           (based on the table in drivers/acpi/scan.c). The reason for this
>           is that most of the SoC devices have already platform driver so
>           we can easily reuse the existing drivers.

Using _CRS contents to infer the device type feels like a mistake to
me.  It doesn't generalize to arbitrary devices.  I don't think it's
the intent of the spec, which seems clearly to be "start with the
_HID/_CID to identify devices," so it violates the principle of least
surprise.

I'm not sure it's even safe to rely on _CRS being useful until after
the OS runs _SRS.  Sec 6.2 of the spec (ACPI 5.0) says the OS uses
_PRS to determine what resources the device needs and _SRS to assign
them, and it *may* use _CRS to learn any current assignments (I know
this doesn't match current Linux behavior very well).  I interpret
that to mean the device may be disabled and return nothing in _CRS
until after the OS evaluates _SRS to enable the device.

I think it will make it harder to reason about and refactor ACPI
because it's "unusual."  For example, the acpi_i2c_register_devices ->
acpi_i2c_add_device path allocates a new struct device (in struct
i2c_client) and registers it.  Now we have a struct device in struct
acpi_device, in struct pnp_dev, *and* in struct i2c_client, and all
refer to the same thing.  What does that mean?  The sysfs picture
seems confusing to me.

I assume you mean the acpi_platform_device_ids[] table you added with
91e56878058.  Having a table of IDs that are treated specially by the
core is a bit of a concern for me because it means we need to add
things to it every time a new platform device comes along.  The patch
didn't include clear criteria for deciding what qualifies.  For
example, I don't know whether PCI host bridges would qualify as
platform devices.  I guess maybe they would, because they don't have a
bus (though of course they have acpi_bus_type like all other ACPI
devices)?

> The implementation follows the Device Tree as much as possible so that
> adding support for DT and ACPI to a driver would be similar and thus easy
> for people who know either method.
>
> An alternative would be to create PNP or ACPI glue drivers for each device
> that then create the corresponding real device like platform or I2C which
> means that we need add much more lines of unnecessary code to the kernel
> compared to adding the ACPI/PNP IDs to the driver which takes only few
> lines of code.
>
> We still allow more complex configuration with the means of
> dev->acpi_handle. So for example if driver needs to call _DSM in order to
> retrieve some parameters for the device it can do so with the help of
> dev->acpi_handle.

I think the benefit here is that you can merely point
.acpi_match_table at an acpi_device_id[] table, then use
platform_get_resource() as a generic way to get resources, whether the
platform device came from OF, ACPI, etc.  The alternative would be to
add, e.g., a PNP driver with a .probe() method that uses
pnp_get_resource().  That's not very much code, but it is more, even
if the .probe() method just calls a device registration function
that's shared across bus types.

That benefit seems like a great thing, and my question then is why
wouldn't we just do it across the board and make platform devices for
*all* ACPI devices without having the I2C and SPI special cases?

Bjorn
