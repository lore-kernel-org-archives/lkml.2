Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2LNDlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 22:41:08 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:52886 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2LNDlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 22:41:06 -0500
Message-ID: <50CA9FA8.90109@linux.vnet.ibm.com>
Date: Fri, 14 Dec 2012 11:40:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: x86: improve reexecute_instruction
References: <50C5A747.1020105@linux.vnet.ibm.com> <50C5A807.4070301@linux.vnet.ibm.com> <20121212010951.GB2898@amt.cnet> <50C8DB11.5050204@linux.vnet.ibm.com> <20121213230204.GC11385@amt.cnet>
In-Reply-To: <20121213230204.GC11385@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121403-1618-0000-0000-0000030621BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 07:02 AM, Marcelo Tosatti wrote:

>>> Same comment as before: the only case where it should not attempt to 
>>> emulate is when there is a condition which makes it impossible to fix
>>> (the information is available to detect that condition).
>>>
>>> The earlier suggestion
>>>
>>> 	"How about recording the gfn number for shadow pages that have been
>>> shadowed in the current pagefault run?"
>>>
>>> Was about that.
>>
>> I think we can have a try. Is this change good to you, Marcelo?
>>
>> [eric@localhost kvm]$ git diff
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 01d7c2a..e3d0001 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -4359,24 +4359,34 @@ unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
>>         return nr_mmu_pages;
>>  }
>>
>> -int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
>> +void kvm_mmu_get_sp_hierarchy(struct kvm_vcpu *vcpu, u64 addr,
>> +                             struct kvm_mmu_sp_hierarchy *hierarchy)
>>  {
>>         struct kvm_shadow_walk_iterator iterator;
>>         u64 spte;
>> -       int nr_sptes = 0;
>> +
>> +       hierarchy->max_level = hierarchy->nr_levels = 0;
>>
>>         walk_shadow_page_lockless_begin(vcpu);
>>         for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
>> -               sptes[iterator.level-1] = spte;
>> -               nr_sptes++;
>> +               struct kvm_mmu_page *sp =  page_header(__pa(iterator.sptep));
>> +
>> +               if (hierarchy->indirect_only && sp->role.direct)
>> +                       break;
>> +
>> +               if (!hierarchy->max_level)
>> +                       hierarchy->max_level = iterator.level;
>> +
>> +               hierarchy->shadow_gfns[iterator.level-1] = sp->gfn;
>> +               hierarchy->sptes[iterator.level-1] = spte;
>> +               hierarchy->nr_levels++;
>> +
>>                 if (!is_shadow_present_pte(spte))
>>                         break;
>>         }
>>         walk_shadow_page_lockless_end(vcpu);
>> -
>> -       return nr_sptes;
>>  }
> 
> Record gfns while shadowing in the vcpu struct, in a struct, along with cr2.
> Then validate 
> That way its guaranteed its not some other vcpu.

Okay, i will try this way. :)


