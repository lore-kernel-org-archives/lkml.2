Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab2LXN1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 08:27:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab2LXN1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 08:27:21 -0500
Date: Mon, 24 Dec 2012 15:27:17 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] KVM: Write protect the updated slot only when we
 start dirty logging
Message-ID: <20121224132717.GW17584@redhat.com>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
 <20121218162647.009f468e.yoshikawa_takuya_b1@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218162647.009f468e.yoshikawa_takuya_b1@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 04:26:47PM +0900, Takuya Yoshikawa wrote:
> This is needed to make kvm_mmu_slot_remove_write_access() rmap based:
> otherwise we may end up using invalid rmap's.
> 
> Signed-off-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
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
We should not check old slot flags here or at least check that
old.npages is not zero. Userspace may delete a slot using old flags,
then, if new memslot is created with dirty log enabled, it will not be
protected.

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

--
			Gleb.
