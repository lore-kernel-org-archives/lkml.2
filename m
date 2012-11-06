Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2KFNME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:12:04 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:58279 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab2KFNMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:12:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Date: Tue, 06 Nov 2012 14:16:12 +0100
Message-ID: <3455360.Z6cZSC3BtR@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAErSpo4Rnu9ioyXWfaNEkUZh402hnFAuwJ9dk5wxT5TNOkc97A@mail.gmail.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <1792336.CIafglX82A@vostro.rjw.lan> <CAErSpo4Rnu9ioyXWfaNEkUZh402hnFAuwJ9dk5wxT5TNOkc97A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 05, 2012 09:54:37 AM Bjorn Helgaas wrote:
> On Sat, Nov 3, 2012 at 2:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, November 03, 2012 01:42:02 PM Bjorn Helgaas wrote:
> >> On Sat, Nov 3, 2012 at 1:46 AM, Mika Westerberg
> >> <mika.westerberg@linux.intel.com> wrote:
> >> > ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
> >> > configure the SPI slave devices behind the SPI controller. This patch adds
> >> > support for this to the SPI core.
> >> >
> >> > In addition we bind ACPI nodes to SPI devices. This makes it possible for
> >> > the slave drivers to get the ACPI handle for further configuration.
> >> >
> >> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> > ---
> >> >  drivers/spi/spi.c |  231 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
> 
> >> > +static acpi_status acpi_spi_add_resources(struct acpi_resource *res, void *data)
> >> > +{
> >> > +       struct acpi_spi_device_info *info = data;
> >> > +       struct acpi_resource_spi_serialbus *sb;
> >> > +       struct spi_device *spi = info->spi;
> >> > +
> >> > +       switch (res->type) {
> >> > +       case ACPI_RESOURCE_TYPE_SERIAL_BUS:
> >> > +               sb = &res->data.spi_serial_bus;
> >> > +               if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_SPI) {
> >> > +                       spi->chip_select = sb->device_selection;
> >> > +                       spi->max_speed_hz = sb->connection_speed;
> >> > +
> >> > +                       /* Mode (clock phase/polarity/etc. */
> >> > +                       if (sb->clock_phase == ACPI_SPI_SECOND_PHASE)
> >> > +                               spi->mode |= SPI_CPHA;
> >> > +                       if (sb->clock_polarity == ACPI_SPI_START_HIGH)
> >> > +                               spi->mode |= SPI_CPOL;
> >> > +                       if (sb->device_polarity == ACPI_SPI_ACTIVE_HIGH)
> >> > +                               spi->mode |= SPI_CS_HIGH;
> >> > +
> >> > +                       /*
> >> > +                        * The info is valid once we have found the
> >> > +                        * SPISerialBus resource.
> >> > +                        */
> >> > +                       info->valid = true;
> >> > +               }
> >> > +               break;
> >> > +
> >> > +       case ACPI_RESOURCE_TYPE_IRQ:
> >> > +               info->gsi = res->data.irq.interrupts[0];
> >> > +               info->triggering = res->data.irq.triggering;
> >> > +               info->polarity = res->data.irq.polarity;
> >> > +               break;
> >> > +
> >> > +       case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
> >> > +               info->gsi = res->data.extended_irq.interrupts[0];
> >> > +               info->triggering = res->data.extended_irq.triggering;
> >> > +               info->polarity = res->data.extended_irq.polarity;
> >>
> >> A driver doesn't seem like the right place for _CRS parsing code.
> >
> > This is not a driver, however. :-)
> 
> OK.  Can you describe what this is?  I assume the picture involves an
> SPI master device and one or more SPI slave devices, and the ACPI
> namespace tells us something about them, and somehow this code is
> related to those devices because it's looking at _CRS for them.

This is part of the SPI core that looks for SPI devices below a controller.

> A _CRS method is associated with a Device in the namespace.  What is
> that device in this case?

An SPI device below a controller.

> What is its PNP ID?

I can't answer that from the top of my head, sorry.

> What driver claims devices with that ID?

The driver that declares support for it in its acpi_match_table[] array.


> >> > +static void acpi_register_spi_devices(struct spi_master *master)
> >> > +{
> >> > +       acpi_status status;
> >> > +       acpi_handle handle;
> >> > +
> >> > +       handle = master->dev.acpi_handle;
> >> > +       if (!handle)
> >> > +               return;
> >> > +
> >> > +       status = acpi_spi_enumerate(handle, acpi_spi_add_device, master);
> >>
> >> How does this work with hot-plug?  acpi_spi_enumerate() walks a
> >> portion of the namespace.  How do we deal with changes to that part of
> >> the namespace?  For example, what happens if this part of the
> >> namespace gets pruned because an enclosing device is removed?  Is
> >> there a way to discover new SPI devices if they get added?
> >
> > Yes, there should be a way to do that eventually.  No, we don't have any
> > removable SPI devices described by ACPI yet, as far as I know.  So even if
> > we added code for that now, we wouldn't be able to test it anyway with any
> > real hardware until such devices become available.  I have no idea when that's
> > going to happen, though.
> 
> I'm not asking about hotplug of devices on an SPI bus.  I'm asking
> about hotplug of SPI masters.  For example, let's say you hot-add a
> whole node that contains an SPI master.  I assume there's some ACPI
> Device node that describes the SPI master, and a hot-add would add a
> subtree to the namespace that contains a new SPI master Device.

The master will be a platform device and again, we're going to add support
for the hotplug of those, but the SPI controllers that we currently can test
it with are not removable.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
