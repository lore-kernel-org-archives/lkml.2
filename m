Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab1FVO3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:29:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54162 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758113Ab1FVO3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:29:06 -0400
Message-ID: <4E01FCA8.3050401@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:31:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 07/22] KVM: MMU: cache mmio info on page fault path
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:28:39,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:28:40,
	Serialize complete at 2011-06-22 22:28:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the page fault is caused by mmio, we can cache the mmio info, later, we do
not need to walk guest page table and quickly know it is a mmio fault while we
emulate the mmio instruction

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    5 +++++
 arch/x86/kvm/mmu.c              |   21 +++++++--------------
 arch/x86/kvm/mmu.h              |   23 +++++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h      |   21 ++++++++++++++-------
 arch/x86/kvm/x86.c              |   11 +++++++++++
 arch/x86/kvm/x86.h              |   36 ++++++++++++++++++++++++++++++++++++
 6 files changed, 96 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index da6bbee..7b0834a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -415,6 +415,11 @@ struct kvm_vcpu_arch {
 	u64 mcg_ctl;
 	u64 *mce_banks;
 
+	/* Cache MMIO info */
+	u64 mmio_gva;
+	unsigned access;
+	gfn_t mmio_gfn;
+
 	/* used for guest single stepping over the given code position */
 	unsigned long singlestep_rip;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8316c2d..7f53210 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -217,11 +217,6 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mask_ptes);
 
-static bool is_write_protection(struct kvm_vcpu *vcpu)
-{
-	return kvm_read_cr0_bits(vcpu, X86_CR0_WP);
-}
-
 static int is_cpuid_PSE36(void)
 {
 	return 1;
@@ -243,11 +238,6 @@ static int is_large_pte(u64 pte)
 	return pte & PT_PAGE_SIZE_MASK;
 }
 
-static int is_writable_pte(unsigned long pte)
-{
-	return pte & PT_WRITABLE_MASK;
-}
-
 static int is_dirty_gpte(unsigned long pte)
 {
 	return pte & PT_DIRTY_MASK;
@@ -2247,15 +2237,17 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
 	send_sig_info(SIGBUS, &info, tsk);
 }
 
-static int kvm_handle_bad_page(struct kvm *kvm, gfn_t gfn, pfn_t pfn)
+static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gva_t gva,
+			       unsigned access, gfn_t gfn, pfn_t pfn)
 {
 	kvm_release_pfn_clean(pfn);
 	if (is_hwpoison_pfn(pfn)) {
-		kvm_send_hwpoison_signal(gfn_to_hva(kvm, gfn), current);
+		kvm_send_hwpoison_signal(gfn_to_hva(vcpu->kvm, gfn), current);
 		return 0;
 	} else if (is_fault_pfn(pfn))
 		return -EFAULT;
 
+	vcpu_cache_mmio_info(vcpu, gva, gfn, access);
 	return 1;
 }
 
@@ -2337,7 +2329,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
 
 	/* mmio */
 	if (is_error_pfn(pfn))
-		return kvm_handle_bad_page(vcpu->kvm, gfn, pfn);
+		return kvm_handle_bad_page(vcpu, v, ACC_ALL, gfn, pfn);
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
@@ -2564,6 +2556,7 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
 
+	vcpu_clear_mmio_info(vcpu, ~0ul);
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->arch.mmu.root_hpa;
@@ -2710,7 +2703,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 
 	/* mmio */
 	if (is_error_pfn(pfn))
-		return kvm_handle_bad_page(vcpu->kvm, gfn, pfn);
+		return kvm_handle_bad_page(vcpu, 0, 0, gfn, pfn);
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 7086ca8..05310b1 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -76,4 +76,27 @@ static inline int is_present_gpte(unsigned long pte)
 	return pte & PT_PRESENT_MASK;
 }
 
