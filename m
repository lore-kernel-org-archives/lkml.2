Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2LXPbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 10:31:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab2LXPbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 10:31:16 -0500
Message-ID: <1356363072.3224.604.camel@bling.home>
Subject: Re: [PATCH] kvm: Fix memory slot generation updates
From: Alex Williamson <alex.williamson@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, yoshikawa_takuya_b1@lab.ntt.co.jp,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Date: Mon, 24 Dec 2012 08:31:12 -0700
In-Reply-To: <20121223085506.GM17584@redhat.com>
References: <20121221151959.3641.75215.stgit@bling.home>
	 <20121223085506.GM17584@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-12-23 at 10:55 +0200, Gleb Natapov wrote:
> On Fri, Dec 21, 2012 at 08:20:16AM -0700, Alex Williamson wrote:
> > Previous patch "kvm: Minor memory slot optimization" overlooked the
> > generation field of the memory slots.  Re-using the original memory
> > slots left us with with two slightly different memory slots with the
> > same generation.  To fix this, make update_memslots() take a new
> > parameter to specify the last generation.  This also makes generation
> > management more explicit to avoid such problems in the future.
> > 
> > Reported-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Applied, thanks. What about this small cleanup on to of the patch:

Nice cleanup

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

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



