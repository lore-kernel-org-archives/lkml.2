Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1FJDpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:45:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49484 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab1FJDpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:45:11 -0400
Message-ID: <4DF193BA.4060701@cn.fujitsu.com>
Date: Fri, 10 Jun 2011 11:47:06 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 14/15] KVM: MMU: mmio page fault support
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE2281.1000008@cn.fujitsu.com> <4DF07601.9060705@redhat.com>
In-Reply-To: <4DF07601.9060705@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 11:44:51,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 11:44:51,
	Serialize complete at 2011-06-10 11:44:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 03:28 PM, Avi Kivity wrote:

> 
> Maybe it's time to kill off bypass_guest_pf=1.  It's not as effective as it used to be, since unsync pages always use shadow_trap_nonpresent_pte, and since we convert between the two nonpresent_ptes during sync and unsync.
> 

Reasonable!

>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 4f475ab..227cf10 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -91,6 +91,9 @@ module_param(dbg, bool, 0644);
>>   static int oos_shadow = 1;
>>   module_param(oos_shadow, bool, 0644);
>>
>> +static int __read_mostly mmio_pf = 1;
>> +module_param(mmio_pf, bool, 0644);
> 
> Why make it a module parameter?

Will remove.

> 
>> +static void mark_mmio_spte(u64 *sptep, u64 gfn, unsigned access)
>> +{
>> +    access&= ACC_WRITE_MASK | ACC_USER_MASK;
>> +
>> +    __set_spte(sptep, shadow_mmio_mask | access | gfn<<  PAGE_SHIFT);
>> +}
> 
> This can only work for shadow.  Is it worth the complexity?
> 

I think it is not bad, since it is really simple, and for tdp, we also need to
set shadow_mmio_mask bits which causes misconfig/rsvd fault

> Also, shadow walking is not significantly faster than guest page table walking.  And if we miss, we have to walk the guest page tables in any case.
> 

Um. i think walking guest page table is slower, it needs to walk memslots for many times
and it triggers page fault if the host page is swapped.

And it is hardly missed, since for tdp, it infrequency zaps shadow pages, for soft mmu,
the mmio spte is always unsync, and in guest, the mmio region is always mapped by kernel,
so it is infrequency to be update and lazily flushed.

>> +
>> +static bool quickly_check_mmio_pf(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>> +{
>> +    if (direct&&  vcpu_match_mmio_gpa(vcpu, addr))
>> +        return true;
>> +
>> +    if (vcpu_match_mmio_gva(vcpu, addr))
>> +        return true;
>> +
>> +    return false;
>> +}
> 
> There is also the case of nesting - it's not direct and it's not a gva.
> 

If it is direct, we only need to compare the pga, and direct=0, we only need to
compare gva, i'll fix the code to make it clear.
