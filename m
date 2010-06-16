Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab0FPD42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 23:56:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab0FPD40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 23:56:26 -0400
Date: Wed, 16 Jun 2010 00:55:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/6] KVM: MMU: prefetch ptes when intercepted guest #PF
Message-ID: <20100616035533.GA22262@amt.cnet>
References: <4C16E6ED.7020009@cn.fujitsu.com>
 <4C16E75F.6020003@cn.fujitsu.com>
 <4C16E7AD.1060101@cn.fujitsu.com>
 <4C16E7F4.5060801@cn.fujitsu.com>
 <4C16E82E.5010306@cn.fujitsu.com>
 <4C16E9A8.10409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C16E9A8.10409@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:47:04AM +0800, Xiao Guangrong wrote:
> Support prefetch ptes when intercept guest #PF, avoid to #PF by later
> access
> 
> If we meet any failure in the prefetch path, we will exit it and
> not try other ptes to avoid become heavy path
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c         |   36 +++++++++++++++++++++
>  arch/x86/kvm/paging_tmpl.h |   76 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 112 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 92ff099..941c86b 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -89,6 +89,8 @@ module_param(oos_shadow, bool, 0644);
>  	}
>  #endif
>  
> +#define PTE_PREFETCH_NUM	16
> +
>  #define PT_FIRST_AVAIL_BITS_SHIFT 9
>  #define PT64_SECOND_AVAIL_BITS_SHIFT 52
>  
> @@ -2041,6 +2043,39 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
>  {
>  }
>  
> +static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
> +{
> +	struct kvm_mmu_page *sp;
> +	int index, i;
> +
> +	sp = page_header(__pa(sptep));
> +	WARN_ON(!sp->role.direct);
> +	index = sptep - sp->spt;
> +
> +	for (i = index + 1; i < min(PT64_ENT_PER_PAGE,
> +				      index + PTE_PREFETCH_NUM); i++) {
> +		gfn_t gfn;
> +		pfn_t pfn;
> +		u64 *spte = sp->spt + i;
> +
> +		if (*spte != shadow_trap_nonpresent_pte)
> +			continue;
> +
> +		gfn = sp->gfn + (i << ((sp->role.level - 1) * PT64_LEVEL_BITS));
> +
> +		pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
> +		if (is_error_pfn(pfn)) {
> +			kvm_release_pfn_clean(pfn);
> +			break;
> +		}
> +		if (pte_prefetch_topup_memory_cache(vcpu))
> +			break;
> +
> +		mmu_set_spte(vcpu, spte, ACC_ALL, ACC_ALL, 0, 0, 1, NULL,
> +			     sp->role.level, gfn, pfn, true, false);

Can only map with level > 1 if the host page matches the size.

