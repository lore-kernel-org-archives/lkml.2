Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab2LVCSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:18:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22353 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2LVCSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:18:35 -0500
Date: Fri, 21 Dec 2012 21:18:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 24/27] x86: Add swiotlb force off support
Message-ID: <20121222021813.GC3468@phenom.dumpdata.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-25-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355436141-8668-25-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 02:02:18PM -0800, Yinghai Lu wrote:
> So use could disable swiotlb from command line, even swiotlb support
> is compiled in.  Just like we have intel_iommu=on and intel_iommu=off.

Does this have any usage besides testing?

And also pls in the future use scripts/get_maintainer.pl so
that you can extract from the email of the maintainer (which would be me).

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  Documentation/kernel-parameters.txt |    7 +++++++
>  arch/x86/kernel/pci-swiotlb.c       |   10 +++++-----
>  drivers/iommu/amd_iommu.c           |    1 +
>  include/linux/swiotlb.h             |    1 +
>  lib/swiotlb.c                       |    5 ++++-
>  5 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 20e248c..08b4c9d 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2832,6 +2832,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	swiotlb=	[IA-64] Number of I/O TLB slabs
>  
> +	swiotlb=[force|off|on] [KNL] disable or enable swiotlb.
> +		force
> +		on
> +			Enable swiotlb.
> +		off
> +			Disable swiotlb.
> +
>  	switches=	[HW,M68k]
>  
>  	sysfs.deprecated=0|1 [KNL]
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index 6f93eb7..80afd3b 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -58,12 +58,12 @@ static struct dma_map_ops swiotlb_dma_ops = {
>   */
>  int __init pci_swiotlb_detect_override(void)
>  {
> -	int use_swiotlb = swiotlb | swiotlb_force;
> -
>  	if (swiotlb_force)
>  		swiotlb = 1;
> +	else if (swiotlb_force_off)
> +		swiotlb = 0;
>  
> -	return use_swiotlb;
> +	return swiotlb;
>  }
>  IOMMU_INIT_FINISH(pci_swiotlb_detect_override,
>  		  pci_xen_swiotlb_detect,
> @@ -76,9 +76,9 @@ IOMMU_INIT_FINISH(pci_swiotlb_detect_override,
>   */
>  int __init pci_swiotlb_detect_4gb(void)
>  {
> -	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
> +	/* don't initialize swiotlb if iommu=off (no_iommu=1) or force off */
>  #ifdef CONFIG_X86_64
> -	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
> +	if (!no_iommu && !swiotlb_force_off && max_pfn > MAX_DMA32_PFN)
>  		swiotlb = 1;
>  #endif
>  	return swiotlb;
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index 55074cb..4f370d3 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -3082,6 +3082,7 @@ int __init amd_iommu_init_dma_ops(void)
>  	unhandled = device_dma_ops_init();
>  	if (unhandled && max_pfn > MAX_DMA32_PFN) {
>  		/* There are unhandled devices - initialize swiotlb for them */
> +		WARN(swiotlb_force_off, "Please remove swiotlb=off\n");
>  		swiotlb = 1;
>  	}
>  
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index f7535d1..dd7cf65 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -8,6 +8,7 @@ struct dma_attrs;
>  struct scatterlist;
>  
>  extern int swiotlb_force;
> +extern int swiotlb_force_off;
>  
>  /*
>   * Maximum allowable number of contiguous slabs to map,
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index 6b99ea7..3f51b2c 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -51,6 +51,7 @@
>  #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
>  
>  int swiotlb_force;
> +int swiotlb_force_off;
>  
>  /*
>   * Used to do a quick range check in swiotlb_tbl_unmap_single and
> @@ -102,8 +103,10 @@ setup_io_tlb_npages(char *str)
>  	}
>  	if (*str == ',')
>  		++str;
> -	if (!strcmp(str, "force"))
> +	if (!strcmp(str, "force") || !strcmp(str, "on"))
>  		swiotlb_force = 1;
> +	if (!strcmp(str, "off"))
> +		swiotlb_force_off = 1;
>  
>  	return 1;
>  }
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
