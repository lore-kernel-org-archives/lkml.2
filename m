Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2LZUEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 15:04:21 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:39250 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab2LZUES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 15:04:18 -0500
MIME-Version: 1.0
In-Reply-To: <5457615.T2WjKPXXC4@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
	<150695156.KNRhubloU5@vostro.rjw.lan>
	<CAErSpo5ZpUaHzYQEpR9Jh0MbcmjHfhKUQ-EpRJH1PNCHR_qnVg@mail.gmail.com>
	<5457615.T2WjKPXXC4@vostro.rjw.lan>
Date: Wed, 26 Dec 2012 12:04:16 -0800
X-Google-Sender-Auth: Zf3GBPaeHCVz6D7wCSxZuvpN3dw
Message-ID: <CAE9FiQUBpu+rUfnvOwDUm8PTYYVfann3SyhhL4k=54EyfRSmLg@mail.gmail.com>
Subject: Re: [Alternative][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 2:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: PCI / ACPI: Set root bridge ACPI handle in advance
>
> The ACPI handles of PCI root bridges need to be known to
> acpi_bind_one(), so that it can create the appropriate
> "firmware_node" and "physical_node" files for them, but currently
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
>
> Accordingly, add a new __weak routine, pcibios_root_bridge_prepare(),
> defaulting to an empty implementation that can be replaced by the
> interested architecutres (x86 and ia64 at the moment) with functions
> that will set the root bridge's ACPI handle before its dev member is
> passed to device_register().  Make both x86 and ia64 provide such
> implementations of pcibios_root_bridge_prepare() and remove
> acpi_pci_find_root_bridge() and acpi_get_pci_rootbridge_handle() that aren't
> necessary any more.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>
> Bjorn,
>
> Since you didn't like the implementation used in the previous patch, here's
> an alternative one using a __weak function.
>
> I don't really strongly prefer any of them.  The advantage of the present one
> is that it changes fewer files and directly affects fewer architectures.  The
> disadvantage of it is the addition of the __weak "callback".
>
> I wonder what the maintainers of the architectures in question (Peter, Tony)
> think.
>
> Thanks,
> Rafael
>
> ---
>  arch/ia64/pci/pci.c     |    8 ++++++++
>  arch/x86/pci/acpi.c     |    9 +++++++++
>  drivers/acpi/pci_root.c |   18 ------------------
>  drivers/pci/pci-acpi.c  |   19 -------------------
>  drivers/pci/probe.c     |   16 ++++++++++++++++
>  include/acpi/acpi_bus.h |    1 -
>  include/linux/pci.h     |    2 ++
>  7 files changed, 35 insertions(+), 38 deletions(-)
>
> Index: linux/drivers/pci/probe.c
> ===================================================================
> --- linux.orig/drivers/pci/probe.c
> +++ linux/drivers/pci/probe.c
> @@ -1632,6 +1632,18 @@ unsigned int pci_scan_child_bus(struct p
>         return max;
>  }
>
> +/**
> + * pcibios_root_bridge_prepare - Platform-specific host bridge setup.
> + * @bridge: Host bridge to set up.
> + *
> + * Default empty implementation.  Replace with an architecture-specific setup
> + * routine, if necessary.
> + */
> +int __weak pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
> +{
> +       return 0;
> +}
> +

You may need to put that weak version to another file.

some version gcc/ld will inline the weak version directly if it is in same file.

otherwise

Acked-by: Yinghai Lu <yinghai@kernel.org>
