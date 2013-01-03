Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3ACWVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:21:20 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:43011 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab3ACWVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:21:17 -0500
MIME-Version: 1.0
In-Reply-To: <1635295.TkbrarASZn@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan> <1626213.gpPY5etSgn@vostro.rjw.lan>
 <2695660.jbNleTYArh@vostro.rjw.lan> <1635295.TkbrarASZn@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 3 Jan 2013 15:13:31 -0700
Message-ID: <CAErSpo7QFKm=teLDBqCUueZwVHZKbA+pfNhrVc-_hK8PmwK2JQ@mail.gmail.com>
Subject: Re: [Alternative 2][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 2:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, January 03, 2013 01:11:30 PM Rafael J. Wysocki wrote:
>> On Thursday, January 03, 2013 01:40:52 AM Rafael J. Wysocki wrote:
>> > On Wednesday, January 02, 2013 04:07:32 PM Bjorn Helgaas wrote:
>> > > On Thu, Dec 27, 2012 at 10:32:13PM +0100, Rafael J. Wysocki wrote:
>> > > > To that end, split pci_create_root_bus() into two functions,
>> > > > pci_alloc_root() and pci_add_root(), that will allocate memory for
>> > > > the new PCI bus and bridge representations and register them with
>> > > > the driver core, respectively, and that may be called directly by
>> > > > the architectures that need to set the root bridge's ACPI handle
>> > > > before registering it.
>> > >
>> > > I'm trying to *reduce* the interfaces for creating and scanning PCI
>> > > host bridges, and this is a step in the opposite direction.
>> >
>> > Yes it is.
>> >
>> > The alternative is to make the root bridge initialization code more complex.
>>
>> Well, maybe not so much.
>>
>> What about adding an extra arg to pci_create_root_bus(), ie. the patch below
>> (changelog skipped for now)?
>>
>> I admit that having two void * args there is a little awkward, but at least
>> it's totally generic.
>>
>> > > > Next, Make both x86 and ia64 (the only architectures using ACPI at
>> > > > the moment) call pci_alloc_root(), set the root bridge's ACPI handle
>> > > > and then call pci_add_root() in their pci_acpi_scan_root() routines
>> > > > instead of calling pci_create_root_bus().  For the other code paths
>> > > > adding PCI root bridges define a new pci_create_root_bus() as a
>> > > > simple combination of pci_alloc_root() and pci_add_root().
>> > >
>> > > pci_create_root_bus() takes a "struct device *parent" argument.  That
>> > > seems like a logical place to tell the PCI core about the host bridge
>> > > device, but x86 and ia64 currently pass NULL there.
>> >
>> > And there's a reason for that.  Namely, on these architectures PCI host
>> > bridges have no physical parents (well, at least in current practice).
>> >
>> > > The patch below shows what I'm thinking.  It does have the side-effect
>> > > of changing the sysfs topology from this:
>> > >
>> > >     /sys/devices/pci0000:00
>> > >     /sys/devices/pci0000:00/0000:00:00.0
>> > >
>> > > to this:
>> > >
>> > >     /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/pci0000:00
>> > >     /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/pci0000:00/0000:00:00.0
>> > >
>> > > because it puts the PCI root bus (pci0000:00) under the PNP0A08 device
>> > > rather than at the top level.
>> >
>> > Which is wrong.
>> >
>> > PNP0A08 is not a parent of the host bridge, but its ACPI "companion" (ie. ACPI
>> > namespace node representing the host bridge itself).
>> >
>> > > That seems like an improvement to me, but it *is* different.
>> >
>> > Well, then we should make every ACPI device node corresponding to a PCI device
>> > be a parent of that device's struct pci_dev and so on for other bus types.  It
>> > doesn't sound like an attractive idea. :-)  Moreover, it is impossible, because
>> > those things generally already have parents (struct pci_dev objects have them
>> > at least).
>> >
>> > That said the idea to pass something meaningful in the parent argument
>> > of pci_create_root_bus() can be implemented if we create a "physical" device
>> > object corresponding to "device:00" (which is an ACPI namespace node) in your
>> > example.
>> >
>> > From what I can tell, "device:00" always corresponds to the ACPI _SB scope
>> > (which is mandatory), so in principle we can create an abstract "physical"
>> > device object for it and call it something like "system_root".  Then, if we
>> > use it as the parent of pci0000:00 (the host bridge), then we'll have
>> >
>> >      /sys/devices/system_root/pci0000:00
>> >      /sys/devices/system_root/pci0000:00/0000:00:00.0
>>
>> Having considered that a little more I don't really think it's a good idea.
>> It still would be going a little backwards, because we'd need to use the parent
>> to get an ACPI handle known already beforehand.
>
> One more thing.
>
> The sysfs locations of PCI devices shouldn't change if acpi=off is passed to
> the kernel, so the above is not a good idea at all, I'm afraid.

I don't think there's a requirement that sysfs with acpi=off be the
same as with it on.  acpi=off is only a debugging tool.  With acpi=off
we ignore all the topology information we get from ACPI, and the
location of PCI host bridges is part of that topology.  We shouldn't
cripple sysfs when we're using ACPI just so it matches the acpi=off
case.

Of course, we might not want to change this in sysfs anyway; I just
don't think acpi=off is a valid reason to avoid a change.

Bjorn
