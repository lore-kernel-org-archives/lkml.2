Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2LJRdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:33:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab2LJRc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:32:58 -0500
Subject: [PATCH v2 03/10] kvm: Fix iommu map/unmap to handle memory slot
 moves
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 10 Dec 2012 10:32:57 -0700
Message-ID: <20121210173257.10461.53405.stgit@bling.home>
In-Reply-To: <20121210171417.10461.20079.stgit@bling.home>
References: <20121210171417.10461.20079.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iommu integration into memory slots expects memory slots to be
added or removed and doesn't handle the move case.  We can unmap
slots from the iommu after we mark them invalid and map them before
installing the final memslot array.  Also re-order the kmemdup vs
map so we don't leave iommu mappings if we get ENOMEM.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 virt/kvm/kvm_main.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6e9d3f9..0f66a0e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -817,6 +817,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
 		synchronize_srcu_expedited(&kvm->srcu);
+		/* slot was deleted or moved, clear iommu mapping */
+		kvm_iommu_unmap_pages(kvm, &old);
 		/* From this point no new shadow pages pointing to a deleted,
 		 * or moved, memslot will be created.
 		 *
@@ -832,20 +834,19 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (r)
 		goto out_free;
 
-	/* map/unmap the pages in iommu page table */
-	if (npages) {
-		r = kvm_iommu_map_pages(kvm, &new);
-		if (r)
-			goto out_free;
-	} else
-		kvm_iommu_unmap_pages(kvm, &old);
-
 	r = -ENOMEM;
 	slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
 			GFP_KERNEL);
 	if (!slots)
 		goto out_free;
 
+	/* map new memory slot into the iommu */
+	if (npages) {
+		r = kvm_iommu_map_pages(kvm, &new);
+		if (r)
+			goto out_slots;
+	}
+
 	/* actual memory is freed via old in kvm_free_physmem_slot below */
 	if (!npages) {
 		new.dirty_bitmap = NULL;
@@ -864,6 +865,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	return 0;
 
+out_slots:
+	kfree(slots);
 out_free:
 	kvm_free_physmem_slot(&new, &old);
 out:

