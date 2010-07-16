Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935458Ab0GPCMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:12:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65490 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935355Ab0GPCMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:12:37 -0400
Message-ID: <4C3FC02C.4080802@cn.fujitsu.com>
Date: Fri, 16 Jul 2010 10:13:00 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 3/6] kvm: rename gfn_to_pfn() etc.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gfn_to_pfn() does actually increase the reference of the page.
But "gfn_to_pfn" is questionable, it misses this semantic.
So we rename it to kvm_get_pfn_for_gfn() which make more sense.

gfn_to_page() and hva_to_pfn() are also renamed.

(no behavior changed)


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 5cb5865..fe220d6 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1589,7 +1589,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		return -ENOMEM;
 
 	for (i = 0; i < npages; i++) {
-		pfn = gfn_to_pfn(kvm, base_gfn + i);
+		pfn = kvm_get_pfn_for_gfn(kvm, base_gfn + i);
 		if (!kvm_is_mmio_pfn(pfn)) {
 			kvm_set_pmt_entry(kvm, base_gfn + i,
 					pfn << PAGE_SHIFT,
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 8123125..aeb67aa 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -314,7 +314,7 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gpa_t gpaddr,
 
 	/* Get reference to new page. */
 	gfn = gpaddr >> PAGE_SHIFT;
-	new_page = gfn_to_page(vcpu->kvm, gfn);
+	new_page = kvm_get_page_for_gfn(vcpu->kvm, gfn);
 	if (is_error_page(new_page)) {
 		printk(KERN_ERR "Couldn't get guest page for gfn %lx!\n", gfn);
 		kvm_release_page_clean(new_page);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index a3cef30..1611292 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -414,7 +414,7 @@ static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, struct kvmppc_pte *pte)
 	u32 *page;
 	int i;
 
-	hpage = gfn_to_page(vcpu->kvm, pte->raddr >> PAGE_SHIFT);
+	hpage = kvm_get_page_for_gfn(vcpu->kvm, pte->raddr >> PAGE_SHIFT);
 	if (is_error_page(hpage))
 		return;
 
diff --git a/arch/powerpc/kvm/book3s_32_mmu_host.c b/arch/powerpc/kvm/book3s_32_mmu_host.c
index 0b51ef8..94b4907 100644
--- a/arch/powerpc/kvm/book3s_32_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_32_mmu_host.c
@@ -147,7 +147,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte)
 	struct hpte_cache *pte;
 
 	/* Get host physical address for gpa */
-	hpaddr = gfn_to_pfn(vcpu->kvm, orig_pte->raddr >> PAGE_SHIFT);
+	hpaddr = kvm_get_pfn_for_gfn(vcpu->kvm, orig_pte->raddr >> PAGE_SHIFT);
 	if (kvm_is_error_hva(hpaddr)) {
 		printk(KERN_INFO "Couldn't get guest page for gfn %lx!\n",
 				 orig_pte->eaddr);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_host.c b/arch/powerpc/kvm/book3s_64_mmu_host.c
index 384179a..414a001 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -101,7 +101,7 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte)
 	struct kvmppc_sid_map *map;
 
 	/* Get host physical address for gpa */
-	hpaddr = gfn_to_pfn(vcpu->kvm, orig_pte->raddr >> PAGE_SHIFT);
+	hpaddr = kvm_get_pfn_for_gfn(vcpu->kvm, orig_pte->raddr >> PAGE_SHIFT);
 	if (kvm_is_error_hva(hpaddr)) {
 		printk(KERN_INFO "Couldn't get guest page for gfn %lx!\n", orig_pte->eaddr);
 		return -EINVAL;
diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index f11ca0f..026e5c7 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -299,7 +299,7 @@ static inline void kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	stlbe = &vcpu_e500->shadow_tlb[tlbsel][esel];
 
 	/* Get reference to new page. */
-	new_page = gfn_to_page(vcpu_e500->vcpu.kvm, gfn);
+	new_page = kvm_get_page_for_gfn(vcpu_e500->vcpu.kvm, gfn);
 	if (is_error_page(new_page)) {
 		printk(KERN_ERR "Couldn't get guest page for gfn %lx!\n", gfn);
 		kvm_release_page_clean(new_page);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1f3cbb8..0867ced 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2097,7 +2097,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
-	pfn = gfn_to_pfn(vcpu->kvm, gfn);
+	pfn = kvm_get_pfn_for_gfn(vcpu->kvm, gfn);
 
 	/* mmio */
 	if (is_error_pfn(pfn))
@@ -2319,7 +2319,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
-	pfn = gfn_to_pfn(vcpu->kvm, gfn);
+	pfn = kvm_get_pfn_for_gfn(vcpu->kvm, gfn);
 	if (is_error_pfn(pfn))
 		return kvm_handle_bad_page(vcpu->kvm, gfn, pfn);
 	spin_lock(&vcpu->kvm->mmu_lock);
@@ -2696,7 +2696,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	vcpu->arch.update_pte.mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
-	pfn = gfn_to_pfn(vcpu->kvm, gfn);
+	pfn = kvm_get_pfn_for_gfn(vcpu->kvm, gfn);
 
 	if (is_error_pfn(pfn)) {
 		kvm_release_pfn_clean(pfn);
@@ -3376,7 +3376,7 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 		else {
 			gpa_t gpa = kvm_mmu_gva_to_gpa_read(vcpu, va, NULL);
 			gfn_t gfn = gpa >> PAGE_SHIFT;
-			pfn_t pfn = gfn_to_pfn(vcpu->kvm, gfn);
+			pfn_t pfn = kvm_get_pfn_for_gfn(vcpu->kvm, gfn);
 			hpa_t hpa = (hpa_t)pfn << PAGE_SHIFT;
 
 			if (is_error_pfn(pfn)) {
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6daeacf..ac24158 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -87,7 +87,7 @@ static bool FNAME(cmpxchg_gpte)(struct kvm *kvm,
 	pt_element_t *table;
 	struct page *page;
 
-	page = gfn_to_page(kvm, table_gfn);
+	page = kvm_get_page_for_gfn(kvm, table_gfn);
 
 	table = kmap_atomic(page, KM_USER0);
 	ret = CMPXCHG(&table[index], orig_pte, new_pte);
@@ -461,7 +461,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
-	pfn = gfn_to_pfn(vcpu->kvm, walker.gfn);
+	pfn = kvm_get_pfn_for_gfn(vcpu->kvm, walker.gfn);
 
 	/* mmio */
 	if (is_error_pfn(pfn))
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 56c9b6b..0a3d4c5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1670,7 +1670,7 @@ static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, struct page **_page)
 
 	might_sleep();
 
-	page = gfn_to_page(svm->vcpu.kvm, gpa >> PAGE_SHIFT);
+	page = kvm_get_page_for_gfn(svm->vcpu.kvm, gpa >> PAGE_SHIFT);
 	if (is_error_page(page))
 		goto error;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b40731e..1e361ff 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2425,7 +2425,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
 	if (r)
 		goto out;
 
-	kvm->arch.apic_access_page = gfn_to_page(kvm, 0xfee00);
+	kvm->arch.apic_access_page = kvm_get_page_for_gfn(kvm, 0xfee00);
 out:
 	mutex_unlock(&kvm->slots_lock);
 	return r;
@@ -2448,7 +2448,7 @@ static int alloc_identity_pagetable(struct kvm *kvm)
 	if (r)
 		goto out;
 
-	kvm->arch.ept_identity_pagetable = gfn_to_page(kvm,
+	kvm->arch.ept_identity_pagetable = kvm_get_page_for_gfn(kvm,
 			kvm->arch.ept_identity_map_addr >> PAGE_SHIFT);
 out:
 	mutex_unlock(&kvm->slots_lock);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f2fb50..cc0abb7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1285,8 +1285,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		/* ...but clean it before doing the actual write */
 		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
 
-		vcpu->arch.time_page =
-				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
+		vcpu->arch.time_page = kvm_get_page_for_gfn(vcpu->kvm,
+				data >> PAGE_SHIFT);
 
 		if (is_error_page(vcpu->arch.time_page)) {
 			kvm_release_page_clean(vcpu->arch.time_page);
@@ -3561,7 +3561,7 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 	if (((gpa + bytes - 1) & PAGE_MASK) != (gpa & PAGE_MASK))
 		goto emul_write;
 
-	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+	page = kvm_get_page_for_gfn(vcpu->kvm, gpa >> PAGE_SHIFT);
 
 	kaddr = kmap_atomic(page, KM_USER0);
 	kaddr += offset_in_page(gpa);
@@ -4563,7 +4563,7 @@ static void vapic_enter(struct kvm_vcpu *vcpu)
 	if (!apic || !apic->vapic_addr)
 		return;
 
-	page = gfn_to_page(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
+	page = kvm_get_page_for_gfn(vcpu->kvm, apic->vapic_addr >> PAGE_SHIFT);
 
 	vcpu->arch.apic->vapic_page = page;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c13cc48..0c61df9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -289,16 +289,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 void kvm_disable_largepages(void);
 void kvm_arch_flush_shadow(struct kvm *kvm);
 
-struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
+struct page *kvm_get_page_for_gfn(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);
 
-pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
-pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
-			 struct kvm_memory_slot *slot, gfn_t gfn);
+pfn_t kvm_get_pfn_for_gfn(struct kvm *kvm, gfn_t gfn);
+pfn_t kvm_get_pfn_for_gfn_memslot(struct kvm *kvm,
+		struct kvm_memory_slot *slot, gfn_t gfn);
 int memslot_id(struct kvm *kvm, gfn_t gfn);
 void kvm_release_pfn_dirty(pfn_t);
 void kvm_release_pfn_clean(pfn_t pfn);
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 62a9caf..a5a2421 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -40,7 +40,7 @@ static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
 	gfn_t end_gfn;
 	pfn_t pfn;
 
-	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
+	pfn     = kvm_get_pfn_for_gfn_memslot(kvm, slot, gfn);
 	end_gfn = gfn + (size >> PAGE_SHIFT);
 	gfn    += 1;
 
@@ -48,7 +48,7 @@ static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return pfn;
 
 	while (gfn < end_gfn)
-		gfn_to_pfn_memslot(kvm, slot, gfn++);
+		kvm_get_pfn_for_gfn_memslot(kvm, slot, gfn++);
 
 	return pfn;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b78b794..3a702b9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -694,7 +694,7 @@ skip_lpage:
 		 * memslot will be created.
 		 *
 		 * validation of sp->gfn happens in:
-		 * 	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
+		 * 	- gfn_to_hva (kvm_read_guest, kvm_get_pfn_for_gfn)
 		 * 	- kvm_is_visible_gfn (mmu_check_roots)
 		 */
 		kvm_arch_flush_shadow(kvm);
@@ -943,7 +943,7 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_hva);
 
-static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
+static pfn_t kvm_get_pfn_for_hva(struct kvm *kvm, unsigned long addr)
 {
 	struct page *page[1];
 	int npages;
@@ -981,7 +981,7 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
 	return pfn;
 }
 
-pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
+pfn_t kvm_get_pfn_for_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	unsigned long addr;
 
@@ -991,22 +991,22 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 		return page_to_pfn(bad_page);
 	}
 
-	return hva_to_pfn(kvm, addr);
+	return kvm_get_pfn_for_hva(kvm, addr);
 }
-EXPORT_SYMBOL_GPL(gfn_to_pfn);
+EXPORT_SYMBOL_GPL(kvm_get_pfn_for_gfn);
 
-pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
-			 struct kvm_memory_slot *slot, gfn_t gfn)
+pfn_t kvm_get_pfn_for_gfn_memslot(struct kvm *kvm,
+		struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
-	return hva_to_pfn(kvm, addr);
+	return kvm_get_pfn_for_hva(kvm, addr);
 }
 
-struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
+struct page *kvm_get_page_for_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	pfn_t pfn;
 
-	pfn = gfn_to_pfn(kvm, gfn);
+	pfn = kvm_get_pfn_for_gfn(kvm, gfn);
 	if (!kvm_is_mmio_pfn(pfn))
 		return pfn_to_page(pfn);
 
@@ -1015,8 +1015,7 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 	get_page(bad_page);
 	return bad_page;
 }
-
-EXPORT_SYMBOL_GPL(gfn_to_page);
+EXPORT_SYMBOL_GPL(kvm_get_page_for_gfn);
 
 void kvm_release_page_clean(struct page *page)
 {
