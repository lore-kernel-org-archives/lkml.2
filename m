Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab2JKNGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:06:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40735 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab2JKNGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:06:20 -0400
Message-ID: <5076C444.8080309@gmail.com>
Date: Thu, 11 Oct 2012 21:06:12 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] KVM: MMU: fix release noslot pfn
References: <50716EE0.6010504@linux.vnet.ibm.com> <50716F1E.90308@linux.vnet.ibm.com> <20121010151125.GA28406@amt.cnet>
In-Reply-To: <20121010151125.GA28406@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 11:11 PM, Marcelo Tosatti wrote:

> 
> Why does is_error_pfn() return true for mmio spte? Its not an "error",
> after all. 
> 
> Please kill is_invalid_pfn and use
> 
> -> is_error_pfn for checking for errors (mmio spte is not an error pfn,
> its a special pfn)
> 
> -> add explicit is_noslot_pfn checks where necessary in the code
> (say to avoid interpreting a noslot_pfn's pfn "address" bits).
> 
> (should have noticed this earlier, sorry).

Never mind, your comments are always appreciated! ;)

Marcelo, is it good to you?
(will post it after your check and full test)

diff --git a/arch/powerpc/kvm/book3s_32_mmu_host.c b/arch/powerpc/kvm/book3s_32_mmu_host.c
index 837f13e..3a4d967 100644
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
index 0688b6b..6c230a2 100644
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
index ff38b66..4b47eeb 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -521,7 +521,7 @@ static inline void kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
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
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index daff69e..7709a75 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -116,7 +116,7 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
 	pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);

-	if (is_error_pfn(pfn))
+	if (is_error_noslot_pfn(pfn))
 		return;

 	hpa =  pfn << PAGE_SHIFT;
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
index 1eefebe..91f8f71 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4502,7 +4502,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
 	 * instruction -> ...
 	 */
 	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
-	if (!is_error_pfn(pfn)) {
+	if (!is_error_noslot_pfn(pfn)) {
 		kvm_release_pfn_clean(pfn);
 		return true;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 93bfc9f..45ff7c6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -58,28 +58,30 @@

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

 static inline bool is_error_pfn(pfn_t pfn)
 {
 	return !!(pfn & KVM_PFN_ERR_MASK);
 }

-static inline bool is_noslot_pfn(pfn_t pfn)
+static inline bool is_error_noslot_pfn(pfn_t pfn)
 {
-	return pfn == KVM_PFN_ERR_BAD;
+	return !!(pfn & KVM_PFN_ERR_NOSLOT_MASK);
 }

-static inline bool is_invalid_pfn(pfn_t pfn)
+static inline bool is_noslot_pfn(pfn_t pfn)
 {
-	return !is_noslot_pfn(pfn) && is_error_pfn(pfn);
+	return pfn == KVM_PFN_NOSLOT;
 }

 #define KVM_HVA_ERR_BAD		(PAGE_OFFSET)
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 037cb67..5534f46 100644
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
