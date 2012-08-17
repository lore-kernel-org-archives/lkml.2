Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab2HQR0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:26:25 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:35620 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994Ab2HQR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:26:15 -0400
X-IronPort-AV: E=Sophos;i="4.77,785,1336348800"; 
   d="scan'208";a="14064737"
Date: Fri, 17 Aug 2012 18:25:56 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Xen-devel] [PATCH 4/5] xen/swiotlb: Use the swiotlb_late_init_with_tbl
 to init Xen-SWIOTLB late when PV PCI is used.
In-Reply-To: <1345132488-27323-5-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1208171818260.15568@kaball.uk.xensource.com>
References: <1345132488-27323-1-git-send-email-konrad.wilk@oracle.com> <1345132488-27323-5-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> With this patch we provide the functionality to initialize the
> Xen-SWIOTLB late in the bootup cycle - specifically for
> Xen PCI-frontend. We still will work if the user had
> supplied 'iommu=soft' on the Linux command line.
> 
> CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> [v1: Fix smatch warnings]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/include/asm/xen/swiotlb-xen.h |    2 +
>  arch/x86/xen/pci-swiotlb-xen.c         |   17 +++++++++-
>  drivers/xen/swiotlb-xen.c              |   54 ++++++++++++++++++++++++++-----
>  include/xen/swiotlb-xen.h              |    1 +
>  4 files changed, 64 insertions(+), 10 deletions(-)
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
> index 1c17227..031d8bc 100644
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
> @@ -76,6 +76,21 @@ void __init pci_xen_swiotlb_init(void)
>  		pci_request_acs();
>  	}
>  }
> +
> +int pci_xen_swiotlb_init_late(void)
> +{
> +	int rc = xen_swiotlb_late_init(1);
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

shouldn't we be checking whether the xen_swiotlb has already been
initialized?


>  IOMMU_INIT_FINISH(pci_xen_swiotlb_detect,
>  		  0,
>  		  pci_xen_swiotlb_init,
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 1afb4fb..1942a3e 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -145,13 +145,14 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
>  	return 0;
>  }
>  
> -void __init xen_swiotlb_init(int verbose)
> +static int __ref __xen_swiotlb_init(int verbose, bool early)
>  {
>  	unsigned long bytes;
>  	int rc = -ENOMEM;
>  	unsigned long nr_tbl;
>  	char *m = NULL;
>  	unsigned int repeat = 3;
> +	unsigned long order;
>
>  	nr_tbl = swiotlb_nr_tbl();
>  	if (nr_tbl)
> @@ -161,12 +162,31 @@ void __init xen_swiotlb_init(int verbose)
>  		xen_io_tlb_nslabs = ALIGN(xen_io_tlb_nslabs, IO_TLB_SEGSIZE);
>  	}
>  retry:
> +	order = get_order(xen_io_tlb_nslabs << IO_TLB_SHIFT);
>  	bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
>  
>  	/*
>  	 * Get IO TLB memory from any location.
>  	 */
> -	xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
> +	if (early)
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
>  		m = "Cannot allocate Xen-SWIOTLB buffer!\n";
>  		goto error;
> @@ -179,17 +199,22 @@ retry:
>  			       bytes,
>  			       xen_io_tlb_nslabs);
>  	if (rc) {
> -		free_bootmem(__pa(xen_io_tlb_start), PAGE_ALIGN(bytes));
> +		if (early)
> +			free_bootmem(__pa(xen_io_tlb_start), PAGE_ALIGN(bytes));
>  		m = "Failed to get contiguous memory for DMA from Xen!\n"\
>  		    "You either: don't have the permissions, do not have"\
>  		    " enough free memory under 4GB, or the hypervisor memory"\
> -		    "is too fragmented!";
> +		    " is too fragmented!";
>  		goto error;
>  	}
>  	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
> -	swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
>  
> -	return;
> +	rc = 0;
> +	if (early)
> +		swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
> +	else
> +		rc = swiotlb_late_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs);
> +	return rc;
>  error:
>  	if (repeat--) {
>  		xen_io_tlb_nslabs = max(1024UL, /* Min is 2MB */
> @@ -198,10 +223,21 @@ error:
>  		      (xen_io_tlb_nslabs << IO_TLB_SHIFT) >> 20);
>  		goto retry;
>  	}
> -	xen_raw_printk("%s (rc:%d)", m, rc);
> -	panic("%s (rc:%d)", m, rc);
> +	pr_err("%s (rc:%d)", m, rc);
> +	if (early)
> +		panic("%s (rc:%d)", m, rc);
> +	else
> +		free_pages((unsigned long)xen_io_tlb_start, order);
> +	return rc;
> +}

All these "if" make the code a harder to read. Would it be possible at
least to unify the error paths and just check on after_bootmem whether
we need to call free_pages or free_bootmem?
In fact using after_bootmem you might get away without an early
parameter.


> +void __init xen_swiotlb_init(int verbose)
> +{
> +	__xen_swiotlb_init(verbose, true /* early */);
> +}
> +int xen_swiotlb_late_init(int verbose)
> +{
> +	return __xen_swiotlb_init(verbose, false /* late */);
>  }
>  void *
>  xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>  			   dma_addr_t *dma_handle, gfp_t flags,
> diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
> index 4f4d449..d38d984 100644
> --- a/include/xen/swiotlb-xen.h
> +++ b/include/xen/swiotlb-xen.h
> @@ -4,6 +4,7 @@
>  #include <linux/swiotlb.h>
>  
>  extern void xen_swiotlb_init(int verbose);
> +extern int  xen_swiotlb_late_init(int verbose);
>  
>  extern void
>  *xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> -- 
> 1.7.7.6
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
