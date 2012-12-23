Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab2LWPCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 10:02:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab2LWPCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 10:02:21 -0500
Date: Sun, 23 Dec 2012 17:02:17 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] KVM: x86: improve reexecute_instruction
Message-ID: <20121223150217.GS17584@redhat.com>
References: <50CC1F62.4050701@linux.vnet.ibm.com>
 <50CC2038.4060500@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CC2038.4060500@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 03:01:12PM +0800, Xiao Guangrong wrote:
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
>  arch/x86/kvm/paging_tmpl.h      |   23 +++++++++++-----
>  arch/x86/kvm/x86.c              |   58 +++++++++++++++++++++++++--------------
>  3 files changed, 60 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index dc87b65..487f0a1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -502,6 +502,13 @@ struct kvm_vcpu_arch {
>  		u64 msr_val;
>  		struct gfn_to_hva_cache data;
>  	} pv_eoi;
> +
> +	/*
> +	 * Cache the access info when fix page fault then use
> +	 * them to detect unhandeable instruction.
> +	 */
> +	gva_t fault_addr;
> +	bool target_gfn_is_pt;
>  };
> 
>  struct kvm_lpage_info {
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 0453fa0..b67fab3 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -506,21 +506,27 @@ out_gpte_changed:
>   * size to map the gfn which is used as PDPT.
>   */
>  static bool
> -FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
> +FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu, gva_t addr,
>  			      struct guest_walker *walker, int user_fault)
>  {
>  	int level;
>  	gfn_t mask = ~(KVM_PAGES_PER_HPAGE(walker->level) - 1);
> +	bool self_changed = false;
> 
>  	if (!(walker->pte_access & ACC_WRITE_MASK ||
>  	      (!is_write_protection(vcpu) && !user_fault)))
>  		return false;
> 
> -	for (level = walker->level; level <= walker->max_level; level++)
> -		if (!((walker->gfn ^ walker->table_gfn[level - 1]) & mask))
> -			return true;
> +	vcpu->arch.fault_addr = addr;
> 
> -	return false;
> +	for (level = walker->level; level <= walker->max_level; level++) {
> +		gfn_t gfn = walker->gfn ^ walker->table_gfn[level - 1];
> +
> +		self_changed |= !(gfn & mask);
> +		vcpu->arch.target_gfn_is_pt |= !gfn;
> +	}
> +
> +	return self_changed;
>  }
> 
>  /*
> @@ -548,7 +554,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>  	int level = PT_PAGE_TABLE_LEVEL;
>  	int force_pt_level;
>  	unsigned long mmu_seq;
> -	bool map_writable;
> +	bool map_writable, is_self_change_mapping;
> 
>  	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
> 
> @@ -576,9 +582,12 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>  		return 0;
>  	}
> 
> +	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu, addr,
> +				       &walker, user_fault);
> +
is_self_change_mapping() has a subtle side-effect by setting
vcpu->arch.target_gfn_is_pt. From reading the page_fault() function
you cannot guess why is_self_change_mapping() is not called inside "if
(walker.level >= PT_DIRECTORY_LEVEL)" since this is the only place where
its output is used. May be pass it pointer to target_gfn_is_pt as a
parameter to make it clear that return value is not the only output of
the function.

>  	if (walker.level >= PT_DIRECTORY_LEVEL)
>  		force_pt_level = mapping_level_dirty_bitmap(vcpu, walker.gfn)
> -		   || FNAME(is_self_change_mapping)(vcpu, &walker, user_fault);
> +		   || is_self_change_mapping;
>  	else
>  		force_pt_level = 1;
>  	if (!force_pt_level) {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bf66169..fc33563 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4756,29 +4756,25 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
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
> 
>  	if (!vcpu->arch.mmu.direct_map) {
> -		gpa = kvm_mmu_gva_to_gpa_read(vcpu, cr2, NULL);
> +		/*
> +		 * Write permission should be allowed since only
> +		 * write access need to be emulated.
> +		 */
> +		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
> +
> +		/*
> +		 * If the mapping is invalid in guest, let cpu retry
> +		 * it to generate fault.
> +		 */
>  		if (gpa == UNMAPPED_GVA)
> -			return true; /* let cpu generate fault */
> +			return true;
>  	}
Why not fold this change to if (!vcpu->arch.mmu.direct_map) into
previous patch where it was introduced. This looks independent of
what you are doing in this patch.

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
> @@ -4786,13 +4782,33 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
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
> +	return !(vcpu->arch.fault_addr == cr2 && vcpu->arch.target_gfn_is_pt);
Do you store fault_addr only to avoid using stale target_gfn_is_pt? If
yes why not reset target_gfn_is_pt to false at the beginning of a page
fault and get rid of fault_addr?

>  }
> 
>  static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
> -- 
> 1.7.7.6

--
			Gleb.
