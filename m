Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab2CaNND (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 09:13:03 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52640 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab2CaNNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 09:13:00 -0400
Message-ID: <4F7702CB.4050704@linux.vnet.ibm.com>
Date: Sat, 31 Mar 2012 21:12:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F7436FB.9000004@redhat.com> <4F744A43.4060600@linux.vnet.ibm.com> <4F745C4F.4060404@redhat.com> <4F757A7C.6020109@linux.vnet.ibm.com>
In-Reply-To: <4F757A7C.6020109@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12033113-2674-0000-0000-000003E60273
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 05:18 PM, Xiao Guangrong wrote:

> On 03/29/2012 08:57 PM, Avi Kivity wrote:
> 
>> On 03/29/2012 01:40 PM, Xiao Guangrong wrote:
>>>>> * Implementation
>>>>> We can freely walk the page between walk_shadow_page_lockless_begin and
>>>>> walk_shadow_page_lockless_end, it can ensure all the shadow page is valid.
>>>>>
>>>>> In the most case, cmpxchg is fair enough to change the access bit of spte,
>>>>> but the write-protect path on softmmu/nested mmu is a especial case: it is
>>>>> a read-check-modify path: read spte, check W bit, then clear W bit.
>>>>
>>>> We also set gpte.D and gpte.A, no? How do you handle that?
>>>>
>>>
>>>
>>> We still need walk gust page table before fast page fault to check
>>> whether the access is valid.
>>
>> Ok.  But that's outside the mmu lock.
>>
>> We can also skip that: if !sp->unsync, copy access rights and gpte.A/D
>> into spare bits in the spte, and use that to check.
>>
> 
> 
> Great!
> 
> gpte.A need not be copied into spte since EFEC.P = 1 means the shadow page
> table is present, gpte.A must be set in this case.
> 
> And, we do not need to cache gpte access rights into spte, instead of it,
> we can atomicly read gpte to get these information (anyway, we need read gpte
> to get the gfn.)
> 


It needs more thinking, we can excellent improvement for dirty page logged in
this idea, but i am not sure we can gain the performance in the below case:

- the page fault is trigged by the invalid access from guest
  in the origin way, it is fixed on the FNAME(walk_addr) path which walk guest page
  table, we way need call gfn_to_pfn (it is fast since the page is always not
  swap out). After the idea, it is fixed on fast page fault path which walk shadow
  page table with RCU locked, the preemption is disabled.

  They are not too different i think.

- the page fault is caused by host, but we can not quickly check the page writable
  since gfn is unknown, then after shadow page walking we get the gfn (read gpte),
  what will we do if gfn is write-protect?

  - if the page is write-protected by the host (!spte.SPTE_HOST_WRITEABLE), we have
    no choice, just call gfn_to_pfn and waiting the page cowed.

    Comparing with the origin way, the time costed on shadow page table walking is
    wasted, unfortunately, it is triggered really frequently if KSM is enabled. It
    may be a regression.

  - if the write-protect is caused by page table protected, we have two choice:
    - call slow page fault path. It is unacceptable, since the number of this kind
      of page fault is very large. We may wast many CPU time.

    - hold mmu-lock and fix it in the last spte. It is OK but makes thing little
      complex, i am not sure if you agree with this. :)




