Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab0KBH1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:27:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65398 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab0KBH1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:27:04 -0400
Message-ID: <4CCFBE4E.3090804@cn.fujitsu.com>
Date: Tue, 02 Nov 2010 15:31:26 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 7/7] KVM: KVM: don't break vcpu 'halt' state due
 to apfs
References: <4CCE8143.3090105@cn.fujitsu.com> <4CCE82BC.3090000@cn.fujitsu.com> <20101101125551.GD31722@redhat.com> <4CCF77B2.9080604@cn.fujitsu.com> <20101102065613.GA7881@redhat.com>
In-Reply-To: <20101102065613.GA7881@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2010 02:56 PM, Gleb Natapov wrote:
> On Tue, Nov 02, 2010 at 10:30:10AM +0800, Xiao Guangrong wrote:
>> On 11/01/2010 08:55 PM, Gleb Natapov wrote:
>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 2cfdf2d..f7aed95 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -5295,8 +5295,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>>>  			{
>>>  				switch(vcpu->arch.mp_state) {
>>>  				case KVM_MP_STATE_HALTED:
>>> -					vcpu->arch.mp_state =
>>> -						KVM_MP_STATE_RUNNABLE;
>>> +					if (list_empty_careful(&vcpu->async_pf.done))
>>> +						vcpu->arch.mp_state =
>>> +							KVM_MP_STATE_RUNNABLE;
>>
>> if nmi/interrupt and apfs completed event occur at the same time, we will miss to
>> exit halt sate. Maybe we can check the pending event here, see below patch please.
>>
> No, we will not. If nmi/interrupt and apfs completed event occur at the same
> time kvm_vcpu_block() will exit with KVM_REQ_UNHALT set, but cpu will
> not be unhalted because of list_empty_careful(&vcpu->async_pf.done)
> check. Vcpu then will process pending apf completion and enter
> kvm_vcpu_block() again which will immediately exit because
> kvm_arch_vcpu_runnable() will return true since there is pending
> nmi/interrupt. This time vcpu will be unhalted.

Thanks for your explanation, but if it has nmi/interrupt pending,
kvm_arch_can_inject_async_page_present() always return false in PV guest case,
it can not process pending apf completion, so, the vcpu is remain halt state
forever?

Also, the pv guest can only handle an apf completion at one time, it can not ensure
vcpu->async_pf.done is empty after kvm_check_async_pf_completion()

> 
>>>  				case KVM_MP_STATE_RUNNABLE:
>>>  					vcpu->arch.apf.halted = false;
>>>  					break;
>>> @@ -6279,6 +6280,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>>>  		vcpu->arch.fault.error_code = 0;
>>>  		vcpu->arch.fault.address = work->arch.token;
>>>  		kvm_inject_page_fault(vcpu);
>>> +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>>>  	}
>>>  }
>>
>> Have a stupid question, why we make the vcpu runnable here? Sorry i don't know
>> kvm pv guest to much. :-(
> Because kvm_arch_vcpu_runnable() does not check for pending exceptions.
> Since now we do not unhalt vcpu when apf completion happens we need to
> unhalt it here. But, as I said, the patch is untested.
> 

As i know, exception can not let guest exit halt state, only NMI/interruption can do it, yes? :-)
