Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab0KVJ2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 04:28:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab0KVJ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 04:28:14 -0500
Message-ID: <4CEA37A6.8040204@redhat.com>
Date: Mon, 22 Nov 2010 11:28:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] KVM: MMU: abstract invalid guest pte mapping
References: <4CE63CF4.80502@cn.fujitsu.com> <4CE63DB3.9010100@cn.fujitsu.com>
In-Reply-To: <4CE63DB3.9010100@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2010 11:04 AM, Xiao Guangrong wrote:
> Introduce a common function to map invalid gpte
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c         |    3 --
>   arch/x86/kvm/paging_tmpl.h |   71 +++++++++++++++++++++++---------------------
>   2 files changed, 37 insertions(+), 37 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index d878dd1..e3d2ee0 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3074,9 +3074,6 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
>   		return;
>           }
>
> -	if (is_rsvd_bits_set(&vcpu->arch.mmu, *(u64 *)new, PT_PAGE_TABLE_LEVEL))
> -		return;
> -
>   	++vcpu->kvm->stat.mmu_pte_updated;
>   	if (!sp->role.cr4_pae)
>   		paging32_update_pte(vcpu, sp, spte, new);
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 60f00db..dfb906f 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -299,25 +299,42 @@ static int FNAME(walk_addr_nested)(struct guest_walker *walker,
>   					addr, access);
>   }
>
> +static bool FNAME(map_invalid_gpte)(struct kvm_vcpu *vcpu,
> +				    struct kvm_mmu_page *sp, u64 *spte,
> +				    pt_element_t gpte)

It's really only for speculative maps, the name should reflect that.

Why restrict to invalid gptes?  Won't it work for valid gptes as well?  
Maybe you'll need an extra code path for update_pte() which already 
knows the pfn.

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

I think the order is reversed.  If !is_present_gpte(), it doesn't matter 
if reserved bits are set or not.

> +
> +	if (!(gpte&  PT_ACCESSED_MASK))
> +		goto no_present;
> +
> +	return false;
> +
> +no_present:
> +	drop_spte(vcpu->kvm, spte, nonpresent);
> +	return true;
> +}
> +
>   static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   			      u64 *spte, const void *pte)
>   {
>   	pt_element_t gpte;
>   	unsigned pte_access;
>   	pfn_t pfn;
> -	u64 new_spte;
>
>   	gpte = *(const pt_element_t *)pte;
> -	if (~gpte&  (PT_PRESENT_MASK | PT_ACCESSED_MASK)) {
> -		if (!is_present_gpte(gpte)) {
> -			if (sp->unsync)
> -				new_spte = shadow_trap_nonpresent_pte;
> -			else
> -				new_spte = shadow_notrap_nonpresent_pte;
> -			__set_spte(spte, new_spte);
> -		}
> +	if (FNAME(map_invalid_gpte)(vcpu, sp, spte, gpte))
>   		return;
> -	}
> +
>   	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
>   	pte_access = sp->role.access&  FNAME(gpte_access)(vcpu, gpte);
>   	if (gpte_to_gfn(gpte) != vcpu->arch.update_pte.gfn)
> @@ -364,7 +381,6 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
>   				u64 *sptep)
>   {
>   	struct kvm_mmu_page *sp;
> -	struct kvm_mmu *mmu =&vcpu->arch.mmu;
>   	pt_element_t *gptep = gw->prefetch_ptes;
>   	u64 *spte;
>   	int i;
> @@ -395,16 +411,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
>
>   		gpte = gptep[i];
>
> -		if (is_rsvd_bits_set(mmu, gpte, PT_PAGE_TABLE_LEVEL))
> -			continue;
> -
> -		if (!is_present_gpte(gpte)) {
> -			if (!sp->unsync)
> -				__set_spte(spte, shadow_notrap_nonpresent_pte);
> -			continue;
> -		}
> -
> -		if (!(gpte&  PT_ACCESSED_MASK))
> +		if (FNAME(map_invalid_gpte)(vcpu, sp, spte, gpte))
>   			continue;
>

Ah, I see where it came from.  But I think the other places get it right.

>   		pte_access = sp->role.access&  FNAME(gpte_access)(vcpu, gpte);
> @@ -761,7 +768,6 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>   		pt_element_t gpte;
>   		gpa_t pte_gpa;
>   		gfn_t gfn;
> -		bool rsvd_bits_set;
>
>   		if (!is_shadow_present_pte(sp->spt[i]))
>   			continue;
> @@ -773,18 +779,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>   			return -EINVAL;
>
>   		gfn = gpte_to_gfn(gpte);
> -		rsvd_bits_set = is_rsvd_bits_set(&vcpu->arch.mmu, gpte,
> -						 PT_PAGE_TABLE_LEVEL);
> -		if (rsvd_bits_set || gfn != sp->gfns[i] ||
> -		      !is_present_gpte(gpte) || !(gpte&  PT_ACCESSED_MASK)) {
> -			u64 nonpresent;
> -
> -			if (rsvd_bits_set || is_present_gpte(gpte) ||
> -			      sp->unsync)
> -				nonpresent = shadow_trap_nonpresent_pte;
> -			else
> -				nonpresent = shadow_notrap_nonpresent_pte;
> -			drop_spte(vcpu->kvm,&sp->spt[i], nonpresent);
> +
> +		if (FNAME(map_invalid_gpte)(vcpu, sp,&sp->spt[i], gpte)) {
> +			kvm_flush_remote_tlbs(vcpu->kvm);
> +			continue;
> +		}
> +
> +		if (gfn != sp->gfns[i]) {
> +			drop_spte(vcpu->kvm,&sp->spt[i],
> +				      shadow_trap_nonpresent_pte);
>   			kvm_flush_remote_tlbs(vcpu->kvm);
>   			continue;
>   		}


-- 
error compiling committee.c: too many arguments to function

