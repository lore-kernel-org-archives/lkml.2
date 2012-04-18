Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab2DRBw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:52:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab2DRBwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:52:54 -0400
Date: Tue, 17 Apr 2012 22:47:57 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 14/16] KVM: MMU: fast path of handling guest page fault
Message-ID: <20120418014757.GA25133@amt.cnet>
References: <4F87FA69.5060106@linux.vnet.ibm.com>
 <4F87FD01.1010600@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F87FD01.1010600@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 06:16:33PM +0800, Xiao Guangrong wrote:
> If the the present bit of page fault error code is set, it indicates
> the shadow page is populated on all levels, it means what we do is
> only modify the access bit which can be done out of mmu-lock
> 
> Currently, in order to simplify the code, we only fix the page fault
> caused by write-protect on the fast path
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c         |  205 ++++++++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/paging_tmpl.h |    3 +
>  2 files changed, 192 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index efa5d59..fc91667 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -446,6 +446,13 @@ static bool __check_direct_spte_mmio_pf(u64 spte)
>  }
>  #endif
> 
> +static bool spte_wp_by_dirty_log(u64 spte)
> +{
> +	WARN_ON(is_writable_pte(spte));
> +
> +	return (spte & SPTE_ALLOW_WRITE) && !(spte & SPTE_WRITE_PROTECT);
> +}
> +
>  static bool spte_has_volatile_bits(u64 spte)
>  {
>  	if (!shadow_accessed_mask)
> @@ -454,9 +461,18 @@ static bool spte_has_volatile_bits(u64 spte)
>  	if (!is_shadow_present_pte(spte))
>  		return false;
> 
> -	if ((spte & shadow_accessed_mask) &&
> -	      (!is_writable_pte(spte) || (spte & shadow_dirty_mask)))
> -		return false;
> +	if (spte & shadow_accessed_mask) {
> +		if (is_writable_pte(spte))
> +			return !(spte & shadow_dirty_mask);
> +
> +		/*
> +		 * If the spte is write-protected by dirty-log, it may
> +		 * be marked writable on fast page fault path, then CPU
> +		 * can modify the Dirty bit.
> +		 */
> +		if (!spte_wp_by_dirty_log(spte))
> +			return false;
> +	}
> 
>  	return true;
>  }
> @@ -1109,26 +1125,18 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
>  		rmap_remove(kvm, sptep);
>  }
> 
> -static bool spte_wp_by_dirty_log(u64 spte)
> -{
> -	WARN_ON(is_writable_pte(spte));
> -
> -	return (spte & SPTE_ALLOW_WRITE) && !(spte & SPTE_WRITE_PROTECT);
> -}
> -
>  static void spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
>  			       bool *flush, bool page_table_protect)
>  {
>  	u64 spte = *sptep;
> 
>  	if (is_writable_pte(spte)) {
> -		*flush |= true;
> -
>  		if (large) {
>  			pgprintk("rmap_write_protect(large): spte %p %llx\n",
>  				 spte, *spte);
>  			BUG_ON(!is_large_pte(spte));
> 
> +			*flush |= true;
>  			drop_spte(kvm, sptep);
>  			--kvm->stat.lpages;
>  			return;
> @@ -1137,6 +1145,9 @@ static void spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
>  		goto reset_spte;
>  	}
> 
> +	/* We need flush tlbs in this case: the fast page fault path
> +	 * can mark the spte writable after we read the sptep.
> +	 */
>  	if (page_table_protect && spte_wp_by_dirty_log(spte))
>  		goto reset_spte;
> 
> @@ -1144,6 +1155,8 @@ static void spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
> 
>  reset_spte:
>  	rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
> +
> +	*flush |= true;
>  	spte = spte & ~PT_WRITABLE_MASK;
>  	if (page_table_protect)
>  		spte |= SPTE_WRITE_PROTECT;
> @@ -2767,18 +2780,172 @@ exit:
>  	return ret;
>  }
> 
> +static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, gfn_t gfn,
> +				   u32 error_code)
> +{
> +	unsigned long *rmap;
> +
> +	/*
> +	 * #PF can be fast only if the shadow page table is present and it
> +	 * is caused by write-protect, that means we just need change the
> +	 * W bit of the spte which can be done out of mmu-lock.
> +	 */
> +	if (!(error_code & PFERR_PRESENT_MASK) ||
> +	      !(error_code & PFERR_WRITE_MASK))
> +		return false;
> +
> +	rmap = gfn_to_rmap(vcpu->kvm, gfn, PT_PAGE_TABLE_LEVEL);
> +
> +	/* Quickly check the page can be writable. */
> +	if (test_bit(PTE_LIST_WP_BIT, ACCESS_ONCE(rmap)))
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool
> +fast_pf_fix_indirect_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> +			  u64 *sptep, u64 spte, gfn_t gfn)
> +{
> +	pfn_t pfn;
> +	bool ret = false;
> +
> +	/*
> +	 * For the indirect spte, it is hard to get a stable gfn since
> +	 * we just use a cmpxchg to avoid all the races which is not
> +	 * enough to avoid the ABA problem: the host can arbitrarily
> +	 * change spte and the mapping from gfn to pfh.
> +	 *
> +	 * What we do is call gfn_to_pfn_atomic to bind the gfn and the
> +	 * pfn because after the call:
> +	 * - we have held the refcount of pfn that means the pfn can not
> +	 *   be freed and be reused for another gfn.
> +	 * - the pfn is writable that means it can not be shared by different
> +	 *   gfn.
> +	 */
> +	pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);

Please document what can happen in parallel whenever you manipulate
sptes without mmu_lock held, convincing the reader that this is safe.

> +
> +/*
> + * Return value:
> + * - true: let the vcpu to access on the same address again.
> + * - false: let the real page fault path to fix it.
> + */
> +static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
> +			    int level, u32 error_code)
> +{
> +	struct kvm_shadow_walk_iterator iterator;
> +	struct kvm_mmu_page *sp;
> +	bool ret = false;
> +	u64 spte = 0ull;
> +
> +	if (!page_fault_can_be_fast(vcpu, gfn, error_code))
> +		return false;

What prevents kvm_mmu_commit_zap_page from nukeing the "shadow_page"
here, again? At this point the faulting spte could be zero (!present), 
and you have not yet increased reader_counter.

Same with current users of walk_shadow_page_lockless_begin.

I agree with Takuya, please reduce the size of the patchset to only to
what is strictly necessary, it appears many of the first patches are
not.

