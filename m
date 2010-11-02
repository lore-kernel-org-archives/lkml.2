Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0KBCZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 22:25:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63095 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab0KBCZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 22:25:46 -0400
Message-ID: <4CCF77B2.9080604@cn.fujitsu.com>
Date: Tue, 02 Nov 2010 10:30:10 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 7/7] KVM: KVM: don't break vcpu 'halt' state due
 to apfs
References: <4CCE8143.3090105@cn.fujitsu.com> <4CCE82BC.3090000@cn.fujitsu.com> <20101101125551.GD31722@redhat.com>
In-Reply-To: <20101101125551.GD31722@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 08:55 PM, Gleb Natapov wrote:

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2cfdf2d..f7aed95 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5295,8 +5295,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>  			{
>  				switch(vcpu->arch.mp_state) {
>  				case KVM_MP_STATE_HALTED:
> -					vcpu->arch.mp_state =
> -						KVM_MP_STATE_RUNNABLE;
> +					if (list_empty_careful(&vcpu->async_pf.done))
> +						vcpu->arch.mp_state =
> +							KVM_MP_STATE_RUNNABLE;

if nmi/interrupt and apfs completed event occur at the same time, we will miss to
exit halt sate. Maybe we can check the pending event here, see below patch please.

>  				case KVM_MP_STATE_RUNNABLE:
>  					vcpu->arch.apf.halted = false;
>  					break;
> @@ -6279,6 +6280,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  		vcpu->arch.fault.error_code = 0;
>  		vcpu->arch.fault.address = work->arch.token;
>  		kvm_inject_page_fault(vcpu);
> +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>  	}
>  }

Have a stupid question, why we make the vcpu runnable here? Sorry i don't know
kvm pv guest to much. :-(

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2044302..27a712b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5267,6 +5267,12 @@ out:
 	return r;
 }
 
+static bool kvm_vcpu_leave_halt_state(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.nmi_pending ||
+		(kvm_arch_interrupt_allowed(vcpu) &&
+		 kvm_cpu_has_interrupt(vcpu));
+}
 
 static int __vcpu_run(struct kvm_vcpu *vcpu)
 {
@@ -5299,8 +5305,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 			{
 				switch(vcpu->arch.mp_state) {
 				case KVM_MP_STATE_HALTED:
-					vcpu->arch.mp_state =
-						KVM_MP_STATE_RUNNABLE;
+					if (kvm_vcpu_leave_halt_state(vcpu))
+						vcpu->arch.mp_state =
+							KVM_MP_STATE_RUNNABLE;
 				case KVM_MP_STATE_RUNNABLE:
 					vcpu->arch.apf.halted = false;
 					break;
@@ -6113,9 +6120,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 		!vcpu->arch.apf.halted)
 		|| !list_empty_careful(&vcpu->async_pf.done)
 		|| vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED
-		|| vcpu->arch.nmi_pending ||
-		(kvm_arch_interrupt_allowed(vcpu) &&
-		 kvm_cpu_has_interrupt(vcpu));
+		|| kvm_vcpu_leave_halt_state(vcpu);
 }
 
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
