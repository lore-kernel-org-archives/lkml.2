Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab2KHTct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:32:49 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54735 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab2KHTcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:32:46 -0500
MIME-Version: 1.0
In-Reply-To: <20121107095608.GX24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <3455360.Z6cZSC3BtR@vostro.rjw.lan> <CAErSpo5xEO4M_Fb0dJ6w7Qxck-0RcKKwQjKj1QZgFxhof7X5Rw@mail.gmail.com>
 <1523215.Pon1eKPQDb@vostro.rjw.lan> <20121107095608.GX24532@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 8 Nov 2012 12:32:25 -0700
Message-ID: <CAErSpo5My6+ypp9zsxR8vh8k1px0otOWfAcacWaLNs2xjsc7UA@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 2:56 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Nov 06, 2012 at 11:18:11PM +0100, Rafael J. Wysocki wrote:
>> > How is the SPI controller different than this?  Is there some logical
>> > difference that requires a different framework?  Or are you proposing
>> > that we get rid of acpi_bus_register_driver() and migrate everything
>> > to this new framework?
>>
>> Yes, I do, but let's just do it gradually.
>
> Bjorn, here is a concrete example how this is supposed to be used.
>
> Lets say we have an existing SPI slave driver that we want to extend to
> support enumeration from ACPI. Instead of writing acpi_driver glue for that
> (and registering it using acpi_bus_register_driver()) what we do is simple
> add these to the existing SPI driver:
>
>         #ifdef CONFIG_ACPI
>         static struct acpi_device_id my_spidrv_match[] = {
>                 /* ACPI IDs here */
>                 { }
>         };
>         MODULE_DEVICE_TABLE(acpi, my_spidrv_match);
>         #endif
>
>         static struct spi_driver my_spidrv = {
>                 ...
>                 .driver = {
>                         .acpi_match_table = ACPI_PTR(my_spidrv_match),
>                 },
>         };
>
> The same thing works with platform, I2c and SPI drivers and can be extented
> to others as well. If the driver needs to do some ACPI specific
> configuration it can get the ACPI handle using its dev->acpi_handle.
>
> The above example now supports both, normal SPI (where the devices are
> enumerated by populating spi_board_info()) and ACPI. Adding support for
> Device Tree is similar than ACPI so a single driver can support all three
> easily at the same time.

Thanks for the concrete example; that helps me a lot.

Struct device_driver is a generic structure, so it seems strange to
have to include non-generic things like of_device_id and now
acpi_match_table there.

I'm actually interested in the details you didn't include above, too.
For example, I don't know of a generic way to get resource information
from a "struct device *", so I assume you need to figure out what sort
of device it is and then do the appropriate PCI/ACPI/OF/DT/etc
operations to learn the resources?

I think it would be cool if there *were* a generic way to get "struct
device" resources.  Then you could imagine a mechanism where a driver
supplied a list of identifiers it could claim, e.g.,
PCI_VEN_DEV(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_CE4100_UART),
ACPI_ID("PNP0501"), etc.,  and it might not need to know anything more
than what the identifier is.
