Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0EaCRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 22:17:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60094 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab0EaCRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 22:17:14 -0400
Message-ID: <4C031B5D.3000502@cn.fujitsu.com>
Date: Mon, 31 May 2010 10:13:49 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: split the operations of kvm_mmu_zap_page()
References: <4C025BDC.1020304@cn.fujitsu.com> <4C025C24.9010200@cn.fujitsu.com> <4C026543.20608@redhat.com>
In-Reply-To: <4C026543.20608@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 05/30/2010 03:37 PM, Xiao Guangrong wrote:
>> Using kvm_mmu_prepare_zap_page() and kvm_mmu_commit_zap_page() to
>> split kvm_mmu_zap_page() function, then we can:
>>
>> - traverse hlist safely
>> - easily to gather remote tlb flush which occurs during page zapped
>>
>>
>> +static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct
>> kvm_mmu_page *sp)
>> +{
>> +    int ret;
>> +
>> +    trace_kvm_mmu_zap_page(sp);
>> +    ++kvm->stat.mmu_shadow_zapped;
>> +    ret = mmu_zap_unsync_children(kvm, sp);
>> +    kvm_mmu_page_unlink_children(kvm, sp);
>> +    kvm_mmu_unlink_parents(kvm, sp);
>> +    if (!sp->role.invalid&&  !sp->role.direct)
>> +        unaccount_shadowed(kvm, sp->gfn);
>> +    if (sp->unsync)
>> +        kvm_unlink_unsync_page(kvm, sp);
>> +    if (!sp->root_count)
>> +        /* Count self */
>> +        ret++;
>> +    else
>> +        kvm_reload_remote_mmus(kvm);
>> +
>> +    sp->role.invalid = 1;
>> +    list_move(&sp->link,&kvm->arch.invalid_mmu_pages);
>> +    kvm_mmu_reset_last_pte_updated(kvm);
>> +    return ret;
>> +}
>> +
>> +static void kvm_mmu_commit_zap_page(struct kvm *kvm)
>> +{
>> +    struct kvm_mmu_page *sp, *n;
>> +
>> +    if (list_empty(&kvm->arch.invalid_mmu_pages))
>> +        return;
>> +
>> +    kvm_flush_remote_tlbs(kvm);
>> +    list_for_each_entry_safe(sp, n,&kvm->arch.invalid_mmu_pages, link) {
>> +        WARN_ON(!sp->role.invalid);
>> +        if (!sp->root_count)
>> +            kvm_mmu_free_page(kvm, sp);
>> +    }
>> +}
>> +
>>    
> 
> You're adding two new functions but not using them here?  Possibly in
> the old kvm_mmu_zap_page()?

I use those in the next patch, it's not in kvm_mmu_zap_page(), it's used like:

hold mmu spin lock

kvm_mmu_prepare_zap_page page A
kvm_mmu_prepare_zap_page page B
kvm_mmu_prepare_zap_page page C
......
kvm_mmu_commit_zap_page

release mmu spin lock

> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 5e5cd8d..225c3c4 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5331,6 +5331,7 @@ struct  kvm *kvm_arch_create_vm(void)
>>       }
>>
>>       INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>> +    INIT_LIST_HEAD(&kvm->arch.invalid_mmu_pages);
>>       INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
>>    
> 
> This is a good idea, but belongs in a separate patch?  We can use it to
> reclaim invalid pages before allocating new ones.
> 

This patch is very simple and kvm_mmu_commit_zap_page() function should depend on
kvm->arch.invalid_mmu_pages, so i think we on need separate this patch, your opinion? :-)

Thanks,
Xiao

