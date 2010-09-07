Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab0IGRui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:50:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0IGRuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 13:50:37 -0400
Date: Tue, 7 Sep 2010 14:48:05 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/27] KVM: MMU: Make walk_addr_generic capable for
 two-level walking
Message-ID: <20100907174805.GA11215@amt.cnet>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
 <1283788566-29186-15-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283788566-29186-15-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 05:55:53PM +0200, Joerg Roedel wrote:
> This patch uses kvm_read_guest_page_tdp to make the
> walk_addr_generic functions suitable for two-level page
> table walking.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |   27 ++++++++++++++++++++-------
>  1 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index cd59af1..a5b5759 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -124,6 +124,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	unsigned index, pt_access, uninitialized_var(pte_access);
>  	gpa_t pte_gpa;
>  	bool eperm, present, rsvd_fault;
> +	int offset;
> +	u32 error = 0;
>  
>  	trace_kvm_mmu_pagetable_walk(addr, write_fault, user_fault,
>  				     fetch_fault);
> @@ -153,12 +155,13 @@ walk:
>  		index = PT_INDEX(addr, walker->level);
>  
>  		table_gfn = gpte_to_gfn(pte);
> -		pte_gpa = gfn_to_gpa(table_gfn);
> -		pte_gpa += index * sizeof(pt_element_t);
> +		offset    = index * sizeof(pt_element_t);
> +		pte_gpa   = gfn_to_gpa(table_gfn) + offset;
>  		walker->table_gfn[walker->level - 1] = table_gfn;
>  		walker->pte_gpa[walker->level - 1] = pte_gpa;
>  
> -		if (kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte))) {
> +		if (kvm_read_guest_page_mmu(vcpu, mmu, table_gfn, &pte, offset,
> +					    sizeof(pte), &error)) {
>  			present = false;
>  			break;
>  		}

If there is failure reading the nested page tables here, you fill
vcpu->arch.fault. But the nested fault error values will be overwritten
at the end of walk_addr() by the original fault values?

> @@ -209,15 +212,25 @@ walk:
>  				is_large_pte(pte) &&
>  				mmu->root_level == PT64_ROOT_LEVEL)) {
>  			int lvl = walker->level;
> +			gpa_t real_gpa;
> +			gfn_t gfn;
>  
> -			walker->gfn = gpte_to_gfn_lvl(pte, lvl);
> -			walker->gfn += (addr & PT_LVL_OFFSET_MASK(lvl))
> -					>> PAGE_SHIFT;
> +			gfn = gpte_to_gfn_lvl(pte, lvl);
> +			gfn += (addr & PT_LVL_OFFSET_MASK(lvl)) >> PAGE_SHIFT;
>  
>  			if (PTTYPE == 32 &&
>  			    walker->level == PT_DIRECTORY_LEVEL &&
>  			    is_cpuid_PSE36())
> -				walker->gfn += pse36_gfn_delta(pte);
> +				gfn += pse36_gfn_delta(pte);
> +
> +			real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn),
> +						      &error);
> +			if (real_gpa == UNMAPPED_GVA) {
> +				walker->error_code = error;
> +				return 0;
> +			}
> +
> +			walker->gfn = real_gpa >> PAGE_SHIFT;
>  
>  			break;
>  		}
> -- 
> 1.7.0.4
> 
