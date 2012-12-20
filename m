Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2LTWvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:51:07 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39241 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab2LTWu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:50:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [Update 2][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
Date: Thu, 20 Dec 2012 23:56:07 +0100
Message-ID: <150695156.KNRhubloU5@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAErSpo7NWHmSEJMuytUTziRTwUmnPHCVcD0zX7pKVmhQyv26sQ@mail.gmail.com>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan> <3596215.suSiEFiGH8@vostro.rjw.lan> <CAErSpo7NWHmSEJMuytUTziRTwUmnPHCVcD0zX7pKVmhQyv26sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 20, 2012 02:13:15 PM Bjorn Helgaas wrote:
> [+cc linux-pci, Myron]
> 
> On Mon, Dec 17, 2012 at 4:30 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > The ACPI handles of PCI root bridges need to be known to
> > acpi_bind_one(), so that it can create the appropriate
> > "firmware_node" and "physical_node" files for them, but currently
> > the way it gets to know those handles is not exactly straightforward
> > (to put it lightly).
> >
> > This is how it works, roughly:
> >
> >   1. acpi_bus_scan() finds the handle of a PCI root bridge,
> >      creates a struct acpi_device object for it and passes that
> >      object to acpi_pci_root_add().
> >
> >   2. acpi_pci_root_add() creates a struct acpi_pci_root object,
> >      populates its "device" field with its argument's address
> >      (device->handle is the ACPI handle found in step 1).
> >
> >   3. The struct acpi_pci_root object created in step 2 is passed
> >      to pci_acpi_scan_root() and used to get resources that are
> >      passed to pci_create_root_bus().
> >
> >   4. pci_create_root_bus() creates a struct pci_host_bridge object
> >      and passes its "dev" member to device_register().
> >
> >   5. platform_notify(), which for systems with ACPI is set to
> >      acpi_platform_notify(), is called.
> >
> > So far, so good.  Now it starts to be "interesting".
> >
> >   6. acpi_find_bridge_device() is used to find the ACPI handle of
> >      the given device (which is the PCI root bridge) and executes
> >      acpi_pci_find_root_bridge(), among other things, for the
> >      given device object.
> >
> >   7. acpi_pci_find_root_bridge() uses the name (sic!) of the given
> >      device object to extract the segment and bus numbers of the PCI
> >      root bridge and passes them to acpi_get_pci_rootbridge_handle().
> >
> >   8. acpi_get_pci_rootbridge_handle() browses the list of ACPI PCI
> >      root bridges and finds the one that matches the given segment
> >      and bus numbers.  Its handle is then used to initialize the
> >      ACPI handle of the PCI root bridge's device object by
> >      acpi_bind_one().  However, this is *exactly* the ACPI handle we
> >      started with in step 1.
> >
> > Needless to say, this is quite embarassing, but it may be avoided
> > thanks to commit f3fd0c8 (ACPI: Allow ACPI handles of devices to be
> > initialized in advance), which makes it possible to initialize the
> > ACPI handle of a device before passing it to device_register().
> 
> This was a mess.  Thanks for cleaning it up.
> 
> > Accordingly, make pci_acpi_scan_root() pass the root bridge's ACPI
> > handle to pci_create_root_bus() and make the latter set the ACPI
> > handle in its struct pci_host_bridge object's "dev" member before
> > passing it to device_register(), so that steps 6-8 above aren't
> > necessary any more.
> >
> > To implement that, I decided to repurpose the 4th argument of
> > pci_create_root_bus(), because that allowed me to avoid defining
> > additional callbacks or similar things and didn't seem to impact
> > architectures without ACPI substantially.
> >
> > All architectures using pci_create_root_bus() directly are updated
> > as needed, but only x86 and ia64 are affected as far as the behavior
> > is concerned (no one else uses ACPI).  There should be no changes in
> > behavior resulting from this on the other architectures.
> 
> I'd like to converge all architectures on a single higher-level
> interface, pci_scan_root_bus(), then deprecate and remove
> pci_create_root_bus(), pci_scan_bus_parented(), and pci_scan_bus().
> You're changing the underlying pci_create_root_bus(), but not the
> higher-level interfaces that use it, which will make converging a bit
> harder.

Do you mean that pci_scan_root_bus() and friends should take a
struct pci_root_sys_info pointer rather than (void *) as an argument?
That's not too difficult to do on top of my patch.  I can do that if you
want me to, no problem.

> Here's an alternate implementation strategy; see what you think:
> 
> - Add "struct acpi_dev_node acpi_node" to struct pci_sysdata (x86) and
> struct pci_controller (ia64).  These are the only two arches that use
> ACPI.
> 
> - Add an empty generic (weak) pcibios_create_root_ bus().

Well, in my opinion things like that make following the code more difficult.
If you were new to the code in question and wanted to understand what it was
doing, you'd need to inspect all architectures to see (1) if they defined
pcibios_create_root_bus() and (2) what was in there if so.

> - Add pcibios_create_root_bus() for x86 and ia64 that does the
> ACPI_HANDLE_SET().
> 
> It does add a pcibios callback, which you were trying to avoid, but it
> does have the advantages that all the higher-level interfaces that use
> pci_create_root_bus() will keep working and only the ACPI arches have
> the acpi_dev_node member and associated code.

All of the things that use pci_create_root_bus() are still working with my
patch applied, hopefully. :-)

You seem to would like the headers of all the involved functions, including
pci_create_root_bus(), not to change.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
