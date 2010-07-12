Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab0GLDJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 23:09:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61985 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab0GLDJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 23:09:54 -0400
Message-ID: <4C3A8694.1000401@cn.fujitsu.com>
Date: Mon, 12 Jul 2010 11:05:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] KVM: MMU: introduce pte_prefetch_topup_memory_cache()
References: <4C330918.6040709@cn.fujitsu.com> <4C330A37.8080709@cn.fujitsu.com> <4C39C1AB.6000606@redhat.com>
In-Reply-To: <4C39C1AB.6000606@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 07/06/2010 01:49 PM, Xiao Guangrong wrote:
>> Introduce this function to topup prefetch cache
>>
>>
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 3dcd55d..cda4587 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -89,6 +89,8 @@ module_param(oos_shadow, bool, 0644);
>>       }
>>   #endif
>>
>> +#define PTE_PREFETCH_NUM        16
>>    
> 
> Let's make it 8 to start with...  It's frightening enough.
> 
> (8 = one cache line in both guest and host)

Umm, before post this patchset, i have done the draft performance test for
different prefetch distance, and it shows 16 is the best distance that we can
get highest performance.

> 
>> @@ -316,15 +318,16 @@ static void update_spte(u64 *sptep, u64 new_spte)
>>       }
>>   }
>>
>> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>> -                  struct kmem_cache *base_cache, int min)
>> +static int __mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>> +                    struct kmem_cache *base_cache, int min,
>> +                    int max, gfp_t flags)
>>   {
>>       void *obj;
>>
>>       if (cache->nobjs>= min)
>>           return 0;
>> -    while (cache->nobjs<  ARRAY_SIZE(cache->objects)) {
>> -        obj = kmem_cache_zalloc(base_cache, GFP_KERNEL);
>> +    while (cache->nobjs<  max) {
>> +        obj = kmem_cache_zalloc(base_cache, flags);
>>           if (!obj)
>>               return -ENOMEM;
>>           cache->objects[cache->nobjs++] = obj;
>> @@ -332,6 +335,20 @@ static int mmu_topup_memory_cache(struct
>> kvm_mmu_memory_cache *cache,
>>       return 0;
>>   }
>>
>> +static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
>> +                  struct kmem_cache *base_cache, int min)
>> +{
>> +    return __mmu_topup_memory_cache(cache, base_cache, min,
>> +                      ARRAY_SIZE(cache->objects), GFP_KERNEL);
>> +}
>> +
>> +static int pte_prefetch_topup_memory_cache(struct kvm_vcpu *vcpu)
>> +{
>> +    return __mmu_topup_memory_cache(&vcpu->arch.mmu_rmap_desc_cache,
>> +                    rmap_desc_cache, PTE_PREFETCH_NUM,
>> +                    PTE_PREFETCH_NUM, GFP_ATOMIC);
>> +}
>> +
>>    
> 
> Just make the ordinary topup sufficient for prefetch.  If we allocate
> too much, we don't lose anything, the memory remains for the next time
> around.
> 

Umm, but at the worst case, we should allocate 40 items for rmap, it's heavy
for GFP_ATOMIC allocation and holding mmu_lock.



