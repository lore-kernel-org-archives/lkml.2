Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0KPUxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:53:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab0KPUw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:52:59 -0500
Date: Tue, 16 Nov 2010 18:52:23 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: MMU: cleanup update_pte, pte_prefetch and
 sync_page functions
Message-ID: <20101116205223.GB24156@amt.cnet>
References: <4CDD173E.8010706@cn.fujitsu.com>
 <4CDD187A.9010609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDD187A.9010609@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 06:35:38PM +0800, Xiao Guangrong wrote:
> Some operation of these functions is very similar, so introduce a
> common function to cleanup them
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c         |    3 -
>  arch/x86/kvm/paging_tmpl.h |  191 ++++++++++++++++++++++++-------------------
>  2 files changed, 107 insertions(+), 87 deletions(-)

This makes the code more complicated and error prone IMO, because there
are specialities of 

> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 94d157f..d0bcca2 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3108,9 +3108,6 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
>  		return;
>          }
>  
> -	if (is_rsvd_bits_set(&vcpu->arch.mmu, *(u64 *)new, PT_PAGE_TABLE_LEVEL))
> -		return;
> -
>  	++vcpu->kvm->stat.mmu_pte_updated;
>  	if (!sp->role.cr4_pae)
>  		paging32_update_pte(vcpu, sp, spte, new);
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 952357a..1a1a0b9 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -299,42 +299,90 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
>  					addr, access);
>  }
>  
> -static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> -			      u64 *spte, const void *pte)
> +static bool FNAME(fetch_guest_pte)(struct kvm_vcpu *vcpu,
> +				   struct kvm_mmu_page *sp, u64 *spte,
> +				   bool clear_unsync, pt_element_t gpte,
> +				   pfn_t (get_pfn)(struct kvm_vcpu *, u64 *,
> +					  pt_element_t, unsigned, bool *))
>  {
> -	pt_element_t gpte;
>  	unsigned pte_access;
> +	u64 nonpresent = shadow_trap_nonpresent_pte;
> +	gfn_t gfn;
>  	pfn_t pfn;
> -	u64 new_spte;
> +	bool dirty, host_writeable;
>  
> -	gpte = *(const pt_element_t *)pte;
> -	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
> -		if (!is_present_gpte(gpte)) {
> -			if (sp->unsync)
> -				new_spte = shadow_trap_nonpresent_pte;
> -			else
> -				new_spte = shadow_notrap_nonpresent_pte;
> -			__set_spte(spte, new_spte);
> -		}
> -		return;
> +	if (!is_present_gpte(gpte) ||
> +	      is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL)) {
> +		if (!sp->unsync && !clear_unsync)
> +			nonpresent = shadow_notrap_nonpresent_pte;
> +		goto no_present;
>  	}
> -	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
> +
> +	if (!(gpte & PT_ACCESSED_MASK))
> +		goto no_present;
> +
>  	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte);
> +	gfn = gpte_to_gfn(gpte);
> +	dirty = is_dirty_gpte(gpte);
> +	pfn = get_pfn(vcpu, spte, gpte, pte_access, &host_writeable);
> +
> +	if (is_error_pfn(pfn))
> +		goto no_present;
> +
> +	if (!host_writeable)
> +		pte_access &= ~ACC_WRITE_MASK;
> +
> +	if (spte_to_pfn(*spte) == pfn)
> +		set_spte(vcpu, spte, pte_access, 0, 0,
> +			 dirty, PT_PAGE_TABLE_LEVEL, gfn,
> +			 pfn, true, false, host_writeable);
> +	else
> +		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
> +			     dirty, NULL, PT_PAGE_TABLE_LEVEL, gfn,
> +			     pfn, true, host_writeable);

For example, the update path should always go through mmu_set_spte to
update last_pte_updated, last_pte_gfn.

Also the callbacks make it harder to read the code. Maybe the
unification works if you use common functions for common parts.

