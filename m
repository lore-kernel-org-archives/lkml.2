Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2E1OF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:05:59 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:60881 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab2E1OF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:05:57 -0400
Message-ID: <4FC3863F.5020902@linux.vnet.ibm.com>
Date: Mon, 28 May 2012 22:05:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] KVM: MMU: fix huge page adapted on non-PAE host
References: <4FC316E3.6080607@linux.vnet.ibm.com> <4FC35A15.6080000@redhat.com> <4FC363EE.6060204@linux.vnet.ibm.com> <4FC36E85.4010909@redhat.com> <4FC37600.1060301@linux.vnet.ibm.com> <4FC37A18.10809@redhat.com> <4FC38084.40409@linux.vnet.ibm.com> <4FC38362.6010802@redhat.com>
In-Reply-To: <4FC38362.6010802@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052803-0260-0000-0000-0000013DE42C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 09:53 PM, Avi Kivity wrote:

> On 05/28/2012 04:41 PM, Xiao Guangrong wrote:
>> On 05/28/2012 09:14 PM, Avi Kivity wrote:
>>
>>> On 05/28/2012 03:56 PM, Xiao Guangrong wrote:
>>>> On 05/28/2012 08:24 PM, Avi Kivity wrote:
>>>>
>>>>> On 05/28/2012 02:39 PM, Xiao Guangrong wrote:
>>>>>> On 05/28/2012 06:57 PM, Avi Kivity wrote:
>>>>>>
>>>>>>> On 05/28/2012 09:10 AM, Xiao Guangrong wrote:
>>>>>>>> The huge page size is 4M on non-PAE host, but 2M page size is used in
>>>>>>>> transparent_hugepage_adjust(), so the page we get after adjust the
>>>>>>>> mapping level is not the head page, the BUG_ON() will be triggered
>>>>>>>>
>>>>>>>>
>>>>>>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>>>>>>> index 72102e0..be3cea4 100644
>>>>>>>> --- a/arch/x86/kvm/mmu.c
>>>>>>>> +++ b/arch/x86/kvm/mmu.c
>>>>>>>> @@ -2595,8 +2595,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>>>>>>>>  			*gfnp = gfn;
>>>>>>>>  			kvm_release_pfn_clean(pfn);
>>>>>>>>  			pfn &= ~mask;
>>>>>>>> -			if (!get_page_unless_zero(pfn_to_page(pfn)))
>>>>>>>> -				BUG();
>>>>>>>> +			kvm_get_pfn(pfn);
>>>>>>>>  			*pfnp = pfn;
>>>>>>>>  		}
>>>>>>>>  	}
>>>>>>>
>>>>>>> Shouldn't we adjust mask instead?
>>>>>>>
>>>>>>
>>>>>>
>>>>>> Adjusting mask to map the whole 4M huge page to KVM guest?
>>>>>
>>>>> The code moves the refcount from the small page to the huge page.  i.e.
>>>>> from pfn 0x1312 to pfn 0x1200.  But if the huge page frame contains
>>>>> 0x400 pages, it should move the refcount to pfn 0x1000.
>>>>>
>>>>
>>>>
>>>> We need not move the refcount to the huge page (the head of pages), moving
>>>> the refcount to the any middle small page is also ok, get_page() will
>>>> properly handle it:
>>>>
>>>> get_page() -> __get_page_tail():
>>>>
>>>> |	struct page *page_head = compound_trans_head(page);
>>>> |
>>>> |	if (likely(page != page_head && get_page_unless_zero(page_head))) {
>>>> |		/*
>>>> |		 * page_head wasn't a dangling pointer but it
>>>> |		 * may not be a head page anymore by the time
>>>> |		 * we obtain the lock. That is ok as long as it
>>>> |		 * can't be freed from under us.
>>>> |		 */
>>>> |		flags = compound_lock_irqsave(page_head);
>>>> |		/* here __split_huge_page_refcount won't run anymore */
>>>> |		if (likely(PageTail(page))) {
>>>> |			__get_page_tail_foll(page, false);
>>>> |			got = true;
>>>> |		}
>>>> |		compound_unlock_irqrestore(page_head, flags);
>>>> |		if (unlikely(!got))
>>>> |			put_page(page_head);
>>>> |	}
>>>>
>>>> The refcount of page_head is increased.
>>>>
>>>
>>> So, the whole thing is unneeded?  Andrea?
>>>
>>
>>
>> I think the reason we move refcount in current code is, we should increase the
>> refcount of the page we will mapped into shadow page table, since we always
>> decrease its refcount after it is mapped. (That is this patch does.)
>>
> 
> 
> As far as I can tell __get_user_pages_fast() will take the reference
> count in the page head in the first place.


IIUC, the refcount used in the Compound Page is like this:

get_user_pages / get_page(page):
	head_page = page->first_page;
	if (page is not the head page)
		page->__mapcount++
	head_page->_count++

	
put_page(page):
	head_page = page->first_page;
	if (page is not the head page)
		page->__mapcount--
	head_page->_count--

