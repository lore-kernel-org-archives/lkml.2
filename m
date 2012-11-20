Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2KTML5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:11:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab2KTMLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:11:54 -0500
Date: Tue, 20 Nov 2012 14:11:51 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: x86: clean up reexecute_instruction
Message-ID: <20121120121151.GH21208@redhat.com>
References: <50AAC77C.8040505@linux.vnet.ibm.com>
 <50AAC7A8.6010309@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AAC7A8.6010309@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 07:58:32AM +0800, Xiao Guangrong wrote:
> Little cleanup for reexecute_instruction, also use gpa_to_gfn in
> retry_instruction
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/x86.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 52ae8b5..7be8452 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4477,19 +4477,18 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
>  	if (tdp_enabled)
>  		return false;
> 
> +	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
> +	if (gpa == UNMAPPED_GVA)
> +		return true; /* let cpu generate fault */
> +
>  	/*
>  	 * if emulation was due to access to shadowed page table
>  	 * and it failed try to unshadow page and re-enter the
>  	 * guest to let CPU execute the instruction.
>  	 */
> -	if (kvm_mmu_unprotect_page_virt(vcpu, gva))
> +	if (kvm_mmu_unprotect_page(vcpu->kvm, c(gpa)))
What's c()? Should be gpa_to_gfn(gpa)?

>  		return true;
> 
> -	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
> -
> -	if (gpa == UNMAPPED_GVA)
> -		return true; /* let cpu generate fault */
> -
>  	/*
>  	 * Do not retry the unhandleable instruction if it faults on the
>  	 * readonly host memory, otherwise it will goto a infinite loop:
> @@ -4544,7 +4543,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>  	if (!vcpu->arch.mmu.direct_map)
>  		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
> 
> -	kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
> +	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> 
>  	return true;
>  }
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
