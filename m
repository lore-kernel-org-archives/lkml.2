Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab2LWIzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 03:55:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2LWIzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 03:55:17 -0500
Date: Sun, 23 Dec 2012 10:55:06 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, yoshikawa_takuya_b1@lab.ntt.co.jp,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: Re: [PATCH] kvm: Fix memory slot generation updates
Message-ID: <20121223085506.GM17584@redhat.com>
References: <20121221151959.3641.75215.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121221151959.3641.75215.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 08:20:16AM -0700, Alex Williamson wrote:
> Previous patch "kvm: Minor memory slot optimization" overlooked the
> generation field of the memory slots.  Re-using the original memory
> slots left us with with two slightly different memory slots with the
> same generation.  To fix this, make update_memslots() take a new
> parameter to specify the last generation.  This also makes generation
> management more explicit to avoid such problems in the future.
> 
> Reported-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Applied, thanks. What about this small cleanup on to of the patch:


diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14cbae8..e45c20c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -702,6 +702,17 @@ static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
 	return 0;
 }
 
+static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
+		struct kvm_memslots *slots, struct kvm_memory_slot *new)
+{
+	struct kvm_memslots *old_memslots = kvm->memslots;
+
+	update_memslots(slots, new, kvm->memslots->generation);
+	rcu_assign_pointer(kvm->memslots, slots);
+	synchronize_srcu_expedited(&kvm->srcu);
+	return old_memslots; 
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -820,11 +831,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		slot = id_to_memslot(slots, mem->slot);
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
-		update_memslots(slots, NULL, kvm->memslots->generation);
+		old_memslots = install_new_memslots(kvm, slots, NULL);
 
-		old_memslots = kvm->memslots;
-		rcu_assign_pointer(kvm->memslots, slots);
-		synchronize_srcu_expedited(&kvm->srcu);
 		/* slot was deleted or moved, clear iommu mapping */
 		kvm_iommu_unmap_pages(kvm, &old);
 		/* From this point no new shadow pages pointing to a deleted,
@@ -868,10 +876,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		memset(&new.arch, 0, sizeof(new.arch));
 	}
 
-	update_memslots(slots, &new, kvm->memslots->generation);
-	old_memslots = kvm->memslots;
-	rcu_assign_pointer(kvm->memslots, slots);
-	synchronize_srcu_expedited(&kvm->srcu);
+	old_memslots = install_new_memslots(kvm, slots, &new);
 
 	kvm_arch_commit_memory_region(kvm, mem, old, user_alloc);
 
--
			Gleb.
