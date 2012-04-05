Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2DEV5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:57:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39365 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab2DEV5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:57:11 -0400
Message-ID: <4F7E1531.5020307@gmail.com>
Date: Fri, 06 Apr 2012 05:57:05 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F7436FB.9000004@redhat.com> <4F744A43.4060600@linux.vnet.ibm.com> <4F745C4F.4060404@redhat.com> <4F757A7C.6020109@linux.vnet.ibm.com> <4F7850EA.3080203@redhat.com>
In-Reply-To: <4F7850EA.3080203@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 08:58 PM, Avi Kivity wrote:

> On 03/30/2012 12:18 PM, Xiao Guangrong wrote:
>> On 03/29/2012 08:57 PM, Avi Kivity wrote:
>>
>>> On 03/29/2012 01:40 PM, Xiao Guangrong wrote:
>>>>>> * Implementation
>>>>>> We can freely walk the page between walk_shadow_page_lockless_begin and
>>>>>> walk_shadow_page_lockless_end, it can ensure all the shadow page is valid.
>>>>>>
>>>>>> In the most case, cmpxchg is fair enough to change the access bit of spte,
>>>>>> but the write-protect path on softmmu/nested mmu is a especial case: it is
>>>>>> a read-check-modify path: read spte, check W bit, then clear W bit.
>>>>>
>>>>> We also set gpte.D and gpte.A, no? How do you handle that?
>>>>>
>>>>
>>>>
>>>> We still need walk gust page table before fast page fault to check
>>>> whether the access is valid.
>>>
>>> Ok.  But that's outside the mmu lock.
>>>
>>> We can also skip that: if !sp->unsync, copy access rights and gpte.A/D
>>> into spare bits in the spte, and use that to check.
>>>
>>
>>
>> Great!
>>
>> gpte.A need not be copied into spte since EFEC.P = 1 means the shadow page
>> table is present, gpte.A must be set in this case.
>>
>> And, we do not need to cache gpte access rights into spte, instead of it,
>> we can atomicly read gpte to get these information (anyway, we need read gpte
>> to get the gfn.)
> 
> Why do we need the gfn?  If !sp->unsync then it is unchanged (it's also
> in sp->gfns).
> 
> Oh, needed for mark_page_dirty().
> 
> Caching gpte access in the spte will save decoding the access buts and
> sp->role.access.
> 


Yes, we can directly get the gfn from sp->gfns (it is also safe for usync sp
i think), but we want to have a quickly check (check if gfn can be writable)
before shadow page table waking.

I mentioned it in the previous reply, see:
http://thread.gmane.org/gmane.comp.emulators.kvm.devel/88934

What is your comment?

>>
>> I will do it in the next version.
>>
>>>>
>>>>>>  In order
>>>>>> to avoid marking spte writable after/during page write-protect, we do the
>>>>>> trick like below:
>>>>>>
>>>>>>       fast page fault path:
>>>>>>             lock RCU
>>>>>>             set identification in the spte
>>>>>
>>>>> What if you can't (already taken)?  Spin?  Slow path?
>>>>
>>>>
>>>> In this patch, it allows to concurrently access on the same spte:
>>>> it freely set its identification on the spte, because i did not
>>>> want to introduce other atomic operations.
>>>>
>>>> You remind me that there may be a risk: if many vcpu fault on the
>>>> same spte, it will retry the spte forever. Hmm, how about fix it
>>>> like this:
>>>>
>>>> if ( spte.identification = 0) {
>>>> 	set spte.identification = vcpu.id
>>>> 	goto cmpxchg-path
>>>> }
>>>>
>>>> if (spte.identification == vcpu.id)
>>>> 	goto cmpxchg-path
>>>>
>>>> return to guest and retry the address again;
>>>>
>>>> cmpxchg-path:
>>>> 	do checks and cmpxchg
>>>>
>>>> It can ensure the spte can be updated.
>>>
>>> What's the difference between this and
>>>
>>>
>>>   if test_and_set_bit(spte.lock)
>>>        return_to_guest
>>>   else
>>>        do checks and cmpxchg
>>>
>>> ?
>>>
>>
>>
>> test_and_set_bit is a atomic operation that is i want to avoid.
> 
> Right.  Can you check what the effect is (with say
> test_and_set_bit(spte, 0) in the same path).
> 
> I'm not convinced it's significant.
> 


