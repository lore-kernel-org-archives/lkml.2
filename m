Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab3AIX1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 18:27:33 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:61514 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab3AIX1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 18:27:31 -0500
MIME-Version: 1.0
In-Reply-To: <1910593.f2RrgAtJJO@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
	<16795012.QL1jNHE7JM@vostro.rjw.lan>
	<CAErSpo473rZOBERaMJV74rfGZXSuBdiPtX=mXmcLmO=CRB4P_g@mail.gmail.com>
	<1910593.f2RrgAtJJO@vostro.rjw.lan>
Date: Wed, 9 Jan 2013 15:27:29 -0800
X-Google-Sender-Auth: b0b8Y-y1SmgJzVTBiRC1frK4U-o
Message-ID: <CAE9FiQW4t17=gYC1dnyCVJUQ3rvV491uiA5U1ZjLWjraM=g9rQ@mail.gmail.com>
Subject: Re: [Alternative][PATCH] ACPI / PCI: Set root bridge ACPI handle in
 advance, v2
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 3:06 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, January 09, 2013 03:16:59 PM Bjorn Helgaas wrote:
>> On Wed, Jan 9, 2013 at 2:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> >
>> > The ACPI handles of PCI root bridges need to be known to
>> > acpi_bind_one(), so that it can create the appropriate
>> > "firmware_node" and "physical_node" files for them, but currently
>> > the way it gets to know those handles is not exactly straightforward
>> > (to put it lightly).
>> >
>> > This is how it works, roughly:
>> >
>> >   1. acpi_bus_scan() finds the handle of a PCI root bridge,
>> >      creates a struct acpi_device object for it and passes that
>> >      object to acpi_pci_root_add().
>> >
>> >   2. acpi_pci_root_add() creates a struct acpi_pci_root object,
>> >      populates its "device" field with its argument's address
>> >      (device->handle is the ACPI handle found in step 1).
>> >
>> >   3. The struct acpi_pci_root object created in step 2 is passed
>> >      to pci_acpi_scan_root() and used to get resources that are
>> >      passed to pci_create_root_bus().
>> >
>> >   4. pci_create_root_bus() creates a struct pci_host_bridge object
>> >      and passes its "dev" member to device_register().
>> >
>> >   5. platform_notify(), which for systems with ACPI is set to
>> >      acpi_platform_notify(), is called.
>> >
>> > So far, so good.  Now it starts to be "interesting".
>> >
>> >   6. acpi_find_bridge_device() is used to find the ACPI handle of
>> >      the given device (which is the PCI root bridge) and executes
>> >      acpi_pci_find_root_bridge(), among other things, for the
>> >      given device object.
>> >
>> >   7. acpi_pci_find_root_bridge() uses the name (sic!) of the given
>> >      device object to extract the segment and bus numbers of the PCI
>> >      root bridge and passes them to acpi_get_pci_rootbridge_handle().
>> >
>> >   8. acpi_get_pci_rootbridge_handle() browses the list of ACPI PCI
>> >      root bridges and finds the one that matches the given segment
>> >      and bus numbers.  Its handle is then used to initialize the
>> >      ACPI handle of the PCI root bridge's device object by
>> >      acpi_bind_one().  However, this is *exactly* the ACPI handle we
>> >      started with in step 1.
>> >
>> > Needless to say, this is quite embarassing, but it may be avoided
>> > thanks to commit f3fd0c8 (ACPI: Allow ACPI handles of devices to be
>> > initialized in advance), which makes it possible to initialize the
>> > ACPI handle of a device before passing it to device_register().
>> >
>> > Accordingly, add a new __weak routine, pcibios_root_bridge_prepare(),
>> > defaulting to an empty implementation that can be replaced by the
>> > interested architecutres (x86 and ia64 at the moment) with functions
>> > that will set the root bridge's ACPI handle before its dev member is
>> > passed to device_register().  Make both x86 and ia64 provide such
>> > implementations of pcibios_root_bridge_prepare() and remove
>> > acpi_pci_find_root_bridge() and acpi_get_pci_rootbridge_handle() that
>> > aren't necessary any more.
>> >
>> > Included is a fix for breakage on systems with non-ACPI PCI host
>> > bridges from Bjorn Helgaas.
>> >
>> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> Looks good to me!
>>
>> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>
> Thanks!
>
> I'll wait for comments from the others, if any, and put it into my acpi-scan
> branch after a couple of days.  It doesn't need to be there technically, but
> it's kind of related.

I tested it with acpi-scan and pci-root-bus-hotplug patchset, and it works well.
so
Acked-by: Yinghai Lu <yinghai@kernel.org>

BTW, found one left over of change about ->acpi_handle==> ACPI_HANDLE..

Index: linux-2.6/drivers/acpi/glue.c
===================================================================
--- linux-2.6.orig/drivers/acpi/glue.c
+++ linux-2.6/drivers/acpi/glue.c
@@ -311,7 +311,7 @@ static int acpi_platform_notify(struct d
        if (!ret) {
                struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };

-               acpi_get_name(dev->acpi_handle, ACPI_FULL_PATHNAME, &buffer);
+               acpi_get_name(ACPI_HANDLE(dev), ACPI_FULL_PATHNAME, &buffer);
                DBG("Device %s -> %s\n", dev_name(dev), (char *)buffer.pointer);
                kfree(buffer.pointer);
        } else


otherwise will get compiling error when enable acpi glue debug.

Thanks

Yinghai
