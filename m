Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1FGNFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:05:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55976 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab1FGNFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:05:08 -0400
Message-ID: <4DEE2281.1000008@cn.fujitsu.com>
Date: Tue, 07 Jun 2011 21:07:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 14/15] KVM: MMU: mmio page fault support
References: <4DEE205E.8000601@cn.fujitsu.com>
In-Reply-To: <4DEE205E.8000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 21:04:56,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 21:04:56,
	Serialize complete at 2011-06-07 21:04:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is from Avi:

| We could cache the result of a miss in an spte by using a reserved bit, and
| checking the page fault error code (or seeing if we get an ept violation or
| ept misconfiguration), so if we get repeated mmio on a page, we don't need to
| search the slot list/tree.
| (https://lkml.org/lkml/2011/2/22/221)

When the page fault is caused by mmio, we cache the info in the shadow page
table, and also set the reserved bits in the shadow page table, so if the mmio
is caused again, we can quickly identify it and emulate it directly

Searching mmio gfn in memslots is heavy since we need to walk all memeslots, it
can be reduced by this feature, and also avoid walking guest page table for
soft mmu.

This feature can be disabled/enabled at the runtime, if
shadow_notrap_nonpresent_pte is enabled, the PFER.RSVD is always set, we need
to walk shadow page table for all page fault, so disable this feature if
shadow_notrap_nonpresent is enabled.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |  149 ++++++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu.h         |    4 +-
 arch/x86/kvm/paging_tmpl.h |   32 +++++++++-
 arch/x86/kvm/vmx.c         |   12 +++-
 4 files changed, 180 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4f475ab..227cf10 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -91,6 +91,9 @@ module_param(dbg, bool, 0644);
 static int oos_shadow = 1;
 module_param(oos_shadow, bool, 0644);
 
+static int __read_mostly mmio_pf = 1;
+module_param(mmio_pf, bool, 0644);
+
 #ifndef MMU_DEBUG
 #define ASSERT(x) do { } while (0)
 #else
@@ -193,6 +196,44 @@ static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
 static u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
+static u64 __read_mostly shadow_mmio_mask = (0xffull << 49 | 1ULL);
+
+static void __set_spte(u64 *sptep, u64 spte)
+{
+	set_64bit(sptep, spte);
+}
+
+static void mark_mmio_spte(u64 *sptep, u64 gfn, unsigned access)
+{
+	access &= ACC_WRITE_MASK | ACC_USER_MASK;
+
+	__set_spte(sptep, shadow_mmio_mask | access | gfn << PAGE_SHIFT);
+}
+
+static bool is_mmio_spte(u64 spte)
+{
+	return (spte & shadow_mmio_mask) == shadow_mmio_mask;
+}
+
+static gfn_t get_mmio_spte_gfn(u64 spte)
+{
+	return (spte & ~shadow_mmio_mask) >> PAGE_SHIFT;
+}
+
+static unsigned get_mmio_spte_access(u64 spte)
+{
+	return (spte & ~shadow_mmio_mask) & ~PAGE_MASK;
+}
+
+static bool set_mmio_spte(u64 *sptep, gfn_t gfn, pfn_t pfn, unsigned access)
+{
+	if (unlikely(is_mmio_pfn(pfn))) {
+		mark_mmio_spte(sptep, gfn, access);
+		return true;
+	}
+
+	return false;
+}
 
 static inline u64 rsvd_bits(int s, int e)
 {
@@ -203,6 +244,8 @@ void kvm_mmu_set_nonpresent_ptes(u64 trap_pte, u64 notrap_pte)
 {
 	shadow_trap_nonpresent_pte = trap_pte;
 	shadow_notrap_nonpresent_pte = notrap_pte;
+	if (trap_pte != notrap_pte)
+		mmio_pf = 0;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_nonpresent_ptes);
 
@@ -230,7 +273,8 @@ static int is_nx(struct kvm_vcpu *vcpu)
 static int is_shadow_present_pte(u64 pte)
 {
 	return pte != shadow_trap_nonpresent_pte
-		&& pte != shadow_notrap_nonpresent_pte;
+		&& pte != shadow_notrap_nonpresent_pte
+		&& !is_mmio_spte(pte);
 }
 
 static int is_large_pte(u64 pte)
@@ -269,11 +313,6 @@ static gfn_t pse36_gfn_delta(u32 gpte)
 	return (gpte & PT32_DIR_PSE36_MASK) << shift;
 }
 
-static void __set_spte(u64 *sptep, u64 spte)
-{
-	set_64bit(sptep, spte);
-}
-
 static u64 __xchg_spte(u64 *sptep, u64 new_spte)
 {
 #ifdef CONFIG_X86_64
@@ -1972,6 +2011,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	u64 spte, entry = *sptep;
 	int ret = 0;
 
+	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
+		return 0;
+
 	/*
 	 * We don't set the accessed bit, since we sometimes want to see
 	 * whether the guest actually used the pte (in order to detect
@@ -2098,6 +2140,9 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		kvm_mmu_flush_tlb(vcpu);
 	}
 
+	if (unlikely(is_mmio_spte(*sptep) && emulate))
+		*emulate = 1;
+
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 	pgprintk("instantiating %s PTE (%s) at %llx (%llx) addr %p\n",
 		 is_large_pte(*sptep)? "2MB" : "4kB",
@@ -2324,7 +2369,10 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 
 static bool mmu_invalid_pfn(pfn_t pfn)
 {
-	return unlikely(is_invalid_pfn(pfn) || is_mmio_pfn(pfn));
+	if (unlikely(!mmio_pf && is_mmio_pfn(pfn)))
+		return true;
+
+	return unlikely(is_invalid_pfn(pfn));
 }
 
 static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
@@ -2340,8 +2388,10 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 
 	if (unlikely(is_mmio_pfn(pfn))) {
 		vcpu_cache_mmio_info(vcpu, gva, gfn, ACC_ALL);
-		*ret_val = 1;
-		goto exit;
+		if (!mmio_pf) {
+			*ret_val = 1;
+			goto exit;
+		}
 	}
 
 	ret = false;
@@ -2656,7 +2706,7 @@ static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
 	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, access);
 }
 
-int kvm_mmu_walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
+static int kvm_mmu_walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
 				      u64 sptes[4])
 {
 	struct kvm_shadow_walk_iterator iterator;
@@ -2683,7 +2733,75 @@ int kvm_mmu_walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
 
 	return nr_sptes;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_walk_shadow_page_lockless);
+
+static bool quickly_check_mmio_pf(struct kvm_vcpu *vcpu, u64 addr, bool direct)
+{
+	if (direct && vcpu_match_mmio_gpa(vcpu, addr))
+		return true;
+
+	if (vcpu_match_mmio_gva(vcpu, addr))
+		return true;
+
+	return false;
+}
+
+/*
+ * If it is a real mmio page fault, return 1 and emulat the instruction
+ * directly, return 0 if it needs page fault path to fix it, -1 is
+ * returned if bug is detected.
+ */
+int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr,
+				  u64 sptes[4], int *nr_sptes, bool direct)
+{
+	if (quickly_check_mmio_pf(vcpu, addr, direct))
+		return 1;
+
+	sptes[0] = shadow_trap_nonpresent_pte;
+	*nr_sptes = kvm_mmu_walk_shadow_page_lockless(vcpu, addr, sptes);
+
+	if (is_mmio_spte(sptes[0])) {
+		gfn_t gfn = get_mmio_spte_gfn(sptes[0]);
+		unsigned access = get_mmio_spte_access(sptes[0]);
+
+		if (direct)
+			addr = 0;
+		vcpu_cache_mmio_info(vcpu, addr, gfn, access);
+		return 1;
+	}
+
+	/*
+	 * It's ok if the gva is remapped by other cpus on shadow guest,
+	 * it's a BUG if the gfn is not a mmio page.
+	 */
+	if (direct && is_shadow_present_pte(sptes[0]))
+		return -1;
+
+	/*
+	 * It's ok if the page table is zapped by other cpus or the page
+	 * fault is caused by shadow_trap_nonpresent_pte, let the page
+	 * fault path to fix it.
+	 */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(handle_mmio_page_fault_common);
+
+static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr,
+				  u32 error_code, bool direct)
+{
+	u64 sptes[4];
+	int nr_sptes, ret;
+
+	if (!mmio_pf)
+		return 0;
+
+	if (!(error_code & PFERR_RSVD_MASK))
+		return 0;
+
+	ret = handle_mmio_page_fault_common(vcpu, addr, sptes, &nr_sptes,
+						 direct);
+	WARN_ON(ret < 0);
+	return ret;
+}
 
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				u32 error_code, bool prefault)
@@ -2692,6 +2810,11 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	int r;
 
 	pgprintk("%s: gva %lx error %x\n", __func__, gva, error_code);