Okay, if you prefer to test_and_set_bit, we may introduce two bits:
fast_pf and write_protect, do things like this:

on fast page fault path:

	old_spte = *spte

	if (test_and_set_bit(spte.fast_pf))
		return_to_guest

	old_spte |= fast_pf

	if (old_spte.wp)
		clear-fast-pf bit and return_to_guest

	if (!rmap.PTE_LIST_WRITE_PROTECT)
		cmpxchg(spte, old_spte, old_spte +w - fast_pf)
	else
		clear-fast-pf bit

on page write-protect path:
	lock mmu-lock
	set rmap.PTE_LIST_WRITE_PROTECT
        smp_mb()
        if (spte.w || spte.fast_pf)
                spte -w -fast_pf + write_protect

        unlock mmu-lock

I think it works but can not make page fault fast for unsync sp (
e.g: two sptes point to the gfn, a page fault on one of the spte
make gfn's sp become unsync.), it is not too bad since we can cache
access bits in spte and properly make all sptes become writable on
mmu_need_write_protect path in a new patchset.

>>
>>>>
>>>>>> The identification should be unique to avoid the below race:
>>>>>>
>>>>>>      VCPU 0                VCPU 1            VCPU 2
>>>>>>       lock RCU
>>>>>>    spte + identification
>>>>>>    check conditions
>>>>>>                        do write-protect, clear
>>>>>>                           identification
>>>>>>                                               lock RCU
>>>>>>                                         set identification
>>>>>>      cmpxchg + w - identification
>>>>>>         OOPS!!!
>>>>>
>>>>> Is it not sufficient to use just two bits?
>>>>>
>>>>> pf_lock - taken by page fault path
>>>>> wp_lock - taken by write protect path
>>>>>
>>>>> pf cmpxchg checks both bits.
>>>>>
>>>>
>>>>
>>>> If we just use two byte as identification, it has to use atomic
>>>> operations to maintain these bits? or i misunderstood?
>>>
>>> Ah, you're using byte writes to set the identification? remember I
>>> didn't read the patches yet.
>>>
>>
>>
>> Yes.
>>
>>> Please check the optimization manual, I remember there are warnings
>>> there about using different sized accesses for the same location,
>>> particularly when locked ops are involved.
>>
>>
>> "using different sized accesses for the same location" is OK i guess,
>> anyway, we can have the data struct of this style:
>>
>> union {
>> 	struct	{
>> 		char byte1,
>> 		char byte2,
>> 		char byte3,
>> 		char byte4
>>       	} foo;
>>
>> 	int bar;
>> }
>>
>> Access .bar and .foo.byte1 is allowed.
>>
>> And for the LOCK operation, i find these descriptions in the manual:
>>
>> "Locked operations are atomic with respect to all other memory operations and all
>> externally visible events"
>>
>> And there is a warning:
>> Software should access semaphores (shared memory used for signalling between
>> multiple processors) using identical addresses and operand lengths. For example, if
>> one processor accesses a semaphore using a word access, other processors should
>> not access the semaphore using a byte access.
>>
>> It is the warning you remember?
> 
> No, it should be safe, but performance is degraded if you mix loads and
> stores of different sizes to the same location.
> 
> See for example "2.1.5.2 L1 DCache", Store Forwarding section in the
> optimization guide.
> 


Oh, got it, it is a new knowledge point for me.

> 
>>
>> In our case, we do not treat it as "semaphores": the "byte writes" does not
>> need be atomic.
>>
>>> Maybe bitops are cheaper. 
>>> If the cost is similar, they're at least more similar to the rest of the
>>> kernel.
>>>
>>
>>
>> The "bitops" you mentioned is the atomic-style bitops? It is cheaper that
>> byte writes?
> 
> They're not cheaper in general but may be compared to mixing byte writes
> and word loads.
> 


Maybe you are right.


