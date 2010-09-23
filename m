Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0IWDAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:00:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59307 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab0IWDAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:00:50 -0400
Message-ID: <4C9AC3EB.1080507@cn.fujitsu.com>
Date: Thu, 23 Sep 2010 11:05:15 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] KVM: MMU: support unsync sp out of the protection
 of 'mmu_lock'
References: <4C976D48.6020400@cn.fujitsu.com> <4C976D7C.7090707@cn.fujitsu.com> <4C977B9E.6030208@redhat.com>
In-Reply-To: <4C977B9E.6030208@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 11:19 PM, Avi Kivity wrote:
>  On 09/20/2010 04:19 PM, Xiao Guangrong wrote:
>> It allows keep unsync sp alive while it's out of the protection, later
>> we can use
>> kvm_mmu_free_page() to free it if !sp->active_count
> 
> Don't understand.  Of course unsync pages exist outside mmu_lock...?

Yes.

sorry, not describe it clear in the log.

> 
> 
>>   diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 839852d..4b7af3f 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -996,7 +996,6 @@ static void kvm_mmu_free_page(struct kvm *kvm,
>> struct kvm_mmu_page *sp)
>>   {
>>       ASSERT(is_empty_shadow_page(sp->spt));
>>       hlist_del(&sp->hash_link);
>> -    list_del(&sp->link);
>>       __free_page(virt_to_page(sp->spt));
>>       if (!sp->role.direct)
>>           __free_page(virt_to_page(sp->gfns));
>> @@ -1681,9 +1680,8 @@ static int kvm_mmu_prepare_zap_page(struct kvm
>> *kvm, struct kvm_mmu_page *sp,
>>       kvm_mmu_unlink_parents(kvm, sp);
>>       if (!sp->role.invalid&&  !sp->role.direct)
>>           unaccount_shadowed(kvm, sp->gfn);
>> -    if (sp->unsync)
>> -        kvm_unlink_unsync_page(kvm, sp);
>> -    if (!sp->active_count) {
>> +
>> +    if (!sp->active_count || sp->unsync) {
>>           /* Count self */
>>           ret++;
>>           list_move(&sp->link, invalid_list);
> 
> How can you drop an active unsync page?
> 
> I'm missing something here.
> 

Umm, this feature is used like this:

hold mmu_lock
increase sp->active_count
release mmu_lock
......
hold mmu_lock
increase sp->active_count
if (!sp->active_count && sp->invalid)
	kvm_mmu_free_page(sp);
......
release mmu_lock

