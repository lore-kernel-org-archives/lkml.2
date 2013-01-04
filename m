Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3ADQGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:06:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32323 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3ADQGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:06:14 -0500
Date: Fri, 4 Jan 2013 11:05:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
Message-ID: <20130104160533.GF3334@phenom.dumpdata.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-27-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357260531-11115-27-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:46PM -0800, Yinghai Lu wrote:
> Normal boot path on system with iommu support:
> swiotlb buffer will be allocated early at first and then try to initialize
> iommu, if iommu for intel or amd could setup properly, swiotlb buffer
> will be freed.
> 
> The early allocating is with bootmem, and get panic when we try to use
> kdump with buffer above 4G only if swiotlb is enabled.
> 
> because actually the kernel can go on without swiotlb, and use intel iommu.
> 
> Try disable swiotlb if there is not enough ram for it.
> 
> That is for kdump to use kernel above 4G.
> 
> Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> ---
>  arch/x86/kernel/pci-swiotlb.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index 6c483ba..949ebfe 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -6,6 +6,7 @@
>  #include <linux/swiotlb.h>
>  #include <linux/bootmem.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/memblock.h>
>  
>  #include <asm/iommu.h>
>  #include <asm/swiotlb.h>
> @@ -50,6 +51,11 @@ static struct dma_map_ops swiotlb_dma_ops = {
>  	.dma_supported = NULL,
>  };
>  
> +static bool __init enough_mem_for_swiotlb(void)
> +{
> +	/* do we have less than 1M RAM under 4G ? */

And why 1MB? The default size is 64MB.

> +	return memblock_mem_size(1ULL<<(32-PAGE_SHIFT)) > (1ULL<<20);
> +}
>  /*
>   * pci_swiotlb_detect_override - set swiotlb to 1 if necessary
>   *
> @@ -58,12 +64,12 @@ static struct dma_map_ops swiotlb_dma_ops = {
>   */
>  int __init pci_swiotlb_detect_override(void)
>  {
> -	int use_swiotlb = swiotlb | swiotlb_force;
> -
>  	if (swiotlb_force)
>  		swiotlb = 1;
> +	else if (!enough_mem_for_swiotlb())
> +		swiotlb = 0;
>  
> -	return use_swiotlb;
> +	return swiotlb;
>  }
>  IOMMU_INIT_FINISH(pci_swiotlb_detect_override,
>  		  pci_xen_swiotlb_detect,
> @@ -78,7 +84,7 @@ int __init pci_swiotlb_detect_4gb(void)
>  {
>  	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
>  #ifdef CONFIG_X86_64
> -	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
> +	if (!no_iommu && max_pfn > MAX_DMA32_PFN && enough_mem_for_swiotlb())
>  		swiotlb = 1;
>  #endif
>  	return swiotlb;
> -- 
> 1.7.10.4
> 
