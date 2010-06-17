Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab0FQIHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:07:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711Ab0FQIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:07:17 -0400
Message-ID: <4C19D7B1.6060908@redhat.com>
Date: Thu, 17 Jun 2010 11:07:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM: MMU: prefetch ptes when intercepted guest #PF
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E7F4.5060801@cn.fujitsu.com> <4C16E82E.5010306@cn.fujitsu.com> <4C16E9A8.10409@cn.fujitsu.com> <4C1766D6.3040000@redhat.com> <4C19CDCC.4060404@cn.fujitsu.com>
In-Reply-To: <4C19CDCC.4060404@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 10:25 AM, Xiao Guangrong wrote:
>
>
>> Can this in fact work for level != PT_PAGE_TABLE_LEVEL?  We might start
>> at PT_PAGE_DIRECTORY_LEVEL but get 4k pages while iterating.
>>      
> Ah, i forgot it. We can't assume that the host also support huge page for
> next gfn, as Marcelo's suggestion, we should "only map with level>  1 if
> the host page matches the size".
>
> Um, the problem is, when we get host page size, we should hold 'mm->mmap_sem',
> it can't used in atomic context and it's also a slow path, we hope pte prefetch
> path is fast.
>
> How about only allow prefetch for sp.leve = 1 now? i'll improve it in the future,
> i think it need more time :-)
>    

I don't think prefetch for level > 1 is worthwhile.  One fault per 2MB 
is already very good, no need to optimize it further.

>>> +
>>> +        pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
>>> +        if (is_error_pfn(pfn)) {
>>> +            kvm_release_pfn_clean(pfn);
>>> +            break;
>>> +        }
>>> +        if (pte_prefetch_topup_memory_cache(vcpu))
>>> +            break;
>>> +
>>> +        mmu_set_spte(vcpu, spte, ACC_ALL, ACC_ALL, 0, 0, 1, NULL,
>>> +                 sp->role.level, gfn, pfn, true, false);
>>> +    }
>>> +}
>>>
>>>        
>> Nice.  Direct prefetch should usually succeed.
>>
>> Can later augment to call get_users_pages_fast(..., PTE_PREFETCH_NUM,
>> ...) to reduce gup overhead.
>>      
> But we can't assume the gfn's hva is consecutive, for example, gfn and gfn+1
> maybe in the different slots.
>    

Right.  We could limit it to one slot then for simplicity.

>    
>>> +
>>> +        if (!table) {
>>> +            page = gfn_to_page_atomic(vcpu->kvm, sp->gfn);
>>> +            if (is_error_page(page)) {
>>> +                kvm_release_page_clean(page);
>>> +                break;
>>> +            }
>>> +            table = kmap_atomic(page, KM_USER0);
>>> +            table = (pt_element_t *)((char *)table + offset);
>>> +        }
>>>
>>>        
>> Why not kvm_read_guest_atomic()?  Can do it outside the loop.
>>      
> Do you mean that read all prefetched sptes at one time?
>    

Yes.

> If prefetch one spte fail, the later sptes that we read is waste, so i
> choose read next spte only when current spte is prefetched successful.
>
> But i not have strong opinion on it since it's fast to read all sptes at
> one time, at the worst case, only 16 * 8 = 128 bytes we need to read.
>    

In general batching is worthwhile, the cost of the extra bytes is low 
compared to the cost of bringing in the cacheline and error checking.

btw, you could align the prefetch to 16 pte boundary.  That would 
improve performance for memory that is scanned backwards.

So we can change the fault path to always fault 16 ptes, aligned on 16 
pte boundary, with the needed pte called with specualtive=false.
>> I think lot of code can be shared with the pte prefetch in invlpg.
>>
>>      
> Yes, please allow me to cleanup those code after my future patchset:
>
> [PATCH v4 9/9] KVM MMU: optimize sync/update unsync-page
>
> it's the last part in the 'allow multiple shadow pages' patchset.
>    

Sure.

-- 
error compiling committee.c: too many arguments to function

