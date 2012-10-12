Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720Ab2JLPYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:24:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31830 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab2JLPYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:24:37 -0400
Date: Fri, 12 Oct 2012 11:12:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 6/8] x86/xen: Use __pa_symbol instead of __pa on C
 visible symbols
Message-ID: <20121012151218.GA29250@phenom.dumpdata.com>
References: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com>
 <20121011205023.12787.18397.stgit@gitlad.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011205023.12787.18397.stgit@gitlad.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 01:50:23PM -0700, Alexander Duyck wrote:
> This change updates a few of the functions to use __pa_symbol when
> translating C visible symbols instead of __pa.  By using __pa_symbol we are
> able to drop a few extra lines of code as don't have to test to see if the
> virtual pointer is a part of the kernel text or just standard virtual memory.
> 
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> ---
> 
>  arch/x86/xen/mmu.c |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index fd28d86..c50a87e 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1449,7 +1449,8 @@ static int xen_pgd_alloc(struct mm_struct *mm)
>  
>  		if (user_pgd != NULL) {
>  			user_pgd[pgd_index(VSYSCALL_START)] =
> -				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
> +				__pgd(__pa_symbol(level3_user_vsyscall) |
> +				      _PAGE_TABLE);
>  			ret = 0;
>  		}
>  
> @@ -1908,7 +1909,7 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  	 * pgd.
>  	 */
>  	xen_mc_batch();
> -	__xen_write_cr3(true, __pa(init_level4_pgt));
> +	__xen_write_cr3(true, __pa_symbol(init_level4_pgt));
>  	xen_mc_issue(PARAVIRT_LAZY_CPU);
>  
>  	/* We can't that easily rip out L3 and L2, as the Xen pagetables are
> @@ -1931,10 +1932,10 @@ static RESERVE_BRK_ARRAY(pmd_t, swapper_kernel_pmd, PTRS_PER_PMD);
>  
>  static void __init xen_write_cr3_init(unsigned long cr3)
>  {
> -	unsigned long pfn = PFN_DOWN(__pa(swapper_pg_dir));
> +	unsigned long pfn = PFN_DOWN(__pa_symbol(swapper_pg_dir));
>  
> -	BUG_ON(read_cr3() != __pa(initial_page_table));
> -	BUG_ON(cr3 != __pa(swapper_pg_dir));
> +	BUG_ON(read_cr3() != __pa_symbol(initial_page_table));
> +	BUG_ON(cr3 != __pa_symbol(swapper_pg_dir));
>  
>  	/*
>  	 * We are switching to swapper_pg_dir for the first time (from
> @@ -1958,7 +1959,7 @@ static void __init xen_write_cr3_init(unsigned long cr3)
>  	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, pfn);
>  
>  	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE,
> -			  PFN_DOWN(__pa(initial_page_table)));
> +			  PFN_DOWN(__pa_symbol(initial_page_table)));
>  	set_page_prot(initial_page_table, PAGE_KERNEL);
>  	set_page_prot(initial_kernel_pmd, PAGE_KERNEL);
>  
> @@ -1983,7 +1984,7 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  
>  	copy_page(initial_page_table, pgd);
>  	initial_page_table[KERNEL_PGD_BOUNDARY] =
> -		__pgd(__pa(initial_kernel_pmd) | _PAGE_PRESENT);
> +		__pgd(__pa_symbol(initial_kernel_pmd) | _PAGE_PRESENT);
>  
>  	set_page_prot(initial_kernel_pmd, PAGE_KERNEL_RO);
>  	set_page_prot(initial_page_table, PAGE_KERNEL_RO);
> @@ -1992,8 +1993,8 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
>  
>  	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE,
> -			  PFN_DOWN(__pa(initial_page_table)));
> -	xen_write_cr3(__pa(initial_page_table));
> +			  PFN_DOWN(__pa_symbol(initial_page_table)));
> +	xen_write_cr3(__pa_symbol(initial_page_table));
>  
>  	memblock_reserve(__pa(xen_start_info->pt_base),
>  			 xen_start_info->nr_pt_frames * PAGE_SIZE);