+static inline int is_writable_pte(unsigned long pte)
+{
+	return pte & PT_WRITABLE_MASK;
+}
+
+static inline bool is_write_protection(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr0_bits(vcpu, X86_CR0_WP);
+}
+
+static inline bool check_write_user_access(struct kvm_vcpu *vcpu,
+					   bool write_fault, bool user_fault,
+					   unsigned long pte)
+{
+	if (unlikely(write_fault && !is_writable_pte(pte)
+	      && (user_fault || is_write_protection(vcpu))))
+		return false;
+
+	if (unlikely(user_fault && !(pte & PT_USER_MASK)))
+		return false;
+
+	return true;
+}
 #endif
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 1caeb4d..13978dc 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -201,11 +201,8 @@ walk:
 			break;
 		}
 
-		if (unlikely(write_fault && !is_writable_pte(pte)
-			     && (user_fault || is_write_protection(vcpu))))
-			eperm = true;
-
-		if (unlikely(user_fault && !(pte & PT_USER_MASK)))
+		if (!check_write_user_access(vcpu, write_fault, user_fault,
+					  pte))
 			eperm = true;
 
 #if PTTYPE == 64
@@ -631,8 +628,16 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		return 0;
 
 	/* mmio */
-	if (is_error_pfn(pfn))
-		return kvm_handle_bad_page(vcpu->kvm, walker.gfn, pfn);
+	if (is_error_pfn(pfn)) {
+		unsigned access = walker.pte_access;
+		bool dirty = is_dirty_gpte(walker.ptes[walker.level - 1]);
+
+		if (dirty)
+			access &= ~ACC_WRITE_MASK;
+
+		return kvm_handle_bad_page(vcpu, mmu_is_nested(vcpu) ? 0 :
+					   addr, access, walker.gfn, pfn);
+	}
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu, mmu_seq))
@@ -672,6 +677,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 	u64 *sptep;
 	int need_flush = 0;
 
+	vcpu_clear_mmio_info(vcpu, gva);
+
 	spin_lock(&vcpu->kvm->mmu_lock);
 
 	for_each_shadow_entry(vcpu, gva, iterator) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index baa5a11..40ffbc5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3950,6 +3950,14 @@ static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 {
 	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 
+	if (vcpu_match_mmio_gva(vcpu, gva) &&
+		  check_write_user_access(vcpu, write, access,
+		  vcpu->arch.access)) {
+		*gpa = vcpu->arch.mmio_gfn << PAGE_SHIFT |
+					(gva & (PAGE_SIZE - 1));
+		return 1;
+	}
+
 	if (write)
 		access |= PFERR_WRITE_MASK;
 
@@ -3962,6 +3970,9 @@ static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 	if ((*gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
 		return 1;
 
+	if (vcpu_match_mmio_gpa(vcpu, *gpa))
+		return 1;
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 256da82..d36fe23 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -75,6 +75,42 @@ static inline u32 bit(int bitno)
 	return 1 << (bitno & 31);
 }
 
+static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
+					gva_t gva, gfn_t gfn, unsigned access)
+{
+	vcpu->arch.mmio_gva = gva & PAGE_MASK;
+	vcpu->arch.access = access;
+	vcpu->arch.mmio_gfn = gfn;
+}
+
+/*
+ * Clear the mmio cache info for the given gva,
+ * specially, if gva is ~0ul, we clear all mmio cache info.
+ */
+static inline void vcpu_clear_mmio_info(struct kvm_vcpu *vcpu, gva_t gva)
+{
+	if (gva != (~0ul) && vcpu->arch.mmio_gva != (gva & PAGE_MASK))
+		return;
+
+	vcpu->arch.mmio_gva = 0;
+}
+
+static inline bool vcpu_match_mmio_gva(struct kvm_vcpu *vcpu, unsigned long gva)
+{
+	if (vcpu->arch.mmio_gva && vcpu->arch.mmio_gva == (gva & PAGE_MASK))
+		return true;
+
+	return false;
+}
+
+static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	if (vcpu->arch.mmio_gfn && vcpu->arch.mmio_gfn == gpa >> PAGE_SHIFT)
+		return true;
+
+	return false;
+}
+
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
-- 
1.7.5.4

