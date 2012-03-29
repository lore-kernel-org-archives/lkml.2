Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036Ab2C2LlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:41:05 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52016 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174Ab2C2Lk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:40:56 -0400
Message-ID: <4F744A43.4060600@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 19:40:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F7436FB.9000004@redhat.com>
In-Reply-To: <4F7436FB.9000004@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032901-1618-0000-0000-0000012EAD7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 06:18 PM, Avi Kivity wrote:

> On 03/29/2012 11:20 AM, Xiao Guangrong wrote:
>> * Idea
>> The present bit of page fault error code (EFEC.P) indicates whether the
>> page table is populated on all levels, if this bit is set, we can know
>> the page fault is caused by the page-protection bits (e.g. W/R bit) or
>> the reserved bits.
>>
>> In KVM, in most cases, all this kind of page fault (EFEC.P = 1) can be
>> simply fixed: the page fault caused by reserved bit
>> (EFFC.P = 1 && EFEC.RSV = 1) has already been filtered out in fast mmio
>> path. What we need do to fix the rest page fault (EFEC.P = 1 && RSV != 1)
>> is just increasing the corresponding access on the spte.
>>
>> This pachset introduces a fast path to fix this kind of page fault: it
>> is out of mmu-lock and need not walk host page table to get the mapping
>> from gfn to pfn.
> 
> Wow!
> 
> Looks like interesting times are back in mmu-land.
> 


:)

> Comments below are before review of actual patches, so maybe they're
> already answered there, or maybe they're just nonsense.
> 


Your comments are always appreciated!

>> * Implementation
>> We can freely walk the page between walk_shadow_page_lockless_begin and
>> walk_shadow_page_lockless_end, it can ensure all the shadow page is valid.
>>
>> In the most case, cmpxchg is fair enough to change the access bit of spte,
>> but the write-protect path on softmmu/nested mmu is a especial case: it is
>> a read-check-modify path: read spte, check W bit, then clear W bit.
> 
> We also set gpte.D and gpte.A, no? How do you handle that?
> 


We still need walk gust page table before fast page fault to check
whether the access is valid.

>>  In order
>> to avoid marking spte writable after/during page write-protect, we do the
>> trick like below:
>>
>>       fast page fault path:
>>             lock RCU
>>             set identification in the spte
> 
> What if you can't (already taken)?  Spin?  Slow path?


In this patch, it allows to concurrently access on the same spte:
it freely set its identification on the spte, because i did not
want to introduce other atomic operations.

You remind me that there may be a risk: if many vcpu fault on the
same spte, it will retry the spte forever. Hmm, how about fix it
like this:

if ( spte.identification = 0) {
	set spte.identification = vcpu.id
	goto cmpxchg-path
}

if (spte.identification == vcpu.id)
	goto cmpxchg-path

return to guest and retry the address again;

cmpxchg-path:
	do checks and cmpxchg

It can ensure the spte can be updated.

>> The identification should be unique to avoid the below race:
>>
>>      VCPU 0                VCPU 1            VCPU 2
>>       lock RCU
>>    spte + identification
>>    check conditions
>>                        do write-protect, clear
>>                           identification
>>                                               lock RCU
>>                                         set identification
>>      cmpxchg + w - identification
>>         OOPS!!!
> 
> Is it not sufficient to use just two bits?
> 
> pf_lock - taken by page fault path
> wp_lock - taken by write protect path
> 
> pf cmpxchg checks both bits.
> 


If we just use two byte as identification, it has to use atomic
operations to maintain these bits? or i misunderstood?

>> - For ept:
>> $ x11perfcomp baseline-hard optimaze-hard
>> 1: baseline-hard
>> 2: optimaze-hard
>>
>>      1         2    Operation
>> --------  --------  ---------
>>   7060.0    7150.0  Composite 500x500 from pixmap to window
>>
>> - For shadow mmu:
>> $ x11perfcomp baseline-soft optimaze-soft
>> 1: baseline-soft
>> 2: optimaze-soft
>>
>>      1         2    Operation
>> --------  --------  ---------
>>   6980.0    7490.0  Composite 500x500 from pixmap to window
>>
>> ( It is interesting that after this patch, the performance of x11perf on
>>   softmmu is better than it on hardmmu, i have tested it for many times,
>>   it is really true. :) )
> 
> It could be because you cannot use THP with dirty logging, so you pay
> the overhead of TDP.
> 


Yes, i think so.

>> Any comments are welcome. :)
>>
> 
> Very impressive.  Now to review the patches (will take me some time).
> 


Thank you, Avi!

