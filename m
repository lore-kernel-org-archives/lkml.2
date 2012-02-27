Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2B0Re6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:34:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36744 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2B0Rey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:34:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.180.92.229 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <1330299202-3838-3-git-send-email-yinghai@kernel.org>
References: <1330299202-3838-1-git-send-email-yinghai@kernel.org> <1330299202-3838-3-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Feb 2012 10:34:33 -0700
Message-ID: <CAErSpo6njxGbsjqFW6nJi3hefKRNUYKj_zCGuPmOOfaFcLkk4A@mail.gmail.com>
Subject: Re: [PATCH 2/8] x86, PCI: have own version for pcibios_bus_to_resource
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 4:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> x86 does not need to offset the address. So we can skip that costing offset
> searching.

I don't understand the point of this.  I'm trying hard to *remove* PCI
code from arch/ because most of it is not really arch-specific.  This
is a good example.  There's nothing in the pcibios_bus_to_resource()
that you're adding back to x86 that is specific to x86, and it makes
things more complicated.  Using __weak adds ambiguity for the reader,
now the pci_add_resource_offset() interface exists but doesn't work,
etc.

I agree that this patch will make x86 a tiny bit faster and a tiny bit
smaller, but I don't think it's enough to matter.  Do you have numbers
that say otherwise?

Bjorn

> ---
>  arch/x86/pci/i386.c       |   14 ++++++++++++++
>  drivers/pci/host-bridge.c |    9 +++++----
>  2 files changed, 19 insertions(+), 4 deletions(-)
>
> Index: linux-2.6/arch/x86/pci/i386.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/i386.c
> +++ linux-2.6/arch/x86/pci/i386.c
> @@ -335,6 +335,20 @@ void __init pcibios_resource_survey(void
>  */
>  fs_initcall(pcibios_assign_resources);
>
> +void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
> +                            struct resource *res)
> +{
> +       region->start = res->start;
> +       region->end = res->end;
> +}
> +
> +void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
> +                            struct pci_bus_region *region)
> +{
> +       res->start = region->start;
> +       res->end = region->end;
> +}
> +
>  static const struct vm_operations_struct pci_mmap_ops = {
>        .access = generic_access_phys,
>  };
> Index: linux-2.6/drivers/pci/host-bridge.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/host-bridge.c
> +++ linux-2.6/drivers/pci/host-bridge.c
> @@ -38,8 +38,9 @@ static bool resource_contains(struct res
>        return res1->start <= res2->start && res1->end >= res2->end;
>  }
>
> -void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
> -                            struct resource *res)
> +void __weak pcibios_resource_to_bus(struct pci_dev *dev,
> +                                   struct pci_bus_region *region,
> +                                   struct resource *res)
>  {
>        struct pci_host_bridge *bridge = pci_host_bridge(dev);
>        struct pci_host_bridge_window *window;
> @@ -66,8 +67,8 @@ static bool region_contains(struct pci_b
>        return region1->start <= region2->start && region1->end >= region2->end;
>  }
>
> -void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
> -                            struct pci_bus_region *region)
> +void __weak pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
> +                                   struct pci_bus_region *region)
>  {
>        struct pci_host_bridge *bridge = pci_host_bridge(dev);
>        struct pci_host_bridge_window *window;
