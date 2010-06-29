Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0F2JHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:07:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60083 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab0F2JHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:07:47 -0400
Message-ID: <4C29B700.8040502@cn.fujitsu.com>
Date: Tue, 29 Jun 2010 17:04:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BAD.6000609@cn.fujitsu.com> <4C287081.40300@redhat.com> <4C287332.5080803@cn.fujitsu.com> <4C2883D3.2050606@redhat.com> <4C2949A5.1070303@cn.fujitsu.com> <4C299B7E.5020303@redhat.com> <4C29A25C.7040900@cn.fujitsu.com> <4C29B390.80602@redhat.com>
In-Reply-To: <4C29B390.80602@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 06/29/2010 10:35 AM, Xiao Guangrong wrote:
>>
>>> We have now
>>>
>>>          if (is_shadow_present_pte(*sptep)&&  !is_large_pte(*sptep))
>>>              continue;
>>>
>>> So we need to add a check, if sp->role.access doesn't match pt_access&
>>> pte_access, we need to get a new sp with the correct access (can only
>>> change read->write).
>>>
>>>      
>> Umm, we should update the spte at the gw->level, so we need get the child
>> sp, and compare its access at this point, just like this:
>>
>> if (level == gw->level&&  is_shadow_present_pte(*sptep)) {
>>     child_sp = page_header(__pa(*sptep&  PT64_BASE_ADDR_MASK));
>>
>>     if (child_sp->access != pt_access&  pte_access&  (diry ? 1 :
>> ~ACC_WRITE_MASK )) {
>>         /* Zap sptep */
>>         ......
>>     }
>>        
>> }
>>
>> So, why not use the new spte flag (SPTE_NO_DIRTY in my patch) to mark
>> this spte then we can see
>> this spte whether need updated directly? i think it more simpler ;-)
>>    
> 
> It's new state, and new state means more maintenance of that state and
> the need to consider the state in all relevant code paths.
> 
> In terms of maintainability, changing walk_addr() is best, since it
> maintains the tight invariant that PT_PAGE_DIRECTORY_LEVEL sptes are
> always consistent with their sptes.  Updating fetch() to allow for a
> relaxed invariant (spte may be read-only while gpte is write-dirty) is
> more complicated, but performs better.  This is also consistent with
> what we do with PT_PAGE_TABLE_LEVEL gptes/sptes and with unsync pages.
> 

Maybe you are right, i just think is more quickly by using SPTE_NO_DIRTY flag
to judge whether need updated. I'll modify this patch as your suggestion.

> btw, how can the patch work?
> 
>>
>> +        if (level == gw->level&&  !dirty&&
>> +              access&  gw->pte_access&  ACC_WRITE_MASK)
>> +            spte |= SPTE_NO_DIRTY;
>> +
>>           spte = __pa(sp->spt)
>>               | PT_PRESENT_MASK | PT_ACCESSED_MASK
>>               | PT_WRITABLE_MASK | PT_USER_MASK;
>>    
> 
> spte is immediately overwritten by the following assignment.
> 

Ah, sorry, i miss it, spte |= SPTE_NO_DIRTY should behind of following assignment.

> However, the other half of the patch can be adapted:
> 
>>
>> +        if (*sptep&  SPTE_NO_DIRTY) {
>> +            struct kvm_mmu_page *child;
>> +
>> +            WARN_ON(level !=  gw->level);
>> +            WARN_ON(!is_shadow_present_pte(*sptep));
>> +            if (dirty) {
>> +                child = page_header(*sptep&
>> +                              PT64_BASE_ADDR_MASK);
>> +                mmu_page_remove_parent_pte(child, sptep);
>> +                __set_spte(sptep, shadow_trap_nonpresent_pte);
>> +                kvm_flush_remote_tlbs(vcpu->kvm);
>> +            }
>> +        }
>> +
>>           if (is_shadow_present_pte(*sptep)&&  !is_large_pte(*sptep))
>>               continue;
>>    
> 
> Simply replace (*spte & SPTE_NO_DIRTY) with a condition that checks
> whether sp->access is consistent with gw->pt(e)_access.
> 

If the guest mapping is writable and it !dirty, we mark SPTE_NO_DIRTY flag in
the spte, when the next #PF occurs, we just need check this flag and see whether
gpte's D bit is set, if it's true, we zap this spte and map to the correct sp.

> Can you write a test case for qemu-kvm.git/kvm/test that demonstrates
> the problem and the fix?  It will help ensure we don't regress in this
> area.
> 

OK, but allow me do it later :-)

