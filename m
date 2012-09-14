Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2INQ1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:27:11 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:47882 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2INQ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:27:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,423,1344211200"; 
   d="scan'208";a="14551866"
Date: Fri, 14 Sep 2012 17:26:24 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 06/10] xen/swiotlb: Use the swiotlb_late_init_with_tbl
 to init Xen-SWIOTLB late when PV PCI is used.
In-Reply-To: <1347306367-28669-7-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1209141720160.29232@kaball.uk.xensource.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com> <1347306367-28669-7-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012, Konrad Rzeszutek Wilk wrote:
> With this patch we provide the functionality to initialize the
> Xen-SWIOTLB late in the bootup cycle - specifically for
> Xen PCI-frontend. We still will work if the user had
> supplied 'iommu=soft' on the Linux command line.
> 
> CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> [v1: Fix smatch warnings]
> [v2: Added check for xen_swiotlb]
> [v3: Rebased with new xen-swiotlb changes]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/include/asm/xen/swiotlb-xen.h |    2 +
>  arch/x86/xen/pci-swiotlb-xen.c         |   22 ++++++++++++++-
>  drivers/xen/swiotlb-xen.c              |   48 +++++++++++++++++++++++++------
>  include/xen/swiotlb-xen.h              |    2 +-
>  4 files changed, 62 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/xen/swiotlb-xen.h b/arch/x86/include/asm/xen/swiotlb-xen.h
> index 1be1ab7..ee52fca 100644
> --- a/arch/x86/include/asm/xen/swiotlb-xen.h
> +++ b/arch/x86/include/asm/xen/swiotlb-xen.h
> @@ -5,10 +5,12 @@
>  extern int xen_swiotlb;
>  extern int __init pci_xen_swiotlb_detect(void);
>  extern void __init pci_xen_swiotlb_init(void);
> +extern int pci_xen_swiotlb_init_late(void);
>  #else
>  #define xen_swiotlb (0)
>  static inline int __init pci_xen_swiotlb_detect(void) { return 0; }
>  static inline void __init pci_xen_swiotlb_init(void) { }
> +static inline int pci_xen_swiotlb_init_late(void) { return -ENXIO; }
>  #endif
>  
>  #endif /* _ASM_X86_SWIOTLB_XEN_H */
> diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
> index 1c17227..406f9c4 100644
> --- a/arch/x86/xen/pci-swiotlb-xen.c
> +++ b/arch/x86/xen/pci-swiotlb-xen.c
> @@ -12,7 +12,7 @@
>  #include <asm/iommu.h>
>  #include <asm/dma.h>
>  #endif
> -
> +#include <linux/export.h>
>  int xen_swiotlb __read_mostly;
>  
>  static struct dma_map_ops xen_swiotlb_dma_ops = {
> @@ -76,6 +76,26 @@ void __init pci_xen_swiotlb_init(void)
>  		pci_request_acs();
>  	}
>  }
> +
> +int pci_xen_swiotlb_init_late(void)
> +{
> +	int rc;
> +
> +	if (xen_swiotlb)
> +		return 0;
> +
> +	rc = xen_swiotlb_init(1);
> +	if (rc)
> +		return rc;
> +
> +	dma_ops = &xen_swiotlb_dma_ops;
> +	/* Make sure ACS will be enabled */
> +	pci_request_acs();
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
> +
>  IOMMU_INIT_FINISH(pci_xen_swiotlb_detect,
>  		  0,
>  		  pci_xen_swiotlb_init,
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 701b103..f0825cb 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -176,9 +176,9 @@ static const char *xen_swiotlb_error(enum xen_swiotlb_err err)
>  	}
>  	return "";
>  }
> -void __init xen_swiotlb_init(int verbose)
> +int __ref xen_swiotlb_init(int verbose)
>  {
> -	unsigned long bytes;
> +	unsigned long bytes, order;
>  	int rc = -ENOMEM;
>  	enum xen_swiotlb_err m_ret = XEN_SWIOTLB_UNKNOWN;
>  	unsigned int repeat = 3;
> @@ -186,10 +186,28 @@ void __init xen_swiotlb_init(int verbose)
>  	xen_io_tlb_nslabs = swiotlb_nr_tbl();
>  retry:
>  	bytes = xen_set_nslabs(xen_io_tlb_nslabs);
> +	order = get_order(xen_io_tlb_nslabs << IO_TLB_SHIFT);
>  	/*
>  	 * Get IO TLB memory from any location.
>  	 */
> -	xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
> +	if (!after_bootmem)
> +		xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
> +	else {
> +#define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
> +#define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
> +		while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
> +			xen_io_tlb_start = (void *)__get_free_pages(__GFP_NOWARN, order);
> +			if (xen_io_tlb_start)
> +				break;
> +			order--;
> +		}
> +		if (order != get_order(bytes)) {
> +			pr_warn("Warning: only able to allocate %ld MB "
> +				"for software IO TLB\n", (PAGE_SIZE << order) >> 20);
> +			xen_io_tlb_nslabs = SLABS_PER_PAGE << order;
> +			bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
> +		}
> +	}
>  	if (!xen_io_tlb_start) {
>  		m_ret = XEN_SWIOTLB_ENOMEM;
>  		goto error;
> @@ -202,14 +220,21 @@ retry:
>  			       bytes,
>  			       xen_io_tlb_nslabs);
>  	if (rc) {
> -		free_bootmem(__pa(xen_io_tlb_start), PAGE_ALIGN(bytes));
> +		if (!after_bootmem)
> +			free_bootmem(__pa(xen_io_tlb_start), PAGE_ALIGN(bytes));
> +		else {
> +			free_pages((unsigned long)xen_io_tlb_start, order);
> +			xen_io_tlb_start = NULL;
> +		}
>  		m_ret = XEN_SWIOTLB_EFIXUP;
>  		goto error;
>  	}
>  	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
> -	swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
> -
> -	return;
> +	if (!after_bootmem)
> +		swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
> +	else
> +		rc = swiotlb_late_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs);
> +	return rc;
>  error:
>  	if (repeat--) {
>  		xen_io_tlb_nslabs = max(1024UL, /* Min is 2MB */
> @@ -218,10 +243,13 @@ error:
>  		      (xen_io_tlb_nslabs << IO_TLB_SHIFT) >> 20);
>  		goto retry;
>  	}
> -	xen_raw_printk("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
> -	panic("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
> +	pr_err("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
> +	if (!after_bootmem)
> +		panic("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
> +	else
> +		free_pages((unsigned long)xen_io_tlb_start, order);
> +	return rc;
>  }
> -
>  void *
>  xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  			   dma_addr_t *dma_handle, gfp_t flags,
> diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
> index 4f4d449..f26f9f3 100644
> --- a/include/xen/swiotlb-xen.h
> +++ b/include/xen/swiotlb-xen.h
> @@ -3,7 +3,7 @@
>  
>  #include <linux/swiotlb.h>
>  
> -extern void xen_swiotlb_init(int verbose);
> +extern int xen_swiotlb_init(int verbose);
>  
>  extern void
>  *xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> -- 
> 1.7.7.6
> 
