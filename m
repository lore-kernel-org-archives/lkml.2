Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1KXJj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:39:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33187 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1KXJjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:39:24 -0500
Message-ID: <4ECE10C6.8020701@gmail.com>
Date: Thu, 24 Nov 2011 17:39:18 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 3/6] KVM: introduce kvm_for_each_memslot macro
References: <4ECE1037.4060300@gmail.com>
In-Reply-To: <4ECE1037.4060300@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Introduce kvm_for_each_memslot to walk all valid memslot

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/ia64/kvm/kvm-ia64.c |    6 ++----
 arch/x86/kvm/mmu.c       |   12 ++++++------
 include/linux/kvm_host.h |    4 ++++
 virt/kvm/iommu.c         |   17 +++++++++--------
 virt/kvm/kvm_main.c      |   14 ++++++--------
 5 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 43f4c92..42ad1f9 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1366,14 +1366,12 @@ static void kvm_release_vm_pages(struct kvm *kvm)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int i, j;
+	int j;
 	unsigned long base_gfn;

 	slots = kvm_memslots(kvm);
-	for (i = 0; i < slots->nmemslots; i++) {
-		memslot = &slots->memslots[i];
+	kvm_for_each_memslot(memslot, slots) {
 		base_gfn = memslot->base_gfn;
-
 		for (j = 0; j < memslot->npages; j++) {
 			if (memslot->rmap[j])
 				put_page((struct page *)memslot->rmap[j]);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 715dcb4..d737443 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1128,15 +1128,15 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 			  int (*handler)(struct kvm *kvm, unsigned long *rmapp,
 					 unsigned long data))
 {
-	int i, j;
+	int j;
 	int ret;
 	int retval = 0;
 	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;

 	slots = kvm_memslots(kvm);

-	for (i = 0; i < slots->nmemslots; i++) {
-		struct kvm_memory_slot *memslot = &slots->memslots[i];
+	kvm_for_each_memslot(memslot, slots) {
 		unsigned long start = memslot->userspace_addr;
 		unsigned long end;

@@ -3985,15 +3985,15 @@ nomem:
  */
 unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
 {
-	int i;
 	unsigned int nr_mmu_pages;
 	unsigned int  nr_pages = 0;
 	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;

 	slots = kvm_memslots(kvm);

-	for (i = 0; i < slots->nmemslots; i++)
-		nr_pages += slots->memslots[i].npages;
+	kvm_for_each_memslot(memslot, slots)
+		nr_pages += memslot->npages;

 	nr_mmu_pages = nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
 	nr_mmu_pages = max(nr_mmu_pages,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 23f795c..392af47 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -308,6 +308,10 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
 	     idx++)

+#define kvm_for_each_memslot(memslot, slots)	\
+	for (memslot = &slots->memslots[0];	\
+	      memslot < slots->memslots + (slots)->nmemslots; memslot++)
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index a195c07..4e5f7b7 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -134,14 +134,15 @@ unmap_pages:

 static int kvm_iommu_map_memslots(struct kvm *kvm)
 {
-	int i, idx, r = 0;
+	int idx, r = 0;
 	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;

 	idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);

-	for (i = 0; i < slots->nmemslots; i++) {
-		r = kvm_iommu_map_pages(kvm, &slots->memslots[i]);
+	kvm_for_each_memslot(memslot, slots) {
+		r = kvm_iommu_map_pages(kvm, memslot);
 		if (r)
 			break;
 	}
@@ -311,16 +312,16 @@ static void kvm_iommu_put_pages(struct kvm *kvm,

 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 {
-	int i, idx;
+	int idx;
 	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;

 	idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);

-	for (i = 0; i < slots->nmemslots; i++) {
-		kvm_iommu_put_pages(kvm, slots->memslots[i].base_gfn,
-				    slots->memslots[i].npages);
-	}
+	kvm_for_each_memslot(memslot, slots)
+		kvm_iommu_put_pages(kvm, memslot->base_gfn, memslot->npages);
+
 	srcu_read_unlock(&kvm->srcu, idx);

 	return 0;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b5ed777..4c2900c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -547,11 +547,11 @@ static void kvm_free_physmem_slot(struct kvm_memory_slot *free,

 void kvm_free_physmem(struct kvm *kvm)
 {
-	int i;
 	struct kvm_memslots *slots = kvm->memslots;
+	struct kvm_memory_slot *memslot;

-	for (i = 0; i < slots->nmemslots; ++i)
-		kvm_free_physmem_slot(&slots->memslots[i], NULL);
+	kvm_for_each_memslot(memslot, slots)
+		kvm_free_physmem_slot(memslot, NULL);

 	kfree(kvm->memslots);
 }
@@ -975,15 +975,13 @@ EXPORT_SYMBOL_GPL(kvm_is_error_hva);
 static struct kvm_memory_slot *__gfn_to_memslot(struct kvm_memslots *slots,
 						gfn_t gfn)
 {
-	int i;
-
-	for (i = 0; i < slots->nmemslots; ++i) {
-		struct kvm_memory_slot *memslot = &slots->memslots[i];
+	struct kvm_memory_slot *memslot;

+	kvm_for_each_memslot(memslot, slots)
 		if (gfn >= memslot->base_gfn
 		    && gfn < memslot->base_gfn + memslot->npages)
 			return memslot;
-	}
+
 	return NULL;
 }

-- 
1.7.7.3

