Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab1BVIOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:14:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60905 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1BVIOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:14:11 -0500
Message-ID: <4D637085.7010101@cn.fujitsu.com>
Date: Tue, 22 Feb 2011 16:15:01 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 6/7] KVM: cleanup traversal used slots
References: <4D636EF8.60800@cn.fujitsu.com>
In-Reply-To: <4D636EF8.60800@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:13:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:13:03,
	Serialize complete at 2011-02-22 16:13:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get all used slots from memslots->slots_sort[], then memslots->nmemslots
is only used when memslots is sorted, this operation is not frequency i think,
so it can be removed

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/ia64/kvm/kvm-ia64.c |    3 +--
 arch/x86/kvm/mmu.c       |    9 +++++----
 arch/x86/kvm/x86.c       |    2 +-
 include/linux/kvm_host.h |    7 +++++--
 virt/kvm/iommu.c         |   13 +++++++------
 virt/kvm/kvm_main.c      |   15 +++++++--------
 6 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 8213efe..75b218c 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1369,8 +1369,7 @@ static void kvm_release_vm_pages(struct kvm *kvm)
 	unsigned long base_gfn;
 
 	slots = kvm_memslots(kvm);
-	for (i = 0; i < slots->nmemslots; i++) {
-		memslot = &slots->memslots[i];
+	kvm_for_each_memslot(slots, memslot, i) {
 		base_gfn = memslot->base_gfn;
 
 		for (j = 0; j < memslot->npages; j++) {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 268c891..0d6e7b1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -874,11 +874,11 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 	int ret;
 	int retval = 0;
 	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
 
 	slots = kvm_memslots(kvm);
 
-	for (i = 0; i < slots->nmemslots; i++) {
-		struct kvm_memory_slot *memslot = &slots->memslots[i];
+	kvm_for_each_memslot(slots, memslot, i) {
 		unsigned long start = memslot->userspace_addr;
 		unsigned long end;
 
@@ -3671,11 +3671,12 @@ unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
 	unsigned int nr_mmu_pages;
 	unsigned int  nr_pages = 0;
 	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
 
 	slots = kvm_memslots(kvm);
 
-	for (i = 0; i < slots->nmemslots; i++)
-		nr_pages += slots->memslots[i].npages;
+	kvm_for_each_memslot(slots, memslot, i)
+		nr_pages += memslot->npages;
 
 	nr_mmu_pages = nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
 	nr_mmu_pages = max(nr_mmu_pages,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 888f0b0..632da9e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3252,7 +3252,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 			goto out;
 		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
 		slots->memslots[log->slot].dirty_bitmap = dirty_bitmap;
-		memslots_updated(slots, log->slot);
+		memslots_updated(slots);
 
 		old_slots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7fbae16..c9fd336 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -222,7 +222,6 @@ struct kvm_irq_routing_table {};
 #endif
 
 struct kvm_memslots {
-	int nmemslots;
 	int used_slots;
 	u64 generation;
 	struct kvm_memory_slot *slot_cache;
@@ -302,6 +301,10 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 	     idx < atomic_read(&kvm->online_vcpus) && vcpup; \
 	     vcpup = kvm_get_vcpu(kvm, ++idx))
 
+#define kvm_for_each_memslot(memslots, memslot, i)	\
+	for (i = 0; i < (memslots)->used_slots &&	\
+		({memslot = (memslots)->slots_sort[i]; 1; }); i++)
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
 
@@ -334,7 +337,7 @@ int is_error_pfn(pfn_t pfn);
 int is_hwpoison_pfn(pfn_t pfn);
 int is_fault_pfn(pfn_t pfn);
 int kvm_is_error_hva(unsigned long addr);
-void memslots_updated(struct kvm_memslots *slots, int slot_id);
+void memslots_updated(struct kvm_memslots *slots);
 int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem,
 			  int user_alloc);
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 62a9caf..79571a9 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -128,12 +128,13 @@ static int kvm_iommu_map_memslots(struct kvm *kvm)
 {
 	int i, idx, r = 0;
 	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);
 
-	for (i = 0; i < slots->nmemslots; i++) {
-		r = kvm_iommu_map_pages(kvm, &slots->memslots[i]);
+	kvm_for_each_memslot(slots, memslot, i) {
+		r = kvm_iommu_map_pages(kvm, memslot);
 		if (r)
 			break;
 	}
@@ -289,14 +290,14 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 {
 	int i, idx;
 	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);
 
-	for (i = 0; i < slots->nmemslots; i++) {
-		kvm_iommu_put_pages(kvm, slots->memslots[i].base_gfn,
-				    slots->memslots[i].npages);
-	}
+	kvm_for_each_memslot(slots, memslot, i)
+		kvm_iommu_put_pages(kvm, memslot->base_gfn, memslot->npages);
+
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return 0;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4917d6a..16b9cf3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -544,9 +544,10 @@ void kvm_free_physmem(struct kvm *kvm)
 {
 	int i;
 	struct kvm_memslots *slots = kvm->memslots;
+	struct kvm_memory_slot *memslot;
 
-	for (i = 0; i < slots->nmemslots; ++i)
-		kvm_free_physmem_slot(&slots->memslots[i], NULL);
+	kvm_for_each_memslot(slots, memslot, i)
+		kvm_free_physmem_slot(memslot, NULL);
 
 	kfree(kvm->memslots);
 }
@@ -673,7 +674,7 @@ static void sort_memslots(struct kvm_memslots *slots)
 	int i, num = 0;
 	struct kvm_memory_slot *memslot;
 
-	for (i = 0; i < slots->nmemslots; i++) {
+	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++) {
 		memslot = &slots->memslots[i];
 		if (!memslot->npages)
 			continue;
@@ -685,10 +686,8 @@ static void sort_memslots(struct kvm_memslots *slots)
 	sort(slots->slots_sort, num, sizeof(memslot), cmp_memslot, NULL);
 }
 
-void memslots_updated(struct kvm_memslots *slots, int slot_id)
+void memslots_updated(struct kvm_memslots *slots)
 {
-	if (slot_id >= slots->nmemslots)
-		slots->nmemslots = slot_id + 1;
 	slots->generation++;
 	slots->slot_cache = NULL;
 	sort_memslots(slots);
@@ -840,7 +839,7 @@ skip_lpage:
 			goto out_free;
 		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
 		slots->memslots[mem->slot].flags |= KVM_MEMSLOT_INVALID;
-		memslots_updated(slots, mem->slot);
+		memslots_updated(slots);
 
 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
@@ -882,7 +881,7 @@ skip_lpage:
 	}
 
 	slots->memslots[mem->slot] = new;
-	memslots_updated(slots, mem->slot);
+	memslots_updated(slots);
 	old_memslots = kvm->memslots;
 	rcu_assign_pointer(kvm->memslots, slots);
 	synchronize_srcu_expedited(&kvm->srcu);
-- 
1.7.4
