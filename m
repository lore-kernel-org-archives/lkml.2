Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab2JRLbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:31:35 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:42073 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab2JRLbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:31:33 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="15252487"
Date: Thu, 18 Oct 2012 12:31:08 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 3/6]: PVH:  mmu related changes.
In-Reply-To: <20121017173119.4e12b222@mantra.us.oracle.com>
Message-ID: <alpine.DEB.2.02.1210181225530.2689@kaball.uk.xensource.com>
References: <20121017173119.4e12b222@mantra.us.oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Mukesh Rathor wrote:
> PVH: This patch implements mmu changes for PVH. First the set/clear mmio pte function makes a hypercall to update the p2m in xen with 1:1 mapping. PVH uses mostly native mmu ops. Two local functions are introduced to add to xen physmap for xen remap interface. xen unmap interface is introduced so the privcmd pte entries can be cleared in xen p2m table.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> ---
>  arch/x86/xen/mmu.c    |  174 ++++++++++++++++++++++++++++++++++++++++++++++---
>  arch/x86/xen/mmu.h    |    2 +
>  drivers/xen/privcmd.c |    5 +-
>  include/xen/xen-ops.h |    5 +-
>  4 files changed, 174 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 5a16824..5ed3b3e 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -73,6 +73,7 @@
>  #include <xen/interface/version.h>
>  #include <xen/interface/memory.h>
>  #include <xen/hvc-console.h>
> +#include <xen/balloon.h>
>  
>  #include "multicalls.h"
>  #include "mmu.h"
> @@ -331,6 +332,20 @@ static void xen_set_pte(pte_t *ptep, pte_t pteval)
>  	__xen_set_pte(ptep, pteval);
>  }
>  
> +void xen_set_clr_mmio_pvh_pte(unsigned long pfn, unsigned long mfn,
> +			      int nr_mfns, int add_mapping)
> +{
> +	struct physdev_map_iomem iomem;
> +
> +	iomem.first_gfn = pfn;
> +	iomem.first_mfn = mfn;
> +	iomem.nr_mfns = nr_mfns;
> +	iomem.add_mapping = add_mapping;
> +
> +	if (HYPERVISOR_physdev_op(PHYSDEVOP_pvh_map_iomem, &iomem))
> +		BUG();
> +}

You introduce this function here but it is unused. It is not clear from
the patch description why you are introducing it.


>  static void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
>  		    pte_t *ptep, pte_t pteval)
>  {
> @@ -1220,6 +1235,8 @@ static void __init xen_pagetable_init(void)
>  #endif
>  	paging_init();
>  	xen_setup_shared_info();
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
>  #ifdef CONFIG_X86_64
>  	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
>  		unsigned long new_mfn_list;
> @@ -1527,6 +1544,10 @@ static void __init xen_set_pte_init(pte_t *ptep, pte_t pte)
>  static void pin_pagetable_pfn(unsigned cmd, unsigned long pfn)
>  {
>  	struct mmuext_op op;
> +
> +	if (xen_feature(XENFEAT_writable_page_tables))
> +		return;
> +
>  	op.cmd = cmd;
>  	op.arg1.mfn = pfn_to_mfn(pfn);
>  	if (HYPERVISOR_mmuext_op(&op, 1, NULL, DOMID_SELF))
> @@ -1724,6 +1745,10 @@ static void set_page_prot(void *addr, pgprot_t prot)
>  	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
>  	pte_t pte = pfn_pte(pfn, prot);
>  
> +	/* recall for PVH, page tables are native. */
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
>  	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
>  		BUG();
>  }
> @@ -1801,6 +1826,9 @@ static void convert_pfn_mfn(void *v)
>  	pte_t *pte = v;
>  	int i;
>  
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
>  	/* All levels are converted the same way, so just treat them
>  	   as ptes. */
>  	for (i = 0; i < PTRS_PER_PTE; i++)
> @@ -1820,6 +1848,7 @@ static void __init check_pt_base(unsigned long *pt_base, unsigned long *pt_end,
>  		(*pt_end)--;
>  	}
>  }
> +
>  /*
>   * Set up the initial kernel pagetable.
>   *
> @@ -1830,6 +1859,7 @@ static void __init check_pt_base(unsigned long *pt_base, unsigned long *pt_end,
>   * but that's enough to get __va working.  We need to fill in the rest
>   * of the physical mapping once some sort of allocator has been set
>   * up.
> + * NOTE: for PVH, the page tables are native.
>   */
>  void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  {
> @@ -1907,10 +1937,13 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  	 * structure to attach it to, so make sure we just set kernel
>  	 * pgd.
>  	 */
> -	xen_mc_batch();
> -	__xen_write_cr3(true, __pa(init_level4_pgt));
> -	xen_mc_issue(PARAVIRT_LAZY_CPU);
> -
> +	if (xen_feature(XENFEAT_writable_page_tables)) {
> +		native_write_cr3(__pa(init_level4_pgt));
> +	} else {
> +		xen_mc_batch();
> +		__xen_write_cr3(true, __pa(init_level4_pgt));
> +		xen_mc_issue(PARAVIRT_LAZY_CPU);
> +	}
>  	/* We can't that easily rip out L3 and L2, as the Xen pagetables are
>  	 * set out this way: [L4], [L1], [L2], [L3], [L1], [L1] ...  for
>  	 * the initial domain. For guests using the toolstack, they are in:
> @@ -2177,8 +2210,20 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
>  
>  void __init xen_init_mmu_ops(void)
>  {
> -	x86_init.mapping.pagetable_reserve = xen_mapping_pagetable_reserve;
>  	x86_init.paging.pagetable_init = xen_pagetable_init;
> +
> +	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> +		pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
> +#if 0
> +		/* For PCI devices to map iomem. */
> +		if (xen_initial_domain()) {
> +			pv_mmu_ops.set_pte = native_set_pte;
> +			pv_mmu_ops.set_pte_at = native_set_pte_at;
> +		}
> +#endif

just remove the commented out code
