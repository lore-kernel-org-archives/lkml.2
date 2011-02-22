Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1BVSz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:55:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab1BVSzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:55:24 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 2/3] kvm: Allow memory slot array to grow on demand
To: avi@redhat.com
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, mtosatti@redhat.com, xiaoguangrong@cn.fujitsu.com
Date: Tue, 22 Feb 2011 11:55:21 -0700
Message-ID: <20110222185512.22026.88579.stgit@s20.home>
In-Reply-To: <20110222183822.22026.62832.stgit@s20.home>
References: <20110222183822.22026.62832.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove fixed KVM_MEMORY_SLOTS limit, allowing the slot array
to grow on demand.  Private slots are now allocated at the
front instead of the end.  Only x86 seems to use private slots,
so this is now zero for all other archs.  The memslots pointer
is already updated using rcu, so changing the size off the
array when it's replaces is straight forward.  x86 also keeps
a bitmap of slots used by a kvm_mmu_page, which requires a
shadow tlb flush whenever we increase the number of slots.
This forces the pages to be rebuilt with the new bitmap size.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 arch/ia64/include/asm/kvm_host.h    |    4 --
 arch/ia64/kvm/kvm-ia64.c            |    2 +
 arch/powerpc/include/asm/kvm_host.h |    3 --
 arch/s390/include/asm/kvm_host.h    |    3 --
 arch/x86/include/asm/kvm_host.h     |    5 +--
 arch/x86/include/asm/vmx.h          |    6 ++-
 arch/x86/kvm/mmu.c                  |   32 +++++++++++++++--
 arch/x86/kvm/x86.c                  |    6 ++-
 include/linux/kvm_host.h            |   22 +++++++++++-
 virt/kvm/kvm_main.c                 |   65 +++++++++++++++++++++++++----------
 10 files changed, 103 insertions(+), 45 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 2689ee5..11d0ab2 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -23,10 +23,6 @@
 #ifndef __ASM_KVM_HOST_H
 #define __ASM_KVM_HOST_H
 
-#define KVM_MEMORY_SLOTS 32
-/* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS 4
-
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
 /* define exit reasons from vmm to kvm*/
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 70d224d..f1adda2 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1814,7 +1814,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);
 
 	r = -EINVAL;
-	if (log->slot >= KVM_MEMORY_SLOTS)
+	if (log->slot >= kvm->memslots->nmemslots)
 		goto out;
 
 	memslot = &kvm->memslots->memslots[log->slot];
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index bba3b9b..dc80057 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -29,9 +29,6 @@
 #include <asm/kvm_asm.h>
 
 #define KVM_MAX_VCPUS 1
-#define KVM_MEMORY_SLOTS 32
-/* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS 4
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index cef7dbf..92a964c 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -20,9 +20,6 @@
 #include <asm/cpu.h>
 
 #define KVM_MAX_VCPUS 64
-#define KVM_MEMORY_SLOTS 32
-/* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS 4
 
 struct sca_entry {
 	atomic_t scn;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ffd7f8d..5c94392 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -27,9 +27,8 @@
 #include <asm/msr-index.h>
 
 #define KVM_MAX_VCPUS 64
-#define KVM_MEMORY_SLOTS 32
 /* memory slots that does not exposed to userspace */
