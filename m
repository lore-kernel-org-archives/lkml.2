Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1IVIy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:54:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab1IVIy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:54:26 -0400
Message-ID: <4E7AF847.7080206@cn.fujitsu.com>
Date: Thu, 22 Sep 2011 16:56:39 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 07/11] KVM: MMU: fast prefetch spte on invlpg path
References: <4E7AF758.7060900@cn.fujitsu.com>
In-Reply-To: <4E7AF758.7060900@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:53:04,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:53:04,
	Serialize complete at 2011-09-22 16:53:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fast prefetch spte for the unsync shadow page on invlpg path

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    4 +---
 arch/x86/kvm/mmu.c              |   38 +++++++++++++++-----------------------
 arch/x86/kvm/paging_tmpl.h      |   30 ++++++++++++++++++------------
 arch/x86/kvm/x86.c              |    4 ++--
 4 files changed, 36 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 58ea3a7..927ba73 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -460,7 +460,6 @@ struct kvm_arch {
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
-	atomic_t invlpg_counter;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
@@ -754,8 +753,7 @@ int fx_init(struct kvm_vcpu *vcpu);
 
 void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu);
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-		       const u8 *new, int bytes,
-		       bool guest_initiated);
+		       const u8 *new, int bytes);
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 805a9d5..4128aba 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3530,8 +3530,7 @@ static bool last_updated_pte_accessed(struct kvm_vcpu *vcpu)
 }
 
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-		       const u8 *new, int bytes,
-		       bool guest_initiated)
+		       const u8 *new, int bytes)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	union kvm_mmu_page_role mask = { .word = 0 };
@@ -3540,7 +3539,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	LIST_HEAD(invalid_list);
 	u64 entry, gentry, *spte;
 	unsigned pte_size, page_offset, misaligned, quadrant, offset;
-	int level, npte, invlpg_counter, r, flooded = 0;
+	int level, npte, r, flooded = 0;
 	bool remote_flush, local_flush, zap_page;
 
 	/*
@@ -3555,19 +3554,16 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 	pgprintk("%s: gpa %llx bytes %d\n", __func__, gpa, bytes);
 
-	invlpg_counter = atomic_read(&vcpu->kvm->arch.invlpg_counter);
-
 	/*
 	 * Assume that the pte write on a page table of the same type
 	 * as the current vcpu paging mode since we update the sptes only
 	 * when they have the same mode.
 	 */
-	if ((is_pae(vcpu) && bytes == 4) || !new) {
+	if (is_pae(vcpu) && bytes == 4) {
 		/* Handle a 32-bit guest writing two halves of a 64-bit gpte */
-		if (is_pae(vcpu)) {
-			gpa &= ~(gpa_t)7;
-			bytes = 8;
-		}
+		gpa &= ~(gpa_t)7;
+		bytes = 8;
+
 		r = kvm_read_guest(vcpu->kvm, gpa, &gentry, min(bytes, 8));
 		if (r)
 			gentry = 0;
@@ -3593,22 +3589,18 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	 */
 	mmu_topup_memory_caches(vcpu);
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
-		gentry = 0;
 	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
-	if (guest_initiated) {
-		if (gfn == vcpu->arch.last_pt_write_gfn
-		    && !last_updated_pte_accessed(vcpu)) {
-			++vcpu->arch.last_pt_write_count;
-			if (vcpu->arch.last_pt_write_count >= 3)
-				flooded = 1;
-		} else {
-			vcpu->arch.last_pt_write_gfn = gfn;
-			vcpu->arch.last_pt_write_count = 1;
-			vcpu->arch.last_pte_updated = NULL;
-		}
+	if (gfn == vcpu->arch.last_pt_write_gfn
+	    && !last_updated_pte_accessed(vcpu)) {
+		++vcpu->arch.last_pt_write_count;
+		if (vcpu->arch.last_pt_write_count >= 3)
+			flooded = 1;
+	} else {
+		vcpu->arch.last_pt_write_gfn = gfn;
+		vcpu->arch.last_pt_write_count = 1;
+		vcpu->arch.last_pte_updated = NULL;
 	}
 
 	mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index d8d3906..9efb860 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -672,20 +672,27 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
-	gpa_t pte_gpa = -1;
 	int level;
 	u64 *sptep;
 
 	vcpu_clear_mmio_info(vcpu, gva);
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	/*
+	 * No need to check return value here, rmap_can_add() can
+	 * help us to skip pte prefetch later.
+	 */
+	mmu_topup_memory_caches(vcpu);
 
+	spin_lock(&vcpu->kvm->mmu_lock);
 	for_each_shadow_entry(vcpu, gva, iterator) {
 		level = iterator.level;
 		sptep = iterator.sptep;
 
 		sp = page_header(__pa(sptep));
 		if (is_last_spte(*sptep, level)) {
+			pt_element_t gpte;
+			gpa_t pte_gpa;
+
 			if (!sp->unsync)
 				break;
 
@@ -694,22 +701,21 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 
 			if (mmu_page_zap_pte(vcpu->kvm, sp, sptep))
 				kvm_flush_remote_tlbs(vcpu->kvm);
+
+			if (!rmap_can_add(vcpu))
+				break;
+
+			if (kvm_read_guest_atomic(vcpu->kvm, pte_gpa, &gpte,
+						  sizeof(pt_element_t)))
+				break;
+
+			FNAME(update_pte)(vcpu, sp, sptep, &gpte);
 		}
 
 		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
 			break;
 	}
-
-	atomic_inc(&vcpu->kvm->arch.invlpg_counter);
-
 	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	if (pte_gpa == -1)
-		return;
-
-	if (mmu_topup_memory_caches(vcpu))
-		return;
-	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t), 0);
 }
 
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a69a3e5..9206e39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4065,7 +4065,7 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 	ret = kvm_write_guest(vcpu->kvm, gpa, val, bytes);
 	if (ret < 0)
 		return 0;
-	kvm_mmu_pte_write(vcpu, gpa, val, bytes, 1);
+	kvm_mmu_pte_write(vcpu, gpa, val, bytes);
 	return 1;
 }
 
@@ -4302,7 +4302,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (!exchanged)
 		return X86EMUL_CMPXCHG_FAILED;
 
-	kvm_mmu_pte_write(vcpu, gpa, new, bytes, 1);
+	kvm_mmu_pte_write(vcpu, gpa, new, bytes);
 
 	return X86EMUL_CONTINUE;
 
-- 
1.7.5.4

