Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab1KRJTC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:19:02 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39833 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1KRJS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:18:59 -0500
Message-ID: <4EC622F8.30005@linux.vnet.ibm.com>
Date: Fri, 18 Nov 2011 17:18:48 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 3/6] KVM: introduce kvm_for_each_memslot macro
References: <4EC6226B.3080408@linux.vnet.ibm.com>
In-Reply-To: <4EC6226B.3080408@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11111809-3864-0000-0000-0000002426CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kvm_for_each_memslot to walk all valid memslot

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/ia64/kvm/kvm-ia64.c |    4 +---
 arch/x86/kvm/mmu.c       |    9 +++++----
 include/linux/kvm_host.h |    4 ++++
 virt/kvm/iommu.c         |   13 +++++++------
 virt/kvm/kvm_main.c      |    5 +++--
 5 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 43f4c92..7d5bc81 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1370,10 +1370,8 @@ static void kvm_release_vm_pages(struct kvm *kvm)
 	unsigned long base_gfn;

 	slots = kvm_memslots(kvm);
-	for (i = 0; i < slots->nmemslots; i++) {
-		memslot = &slots->memslots[i];
+	kvm_for_each_memslot(slots, memslot, i) {
 		base_gfn = memslot->base_gfn;
-
 		for (j = 0; j < memslot->npages; j++) {
 			if (memslot->rmap[j])
 				put_page((struct page *)memslot->rmap[j]);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e6c2755..53dbae0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1120,11 +1120,11 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
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

@@ -3977,11 +3977,12 @@ unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bb8728e..10524c0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -307,6 +307,10 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
 	     idx++)

+#define kvm_for_each_memslot(slots, memslot, i)	\
+	for (i = 0; i < (slots)->nmemslots &&	\
+	      ({ memslot = &(slots)->memslots[i]; 1; }); i++)
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index d5f3b8d..02df243 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -134,12 +134,13 @@ static int kvm_iommu_map_memslots(struct kvm *kvm)
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
@@ -311,14 +312,14 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
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
index 0fb3aeb..ec3b03b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -549,9 +549,10 @@ void kvm_free_physmem(struct kvm *kvm)
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
-- 
1.7.7.1

