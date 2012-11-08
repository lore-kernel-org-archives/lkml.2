Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab2KHVCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:02:01 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:34935 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab2KHVCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:02:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Grant Likely <grant.likely@secretlab.ca>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Date: Thu, 08 Nov 2012 22:06:13 +0100
Message-ID: <8738296.8fuPoPcrrF@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CACxGe6sUXWLZVBpD1we_ZAXA7wvMg72DQpyCw5f+E8c5_ox++w@mail.gmail.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <20121107095842.GY24532@intel.com> <CACxGe6sUXWLZVBpD1we_ZAXA7wvMg72DQpyCw5f+E8c5_ox++w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 08, 2012 06:05:23 PM Grant Likely wrote:
> On Wed, Nov 7, 2012 at 9:58 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Tue, Nov 06, 2012 at 11:36:08PM +0100, Rafael J. Wysocki wrote:
> >> >
> >> > OK, but then we need to pass the information obtained from _CRS
> >> > (presumably after some adjustments through _SRS) to drivers, or rather to
> >> > things like the SPI core, I2C core etc. so that they can create device
> >> > objects for drivers to bind to and quite frankly I don't see why not to use
> >> > ACPI resources for that.
> >>
> >> Nevertheless, the routines for parsing those resources should belong
> >> to the ACPI core, mostly to avoid code duplication.
> >
> > Rafael,
> >
> > So is the idea now that the ACPI core parses the resources and passes them
> > forward via struct acpi_device?

Not exactly.  The idea is to execute _CRS in the core and attach the result
as a list of resources the struct acpi_device object representing the given
device node.

> > I'm just wondering how to proceed with these I2C and SPI enumeration patches.
> 
> From my experience with device tree, that seems the wrong way around.
> Device Tree used to have a separate "of_device" which is analogous to
> an acpi_device.

No, it is not.  If anything, struct acpi_device is a counterpart of struct
device_node. :-)

Yes, the name is misleading and it should be something like struct acpi_dev_node.
Yes, these objects _are_ registered as devices with the driver model and there
are drivers that bind to some of them.  Yes, this is a mistake, but fixing it
will take quite some time, because it involves converting the drivers in
question.

No, acpi_handle is not analogous to struct device_node, because it only is
a pointer to a structure used internally by the AML interpreter.  It only
is useful for executing AML methods with the help of the interpreter, but
there are reasons why _CRS, in particular, should only be executed by the
ACPI core.

> The problem was always that of_devices never fit into
> the view that Linux has of the system. That would mean having both an
> of_device and and spi_device in completely separate parts of the
> driver model tree to support an spi device. Same for platform, i2c and
> onewire and others. Blech.
> 
> So, yes I agree that ACPI core should have the tools for parsing the
> resources, but it makes sense for those functions to be helpers that
> the spi core acpi support and the i2c core acpi support use to
> populate the native spi_device and i2c_client structures.

Yes, that exactly is the plan, although I2C and SPI will not receive the
resources directly from _CRS. :-)

> Plus individual drivers can call the same functions if (and only if) the
> needed resources cannot fit into the bus type's native format.

I'm kind of cautious about this particular thing.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
