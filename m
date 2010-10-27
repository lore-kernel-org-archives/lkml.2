Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872Ab0J0KrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:47:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab0J0KrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:47:15 -0400
Date: Wed, 27 Oct 2010 12:44:12 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/8] KVM: don't touch vcpu stat after async pf is
 complete
Message-ID: <20101027104412.GO26191@redhat.com>
References: <4CC7EA7D.5020901@cn.fujitsu.com>
 <4CC7EB75.9030709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7EB75.9030709@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:05:57PM +0800, Xiao Guangrong wrote:
> Don't make a KVM_REQ_UNHALT request after async pf is completed since it
> can break guest's 'halt' instruction.
> 
Why is it a problem? CPU may be unhalted by different events so OS
shouldn't depend on it.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    1 +
>  arch/x86/kvm/x86.c              |    5 +++++
>  virt/kvm/async_pf.c             |    1 +
>  virt/kvm/kvm_main.c             |    7 +++++--
>  4 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1be0058..d01677b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -822,6 +822,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  				 struct kvm_async_pf *work);
>  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
>  			       struct kvm_async_pf *work);
> +void kvm_arch_async_pf_completion(struct kvm_vcpu *vcpu);
>  bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu);
>  extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0b2c420..c0e7ad0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6280,6 +6280,11 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +void kvm_arch_async_pf_completion(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.apf.halted = false;
> +}
> +
>  bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
>  {
>  	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index e213ca4..5307a32 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -142,6 +142,7 @@ bool kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>  	if (work->page)
>  		put_page(work->page);
>  	kmem_cache_free(async_pf_cache, work);
> +	kvm_arch_async_pf_completion(vcpu);
>  
>  	return true;
>  }
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d9aed28..23a8b06 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1347,11 +1347,14 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	for (;;) {
>  		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
>  
> -		if (kvm_arch_vcpu_runnable(vcpu) ||
> -		     kvm_check_async_pf_completion(vcpu)) {
> +		if (kvm_arch_vcpu_runnable(vcpu)) {
>  			kvm_make_request(KVM_REQ_UNHALT, vcpu);
>  			break;
>  		}
> +
> +		if (kvm_check_async_pf_completion(vcpu))
> +			break;
> +
>  		if (kvm_cpu_has_pending_timer(vcpu))
>  			break;
>  		if (signal_pending(current))
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
