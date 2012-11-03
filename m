Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2KCULL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 16:11:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:12803 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab2KCULJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 16:11:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,705,1344236400"; 
   d="scan'208";a="214854311"
Date: Sat, 3 Nov 2012 22:13:10 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121103201310.GQ16648@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <1351928793-14375-3-git-send-email-mika.westerberg@linux.intel.com>
 <CAErSpo5q64uEse3aYYZkuQrD+9AJ9HFP_VVB1TabYfO-_BvY3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5q64uEse3aYYZkuQrD+9AJ9HFP_VVB1TabYfO-_BvY3g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 01:42:02PM -0600, Bjorn Helgaas wrote:
> On Sat, Nov 3, 2012 at 1:46 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
> > configure the SPI slave devices behind the SPI controller. This patch adds
> > support for this to the SPI core.
> >
> > In addition we bind ACPI nodes to SPI devices. This makes it possible for
> > the slave drivers to get the ACPI handle for further configuration.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/spi/spi.c |  231 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 230 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> > index 84c2861..de22a6e 100644
> > --- a/drivers/spi/spi.c
> > +++ b/drivers/spi/spi.c
> > @@ -35,6 +35,7 @@
> >  #include <linux/sched.h>
> >  #include <linux/delay.h>
> >  #include <linux/kthread.h>
> > +#include <linux/acpi.h>
> >
> >  static void spidev_release(struct device *dev)
> >  {
> > @@ -93,6 +94,10 @@ static int spi_match_device(struct device *dev, struct device_driver *drv)
> >         if (of_driver_match_device(dev, drv))
> >                 return 1;
> >
> > +       /* Then try ACPI */
> > +       if (acpi_driver_match_device(dev, drv))
> > +               return 1;
> > +
> >         if (sdrv->id_table)
> >                 return !!spi_match_id(sdrv->id_table, spi);
> >
> > @@ -888,6 +893,227 @@ static void of_register_spi_devices(struct spi_master *master)
> >  static void of_register_spi_devices(struct spi_master *master) { }
> >  #endif
> >
> > +#ifdef CONFIG_ACPI
> > +struct acpi_spi {
> > +       acpi_status (*callback)(struct acpi_device *, void *);
> > +       void *data;
> > +};
> > +
> > +static acpi_status acpi_spi_enumerate_device(acpi_handle handle, u32 level,
> > +                                            void *data, void **return_value)
> > +{
> > +       struct acpi_spi *acpi_spi = data;
> > +       struct acpi_device *adev;
> > +
> > +       if (acpi_bus_get_device(handle, &adev))
> > +               return AE_OK;
> > +       if (acpi_bus_get_status(adev) || !adev->status.present)
> > +               return AE_OK;
> > +
> > +       return acpi_spi->callback(adev, acpi_spi->data);
> > +}
> > +
> > +static acpi_status acpi_spi_enumerate(acpi_handle handle,
> > +       acpi_status (*callback)(struct acpi_device *, void *), void *data)
> > +{
> > +       struct acpi_spi acpi_spi;
> > +
> > +       acpi_spi.callback = callback;
> > +       acpi_spi.data = data;
> > +
> > +       return acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
> > +                                  acpi_spi_enumerate_device, NULL,
> > +                                  &acpi_spi, NULL);
> > +}
> > +
> > +struct acpi_spi_device_info {
> > +       struct spi_device *spi;
> > +       int triggering;
> > +       int polarity;
> > +       int gsi;
> > +       bool valid;
> > +};
> > +
> > +static acpi_status acpi_spi_add_resources(struct acpi_resource *res, void *data)
> > +{
> > +       struct acpi_spi_device_info *info = data;
> > +       struct acpi_resource_spi_serialbus *sb;
> > +       struct spi_device *spi = info->spi;
> > +
> > +       switch (res->type) {
> > +       case ACPI_RESOURCE_TYPE_SERIAL_BUS:
> > +               sb = &res->data.spi_serial_bus;
> > +               if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_SPI) {
> > +                       spi->chip_select = sb->device_selection;
> > +                       spi->max_speed_hz = sb->connection_speed;
> > +
> > +                       /* Mode (clock phase/polarity/etc. */
> > +                       if (sb->clock_phase == ACPI_SPI_SECOND_PHASE)
> > +                               spi->mode |= SPI_CPHA;
> > +                       if (sb->clock_polarity == ACPI_SPI_START_HIGH)
> > +                               spi->mode |= SPI_CPOL;
> > +                       if (sb->device_polarity == ACPI_SPI_ACTIVE_HIGH)
> > +                               spi->mode |= SPI_CS_HIGH;
> > +
> > +                       /*
> > +                        * The info is valid once we have found the
> > +                        * SPISerialBus resource.
> > +                        */
> > +                       info->valid = true;
> > +               }
> > +               break;
> > +
> > +       case ACPI_RESOURCE_TYPE_IRQ:
> > +               info->gsi = res->data.irq.interrupts[0];
> > +               info->triggering = res->data.irq.triggering;
> > +               info->polarity = res->data.irq.polarity;
> > +               break;
> > +
> > +       case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
> > +               info->gsi = res->data.extended_irq.interrupts[0];
> > +               info->triggering = res->data.extended_irq.triggering;
> > +               info->polarity = res->data.extended_irq.polarity;
> 
> A driver doesn't seem like the right place for _CRS parsing code.  I
> think the intent of _CRS is to describe resources that need to be
> coordinated across all devices, e.g., MMIO space, I/O port space, and
> IRQs.  Since these resources require system-wide coordination, even
> when we don't have drivers for some devices, the ACPI core should be
> able to parse _CRS without needing any device-specific knowledge.

I think the driver is the only one who really knows the resources it needs
in order to talk the hardware.

The purpose of the above code is to extract the resources in a suitable
form so that we can create a struct spi_device out of them automatically,
in a similar way than the Device Tree does.

There are other things which we cannot do in the generic code, such as GPIO
resources and FixedDMA resources. These should be handled by the actual
driver with the help of dev->acpi_handle IMO.

> I know the Linux ACPI core doesn't parse _CRS today, but it should.
> The only reason we get away with the core ignoring _CRS is because the
> BIOS sets up most ACPI devices and we never change them.  If we change
> any resource assignments, we have to know where all the other devices
> are so we can avoid conflicts.

I agree but these devices are typically "fixed" so that they wont be
hot-plugged (although we should prepare for such devices as well) so
basically we don't need to do change any assignments for resources.

And if the ACPI core parses the _CRS, how does it pass all the resources to
the drivers?

The idea here is to reuse the existing drivers as much as possible. That's
why we follow what Device Tree did already.

> 
> > +               break;
> > +       }
> > +
> > +       return AE_OK;
> > +}
> > +
> > +static acpi_status acpi_spi_add_device(struct acpi_device *adev, void *data)
> > +{
> > +       struct acpi_spi_device_info info;
> > +       struct spi_master *master = data;
> > +       struct spi_device *spi;
> > +       acpi_status status;
> > +
> > +       spi = spi_alloc_device(master);
> > +       if (!spi) {
> > +               dev_err(&master->dev, "failed to allocate SPI device\n");
> > +               return AE_ERROR;
> > +       }
> > +
> > +       memset(&info, 0, sizeof(info));
> > +       info.spi = spi;
> > +       info.gsi = -1;
> > +
> > +       status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
> > +                                    acpi_spi_add_resources, &info);
> > +       if (ACPI_FAILURE(status) || !info.valid)
> > +               goto fail_put_dev;
> > +
> > +       strlcpy(spi->modalias, acpi_device_hid(adev), sizeof(spi->modalias));
> > +       if (info.gsi >= 0)
> > +               spi->irq = acpi_register_gsi(&adev->dev, info.gsi,
> > +                                            info.triggering, info.polarity);
> > +       request_module(spi->modalias);
> > +       if (spi_add_device(spi)) {
> > +               dev_err(&master->dev, "failed to add SPI device from ACPI\n");
> > +               goto fail_unregister_gsi;
> > +       }
> > +
> > +       return AE_OK;
> > +
> > + fail_unregister_gsi:
> > +       if (info.gsi >= 0)
> > +               acpi_unregister_gsi(info.gsi);
> > + fail_put_dev:
> > +       spi_dev_put(spi);
> > +
> > +       return AE_OK;
> > +}
> > +
> > +static void acpi_register_spi_devices(struct spi_master *master)
> > +{
> > +       acpi_status status;
> > +       acpi_handle handle;
> > +
> > +       handle = master->dev.acpi_handle;
> > +       if (!handle)
> > +               return;
> > +
> > +       status = acpi_spi_enumerate(handle, acpi_spi_add_device, master);
> 
> How does this work with hot-plug?  acpi_spi_enumerate() walks a
> portion of the namespace.  How do we deal with changes to that part of
> the namespace?  For example, what happens if this part of the
> namespace gets pruned because an enclosing device is removed?  Is
> there a way to discover new SPI devices if they get added?

I'm not aware that we even support SPI hot-plug in the first place (well,
I'm not sure that the SPI bus even supports such thing).

Typically SPI devices are pretty much "static", at least that is my
understanding. The platform device type ACPI support doesn't yet handle
removing of the device and same goes with this code (typically the SPI
master is based on a platform device).

Eventually we should prepare for hot-plugging the SPI master device and
delete the slave device when the master is removed.