-#define KVM_PRIVATE_MEM_SLOTS 4
+#define KVM_PRIVATE_MEM_SLOTS 3
 
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
@@ -207,7 +206,7 @@ struct kvm_mmu_page {
 	 * One bit set per slot which has memory
 	 * in this shadow page.
 	 */
-	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
+	unsigned long *slot_bitmap;
 	bool multimapped;         /* More than one parent_pte? */
 	bool unsync;
 	int root_count;          /* Currently serving as active root */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 84471b8..7fd8c89 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -370,9 +370,9 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define TSS_PRIVATE_MEMSLOT			(KVM_MEMORY_SLOTS + 0)
-#define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	(KVM_MEMORY_SLOTS + 1)
-#define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	(KVM_MEMORY_SLOTS + 2)
+#define TSS_PRIVATE_MEMSLOT			0
+#define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	1
+#define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	2
 
 #define VMX_NR_VPIDS				(1 << 16)
 #define VMX_VPID_EXTENT_SINGLE_CONTEXT		1
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ccacf0b..91e14f6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1029,9 +1029,13 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
 
 static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+
 	ASSERT(is_empty_shadow_page(sp->spt));
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
+	if (unlikely(slots->nmemslots > sizeof(sp->slot_bitmap) * 8))
+		kfree(sp->slot_bitmap);
 	__free_page(virt_to_page(sp->spt));
 	if (!sp->role.direct)
 		__free_page(virt_to_page(sp->gfns));
@@ -1048,6 +1052,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 					       u64 *parent_pte, int direct)
 {
 	struct kvm_mmu_page *sp;
+	struct kvm_memslots *slots = kvm_memslots(vcpu->kvm);
 
 	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache, sizeof *sp);
 	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
@@ -1056,7 +1061,16 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 						  PAGE_SIZE);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
+
+	if (unlikely(slots->nmemslots > sizeof(sp->slot_bitmap) * 8)) {
+		sp->slot_bitmap = kzalloc(sizeof(long) *
+					  BITS_TO_LONGS(slots->nmemslots),
+					  GFP_KERNEL);
+		if (!sp->slot_bitmap)
+			return NULL;
+	} else
+		bitmap_zero((void *)&sp->slot_bitmap, slots->nmemslots);
+
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
@@ -1817,8 +1831,12 @@ static void page_header_update_slot(struct kvm *kvm, void *pte, gfn_t gfn)
 {
 	int slot = memslot_id(kvm, gfn);
 	struct kvm_mmu_page *sp = page_header(__pa(pte));
+	struct kvm_memslots *slots = kvm_memslots(kvm);
 
-	__set_bit(slot, sp->slot_bitmap);
+	if (likely(slots->nmemslots <= sizeof(sp->slot_bitmap) * 8))
+		__set_bit(slot, (void *)&sp->slot_bitmap);
+	else
+		__set_bit(slot, sp->slot_bitmap);
 }
 
 static void mmu_convert_notrap(struct kvm_mmu_page *sp)
@@ -3530,13 +3548,19 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu)
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
 	struct kvm_mmu_page *sp;
+	struct kvm_memslots *slots = kvm_memslots(kvm);
 
 	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
 		int i;
 		u64 *pt;
 
-		if (!test_bit(slot, sp->slot_bitmap))
-			continue;
+		if (likely(slots->nmemslots <= sizeof(sp->slot_bitmap) * 8)) {
+			if (!test_bit(slot, (void *)&sp->slot_bitmap))
+				continue;
+		} else {
+			if (!test_bit(slot, sp->slot_bitmap))
+				continue;
+		}
 
 		pt = sp->spt;
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5eccdba..88688d8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1978,7 +1978,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 		r = KVM_MAX_VCPUS;
 		break;
 	case KVM_CAP_NR_MEMSLOTS:
-		r = KVM_MEMORY_SLOTS;
+		r = KVM_MAX_MEM_SLOTS - KVM_PRIVATE_MEM_SLOTS;
 		break;
 	case KVM_CAP_PV_MMU:	/* obsolete */
 		r = 0;
@@ -3201,7 +3201,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);
 
 	r = -EINVAL;
-	if (log->slot >= KVM_MEMORY_SLOTS)
+	if (log->slot >= kvm->memslots->nmemslots)
 		goto out;
 
 	memslot = &kvm->memslots->memslots[log->slot];
@@ -6068,7 +6068,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	int map_flags = MAP_PRIVATE | MAP_ANONYMOUS;
 
 	/* Prevent internal slot pages from being moved by fork()/COW. */
