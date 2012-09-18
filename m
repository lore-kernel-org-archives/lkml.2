Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab2IRANR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 20:13:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50783 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab2IRANO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 20:13:14 -0400
MIME-Version: 1.0
In-Reply-To: <1346622653-30741-7-git-send-email-yinghai@kernel.org>
References: <1346622653-30741-1-git-send-email-yinghai@kernel.org> <1346622653-30741-7-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 17 Sep 2012 18:12:53 -0600
Message-ID: <CAErSpo4wmnnFKZeY4XyZdmoOZeQz8sj-5VoAhGhCSqWTBi0GRw@mail.gmail.com>
Subject: Re: [PATCH part2 6/6] PCI: Claim hw/fw allocated resources in hot add path.
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
> During testing remove/rescan root bus 00, found
> [  338.142574] bus: 'pci': really_probe: probing driver ata_piix with device 0000:00:01.1
> [  338.146788] ata_piix 0000:00:01.1: device not available (can't reserve [io  0x01f0-0x01f7])
> [  338.150565] ata_piix: probe of 0000:00:01.1 failed with error -22
>
> because that fixed resource is not claimed from
>         arch/x86/pci/i386.c::pcibios_allocate_resources()
> that is init path.
>
> Try to claim those resources, so on the remove/rescan will still use old
> resources.
>
> It is some kind honoring HW/FW setting in the registers during hot add.
> esp root-bus hot add is through acpi, BIOS have chance to set some register
> for us.
>
> -v2: add rom resource claiming.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/pci/i386.c |   28 +++++++++++++++++++++-------
>  drivers/pci/bus.c   |    2 ++
>  include/linux/pci.h |    1 +
>  3 files changed, 24 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index abf2a61..3cb7d66 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -201,13 +201,15 @@ EXPORT_SYMBOL(pcibios_align_resource);
>   *         as well.
>   */
>
> -static void __init pcibios_allocate_bridge_resources(struct pci_dev *dev)
> +static void pcibios_allocate_bridge_resources(struct pci_dev *dev)

This patch has a little too much going on at the same time.  Can you
split the __init removal into its own patch so we can focus on what's
left by itself?

>  {
>         int idx;
>         struct resource *r;
>
>         for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
>                 r = &dev->resource[idx];
> +               if (r->parent)  /* Already allocated */
> +                       continue;

This is also a potentially interesting change that maybe should be in
its own patch.

>                 if (!r->flags)
>                         continue;
>                 if (!r->start || pci_claim_resource(dev, idx) < 0) {
> @@ -223,7 +225,7 @@ static void __init pcibios_allocate_bridge_resources(struct pci_dev *dev)
>         }
>  }
>
> -static void __init pcibios_allocate_bus_resources(struct pci_bus *bus)
> +static void pcibios_allocate_bus_resources(struct pci_bus *bus)
>  {
>         struct pci_bus *child;
>
> @@ -239,7 +241,7 @@ struct pci_check_idx_range {
>         int end;
>  };
>
> -static void __init pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
> +static void pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
>  {
>         int idx, disabled, i;
>         u16 command;
> @@ -292,7 +294,7 @@ static void __init pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
>         }
>  }
>
> -static void __init pcibios_allocate_resources(struct pci_bus *bus, int pass)
> +static void pcibios_allocate_resources(struct pci_bus *bus, int pass)
>  {
>         struct pci_dev *dev;
>         struct pci_bus *child;
> @@ -306,7 +308,7 @@ static void __init pcibios_allocate_resources(struct pci_bus *bus, int pass)
>         }
>  }
>
> -static void __init pcibios_allocate_dev_rom_resource(struct pci_dev *dev)
> +static void pcibios_allocate_dev_rom_resource(struct pci_dev *dev)
>  {
>         struct resource *r;
>
> @@ -324,7 +326,7 @@ static void __init pcibios_allocate_dev_rom_resource(struct pci_dev *dev)
>                 r->start = 0;
>         }
>  }
> -static void __init __pcibios_allocate_rom_resources(struct pci_bus *bus)
> +static void __pcibios_allocate_rom_resources(struct pci_bus *bus)
>  {
>         struct pci_dev *dev;
>         struct pci_bus *child;
> @@ -337,7 +339,7 @@ static void __init __pcibios_allocate_rom_resources(struct pci_bus *bus)
>                         __pcibios_allocate_rom_resources(child);
>         }
>  }
> -static void __init pcibios_allocate_rom_resources(struct pci_bus *bus)
> +static void pcibios_allocate_rom_resources(struct pci_bus *bus)
>  {
>         if (pci_probe & PCI_ASSIGN_ROMS)
>                 return;
> @@ -358,6 +360,18 @@ static int __init pcibios_assign_resources(void)
>         return 0;
>  }
>
> +void pcibios_resource_survey_bus(struct pci_bus *bus)
> +{
> +       dev_printk(KERN_DEBUG, &bus->dev, "Allocating resources\n");
> +
> +       pcibios_allocate_bus_resources(bus);
> +
> +       pcibios_allocate_resources(bus, 0);
> +       pcibios_allocate_resources(bus, 1);
> +
> +       pcibios_allocate_rom_resources(bus);
> +}
> +
>  void __init pcibios_resource_survey(void)

I wish pcibios_resource_survey() could look like this:

    void __init pcibios_resource_survey(void)
    {
        list_for_each_entry(bus, &pci_root_buses, node)
            pcibios_resource_survey_bus(bus)

        e820_reserve_resources_late();
        ...

but maybe there's a reason why pcibios_allocate_rom_resources() really
has to be in the pcibios_assign_resources() fs_initcall rather than in
pcibios_resource_survey().

>  {
>         struct pci_bus *bus;
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 4b0970b..2882d01 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -154,6 +154,8 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
>         return ret;
>  }
>
> +void __weak pcibios_resource_survey_bus(struct pci_bus *bus) { }
> +
>  /**
>   * pci_bus_add_device - add a single device
>   * @dev: device to add
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 1b460e1..29a4704 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -676,6 +676,7 @@ extern struct list_head pci_root_buses;     /* list of all known PCI buses */
>  /* Some device drivers need know if pci is initiated */
>  extern int no_pci_devices(void);
>
> +void pcibios_resource_survey_bus(struct pci_bus *bus);
>  void pcibios_fixup_bus(struct pci_bus *);
>  int __must_check pcibios_enable_device(struct pci_dev *, int mask);
>  /* Architecture specific versions may override this (weak) */
> --
> 1.7.7
>
