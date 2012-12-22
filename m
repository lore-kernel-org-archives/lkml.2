Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab2LVCVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:21:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38225 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2LVCVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:21:37 -0500
Date: Fri, 21 Dec 2012 21:21:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kerne.org>
Subject: Re: [PATCH v6 23/27] x86: Don't panic if can not alloc buffer for
 swiotlb
Message-ID: <20121222022113.GD3468@phenom.dumpdata.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-24-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355436141-8668-24-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 02:02:17PM -0800, Yinghai Lu wrote:
> Normal boot path on system with iommu support:
> swiotlb buffer will be allocated early at first and then try to initialize
> iommu, if iommu for intel or amd could setup properly, swiotlb buffer
> will be freed.
> 
> The early allocating is with bootmem, and could panic when we try to use
> kdump with buffer above 4G only.
> 
> Replace the panic with WARN, and the kernel can go on without swiotlb,
> and could iommu later.


What if SWIOTLB is the only option? Meaning there are no other IOMMUs?


> 
> Signed-off-by: Yinghai Lu <yinghai@kerne.org>
> ---
>  arch/x86/kernel/pci-swiotlb.c |    5 ++++-
>  include/linux/swiotlb.h       |    2 +-
>  lib/swiotlb.c                 |   17 +++++++++++------
>  3 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index 6c483ba..6f93eb7 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -91,7 +91,10 @@ IOMMU_INIT(pci_swiotlb_detect_4gb,
>  void __init pci_swiotlb_init(void)
>  {
>  	if (swiotlb) {
> -		swiotlb_init(0);
> +		if (swiotlb_init(0)) {
> +			swiotlb = 0;
> +			return;
> +		}
>  		dma_ops = &swiotlb_dma_ops;
>  	}
>  }
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index 8d08b3e..f7535d1 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -22,7 +22,7 @@ extern int swiotlb_force;
>   */
>  #define IO_TLB_SHIFT 11
>  
> -extern void swiotlb_init(int verbose);
> +int swiotlb_init(int verbose);
>  extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
>  extern unsigned long swiotlb_nr_tbl(void);
>  extern int swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs);
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index f114bf6..6b99ea7 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -170,7 +170,7 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
>   * Statically reserve bounce buffer space and initialize bounce buffer data
>   * structures for the software IO TLB used to implement the DMA API.
>   */
> -static void __init
> +static int __init
>  swiotlb_init_with_default_size(size_t default_size, int verbose)
>  {
>  	unsigned long bytes;
> @@ -185,17 +185,22 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
>  	/*
>  	 * Get IO TLB memory from the low pages
>  	 */
> -	io_tlb_start = alloc_bootmem_low_pages(PAGE_ALIGN(bytes));
> -	if (!io_tlb_start)
> -		panic("Cannot allocate SWIOTLB buffer");
> +	io_tlb_start = alloc_bootmem_low_pages_nopanic(PAGE_ALIGN(bytes));
> +	if (!io_tlb_start) {
> +		WARN(1, "Cannot allocate SWIOTLB buffer");
> +		return -1;
> +	}
>  
>  	swiotlb_init_with_tbl(io_tlb_start, io_tlb_nslabs, verbose);
> +
> +	return 0;
>  }
>  
> -void __init
> +int __init
>  swiotlb_init(int verbose)
>  {
> -	swiotlb_init_with_default_size(64 * (1<<20), verbose);	/* default to 64MB */
> +	/* default to 64MB */
> +	return swiotlb_init_with_default_size(64 * (1<<20), verbose);
>  }
>  
>  /*
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
