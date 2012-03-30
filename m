Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2C3JTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:19:08 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:53213 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2C3JS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:18:59 -0400
Message-ID: <4F757A7C.6020109@linux.vnet.ibm.com>
Date: Fri, 30 Mar 2012 17:18:52 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F7436FB.9000004@redhat.com> <4F744A43.4060600@linux.vnet.ibm.com> <4F745C4F.4060404@redhat.com>
In-Reply-To: <4F745C4F.4060404@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032923-1396-0000-0000-000000E4C8C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 08:57 PM, Avi Kivity wrote:

> On 03/29/2012 01:40 PM, Xiao Guangrong wrote:
>>>> * Implementation
>>>> We can freely walk the page between walk_shadow_page_lockless_begin and
>>>> walk_shadow_page_lockless_end, it can ensure all the shadow page is valid.
>>>>
>>>> In the most case, cmpxchg is fair enough to change the access bit of spte,
>>>> but the write-protect path on softmmu/nested mmu is a especial case: it is
>>>> a read-check-modify path: read spte, check W bit, then clear W bit.
>>>
>>> We also set gpte.D and gpte.A, no? How do you handle that?
>>>
>>
>>
>> We still need walk gust page table before fast page fault to check
>> whether the access is valid.
> 
> Ok.  But that's outside the mmu lock.
> 
> We can also skip that: if !sp->unsync, copy access rights and gpte.A/D
> into spare bits in the spte, and use that to check.
> 


Great!

gpte.A need not be copied into spte since EFEC.P = 1 means the shadow page
table is present, gpte.A must be set in this case.

And, we do not need to cache gpte access rights into spte, instead of it,
we can atomicly read gpte to get these information (anyway, we need read gpte
to get the gfn.)

I will do it in the next version.

>>
>>>>  In order
>>>> to avoid marking spte writable after/during page write-protect, we do the
>>>> trick like below:
>>>>
>>>>       fast page fault path:
>>>>             lock RCU
>>>>             set identification in the spte
>>>
>>> What if you can't (already taken)?  Spin?  Slow path?
>>
>>
>> In this patch, it allows to concurrently access on the same spte:
>> it freely set its identification on the spte, because i did not
>> want to introduce other atomic operations.
>>
>> You remind me that there may be a risk: if many vcpu fault on the
>> same spte, it will retry the spte forever. Hmm, how about fix it
>> like this:
>>
>> if ( spte.identification = 0) {
>> 	set spte.identification = vcpu.id
>> 	goto cmpxchg-path
>> }
>>
>> if (spte.identification == vcpu.id)
>> 	goto cmpxchg-path
>>
>> return to guest and retry the address again;
>>
>> cmpxchg-path:
>> 	do checks and cmpxchg
>>
>> It can ensure the spte can be updated.
> 
> What's the difference between this and
> 
> 
>   if test_and_set_bit(spte.lock)
>        return_to_guest
>   else
>        do checks and cmpxchg
> 
> ?
> 


test_and_set_bit is a atomic operation that is i want to avoid.

>>
>>>> The identification should be unique to avoid the below race:
>>>>
>>>>      VCPU 0                VCPU 1            VCPU 2
>>>>       lock RCU
>>>>    spte + identification
>>>>    check conditions
>>>>                        do write-protect, clear
>>>>                           identification
>>>>                                               lock RCU
>>>>                                         set identification
>>>>      cmpxchg + w - identification
>>>>         OOPS!!!
>>>
>>> Is it not sufficient to use just two bits?
>>>
>>> pf_lock - taken by page fault path
>>> wp_lock - taken by write protect path
>>>
>>> pf cmpxchg checks both bits.
>>>
>>
>>
>> If we just use two byte as identification, it has to use atomic
>> operations to maintain these bits? or i misunderstood?
> 
> Ah, you're using byte writes to set the identification? remember I
> didn't read the patches yet.
> 


Yes.

> Please check the optimization manual, I remember there are warnings
> there about using different sized accesses for the same location,
> particularly when locked ops are involved.


"using different sized accesses for the same location" is OK i guess,
anyway, we can have the data struct of this style:

union {
	struct	{
		char byte1,
		char byte2,
		char byte3,
		char byte4
      	} foo;

	int bar;
}

Access .bar and .foo.byte1 is allowed.

And for the LOCK operation, i find these descriptions in the manual:

"Locked operations are atomic with respect to all other memory operations and all
externally visible events"

And there is a warning:
Software should access semaphores (shared memory used for signalling between
multiple processors) using identical addresses and operand lengths. For example, if
one processor accesses a semaphore using a word access, other processors should
not access the semaphore using a byte access.

It is the warning you remember?

In our case, we do not treat it as "semaphores": the "byte writes" does not
need be atomic.

> Maybe bitops are cheaper. 
> If the cost is similar, they're at least more similar to the rest of the
> kernel.
> 


The "bitops" you mentioned is the atomic-style bitops? It is cheaper that
byte writes?

