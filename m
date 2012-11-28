Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2K1RH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:07:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41141 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2K1RH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:07:27 -0500
Date: Wed, 28 Nov 2012 12:06:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 12/46] x86, mm: use pfn_range_is_mapped() with CPA
Message-ID: <20121128170625.GJ21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
 <1353123563-3103-13-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353123563-3103-13-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:38:49PM -0800, Yinghai Lu wrote:
> We are going to map ram only, so under max_low_pfn_mapped,
> between 4g and max_pfn_mapped does not mean mapped at all.

I think I know what you are saying but I am having a hard
time parsing it. Is this what you mean?

"We check to see if the PFNs are under max_low_pfn_mapped or
between 4G and max_pfn_mapped. If they are not: then we
map them."  ?


> 
> Use pfn_range_is_mapped() directly.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/pageattr.c |   16 +++-------------
>  1 files changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index a718e0d..44acfcd 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -551,16 +551,10 @@ static int split_large_page(pte_t *kpte, unsigned long address)
>  	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
>  		set_pte(&pbase[i], pfn_pte(pfn, ref_prot));
>  
> -	if (address >= (unsigned long)__va(0) &&
> -		address < (unsigned long)__va(max_low_pfn_mapped << PAGE_SHIFT))
> +	if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),
> +				PFN_DOWN(__pa(address)) + 1))
>  		split_page_count(level);
>  
> -#ifdef CONFIG_X86_64
> -	if (address >= (unsigned long)__va(1UL<<32) &&
> -		address < (unsigned long)__va(max_pfn_mapped << PAGE_SHIFT))
> -		split_page_count(level);
> -#endif
> -
>  	/*
>  	 * Install the new, split up pagetable.
>  	 *
> @@ -729,13 +723,9 @@ static int cpa_process_alias(struct cpa_data *cpa)
>  	unsigned long vaddr;
>  	int ret;
>  
> -	if (cpa->pfn >= max_pfn_mapped)
> +	if (!pfn_range_is_mapped(cpa->pfn, cpa->pfn + 1))
>  		return 0;
>  
> -#ifdef CONFIG_X86_64
> -	if (cpa->pfn >= max_low_pfn_mapped && cpa->pfn < (1UL<<(32-PAGE_SHIFT)))
> -		return 0;
> -#endif
>  	/*
>  	 * No need to redo, when the primary call touched the direct
>  	 * mapping already:
> -- 
> 1.7.7
