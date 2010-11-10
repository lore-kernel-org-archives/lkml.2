Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0KJCET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:04:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62774 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab0KJCEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:04:16 -0500
Message-ID: <4CD9FEA1.2050400@cn.fujitsu.com>
Date: Wed, 10 Nov 2010 10:08:33 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: MMU: don not retry #PF for nonpaging guest
References: <4CD28B5F.1040205@cn.fujitsu.com> <4CD28BCA.1060907@cn.fujitsu.com> <20101104103548.GE6018@redhat.com> <4CD39886.4050909@cn.fujitsu.com> <20101109080357.GI9036@redhat.com> <4CD90AE8.7070003@cn.fujitsu.com> <20101109092625.GK9036@redhat.com> <4CD919E8.3010300@cn.fujitsu.com> <20101109105155.GP9036@redhat.com>
In-Reply-To: <20101109105155.GP9036@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-10 10:04:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-10 10:04:41,
	Serialize complete at 2010-11-10 10:04:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 06:51 PM, Gleb Natapov wrote:
> On Tue, Nov 09, 2010 at 05:52:40PM +0800, Xiao Guangrong wrote:
>>>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>>>> index 7f20f2c..606978e 100644
>>>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>>>> @@ -600,6 +600,7 @@ struct kvm_x86_ops {
>>>>>>  struct kvm_arch_async_pf {
>>>>>>  	u32 token;
>>>>>>  	gfn_t gfn;
>>>>>> +	bool softmmu;
>>>>>>  };
>>>>>>  
>>>>>>  extern struct kvm_x86_ops *kvm_x86_ops;
>>>>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>>>>> index f3fad4f..48ca312 100644
>>>>>> --- a/arch/x86/kvm/mmu.c
>>>>>> +++ b/arch/x86/kvm/mmu.c
>>>>>>  static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
>>>>>> @@ -2602,6 +2607,7 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
>>>>>>  	struct kvm_arch_async_pf arch;
>>>>>>  	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
>>>>>>  	arch.gfn = gfn;
>>>>>> +	arch.softmmu = mmu_is_softmmu(vcpu);
>>>>>>  
>>>>> We can do:
>>>>>         if (mmu_is_nested(vcpu))
>>>>> 		gva = vcpu->mmu.gva_to_gpa(gva);
>>>>> And this should fix everything no?
>>>>>
>>>>
>>>> No, since it can't help us to avoid NPF when nested guest run again.
>>>>
>>> Of course it will not prevent NPF if L2 guest touches it again, but from
>>> correctness point of view it is OK. So if L1 will re-use the page for
>>> L1 process the page will be already mapped. Not a huge gain I agree, but
>>> fix is much more simple.
>>>
>>
>> Um, it need hold mmu_lock, and we don't know 'gva''s mapping in PT10 is valid
>> or not, also don't know whether it can be accessed later, so the general rule
>> is lazily update it. 
>>
> We do know that gva's mapping in PT10 is valid since we wouldn't try apf
> otherwise. If nested gpa is mapped to a gpa thst is not valid in L0 then
> L0 should emulate instruction for L2, no?
> 

No need.

>> The more important is that we can prefault for softmmu in the later patch,
>> it means we can prefault 'gva' in PT20, so don't cook gva here.
>>
> So may be just apply second patch then?
> 

Yes, i think so.