+
+	r = handle_mmio_page_fault(vcpu, gva, error_code, true);
+	if (r)
+		return r;
+
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
@@ -2768,6 +2891,10 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	ASSERT(vcpu);
 	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
+	r = handle_mmio_page_fault(vcpu, gpa, error_code, true);
+	if (r)
+		return r;
+
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e7725c4..1da5ca7 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -48,8 +48,8 @@
 #define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)
 
-int kvm_mmu_walk_shadow_page_lockless(struct kvm_vcpu *vcpu, u64 addr,
-				      u64 sptes[4]);
+int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr,
+				  u64 sptes[4], int *nr_sptes, bool direct);
 
 int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 4f960b2..4287dc8 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -580,6 +580,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
+	r = handle_mmio_page_fault(vcpu, addr, error_code, mmu_is_nested(vcpu));
+	if (r)
+		return r;
+
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
@@ -779,6 +783,28 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 	}
 }
 
+static bool FNAME(sync_mmio_spte)(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu_page *sp, u64 *sptep,
+				  pt_element_t gpte, int *nr_present)
+{
+	if (unlikely(is_mmio_spte(*sptep))) {
+		gfn_t gfn = gpte_to_gfn(gpte);
+		unsigned access = sp->role.access & FNAME(gpte_access)(vcpu,
+							gpte);
+
+		if (gfn != get_mmio_spte_gfn(*sptep)) {
+			__set_spte(sptep, shadow_trap_nonpresent_pte);
+			return true;
+		}
+
+		(*nr_present)++;
+		mark_mmio_spte(sptep, gfn, access);
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Using the cached information from sp->gfns is safe because:
  * - The spte has a reference to the struct page, so the pfn for a given gfn
@@ -814,7 +840,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!is_shadow_present_pte(sp->spt[i]))
+		if (sp->spt[i] == shadow_trap_nonpresent_pte)
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
@@ -830,6 +856,10 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 			continue;
 		}
 
