Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab0DVTbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756974Ab0DVTaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:30:03 -0400
Date: Thu, 22 Apr 2010 16:29:47 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/10] KVM MMU: don't write-protect if have new mapping to
 unsync page
Message-ID: <20100422192947.GA2280@amt.cnet>
References: <4BCFE581.8050305@cn.fujitsu.com>
 <4BCFE8F0.7010509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCFE8F0.7010509@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 02:13:04PM +0800, Xiao Guangrong wrote:
> If have new mapping to the unsync page(i.e, add a new parent), just
> update the page from sp->gfn but not write-protect gfn, and if need
> create new shadow page form sp->gfn, we should sync it
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |   27 +++++++++++++++++++--------
>  1 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index fd027a6..8607a64 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1196,16 +1196,20 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  
>  static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  
> -static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
> +static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> +			 bool clear_unsync)
>  {
>  	if (sp->role.cr4_pae != !!is_pae(vcpu)) {
>  		kvm_mmu_zap_page(vcpu->kvm, sp);
>  		return 1;
>  	}
>  
> -	if (rmap_write_protect(vcpu->kvm, sp->gfn))
> -		kvm_flush_remote_tlbs(vcpu->kvm);
> -	kvm_unlink_unsync_page(vcpu->kvm, sp);
> +	if (clear_unsync) {
> +		if (rmap_write_protect(vcpu->kvm, sp->gfn))
> +			kvm_flush_remote_tlbs(vcpu->kvm);
> +		kvm_unlink_unsync_page(vcpu->kvm, sp);
> +	}
> +
>  	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
>  		kvm_mmu_zap_page(vcpu->kvm, sp);
>  		return 1;
> @@ -1293,7 +1297,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
>  			kvm_flush_remote_tlbs(vcpu->kvm);
>  
>  		for_each_sp(pages, sp, parents, i) {
> -			kvm_sync_page(vcpu, sp);
> +			kvm_sync_page(vcpu, sp, true);
>  			mmu_pages_clear_parents(&parents);
>  		}
>  		cond_resched_lock(&vcpu->kvm->mmu_lock);
> @@ -1313,7 +1317,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  	unsigned index;
>  	unsigned quadrant;
>  	struct hlist_head *bucket;
> -	struct kvm_mmu_page *sp;
> +	struct kvm_mmu_page *sp, *unsync_sp = NULL;
>  	struct hlist_node *node, *tmp;
>  
>  	role = vcpu->arch.mmu.base_role;
> @@ -1332,12 +1336,16 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  	hlist_for_each_entry_safe(sp, node, tmp, bucket, hash_link)
>  		if (sp->gfn == gfn) {
>  			if (sp->unsync)
> -				if (kvm_sync_page(vcpu, sp))
> -					continue;
> +				unsync_sp = sp;

Xiao,

I don't see a reason why you can't create a new mapping to an unsync
page. The code already creates shadow pte entries using unsync
pagetables.

So all you need would be to kvm_sync_pages before write protecting.

Also make sure kvm_sync_pages is in place here before enabling multiple
unsync shadows, in the patch series.

>  
>  			if (sp->role.word != role.word)
>  				continue;
>  
> +			if (unsync_sp && kvm_sync_page(vcpu, unsync_sp, false)) {
> +				unsync_sp = NULL;
> +				continue;
> +			}
> +
>  			mmu_page_add_parent_pte(vcpu, sp, parent_pte);
>  			if (sp->unsync_children) {
>  				set_bit(KVM_REQ_MMU_SYNC, &vcpu->requests);
> @@ -1346,6 +1354,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  			trace_kvm_mmu_get_page(sp, false);
>  			return sp;
>  		}
> +	if (unsync_sp)
> +		kvm_sync_page(vcpu, unsync_sp, true);
> +
>  	++vcpu->kvm->stat.mmu_cache_miss;
>  	sp = kvm_mmu_alloc_page(vcpu, parent_pte);
>  	if (!sp)
> -- 
> 1.6.1.2
> 
