Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab2EWLes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:34:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933471Ab2EWLep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:34:45 -0400
Message-ID: <4FBCCB38.9080302@redhat.com>
Date: Wed, 23 May 2012 14:34:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] KVM: MMU: fast path of handling guest page fault
References: <4FBCA4FB.8050501@linux.vnet.ibm.com> <4FBCA60F.5040701@linux.vnet.ibm.com>
In-Reply-To: <4FBCA60F.5040701@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 11:55 AM, Xiao Guangrong wrote:
> If the the present bit of page fault error code is set, it indicates
> the shadow page is populated on all levels, it means what we do is
> only modify the access bit which can be done out of mmu-lock
> 
> Currently, in order to simplify the code, we only fix the page fault
> caused by write-protect on the fast path
> 
> +
>  static bool spte_has_volatile_bits(u64 spte)
>  {
> +	/*
> +	 * Always atomicly update spte if it can be updated
> +	 * out of mmu-lock.
> +	 */
> +	if (spte_can_lockless_update(spte))
> +		return true;


This is a really subtle point, but is it really needed?

Lockless spte updates should always set the dirty and accessed bits, so
we won't be overwriting any volatile bits there.

> +
>  	if (!shadow_accessed_mask)
>  		return false;
> 
> @@ -498,13 +517,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>  		return ret;
>  	}
> 
> -	new_spte |= old_spte & shadow_dirty_mask;
> -
> -	mask = shadow_accessed_mask;
> -	if (is_writable_pte(old_spte))
> -		mask |= shadow_dirty_mask;
> -
> -	if (!spte_has_volatile_bits(old_spte) || (new_spte & mask) == mask)
> +	if (!spte_has_volatile_bits(old_spte))
>  		__update_clear_spte_fast(sptep, new_spte);
>  	else
>  		old_spte = __update_clear_spte_slow(sptep, new_spte);


It looks like the old code is bad.. why can we ignore volatile bits in
the old spte?  Suppose pfn is changing?

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
> +	 * change spte and the mapping from gfn to pfn.
> +	 *
> +	 * What we do is call gfn_to_pfn_atomic to bind the gfn and the
> +	 * pfn because after the call:
> +	 * - we have held the refcount of pfn that means the pfn can not
> +	 *   be freed and be reused for another gfn.
> +	 * - the pfn is writable that means it can not be shared by different
> +	 *   gfn.
> +	 */
> +	pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
> +
> +	/* The host page is swapped out or merged. */
> +	if (mmu_invalid_pfn(pfn))
> +		goto exit;
> +
> +	ret = true;
> +
> +	if (pfn != spte_to_pfn(spte))
> +		goto exit;
> +
> +	if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
> +		mark_page_dirty(vcpu->kvm, gfn);

Isn't it better to kvm_release_pfn_dirty() here?

> +
> +exit:
> +	kvm_release_pfn_clean(pfn);
> +	return ret;
> +}
> +
> +> +
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
> +

No need to pass gfn here.


> +	walk_shadow_page_lockless_begin(vcpu);
> +	for_each_shadow_entry_lockless(vcpu, gva, iterator, spte)
> +		if (!is_shadow_present_pte(spte) || iterator.level < level)
> +			break;
> +
> +	/*
> +	 * If the mapping has been changed, let the vcpu fault on the
> +	 * same address again.
> +	 */
> +	if (!is_rmap_spte(spte)) {
> +		ret = true;
> +		goto exit;
> +	}
> +
> +	if (!is_last_spte(spte, level))
> +		goto exit;
> +
> +	/*
> +	 * Check if it is a spurious fault caused by TLB lazily flushed.
> +	 *
> +	 * Need not check the access of upper level table entries since
> +	 * they are always ACC_ALL.
> +	 */
> +	 if (is_writable_pte(spte)) {
> +		ret = true;
> +		goto exit;
> +	}
> +
> +	/*
> +	 * Currently, to simplify the code, only the spte write-protected
> +	 * by dirty-log can be fast fixed.
> +	 */
> +	if (!spte_can_be_writable(spte))
> +		goto exit;
> +
> +	sp = page_header(__pa(iterator.sptep));
> +
> +	if (sp->role.direct)
> +		ret = fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte);
> +	else
> +		ret = fast_pf_fix_indirect_spte(vcpu, sp, iterator.sptep,
> +						spte, gfn);
> +
> +exit:
> +	walk_shadow_page_lockless_end(vcpu);
> +
> +	return ret;
> +}
> +


-- 
error compiling committee.c: too many arguments to function
