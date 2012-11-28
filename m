Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab2K1WlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:41:02 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39024 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab2K1WlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:41:00 -0500
Message-ID: <50B692F3.4000408@linux.vnet.ibm.com>
Date: Thu, 29 Nov 2012 06:40:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: x86: improve reexecute_instruction
References: <50AAC77C.8040505@linux.vnet.ibm.com> <50AAC7F9.7050305@linux.vnet.ibm.com> <20121126224105.GB10634@amt.cnet> <50B433D0.8060107@linux.vnet.ibm.com> <20121128141230.GI928@redhat.com> <50B626D7.7070608@linux.vnet.ibm.com> <20121128215750.GA10039@amt.cnet>
In-Reply-To: <20121128215750.GA10039@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112822-1396-0000-0000-0000023A57A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 05:57 AM, Marcelo Tosatti wrote:
> On Wed, Nov 28, 2012 at 10:59:35PM +0800, Xiao Guangrong wrote:
>> On 11/28/2012 10:12 PM, Gleb Natapov wrote:
>>> On Tue, Nov 27, 2012 at 11:30:24AM +0800, Xiao Guangrong wrote:
>>>> On 11/27/2012 06:41 AM, Marcelo Tosatti wrote:
>>>>
>>>>>>
>>>>>> -	return false;
>>>>>> +again:
>>>>>> +	page_fault_count = ACCESS_ONCE(vcpu->kvm->arch.page_fault_count);
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * if emulation was due to access to shadowed page table
>>>>>> +	 * and it failed try to unshadow page and re-enter the
>>>>>> +	 * guest to let CPU execute the instruction.
>>>>>> +	 */
>>>>>> +	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
>>>>>> +	emulate = vcpu->arch.mmu.page_fault(vcpu, cr3, PFERR_WRITE_MASK, false);
>>>>>
>>>>> Can you explain what is the objective here?
>>>>>
>>>>
>>>> Sure. :)
>>>>
>>>> The instruction emulation is caused by fault access on cr3. After unprotect
>>>> the target page, we call vcpu->arch.mmu.page_fault to fix the mapping of cr3.
>>>> if it return 1, mmu can not fix the mapping, we should report the error,
>>>> otherwise it is good to return to guest and let it re-execute the instruction
>>>> again.
>>>>
>>>> page_fault_count is used to avoid the race on other vcpus, since after we
>>>> unprotect the target page, other cpu can enter page fault path and let the
>>>> page be write-protected again.
>>>>
>>>> This way can help us to detect all the case that mmu can not be fixed.
>>>>
>>> Can you write this in a comment above vcpu->arch.mmu.page_fault()?
>>
>> Okay, if Marcelo does not object this way. :)
> 
> I do object, since it is possible to detect precisely the condition by 
> storing which gfns have been cached.
> 
> Then, Xiao, you need a way to handle large read-only sptes.

Sorry, Marcelo, i am still confused why read-only sptes can not work
under this patch?

The code after read-only large spte is is:

+		if ((level > PT_PAGE_TABLE_LEVEL &&
+		   has_wrprotected_page(vcpu->kvm, gfn, level)) ||
+		      mmu_need_write_protect(vcpu, gfn, can_unsync)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			ret = 1;

It return 1, then reexecute_instruction return 0. It is the same as without
readonly large-spte.


