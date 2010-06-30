Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab0F3UpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:45:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530Ab0F3UpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:45:03 -0400
Date: Wed, 30 Jun 2010 17:43:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 9/11] KVM: MMU: prefetch ptes when intercepted guest
 #PF
Message-ID: <20100630204324.GA5366@amt.cnet>
References: <4C2AF9FA.9020601@cn.fujitsu.com>
 <4C2AFB65.2030807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2AFB65.2030807@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 04:08:05PM +0800, Xiao Guangrong wrote:
> Support prefetch ptes when intercept guest #PF, avoid to #PF by later
> access
> 
> If we meet any failure in the prefetch path, we will exit it and
> not try other ptes to avoid become heavy path
> 
> Note: this speculative will mark page become dirty but it not really
> accessed, the same issue is in other speculative paths like invlpg,
> pte write, fortunately, it just affect host memory management. After
> Avi's patchset named "[PATCH v2 1/4] KVM: MMU: Introduce drop_spte()"
> merged, we will easily fix it. Will do it in the future.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c         |   83 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/paging_tmpl.h |   76 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 159 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 6673484..fadfafe 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2002,6 +2002,88 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
>  {
>  }
>  
> +static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
> +				    struct kvm_mmu_page *sp,
> +				    u64 *start, u64 *end)
> +{
> +	gfn_t gfn;
> +	struct page *pages[PTE_PREFETCH_NUM];
> +
> +	gfn = sp->gfn + start - sp->spt;
> +	while (start < end) {
> +		unsigned long addr;
> +		int entry, j, ret;
> +
> +		addr = gfn_to_hva_many(vcpu->kvm, gfn, &entry);
> +		if (kvm_is_error_hva(addr))
> +			return -1;
> +
> +		entry = min(entry, (int)(end - start));
> +		ret = __get_user_pages_fast(addr, entry, 1, pages);
> +		if (ret <= 0)
> +			return -1;

Why can't you use gfn_to_pfn_atomic() here, one page at a time? Is 
the overhead significant that this is worthwhile?

You're bypassing the centralized interface.

> +
> +		for (j = 0; j < ret; j++, gfn++, start++)
> +			mmu_set_spte(vcpu, start, ACC_ALL,
> +				     sp->role.access, 0, 0, 1, NULL,
> +				     sp->role.level, gfn,
> +				     page_to_pfn(pages[j]), true, false);
> +
> +		if (ret < entry)
> +			return -1;
> +	}
> +	return 0;
> +}
> +
> +static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
> +				  struct kvm_mmu_page *sp, u64 *sptep)
> +{
> +	u64 *start = NULL;
> +	int index, i, max;
> +
> +	WARN_ON(!sp->role.direct);
> +
> +	if (pte_prefetch_topup_memory_cache(vcpu))
> +		return;
> +
> +	index = sptep - sp->spt;
> +	i = index & ~(PTE_PREFETCH_NUM - 1);
> +	max = index | (PTE_PREFETCH_NUM - 1);
> +
> +	for (; i < max; i++) {
> +		u64 *spte = sp->spt + i;
> +
> +		if (*spte != shadow_trap_nonpresent_pte || spte == sptep) {
> +			if (!start)
> +				continue;
> +			if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
> +				break;
> +			start = NULL;
> +		} else if (!start)
> +			start = spte;
> +	}
> +}
> +
> +static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
> +{
> +	struct kvm_mmu_page *sp;
> +
> +	/*
> +	 * Since it's no accessed bit on EPT, it's no way to
> +	 * distinguish between actually accessed translations
> +	 * and prefetched, so disable pte prefetch if EPT is
> +	 * enabled.
> +	 */
> +	if (!shadow_accessed_mask)
> +		return;
> +
> +	sp = page_header(__pa(sptep));
> +	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
> +		return;
> +
> +	__direct_pte_prefetch(vcpu, sp, sptep);
> +}
> +
>  static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  			int level, gfn_t gfn, pfn_t pfn)
>  {
> @@ -2015,6 +2097,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, ACC_ALL,
>  				     0, write, 1, &pt_write,
>  				     level, gfn, pfn, false, true);
> +			direct_pte_prefetch(vcpu, iterator.sptep);
>  			++vcpu->stat.pf_fixed;
>  			break;
>  		}
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 3350c02..d8c3be8 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -291,6 +291,81 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  		     gpte_to_gfn(gpte), pfn, true, true);
>  }
>  
> +static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
> +{
> +	struct kvm_mmu_page *sp;
> +	pt_element_t gptep[PTE_PREFETCH_NUM];
> +	gpa_t first_pte_gpa;
> +	int offset = 0, index, i, j, max;
> +
> +	sp = page_header(__pa(sptep));
> +	index = sptep - sp->spt;
> +
> +	if (sp->role.level > PT_PAGE_TABLE_LEVEL)
> +		return;
> +
> +	if (sp->role.direct)
> +		return __direct_pte_prefetch(vcpu, sp, sptep);
> +
> +	index = sptep - sp->spt;
> +	i = index & ~(PTE_PREFETCH_NUM - 1);
> +	max = index | (PTE_PREFETCH_NUM - 1);
> +
> +	if (PTTYPE == 32)
> +		offset = sp->role.quadrant << PT64_LEVEL_BITS;
> +
> +	first_pte_gpa = gfn_to_gpa(sp->gfn) +
> +				(offset + i) * sizeof(pt_element_t);
> +
> +	if (kvm_read_guest_atomic(vcpu->kvm, first_pte_gpa, gptep,
> +					sizeof(gptep)) < 0)
> +		return;
> +
> +	if (pte_prefetch_topup_memory_cache(vcpu))
> +		return;
> +
> +	for (j = 0; i < max; i++, j++) {
> +		pt_element_t gpte;
> +		unsigned pte_access;
> +		u64 *spte = sp->spt + i;
> +		gfn_t gfn;
> +		pfn_t pfn;
> +
> +		if (spte == sptep)
> +			continue;
> +
> +		if (*spte != shadow_trap_nonpresent_pte)
> +			continue;
> +
> +		gpte = gptep[j];
> +
> +		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL))
> +			break;
> +
> +		if (!(gpte & PT_ACCESSED_MASK))
> +			continue;
> +
> +		if (!is_present_gpte(gpte)) {
> +			if (!sp->unsync)
> +				__set_spte(spte, shadow_notrap_nonpresent_pte);
> +			continue;
> +		}
> +
> +		gfn = gpte_to_gfn(gpte);
> +
> +		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
> +		if (is_error_pfn(pfn)) {
> +			kvm_release_pfn_clean(pfn);
> +			break;
> +		}
> +
> +		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
> +		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
> +			     is_dirty_gpte(gpte), NULL, sp->role.level, gfn,
> +			     pfn, true, false);

reset_host_protection should be true, see commit 1403283acca (also for
direct case to be consistent).
