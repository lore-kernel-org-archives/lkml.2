Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2LLE12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 23:27:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab2LLE11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 23:27:27 -0500
Date: Tue, 11 Dec 2012 21:47:51 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] KVM: MMU: move adjusting pte access for softmmu
 to FNAME(page_fault)
Message-ID: <20121211234751.GB14520@amt.cnet>
References: <50C5A747.1020105@linux.vnet.ibm.com>
 <50C5A774.1050601@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C5A774.1050601@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 05:12:20PM +0800, Xiao Guangrong wrote:
> Then, no mmu specified code exists in the common function and drop two
> parameters in set_spte
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c         |   47 ++++++++++++-------------------------------
>  arch/x86/kvm/paging_tmpl.h |   25 ++++++++++++++++++----
>  2 files changed, 33 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 01d7c2a..2a3c890 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2342,8 +2342,7 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>  }
> 
>  static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> -		    unsigned pte_access, int user_fault,
> -		    int write_fault, int level,
> +		    unsigned pte_access, int level,
>  		    gfn_t gfn, pfn_t pfn, bool speculative,
>  		    bool can_unsync, bool host_writable)
>  {
> @@ -2378,9 +2377,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> 
>  	spte |= (u64)pfn << PAGE_SHIFT;
> 
> -	if ((pte_access & ACC_WRITE_MASK)
> -	    || (!vcpu->arch.mmu.direct_map && write_fault
> -		&& !is_write_protection(vcpu) && !user_fault)) {
> +	if (pte_access & ACC_WRITE_MASK) {
> 
>  		/*
>  		 * There are two cases:
> @@ -2399,19 +2396,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> 
>  		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
> 
> -		if (!vcpu->arch.mmu.direct_map
> -		    && !(pte_access & ACC_WRITE_MASK)) {
> -			spte &= ~PT_USER_MASK;
> -			/*
> -			 * If we converted a user page to a kernel page,
> -			 * so that the kernel can write to it when cr0.wp=0,
> -			 * then we should prevent the kernel from executing it
> -			 * if SMEP is enabled.
> -			 */
> -			if (kvm_read_cr4_bits(vcpu, X86_CR4_SMEP))
> -				spte |= PT64_NX_MASK;
> -		}
> -
>  		/*
>  		 * Optimization: for pte sync, if spte was writable the hash
>  		 * lookup is unnecessary (and expensive). Write protection
> @@ -2442,18 +2426,15 @@ done:
> 
>  static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  			 unsigned pt_access, unsigned pte_access,
> -			 int user_fault, int write_fault,
> -			 int *emulate, int level, gfn_t gfn,
> -			 pfn_t pfn, bool speculative,
> -			 bool host_writable)
> +			 int write_fault, int *emulate, int level, gfn_t gfn,
> +			 pfn_t pfn, bool speculative, bool host_writable)
>  {
>  	int was_rmapped = 0;
>  	int rmap_count;
> 
> -	pgprintk("%s: spte %llx access %x write_fault %d"
> -		 " user_fault %d gfn %llx\n",
> +	pgprintk("%s: spte %llx access %x write_fault %d gfn %llx\n",
>  		 __func__, *sptep, pt_access,
> -		 write_fault, user_fault, gfn);
> +		 write_fault, gfn);
> 
>  	if (is_rmap_spte(*sptep)) {
>  		/*
> @@ -2477,9 +2458,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  			was_rmapped = 1;
>  	}
> 
> -	if (set_spte(vcpu, sptep, pte_access, user_fault, write_fault,
> -		      level, gfn, pfn, speculative, true,
> -		      host_writable)) {
> +	if (set_spte(vcpu, sptep, pte_access, level, gfn, pfn, speculative,
> +	      true, host_writable)) {
>  		if (write_fault)
>  			*emulate = 1;
>  		kvm_mmu_flush_tlb(vcpu);
> @@ -2571,10 +2551,9 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
>  		return -1;
> 
>  	for (i = 0; i < ret; i++, gfn++, start++)
> -		mmu_set_spte(vcpu, start, ACC_ALL,
> -			     access, 0, 0, NULL,
> -			     sp->role.level, gfn,
> -			     page_to_pfn(pages[i]), true, true);
> +		mmu_set_spte(vcpu, start, ACC_ALL, access, 0, NULL,
> +			     sp->role.level, gfn, page_to_pfn(pages[i]),
> +			     true, true);
> 
>  	return 0;
>  }
> @@ -2636,8 +2615,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  			unsigned pte_access = ACC_ALL;
> 
>  			mmu_set_spte(vcpu, iterator.sptep, ACC_ALL, pte_access,
> -				     0, write, &emulate,
> -				     level, gfn, pfn, prefault, map_writable);
> +				     write, &emulate, level, gfn, pfn,
> +				     prefault, map_writable);
>  			direct_pte_prefetch(vcpu, iterator.sptep);
>  			++vcpu->stat.pf_fixed;
>  			break;
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 891eb6d..ec481e9 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -330,7 +330,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	 * we call mmu_set_spte() with host_writable = true because
>  	 * pte_prefetch_gfn_to_pfn always gets a writable pfn.
>  	 */
> -	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
> +	mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0,
>  		     NULL, PT_PAGE_TABLE_LEVEL, gfn, pfn, true, true);
> 
>  	return true;
> @@ -405,7 +405,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
>   */
>  static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>  			 struct guest_walker *gw,
> -			 int user_fault, int write_fault, int hlevel,
> +			 int write_fault, int hlevel,
>  			 pfn_t pfn, bool map_writable, bool prefault)
>  {
>  	struct kvm_mmu_page *sp = NULL;
> @@ -478,7 +478,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
> 
>  	clear_sp_write_flooding_count(it.sptep);
>  	mmu_set_spte(vcpu, it.sptep, access, gw->pte_access,
> -		     user_fault, write_fault, &emulate, it.level,
> +		     write_fault, &emulate, it.level,
>  		     gw->gfn, pfn, prefault, map_writable);
>  	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
> 
> @@ -544,6 +544,21 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>  		return 0;
>  	}
> 
> +	if (write_fault && !(walker.pte_access & ACC_WRITE_MASK) &&
> +		  !is_write_protection(vcpu) && !user_fault) {
> +		walker.pte_access |= ACC_WRITE_MASK;
> +		walker.pte_access &= ~ACC_USER_MASK;
> +
> +		/*
> +		 * If we converted a user page to a kernel page,
> +		 * so that the kernel can write to it when cr0.wp=0,
> +		 * then we should prevent the kernel from executing it
> +		 * if SMEP is enabled.
> +		 */
> +		if (kvm_read_cr4_bits(vcpu, X86_CR4_SMEP))
> +			walker.pte_access &= ~ACC_EXEC_MASK;
> +	}

Don't think you should modify walker.pte_access here, since it can be
used afterwards (eg for handle_abnormal_pfn). 

BTW, your patch is fixing a bug: 

host_writable is ignored for CR0.WP emulation:

        if (host_writable)
                spte |= SPTE_HOST_WRITEABLE;
        else
                pte_access &= ~ACC_WRITE_MASK;

        spte |= (u64)pfn << PAGE_SHIFT;

        if ((pte_access & ACC_WRITE_MASK)
            || (!vcpu->arch.mmu.direct_map && write_fault
                && !is_write_protection(vcpu) && !user_fault)) {

