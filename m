Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3ADHzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:55:32 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49510 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3ADHz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:55:29 -0500
Message-ID: <50E68AD7.9010008@linux.vnet.ibm.com>
Date: Fri, 04 Jan 2013 15:55:03 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] KVM: x86: improve reexecute_instruction
References: <50CC1F62.4050701@linux.vnet.ibm.com> <50CC2038.4060500@linux.vnet.ibm.com> <20121223150217.GS17584@redhat.com>
In-Reply-To: <20121223150217.GS17584@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010407-1396-0000-0000-0000025F241C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

Thanks for your review and sorry for the delay reply since i was on my vacation.

On 12/23/2012 11:02 PM, Gleb Natapov wrote:
> On Sat, Dec 15, 2012 at 03:01:12PM +0800, Xiao Guangrong wrote:

>>
>> +	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu, addr,
>> +				       &walker, user_fault);
>> +
> is_self_change_mapping() has a subtle side-effect by setting
> vcpu->arch.target_gfn_is_pt. From reading the page_fault() function
> you cannot guess why is_self_change_mapping() is not called inside "if
> (walker.level >= PT_DIRECTORY_LEVEL)" since this is the only place where
> its output is used. May be pass it pointer to target_gfn_is_pt as a
> parameter to make it clear that return value is not the only output of
> the function.

Yes, it is clearer, will do it in the next version.

> 
>>  	if (walker.level >= PT_DIRECTORY_LEVEL)
>>  		force_pt_level = mapping_level_dirty_bitmap(vcpu, walker.gfn)
>> -		   || FNAME(is_self_change_mapping)(vcpu, &walker, user_fault);
>> +		   || is_self_change_mapping;
>>  	else
>>  		force_pt_level = 1;
>>  	if (!force_pt_level) {
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index bf66169..fc33563 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4756,29 +4756,25 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
>>  static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>>  {
>>  	gpa_t gpa = cr2;
>> +	gfn_t gfn;
>>  	pfn_t pfn;
>> -	unsigned int indirect_shadow_pages;
>> -
>> -	spin_lock(&vcpu->kvm->mmu_lock);
>> -	indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
>> -	spin_unlock(&vcpu->kvm->mmu_lock);
>> -
>> -	if (!indirect_shadow_pages)
>> -		return false;
>>
>>  	if (!vcpu->arch.mmu.direct_map) {
>> -		gpa = kvm_mmu_gva_to_gpa_read(vcpu, cr2, NULL);
>> +		/*
>> +		 * Write permission should be allowed since only
>> +		 * write access need to be emulated.
>> +		 */
>> +		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
>> +
>> +		/*
>> +		 * If the mapping is invalid in guest, let cpu retry
>> +		 * it to generate fault.
>> +		 */
>>  		if (gpa == UNMAPPED_GVA)
>> -			return true; /* let cpu generate fault */
>> +			return true;
>>  	}
> Why not fold this change to if (!vcpu->arch.mmu.direct_map) into
> previous patch where it was introduced. This looks independent of
> what you are doing in this patch.

Fine to me.

> 
>>
>> -	/*
>> -	 * if emulation was due to access to shadowed page table
>> -	 * and it failed try to unshadow page and re-enter the
>> -	 * guest to let CPU execute the instruction.
>> -	 */
>> -	if (kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
>> -		return true;
>> +	gfn = gpa_to_gfn(gpa);
>>
>>  	/*
>>  	 * Do not retry the unhandleable instruction if it faults on the
>> @@ -4786,13 +4782,33 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>>  	 * retry instruction -> write #PF -> emulation fail -> retry
>>  	 * instruction -> ...
>>  	 */
>> -	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
>> -	if (!is_error_noslot_pfn(pfn)) {
>> -		kvm_release_pfn_clean(pfn);
>> +	pfn = gfn_to_pfn(vcpu->kvm, gfn);
>> +
>> +	/*
>> +	 * If the instruction failed on the error pfn, it can not be fixed,
>> +	 * report the error to userspace.
>> +	 */
>> +	if (is_error_noslot_pfn(pfn))
>> +		return false;
>> +
>> +	kvm_release_pfn_clean(pfn);
>> +
>> +	/* The instructions are well-emulated on direct mmu. */
>> +	if (vcpu->arch.mmu.direct_map) {
>> +		unsigned int indirect_shadow_pages;
>> +
>> +		spin_lock(&vcpu->kvm->mmu_lock);
>> +		indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
>> +		spin_unlock(&vcpu->kvm->mmu_lock);
>> +
>> +		if (indirect_shadow_pages)
>> +			kvm_mmu_unprotect_page(vcpu->kvm, gfn);
>> +
>>  		return true;
>>  	}
>>
>> -	return false;
>> +	kvm_mmu_unprotect_page(vcpu->kvm, gfn);
>> +	return !(vcpu->arch.fault_addr == cr2 && vcpu->arch.target_gfn_is_pt);
> Do you store fault_addr only to avoid using stale target_gfn_is_pt? If
> yes why not reset target_gfn_is_pt to false at the beginning of a page
> fault and get rid of fault_addr?

Good suggestion, will do. :)


