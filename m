Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab2EXIZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab2EXIZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:25:33 -0400
Message-ID: <4FBDF079.4080601@redhat.com>
Date: Thu, 24 May 2012 11:25:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] KVM: MMU: fast path of handling guest page fault
References: <4FBCA4FB.8050501@linux.vnet.ibm.com> <4FBCA60F.5040701@linux.vnet.ibm.com> <4FBCCB38.9080302@redhat.com> <4FBDD48B.7020109@linux.vnet.ibm.com>
In-Reply-To: <4FBDD48B.7020109@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 09:26 AM, Xiao Guangrong wrote:
> On 05/23/2012 07:34 PM, Avi Kivity wrote:
> 
> 
>>>  static bool spte_has_volatile_bits(u64 spte)
>>>  {
>>> +	/*
>>> +	 * Always atomicly update spte if it can be updated
>>> +	 * out of mmu-lock.
>>> +	 */
>>> +	if (spte_can_lockless_update(spte))
>>> +		return true;
>> 
>> 
>> This is a really subtle point, but is it really needed?
>> 
>> Lockless spte updates should always set the dirty and accessed bits, so
>> we won't be overwriting any volatile bits there.
>> 
> 
> 
> Avi,
> 
> Currently, The spte update/clear paths in mmu-lock think the "Dirty bit" is
> not volatile if the spte is readonly. Then the "Dirty bit" caused by
> lockless update can be lost.
> 

Maybe it's better to change that.  In fact, changing

	if ((spte & shadow_accessed_mask) &&
	      (!is_writable_pte(spte) || (spte & shadow_dirty_mask)))
		return false;

to

	if (~spte & (shadow_accessed_mask | shadow_dirty_mask))
		return false;

is almost the same thing - we miss the case where the page is COW or
shadowed though.

If we release the page as dirty, as below, perhaps the whole thing
doesn't matter; the mm must drop spte.w (or spte.d) before it needs to
access spte.d again.


> And, for tlb flush:
> 
> |        * If we overwrite a writable spte with a read-only one we
> |        * should flush remote TLBs. Otherwise rmap_write_protect
> |        * will find a read-only spte, even though the writable spte
> |        * might be cached on a CPU's TLB.
> |        */
> |       if (is_writable_pte(entry) && !is_writable_pte(*sptep))
> |                kvm_flush_remote_tlbs(vcpu->kvm);
> 
> Atomically update spte can help us to get a stable is_writable_pte().

Why is it unstable? mmu_set_spte() before cleared SPTE_MMU_WRITEABLE, so
the lockless path will keep its hands off *spte.

> 
> 
>>> +
>>>  	if (!shadow_accessed_mask)
>>>  		return false;
>>>
>>> @@ -498,13 +517,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>>>  		return ret;
>>>  	}
>>>
>>> -	new_spte |= old_spte & shadow_dirty_mask;
>>> -
>>> -	mask = shadow_accessed_mask;
>>> -	if (is_writable_pte(old_spte))
>>> -		mask |= shadow_dirty_mask;
>>> -
>>> -	if (!spte_has_volatile_bits(old_spte) || (new_spte & mask) == mask)
>>> +	if (!spte_has_volatile_bits(old_spte))
>>>  		__update_clear_spte_fast(sptep, new_spte);
>>>  	else
>>>  		old_spte = __update_clear_spte_slow(sptep, new_spte);
>> 
>> 
>> It looks like the old code is bad.. why can we ignore volatile bits in
>> the old spte?  Suppose pfn is changing?
>> 
> 
> 
> /* Rules for using mmu_spte_update:
>  * Update the state bits, it means the mapped pfn is not changged.
> 
> If pfn is changed, we should clear spte first, then set the spte to
> the new pfn, in kvm_set_pte_rmapp(), we have:
> 
> | mmu_spte_clear_track_bits(sptep);
> | mmu_spte_set(sptep, new_spte);

Okay, thanks.

-- 
error compiling committee.c: too many arguments to function
