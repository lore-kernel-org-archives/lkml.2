Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab2K1O7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:59:46 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37917 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab2K1O7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:59:45 -0500
Message-ID: <50B626D7.7070608@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 22:59:35 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: x86: improve reexecute_instruction
References: <50AAC77C.8040505@linux.vnet.ibm.com> <50AAC7F9.7050305@linux.vnet.ibm.com> <20121126224105.GB10634@amt.cnet> <50B433D0.8060107@linux.vnet.ibm.com> <20121128141230.GI928@redhat.com>
In-Reply-To: <20121128141230.GI928@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112814-3864-0000-0000-000005C2595A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 10:12 PM, Gleb Natapov wrote:
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
>>
> Can you write this in a comment above vcpu->arch.mmu.page_fault()?

Okay, if Marcelo does not object this way. :)

