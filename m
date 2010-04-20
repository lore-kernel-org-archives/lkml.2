Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0DTBqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 21:46:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab0DTBqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 21:46:50 -0400
Date: Mon, 19 Apr 2010 21:59:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm x86 mmu: simplify kvm_mmu_unlink_parents()
Message-ID: <20100420005937.GA17981@amt.cnet>
References: <4BC97645.8050009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC97645.8050009@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17, 2010 at 04:50:13PM +0800, Lai Jiangshan wrote:
> 
> mmu_page_remove_parent_pte() does much maintenance works,
> but kvm_mmu_unlink_parents() unlink all parents, so
> such maintenance works are not need.
> 
> This patch simplifies the works of kvm_mmu_unlink_parents()
> by unlinking parents without so many maintenance works.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 90f666e..71faa04 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1453,22 +1453,33 @@ static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
>  
>  static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
> -	u64 *parent_pte;
> +	if (!sp->multimapped) {
> +		if (!sp->parent_pte)
> +			return;
>  
> -	while (sp->multimapped || sp->parent_pte) {
> -		if (!sp->multimapped)
> -			parent_pte = sp->parent_pte;
> -		else {
> -			struct kvm_pte_chain *chain;
> +		__set_spte(sp->parent_pte, shadow_trap_nonpresent_pte);
> +		sp->parent_pte = NULL;
> +		return;
> +	}
>  
> -			chain = container_of(sp->parent_ptes.first,
> -					     struct kvm_pte_chain, link);
> -			parent_pte = chain->parent_ptes[0];
> +	while (!hlist_empty(&sp->parent_ptes)) {
> +		struct kvm_pte_chain *chain;
> +		u64 *parent_pte;
> +		int i;
> +
> +		chain = hlist_entry(sp->parent_ptes.first,
> +				    struct kvm_pte_chain, link);
> +		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
> +			parent_pte = chain->parent_ptes[i];
> +			if (!parent_pte)
> +				break;
> +			__set_spte(parent_pte, shadow_trap_nonpresent_pte);
>  		}
> -		BUG_ON(!parent_pte);
> -		kvm_mmu_put_page(sp, parent_pte);
> -		__set_spte(parent_pte, shadow_trap_nonpresent_pte);
> +		hlist_del(&chain->link);
> +		mmu_free_pte_chain(chain);
>  	}
> +	sp->multimapped = 0;
> +	sp->parent_pte = NULL;
>  }
>  
>  static int mmu_zap_unsync_children(struct kvm *kvm,
> 

Personally i don't see why this is any better than the previous code.
