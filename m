Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0D0NfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:35:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab0D0NfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:35:10 -0400
Message-ID: <4BD6E80A.2000201@redhat.com>
Date: Tue, 27 Apr 2010 16:35:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/22] KVM: MMU: Introduce kvm_read_guest_page_x86()
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-16-git-send-email-joerg.roedel@amd.com> <4BD6DE15.8070409@redhat.com> <20100427132030.GH11097@amd.com>
In-Reply-To: <20100427132030.GH11097@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 04:20 PM, Joerg Roedel wrote:
> On Tue, Apr 27, 2010 at 03:52:37PM +0300, Avi Kivity wrote:
>    
>> On 04/27/2010 01:38 PM, Joerg Roedel wrote:
>>      
>>> This patch introduces the kvm_read_guest_page_x86 function
>>> which reads from the physical memory of the guest. If the
>>> guest is running in guest-mode itself with nested paging
>>> enabled it will read from the guest's guest physical memory
>>> instead.
>>> The patch also changes changes the code to use this function
>>> where it is necessary.
>>>
>>>
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 7851bbc..d9dfc8c 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -254,6 +254,13 @@ struct kvm_mmu {
>>>   	union kvm_mmu_page_role base_role;
>>>   	bool direct_map;
>>>
>>> +	/*
>>> +	 * If true the mmu runs in two-level mode.
>>> +	 * vcpu->arch.nested_mmu needs to contain meaningful values in
>>> +	 * this case.
>>> +	 */
>>> +	bool nested;
>>> +
>>>        
>> struct mmu_context *active_mmu? (in vcpu->arch)
>>      
> Hmm, difficult since both mmu's are active in the npt-npt case. The
> arch.mmu struct contains mostly the l1 paging state initialized for
> shadow paging and different set_cr3/get_cr3/inject_page_fault functions.
> This keeps the changes to the mmu small and optimize for the common case
> (a nested npt fault).
>    

Well, it reduces the changes to the mmu, but it makes a 'struct kvm_mmu' 
incoherent since its meaning depends on whether it is nested or not.  
For someone reading the code, it is hard to see when to use ->nested_mmu 
or ->mmu.

Perhaps have

    struct kvm_mmu base_mmu;
    struct kvm_mmu nested_mmu;
    struct kvm_mmu *mmu;

You could have one patch that mindlessly changes mmu. to mmu->.  The 
impact of the patchset increases, but I think the result is more readable.

It will be a pain adapting the patchset, but easier than updating 
mmu.txt to reflect the current situation.

> The arch.nested_mmu contains the l2 paging mode and is only used for
> nested gva_to_gpa translations (thats the reason it is only partially
> initialized).
>
>    
>>>   	u64 *pae_root;
>>>   	u64 rsvd_bits_mask[2][4];
>>>   };
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 558d995..317ad26 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -379,6 +379,20 @@ int kvm_read_guest_page_tdp(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>>>   }
>>>   EXPORT_SYMBOL_GPL(kvm_read_guest_page_tdp);
>>>
>>> +int kvm_read_guest_page_x86(struct kvm_vcpu *vcpu, gfn_t gfn,
>>> +			    void *data, int offset, int len, u32 *error)
>>> +{
>>> +	struct kvm_mmu *mmu;
>>> +
>>> +	if (vcpu->arch.mmu.nested)
>>> +		mmu =&vcpu->arch.nested_mmu;
>>> +	else
>>> +		mmu =&vcpu->arch.mmu;
>>> +
>>> +	return kvm_read_guest_page_tdp(vcpu, mmu, gfn, data, offset, len,
>>> +				       error);
>>> +}
>>>        
>> This is really not x86 specific (though the implementation certainly
>> is).  s390 will have exactly the same need when it gets nested virt.
>> I think this can be folded into
>> kvm_read_guest_page_tdp()/kvm_read_nested_guest_page().
>>      
> For the generic walk_addr I need a version of that function that takes
> an mmu_context parameter. Thats the reason I made two functions.
> The function (or at least its semantic) is useful for !x86 too, thats
> right. But it currently can't be made generic because the MMU
> implementation is architecture specific. Do you suggest to give it a
> more generic name so we can move it later?
>    

kvm_read_guest_page_mmu() for the internal one, 
kvm_read_nested_guest_page() for the generic one?

-- 
error compiling committee.c: too many arguments to function

