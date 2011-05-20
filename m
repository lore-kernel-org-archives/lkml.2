Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559Ab1ETBFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:05:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:46457 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933314Ab1ETBFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:05:41 -0400
Subject: Re: [PATCH 7/7] [RFC] SMP support code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
In-Reply-To: <1305753895-24845-7-git-send-email-ericvh@gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	 <1305753895-24845-7-git-send-email-ericvh@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 11:05:29 +1000
Message-ID: <1305853529.7481.111.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 16:24 -0500, Eric Van Hensbergen wrote:

> +#ifdef CONFIG_BGP
> +/*
> + * The icbi instruction does not broadcast to all cpus in the ppc450
> + * processor used by Blue Gene/P.  It is unlikely this problem will
> + * be exhibited in other processors so this remains ifdef'ed for BGP
> + * specifically.
> + *
> + * We deal with this by marking executable pages either writable, or
> + * executable, but never both.  The permissions will fault back and
> + * forth if the thread is actively writing to executable sections.
> + * Each time we fault to become executable we flush the dcache into
> + * icache on all cpus.
> + *

I know that hack :-) I think I wrote it even (or a version of it, that
was a long time ago) ;-) That doesn't make it pretty tho ...
> 

> +struct bgp_fixup_parm {
> +	struct page		*page;
> +	unsigned long		address;
> +	struct vm_area_struct	*vma;
> +};
> +
> +static void bgp_fixup_cache_tlb(void *parm)
> +{
> +	struct bgp_fixup_parm	*p = parm;
> +
> +	if (!PageHighMem(p->page))
> +		flush_dcache_icache_page(p->page);
> +	local_flush_tlb_page(p->vma, p->address);
> +}
> +
> +static void bgp_fixup_access_perms(struct vm_area_struct *vma,
> +				  unsigned long address,
> +				  int is_write, int is_exec)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	pte_t *ptep = NULL;
> +	pmd_t *pmdp;
> +
> +	if (get_pteptr(mm, address, &ptep, &pmdp)) {
> +		spinlock_t *ptl = pte_lockptr(mm, pmdp);
> +		pte_t old;
> +
> +		spin_lock(ptl);
> +		old = *ptep;
> +		if (pte_present(old)) {
> +			struct page *page = pte_page(old);
> +
> +			if (is_exec) {
> +				struct bgp_fixup_parm param = {
> +					.page		= page,
> +					.address	= address,
> +					.vma		= vma,
> +				};
> +				pte_update(ptep, _PAGE_HWWRITE, 0);
> +				on_each_cpu(bgp_fixup_cache_tlb, &param, 1);

Gotta be very careful with on_each_cpu() done within a lock. I wonder if
we could fast-path & simplify that using crits, is there a way to shoot
criticial IPIs to the other cores ? Might even be able in this case to
do it entirely in asm in the page fault path.

> +				pte_update(ptep, 0, _PAGE_EXEC);
> +				pte_unmap_unlock(ptep, ptl);
> +				return;
> +			}
> +			if (is_write &&
> +			    (pte_val(old) & _PAGE_RW) &&
> +			    (pte_val(old) & _PAGE_DIRTY) &&
> +			    !(pte_val(old) & _PAGE_HWWRITE)) {
> +				pte_update(ptep, _PAGE_EXEC, _PAGE_HWWRITE);
> +			}
> +		}
> +		if (!pte_same(old, *ptep))
> +			flush_tlb_page(vma, address);
> +		pte_unmap_unlock(ptep, ptl);
> +	}
> +}
> +#endif /* CONFIG_BGP */
> +
>  /*
>   * For 600- and 800-family processors, the error_code parameter is DSISR
>   * for a data fault, SRR1 for an instruction fault. For 400-family processors
> @@ -333,6 +404,12 @@ good_area:
>  		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
>  				     regs, address);
>  	}
> +
> +#ifdef CONFIG_BGP
> +	/* Fixup _PAGE_EXEC and _PAGE_HWWRITE if necessary */
> +	bgp_fixup_access_perms(vma, address, is_write, is_exec);
> +#endif /* CONFIG_BGP */
> +
>  	up_read(&mm->mmap_sem);
>  	return 0;
>  
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index 3a3c711..b77a25f 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -300,7 +300,7 @@ config PPC_PERF_CTRS
>           This enables the powerpc-specific perf_event back-end.
>  
>  config SMP
> -	depends on PPC_BOOK3S || PPC_BOOK3E || FSL_BOOKE || PPC_47x
> +	depends on PPC_BOOK3S || PPC_BOOK3E || FSL_BOOKE || PPC_47x || BGP
>  	bool "Symmetric multi-processing support"
>  	---help---
>  	  This enables support for systems with more than one CPU. If you have


