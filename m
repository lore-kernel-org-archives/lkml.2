Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3ADXiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 18:38:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab3ADXit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 18:38:49 -0500
Date: Fri, 4 Jan 2013 20:44:32 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/5] KVM: x86: improve reexecute_instruction
Message-ID: <20130104224432.GB13481@amt.cnet>
References: <50E6DEDC.7040800@linux.vnet.ibm.com>
 <50E6DFAB.6050008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E6DFAB.6050008@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 09:56:59PM +0800, Xiao Guangrong wrote:
> The current reexecute_instruction can not well detect the failed instruction
> emulation. It allows guest to retry all the instructions except it accesses
> on error pfn
> 
> For example, some cases are nested-write-protect - if the page we want to
> write is used as PDE but it chains to itself. Under this case, we should
> stop the emulation and report the case to userspace
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    7 +++++
>  arch/x86/kvm/paging_tmpl.h      |   24 +++++++++++++-----
>  arch/x86/kvm/x86.c              |   50 ++++++++++++++++++++++++--------------
>  3 files changed, 55 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c431b33..de229e6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -502,6 +502,13 @@ struct kvm_vcpu_arch {
>  		u64 msr_val;
>  		struct gfn_to_hva_cache data;
>  	} pv_eoi;
> +
> +	/*
> +	 * Indicate whether the gfn is used as page table in guest which
> +	 * is set when fix page fault and used to detect unhandeable
> +	 * instruction.
> +	 */
> +	bool target_gfn_is_pt;
>  };
> 
>  struct kvm_lpage_info {
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 0453fa0..ca1be75 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -507,20 +507,27 @@ out_gpte_changed:
>   */
>  static bool
>  FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
> -			      struct guest_walker *walker, int user_fault)
> +			      struct guest_walker *walker, int user_fault,
> +			      bool *target_gfn_is_pt)
>  {
>  	int level;
>  	gfn_t mask = ~(KVM_PAGES_PER_HPAGE(walker->level) - 1);
> +	bool self_changed = false;
> +
> +	*target_gfn_is_pt = false;
> 
>  	if (!(walker->pte_access & ACC_WRITE_MASK ||
>  	      (!is_write_protection(vcpu) && !user_fault)))
>  		return false;
> 
> -	for (level = walker->level; level <= walker->max_level; level++)
> -		if (!((walker->gfn ^ walker->table_gfn[level - 1]) & mask))
> -			return true;
> +	for (level = walker->level; level <= walker->max_level; level++) {
> +		gfn_t gfn = walker->gfn ^ walker->table_gfn[level - 1];
> +
> +		self_changed |= !(gfn & mask);
> +		*target_gfn_is_pt |= !gfn;
> +	}
> 
> -	return false;
> +	return self_changed;
>  }
> 
>  /*
> @@ -548,7 +555,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>  	int level = PT_PAGE_TABLE_LEVEL;
>  	int force_pt_level;
>  	unsigned long mmu_seq;
> -	bool map_writable;
> +	bool map_writable, is_self_change_mapping;
> 
>  	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
> 
> @@ -576,9 +583,12 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>  		return 0;
>  	}
> 
> +	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
> +		      &walker, user_fault, &vcpu->arch.target_gfn_is_pt);
> +
>  	if (walker.level >= PT_DIRECTORY_LEVEL)
>  		force_pt_level = mapping_level_dirty_bitmap(vcpu, walker.gfn)
> -		   || FNAME(is_self_change_mapping)(vcpu, &walker, user_fault);
> +		   || is_self_change_mapping;
>  	else
>  		force_pt_level = 1;
>  	if (!force_pt_level) {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b0a3678..44c6992 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4756,15 +4756,8 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
>  static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>  {
>  	gpa_t gpa = cr2;
> +	gfn_t gfn;
>  	pfn_t pfn;
> -	unsigned int indirect_shadow_pages;
> -
> -	spin_lock(&vcpu->kvm->mmu_lock);
> -	indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
> -	spin_unlock(&vcpu->kvm->mmu_lock);
> -
> -	if (!indirect_shadow_pages)
> -		return false;

This renders the previous patch obsolete, pretty much (please fold).

>  	if (!vcpu->arch.mmu.direct_map) {
>  		/*
> @@ -4781,13 +4774,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>  			return true;
>  	}
> 
> -	/*
> -	 * if emulation was due to access to shadowed page table
> -	 * and it failed try to unshadow page and re-enter the
> -	 * guest to let CPU execute the instruction.
> -	 */
> -	if (kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
> -		return true;
> +	gfn = gpa_to_gfn(gpa);
> 
>  	/*
>  	 * Do not retry the unhandleable instruction if it faults on the
> @@ -4795,13 +4782,38 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>  	 * retry instruction -> write #PF -> emulation fail -> retry
>  	 * instruction -> ...
>  	 */
> -	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
> -	if (!is_error_noslot_pfn(pfn)) {
> -		kvm_release_pfn_clean(pfn);
> +	pfn = gfn_to_pfn(vcpu->kvm, gfn);
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

!direct_map?

> +		unsigned int indirect_shadow_pages;
> +
> +		spin_lock(&vcpu->kvm->mmu_lock);
> +		indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
> +		spin_unlock(&vcpu->kvm->mmu_lock);
> +
> +		if (indirect_shadow_pages)
> +			kvm_mmu_unprotect_page(vcpu->kvm, gfn);
> +
>  		return true;
>  	}
> 
> -	return false;
> +	kvm_mmu_unprotect_page(vcpu->kvm, gfn);
> +
> +	/* If the target gfn is used as page table, the fault can
> +	 * not be avoided by unprotecting shadow page and it will
> +	 * be reported to userspace.
> +	 */
> +	return !vcpu->arch.target_gfn_is_pt;
>  }

The idea was

How about recording the gfn number for shadow pages that have been
shadowed in the current pagefault run? (which is cheap, compared to
shadowing these pages).

If failed instruction emulation is write to one of these gfns, then
fail.
