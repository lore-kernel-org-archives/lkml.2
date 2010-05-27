Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab0E0LEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 07:04:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58941 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754872Ab0E0LEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 07:04:14 -0400
Message-ID: <4BFE50E2.60203@cn.fujitsu.com>
Date: Thu, 27 May 2010 19:00:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: MMU: fix relaxing permission
References: <4BFC8B0D.2060106@cn.fujitsu.com> <4BFC8B8C.7010402@cn.fujitsu.com> <4BFE4513.8090606@redhat.com>
In-Reply-To: <4BFE4513.8090606@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 05/26/2010 05:46 AM, Xiao Guangrong wrote:
>> There is a relaxing permission operation in set_spte():
>>
>> if guest's CR0.WP is not set and R/W #PF occurs in supervisor-level,
>> the mapping path might set to writable, then user can allow to write.
>>
>> @@ -1859,8 +1859,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64
>> *sptep,
>>
>>       spte |= (u64)pfn<<  PAGE_SHIFT;
>>
>> -    if ((pte_access&  ACC_WRITE_MASK)
>> -        || (write_fault&&  !is_write_protection(vcpu)&&  !user_fault)) {
>> +    if (pte_access&  ACC_WRITE_MASK) {
>>
>>    
> 
> The host always sets cr0.wp (in shadow mode) so we can write protect
> page tables.  So when the guest clears cr0.wp, we emulate a gpte with
> gpte.w=0 and gpte.u=1 in two ways:
> 
> - spte.w=1, spte.u=0: this will allow the guest kernel to write but trap
> on guest user access
> - spte.w=0, spte.u=1: allows guest user access but traps on guest kernel
> writes
> 
> If the guest attempts an access that is currently disallowed, we switch
> to the other spte encoding.

Avi,

Thanks for your explanation, but i not see where to implement what you say,
could you please point it out for me? :-(

And, i think use 'spte.w=1, spte.u=0' to emulate 'guest cr0.wp=0 and gpte.w=0'
is not a good way since it can completely stop user process access, but in this
case, user process is usually read and kernel lazily to write, just like vdso,
it will generate a lots of #PF
