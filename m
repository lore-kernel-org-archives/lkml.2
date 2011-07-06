Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1GFSxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab1GFSxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:53:16 -0400
Date: Wed, 6 Jul 2011 15:52:52 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 18/19] KVM: MMU: mmio page fault support
Message-ID: <20110706185252.GC9820@amt.cnet>
References: <4E0C3178.2080603@cn.fujitsu.com>
 <4E0C3375.6010500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0C3375.6010500@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 04:27:33PM +0800, Xiao Guangrong wrote:
> The idea is from Avi:
> 
> | We could cache the result of a miss in an spte by using a reserved bit, and
> | checking the page fault error code (or seeing if we get an ept violation or
> | ept misconfiguration), so if we get repeated mmio on a page, we don't need to
> | search the slot list/tree.
> | (https://lkml.org/lkml/2011/2/22/221)
> 
> When the page fault is caused by mmio, we cache the info in the shadow page
> table, and also set the reserved bits in the shadow page table, so if the mmio
> is caused again, we can quickly identify it and emulate it directly
> 
> Searching mmio gfn in memslots is heavy since we need to walk all memeslots, it
> can be reduced by this feature, and also avoid walking guest page table for
> soft mmu.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c         |  154 ++++++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/mmu.h         |    2 +
>  arch/x86/kvm/paging_tmpl.h |   21 ++++--
>  arch/x86/kvm/vmx.c         |   22 ++++++-
>  arch/x86/kvm/x86.c         |   32 +++++++++
>  5 files changed, 217 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 2ecbffb..a5a69a8 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -197,6 +197,47 @@ static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
>  static u64 __read_mostly shadow_user_mask;
>  static u64 __read_mostly shadow_accessed_mask;
>  static u64 __read_mostly shadow_dirty_mask;
> +static u64 __read_mostly shadow_mmio_mask;
> +
> +static void mmu_spte_set(u64 *sptep, u64 spte);
> +
> +void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask)
> +{
> +	shadow_mmio_mask = mmio_mask;
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
> +
> +static void mark_mmio_spte(u64 *sptep, u64 gfn, unsigned access)
> +{
> +	access &= ACC_WRITE_MASK | ACC_USER_MASK;
> +
> +	mmu_spte_set(sptep, shadow_mmio_mask | access | gfn << PAGE_SHIFT);
> +}
> +
> +static bool is_mmio_spte(u64 spte)
> +{
> +	return (spte & shadow_mmio_mask) == shadow_mmio_mask;
> +}
> +
> +static gfn_t get_mmio_spte_gfn(u64 spte)
> +{
> +	return (spte & ~shadow_mmio_mask) >> PAGE_SHIFT;
> +}
> +
> +static unsigned get_mmio_spte_access(u64 spte)
> +{
> +	return (spte & ~shadow_mmio_mask) & ~PAGE_MASK;
> +}
> +
> +static bool set_mmio_spte(u64 *sptep, gfn_t gfn, pfn_t pfn, unsigned access)
> +{
> +	if (unlikely(is_mmio_pfn(pfn))) {
> +		mark_mmio_spte(sptep, gfn, access);
> +		return true;
> +	}
> +
> +	return false;
> +}
>  
>  static inline u64 rsvd_bits(int s, int e)
>  {
> @@ -226,7 +267,7 @@ static int is_nx(struct kvm_vcpu *vcpu)
>  
>  static int is_shadow_present_pte(u64 pte)
>  {
> -	return pte & PT_PRESENT_MASK;
> +	return pte & PT_PRESENT_MASK && !is_mmio_spte(pte);
>  }
>  
>  static int is_large_pte(u64 pte)
> @@ -1748,7 +1789,8 @@ static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>  			child = page_header(pte & PT64_BASE_ADDR_MASK);
>  			drop_parent_pte(child, spte);
>  		}
> -	}
> +	} else if (is_mmio_spte(pte))
> +		mmu_spte_clear_no_track(spte);
>  
>  	if (is_large_pte(pte))
>  		--kvm->stat.lpages;
> @@ -2123,6 +2165,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	u64 spte, entry = *sptep;
>  	int ret = 0;
>  
> +	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
> +		return 0;
> +
>  	/*
>  	 * We don't set the accessed bit, since we sometimes want to see
>  	 * whether the guest actually used the pte (in order to detect
> @@ -2258,6 +2303,9 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		kvm_mmu_flush_tlb(vcpu);
>  	}
>  
> +	if (unlikely(is_mmio_spte(*sptep) && emulate))
> +		*emulate = 1;
> +
>  	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
>  	pgprintk("instantiating %s PTE (%s) at %llx (%llx) addr %p\n",
>  		 is_large_pte(*sptep)? "2MB" : "4kB",
> @@ -2484,7 +2532,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>  
>  static bool mmu_invalid_pfn(pfn_t pfn)
>  {
> -	return unlikely(is_invalid_pfn(pfn) || is_mmio_pfn(pfn));
> +	return unlikely(is_invalid_pfn(pfn));
>  }
>  
>  static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
> @@ -2498,11 +2546,8 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
>  		goto exit;
>  	}
>  
> -	if (unlikely(is_mmio_pfn(pfn))) {
> +	if (unlikely(is_mmio_pfn(pfn)))
>  		vcpu_cache_mmio_info(vcpu, gva, gfn, access);
> -		*ret_val = 1;
> -		goto exit;
> -	}
>  
>  	ret = false;
>  exit:
> @@ -2816,6 +2861,77 @@ static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
>  	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, access);
>  }
>  
> +static bool quickly_check_mmio_pf(struct kvm_vcpu *vcpu, u64 addr, bool direct)
> +{
> +	if (direct)
> +		return vcpu_match_mmio_gpa(vcpu, addr);
> +
> +	return vcpu_match_mmio_gva(vcpu, addr);
> +}
> +
> +static u64 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr)
> +{
> +	struct kvm_shadow_walk_iterator iterator;
> +	u64 spte = 0ull;
> +
> +	walk_shadow_page_lockless_begin(vcpu);
> +	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte)
> +		if (!is_shadow_present_pte(spte))
> +			break;
> +	walk_shadow_page_lockless_end(vcpu);
> +
> +	return spte;
> +}
> +
> +/*
> + * If it is a real mmio page fault, return 1 and emulat the instruction
> + * directly, return 0 to let CPU fault again on the address, -1 is
> + * returned if bug is detected.
> + */
> +int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
> +{
> +	u64 spte;
> +
> +	if (quickly_check_mmio_pf(vcpu, addr, direct))
> +		return 1;
> +
> +	spte = walk_shadow_page_get_mmio_spte(vcpu, addr);
> +
> +	if (is_mmio_spte(spte)) {
> +		gfn_t gfn = get_mmio_spte_gfn(spte);
> +		unsigned access = get_mmio_spte_access(spte);
> +
> +		if (direct)
> +			addr = 0;
> +		vcpu_cache_mmio_info(vcpu, addr, gfn, access);
> +		return 1;
> +	}
> +
> +	/*
> +	 * It's ok if the gva is remapped by other cpus on shadow guest,
> +	 * it's a BUG if the gfn is not a mmio page.
> +	 */
> +	if (direct && is_shadow_present_pte(spte))
> +		return -1;

This is only going to generate an spte dump, for a genuine EPT
misconfig, if the present bit is set.

Should be:

/*
 * Page table zapped by other cpus, let CPU fault again on
 * the address.
 */
if (*spte == 0ull)
    return 0;
/* BUG if gfn is not an mmio page */
return -1;

> +static bool sync_mmio_spte(u64 *sptep, gfn_t gfn, unsigned access,
> +			   int *nr_present)
> +{
> +	if (unlikely(is_mmio_spte(*sptep))) {
> +		if (gfn != get_mmio_spte_gfn(*sptep)) {
> +			mmu_spte_clear_no_track(sptep);
> +			return true;
> +		}
> +
> +		(*nr_present)++;

Can increase nr_present in the caller.

> @@ -6481,6 +6506,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  	if (!kvm->arch.n_requested_mmu_pages)
>  		nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
>  
> +	/*
> +	 * If the new memory slot is created, we need to clear all
> +	 * mmio sptes.
> +	 */
> +	if (npages && old.base_gfn != mem->guest_phys_addr >> PAGE_SHIFT)
> +		kvm_arch_flush_shadow(kvm);
> +

This should be in __kvm_set_memory_region.