-	if (memslot->id >= KVM_MEMORY_SLOTS)
+	if (memslot->id < KVM_PRIVATE_MEM_SLOTS)
 		map_flags = MAP_SHARED | MAP_ANONYMOUS;
 
 	/*To keep backward compatibility with older userspace,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b5021db..7bbb36f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -28,6 +28,25 @@
 #include <asm/kvm_host.h>
 
 /*
+ * Private slots are not exposed to userspace.  These are filled at the
+ * front of the slot array with the userspace visible 0 index starting
+ * immediately following.
+ */
+#ifndef KVM_PRIVATE_MEM_SLOTS
+ #define KVM_PRIVATE_MEM_SLOTS 0
+#endif
+
+/*
+ * Protect from malicious userspace by putting an upper bound on the number
+ * of memory slots.  This is an arbitrarily large number that still allows
+ * us to make pseudo-guarantees about supporting 64 assigned devices with
+ * plenty of slots left over.
+ */
+#ifndef KVM_MAX_MEM_SLOTS
+ #define KVM_MAX_MEM_SLOTS 512
+#endif
+
+/*
  * vcpu->requests bit members
  */
 #define KVM_REQ_TLB_FLUSH          0
@@ -206,8 +225,7 @@ struct kvm_irq_routing_table {};
 struct kvm_memslots {
 	int nmemslots;
 	u64 generation;
-	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS +
-					KVM_PRIVATE_MEM_SLOTS];
+	struct kvm_memory_slot memslots[];
 };
 
 struct kvm {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fd67bcd..a3a5bda 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -623,13 +623,14 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem,
 			    int user_alloc)
 {
-	int r;
+	int r, nmemslots;
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long i;
-	struct kvm_memory_slot *memslot;
-	struct kvm_memory_slot old, new;
+	struct kvm_memory_slot *memslot = NULL;
+	struct kvm_memory_slot old = {}, new = {};
 	struct kvm_memslots *slots, *old_memslots;
+	bool flush = false;
 
 	r = -EINVAL;
 	/* General sanity checks */
@@ -639,12 +640,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		goto out;
 	if (user_alloc && (mem->userspace_addr & (PAGE_SIZE - 1)))
 		goto out;
-	if (mem->slot >= KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
+	if (mem->slot >= KVM_MAX_MEM_SLOTS)
 		goto out;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		goto out;
 
-	memslot = &kvm->memslots->memslots[mem->slot];
 	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	npages = mem->memory_size >> PAGE_SHIFT;
 
@@ -655,7 +655,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!npages)
 		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
 
-	new = old = *memslot;
+	if (mem->slot < kvm->memslots->nmemslots) {
+		memslot = &kvm->memslots->memslots[mem->slot];
+		new = old = *memslot;
+	}
 
 	new.id = mem->slot;
 	new.base_gfn = base_gfn;
@@ -669,7 +672,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	/* Check for overlaps */
 	r = -EEXIST;
-	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
+	for (i = KVM_PRIVATE_MEM_SLOTS; i < kvm->memslots->nmemslots; ++i) {
 		struct kvm_memory_slot *s = &kvm->memslots->memslots[i];
 
 		if (s == memslot || !s->npages)
@@ -752,12 +755,19 @@ skip_lpage:
 
 	if (!npages) {
 		r = -ENOMEM;
-		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
+
+		nmemslots = (mem->slot >= kvm->memslots->nmemslots) ?
+			    mem->slot + 1 : kvm->memslots->nmemslots;
+
+		slots = kzalloc(sizeof(struct kvm_memslots) +
+				nmemslots * sizeof(struct kvm_memory_slot),
+				GFP_KERNEL);
 		if (!slots)
 			goto out_free;
-		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
-		if (mem->slot >= slots->nmemslots)
-			slots->nmemslots = mem->slot + 1;
+		memcpy(slots, kvm->memslots,
+		       sizeof(struct kvm_memslots) + kvm->memslots->nmemslots *
+		       sizeof(struct kvm_memory_slot));
+		slots->nmemslots = nmemslots;
 		slots->generation++;
 		slots->memslots[mem->slot].flags |= KVM_MEMSLOT_INVALID;
 
@@ -787,12 +797,21 @@ skip_lpage:
 	}
 
 	r = -ENOMEM;
-	slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
+
+	if (mem->slot >= kvm->memslots->nmemslots) {
+		nmemslots = mem->slot + 1;
+		flush = true;
+	} else
+		nmemslots = kvm->memslots->nmemslots;
+
+	slots = kzalloc(sizeof(struct kvm_memslots) +
+			nmemslots * sizeof(struct kvm_memory_slot),
+			GFP_KERNEL);
 	if (!slots)
 		goto out_free;
-	memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
-	if (mem->slot >= slots->nmemslots)
-		slots->nmemslots = mem->slot + 1;
+	memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots) +
+	       kvm->memslots->nmemslots * sizeof(struct kvm_memory_slot));
+	slots->nmemslots = nmemslots;
 	slots->generation++;
 
 	/* actual memory is freed via old in kvm_free_physmem_slot below */
