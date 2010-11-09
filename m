Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab0KIIEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 03:04:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab0KIIEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 03:04:02 -0500
Date: Tue, 9 Nov 2010 10:03:57 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: MMU: don not retry #PF for nonpaging guest
Message-ID: <20101109080357.GI9036@redhat.com>
References: <4CD28B5F.1040205@cn.fujitsu.com>
 <4CD28BCA.1060907@cn.fujitsu.com>
 <20101104103548.GE6018@redhat.com>
 <4CD39886.4050909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD39886.4050909@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 01:39:18PM +0800, Xiao Guangrong wrote:
> On 11/04/2010 06:35 PM, Gleb Natapov wrote:
> > On Thu, Nov 04, 2010 at 06:32:42PM +0800, Xiao Guangrong wrote:
> >> nonpaing guest's 'direct_map' is also true, retry #PF for those
> >> guests is useless, so use 'tdp_enabled' instead
> >>
> > nonpaging guest will not attempt async pf. 
> 
> Ah, my mistake, but why we can not attempt async pf for nonpaging guest?
> 
> > And by checking tdp_enabled
> > here instead of direct_map we will screw nested ntp.
> > 
> 
> It looks like something broken: apfs can generated in L2 guest (nested ntp guest)
> and be retried in L1 guest.
> 
OK now when Xiao explained me the problem privately I can review this.

> Below patch fix it and let nonpaging guest support async pf. I'll post it properly
> if you like. :-)
> 
Apf for nonpaging guest should be separate patch of course.

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7f20f2c..606978e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -600,6 +600,7 @@ struct kvm_x86_ops {
>  struct kvm_arch_async_pf {
>  	u32 token;
>  	gfn_t gfn;
> +	bool softmmu;
>  };
>  
>  extern struct kvm_x86_ops *kvm_x86_ops;
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index f3fad4f..48ca312 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
>  static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
> @@ -2602,6 +2607,7 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
>  	struct kvm_arch_async_pf arch;
>  	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
>  	arch.gfn = gfn;
> +	arch.softmmu = mmu_is_softmmu(vcpu);
>  
We can do:
        if (mmu_is_nested(vcpu))
		gva = vcpu->mmu.gva_to_gpa(gva);
And this should fix everything no?

>  	return kvm_setup_async_pf(vcpu, gva, gfn, &arch);
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2044302..d826d78 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6172,9 +6172,10 @@ EXPORT_SYMBOL_GPL(kvm_set_rflags);
>  
>  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  {
> +	bool softmmu = mmu_is_softmmu(vcpu);
>  	int r;
>  
> -	if (!vcpu->arch.mmu.direct_map || is_error_page(work->page))
> +	if (softmmu || work->arch.softmmu || is_error_page(work->page))
>  		return;
>  
>  	r = kvm_mmu_reload(vcpu);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2cea414..48796c7 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -55,6 +55,11 @@ static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)
>  	return vcpu->arch.walk_mmu == &vcpu->arch.nested_mmu;
>  }
>  
> +static inline bool mmu_is_softmmu(struct kvm_vcpu *vcpu)
> +{
> +	return !tdp_enabled || mmu_is_nested(vcpu);
> +}
> +
Isn't this the same as checking vcpu->arch.mmu.direct_map? The only
difference that this will be true for nonpaging mode too but this is
even better since we can prefault in nonpaging mode.

--
			Gleb.
