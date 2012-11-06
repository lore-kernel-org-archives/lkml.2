Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab2KFNjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:39:10 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:58338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab2KFNjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:39:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Date: Tue, 06 Nov 2012 14:43:19 +0100
Message-ID: <1815967.2MF0PyW36l@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAErSpo6gfL+QFoWK+8ahYAj+vnp4OCn4B=-vALGbU_LnsyT8oQ@mail.gmail.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <4052192.ry8JrGTr6H@vostro.rjw.lan> <CAErSpo6gfL+QFoWK+8ahYAj+vnp4OCn4B=-vALGbU_LnsyT8oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 05, 2012 09:54:42 AM Bjorn Helgaas wrote:
> On Mon, Nov 5, 2012 at 3:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday, November 03, 2012 09:59:28 PM Rafael J. Wysocki wrote:
> >> On Saturday, November 03, 2012 10:13:10 PM Mika Westerberg wrote:
> >> > On Sat, Nov 03, 2012 at 01:42:02PM -0600, Bjorn Helgaas wrote:
> >> > > On Sat, Nov 3, 2012 at 1:46 AM, Mika Westerberg
> >> > > <mika.westerberg@linux.intel.com> wrote:
> >> > > > ACPI 5 introduced SPISerialBus resource that allows us to enumerate and
> >> > > > configure the SPI slave devices behind the SPI controller. This patch adds
> >> > > > support for this to the SPI core.
> > [...]
> >> > And if the ACPI core parses the _CRS, how does it pass all the resources to
> >> > the drivers?
> >>
> >> Pretty much the same way the $subject patch does.
> >>
> >> Instead of parsing the entire subtree below an SPI controller and trying
> >> acpi_spi_add_device() for each device node in there, it could call
> >> acpi_spi_add_device() whenever it finds a device of type
> >> ACPI_RESOURCE_TYPE_SERIAL_BUS/ACPI_RESOURCE_SERIAL_TYPE_SPI.
> >> The only problem is how to pass "master" to it.
> >>
> >> So Bjorn, do you have any idea how we could pass the "master" pointer from the
> >> ACPI core to acpi_spi_add_device() in a sensible way?
> >>
> >> An alternative might be to store the information obtained from _CRS in
> >> struct acpi_device objects created by the ACPI core while parsing the
> >> namespace.  We do that already for things like _PRW, so we might as well do it
> >> for _CRS.  Then, the SPI core could just walk the subtree of the device hierarchy
> >> below the SPI controller's acpi_device to extract that information.
> >> Maybe that's the way to go?
> >
> > The general idea is to move the _CRS parsing routine from acpi_platform.c
> > to scan.c and make it attach resource objects to struct acpi_device.
> >
> > I'm thinking about adding a list head to struct acpi_device pointing to a
> > list of entries like:
> >
> > struct resource_list_entry {
> >         struct list_head node;
> >         struct resource *resources;
> >         unsigned int count;
> > };
> >
> > where "resources" is an array of resources (e.g. interrupts) in the given
> > entry and count is the size of that array.
> >
> > That list would contain common resources like ACPI_RESOURCE_TYPE_FIXED_MEMORY32,
> > ACPI_RESOURCE_TYPE_IRQ, ACPI_RESOURCE_TYPE_ADDRESS32, ACPI_RESOURCE_TYPE_EXTENDED_IRQ.
> 
> This is exactly what PNPACPI already does.  For every Device node in
> the namespace, pnpacpi/rsparser.c parses _CRS and builds a list of
> struct resources that correspond to it.  If you put this functionality
> in acpi/scan.c, should we get rid of PNPACPI?

Quite likely.  At least this part of it, if you want the core to parse
resources.

That said, I actually tried to abstract out resource parsing in a more generic
fashion on the basis of our new platform device support code, but quite frankly
I wasn't able to.

The problem is that struct resource is too simple to be useful for representing
all of the information that can be encoded in ACPI resources.  As a result, some
information have to be stored directly in things like struct pnp_dev, struct
platform_device etc. and if we want to represent it generically, the only way
to do that seems to be using the ACPICA resource types as defined in acrestyp.h.

So we can attach a list of things like

struct acpi_resource_list_entry {
	struct list_head node;
	struct acpi_resource resource;
};

to struct acpi_device, but that doesn't help much, because the different
bus types will then need to extract the information they need from that list
anyway.  It would reduce the number of _CRS invocations, but beyond that I'm
not sure how usefult it's going to be.

Still, we probably should centralize things like
pnpacpi_parse_allocated_irqresource() to avoid duplicating that code.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
