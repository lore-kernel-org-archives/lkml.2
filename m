Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab2BATIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:08:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab2BATIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:08:49 -0500
Message-ID: <1328122724.6937.216.camel@bling.home>
Subject: Re: [PATCH 2/3] device_isolation: Support isolation on POWER p5ioc2
 bridges
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org, aik@ozlabs.ru,
        benh@kernel.crashing.org, qemu-devel@nongnu.org, joerg.roedel@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 01 Feb 2012 11:58:44 -0700
In-Reply-To: <1328071614-8320-3-git-send-email-david@gibson.dropbear.id.au>
References: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
	 <1328071614-8320-3-git-send-email-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 15:46 +1100, David Gibson wrote:
> This patch adds code to the code for the powernv platform to create
> and populate isolation groups on hardware using the p5ioc2 PCI host
> bridge used on some IBM POWER systems.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  arch/powerpc/platforms/powernv/pci-p5ioc2.c |   14 +++++++++++++-
>  arch/powerpc/platforms/powernv/pci.h        |    3 +++
>  2 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
> index 2649677..e5bb3a6 100644
> --- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
> +++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
> @@ -20,6 +20,7 @@
>  #include <linux/irq.h>
>  #include <linux/io.h>
>  #include <linux/msi.h>
> +#include <linux/device_isolation.h>
>  
>  #include <asm/sections.h>
>  #include <asm/io.h>
> @@ -88,10 +89,21 @@ static void pnv_pci_init_p5ioc2_msis(struct pnv_phb *phb) { }
>  static void __devinit pnv_pci_p5ioc2_dma_dev_setup(struct pnv_phb *phb,
>  						   struct pci_dev *pdev)
>  {
> -	if (phb->p5ioc2.iommu_table.it_map == NULL)
> +	if (phb->p5ioc2.iommu_table.it_map == NULL) {
>  		iommu_init_table(&phb->p5ioc2.iommu_table, phb->hose->node);
> +#ifdef CONFIG_DEVICE_ISOLATION
> +		phb->p5ioc2.di_group = kzalloc(sizeof(*(phb->p5ioc2.di_group)),
> +					       GFP_KERNEL);
> +		BUG_ON(!phb->p5ioc2.di_group ||
> +		       (device_isolation_group_init(phb->p5ioc2.di_group,
> +						    "p5ioc2:%llx", phb->opal_id) < 0));
> +#endif

Hmm, it's really unfortunate that this is architected so we need to
surround everything in #ifdefs even though we have stub functions
defined.

> +	}
>  
>  	set_iommu_table_base(&pdev->dev, &phb->p5ioc2.iommu_table);
> +#ifdef CONFIG_DEVICE_ISOLATION
> +	device_isolation_dev_add(phb->p5ioc2.di_group, &pdev->dev);
> +#endif
>  }
>  
>  static void __init pnv_pci_init_p5ioc2_phb(struct device_node *np,
> diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
> index 8bc4796..64ede1e 100644
> --- a/arch/powerpc/platforms/powernv/pci.h
> +++ b/arch/powerpc/platforms/powernv/pci.h
> @@ -87,6 +87,9 @@ struct pnv_phb {
>  	union {
>  		struct {
>  			struct iommu_table iommu_table;
> +#ifdef CONFIG_DEVICE_ISOLATION
> +			struct device_isolation_group *di_group;
> +#endif
>  		} p5ioc2;
>  
>  		struct {



