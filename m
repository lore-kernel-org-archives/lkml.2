Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2G0LiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 07:38:19 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:43931 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2G0LiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 07:38:18 -0400
X-IronPort-AV: E=Sophos;i="4.77,666,1336348800"; 
   d="scan'208";a="13733491"
Date: Fri, 27 Jul 2012 12:37:24 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 3/7] xen/mmu: Release the Xen provided L4
 (PGD) back.
In-Reply-To: <1343335652-5659-4-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1207271231560.26163@kaball.uk.xensource.com>
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com> <1343335652-5659-4-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012, Konrad Rzeszutek Wilk wrote:
> Since we are not using it and somebody else could use it.

make sense except it is almost entirely rewritten by the following
patch...

> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index a59070b..48bdc9f 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1782,20 +1782,21 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  	/* Unpin Xen-provided one */
>  	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
>  
> -	/* Switch over */
> -	pgd = init_level4_pgt;
> -
>  	/*
>  	 * At this stage there can be no user pgd, and no page
>  	 * structure to attach it to, so make sure we just set kernel
>  	 * pgd.
>  	 */
>  	xen_mc_batch();
> -	__xen_write_cr3(true, __pa(pgd));
> +	__xen_write_cr3(true, __pa(init_level4_pgt));
>  	xen_mc_issue(PARAVIRT_LAZY_CPU);
>  
> -	memblock_reserve(__pa(xen_start_info->pt_base),
> -			 xen_start_info->nr_pt_frames * PAGE_SIZE);
> +	/* Offset by one page since the original pgd is going bye bye */
> +	memblock_reserve(__pa(xen_start_info->pt_base + PAGE_SIZE),
> +			 (xen_start_info->nr_pt_frames * PAGE_SIZE) - PAGE_SIZE);
> +	/* and also RW it so it can actually be used. */
> +	set_page_prot(pgd, PAGE_KERNEL);
> +	clear_page(pgd);
>  }
>  #else	/* !CONFIG_X86_64 */
>  static RESERVE_BRK_ARRAY(pmd_t, initial_kernel_pmd, PTRS_PER_PMD);
> -- 
> 1.7.7.6
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
