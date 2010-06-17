Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0FQH2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 03:28:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60866 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab0FQH2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:28:36 -0400
Message-ID: <4C19CDCC.4060404@cn.fujitsu.com>
Date: Thu, 17 Jun 2010 15:25:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM: MMU: prefetch ptes when intercepted guest #PF
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E7F4.5060801@cn.fujitsu.com> <4C16E82E.5010306@cn.fujitsu.com> <4C16E9A8.10409@cn.fujitsu.com> <4C1766D6.3040000@redhat.com>
In-Reply-To: <4C1766D6.3040000@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>> +        if (*spte != shadow_trap_nonpresent_pte)
>> +            continue;
>> +
>> +        gfn = sp->gfn + (i<<  ((sp->role.level - 1) * PT64_LEVEL_BITS));
>>    
> 

Avi,

Thanks for your comment.

> Can calculate outside the loop and use +=.
> 

It's nice, will do it in the next version.

> Can this in fact work for level != PT_PAGE_TABLE_LEVEL?  We might start
> at PT_PAGE_DIRECTORY_LEVEL but get 4k pages while iterating.

Ah, i forgot it. We can't assume that the host also support huge page for
next gfn, as Marcelo's suggestion, we should "only map with level > 1 if
the host page matches the size".

Um, the problem is, when we get host page size, we should hold 'mm->mmap_sem',
it can't used in atomic context and it's also a slow path, we hope pte prefetch
path is fast.

How about only allow prefetch for sp.leve = 1 now? i'll improve it in the future,
i think it need more time :-)

> 
>> +
>> +        pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
>> +        if (is_error_pfn(pfn)) {
>> +            kvm_release_pfn_clean(pfn);
>> +            break;
>> +        }
>> +        if (pte_prefetch_topup_memory_cache(vcpu))
>> +            break;
>> +
>> +        mmu_set_spte(vcpu, spte, ACC_ALL, ACC_ALL, 0, 0, 1, NULL,
>> +                 sp->role.level, gfn, pfn, true, false);
>> +    }
>> +}
>>    
> 
> Nice.  Direct prefetch should usually succeed.
> 
> Can later augment to call get_users_pages_fast(..., PTE_PREFETCH_NUM,
> ...) to reduce gup overhead.

But we can't assume the gfn's hva is consecutive, for example, gfn and gfn+1
maybe in the different slots.

> 
>>
>> +static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, u64 *sptep)
>> +{
>> +    struct kvm_mmu_page *sp;
>> +    pt_element_t *table = NULL;
>> +    int offset = 0, shift, index, i;
>> +
>> +    sp = page_header(__pa(sptep));
>> +    index = sptep - sp->spt;
>> +
>> +    if (PTTYPE == 32) {
>> +        shift = PAGE_SHIFT - (PT_LEVEL_BITS -
>> +                    PT64_LEVEL_BITS) * sp->role.level;
>> +        offset = sp->role.quadrant<<  shift;
>> +    }
>> +
>> +    for (i = index + 1; i<  min(PT64_ENT_PER_PAGE,
>> +                      index + PTE_PREFETCH_NUM); i++) {
>> +        struct page *page;
>> +        pt_element_t gpte;
>> +        unsigned pte_access;
>> +        u64 *spte = sp->spt + i;
>> +        gfn_t gfn;
>> +        pfn_t pfn;
>> +        int dirty;
>> +
>> +        if (*spte != shadow_trap_nonpresent_pte)
>> +            continue;
>> +
>> +        pte_access = sp->role.access;
>> +        if (sp->role.direct) {
>> +            dirty = 1;
>> +            gfn = sp->gfn + (i<<  ((sp->role.level - 1) *
>> +                          PT64_LEVEL_BITS));
>> +            goto gfn_mapping;
>> +        }
>>    
> 
> Should just call direct_pte_prefetch.
> 

OK, will fix it.

>> +
>> +        if (!table) {
>> +            page = gfn_to_page_atomic(vcpu->kvm, sp->gfn);
>> +            if (is_error_page(page)) {
>> +                kvm_release_page_clean(page);
>> +                break;
>> +            }
>> +            table = kmap_atomic(page, KM_USER0);
>> +            table = (pt_element_t *)((char *)table + offset);
>> +        }
>>    
> 
> Why not kvm_read_guest_atomic()?  Can do it outside the loop.

Do you mean that read all prefetched sptes at one time?
If prefetch one spte fail, the later sptes that we read is waste, so i
choose read next spte only when current spte is prefetched successful.

But i not have strong opinion on it since it's fast to read all sptes at
one time, at the worst case, only 16 * 8 = 128 bytes we need to read.

> 
>> +
>> +        gpte = table[i];
>> +        if (!(gpte&  PT_ACCESSED_MASK))
>> +            continue;
>> +
>> +        if (!is_present_gpte(gpte)) {
>> +            if (!sp->unsync)
>> +                *spte = shadow_notrap_nonpresent_pte;
>>    
> 
> Need __set_spte().

Oops, fix it.

> 
>> +            continue;
>> +        }
>> +        dirty = is_dirty_gpte(gpte);
>> +        gfn = (gpte&  PT64_BASE_ADDR_MASK)>>  PAGE_SHIFT;
>> +        pte_access = pte_access&  FNAME(gpte_access)(vcpu, gpte);
>> +gfn_mapping:
>> +        pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
>> +        if (is_error_pfn(pfn)) {
>> +            kvm_release_pfn_clean(pfn);
>> +            break;
>> +        }
>> +
>> +        if (pte_prefetch_topup_memory_cache(vcpu))
>> +            break;
>> +        mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
>> +                 dirty, NULL, sp->role.level, gfn, pfn,
>> +                 true, false);
>> +    }
>> +    if (table)
>> +        kunmap_atomic((char *)table - offset, KM_USER0);
>> +}
>>    
> 
> I think lot of code can be shared with the pte prefetch in invlpg.
> 

Yes, please allow me to cleanup those code after my future patchset:

[PATCH v4 9/9] KVM MMU: optimize sync/update unsync-page

it's the last part in the 'allow multiple shadow pages' patchset.
