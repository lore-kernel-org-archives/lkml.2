Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0EaCEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 22:04:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60411 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab0EaCEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 22:04:05 -0400
Message-ID: <4C031845.7040208@cn.fujitsu.com>
Date: Mon, 31 May 2010 10:00:37 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/5] KVM: MMU: introduce some macros to cleanup hlist
 traverseing
References: <4C025BDC.1020304@cn.fujitsu.com> <4C026433.50602@redhat.com>
In-Reply-To: <4C026433.50602@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 05/30/2010 03:36 PM, Xiao Guangrong wrote:
>> Introduce for_each_gfn_sp(), for_each_gfn_indirect_sp() and
>> for_each_gfn_indirect_valid_sp() to cleanup hlist traverseing
>>
>> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
>> ---
>>   arch/x86/kvm/mmu.c |  129
>> ++++++++++++++++++++++------------------------------
>>   1 files changed, 54 insertions(+), 75 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 56f8c3c..84c705e 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1200,6 +1200,22 @@ static void kvm_unlink_unsync_page(struct kvm
>> *kvm, struct kvm_mmu_page *sp)
>>
>>   static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>>
>> +#define for_each_gfn_sp(kvm, sp, gfn, pos, n)                \
>> +  hlist_for_each_entry_safe(sp, pos, n,                    \
>> +    &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
>> +        if (sp->gfn == gfn)
>>    

Avi,

Thanks for your review.

> 
> 
>    if (...)
>         for_each_gfn_sp(...)
>               blah();
>    else
>          BUG();
> 
> will break.  Can do 'if ((sp)->gfn != (gfn)) ; else'.
> 
> Or call functions from the for (;;) parameters to advance the cursor.
> 
> (also use parentheses to protect macro arguments)
> 

Yeah, it's my mistake, i'll fix it in the next version.

> 
> 
>> +
>> +#define for_each_gfn_indirect_sp(kvm, sp, gfn, pos, n)            \
>> +  hlist_for_each_entry_safe(sp, pos, n,                    \
>> +    &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
>> +        if (sp->gfn == gfn&&  !sp->role.direct)
>> +
>> +#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn, pos, n)        \
>> +  hlist_for_each_entry_safe(sp, pos, n,                    \
>> +    &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
>> +        if (sp->gfn == gfn&&  !sp->role.direct&&        \
>> +            !sp->role.invalid)
>>    
> 
> Shouldn't we always skip invalid gfns? 

Actually, in kvm_mmu_unprotect_page() function, it need find out
invalid shadow pages:

|	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link)
|		if (sp->gfn == gfn && !sp->role.direct) {
|			pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
|				 sp->role.word);
|			r = 1;
|			if (kvm_mmu_zap_page(kvm, sp))
|				goto restart;
|		}

I'm not sure whether we can skip invalid sp here, since it can change this
function's return value. :-(


> What about providing both gfn and role to the macro?
> 

In current code, no code simply use role and gfn to find sp,
in kvm_mmu_get_page(), we need do other work for
'sp->gfn == gfn && sp->role != role' sp, and other functions only need compare
some members in role, but not all members.

Xiao

