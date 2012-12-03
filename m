Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2LCXjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:39:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab2LCXjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:39:44 -0500
Subject: [RFC PATCH 6/6] kvm: Allow memory slots to grow
To: mtosatti@redhat.com, kvm@vger.kernel.org, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 16:39:43 -0700
Message-ID: <20121203233942.3661.74089.stgit@bling.home>
In-Reply-To: <20121203231912.3661.57179.stgit@bling.home>
References: <20121203231912.3661.57179.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start with zero and grow up to KVM_MEM_SLOTS_NUM.  A modest guest
without device assignment likely uses around 1/4 of the total
entries.  We don't attempt to shrink the array when slots are
released.  Both x86 and powerpc still have some statically sized
elements elsewhere, but this covers the bulk of the memory used.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 include/linux/kvm_host.h |    2 +
 virt/kvm/kvm_main.c      |   62 +++++++++++++++++++++++++++++++---------------
 2 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1955a4e..effc800 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -315,7 +315,7 @@ struct kvm_irq_routing_table {};
 struct kvm_memslots {
 	int nmemslots;
 	u64 generation;
-	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
+	struct kvm_memory_slot memslots[];
 };
 
 struct kvm {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ebd3960..fa4df50 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -439,17 +439,6 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 
-static void kvm_init_memslots_id(struct kvm *kvm)
-{
-	int i;
-	struct kvm_memslots *slots = kvm->memslots;
-
-	slots->nmemslots = KVM_MEM_SLOTS_NUM;
-
-	for (i = 0; i < kvm->memslots->nmemslots; i++)
-		slots->memslots[i].id_to_index = slots->memslots[i].id = i;
-}
-
 static struct kvm *kvm_create_vm(unsigned long type)
 {
 	int r, i;
@@ -475,7 +464,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!kvm->memslots)
 		goto out_err_nosrcu;
-	kvm_init_memslots_id(kvm);
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_nosrcu;
 	for (i = 0; i < KVM_NR_BUSES; i++) {
@@ -696,6 +684,40 @@ static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
 	return 0;
 }
 
+struct kvm_memslots *__kvm_dup_and_grow_memslots(struct kvm_memslots *oldslots,
+						 int slot)
+{
+	int nmemslots;
+	struct kvm_memslots *newslots;
+
+	nmemslots = (slot >= oldslots->nmemslots) ?
+		    slot + 1 : oldslots->nmemslots;
+
+	newslots = kmalloc(sizeof(struct kvm_memslots) +
+			nmemslots * sizeof(struct kvm_memory_slot), GFP_KERNEL);
+	if (!newslots)
+		return NULL;
+
+	memcpy(newslots, oldslots, sizeof(struct kvm_memslots) +
+	       oldslots->nmemslots * sizeof(struct kvm_memory_slot));
+
+	if (nmemslots != oldslots->nmemslots) {
+		int i;
+		memset(&newslots->memslots[oldslots->nmemslots], 0,
+		       (nmemslots - oldslots->nmemslots) *
+		       sizeof(struct kvm_memory_slot));
+
+		for (i = oldslots->nmemslots; i < nmemslots; i++) {
+			newslots->memslots[i].id_to_index = i;
+			newslots->memslots[i].id = i;
+		}
+
+		newslots->nmemslots = nmemslots;
+	}
+
+	return newslots;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -711,8 +733,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int r;
 	gfn_t base_gfn;
 	unsigned long npages;
-	struct kvm_memory_slot *memslot, *slot;
-	struct kvm_memory_slot old, new;
+	struct kvm_memory_slot *memslot = NULL, *slot;
+	struct kvm_memory_slot old = {}, new = {};
 	struct kvm_memslots *slots, *old_memslots;
 
 	r = check_memory_region_flags(mem);
@@ -737,7 +759,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		goto out;
 
-	memslot = id_to_memslot(kvm->memslots, mem->slot);
 	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	npages = mem->memory_size >> PAGE_SHIFT;
 
@@ -748,7 +769,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!npages)
 		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
 
-	new = old = *memslot;
+	if (mem->slot < kvm->memslots->nmemslots) {
+		memslot = id_to_memslot(kvm->memslots, mem->slot);
+		new = old = *memslot;
+	}
 
 	new.id = mem->slot;
 	new.base_gfn = base_gfn;
@@ -796,8 +820,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		struct kvm_memory_slot *slot;
 
 		r = -ENOMEM;
-		slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
-				GFP_KERNEL);
+		slots = __kvm_dup_and_grow_memslots(kvm->memslots, mem->slot);
 		if (!slots)
 			goto out_free;
 		slot = id_to_memslot(slots, mem->slot);
@@ -832,8 +855,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		kvm_iommu_unmap_pages(kvm, &old);
 
 	r = -ENOMEM;
-	slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
-			GFP_KERNEL);
+	slots = __kvm_dup_and_grow_memslots(kvm->memslots, mem->slot);
 	if (!slots)
 		goto out_free;
 

