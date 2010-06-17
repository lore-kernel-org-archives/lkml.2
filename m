Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab0FQIh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584Ab0FQIhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:37:24 -0400
Message-ID: <4C19DEC0.9020906@redhat.com>
Date: Thu, 17 Jun 2010 11:37:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC][PATCH 9/9] make kvm mmu shrinker more aggressive
References: <20100615135518.BC244431@kernel.beaverton.ibm.com>	 <20100615135530.4565745D@kernel.beaverton.ibm.com>	 <4C189830.2070300@redhat.com> <1276701911.6437.16973.camel@nimitz>
In-Reply-To: <1276701911.6437.16973.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 06:25 PM, Dave Hansen wrote:
>
>>> If mmu_shrink() has already done a significant amount of
>>> scanning, the use of 'nr_to_scan' inside shrink_kvm_mmu()
>>> will also ensure that we do not over-reclaim when we have
>>> already done a lot of work in this call.
>>>
>>> In the end, this patch defines a "scan" as:
>>> 1. An attempt to acquire a refcount on a 'struct kvm'
>>> 2. freeing a kvm mmu page
>>>
>>> This would probably be most ideal if we can expose some
>>> of the work done by kvm_mmu_remove_some_alloc_mmu_pages()
>>> as also counting as scanning, but I think we have churned
>>> enough for the moment.
>>>        
>> It usually removes one page.
>>      
> Does it always just go right now and free it, or is there any real
> scanning that has to go on?
>    

It picks a page from the tail of the LRU and frees it.  There is very 
little attempt to keep the LRU in LRU order, though.

We do need a scanner that looks at spte accessed bits if this isn't 
going to result in performance losses.

>>> diff -puN arch/x86/kvm/mmu.c~make-shrinker-more-aggressive arch/x86/kvm/mmu.c
>>> --- linux-2.6.git/arch/x86/kvm/mmu.c~make-shrinker-more-aggressive	2010-06-14 11:30:44.000000000 -0700
>>> +++ linux-2.6.git-dave/arch/x86/kvm/mmu.c	2010-06-14 11:38:04.000000000 -0700
>>> @@ -2935,8 +2935,10 @@ static int shrink_kvm_mmu(struct kvm *kv
>>>
>>>    	idx = srcu_read_lock(&kvm->srcu);
>>>    	spin_lock(&kvm->mmu_lock);
>>> -	if (kvm->arch.n_used_mmu_pages>   0)
>>> -		freed_pages = kvm_mmu_remove_some_alloc_mmu_pages(kvm);
>>> +	while (nr_to_scan>   0&&   kvm->arch.n_used_mmu_pages>   0) {
>>> +		freed_pages += kvm_mmu_remove_some_alloc_mmu_pages(kvm);
>>> +		nr_to_scan--;
>>> +	}
>>>
>>>        
>> What tree are you patching?
>>      
> These applied to Linus's latest as of yesterday.
>    

Please patch against kvm.git master (or next, which is usually a few 
unregression-tested patches ahead).  This code has changed.

-- 
error compiling committee.c: too many arguments to function

