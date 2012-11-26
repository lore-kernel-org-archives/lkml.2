Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab2KZXRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:17:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab2KZXRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:17:06 -0500
Date: Mon, 26 Nov 2012 20:37:12 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: x86: let reexecute_instruction work for tdp
Message-ID: <20121126223712.GA10634@amt.cnet>
References: <50AAC77C.8040505@linux.vnet.ibm.com>
 <50AAC7CE.2050506@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AAC7CE.2050506@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 07:59:10AM +0800, Xiao Guangrong wrote:
> Currently, reexecute_instruction refused to retry all instructions. If
> nested npt is used, the emulation may be caused by shadow page, it can
> be fixed by dropping the shadow page
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/x86.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7be8452..5fe72cc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4469,17 +4469,19 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
>  	return r;
>  }
> 
> -static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
> +static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>  {
> -	gpa_t gpa;
> +	gpa_t gpa = cr2;
>  	pfn_t pfn;
> 
> -	if (tdp_enabled)
> +	if (!ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
>  		return false;

How is indirect_shadow_pages protected? Why is ACCESS_ONCE() being used
to read it?

> -	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
> -	if (gpa == UNMAPPED_GVA)
> -		return true; /* let cpu generate fault */
> +	if (!vcpu->arch.mmu.direct_map) {
> +		gpa = kvm_mmu_gva_to_gpa_read(vcpu, cr2, NULL);
> +		if (gpa == UNMAPPED_GVA)
> +			return true; /* let cpu generate fault */
> +	}
> 
>  	/*
>  	 * if emulation was due to access to shadowed page table
> -- 
> 1.7.7.6
