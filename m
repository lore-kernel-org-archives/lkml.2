Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab0FACmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 22:42:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62662 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab0FACmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 22:42:24 -0400
Message-ID: <4C0472C1.3020505@cn.fujitsu.com>
Date: Tue, 01 Jun 2010 10:38:57 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/5] KVM: MMU: introduce some macros to cleanup hlist
 traverseing
References: <4C025BDC.1020304@cn.fujitsu.com> <4C026433.50602@redhat.com> <4C031845.7040208@cn.fujitsu.com> <4C039A1B.4010703@redhat.com>
In-Reply-To: <4C039A1B.4010703@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 05/31/2010 05:00 AM, Xiao Guangrong wrote:
>>
>>>     
>>>> +
>>>> +#define for_each_gfn_indirect_sp(kvm, sp, gfn, pos, n)            \
>>>> +  hlist_for_each_entry_safe(sp, pos, n,                    \
>>>> +&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
>>>> +        if (sp->gfn == gfn&&   !sp->role.direct)
>>>> +
>>>> +#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn, pos, n)        \
>>>> +  hlist_for_each_entry_safe(sp, pos, n,                    \
>>>> +&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
>>>> +        if (sp->gfn == gfn&&   !sp->role.direct&&         \
>>>> +            !sp->role.invalid)
>>>>
>>>>        
>>> Shouldn't we always skip invalid gfns?
>>>      
>> Actually, in kvm_mmu_unprotect_page() function, it need find out
>> invalid shadow pages:
>>
>> |    hlist_for_each_entry_safe(sp, node, n, bucket, hash_link)
>> |        if (sp->gfn == gfn&&  !sp->role.direct) {
>> |            pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
>> |                 sp->role.word);
>> |            r = 1;
>> |            if (kvm_mmu_zap_page(kvm, sp))
>> |                goto restart;
>> |        }
>>
>> I'm not sure whether we can skip invalid sp here, since it can change
>> this
>> function's return value. :-(
>>    
> 
> Hm.  Invalid pages don't need to be write protected.  So I think you can
> patch unprotect_page() to ignore invalid pages, and then you can convert
> it to the new macros which ignore invalid pages as well.
> 
> The invariant is: if an sp exists with !role.invalid and !unsync, then
> the page must be write protected.

OK, will fix it in the next version.

> 
> 
>>> What about providing both gfn and role to the macro?
>>>
>>>      
>> In current code, no code simply use role and gfn to find sp,
>> in kvm_mmu_get_page(), we need do other work for
>> 'sp->gfn == gfn&&  sp->role != role' sp, and other functions only need
>> compare
>> some members in role, but not all members.
>>    
> 
> How about just gfn?  I think everything compares against that!
> 

In this patch, it already introduced a macro to only compares 'gfn', that is:

+#define for_each_gfn_sp(kvm, sp, gfn, pos, n)				\
+  hlist_for_each_entry_safe(sp, pos, n,				\
+	&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
+		if (sp->gfn == gfn)

Sorry if i misunderstand your meaning.

Thanks,
Xiao
