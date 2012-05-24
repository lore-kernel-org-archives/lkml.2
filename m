Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2EXJET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:04:19 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:44482 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab2EXJER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:04:17 -0400
Message-ID: <4FBDF97D.1080704@linux.vnet.ibm.com>
Date: Thu, 24 May 2012 17:03:57 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] KVM: MMU: fast path of handling guest page fault
References: <4FBCA4FB.8050501@linux.vnet.ibm.com> <4FBCA60F.5040701@linux.vnet.ibm.com> <4FBCCB38.9080302@redhat.com> <4FBDD48B.7020109@linux.vnet.ibm.com> <4FBDF079.4080601@redhat.com>
In-Reply-To: <4FBDF079.4080601@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052322-1396-0000-0000-000001490C5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 04:25 PM, Avi Kivity wrote:

> On 05/24/2012 09:26 AM, Xiao Guangrong wrote:
>> On 05/23/2012 07:34 PM, Avi Kivity wrote:
>>
>>
>>>>  static bool spte_has_volatile_bits(u64 spte)
>>>>  {
>>>> +	/*
>>>> +	 * Always atomicly update spte if it can be updated
>>>> +	 * out of mmu-lock.
>>>> +	 */
>>>> +	if (spte_can_lockless_update(spte))
>>>> +		return true;
>>>
>>>
>>> This is a really subtle point, but is it really needed?
>>>
>>> Lockless spte updates should always set the dirty and accessed bits, so
>>> we won't be overwriting any volatile bits there.
>>>
>>
>>
>> Avi,
>>
>> Currently, The spte update/clear paths in mmu-lock think the "Dirty bit" is
>> not volatile if the spte is readonly. Then the "Dirty bit" caused by
>> lockless update can be lost.
>>
> 
> Maybe it's better to change that.  In fact, changing
> 
> 	if ((spte & shadow_accessed_mask) &&
> 	      (!is_writable_pte(spte) || (spte & shadow_dirty_mask)))
> 		return false;
> 
> to
> 
> 	if (~spte & (shadow_accessed_mask | shadow_dirty_mask))
> 		return false;
> 


Okay, i like this way.

> is almost the same thing - we miss the case where the page is COW or
> shadowed though.
> 
> If we release the page as dirty, as below, perhaps the whole thing
> doesn't matter; the mm must drop spte.w (or spte.d) before it needs to
> access spte.d again.
> 
> 
>> And, for tlb flush:
>>
>> |        * If we overwrite a writable spte with a read-only one we
>> |        * should flush remote TLBs. Otherwise rmap_write_protect
>> |        * will find a read-only spte, even though the writable spte
>> |        * might be cached on a CPU's TLB.
>> |        */
>> |       if (is_writable_pte(entry) && !is_writable_pte(*sptep))
>> |                kvm_flush_remote_tlbs(vcpu->kvm);
>>
>> Atomically update spte can help us to get a stable is_writable_pte().
> 
> Why is it unstable? mmu_set_spte() before cleared SPTE_MMU_WRITEABLE, so
> the lockless path will keep its hands off *spte.
> 


Since dirty-log path does not clear SPTE_MMU_WRITEABLE bit, so in the
system, we have this kind of spte which is readonly but SPTE_MMU_WRITEABLE
is set.

In mmu_set_spte(), we may read a read-only spte (which indicates the TLb need
not be flushed), but it can be marked writeable by fast page fault, then the
TLB is dirty.

If you do not like the way in this patch, we can change it to:

       if (spte_can_be_wriable(entry) && !is_writable_pte(*sptep))
                kvm_flush_remote_tlbs(vcpu->kvm);

And actually, this kind of TLB flush can be delay until page table protection
happen, we can simply mask tlb dirty after your patchset of "flush tlb out
of mmu lock"


