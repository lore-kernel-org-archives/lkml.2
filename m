Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab2LJRdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:33:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab2LJRdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:33:04 -0500
Subject: [PATCH v2 04/10] kvm: Minor memory slot optimization
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 10 Dec 2012 10:33:03 -0700
Message-ID: <20121210173303.10461.47295.stgit@bling.home>
In-Reply-To: <20121210171417.10461.20079.stgit@bling.home>
References: <20121210171417.10461.20079.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a slot is removed or moved in the guest physical address space, we
first allocate and install a new slot array with the invalidated
entry.  The old array is then freed.  We then proceed to allocate yet
another slot array to install the permanent replacement.  Re-use the
original array when this occurs and avoid the extra kfree/kmalloc.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 virt/kvm/kvm_main.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0f66a0e..2a80dac 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -711,7 +711,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	unsigned long npages;
 	struct kvm_memory_slot *memslot, *slot;
 	struct kvm_memory_slot old, new;
-	struct kvm_memslots *slots, *old_memslots;
+	struct kvm_memslots *slots = NULL, *old_memslots;
 
 	r = check_memory_region_flags(mem);
 	if (r)
@@ -827,18 +827,25 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		 * 	- kvm_is_visible_gfn (mmu_check_roots)
 		 */
 		kvm_arch_flush_shadow_memslot(kvm, slot);
-		kfree(old_memslots);
+		slots = old_memslots;
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, &new, old, mem, user_alloc);
 	if (r)
-		goto out_free;
+		goto out_slots;
 
 	r = -ENOMEM;
-	slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
-			GFP_KERNEL);
-	if (!slots)
-		goto out_free;
+	/*
+	 * We can re-use the old_memslots from above, the only difference
+	 * from the currently installed memslots is the invalid flag.  This
+	 * will get overwritten by update_memslots anyway.
+	 */
+	if (!slots) {
+		slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
+				GFP_KERNEL);
+		if (!slots)
+			goto out_free;
+	}
 
 	/* map new memory slot into the iommu */
 	if (npages) {

