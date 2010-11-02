Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0KBHp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:45:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab0KBHpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:45:50 -0400
Date: Tue, 2 Nov 2010 09:45:45 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 7/7] KVM: KVM: don't break vcpu 'halt' state due
 to apfs
Message-ID: <20101102074545.GC7881@redhat.com>
References: <4CCE8143.3090105@cn.fujitsu.com>
 <4CCE82BC.3090000@cn.fujitsu.com>
 <20101101125551.GD31722@redhat.com>
 <4CCF77B2.9080604@cn.fujitsu.com>
 <20101102065613.GA7881@redhat.com>
 <4CCFBE4E.3090804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCFBE4E.3090804@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 03:31:26PM +0800, Xiao Guangrong wrote:
> On 11/02/2010 02:56 PM, Gleb Natapov wrote:
> > On Tue, Nov 02, 2010 at 10:30:10AM +0800, Xiao Guangrong wrote:
> >> On 11/01/2010 08:55 PM, Gleb Natapov wrote:
> >>
> >>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >>> index 2cfdf2d..f7aed95 100644
> >>> --- a/arch/x86/kvm/x86.c
> >>> +++ b/arch/x86/kvm/x86.c
> >>> @@ -5295,8 +5295,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
> >>>  			{
> >>>  				switch(vcpu->arch.mp_state) {
> >>>  				case KVM_MP_STATE_HALTED:
> >>> -					vcpu->arch.mp_state =
> >>> -						KVM_MP_STATE_RUNNABLE;
> >>> +					if (list_empty_careful(&vcpu->async_pf.done))
> >>> +						vcpu->arch.mp_state =
> >>> +							KVM_MP_STATE_RUNNABLE;
> >>
> >> if nmi/interrupt and apfs completed event occur at the same time, we will miss to
> >> exit halt sate. Maybe we can check the pending event here, see below patch please.
> >>
> > No, we will not. If nmi/interrupt and apfs completed event occur at the same
> > time kvm_vcpu_block() will exit with KVM_REQ_UNHALT set, but cpu will
> > not be unhalted because of list_empty_careful(&vcpu->async_pf.done)
> > check. Vcpu then will process pending apf completion and enter
> > kvm_vcpu_block() again which will immediately exit because
> > kvm_arch_vcpu_runnable() will return true since there is pending
> > nmi/interrupt. This time vcpu will be unhalted.
> 
> Thanks for your explanation, but if it has nmi/interrupt pending,
> kvm_arch_can_inject_async_page_present() always return false in PV guest case,
> it can not process pending apf completion, so, the vcpu is remain halt state
> forever?
> 

kvm_event_needs_reinjection() checks for nmi/interrupts that
need reinjection (not injection).  Those are nmi/interrupts that
was injected but injection failed for some reason. For nmi, for
instance, kvm_arch_vcpu_runnable() checks vcpu->arch.nmi_pending,
but kvm_event_needs_reinjection() checks for vcpu->arch.nmi_injected.
NMI moves from nmi_pending to nmi_injected when it is injected into vcpu
for the first time. CPU cannot be halted in this state.

> Also, the pv guest can only handle an apf completion at one time, it can not ensure
> vcpu->async_pf.done is empty after kvm_check_async_pf_completion()
> 
In case of PV guest it will be woken up by apf completion by
kvm_arch_async_page_present() below.

> > 
> >>>  				case KVM_MP_STATE_RUNNABLE:
> >>>  					vcpu->arch.apf.halted = false;
> >>>  					break;
> >>> @@ -6279,6 +6280,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
> >>>  		vcpu->arch.fault.error_code = 0;
> >>>  		vcpu->arch.fault.address = work->arch.token;
> >>>  		kvm_inject_page_fault(vcpu);
> >>> +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> >>>  	}
> >>>  }
> >>
> >> Have a stupid question, why we make the vcpu runnable here? Sorry i don't know
> >> kvm pv guest to much. :-(
> > Because kvm_arch_vcpu_runnable() does not check for pending exceptions.
> > Since now we do not unhalt vcpu when apf completion happens we need to
> > unhalt it here. But, as I said, the patch is untested.
> > 
> 
> As i know, exception can not let guest exit halt state, only NMI/interruption can do it, yes? :-)
On physical HW exception cannot happen while cpu is in halt state, but
with PV we define what guest can and cannot expect, so when guest
explicitly enables apf it should be able to handle it during halt.

--
			Gleb.
