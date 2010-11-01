Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0KAMz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501Ab0KAMz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:55:57 -0400
Date: Mon, 1 Nov 2010 14:55:51 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 7/7] KVM: KVM: don't break vcpu 'halt' state due
 to apfs
Message-ID: <20101101125551.GD31722@redhat.com>
References: <4CCE8143.3090105@cn.fujitsu.com>
 <4CCE82BC.3090000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCE82BC.3090000@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 05:05:00PM +0800, Xiao Guangrong wrote:
> Don't make a KVM_REQ_UNHALT request after async pf is completed since it
> can break guest's 'HLT' instruction.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/x86.c       |   13 ++++++++++---
>  include/linux/kvm_host.h |    6 ++++++
>  virt/kvm/kvm_main.c      |    9 ++++++++-
>  3 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 189664a..c57fb38 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6105,13 +6105,20 @@ void kvm_arch_flush_shadow(struct kvm *kvm)
>  
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>  {
> -	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
> +	if ((vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
>  		!vcpu->arch.apf.halted)
> -		|| !list_empty_careful(&vcpu->async_pf.done)
>  		|| vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED
>  		|| vcpu->arch.nmi_pending ||
>  		(kvm_arch_interrupt_allowed(vcpu) &&
> -		 kvm_cpu_has_interrupt(vcpu));
> +		 kvm_cpu_has_interrupt(vcpu)))
> +		return 1;
> +
> +	if (!list_empty_careful(&vcpu->async_pf.done)) {
> +		vcpu->arch.apf.halted = false;
> +		return 2;
> +	}
kvm_arch_vcpu_runnable() shouldn't change vcpu state. I don't like the
way it propagates internal x86 state to kvm_vcpu_block() too.
May be what you are looking for is the patch below? (not tested).

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2cfdf2d..f7aed95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5295,8 +5295,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 			{
 				switch(vcpu->arch.mp_state) {
 				case KVM_MP_STATE_HALTED:
-					vcpu->arch.mp_state =
-						KVM_MP_STATE_RUNNABLE;
+					if (list_empty_careful(&vcpu->async_pf.done))
+						vcpu->arch.mp_state =
+							KVM_MP_STATE_RUNNABLE;
 				case KVM_MP_STATE_RUNNABLE:
 					vcpu->arch.apf.halted = false;
 					break;
@@ -6279,6 +6280,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 		vcpu->arch.fault.error_code = 0;
 		vcpu->arch.fault.address = work->arch.token;
 		kvm_inject_page_fault(vcpu);
+		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	}
 }
 
--
			Gleb.
