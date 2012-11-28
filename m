Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2K1DdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 22:33:21 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57209 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2K1DdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 22:33:20 -0500
Message-ID: <50B585F7.7090902@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 11:33:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: x86: improve reexecute_instruction
References: <50AAC77C.8040505@linux.vnet.ibm.com> <50AAC7F9.7050305@linux.vnet.ibm.com> <20121126224105.GB10634@amt.cnet> <50B433D0.8060107@linux.vnet.ibm.com> <20121127234203.GC8295@amt.cnet>
In-Reply-To: <20121127234203.GC8295@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112803-1618-0000-0000-000002EF40D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 07:42 AM, Marcelo Tosatti wrote:
> On Tue, Nov 27, 2012 at 11:30:24AM +0800, Xiao Guangrong wrote:
>> On 11/27/2012 06:41 AM, Marcelo Tosatti wrote:
>>
>>>>
>>>> -	return false;
>>>> +again:
>>>> +	page_fault_count = ACCESS_ONCE(vcpu->kvm->arch.page_fault_count);
>>>> +
>>>> +	/*
>>>> +	 * if emulation was due to access to shadowed page table
>>>> +	 * and it failed try to unshadow page and re-enter the
>>>> +	 * guest to let CPU execute the instruction.
>>>> +	 */
>>>> +	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
>>>> +	emulate = vcpu->arch.mmu.page_fault(vcpu, cr3, PFERR_WRITE_MASK, false);
>>>
>>> Can you explain what is the objective here?
>>>
>>
>> Sure. :)
>>
>> The instruction emulation is caused by fault access on cr3. After unprotect
>> the target page, we call vcpu->arch.mmu.page_fault to fix the mapping of cr3.
>> if it return 1, mmu can not fix the mapping, we should report the error,
>> otherwise it is good to return to guest and let it re-execute the instruction
>> again.
>>
>> page_fault_count is used to avoid the race on other vcpus, since after we
>> unprotect the target page, other cpu can enter page fault path and let the
>> page be write-protected again.
>>
>> This way can help us to detect all the case that mmu can not be fixed.
> 
> How about recording the gfn number for shadow pages that have been
> shadowed in the current pagefault run? (which is cheap, compared to
> shadowing these pages).
> 

Marcelo,

Thanks for your idea!

If we use this way, we should cache gfns in vcpu struct.

Actually, i have considered the approach like yours, that is getting
all page tables of the guest, then to see whether the page table gfns
are contained in the target gfn. But we need changed mmu->gva_to_pfn
or introduce a new method to get page tables of the guest.

But reexecute_instruction is really the unlikely path, both of these
ways can make the mmu code more complex and/or introduce unnecessary
overload for the common cases.

it looks like the way used in this patch is the simplest and no harmful to
the core code.