@@ -808,6 +827,9 @@ skip_lpage:
 	rcu_assign_pointer(kvm->memslots, slots);
 	synchronize_srcu_expedited(&kvm->srcu);
 
+	if (flush)
+		kvm_arch_flush_shadow(kvm);
+
 	kvm_arch_commit_memory_region(kvm, mem, old, user_alloc);
 
 	kvm_free_physmem_slot(&old, &new);
@@ -841,7 +863,7 @@ int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 				   kvm_userspace_memory_region *mem,
 				   int user_alloc)
 {
-	if (mem->slot >= KVM_MEMORY_SLOTS)
+	if (mem->slot >= KVM_MAX_MEM_SLOTS)
 		return -EINVAL;
 	return kvm_set_memory_region(kvm, mem, user_alloc);
 }
@@ -855,7 +877,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	unsigned long any = 0;
 
 	r = -EINVAL;
-	if (log->slot >= KVM_MEMORY_SLOTS)
+	if (log->slot >= kvm->memslots->nmemslots)
 		goto out;
 
 	memslot = &kvm->memslots->memslots[log->slot];
@@ -947,7 +969,7 @@ int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 	int i;
 	struct kvm_memslots *slots = kvm_memslots(kvm);
 
-	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
+	for (i = KVM_PRIVATE_MEM_SLOTS; i < slots->nmemslots; ++i) {
 		struct kvm_memory_slot *memslot = &slots->memslots[i];
 
 		if (memslot->flags & KVM_MEMSLOT_INVALID)
@@ -1832,6 +1854,8 @@ static long kvm_vm_ioctl(struct file *filp,
 						sizeof kvm_userspace_mem))
 			goto out;
 
+		kvm_userspace_mem.slot += KVM_PRIVATE_MEM_SLOTS;
+
 		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem, 1);
 		if (r)
 			goto out;
@@ -1843,6 +1867,9 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&log, argp, sizeof log))
 			goto out;
+
+		log.slot += KVM_PRIVATE_MEM_SLOTS;
+
 		r = kvm_vm_ioctl_get_dirty_log(kvm, &log);
 		if (r)
 			goto out;
@@ -1937,7 +1964,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
 		if (copy_from_user(&compat_log, (void __user *)arg,
 				   sizeof(compat_log)))
 			goto out;
-		log.slot	 = compat_log.slot;
+		log.slot	 = compat_log.slot + KVM_PRIVATE_MEM_SLOTS;
 		log.padding1	 = compat_log.padding1;
 		log.padding2	 = compat_log.padding2;
 		log.dirty_bitmap = compat_ptr(compat_log.dirty_bitmap);

