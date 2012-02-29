Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966129Ab2B2XUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:20:32 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44677 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966000Ab2B2XUY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:20:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.152.114.35 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <1330556858-11768-3-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org> <1330556858-11768-3-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 29 Feb 2012 16:20:02 -0700
Message-ID: <CAErSpo62VuJw+3caNUhmg5moh3h4cn5z4kCsqTWZW-XqSzpk4Q@mail.gmail.com>
Subject: Re: [PATCH 02/39] x86, PCI: have own version for pcibios_bus_to_resource
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 4:07 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> x86 does not need to offset the address. So we can skip that costing offset
> searching.

I tried to start a discussion about this patch (and others), but I
don't think you responded:
http://marc.info/?l=linux-pci&m=133036414506921&w=2

It's discouraging to spend time reviewing all your patches and trying
to give useful feedback, when all I get in response is a deluge of
fresh patches.

Bjorn

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/pci/i386.c       |   14 ++++++++++++++
>  drivers/pci/host-bridge.c |    9 +++++----
>  2 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 33e6a0b..eeed28e 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -335,6 +335,20 @@ void __init pcibios_resource_survey(void)
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
> diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
> index 5ca4220..dfaff3f 100644
> --- a/drivers/pci/host-bridge.c
> +++ b/drivers/pci/host-bridge.c
> @@ -38,8 +38,9 @@ static bool resource_contains(struct resource *res1, struct resource *res2)
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
> @@ -66,8 +67,8 @@ static bool region_contains(struct pci_bus_region *region1,
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
> --
> 1.7.7
>
