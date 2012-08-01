Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab2HAKJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:09:31 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:35728 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2HAKJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:09:30 -0400
X-IronPort-AV: E=Sophos;i="4.77,693,1336348800"; 
   d="scan'208";a="13798937"
Date: Wed, 1 Aug 2012 11:09:12 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 2/5] xen/swiotlb: With more than 4GB on
 64-bit, disable the native SWIOTLB.
In-Reply-To: <20120731182551.GA1559@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208011108590.4645@kaball.uk.xensource.com>
References: <1343743223-30092-1-git-send-email-konrad.wilk@oracle.com> <1343743223-30092-3-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1207311542520.4645@kaball.uk.xensource.com> <20120731182551.GA1559@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Konrad Rzeszutek Wilk wrote:
> commit 21ef55f4ab2b6d63eb0ed86abbc959d31377853b
> Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date:   Fri Jul 27 20:16:00 2012 -0400
> 
>     xen/swiotlb: With more than 4GB on 64-bit, disable the native SWIOTLB.
>     
>     If a PV guest is booted the native SWIOTLB should not be
>     turned on. It does not help us (we don't have any PCI devices)
>     and it eats 64MB of good memory. In the case of PV guests
>     with PCI devices we need the Xen-SWIOTLB one.
>    
>     [v1: Rewrite comment per Stefano's suggestion] 
>     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

> diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
> index b6a5340..1c17227 100644
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
> @@ -49,6 +54,15 @@ int __init pci_xen_swiotlb_detect(void)
>  	 * the 'swiotlb' flag is the only one turning it on. */
>  	swiotlb = 0;
>  
> +#ifdef CONFIG_X86_64
> +	/* pci_swiotlb_detect_4gb turns on native SWIOTLB if no_iommu == 0
> +	 * (so no iommu=X command line over-writes).
> +	 * Considering that PV guests do not want the *native SWIOTLB* but
> +	 * only Xen SWIOTLB it is not useful to us so set no_iommu=1 here.
> +	 */
> +	if (max_pfn > MAX_DMA32_PFN)
> +		no_iommu = 1;
> +#endif
>  	return xen_swiotlb;
>  }
>  
> 
