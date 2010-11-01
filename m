Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab0KAJZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab0KAJZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:25:34 -0400
Date: Mon, 1 Nov 2010 11:25:30 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 4/7] KVM: avoid unnecessary wait for a async pf
Message-ID: <20101101092530.GZ26191@redhat.com>
References: <4CCE8143.3090105@cn.fujitsu.com>
 <4CCE81E8.6020001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCE81E8.6020001@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 05:01:28PM +0800, Xiao Guangrong wrote:
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
> Fixed by mark the vcpu is unhalted in kvm_check_async_pf_completion()
> path
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Gleb Natapov <gleb@redhat.com>

> ---
>  arch/x86/kvm/x86.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b543f4..4da8485 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6280,6 +6280,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  		vcpu->arch.fault.address = work->arch.token;
>  		kvm_inject_page_fault(vcpu);
>  	}
> +	vcpu->arch.apf.halted = false;
>  }
>  
>  bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
> -- 
> 1.7.0.4

--
			Gleb.
