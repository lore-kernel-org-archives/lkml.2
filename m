Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0INW4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:56:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab0INW4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:56:47 -0400
Date: Tue, 14 Sep 2010 19:08:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: MMU: Use base_role.nxe for mmu.nx
Message-ID: <20100914220836.GA3553@amt.cnet>
References: <1284479173-4515-1-git-send-email-joerg.roedel@amd.com>
 <1284479173-4515-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284479173-4515-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 05:46:13PM +0200, Joerg Roedel wrote:
> This patch removes the mmu.nx field and uses the equivalent
> field mmu.base_role.nxe instead.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    2 --
>  arch/x86/kvm/mmu.c              |   27 +++++++++++++--------------
>  arch/x86/kvm/paging_tmpl.h      |    4 ++--
>  arch/x86/kvm/x86.c              |    3 ---
>  4 files changed, 15 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8a83177..50506be 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -259,8 +259,6 @@ struct kvm_mmu {
>  	u64 *lm_root;
>  	u64 rsvd_bits_mask[2][4];
>  
> -	bool nx;
> -
>  	u64 pdptrs[4]; /* pae */
>  };
>  
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 3ce56bf..21d2983 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -238,7 +238,7 @@ static int is_cpuid_PSE36(void)
>  
>  static int is_nx(struct kvm_vcpu *vcpu)
>  {
> -	return vcpu->arch.efer & EFER_NX;
> +	return !!(vcpu->arch.efer & EFER_NX);
>  }
>  
>  static int is_shadow_present_pte(u64 pte)
> @@ -2634,7 +2634,7 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu,
>  	context->shadow_root_level = PT32E_ROOT_LEVEL;
>  	context->root_hpa = INVALID_PAGE;
>  	context->direct_map = true;
> -	context->nx = false;
> +	context->base_role.nxe = 0;
>  	return 0;
>  }
>  
> @@ -2688,7 +2688,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
>  	int maxphyaddr = cpuid_maxphyaddr(vcpu);
>  	u64 exb_bit_rsvd = 0;
>  
> -	if (!context->nx)
> +	if (!context->base_role.nxe)
>  		exb_bit_rsvd = rsvd_bits(63, 63);
>  	switch (level) {
>  	case PT32_ROOT_LEVEL:
> @@ -2747,7 +2747,7 @@ static int paging64_init_context_common(struct kvm_vcpu *vcpu,
>  					struct kvm_mmu *context,
>  					int level)
>  {
> -	context->nx = is_nx(vcpu);
> +	context->base_role.nxe = is_nx(vcpu);
>  
>  	reset_rsvds_bits_mask(vcpu, context, level);
>  
> @@ -2775,7 +2775,7 @@ static int paging64_init_context(struct kvm_vcpu *vcpu,
>  static int paging32_init_context(struct kvm_vcpu *vcpu,
>  				 struct kvm_mmu *context)
>  {
> -	context->nx = false;
> +	context->base_role.nxe = 0;
>  
>  	reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
>  
> @@ -2815,24 +2815,23 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
>  	context->get_cr3 = get_cr3;
>  	context->inject_page_fault = kvm_inject_page_fault;
> -	context->nx = is_nx(vcpu);
>  
>  	if (!is_paging(vcpu)) {
> -		context->nx = false;
> +		context->base_role.nxe = 0;
>  		context->gva_to_gpa = nonpaging_gva_to_gpa;
>  		context->root_level = 0;
>  	} else if (is_long_mode(vcpu)) {
> -		context->nx = is_nx(vcpu);
> +		context->base_role.nxe = is_nx(vcpu);
>  		reset_rsvds_bits_mask(vcpu, context, PT64_ROOT_LEVEL);
>  		context->gva_to_gpa = paging64_gva_to_gpa;
>  		context->root_level = PT64_ROOT_LEVEL;
>  	} else if (is_pae(vcpu)) {
> -		context->nx = is_nx(vcpu);
> +		context->base_role.nxe = is_nx(vcpu);
>  		reset_rsvds_bits_mask(vcpu, context, PT32E_ROOT_LEVEL);
>  		context->gva_to_gpa = paging64_gva_to_gpa;
>  		context->root_level = PT32E_ROOT_LEVEL;
>  	} else {
> -		context->nx = false;
> +		context->base_role.nxe = 0;
>  		reset_rsvds_bits_mask(vcpu, context, PT32_ROOT_LEVEL);
>  		context->gva_to_gpa = paging32_gva_to_gpa;
>  		context->root_level = PT32_ROOT_LEVEL;

For tdp better set base_role.nxe to zero, otherwise duplicate tdp
pagetables can be created if the guest switches between nx/non-nx.

