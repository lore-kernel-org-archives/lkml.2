Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3AGUh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:37:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab3AGUh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:37:26 -0500
Date: Mon, 7 Jan 2013 18:11:46 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] KVM: Write protect the updated slot only when we
 start dirty logging
Message-ID: <20130107201146.GA19224@amt.cnet>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
 <20121218162647.009f468e.yoshikawa_takuya_b1@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218162647.009f468e.yoshikawa_takuya_b1@lab.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 04:26:47PM +0900, Takuya Yoshikawa wrote:
> This is needed to make kvm_mmu_slot_remove_write_access() rmap based:
> otherwise we may end up using invalid rmap's.
> 
> Signed-off-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>

Why? memslot->arch.rmap[] has been properly allocated at this point.

> ---
>  arch/x86/kvm/x86.c  |    9 ++++++++-
>  virt/kvm/kvm_main.c |    1 -
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1c9c834..9451efa 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6897,7 +6897,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  	spin_lock(&kvm->mmu_lock);
>  	if (nr_mmu_pages)
>  		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
> -	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
> +	/*
> +	 * Write protect all pages for dirty logging.
> +	 * Existing largepage mappings are destroyed here and new ones will
> +	 * not be created until the end of the logging.
> +	 */
> +	if ((mem->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
> +	    !(old.flags & KVM_MEM_LOG_DIRTY_PAGES))
> +		kvm_mmu_slot_remove_write_access(kvm, mem->slot);
>  	spin_unlock(&kvm->mmu_lock);
>  	/*
>  	 * If memory slot is created, or moved, we need to clear all
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index bd31096..0ef5daa 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -805,7 +805,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
>  		if (kvm_create_dirty_bitmap(&new) < 0)
>  			goto out_free;
> -		/* destroy any largepage mappings for dirty tracking */
>  	}
>  
>  	if (!npages || base_gfn != old.base_gfn) {
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
