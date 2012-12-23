Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2LWNdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 08:33:09 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39474 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2LWNdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 08:33:07 -0500
Date: Sun, 23 Dec 2012 22:26:45 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        yoshikawa_takuya_b1@lab.ntt.co.jp, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: Fix memory slot generation updates
Message-Id: <20121223222645.6dd4519d4d27557d432d0424@gmail.com>
In-Reply-To: <20121223085506.GM17584@redhat.com>
References: <20121221151959.3641.75215.stgit@bling.home>
	<20121223085506.GM17584@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2012 10:55:06 +0200
Gleb Natapov <gleb@redhat.com> wrote:

> Applied, thanks. What about this small cleanup on to of the patch:

Looks nice!  Hope to see this applied as well.

Thanks,
	Takuya

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 14cbae8..e45c20c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -702,6 +702,17 @@ static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
>  	return 0;
>  }
>  
> +static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
> +		struct kvm_memslots *slots, struct kvm_memory_slot *new)
> +{
> +	struct kvm_memslots *old_memslots = kvm->memslots;
> +
> +	update_memslots(slots, new, kvm->memslots->generation);
> +	rcu_assign_pointer(kvm->memslots, slots);
> +	synchronize_srcu_expedited(&kvm->srcu);
> +	return old_memslots; 
> +}
> +
>  /*
>   * Allocate some memory and give it an address in the guest physical address
>   * space.
> @@ -820,11 +831,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		slot = id_to_memslot(slots, mem->slot);
>  		slot->flags |= KVM_MEMSLOT_INVALID;
>  
> -		update_memslots(slots, NULL, kvm->memslots->generation);
> +		old_memslots = install_new_memslots(kvm, slots, NULL);
>  
> -		old_memslots = kvm->memslots;
> -		rcu_assign_pointer(kvm->memslots, slots);
> -		synchronize_srcu_expedited(&kvm->srcu);
>  		/* slot was deleted or moved, clear iommu mapping */
>  		kvm_iommu_unmap_pages(kvm, &old);
>  		/* From this point no new shadow pages pointing to a deleted,
> @@ -868,10 +876,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		memset(&new.arch, 0, sizeof(new.arch));
>  	}
>  
> -	update_memslots(slots, &new, kvm->memslots->generation);
> -	old_memslots = kvm->memslots;
> -	rcu_assign_pointer(kvm->memslots, slots);
> -	synchronize_srcu_expedited(&kvm->srcu);
> +	old_memslots = install_new_memslots(kvm, slots, &new);
>  
>  	kvm_arch_commit_memory_region(kvm, mem, old, user_alloc);
>  
> --
> 			Gleb.


-- 
Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
