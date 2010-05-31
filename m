Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab0EaLGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:06:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab0EaLGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:06:12 -0400
Message-ID: <4C039816.5090101@redhat.com>
Date: Mon, 31 May 2010 14:05:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: split the operations of kvm_mmu_zap_page()
References: <4C025BDC.1020304@cn.fujitsu.com> <4C025C24.9010200@cn.fujitsu.com> <4C026543.20608@redhat.com> <4C031B5D.3000502@cn.fujitsu.com>
In-Reply-To: <4C031B5D.3000502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 05:13 AM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>    
>> On 05/30/2010 03:37 PM, Xiao Guangrong wrote:
>>      
>>> Using kvm_mmu_prepare_zap_page() and kvm_mmu_commit_zap_page() to
>>> split kvm_mmu_zap_page() function, then we can:
>>>
>>> - traverse hlist safely
>>> - easily to gather remote tlb flush which occurs during page zapped
>>>
>>>
>>> +static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct
>>> kvm_mmu_page *sp)
>>> +{
>>> +    int ret;
>>> +
>>> +    trace_kvm_mmu_zap_page(sp);
>>> +    ++kvm->stat.mmu_shadow_zapped;
>>> +    ret = mmu_zap_unsync_children(kvm, sp);
>>> +    kvm_mmu_page_unlink_children(kvm, sp);
>>> +    kvm_mmu_unlink_parents(kvm, sp);
>>> +    if (!sp->role.invalid&&   !sp->role.direct)
>>> +        unaccount_shadowed(kvm, sp->gfn);
>>> +    if (sp->unsync)
>>> +        kvm_unlink_unsync_page(kvm, sp);
>>> +    if (!sp->root_count)
>>> +        /* Count self */
>>> +        ret++;
>>> +    else
>>> +        kvm_reload_remote_mmus(kvm);
>>> +
>>> +    sp->role.invalid = 1;
>>> +    list_move(&sp->link,&kvm->arch.invalid_mmu_pages);
>>> +    kvm_mmu_reset_last_pte_updated(kvm);
>>> +    return ret;
>>> +}
>>> +
>>> +static void kvm_mmu_commit_zap_page(struct kvm *kvm)
>>> +{
>>> +    struct kvm_mmu_page *sp, *n;
>>> +
>>> +    if (list_empty(&kvm->arch.invalid_mmu_pages))
>>> +        return;
>>> +
>>> +    kvm_flush_remote_tlbs(kvm);
>>> +    list_for_each_entry_safe(sp, n,&kvm->arch.invalid_mmu_pages, link) {
>>> +        WARN_ON(!sp->role.invalid);
>>> +        if (!sp->root_count)
>>> +            kvm_mmu_free_page(kvm, sp);
>>> +    }
>>> +}
>>> +
>>>
>>>        
>> You're adding two new functions but not using them here?  Possibly in
>> the old kvm_mmu_zap_page()?
>>      
> I use those in the next patch, it's not in kvm_mmu_zap_page(), it's used like:
>
> hold mmu spin lock
>
> kvm_mmu_prepare_zap_page page A
> kvm_mmu_prepare_zap_page page B
> kvm_mmu_prepare_zap_page page C
> ......
> kvm_mmu_commit_zap_page
>    

It would be better to rewrite kvm_mmu_zap_page() in terms of 
prepare/commit in the patch so we don't have two copies of the same 
thing (also easier to review).




>> This is a good idea, but belongs in a separate patch?  We can use it to
>> reclaim invalid pages before allocating new ones.
>>
>>      
> This patch is very simple and kvm_mmu_commit_zap_page() function should depend on
> kvm->arch.invalid_mmu_pages, so i think we on need separate this patch, your opinion? :-)
>
>    

How about passing the list as a parameter to prepare() and commit()?  If 
the lifetime of the list is just prepare/commit, it shouldn't be a global.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

