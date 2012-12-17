Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2LQRYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:24:18 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47746 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2LQRYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:24:16 -0500
MIME-Version: 1.0
In-Reply-To: <4085861.TBmZVTPOvU@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
	<4085861.TBmZVTPOvU@vostro.rjw.lan>
Date: Mon, 17 Dec 2012 09:24:14 -0800
X-Google-Sender-Auth: jrq2juU8_xA8Lhxx7m6csu0Vo7w
Message-ID: <CAE9FiQVaQqkNwZ1dKipC6ohmMMUthsoLcHr125u=N=GYHOs62Q@mail.gmail.com>
Subject: Re: [Update][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, tony.luck@intel.com,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 4:20 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The ACPI handles of PCI root bridges need to be known to
> acpi_bind_one(), so that it can create the appropriate
> "firmware_node" and "physical_node0" files for them, but currently
> the way it gets to know those handles is not exactly straightforward
> (to put it lightly).
>
> This is how it works, roughly:
>
>   1. acpi_bus_scan() finds the handle of a PCI root bridge,
>      creates a struct acpi_device object for it and passes that
>      object to acpi_pci_root_add().
>
>   2. acpi_pci_root_add() creates a struct acpi_pci_root object,
>      populates its "device" field with its argument's address
>      (device->handle is the ACPI handle found in step 1).
>
>   3. The struct acpi_pci_root object created in step 2 is passed
>      to pci_acpi_scan_root() and used to get resources that are
>      passed to pci_create_root_bus().
>
>   4. pci_create_root_bus() creates a struct pci_host_bridge object
>      and passes its "dev" member to device_register().
>
>   5. platform_notify(), which for systems with ACPI is set to
>      acpi_platform_notify(), is called.
>
> So far, so good.  Now it starts to be "interesting".
>
>   6. acpi_find_bridge_device() is used to find the ACPI handle of
>      the given device (which is the PCI root bridge) and executes
>      acpi_pci_find_root_bridge(), among other things, for the
>      given device object.
>
>   7. acpi_pci_find_root_bridge() uses the name (sic!) of the given
>      device object to extract the segment and bus numbers of the PCI
>      root bridge and passes them to acpi_get_pci_rootbridge_handle().
>
>   8. acpi_get_pci_rootbridge_handle() browses the list of ACPI PCI
>      root bridges and finds the one that matches the given segment
>      and bus numbers.  Its handle is then used to initialize the
>      ACPI handle of the PCI root bridge's device object by
>      acpi_bind_one().  However, this is *exactly* the ACPI handle we
>      started with in step 1.
>
> Needless to say, this is quite embarassing, but it may be avoided
> thanks to commit f3fd0c8 (ACPI: Allow ACPI handles of devices to be
> initialized in advance), which makes it possible to initialize the
> ACPI handle of a device before passing it to device_register().
> Namely, if pci_acpi_scan_root() could easily pass the root bridge's
> ACPI handle to pci_create_root_bus(), the latter could set the ACPI
> handle in its struct pci_host_bridge object's "dev" member before
> passing it to device_register() and steps 6-8 above wouldn't be
> necessary any more.
>
> To make that happen I decided to repurpose the 4th argument of
> pci_create_root_bus(), because that allowed me to avoid defining
> additional callbacks or similar things and didn't seem to impact
> architectures without ACPI substantially.
>
> All architectures using pci_create_root_bus() directly are updated
> as needed, but only x86 and ia64 are affected as far as the behavior
> is concerned (no one else uses ACPI).  There should be no changes in
> behavior resulting from this on the other architectures.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Yinghai Lu <yinghai@kernel.org>

and the ones in your acpi_scan_temp branches.

Thanks a lot.

Yinghai