+		if (FNAME(sync_mmio_spte)(vcpu, sp, &sp->spt[i], gpte,
+						&nr_present))
+			continue;
+
 		if (gfn != sp->gfns[i]) {
 			drop_spte(vcpu->kvm, &sp->spt[i],
 				      shadow_trap_nonpresent_pte);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 8c3d343..2478e0b 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4673,16 +4673,22 @@ static void ept_misconfig_inspect_spte(struct kvm_vcpu *vcpu, u64 spte,
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 {
 	u64 sptes[4];
-	int nr_sptes, i;
+	int nr_sptes, i, ret;
 	gpa_t gpa;
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 
+	ret = handle_mmio_page_fault_common(vcpu, gpa, sptes, &nr_sptes, true);
+	if (likely(ret == 1))
+		return x86_emulate_instruction(vcpu, gpa, 0, NULL, 0) ==
+							EMULATE_DONE;
+	if (unlikely(!ret))
+		return kvm_mmu_page_fault(vcpu, gpa, 0, NULL, 0);
+
+	/* It is the real ept misconfig */
 	printk(KERN_ERR "EPT: Misconfiguration.\n");
 	printk(KERN_ERR "EPT: GPA: 0x%llx\n", gpa);
 
-	nr_sptes = kvm_mmu_walk_shadow_page_lockless(vcpu, gpa, sptes);
-
 	for (i = PT64_ROOT_LEVEL; i > PT64_ROOT_LEVEL - nr_sptes; --i)
 		ept_misconfig_inspect_spte(vcpu, sptes[i-1], i);
 
-- 
1.7.4.4

