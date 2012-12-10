Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2LJXVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:21:46 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:45116 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2LJXVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:21:44 -0500
MIME-Version: 1.0
In-Reply-To: <20121210212545.GA15884@google.com>
References: <20121210200321.1343445856179c58d0d0cb16@canb.auug.org.au> <20121210212545.GA15884@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Dec 2012 16:21:22 -0700
Message-ID: <CAErSpo5NdruCvW7YwOSm3Yh=_muCjQk26iCL5hbp39nzcNegng@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the pci tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 2:25 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Dec 10, 2012 at 08:03:21PM +1100, Stephen Rothwell wrote:
>> Hi Bjorn,
>>
>> After merging the pci tree, today's linux-next build (powerpc
>> ppc44x_defconfig) produced this warning:
>>
>> drivers/pci/rom.c: In function 'pci_map_rom':
>> drivers/pci/rom.c:125:23: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>>
>> Introduced by commit 84c1b80e3263 ("PCI: Add support for non-BAR ROMs").
>
> I propose the following patch to fix this warning.  Any comments?  If
> it looks OK, I'll add it this afternoon.
>
> commit dbd3fc3345390a989a033427aa915a0dfb62149f
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Mon Dec 10 11:24:42 2012 -0700
>
>     PCI: Use phys_addr_t for physical ROM address
>
>     Use phys_addr_t rather than "void *" for physical memory address.
>     This removes casts and fixes a "cast from pointer to integer of different
>     size" warning on ppc44x_defconfig.
>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

I applied this and pushed my -next branch.

> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index fddb9f6..d07f3bb 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -628,8 +628,8 @@ int pcibios_add_device(struct pci_dev *dev)
>                             (PCI_FUNC(dev->devfn) == rom->function) &&
>                             (dev->vendor == rom->vendor) &&
>                             (dev->device == rom->devid)) {
> -                               dev->rom = (void *)(unsigned long)(pa_data +
> -                                     offsetof(struct pci_setup_rom, romdata));
> +                               dev->rom = pa_data +
> +                                     offsetof(struct pci_setup_rom, romdata);
>                                 dev->romlen = rom->pcilen;
>                         }
>                 }
> diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
> index 3a3828f..ab886b7 100644
> --- a/drivers/pci/rom.c
> +++ b/drivers/pci/rom.c
> @@ -122,7 +122,7 @@ void __iomem *pci_map_rom(struct pci_dev *pdev, size_t *size)
>          */
>         if (pdev->rom && pdev->romlen) {
>                 *size = pdev->romlen;
> -               return phys_to_virt((phys_addr_t)pdev->rom);
> +               return phys_to_virt(pdev->rom);
>         /*
>          * IORESOURCE_ROM_SHADOW set on x86, x86_64 and IA64 supports legacy
>          * memory map if the VGA enable bit of the Bridge Control register is
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index f116b2d..957563b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -333,7 +333,7 @@ struct pci_dev {
>         };
>         struct pci_ats  *ats;   /* Address Translation Service */
>  #endif
> -       void *rom; /* Physical pointer to ROM if it's not from the BAR */
> +       phys_addr_t rom; /* Physical address of ROM if it's not from the BAR */
>         size_t romlen; /* Length of ROM if it's not from the BAR */
>  };
>
