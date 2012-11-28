Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab2K1RIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:08:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41656 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2K1RIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:08:05 -0500
Date: Wed, 28 Nov 2012 12:07:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 13/46] x86, mm: use pfn_range_is_mapped() with gart
Message-ID: <20121128170711.GK21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
 <1353123563-3103-14-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353123563-3103-14-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:38:50PM -0800, Yinghai Lu wrote:
> We are going to map ram only, so under max_low_pfn_mapped,
> between 4g and max_pfn_mapped does not mean mapped at all.

Perhaps the re-write I mentioned in the earlier email could
help here.

> 
> Use pfn_range_is_mapped() directly.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/amd_gart_64.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
> index e663112..b574b29 100644
> --- a/arch/x86/kernel/amd_gart_64.c
> +++ b/arch/x86/kernel/amd_gart_64.c
> @@ -768,10 +768,9 @@ int __init gart_iommu_init(void)
>  	aper_base	= info.aper_base;
>  	end_pfn		= (aper_base>>PAGE_SHIFT) + (aper_size>>PAGE_SHIFT);
>  
> -	if (end_pfn > max_low_pfn_mapped) {
> -		start_pfn = (aper_base>>PAGE_SHIFT);
> +	start_pfn = PFN_DOWN(aper_base);
> +	if (!pfn_range_is_mapped(start_pfn, end_pfn))
>  		init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
> -	}
>  
>  	pr_info("PCI-DMA: using GART IOMMU.\n");
>  	iommu_size = check_iommu_size(info.aper_base, aper_size);
> -- 
> 1.7.7
