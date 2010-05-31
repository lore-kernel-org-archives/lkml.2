Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0EaLOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:14:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab0EaLOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:14:42 -0400
Message-ID: <4C039A1B.4010703@redhat.com>
Date: Mon, 31 May 2010 14:14:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/5] KVM: MMU: introduce some macros to cleanup hlist
 traverseing
References: <4C025BDC.1020304@cn.fujitsu.com> <4C026433.50602@redhat.com> <4C031845.7040208@cn.fujitsu.com>
In-Reply-To: <4C031845.7040208@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 05:00 AM, Xiao Guangrong wrote:
>
>>      
>>> +
>>> +#define for_each_gfn_indirect_sp(kvm, sp, gfn, pos, n)            \
>>> +  hlist_for_each_entry_safe(sp, pos, n,                    \
>>> +&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
>>> +        if (sp->gfn == gfn&&   !sp->role.direct)
>>> +
>>> +#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn, pos, n)        \
>>> +  hlist_for_each_entry_safe(sp, pos, n,                    \
>>> +&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
>>> +        if (sp->gfn == gfn&&   !sp->role.direct&&         \
>>> +            !sp->role.invalid)
>>>
>>>        
>> Shouldn't we always skip invalid gfns?
>>      
> Actually, in kvm_mmu_unprotect_page() function, it need find out
> invalid shadow pages:
>
> |	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link)
> |		if (sp->gfn == gfn&&  !sp->role.direct) {
> |			pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
> |				 sp->role.word);
> |			r = 1;
> |			if (kvm_mmu_zap_page(kvm, sp))
> |				goto restart;
> |		}
>
> I'm not sure whether we can skip invalid sp here, since it can change this
> function's return value. :-(
>    

Hm.  Invalid pages don't need to be write protected.  So I think you can 
patch unprotect_page() to ignore invalid pages, and then you can convert 
it to the new macros which ignore invalid pages as well.

The invariant is: if an sp exists with !role.invalid and !unsync, then 
the page must be write protected.


>> What about providing both gfn and role to the macro?
>>
>>      
> In current code, no code simply use role and gfn to find sp,
> in kvm_mmu_get_page(), we need do other work for
> 'sp->gfn == gfn&&  sp->role != role' sp, and other functions only need compare
> some members in role, but not all members.
>    

How about just gfn?  I think everything compares against that!

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

