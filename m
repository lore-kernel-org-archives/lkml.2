Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2KFUgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:36:19 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48736 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab2KFUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:36:18 -0500
MIME-Version: 1.0
In-Reply-To: <1815967.2MF0PyW36l@vostro.rjw.lan>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <4052192.ry8JrGTr6H@vostro.rjw.lan> <CAErSpo6gfL+QFoWK+8ahYAj+vnp4OCn4B=-vALGbU_LnsyT8oQ@mail.gmail.com>
 <1815967.2MF0PyW36l@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 6 Nov 2012 13:35:56 -0700
Message-ID: <CAErSpo44pWUJmRAP6eR9T+2WvO5hJPFOC=Nn-WPXDtCY0v0EDw@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 6:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, November 05, 2012 09:54:42 AM Bjorn Helgaas wrote:
>> On Mon, Nov 5, 2012 at 3:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Saturday, November 03, 2012 09:59:28 PM Rafael J. Wysocki wrote:
>> >> On Saturday, November 03, 2012 10:13:10 PM Mika Westerberg wrote:
>> >> > On Sat, Nov 03, 2012 at 01:42:02PM -0600, Bjorn Helgaas wrote:
>> >> > > On Sat, Nov 3, 2012 at 1:46 AM, Mika Westerberg
>> >> > > <mika.westerberg@linux.intel.com> wrote:
>> >> > > > ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
>> >> > > > configure the SPI slave devices behind the SPI controller. This patch adds
>> >> > > > support for this to the SPI core.
>> > [...]
>> >> > And if the ACPI core parses the _CRS, how does it pass all the resources to
>> >> > the drivers?
>> >>
>> >> Pretty much the same way the $subject patch does.
>> >>
>> >> Instead of parsing the entire subtree below an SPI controller and trying
>> >> acpi_spi_add_device() for each device node in there, it could call
>> >> acpi_spi_add_device() whenever it finds a device of type
>> >> ACPI_RESOURCE_TYPE_SERIAL_BUS/ACPI_RESOURCE_SERIAL_TYPE_SPI.
>> >> The only problem is how to pass "master" to it.
>> >>
>> >> So Bjorn, do you have any idea how we could pass the "master" pointer from the
>> >> ACPI core to acpi_spi_add_device() in a sensible way?
>> >>
>> >> An alternative might be to store the information obtained from _CRS in
>> >> struct acpi_device objects created by the ACPI core while parsing the
>> >> namespace.  We do that already for things like _PRW, so we might as well do it
>> >> for _CRS.  Then, the SPI core could just walk the subtree of the device hierarchy
>> >> below the SPI controller's acpi_device to extract that information.
>> >> Maybe that's the way to go?
>> >
>> > The general idea is to move the _CRS parsing routine from acpi_platform.c
>> > to scan.c and make it attach resource objects to struct acpi_device.
>> >
>> > I'm thinking about adding a list head to struct acpi_device pointing to a
>> > list of entries like:
>> >
>> > struct resource_list_entry {
>> >         struct list_head node;
>> >         struct resource *resources;
>> >         unsigned int count;
>> > };
>> >
>> > where "resources" is an array of resources (e.g. interrupts) in the given
>> > entry and count is the size of that array.
>> >
>> > That list would contain common resources like ACPI_RESOURCE_TYPE_FIXED_MEMORY32,
>> > ACPI_RESOURCE_TYPE_IRQ, ACPI_RESOURCE_TYPE_ADDRESS32, ACPI_RESOURCE_TYPE_EXTENDED_IRQ.
>>
>> This is exactly what PNPACPI already does.  For every Device node in
>> the namespace, pnpacpi/rsparser.c parses _CRS and builds a list of
>> struct resources that correspond to it.  If you put this functionality
>> in acpi/scan.c, should we get rid of PNPACPI?
>
> Quite likely.  At least this part of it, if you want the core to parse
> resources.
>
> That said, I actually tried to abstract out resource parsing in a more generic
> fashion on the basis of our new platform device support code, but quite frankly
> I wasn't able to.
>
> The problem is that struct resource is too simple to be useful for representing
> all of the information that can be encoded in ACPI resources.  As a result, some
> information have to be stored directly in things like struct pnp_dev, struct
> platform_device etc. and if we want to represent it generically, the only way
> to do that seems to be using the ACPICA resource types as defined in acrestyp.h.

Really?  I didn't have that impression.  It might be that the new GPIO
and SERIAL_BUS stuff makes it too complicated for a struct resource,
but prior to that, I don't think it was.  It's true that there are
many different formats (IO, FIXED_IO, MEMORY24, MEMORY32, etc.), but
only the core needs to be aware of the encoding of all those formats.
As far as a *driver* is concerned, there are only IRQ, DMA, IO, and
MEM resources, and those fit easily in a struct resource.

I want to expand on what I said before about _CRS being the domain of
the core, not drivers.  The core must evaluate _CRS to know where
devices are and avoid conflicts when assigning resources.  The core
must evaluate _PRS and _SRS when making resource assignments.  It
doesn't make sense for drivers to be using _PRS and _SRS; they don't
have a global view of resources, and any assignment they make would
likely cause conflicts with other devices.  I think it makes sense to
consolidate all _CRS, _PRS, and _SRS management in the core rather
than splitting it up.  This is exactly analogous to PCI BAR
management, and we don't intend drivers to read and write BARs
directly.

Bjorn
