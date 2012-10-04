Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853Ab2JDRyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:54:11 -0400
Received: from mail-we0-f202.google.com ([74.125.82.202]:46662 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2JDRyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:54:10 -0400
Date: Thu, 4 Oct 2012 11:47:46 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4] ACPI: kill acpi_pci_root_start
Message-ID: <20121004174746.GA24119@google.com>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
 <1349305214-3241-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349305214-3241-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:00:10PM -0700, Yinghai Lu wrote:
> Now acpi_pci_root_driver has two ops: .add and .start, aka acpi_pci_root_add
> and acpi_pci_root_start.
> 
> That is for hotplug handling: .add need to return early to make sure all
> acpi device could be created and added early. So .start could device_add
> pci device that are found in acpi_pci_root_add/pci_acpi_scan_root().
> 
> That is holding pci devics to be out of devices for while.
> 
> We could use bus notifier to handle hotplug case.
> 	CONFIG_HOTPLUG is enabled always now.
> Need to add drivers_autoprobe bit in acpi_device to hold attaching drivers
> for acpi_devices, so could make sure all acpi_devices get created at first.
> Then acpi_bus_attach() that is called from acpi_bus_add will attach driver
> for all acpi_devices that are just created.
> 
> That make the logic more simple: hotplug path handling just like booting path
> that drivers are attached after all acpi device get created.
> 
> At last we could remove all acpi_bus_start workaround.

I think we should get rid of ACPI .start() methods, but I'm opposed to this
approach of fiddling with driver binding order.

At hot-plug time, the pci_root.c driver is already loaded, then we enumerate
the new host bridge.  Since pci_root.c is already loaded, we bind the driver
before descending the ACPI tree below the host bridge.  We need to make that
same ordering work at boot-time.

At boot-time, we currently enumerate ALL ACPI devices before registering
the pci_root.c driver:

    acpi_init				# subsys_initcall
	acpi_scan_init
	    acpi_bus_scan		# enumerate ACPI devices

    acpi_pci_root_init			# subsys_initcall for pci_root.c
	acpi_bus_register_driver
	    ...
		acpi_pci_root_add	# pci_root.c add method

This is a fundamental difference: at boot-time, all the ACPI devices below the
host bridge already exist before the pci_root.c driver claims the bridge,
while at hot-add time, pci_root.c claims the bridge *before* those ACPI
devices exist.

I think this is wrong.  The hot-plug case (where the driver is already
loaded and binds to the device as soon as it's discovered, before the
ACPI hierarchy below it is enumerated) seems like the obviously correct
order.  I think we should change the boot-time order to match that, i.e.,
we should register pci_root.c *before* enumerating ACPI devices.

I realize that this will require changes in the way we bind PCI and ACPI
devices.  I pointed that out in a previous response, appended below for
convenience:

On Tue, Oct 2, 2012 at 4:38 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

>> We enumerate ACPI devices by doing a depth-first traversal of the
>> namespace.  We should be able to bind a driver to a device as soon as
>> we discover it.  For PNP0A03/08 host bridges, that will be the
>> pci_root.c driver.  That driver's .add() method enumerates all the PCI
>> devices behind the host bridge, which is another depth-first
>> traversal, this time of the PCI hierarchy.  Similarly, we ought to be
>> able to bind drivers to the PCI devices as we discover them.
>
>> But the PCI/ACPI binding is an issue here, because the ACPI
>> enumeration hasn't descended below the host bridge yet, so we have the
>> pci_dev structs but the acpi_device structs don't exist yet.  I think
>> this is part of the reason for the .add()/.start() split.  But I don't
>> think the split is the correct solution.  I think we need to think
>> about the binding in a different way.  Maybe we don't bind at all and
>> instead search the namespace every time we need the association.  Or
>> maybe we do the binding but base it on the acpi_handle (which exists
>> before the ACPI subtree has been enumerated) rather than the
>> acpi_device (which doesn't exist until we enumerate the subtree).
>> It's not even clear to me that we should build acpi_device structs for
>> things that already have pci_dev structs.
