Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab2KSXXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:23:47 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:53894 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab2KSXXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:23:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/3 UPDATED] i2c / ACPI: add ACPI enumeration support
Date: Tue, 20 Nov 2012 00:28:11 +0100
Message-ID: <1803580.oEdftF4n8y@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAErSpo46YMLg=AJgtx=bouWJKz0eMTm5GA3s3+=8Z8-_GLu-9g@mail.gmail.com>
References: <2439178.tCj2rUMYJS@vostro.rjw.lan> <20121117095537.GC17774@intel.com> <CAErSpo46YMLg=AJgtx=bouWJKz0eMTm5GA3s3+=8Z8-_GLu-9g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 19, 2012 03:49:25 PM Bjorn Helgaas wrote:
> On Sat, Nov 17, 2012 at 2:55 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Sat, Nov 17, 2012 at 10:03:54AM +0200, Mika Westerberg wrote:
> >> On Fri, Nov 16, 2012 at 11:46:40PM -0700, Bjorn Helgaas wrote:
> >> > On Fri, Nov 16, 2012 at 10:28 AM, Mika Westerberg
> >> > <mika.westerberg@linux.intel.com> wrote:
> >> > > ...
> >> > > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> > > Date: Mon, 10 Sep 2012 12:12:32 +0300
> >> > > Subject: [PATCH] i2c / ACPI: add ACPI enumeration support
> >> > >
> >> > > ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
> >> > > and configure the I2C slave devices behind the I2C controller. This patch
> >> > > adds helper functions to support I2C slave enumeration.
> >> > >
> >> > > An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
> >> > > in order to get its slave devices enumerated, created and bound to the
> >> > > corresponding ACPI handle.
> >> >
> >> > I must admit I don't understand the strategy here.  Likely it's only
> >> > because I haven't been paying enough attention, but I'll ask anyway in
> >> > case anybody else is similarly confused.
> >> >
> >> > The callchain when we enumerate these slave devices looks like this:
> >> >
> >> >     acpi_i2c_register_devices(struct i2c_adapter *)
> >> >       acpi_walk_namespace(adapter->dev.acpi_handle, acpi_i2c_add_device)
> >> >         acpi_i2c_add_device
> >> >           acpi_bus_get_device
> >> >           acpi_bus_get_status
> >> >           acpi_dev_get_resources(..., acpi_i2c_add_resource, ...)
> >> >           <find IRQ, addr>
> >> >           acpi_dev_free_resources
> >> >           i2c_new_device
> >> >             client = kzalloc
> >> >             client->dev = ...
> >> >             device_register(&client->dev)
> >> >
> >> > Is the ACPI namespace in question something like the following?
> >> >
> >> >     Device {                    # i2C master, i.e., the i2c_adapter
> >> >       _HID PNPmmmm
> >> >       Device {                  # I2C slave 1, i.e.,  a client
> >> >         _HID PNPsss1
> >> >         _CRS
> >> >           SerialBus/I2C addr addr1, mode mode1
> >> >           IRQ irq1
> >> >       }
> >> >       Device {                  # I2C slave 2
> >> >         _HID PNPsss2
> >> >         _CRS
> >> >           SerialBus/I2C addr addr2, mode mode2
> >> >           IRQ irq2
> >> >       }
> >> >     }
> >>
> >> Yes.
> >>
> >> > _CRS is a device configuration method, so I would expect that it
> >> > exists within the scope of a Device() object.  The way I'm used to
> >> > this working is for a driver to specify "I know about PNPsss1
> >> > devices."
> >>
> >> Yes.
> >>
> >> > But it looks like acpi_i2c_register() walks the namespace below an i2c
> >> > master device, registering a new i2c device (a slave) for every ACPI
> >> > device node with a _CRS method that contains a SERIAL_BUS/TYPE_I2C
> >> > descriptor.  It seems like you're basically claiming those devices
> >> > nodes based on the contents of their _CRS, not based on their PNP IDs,
> >> > which seems strange to me.
> >>
> >> Yes, if we only matched the PNP IDs we would get bunch of PNP devices which
> >> certainly doesn't help us to reuse the existing I2C drivers. So instead of
> >> creating a new glue driver for ACPI or PNP device we added this enumeration
> >> method that then creates the I2C devices, just like DT does.
> >
> > In other words, what this whole thing is trying to achieve is something
> > along the lines of:
> >
> >         - Instead of making PNP or ACPI devices out of every device in the
> >           ACPI namespace we use the resources returned by the _CRS
> >           method for a given device as a hint of what type of device it is.
> >
> >         - If we find I2CSerialBus() we assume it is an I2C device and
> >           create i2c_device (and i2c_client) and register this to the I2C
> >           core.
> >
> >         - If we find SPISerialBus() we assume it is a SPI device and create
> >           corresponding spidevice and register it to the SPI core.
> >
> >         - Devices that don't have a bus are represented as platform devices
> >           (based on the table in drivers/acpi/scan.c). The reason for this
> >           is that most of the SoC devices have already platform driver so
> >           we can easily reuse the existing drivers.
> 
> Using _CRS contents to infer the device type feels like a mistake to
> me.  It doesn't generalize to arbitrary devices.  I don't think it's
> the intent of the spec, which seems clearly to be "start with the
> _HID/_CID to identify devices," so it violates the principle of least
> surprise.
> 
> I'm not sure it's even safe to rely on _CRS being useful until after
> the OS runs _SRS.  Sec 6.2 of the spec (ACPI 5.0) says the OS uses
> _PRS to determine what resources the device needs and _SRS to assign
> them, and it *may* use _CRS to learn any current assignments (I know
> this doesn't match current Linux behavior very well).  I interpret
> that to mean the device may be disabled and return nothing in _CRS
> until after the OS evaluates _SRS to enable the device.
> 
> I think it will make it harder to reason about and refactor ACPI
> because it's "unusual."  For example, the acpi_i2c_register_devices ->
> acpi_i2c_add_device path allocates a new struct device (in struct
> i2c_client) and registers it.  Now we have a struct device in struct
> acpi_device, in struct pnp_dev, *and* in struct i2c_client, and all
> refer to the same thing.  What does that mean?  The sysfs picture
> seems confusing to me.
> 
> I assume you mean the acpi_platform_device_ids[] table you added with
> 91e56878058.  Having a table of IDs that are treated specially by the
> core is a bit of a concern for me because it means we need to add
> things to it every time a new platform device comes along.  The patch
> didn't include clear criteria for deciding what qualifies.

The current criterion is: If we know for a fact that the given device ID
matches a piece of hardware that we have an existing platform driver for
(e.g. an SPI controller), we'll add it to that table.  For now, that's
about it (although the "vision" is to extend that to other situations
and, ideally, to get rid of that table in the future).

All of that is about avoiding the need to have two different drivers for the
same piece of hardware, just because once it is used in a system with an
ACPI BIOS, and some other time it is used in a system where we get device
information from Device Trees.  And yes, that applies to PCI host bridges too. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
