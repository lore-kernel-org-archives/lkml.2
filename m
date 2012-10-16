Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2JPMLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:11:09 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:36251 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2JPMLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:11:07 -0400
Message-ID: <507D4ED3.2010903@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2012 20:10:59 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 6/6] KVM: do not treat noslot pfn as a error pfn
References: <507D4DE7.5080708@linux.vnet.ibm.com>
In-Reply-To: <507D4DE7.5080708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101612-6102-0000-0000-000002635AB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch filters noslot pfn out from error pfns based on Marcelo comment:
noslot pfn is not a error pfn

After this patch,
- is_noslot_pfn indicates that the gfn is not in slot
- is_error_pfn indicates that the gfn is in slot but the error is occurred
  when translate the gfn to pfn
- is_error_noslot_pfn indicates that the pfn either it is error pfns or it
  is noslot pfn
And is_invalid_pfn can be removed, it makes the code more clean

[ The patch has been compiling tested for powerpc ]

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/powerpc/kvm/book3s_32_mmu_host.c |    2 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c |    2 +-
 arch/powerpc/kvm/e500_tlb.c           |    2 +-
 arch/x86/kvm/mmu.c                    |    4 ++--
 arch/x86/kvm/paging_tmpl.h            |    2 +-
 arch/x86/kvm/x86.c                    |    2 +-
 include/linux/kvm_host.h              |   28 ++++++++++++++++++++--------
 virt/kvm/iommu.c                      |    4 ++--
 virt/kvm/kvm_main.c                   |    6 +++---
 9 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_32_mmu_host.c b/arch/powerpc/kvm/book3s_32_mmu_host.c
index 9fac010..844d591 100644
--- a/arch/powerpc/kvm/book3s_32_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_32_mmu_host.c
@@ -155,7 +155,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte)

 	/* Get host physical address for gpa */
 	hpaddr = kvmppc_gfn_to_pfn(vcpu, orig_pte->raddr >> PAGE_SHIFT);
