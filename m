Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0FNWUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:20:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab0FNWUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:20:24 -0400
Date: Mon, 14 Jun 2010 19:07:08 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/7] KVM: MMU: don't walk every parent pages while mark
 unsync
Message-ID: <20100614220708.GA8658@amt.cnet>
References: <4C1239EE.3090904@cn.fujitsu.com>
 <4C123B93.7060803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C123B93.7060803@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 09:35:15PM +0800, Xiao Guangrong wrote:
> While we mark the parent's unsync_child_bitmap, if the parent is already
> unsynced, it no need walk it's parent, it can reduce some unnecessary
> workload
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |   61 ++++++++++++++-------------------------------------
>  1 files changed, 17 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index eb20682..a92863f 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -175,7 +175,7 @@ struct kvm_shadow_walk_iterator {
>  	     shadow_walk_okay(&(_walker));			\
>  	     shadow_walk_next(&(_walker)))
>  
> -typedef int (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp);
> +typedef void (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp, u64 *spte);
>  
>  static struct kmem_cache *pte_chain_cache;
>  static struct kmem_cache *rmap_desc_cache;
> @@ -1024,7 +1024,6 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
>  	BUG();
>  }
>  
> -
>  static void mmu_parent_walk(struct kvm_mmu_page *sp, mmu_parent_walk_fn fn)
>  {
>  	struct kvm_pte_chain *pte_chain;
> @@ -1034,63 +1033,37 @@ static void mmu_parent_walk(struct kvm_mmu_page *sp, mmu_parent_walk_fn fn)
>  
>  	if (!sp->multimapped && sp->parent_pte) {
>  		parent_sp = page_header(__pa(sp->parent_pte));
> -		fn(parent_sp);
> -		mmu_parent_walk(parent_sp, fn);
> +		fn(parent_sp, sp->parent_pte);
>  		return;
>  	}
> +
>  	hlist_for_each_entry(pte_chain, node, &sp->parent_ptes, link)
>  		for (i = 0; i < NR_PTE_CHAIN_ENTRIES; ++i) {
> -			if (!pte_chain->parent_ptes[i])
> +			u64 *spte = pte_chain->parent_ptes[i];
> +
> +			if (!spte)
>  				break;
> -			parent_sp = page_header(__pa(pte_chain->parent_ptes[i]));
> -			fn(parent_sp);
> -			mmu_parent_walk(parent_sp, fn);
> +			parent_sp = page_header(__pa(spte));
> +			fn(parent_sp, spte);
>  		}
>  }
>  
> -static void kvm_mmu_update_unsync_bitmap(u64 *spte)
> +static void mark_unsync(struct kvm_mmu_page *sp, u64 *spte);
> +static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
>  {
> -	unsigned int index;
> -	struct kvm_mmu_page *sp = page_header(__pa(spte));
> -
> -	index = spte - sp->spt;
> -	if (!__test_and_set_bit(index, sp->unsync_child_bitmap))
> -		sp->unsync_children++;
> -	WARN_ON(!sp->unsync_children);
> +	mmu_parent_walk(sp, mark_unsync);
>  }
>  
> -static void kvm_mmu_update_parents_unsync(struct kvm_mmu_page *sp)
> +static void mark_unsync(struct kvm_mmu_page *sp, u64 *spte)
>  {
> -	struct kvm_pte_chain *pte_chain;
> -	struct hlist_node *node;
> -	int i;
> +	unsigned int index;
>  
> -	if (!sp->parent_pte)
> +	index = spte - sp->spt;
> +	if (__test_and_set_bit(index, sp->unsync_child_bitmap))
>  		return;
> -
> -	if (!sp->multimapped) {
> -		kvm_mmu_update_unsync_bitmap(sp->parent_pte);
> +	if (sp->unsync_children++)
>  		return;

This looks wrong. If the sp has an unrelated children marked as 
unsync (which increased sp->unsync_children), you stop the walk? 

Applied 1-6, thanks.

