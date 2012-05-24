Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab2EXGbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:31:51 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50297 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2EXGbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:31:48 -0400
Message-ID: <4FBDD48B.7020109@linux.vnet.ibm.com>
Date: Thu, 24 May 2012 14:26:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] KVM: MMU: fast path of handling guest page fault
References: <4FBCA4FB.8050501@linux.vnet.ibm.com> <4FBCA60F.5040701@linux.vnet.ibm.com> <4FBCCB38.9080302@redhat.com>
In-Reply-To: <4FBCCB38.9080302@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052406-4790-0000-0000-000002EB57F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 07:34 PM, Avi Kivity wrote:


>>  static bool spte_has_volatile_bits(u64 spte)
>>  {
>> +	/*
>> +	 * Always atomicly update spte if it can be updated
>> +	 * out of mmu-lock.
>> +	 */
>> +	if (spte_can_lockless_update(spte))
>> +		return true;
> 
> 
> This is a really subtle point, but is it really needed?
> 
> Lockless spte updates should always set the dirty and accessed bits, so
> we won't be overwriting any volatile bits there.
> 


Avi,

Currently, The spte update/clear paths in mmu-lock think the "Dirty bit" is
not volatile if the spte is readonly. Then the "Dirty bit" caused by
lockless update can be lost.

And, for tlb flush:

|        * If we overwrite a writable spte with a read-only one we
|        * should flush remote TLBs. Otherwise rmap_write_protect
|        * will find a read-only spte, even though the writable spte
|        * might be cached on a CPU's TLB.
|        */
|       if (is_writable_pte(entry) && !is_writable_pte(*sptep))
|                kvm_flush_remote_tlbs(vcpu->kvm);

Atomically update spte can help us to get a stable is_writable_pte().


>> +
>>  	if (!shadow_accessed_mask)
>>  		return false;
>>
>> @@ -498,13 +517,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>>  		return ret;
>>  	}
>>
>> -	new_spte |= old_spte & shadow_dirty_mask;
>> -
>> -	mask = shadow_accessed_mask;
>> -	if (is_writable_pte(old_spte))
>> -		mask |= shadow_dirty_mask;
>> -
>> -	if (!spte_has_volatile_bits(old_spte) || (new_spte & mask) == mask)
>> +	if (!spte_has_volatile_bits(old_spte))
>>  		__update_clear_spte_fast(sptep, new_spte);
>>  	else
>>  		old_spte = __update_clear_spte_slow(sptep, new_spte);
> 
> 
> It looks like the old code is bad.. why can we ignore volatile bits in
> the old spte?  Suppose pfn is changing?
> 


/* Rules for using mmu_spte_update:
 * Update the state bits, it means the mapped pfn is not changged.

If pfn is changed, we should clear spte first, then set the spte to
the new pfn, in kvm_set_pte_rmapp(), we have:

| mmu_spte_clear_track_bits(sptep);
| mmu_spte_set(sptep, new_spte);

>> +
>> +static bool
>> +fast_pf_fix_indirect_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>> +			  u64 *sptep, u64 spte, gfn_t gfn)
>> +{
>> +	pfn_t pfn;
>> +	bool ret = false;
>> +
>> +	/*
>> +	 * For the indirect spte, it is hard to get a stable gfn since
>> +	 * we just use a cmpxchg to avoid all the races which is not
>> +	 * enough to avoid the ABA problem: the host can arbitrarily
>> +	 * change spte and the mapping from gfn to pfn.
>> +	 *
>> +	 * What we do is call gfn_to_pfn_atomic to bind the gfn and the
>> +	 * pfn because after the call:
>> +	 * - we have held the refcount of pfn that means the pfn can not
>> +	 *   be freed and be reused for another gfn.
>> +	 * - the pfn is writable that means it can not be shared by different
>> +	 *   gfn.
>> +	 */
>> +	pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
>> +
>> +	/* The host page is swapped out or merged. */
>> +	if (mmu_invalid_pfn(pfn))
>> +		goto exit;
>> +
>> +	ret = true;
>> +
>> +	if (pfn != spte_to_pfn(spte))
>> +		goto exit;
>> +
>> +	if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
>> +		mark_page_dirty(vcpu->kvm, gfn);
> 
> Isn't it better to kvm_release_pfn_dirty() here?
> 


Right, kvm_release_pfn_dirty is better.

>> +
>> +exit:
>> +	kvm_release_pfn_clean(pfn);
>> +	return ret;
>> +}
>> +
>> +> +
>> +/*
>> + * Return value:
>> + * - true: let the vcpu to access on the same address again.
>> + * - false: let the real page fault path to fix it.
>> + */
>> +static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
>> +			    int level, u32 error_code)
>> +{
>> +	struct kvm_shadow_walk_iterator iterator;
>> +	struct kvm_mmu_page *sp;
>> +	bool ret = false;
>> +	u64 spte = 0ull;
>> +
>> +	if (!page_fault_can_be_fast(vcpu, gfn, error_code))
>> +		return false;
>> +
> 
> No need to pass gfn here.


Right, will fix it.

