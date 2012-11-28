Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2K1Ozi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:55:38 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47697 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2K1Ozg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:55:36 -0500
Message-ID: <50B625DE.5070001@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2012 22:55:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: x86: let reexecute_instruction work for tdp
References: <50AAC77C.8040505@linux.vnet.ibm.com> <50AAC7CE.2050506@linux.vnet.ibm.com> <20121126223712.GA10634@amt.cnet> <50B42FC7.2080805@linux.vnet.ibm.com> <20121127233246.GB8295@amt.cnet> <50B581C1.2050406@linux.vnet.ibm.com> <20121128140155.GH928@redhat.com>
In-Reply-To: <20121128140155.GH928@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112814-6102-0000-0000-000002A308FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 10:01 PM, Gleb Natapov wrote:
> On Wed, Nov 28, 2012 at 11:15:13AM +0800, Xiao Guangrong wrote:
>> On 11/28/2012 07:32 AM, Marcelo Tosatti wrote:
>>> On Tue, Nov 27, 2012 at 11:13:11AM +0800, Xiao Guangrong wrote:
>>>>>> +static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>>>>>>  {
>>>>>> -	gpa_t gpa;
>>>>>> +	gpa_t gpa = cr2;
>>>>>>  	pfn_t pfn;
>>>>>>
>>>>>> -	if (tdp_enabled)
>>>>>> +	if (!ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
>>>>>>  		return false;
>>>>>
>>>>> How is indirect_shadow_pages protected? Why is ACCESS_ONCE() being used
>>>>> to read it?
>>>>
>>>> Hi Marcelo,
>>>>
>>>> It is protected by mmu-lock for it only be changed when mmu-lock is hold. And
>>>> ACCESS_ONCE is used on read path avoiding magic optimization from compiler.
>>>
>>> Please switch to mmu_lock protection, there is no reason to have access
>>> to this variable locklessly - not performance critical.
>>>
>>> For example, there is no use of barriers when modifying the variable.
>>
>> This is not bad, the worst case is, the direct mmu failed to unprotect the shadow
>> pages, (meet indirect_shadow_pages = 0, but there has shadow pages being shadowed.),
>> after enter to guest, we will go into reexecute_instruction again, then it will
>> remove shadow pages.
>>
> Isn't the same scenario can happen even with mmu lock around
> indirect_shadow_pages access?

Hmm..., i also think it is no different. Even using mmu-lock, we can not
prevent the target pfn can not be write-protected later. Marcelo?

