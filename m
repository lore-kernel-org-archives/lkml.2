Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2JDUU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:20:28 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59413 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693Ab2JDUUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:20:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 0/4] ACPI: kill acpi_pci_root_start
Date: Thu, 04 Oct 2012 21:53:02 +0200
Message-ID: <11181546.I8dMpGB7VY@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.4.6-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121004174746.GA24119@google.com>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com> <1349305214-3241-1-git-send-email-yinghai@kernel.org> <20121004174746.GA24119@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 of October 2012 11:47:46 Bjorn Helgaas wrote:
> On Wed, Oct 03, 2012 at 04:00:10PM -0700, Yinghai Lu wrote:
> > Now acpi_pci_root_driver has two ops: .add and .start, aka acpi_pci_root_add
> > and acpi_pci_root_start.
> > 
> > That is for hotplug handling: .add need to return early to make sure all
> > acpi device could be created and added early. So .start could device_add
> > pci device that are found in acpi_pci_root_add/pci_acpi_scan_root().
> > 
> > That is holding pci devics to be out of devices for while.
> > 
> > We could use bus notifier to handle hotplug case.
> > 	CONFIG_HOTPLUG is enabled always now.
> > Need to add drivers_autoprobe bit in acpi_device to hold attaching drivers
> > for acpi_devices, so could make sure all acpi_devices get created at first.
> > Then acpi_bus_attach() that is called from acpi_bus_add will attach driver
> > for all acpi_devices that are just created.
> > 
> > That make the logic more simple: hotplug path handling just like booting path
> > that drivers are attached after all acpi device get created.
> > 
> > At last we could remove all acpi_bus_start workaround.
> 
> I think we should get rid of ACPI .start() methods, but I'm opposed to this
> approach of fiddling with driver binding order.
> 
> At hot-plug time, the pci_root.c driver is already loaded, then we enumerate
> the new host bridge.  Since pci_root.c is already loaded, we bind the driver
> before descending the ACPI tree below the host bridge.  We need to make that
> same ordering work at boot-time.
> 
> At boot-time, we currently enumerate ALL ACPI devices before registering
> the pci_root.c driver:
> 
>     acpi_init				# subsys_initcall
> 	acpi_scan_init
> 	    acpi_bus_scan		# enumerate ACPI devices
> 
>     acpi_pci_root_init			# subsys_initcall for pci_root.c
> 	acpi_bus_register_driver
> 	    ...
> 		acpi_pci_root_add	# pci_root.c add method
> 
> This is a fundamental difference: at boot-time, all the ACPI devices below the
> host bridge already exist before the pci_root.c driver claims the bridge,
> while at hot-add time, pci_root.c claims the bridge *before* those ACPI
> devices exist.
> 
> I think this is wrong.  The hot-plug case (where the driver is already
> loaded and binds to the device as soon as it's discovered, before the
> ACPI hierarchy below it is enumerated) seems like the obviously correct
> order.  I think we should change the boot-time order to match that, i.e.,
> we should register pci_root.c *before* enumerating ACPI devices.
> 
> I realize that this will require changes in the way we bind PCI and ACPI
> devices.  I pointed that out in a previous response, appended below for
> convenience:
> 
> On Tue, Oct 2, 2012 at 4:38 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> 
> >> We enumerate ACPI devices by doing a depth-first traversal of the
> >> namespace.  We should be able to bind a driver to a device as soon as
> >> we discover it.  For PNP0A03/08 host bridges, that will be the
> >> pci_root.c driver.  That driver's .add() method enumerates all the PCI
> >> devices behind the host bridge, which is another depth-first
> >> traversal, this time of the PCI hierarchy.  Similarly, we ought to be
> >> able to bind drivers to the PCI devices as we discover them.
> >
> >> But the PCI/ACPI binding is an issue here, because the ACPI
> >> enumeration hasn't descended below the host bridge yet, so we have the
> >> pci_dev structs but the acpi_device structs don't exist yet.  I think
> >> this is part of the reason for the .add()/.start() split.  But I don't
> >> think the split is the correct solution.  I think we need to think
> >> about the binding in a different way.  Maybe we don't bind at all and
> >> instead search the namespace every time we need the association.  Or
> >> maybe we do the binding but base it on the acpi_handle (which exists
> >> before the ACPI subtree has been enumerated) rather than the
> >> acpi_device (which doesn't exist until we enumerate the subtree).
> >> It's not even clear to me that we should build acpi_device structs for
> >> things that already have pci_dev structs.

No, we shouldn't.

We generally have problems in this area, not only with PCI.  For
example, some platform x86 drivers cannot bind to the devices they
should handle, because there's a "generic" ACPI driver that binds to
the device in question earlier.

My personal opinion is that so called "ACPI devices" (i.e. things
represented by struct acpi_device) are generally partially redundant, because
either they already have "sibling" struct device objects representing "real"
devices, like PCI, SATA or PNP, or there should be struct platform_device
"sibling" objects corresponding to them.  Moreover, all ACPI drivers can be
replaced with platform drivers and the only problem is the .notify() callback
that is not present in struct platform_driver. So perhaps we can create
a "real device" for every "ACPI device" we discover (if there isn't one
already) and stop using ACPI drivers entirely, eventually.

That also may help to address the problem of hypothetical future systems
with ACPI tables describing the same hardware that we already have device
tree representation for. In those cases drivers should work regardless of
whether the information on devices is read from ACPI tables or from device
trees and quite frankly I don't see how we can achieve this with the
existing ACPI drivers.

Perhaps we don't even need the ACPI bus type and struct acpi_device
objects can be treated simply as storage of information used by the generic
ACPI power management code etc. I'm not sure how to get there yet in the
least painful way, but I think it would make things generally more
straightforward.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
