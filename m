Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab2GQN42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:56:28 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:55263 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2GQN4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:56:24 -0400
Message-ID: <50056F00.4030406@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 21:56:16 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 9/9] KVM: remove the unused parameter of gfn_to_pfn_memslot
References: <50056DB8.7080702@linux.vnet.ibm.com>
In-Reply-To: <50056DB8.7080702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071703-5490-0000-0000-000001CB1DB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter, 'kvm', is not used in gfn_to_pfn_memslot, we can happily remove
it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/powerpc/kvm/e500_tlb.c |    2 +-
 arch/x86/kvm/mmu.c          |    2 +-
 include/linux/kvm_host.h    |    5 ++---
 virt/kvm/iommu.c            |   10 +++++-----
 virt/kvm/kvm_main.c         |   15 +++++++--------
 5 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index c510fc9..c8f6c58 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -520,7 +520,7 @@ static inline void kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,

 	if (likely(!pfnmap)) {
 		unsigned long tsize_pages = 1 << (tsize + 10 - PAGE_SHIFT);
-		pfn = gfn_to_pfn_memslot(vcpu_e500->vcpu.kvm, slot, gfn);
+		pfn = gfn_to_pfn_memslot(slot, gfn);
 		if (is_error_pfn(pfn)) {
 			printk(KERN_ERR "Couldn't get real page for gfn %lx!\n",
 					(long)gfn);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e23cdae..4ed543a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2488,7 +2488,7 @@ static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,

 	hva = gfn_to_hva_memslot(slot, gfn);

-	return hva_to_pfn_atomic(vcpu->kvm, hva);
+	return hva_to_pfn_atomic(hva);
 }

 static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f1ef5fc..14bfde4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -418,15 +418,14 @@ void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);

-pfn_t hva_to_pfn_atomic(struct kvm *kvm, unsigned long addr);
+pfn_t hva_to_pfn_atomic(unsigned long addr);
 pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn_async(struct kvm *kvm, gfn_t gfn, bool *async,
 		       bool write_fault, bool *writable);
 pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
-pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
-			 struct kvm_memory_slot *slot, gfn_t gfn);
+pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_release_pfn_dirty(pfn_t);
 void kvm_release_pfn_clean(pfn_t pfn);
 void kvm_set_pfn_dirty(pfn_t pfn);
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index e9fff98..c03f1fb 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -42,13 +42,13 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm);
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages);

-static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
-			   gfn_t gfn, unsigned long size)
+static pfn_t kvm_pin_pages(struct kvm_memory_slot *slot, gfn_t gfn,
+			   unsigned long size)
 {
 	gfn_t end_gfn;
 	pfn_t pfn;

-	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
+	pfn     = gfn_to_pfn_memslot(slot, gfn);
 	end_gfn = gfn + (size >> PAGE_SHIFT);
 	gfn    += 1;

@@ -56,7 +56,7 @@ static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return pfn;

 	while (gfn < end_gfn)
-		gfn_to_pfn_memslot(kvm, slot, gfn++);
+		gfn_to_pfn_memslot(slot, gfn++);

 	return pfn;
 }
@@ -105,7 +105,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		 * Pin all pages we are about to map in memory. This is
 		 * important because we unmap and unpin in 4kb steps later.
 		 */
-		pfn = kvm_pin_pages(kvm, slot, gfn, page_size);
+		pfn = kvm_pin_pages(slot, gfn, page_size);
 		if (is_error_pfn(pfn)) {
 			gfn += 1;
 			continue;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7082e33..78cf42f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1063,8 +1063,8 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 	return rc == -EHWPOISON;
 }

-static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
-			bool *async, bool write_fault, bool *writable)
+static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
+			bool write_fault, bool *writable)
 {
 	struct page *page[1];
 	int npages = 0;
@@ -1144,9 +1144,9 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
 	return pfn;
 }

-pfn_t hva_to_pfn_atomic(struct kvm *kvm, unsigned long addr)
+pfn_t hva_to_pfn_atomic(unsigned long addr)
 {
-	return hva_to_pfn(kvm, addr, true, NULL, true, NULL);
+	return hva_to_pfn(addr, true, NULL, true, NULL);
 }
 EXPORT_SYMBOL_GPL(hva_to_pfn_atomic);

@@ -1164,7 +1164,7 @@ static pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic, bool *async,
 		return page_to_pfn(bad_page);
 	}

-	return hva_to_pfn(kvm, addr, atomic, async, write_fault, writable);
+	return hva_to_pfn(addr, atomic, async, write_fault, writable);
 }

 pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
@@ -1193,11 +1193,10 @@ pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);

-pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
-			 struct kvm_memory_slot *slot, gfn_t gfn)
+pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
-	return hva_to_pfn(kvm, addr, false, NULL, true, NULL);
+	return hva_to_pfn(addr, false, NULL, true, NULL);
 }

 int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn, struct page **pages,
-- 
1.7.7.6

