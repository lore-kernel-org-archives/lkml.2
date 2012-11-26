Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab2KZXRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:17:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab2KZXRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:17:04 -0500
Date: Mon, 26 Nov 2012 20:41:05 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: x86: improve reexecute_instruction
Message-ID: <20121126224105.GB10634@amt.cnet>
References: <50AAC77C.8040505@linux.vnet.ibm.com>
 <50AAC7F9.7050305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AAC7F9.7050305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 07:59:53AM +0800, Xiao Guangrong wrote:
> The current reexecute_instruction can not well detect the failed instruction
> emulation. It allows guest to retry all the instructions except it accesses
> on error pfn.
> 
> For example, some cases are nested-write-protect - if the page we want to
> write is used as PDE but it chains to itself. Under this case, we should
> stop the emulation and report the case to userspace.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    2 +
>  arch/x86/kvm/paging_tmpl.h      |    2 +
>  arch/x86/kvm/x86.c              |   54 ++++++++++++++++++++++++++++-----------
>  3 files changed, 43 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b2e11f4..c5eb52f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -566,6 +566,8 @@ struct kvm_arch {
>  	u64 hv_guest_os_id;
>  	u64 hv_hypercall;
> 
> +	/* synchronizing reexecute_instruction and page fault path. */
> +	u64 page_fault_count;
>  	#ifdef CONFIG_KVM_MMU_AUDIT
>  	int audit_point;
>  	#endif
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 891eb6d..d55ad89 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -568,6 +568,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>  	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
>  		goto out_unlock;
> 
> +	vcpu->kvm->arch.page_fault_count++;
> +
>  	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
>  	kvm_mmu_free_some_pages(vcpu);
>  	if (!force_pt_level)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5fe72cc..2fe484b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4473,37 +4473,61 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>  {
>  	gpa_t gpa = cr2;
>  	pfn_t pfn;
> -
> -	if (!ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
> -		return false;
> +	u64 page_fault_count;
> +	int emulate;
> 
>  	if (!vcpu->arch.mmu.direct_map) {
>  		gpa = kvm_mmu_gva_to_gpa_read(vcpu, cr2, NULL);
> +		/*
> +		 * If the mapping is invalid in guest, let cpu retry
> +		 * it to generate fault.
> +		 */
>  		if (gpa == UNMAPPED_GVA)
> -			return true; /* let cpu generate fault */
> +			return true;
>  	}
> 
>  	/*
> -	 * if emulation was due to access to shadowed page table
> -	 * and it failed try to unshadow page and re-enter the
> -	 * guest to let CPU execute the instruction.
> -	 */
> -	if (kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
> -		return true;
> -
> -	/*
>  	 * Do not retry the unhandleable instruction if it faults on the
>  	 * readonly host memory, otherwise it will goto a infinite loop:
>  	 * retry instruction -> write #PF -> emulation fail -> retry
>  	 * instruction -> ...
>  	 */
>  	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
> -	if (!is_error_noslot_pfn(pfn)) {
> -		kvm_release_pfn_clean(pfn);
> +
> +	/*
> +	 * If the instruction failed on the error pfn, it can not be fixed,
> +	 * report the error to userspace.
> +	 */
> +	if (is_error_noslot_pfn(pfn))
> +		return false;
> +
> +	kvm_release_pfn_clean(pfn);
> +
> +	/* The instructions are well-emulated on direct mmu. */
> +	if (vcpu->arch.mmu.direct_map) {
> +		if (ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
> +			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> +
>  		return true;
>  	}
> 
> -	return false;
> +again:
> +	page_fault_count = ACCESS_ONCE(vcpu->kvm->arch.page_fault_count);
> +
> +	/*
> +	 * if emulation was due to access to shadowed page table
> +	 * and it failed try to unshadow page and re-enter the
> +	 * guest to let CPU execute the instruction.
> +	 */
> +	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> +	emulate = vcpu->arch.mmu.page_fault(vcpu, cr3, PFERR_WRITE_MASK, false);

Can you explain what is the objective here?

> +	/* The page fault path called above can increase the count. */
> +	if (page_fault_count + 1 !=
> +	      ACCESS_ONCE(vcpu->kvm->arch.page_fault_count))
> +		goto again;
> +
> +	return !emulate;
>  }
> 
>  static bool retry_instruction(struct x86_emulate_ctxt *ctxt,

