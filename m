Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2LMBAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:00:45 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63211 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2LMBAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:00:40 -0500
MIME-Version: 1.0
In-Reply-To: <1772854.QSySvgjB3i@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <1772854.QSySvgjB3i@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 12 Dec 2012 18:00:19 -0700
Message-ID: <CAErSpo4_2TMjW65w0wwWpYRDMMRvWxJU_+wgyMFXmTzOaQhQAA@mail.gmail.com>
Subject: Re: [PATCH 2/6] ACPI: Change the ordering of PCI root bridge driver registrarion
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 9, 2012 at 4:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Devices created by acpi_create_platform_device() sometimes may need
> to be added to the device hierarchy as children of PCI bridges.

An example of this hierarchy would help to understand it.

> For
> this purpose, however, the struct pci_dev objects representing those
> bridges need to exist before the platform devices in question are
> added, but this is only possible if the PCI root bridge driver is
> registered before the initial scanning of the ACPI namespace
> (that driver's .add() routine creates the required struct pci_dev
> objects).

The previous patch (1/6) registers all acpi_device objects in the
first pass, then calls driver .add() methods in the second pass.  And
here you're saying the .add() method has to run before platform
devices are added.  So I guess the acpi_device objects are added
first, then the .add() methods called, then the platform devices
added?

I think the call sequence looks like this:

    acpi_bus_scan
      acpi_walk_namespace
        acpi_bus_check_add
          acpi_add_single_object
            device = kzalloc(sizeof(struct acpi_device, ...)    # (1)
acpi_devices created here
      acpi_walk_namespace
        acpi_bus_match_device
          if (acpi_match_device_ids(device, acpi_platform_device_ids))
            acpi_create_platform_device    # (3) platform device added here
          else
            device_attach    # (2) driver .add() called here
            acpi_hot_add_bind

(1) happens first because it's in the first acpi_walk_namespace().
(2) happens before (3) because acpi_walk_namespace() calls
acpi_bus_match_device() in preorder (node visited before its children)

It always seems like a bit of a hack when we have to call out a driver
specifically like this.  Are these special platform devices unique to
PCI?  What would happen with these platform devices that are children
of PCI bridges if we booted a kernel without a PCI host bridge driver?
 You would hope that the PCI host bridge and everything under it would
just be ignored, and I assume that in that case, these platform
devices should be ignored, too.

I know we can't build ACPI without PCI today, but AFAIK that's mostly
to reduce the configuration/testing matrix, not a design restriction.
So I guess I'm trying to figure out whether the ACPI core should be
made smart enough to deal with these PCI-related platform devices (as
you're doing in these patches), or whether there should be something
in the PCI host bridge driver that deals with them.

> For this reason, call acpi_pci_root_init() from acpi_scan_init()
> before scanning the ACPI namespace for the first time instead of
> running it from a separate subsys initcall.  Since the previous patch
> has changed the ACPI namespace scanning algorithm, this change does
> not affect the PCI root bridge driver's functionality during boot.
> It also makes the situation during boot more similar to the situation
> during hot-plug (in which the PCI root bridge driver is always
> present) and so it helps to reduce arbitary differences between
> the hot-plug and boot PCI root bridge code.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/internal.h |    1 +
>  drivers/acpi/pci_root.c |    4 +---
>  drivers/acpi/scan.c     |    1 +
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux/drivers/acpi/internal.h
> ===================================================================
> --- linux.orig/drivers/acpi/internal.h
> +++ linux/drivers/acpi/internal.h
> @@ -67,6 +67,7 @@ struct acpi_ec {
>
>  extern struct acpi_ec *first_ec;
>
> +int acpi_pci_root_init(void);
>  int acpi_ec_init(void);
>  int acpi_ec_ecdt_probe(void);
>  int acpi_boot_ec_enable(void);
> Index: linux/drivers/acpi/pci_root.c
> ===================================================================
> --- linux.orig/drivers/acpi/pci_root.c
> +++ linux/drivers/acpi/pci_root.c
> @@ -674,7 +674,7 @@ static int acpi_pci_root_remove(struct a
>         return 0;
>  }
>
> -static int __init acpi_pci_root_init(void)
> +int __init acpi_pci_root_init(void)
>  {
>         acpi_hest_init();
>
> @@ -687,5 +687,3 @@ static int __init acpi_pci_root_init(voi
>
>         return 0;
>  }
> -
> -subsys_initcall(acpi_pci_root_init);
> Index: linux/drivers/acpi/scan.c
> ===================================================================
> --- linux.orig/drivers/acpi/scan.c
> +++ linux/drivers/acpi/scan.c
> @@ -1828,6 +1828,7 @@ int __init acpi_scan_init(void)
>         }
>
>         acpi_power_init();
> +       acpi_pci_root_init();
>
>         /*
>          * Enumerate devices in the ACPI namespace.
>
