Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2KFWOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:14:06 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:59145 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2KFWOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:14:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Date: Tue, 06 Nov 2012 23:18:11 +0100
Message-ID: <1523215.Pon1eKPQDb@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAErSpo5xEO4M_Fb0dJ6w7Qxck-0RcKKwQjKj1QZgFxhof7X5Rw@mail.gmail.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <3455360.Z6cZSC3BtR@vostro.rjw.lan> <CAErSpo5xEO4M_Fb0dJ6w7Qxck-0RcKKwQjKj1QZgFxhof7X5Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 06, 2012 01:53:01 PM Bjorn Helgaas wrote:
> On Tue, Nov 6, 2012 at 6:16 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, November 05, 2012 09:54:37 AM Bjorn Helgaas wrote:
> >> On Sat, Nov 3, 2012 at 2:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Saturday, November 03, 2012 01:42:02 PM Bjorn Helgaas wrote:
> >> >> On Sat, Nov 3, 2012 at 1:46 AM, Mika Westerberg
> >> >> <mika.westerberg@linux.intel.com> wrote:
> >> >> > ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
> >> >> > configure the SPI slave devices behind the SPI controller. This patch adds
> >> >> > support for this to the SPI core.
> >> >> >
> >> >> > In addition we bind ACPI nodes to SPI devices. This makes it possible for
> >> >> > the slave drivers to get the ACPI handle for further configuration.
> >> >> >
> >> >> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> >> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> >> > ---
> >> >> >  drivers/spi/spi.c |  231 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >>
> >> >> > +static acpi_status acpi_spi_add_resources(struct acpi_resource *res, void *data)
> >> >> > +{
> >> >> > +       struct acpi_spi_device_info *info = data;
> >> >> > +       struct acpi_resource_spi_serialbus *sb;
> >> >> > +       struct spi_device *spi = info->spi;
> >> >> > +
> >> >> > +       switch (res->type) {
> >> >> > +       case ACPI_RESOURCE_TYPE_SERIAL_BUS:
> >> >> > +               sb = &res->data.spi_serial_bus;
> >> >> > +               if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_SPI) {
> >> >> > +                       spi->chip_select = sb->device_selection;
> >> >> > +                       spi->max_speed_hz = sb->connection_speed;
> >> >> > +
> >> >> > +                       /* Mode (clock phase/polarity/etc. */
> >> >> > +                       if (sb->clock_phase == ACPI_SPI_SECOND_PHASE)
> >> >> > +                               spi->mode |= SPI_CPHA;
> >> >> > +                       if (sb->clock_polarity == ACPI_SPI_START_HIGH)
> >> >> > +                               spi->mode |= SPI_CPOL;
> >> >> > +                       if (sb->device_polarity == ACPI_SPI_ACTIVE_HIGH)
> >> >> > +                               spi->mode |= SPI_CS_HIGH;
> >> >> > +
> >> >> > +                       /*
> >> >> > +                        * The info is valid once we have found the
> >> >> > +                        * SPISerialBus resource.
> >> >> > +                        */
> >> >> > +                       info->valid = true;
> >> >> > +               }
> >> >> > +               break;
> >> >> > +
> >> >> > +       case ACPI_RESOURCE_TYPE_IRQ:
> >> >> > +               info->gsi = res->data.irq.interrupts[0];
> >> >> > +               info->triggering = res->data.irq.triggering;
> >> >> > +               info->polarity = res->data.irq.polarity;
> >> >> > +               break;
> >> >> > +
> >> >> > +       case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
> >> >> > +               info->gsi = res->data.extended_irq.interrupts[0];
> >> >> > +               info->triggering = res->data.extended_irq.triggering;
> >> >> > +               info->polarity = res->data.extended_irq.polarity;
> >> >>
> >> >> A driver doesn't seem like the right place for _CRS parsing code.
> >> >
> >> > This is not a driver, however. :-)
> >>
> >> OK.  Can you describe what this is?  I assume the picture involves an
> >> SPI master device and one or more SPI slave devices, and the ACPI
> >> namespace tells us something about them, and somehow this code is
> >> related to those devices because it's looking at _CRS for them.
> >
> > This is part of the SPI core that looks for SPI devices below a controller.
> >
> >> A _CRS method is associated with a Device in the namespace.  What is
> >> that device in this case?
> >
> > An SPI device below a controller.
> >
> >> What is its PNP ID?
> >
> > I can't answer that from the top of my head, sorry.
> >
> >> What driver claims devices with that ID?
> >
> > The driver that declares support for it in its acpi_match_table[] array.
> 
> OK, I guess my problem is in understanding the difference between (1)
> a platform device where we use the acpi_match_table[] to locate
> devices with matching ACPI IDs, and (2) a device where we use
> pnp_register_driver() or acpi_bus_register_driver() to locate devices
> with matching ACPI IDs.
> 
> They seem similar to me.  For example, take a PNP0A03 PCI host bridge.
>  This seems like a platform device since there's no native hardware
> method to enumerate it.  The ACPI namespace gives us a way to find it.
>  We use acpi_bus_register_driver() to bind a driver to it.  The driver
> has the struct acpi_device * and can access any ACPI state it needs.
> The driver supplies .add() and .remove() methods, so in principle the
> driver doesn't need to know anything about hotplug (assuming the ACPI
> core handles hotplug correctly, which it doesn't yet).

Well, I hope this is the last time I need to explain that. :-)

Please see this message for detailed discussion:

http://marc.info/?l=linux-kernel&m=135180467616074&w=4

> How is the SPI controller different than this?  Is there some logical
> difference that requires a different framework?  Or are you proposing
> that we get rid of acpi_bus_register_driver() and migrate everything
> to this new framework?

Yes, I do, but let's just do it gradually.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
