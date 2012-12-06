Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2LFCa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 21:30:27 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49519 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab2LFCaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 21:30:25 -0500
Message-ID: <50C00336.8010307@linux.vnet.ibm.com>
Date: Thu, 06 Dec 2012 10:30:14 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: optimize for set_spte
References: <50BD32F7.5080601@linux.vnet.ibm.com> <20121205210919.GA20260@amt.cnet>
In-Reply-To: <20121205210919.GA20260@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120602-1396-0000-0000-0000024216E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 05:09 AM, Marcelo Tosatti wrote:
> On Tue, Dec 04, 2012 at 07:17:11AM +0800, Xiao Guangrong wrote:
>> There are two cases we need to adjust page size in set_spte:
>> 1): the one is other vcpu creates new sp in the window between mapping_level()
>>     and acquiring mmu-lock.
>> 2): the another case is the new sp is created by itself (page-fault path) when
>>     guest uses the target gfn as its page table.
>>
>> In current code, set_spte drop the spte and emulate the access for these case,
>> it works not good:
>> - for the case 1, it may destroy the mapping established by other vcpu, and
>>   do expensive instruction emulation.
>> - for the case 2, it may emulate the access even if the guest is accessing
>>   the page which not used as page table. There is a example, 0~2M is used as
>>   huge page in guest, in this huge page, only page 3 used as page table, then
>>   guest read/writes on other pages can cause instruction emulation.
>>
>> Both of these cases can be fixed by allowing guest to retry the access, it
>> will refault, then we can establish the mapping by using small page
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |   16 ++++++++++++----
>>  1 files changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index b875a9e..01d7c2a 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -2382,12 +2382,20 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>>  	    || (!vcpu->arch.mmu.direct_map && write_fault
>>  		&& !is_write_protection(vcpu) && !user_fault)) {
>>
>> +		/*
>> +		 * There are two cases:
>> +		 * - the one is other vcpu creates new sp in the window
>> +		 *   between mapping_level() and acquiring mmu-lock.
>> +		 * - the another case is the new sp is created by itself
>> +		 *   (page-fault path) when guest uses the target gfn as
>> +		 *   its page table.
>> +		 * Both of these cases can be fixed by allowing guest to
>> +		 * retry the access, it will refault, then we can establish
>> +		 * the mapping by using small page.
>> +		 */
>>  		if (level > PT_PAGE_TABLE_LEVEL &&
>> -		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
>> -			ret = 1;
>> -			drop_spte(vcpu->kvm, sptep);
>> +		    has_wrprotected_page(vcpu->kvm, gfn, level))
>>  			goto done;
>> -		}
>>
>>  		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
>>
>> -- 
>> 1.7.7.6
> 
> ACK.
> 
> Does it fix your testcase?

No.
I will post the new version patch of improving reexecute_instruction.



