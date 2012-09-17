Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab2IQXip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 19:38:45 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62398 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab2IQXin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 19:38:43 -0400
MIME-Version: 1.0
In-Reply-To: <1346622653-30741-5-git-send-email-yinghai@kernel.org>
References: <1346622653-30741-1-git-send-email-yinghai@kernel.org> <1346622653-30741-5-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 17 Sep 2012 17:38:22 -0600
Message-ID: <CAErSpo40tRGynUQEfyB6svinH_wizevXvg5kEMFQtvCdmO1duw@mail.gmail.com>
Subject: Re: [PATCH part2 4/6] x86, PCI: Separate rom resource claim out
To: Yinghai Lu <yinghai@kernel.org>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        x86 <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 3:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> So could use it with hot-added root bus.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/pci/i386.c |   58 ++++++++++++++++++++++++++++++++++++---------------
>  1 files changed, 41 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 84696ed..4fdf0b2 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -298,27 +298,51 @@ static void __init pcibios_allocate_resources(struct pci_bus *bus, int pass)
>         }
>  }
>
> -static int __init pcibios_assign_resources(void)
> +static void __init pcibios_allocate_dev_rom_resource(struct pci_dev *dev)
>  {
> -       struct pci_dev *dev = NULL;
>         struct resource *r;
>
> -       if (!(pci_probe & PCI_ASSIGN_ROMS)) {
> -               /*
> -                * Try to use BIOS settings for ROMs, otherwise let
> -                * pci_assign_unassigned_resources() allocate the new
> -                * addresses.
> -                */
> -               for_each_pci_dev(dev) {
> -                       r = &dev->resource[PCI_ROM_RESOURCE];
> -                       if (!r->flags || !r->start)
> -                               continue;
> -                       if (pci_claim_resource(dev, PCI_ROM_RESOURCE) < 0) {
> -                               r->end -= r->start;
> -                               r->start = 0;
> -                       }
> -               }
> +       /*
> +        * Try to use BIOS settings for ROMs, otherwise let
> +        * pci_assign_unassigned_resources() allocate the new
> +        * addresses.
> +        */
> +       r = &dev->resource[PCI_ROM_RESOURCE];
> +       if (!r->flags || !r->start)
> +               return;
> +
> +       if (pci_claim_resource(dev, PCI_ROM_RESOURCE) < 0) {
> +               r->end -= r->start;
> +               r->start = 0;
>         }
> +}
> +static void __init __pcibios_allocate_rom_resources(struct pci_bus *bus)
> +{
> +       struct pci_dev *dev;
> +       struct pci_bus *child;
> +
> +       list_for_each_entry(dev, &bus->devices, bus_list) {
> +               pcibios_allocate_dev_rom_resource(dev);
> +
> +               child = dev->subordinate;
> +               if (child)
> +                       __pcibios_allocate_rom_resources(child);

I really dislike the "__" prefix on the function names.  It seems
pointless to add another function and the "__" when all you need is a
test of PCI_ASSIGN_ROMS.  Also, it makes the structure of
__pcibios_allocate_rom_resources() different from
pcibios_allocate_resources() when they should be exactly the same.

What if you made pcibios_assign_resources() look like this:

    if (!!(pci_probe & PCI_ASSIGN_ROMS)) {
        list_for_each_entry(bus, &pci_root_buses, node)
            pcibios_allocate_rom_resources(bus);
    }

Then I don't think you'd need the extra function.

> +       }
> +}
> +static void __init pcibios_allocate_rom_resources(struct pci_bus *bus)
> +{
> +       if (pci_probe & PCI_ASSIGN_ROMS)
> +               return;
> +
> +       __pcibios_allocate_rom_resources(bus);
> +}
> +
> +static int __init pcibios_assign_resources(void)
> +{
> +       struct pci_bus *bus;
> +
> +       list_for_each_entry(bus, &pci_root_buses, node)
> +               pcibios_allocate_rom_resources(bus);
>
>         pci_assign_unassigned_resources();
>         pcibios_fw_addr_list_del();
> --
> 1.7.7
>
