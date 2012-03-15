Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161667Ab2COVmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:42:39 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64505 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161564Ab2COVmg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:42:36 -0400
MIME-Version: 1.0
In-Reply-To: <1331623594-30543-11-git-send-email-yinghai@kernel.org>
References: <1331623594-30543-1-git-send-email-yinghai@kernel.org> <1331623594-30543-11-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 15 Mar 2012 15:42:14 -0600
Message-ID: <CAErSpo4=czJci=Yqv2DkU6w592pyWn5fg7+Domc0qKUi+kZ=Yw@mail.gmail.com>
Subject: Re: [PATCH 10/12] PCI, pciehp: Separate pci_hp_add_bridge()
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 1:26 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> Will use it for other pci hp hotplug support
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/hotplug-pci.c        |   13 +++++++++++++
>  drivers/pci/hotplug/pciehp_pci.c |   18 ++----------------
>  drivers/pci/pci.h                |    1 +
>  3 files changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
> index d3509cd..d0999b1 100644
> --- a/drivers/pci/hotplug-pci.c
> +++ b/drivers/pci/hotplug-pci.c
> @@ -4,6 +4,19 @@
>  #include <linux/export.h>
>  #include "pci.h"
>
> +int __ref pci_hp_add_bridge(struct pci_dev *dev)
> +{
> +       struct pci_bus *parent = dev->bus;
> +       int pass, busnr = parent->secondary;
> +
> +       for (pass = 0; pass < 2; pass++)
> +               busnr = pci_scan_bridge(parent, dev, busnr, pass);
> +       if (!dev->subordinate)
> +               return -1;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(pci_hp_add_bridge);

I'm not sure this is baked enough to use EXPORT_SYMBOL() rather than
EXPORT_SYMBOL_GPL().  For example, maybe we can use the same "add
bridge" interface we normally use, rather than inventing a new
hotplug-specific one.  Using EXPORT_SYMBOL() would force us to keep
this interface longer than we might want to.

>  unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
>  {
> diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
> index e21171c..b9a9fce 100644
> --- a/drivers/pci/hotplug/pciehp_pci.c
> +++ b/drivers/pci/hotplug/pciehp_pci.c
> @@ -34,19 +34,6 @@
>  #include "../pci.h"
>  #include "pciehp.h"
>
> -static int __ref pciehp_add_bridge(struct pci_dev *dev)
> -{
> -       struct pci_bus *parent = dev->bus;
> -       int pass, busnr = parent->secondary;
> -
> -       for (pass = 0; pass < 2; pass++)
> -               busnr = pci_scan_bridge(parent, dev, busnr, pass);
> -       if (!dev->subordinate)
> -               return -1;
> -
> -       return 0;
> -}
> -
>  int pciehp_configure_device(struct slot *p_slot)
>  {
>        struct pci_dev *dev;
> @@ -75,9 +62,8 @@ int pciehp_configure_device(struct slot *p_slot)
>                if (!dev)
>                        continue;
>                if ((dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
> -                               (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)) {
> -                       pciehp_add_bridge(dev);
> -               }
> +                   (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS))
> +                       pci_hp_add_bridge(dev);
>                pci_dev_put(dev);
>        }
>
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 13b1159..9378d81 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -124,6 +124,7 @@ static inline int pci_proc_detach_bus(struct pci_bus *bus) { return 0; }
>  #endif
>
>  /* Functions for PCI Hotplug drivers to use */
> +int pci_hp_add_bridge(struct pci_dev *dev);
>  extern unsigned int pci_do_scan_bus(struct pci_bus *bus);
>
>  #ifdef HAVE_PCI_LEGACY
> --
> 1.7.7
>