-	if (is_error_pfn(hpaddr)) {
+	if (is_error_noslot_pfn(hpaddr)) {
 		printk(KERN_INFO "Couldn't get guest page for gfn %lx!\n",
 				 orig_pte->eaddr);
 		r = -EINVAL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_host.c b/arch/powerpc/kvm/book3s_64_mmu_host.c
index 6b2c80e..53f390f 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -92,7 +92,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte)

 	/* Get host physical address for gpa */
 	hpaddr = kvmppc_gfn_to_pfn(vcpu, orig_pte->raddr >> PAGE_SHIFT);
-	if (is_error_pfn(hpaddr)) {
+	if (is_error_noslot_pfn(hpaddr)) {
 		printk(KERN_INFO "Couldn't get guest page for gfn %lx!\n", orig_pte->eaddr);
 		r = -EINVAL;
 		goto out;
diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index c733894..6305ee6 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -524,7 +524,7 @@ static inline void kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	if (likely(!pfnmap)) {
 		unsigned long tsize_pages = 1 << (tsize + 10 - PAGE_SHIFT);
 		pfn = gfn_to_pfn_memslot(slot, gfn);
-		if (is_error_pfn(pfn)) {
+		if (is_error_noslot_pfn(pfn)) {
 			printk(KERN_ERR "Couldn't get real page for gfn %lx!\n",
 					(long)gfn);
 			return;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 56c0e39..54c3557 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2699,7 +2699,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	 * PT_PAGE_TABLE_LEVEL and there would be no adjustment done
 	 * here.
 	 */
-	if (!is_error_pfn(pfn) && !kvm_is_mmio_pfn(pfn) &&
+	if (!is_error_noslot_pfn(pfn) && !kvm_is_mmio_pfn(pfn) &&
 	    level == PT_PAGE_TABLE_LEVEL &&
 	    PageTransCompound(pfn_to_page(pfn)) &&
 	    !has_wrprotected_page(vcpu->kvm, gfn, PT_DIRECTORY_LEVEL)) {
@@ -2733,7 +2733,7 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 	bool ret = true;

 	/* The pfn is invalid, report the error! */
-	if (unlikely(is_invalid_pfn(pfn))) {
+	if (unlikely(is_error_pfn(pfn))) {
 		*ret_val = kvm_handle_bad_page(vcpu, gfn, pfn);
 		goto exit;
 	}
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index f887e4c..89f3241 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -323,7 +323,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	protect_clean_gpte(&pte_access, gpte);
 	pfn = pte_prefetch_gfn_to_pfn(vcpu, gfn,
 			no_dirty_log && (pte_access & ACC_WRITE_MASK));
-	if (is_invalid_pfn(pfn))
+	if (is_error_pfn(pfn))
 		return false;

 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 841d09b..8b90dd5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4504,7 +4504,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
 	 * instruction -> ...
 	 */
 	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
-	if (!is_error_pfn(pfn)) {
+	if (!is_error_noslot_pfn(pfn)) {
 		kvm_release_pfn_clean(pfn);
 		return true;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6afc5be..e235068 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -58,28 +58,40 @@

 /*
  * For the normal pfn, the highest 12 bits should be zero,
- * so we can mask these bits to indicate the error.
+ * so we can mask bit 62 ~ bit 52  to indicate the error pfn,
+ * mask bit 63 to indicate the noslot pfn.
  */
-#define KVM_PFN_ERR_MASK	(0xfffULL << 52)
+#define KVM_PFN_ERR_MASK	(0x7ffULL << 52)
+#define KVM_PFN_ERR_NOSLOT_MASK	(0xfffULL << 52)
+#define KVM_PFN_NOSLOT		(0x1ULL << 63)

 #define KVM_PFN_ERR_FAULT	(KVM_PFN_ERR_MASK)
 #define KVM_PFN_ERR_HWPOISON	(KVM_PFN_ERR_MASK + 1)
-#define KVM_PFN_ERR_BAD		(KVM_PFN_ERR_MASK + 2)
-#define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 3)
+#define KVM_PFN_ERR_RO_FAULT	(KVM_PFN_ERR_MASK + 2)

+/*
+ * error pfns indicate that the gfn is in slot but faild to
+ * translate it to pfn on host.
+ */
 static inline bool is_error_pfn(pfn_t pfn)
 {
 	return !!(pfn & KVM_PFN_ERR_MASK);
 }

-static inline bool is_noslot_pfn(pfn_t pfn)
+/*
+ * error_noslot pfns indicate that the gfn can not be
+ * translated to pfn - it is not in slot or failed to
+ * translate it to pfn.
+ */
+static inline bool is_error_noslot_pfn(pfn_t pfn)
 {
-	return pfn == KVM_PFN_ERR_BAD;
+	return !!(pfn & KVM_PFN_ERR_NOSLOT_MASK);
 }

-static inline bool is_invalid_pfn(pfn_t pfn)
+/* noslot pfn indicates that the gfn is not in slot. */
+static inline bool is_noslot_pfn(pfn_t pfn)
 {
-	return !is_noslot_pfn(pfn) && is_error_pfn(pfn);
+	return pfn == KVM_PFN_NOSLOT;
 }

 #define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 18e1e30..4a340cb 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -52,7 +52,7 @@ static pfn_t kvm_pin_pages(struct kvm_memory_slot *slot, gfn_t gfn,
 	end_gfn = gfn + (size >> PAGE_SHIFT);
 	gfn    += 1;

-	if (is_error_pfn(pfn))
+	if (is_error_noslot_pfn(pfn))
 		return pfn;

 	while (gfn < end_gfn)
@@ -106,7 +106,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		 * important because we unmap and unpin in 4kb steps later.
 		 */
 		pfn = kvm_pin_pages(slot, gfn, page_size);
-		if (is_error_pfn(pfn)) {
+		if (is_error_noslot_pfn(pfn)) {
 			gfn += 1;
 			continue;
 		}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a65bc02..e26a55f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1208,7 +1208,7 @@ __gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn, bool atomic,
 		return KVM_PFN_ERR_RO_FAULT;

 	if (kvm_is_error_hva(addr))
-		return KVM_PFN_ERR_BAD;
+		return KVM_PFN_NOSLOT;

 	/* Do not map writable pfn in the readonly memslot. */
 	if (writable && memslot_is_readonly(slot)) {
@@ -1290,7 +1290,7 @@ EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);

 static struct page *kvm_pfn_to_page(pfn_t pfn)
 {
-	if (is_error_pfn(pfn))
+	if (is_error_noslot_pfn(pfn))
 		return KVM_ERR_PTR_BAD_PAGE;

 	if (kvm_is_mmio_pfn(pfn)) {
@@ -1322,7 +1322,7 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);

 void kvm_release_pfn_clean(pfn_t pfn)
 {
-	if (!is_error_pfn(pfn) && !kvm_is_mmio_pfn(pfn))
+	if (!is_error_noslot_pfn(pfn) && !kvm_is_mmio_pfn(pfn))
 		put_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
-- 
1.7.7.6

