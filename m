Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab0GMBUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:20:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56556 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab0GMBUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:20:51 -0400
Message-ID: <4C3BBE84.30708@cn.fujitsu.com>
Date: Tue, 13 Jul 2010 09:16:52 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] KVM: MMU: introduce pte_prefetch_topup_memory_cache()
References: <4C330918.6040709@cn.fujitsu.com> <4C330A37.8080709@cn.fujitsu.com> <4C39C1AB.6000606@redhat.com> <4C3A8694.1000401@cn.fujitsu.com> <4C3B09FD.3060307@redhat.com>
In-Reply-To: <4C3B09FD.3060307@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 07/12/2010 06:05 AM, Xiao Guangrong wrote:
>>
>> Avi Kivity wrote:
>>   
>>> On 07/06/2010 01:49 PM, Xiao Guangrong wrote:
>>>     
>>>> Introduce this function to topup prefetch cache
>>>>
>>>>
>>>>
>>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>>> index 3dcd55d..cda4587 100644
>>>> --- a/arch/x86/kvm/mmu.c
>>>> +++ b/arch/x86/kvm/mmu.c
>>>> @@ -89,6 +89,8 @@ module_param(oos_shadow, bool, 0644);
>>>>        }
>>>>    #endif
>>>>
>>>> +#define PTE_PREFETCH_NUM        16
>>>>
>>>>        
>>> Let's make it 8 to start with...  It's frightening enough.
>>>
>>> (8 = one cache line in both guest and host)
>>>      
>> Umm, before post this patchset, i have done the draft performance test
>> for
>> different prefetch distance, and it shows 16 is the best distance that
>> we can
>> get highest performance.
>>    
> 
> What's the different between 8 and 16?
> 
> I'm worried that there are workloads that don't benefit from prefetch,
> and we may regress there.  So I'd like to limit it, at least at first.
> 

OK

> btw, what about dirty logging? will prefetch cause pages to be marked
> dirty?
> 
> We may need to instantiate prefetched pages with spte.d=0 and examine it
> when tearing down the spte.
> 

Yeah, all speculative path are broken dirty bit tracking, and i guess it's
need more review, so i plan to do it in the separate patch, i'll post it after
this patchset merged, could you allow it?

>>>> +static int pte_prefetch_topup_memory_cache(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +    return __mmu_topup_memory_cache(&vcpu->arch.mmu_rmap_desc_cache,
>>>> +                    rmap_desc_cache, PTE_PREFETCH_NUM,
>>>> +                    PTE_PREFETCH_NUM, GFP_ATOMIC);
>>>> +}
>>>> +
>>>>
>>>>        
>>> Just make the ordinary topup sufficient for prefetch.  If we allocate
>>> too much, we don't lose anything, the memory remains for the next time
>>> around.
>>>
>>>      
>> Umm, but at the worst case, we should allocate 40 items for rmap, it's
>> heavy
>> for GFP_ATOMIC allocation and holding mmu_lock.
>>
>>    
> 
> Why use GFP_ATOMIC at all?  Make mmu_topup_memory_caches() always assume
> we'll be prefetching.
> 
> Why 40?  I think all we need is PTE_PREFETCH_NUM rmap entries.
> 

Oh, i see your mean now, i'll increase rmap entries in mmu_topup_memory_caches()


