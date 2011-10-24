Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1JXKHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:07:39 -0400
Received: from 8bytes.org ([88.198.83.132]:38907 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab1JXKHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:07:38 -0400
Date: Mon, 24 Oct 2011 12:07:36 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86 amd_gart_64: Verify we can perform the
	remapping requested
Message-ID: <20111024100735.GL1512@8bytes.org>
References: <m1lisj48q1.fsf@fess.ebiederm.org> <m1fwir48og.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fwir48og.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 02:20:15PM -0700, Eric W. Biederman wrote:
> 
> Recently I had a driver try with a peculiar 2G dma memory limit.
> The driver failed in weird and strange ways because the GART remapping
> apperture had been allocated above 2G where the driver cound not reach,
> and no error was reported when the mappings were setup.
> 
> Implement gart_dma_supported to test for this problem case and to return
> and error if we can not support the remapping.

You do basically the same as for swiotlb, so it must be good :)

> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

For both patches:

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  arch/x86/kernel/amd_gart_64.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
> index 8a439d3..66279cb 100644
> --- a/arch/x86/kernel/amd_gart_64.c
> +++ b/arch/x86/kernel/amd_gart_64.c
> @@ -519,6 +519,14 @@ static int gart_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  	return (dma_addr == bad_dma_addr);
>  }
>  
> +static int gart_dma_supported(struct device *dev, u64 mask)
> +{
> +	unsigned long iommu_max_addr = iommu_bus_base + iommu_size - 1;
> +
> +	/* Fail if the gart window is too high to fit in the devices dma mask */
> +	return iommu_max_addr <= mask;
> +}
> +
>  static int no_agp;
>  
>  static __init unsigned long check_iommu_size(unsigned long aper, u64 aper_size)
> @@ -703,6 +711,7 @@ static struct dma_map_ops gart_dma_ops = {
>  	.alloc_coherent			= gart_alloc_coherent,
>  	.free_coherent			= gart_free_coherent,
>  	.mapping_error			= gart_mapping_error,
> +	.dma_supported			= gart_dma_supported,
>  };
>  
>  static void gart_iommu_shutdown(void)
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Nothing great was ever achieved without enthusiasm.
