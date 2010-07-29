Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0G2CQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 22:16:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50472 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab0G2CQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 22:16:15 -0400
Message-ID: <4C50E545.5050000@cn.fujitsu.com>
Date: Thu, 29 Jul 2010 10:19:49 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 5/6] kvm, x86: use ro page and don't copy shared page
References: <4C3FC033.3000605@cn.fujitsu.com> <20100716071936.GE17894@redhat.com> <20100716232612.GB8946@amt.cnet>
In-Reply-To: <20100716232612.GB8946@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2010 07:26 AM, Marcelo Tosatti wrote:
> On Fri, Jul 16, 2010 at 10:19:36AM +0300, Gleb Natapov wrote:
>> On Fri, Jul 16, 2010 at 10:13:07AM +0800, Lai Jiangshan wrote:
>>> When page fault, we always call get_user_pages(write=1).
>>>
>>> Actually, we don't need to do this when it is not write fault.
>>> get_user_pages(write=1) will cause shared page(ksm) copied.
>>> If this page is not modified in future, this copying and the copied page
>>> are just wasted. Ksm may scan and merge them and may cause thrash.
>>>
>> But is page is written into afterwords we will get another page fault.
>>
>>> In this patch, if the page is RO for host VMM and it not write fault for guest,
>>> we will use RO page, otherwise we use a writable page.
>>>
>> Currently pages allocated for guest memory are required to be RW, so after your series
>> behaviour will remain exactly the same as before.
> 
> Except KSM pages.
> 
>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>> ---
>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>> index 8ba9b0d..6382140 100644
>>> --- a/arch/x86/kvm/mmu.c
>>> +++ b/arch/x86/kvm/mmu.c
>>> @@ -1832,6 +1832,45 @@ static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
>>>  	}
>>>  }
>>>  
>>> +/* get a current mapped page fast, and test whether the page is writable. */
>>> +static struct page *get_user_page_and_protection(unsigned long addr,
>>> +	int *writable)
>>> +{
>>> +	struct page *page[1];
>>> +
>>> +	if (__get_user_pages_fast(addr, 1, 1, page) == 1) {
>>> +		*writable = 1;
>>> +		return page[0];
>>> +	}
>>> +	if (__get_user_pages_fast(addr, 1, 0, page) == 1) {
>>> +		*writable = 0;
>>> +		return page[0];
>>> +	}
>>> +	return NULL;
>>> +}
>>> +
>>> +static pfn_t kvm_get_pfn_for_page_fault(struct kvm *kvm, gfn_t gfn,
>>> +		int write_fault, int *host_writable)
>>> +{
>>> +	unsigned long addr;
>>> +	struct page *page;
>>> +
>>> +	if (!write_fault) {
>>> +		addr = gfn_to_hva(kvm, gfn);
>>> +		if (kvm_is_error_hva(addr)) {
>>> +			get_page(bad_page);
>>> +			return page_to_pfn(bad_page);
>>> +		}
>>> +
>>> +		page = get_user_page_and_protection(addr, host_writable);
>>> +		if (page)
>>> +			return page_to_pfn(page);
>>> +	}
>>> +
>>> +	*host_writable = 1;
>>> +	return kvm_get_pfn_for_gfn(kvm, gfn);
>>> +}
>>> +
>> kvm_get_pfn_for_gfn() returns fault_page if page is mapped RO, so caller
>> of kvm_get_pfn_for_page_fault() and kvm_get_pfn_for_gfn() will get
>> different results when called on the same page. Not good.
>> kvm_get_pfn_for_page_fault() logic should be folded into
>> kvm_get_pfn_for_gfn().
> 
> Agreed. Please keep gfn_to_pfn related code in virt/kvm/kvm_main.c.
> 
> 

Pass write_fault parameter to kvm_get_pfn_for_gfn()?
But only X86 use this parameter currently, I think it is OK to
keep these code in arch/x86/kvm/mmu.c
