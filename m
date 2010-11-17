Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935062Ab0KQRg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:36:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321Ab0KQRg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:36:28 -0500
Date: Wed, 17 Nov 2010 14:55:15 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] KVM: MMU: cleanup update_pte, pte_prefetch and
 sync_page functions
Message-ID: <20101117165515.GF18959@amt.cnet>
References: <4CE355A0.6020907@cn.fujitsu.com>
 <4CE35687.1020109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE35687.1020109@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 12:13:59PM +0800, Xiao Guangrong wrote:
> Abstract the same operation to cleanup them
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c         |    3 --
>  arch/x86/kvm/paging_tmpl.h |   70 ++++++++++++++++++++++---------------------
>  2 files changed, 36 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 0668f4b..c513afc 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3082,9 +3082,6 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
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
> index 60f00db..01a00b0 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -299,25 +299,43 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
>  					addr, access);
>  }
>  
> +static bool FNAME(map_invalid_gpte)(struct kvm_vcpu *vcpu,
> +				    struct kvm_mmu_page *sp, u64 *spte,
> +				    pt_element_t gpte)
> +{
> +	u64 nonpresent = shadow_trap_nonpresent_pte;
> +
> +	if (is_rsvd_bits_set(&vcpu->arch.mmu, gpte, PT_PAGE_TABLE_LEVEL))
> +		goto no_present;
> +
> +	if (!is_present_gpte(gpte)) {
> +		if (!sp->unsync)
> +			nonpresent = shadow_notrap_nonpresent_pte;
> +		goto no_present;
> +	}
> +
> +	if (!(gpte & PT_ACCESSED_MASK))
> +		goto no_present;
> +
> +	return false;
> +
> +no_present:
> +	if (drop_spte(vcpu->kvm, spte, nonpresent))
> +		kvm_flush_remote_tlbs(vcpu->kvm);
> +	return true;
> +}

TLB flush not necessary. Looks fine otherwise, please rebase.

