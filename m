Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850Ab0J0Km0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:42:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab0J0KmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:42:24 -0400
Date: Wed, 27 Oct 2010 12:42:10 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/8] KVM: avoid unnecessary wait for a async pf
Message-ID: <20101027104210.GN26191@redhat.com>
References: <4CC7EA7D.5020901@cn.fujitsu.com>
 <4CC7EB3A.6070002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7EB3A.6070002@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:04:58PM +0800, Xiao Guangrong wrote:
> In current code, it checks async pf completion out of the wait context,
> like this:
> 
> if (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
> 		    !vcpu->arch.apf.halted)
> 			r = vcpu_enter_guest(vcpu);
> 		else {
> 			......
> 			kvm_vcpu_block(vcpu)
> 			 ^- waiting until 'async_pf.done' is not empty
> }
> 	
> kvm_check_async_pf_completion(vcpu)
>  ^- delete list from async_pf.done
> 
> So, if we check aysnc pf completion first, it can be blocked at
> kvm_vcpu_block
> 
Correct, but it can be fixed by adding vcpu->arch.apf.halted = false; to
kvm_arch_async_page_present(), no?
Adding kvm_check_async_pf_completion() to arch independent kvm_vcpu_block()
constrains how other archs may implement async pf support IMO.
 
> Fixed by move the check into wait context
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/x86.c       |    3 ---
>  include/linux/kvm_host.h |    1 -
>  virt/kvm/async_pf.c      |    6 ++++--
>  virt/kvm/async_pf.h      |    6 ++++++
>  virt/kvm/kvm_main.c      |    3 ++-
>  5 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 16f42ff..0b2c420 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5321,8 +5321,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>  			vcpu->run->exit_reason = KVM_EXIT_INTR;
>  			++vcpu->stat.request_irq_exits;
>  		}
> -		
> -		kvm_check_async_pf_completion(vcpu);
>  
>  		if (signal_pending(current)) {
>  			r = -EINTR;
> @@ -6108,7 +6106,6 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>  {
>  	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
>  		!vcpu->arch.apf.halted)
> -		|| !list_empty_careful(&vcpu->async_pf.done)
>  		|| vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED
>  		|| vcpu->arch.nmi_pending ||
>  		(kvm_arch_interrupt_allowed(vcpu) &&
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ee4314e..0c1b7c5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -90,7 +90,6 @@ struct kvm_async_pf {
>  };
>  
>  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
> -void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
>  int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
>  		       struct kvm_arch_async_pf *arch);
>  int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 60df9e0..e213ca4 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -120,13 +120,13 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  	vcpu->async_pf.queued = 0;
>  }
>  
> -void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
> +bool kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_async_pf *work;
>  
>  	if (list_empty_careful(&vcpu->async_pf.done) ||
>  	    !kvm_arch_can_inject_async_page_present(vcpu))
> -		return;
> +		return false;
>  
>  	spin_lock(&vcpu->async_pf.lock);
>  	work = list_first_entry(&vcpu->async_pf.done, typeof(*work), link);
> @@ -142,6 +142,8 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>  	if (work->page)
>  		put_page(work->page);
>  	kmem_cache_free(async_pf_cache, work);
> +
> +	return true;
>  }
>  
>  int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
> diff --git a/virt/kvm/async_pf.h b/virt/kvm/async_pf.h
> index e7ef644..e21533c 100644
> --- a/virt/kvm/async_pf.h
> +++ b/virt/kvm/async_pf.h
> @@ -27,10 +27,16 @@
>  int kvm_async_pf_init(void);
>  void kvm_async_pf_deinit(void);
>  void kvm_async_pf_vcpu_init(struct kvm_vcpu *vcpu);
> +bool kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
> +
>  #else
>  #define kvm_async_pf_init() (0)
>  #define kvm_async_pf_deinit() do{}while(0)
>  #define kvm_async_pf_vcpu_init(C) do{}while(0)
> +static inline bool kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
>  #endif
>  
>  #endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 88d869e..d9aed28 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1347,7 +1347,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	for (;;) {
>  		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
>  
> -		if (kvm_arch_vcpu_runnable(vcpu)) {
> +		if (kvm_arch_vcpu_runnable(vcpu) ||
> +		     kvm_check_async_pf_completion(vcpu)) {
>  			kvm_make_request(KVM_REQ_UNHALT, vcpu);
>  			break;
>  		}
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
