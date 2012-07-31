Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2GaOq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:46:29 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:13489 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab2GaOqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:46:25 -0400
X-IronPort-AV: E=Sophos;i="4.77,686,1336348800"; 
   d="scan'208";a="13783751"
Date: Tue, 31 Jul 2012 15:46:04 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: Re: [PATCH 2/5] xen/swiotlb: With more than 4GB on 64-bit, disable
 the native SWIOTLB.
In-Reply-To: <1343743223-30092-3-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1207311542520.4645@kaball.uk.xensource.com>
References: <1343743223-30092-1-git-send-email-konrad.wilk@oracle.com> <1343743223-30092-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Konrad Rzeszutek Wilk wrote:
> If a PV guest is booted the native SWIOTLB should not be
> turned on. It does not help us (we don't have any PCI devices)
> and it eats 64MB of good memory. In the case of PV guests
> with PCI devices we need the Xen-SWIOTLB one.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/pci-swiotlb-xen.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
> index b6a5340..0d5a214 100644
> --- a/arch/x86/xen/pci-swiotlb-xen.c
> +++ b/arch/x86/xen/pci-swiotlb-xen.c
> @@ -8,6 +8,11 @@
>  #include <xen/xen.h>
>  #include <asm/iommu_table.h>
>  
> +#ifdef CONFIG_X86_64
> +#include <asm/iommu.h>
> +#include <asm/dma.h>
> +#endif
> +
>  int xen_swiotlb __read_mostly;
>  
>  static struct dma_map_ops xen_swiotlb_dma_ops = {
> @@ -49,6 +54,13 @@ int __init pci_xen_swiotlb_detect(void)
>  	 * the 'swiotlb' flag is the only one turning it on. */
>  	swiotlb = 0;
>  
> +#ifdef CONFIG_X86_64
> +	/* pci_swiotlb_detect_4gb turns native SWIOTLB if no_iommu == 0
> +	 * (so no iommu=X command line over-writes). So disable the native
> +	 * SWIOTLB. */

Maybe rewording it would be a good idea:

/* pci_swiotlb_detect_4gb turns on native SWIOTLB if no_iommu == 0
 * (so no iommu=X command line over-writes).
 * Considering that PV guests don't normally have PCI devices it is not
 * useful to us so we set no_iommu to 1 here */


> +	if (max_pfn > MAX_DMA32_PFN)
> +		no_iommu = 1;
> +#endif
>  	return xen_swiotlb;
>  }
>  
> -- 
> 1.7.7.6
> 
