Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab1FVOeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:34:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab1FVOeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:34:18 -0400
Message-ID: <4E01FDE0.5080800@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:36:16 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 21/22] KVM: MMU: mmio page fault support
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:33:51,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:33:51,
	Serialize complete at 2011-06-22 22:33:51
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

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |  156 ++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu.h         |    1 +
 arch/x86/kvm/paging_tmpl.h |   18 ++++--
 arch/x86/kvm/vmx.c         |   10 +++-
 4 files changed, 173 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1319050..e69a47a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -197,6 +197,41 @@ static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
 static u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
+static u64 __read_mostly shadow_mmio_mask = (0xffull << 49 | 1ULL);
+
+static void mmu_spte_set(u64 *sptep, u64 spte);
+
+static void mark_mmio_spte(u64 *sptep, u64 gfn, unsigned access)
+{
+	access &= ACC_WRITE_MASK | ACC_USER_MASK;
+
+	mmu_spte_set(sptep, shadow_mmio_mask | access | gfn << PAGE_SHIFT);
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
@@ -226,7 +261,7 @@ static int is_nx(struct kvm_vcpu *vcpu)
 
 static int is_shadow_present_pte(u64 pte)
 {
-	return pte != 0ull;
+	return pte != 0ull && !is_mmio_spte(pte);
 }
 
 static int is_large_pte(u64 pte)
@@ -2123,6 +2158,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	u64 spte, entry = *sptep;
 	int ret = 0;
 
+	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
+		return 0;
+
 	/*
 	 * We don't set the accessed bit, since we sometimes want to see
 	 * whether the guest actually used the pte (in order to detect
@@ -2258,6 +2296,9 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		kvm_mmu_flush_tlb(vcpu);
 	}
 
+	if (unlikely(is_mmio_spte(*sptep) && emulate))
+		*emulate = 1;
+
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 	pgprintk("instantiating %s PTE (%s) at %llx (%llx) addr %p\n",
 		 is_large_pte(*sptep)? "2MB" : "4kB",
@@ -2484,7 +2525,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 
 static bool mmu_invalid_pfn(pfn_t pfn)
 {
-	return unlikely(is_invalid_pfn(pfn) || is_mmio_pfn(pfn));
+	return unlikely(is_invalid_pfn(pfn));
 }
 
 static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
@@ -2498,11 +2539,8 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 		goto exit;
 	}
 
-	if (unlikely(is_mmio_pfn(pfn))) {
+	if (unlikely(is_mmio_pfn(pfn)))
 		vcpu_cache_mmio_info(vcpu, gva, gfn, access);
-		*ret_val = 1;
-		goto exit;
-	}
 
 	ret = false;
 exit:
@@ -2816,6 +2854,86 @@ static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
 	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, access);
 }
 
+static bool quickly_check_mmio_pf(struct kvm_vcpu *vcpu, u64 addr, bool direct)
+{
+	if (direct)
+		return vcpu_match_mmio_gpa(vcpu, addr);
+
+	return vcpu_match_mmio_gva(vcpu, addr);
+}
+
+static u64 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	u64 spte, ret = 0ull;
+
+	walk_shadow_page_lockless_begin(vcpu);
+	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
+		if (iterator.level == 1) {
+			ret = spte;
+			break;
+		}
+
+		if (!is_shadow_present_pte(spte))
+			break;
+	}
+	walk_shadow_page_lockless_end(vcpu);
+
+	return ret;
+}
+
+/*
+ * If it is a real mmio page fault, return 1 and emulat the instruction
+ * directly, return 0 if it needs page fault path to fix it, -1 is
+ * returned if bug is detected.
+ */
+int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
+{
+	u64 spte;
+
+	if (quickly_check_mmio_pf(vcpu, addr, direct))
+		return 1;
+
+	spte = walk_shadow_page_get_mmio_spte(vcpu, addr);
+
+	if (is_mmio_spte(spte)) {
+		gfn_t gfn = get_mmio_spte_gfn(spte);
+		unsigned access = get_mmio_spte_access(spte);
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
+	if (direct && is_shadow_present_pte(spte))
+		return -1;
+
+	/*
+	 * If the page table is zapped by other cpus, let the page
+	 * fault path to fix it.
+	 */
+	return 0;
+}
+EXPORT_SYMBOL_GPL(handle_mmio_page_fault_common);
+
+static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr,
+				  u32 error_code, bool direct)
+{
+	int ret;
+
+	if (likely(!(error_code & PFERR_RSVD_MASK)))
+		return 0;
+
+	ret = handle_mmio_page_fault_common(vcpu, addr, direct);
+	WARN_ON(ret < 0);
+	return ret;
+}
+
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				u32 error_code, bool prefault)
 {
@@ -2823,6 +2941,11 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
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
@@ -2899,6 +3022,10 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	ASSERT(vcpu);
 	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
+	r = handle_mmio_page_fault(vcpu, gpa, error_code, true);
+	if (r)
+		return r;
+
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
@@ -2996,6 +3123,23 @@ static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
 	return (gpte & mmu->rsvd_bits_mask[bit7][level-1]) != 0;
 }
 
+static bool sync_mmio_spte(u64 *sptep, gfn_t gfn, unsigned access,
+			   int *nr_present)
+{
+	if (unlikely(is_mmio_spte(*sptep))) {
+		if (gfn != get_mmio_spte_gfn(*sptep)) {
+			mmu_spte_clear_no_track(sptep);
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
 #define PTTYPE 64
 #include "paging_tmpl.h"
 #undef PTTYPE
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 05310b1..ebf09bf 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -49,6 +49,7 @@
 #define PFERR_FETCH_MASK (1U << 4)
 
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
+int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
 int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
 static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 870be69..cbdc1ae 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -583,6 +583,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
+	r = handle_mmio_page_fault(vcpu, addr, error_code, mmu_is_nested(vcpu));
+	if (r)
+		return r;
+
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
@@ -786,7 +790,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!is_shadow_present_pte(sp->spt[i]))
+		if (!sp->spt[i])
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
@@ -795,13 +799,18 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 					  sizeof(pt_element_t)))
 			return -EINVAL;
 
-		gfn = gpte_to_gfn(gpte);
-
 		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
 			vcpu->kvm->tlbs_dirty++;
 			continue;
 		}
 
+		gfn = gpte_to_gfn(gpte);
+		pte_access = sp->role.access;
+		pte_access &= FNAME(gpte_access)(vcpu, gpte, true);
+
+		if (sync_mmio_spte(&sp->spt[i], gfn, pte_access, &nr_present))
+			continue;
+
 		if (gfn != sp->gfns[i]) {
 			drop_spte(vcpu->kvm, &sp->spt[i]);
 			vcpu->kvm->tlbs_dirty++;
@@ -809,8 +818,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		}
 
 		nr_present++;
-		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte,
-								  true);
+
 		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
 
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a644acb..37a49f1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4671,11 +4671,19 @@ static void ept_misconfig_inspect_spte(struct kvm_vcpu *vcpu, u64 spte,
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 {
 	u64 sptes[4];
-	int nr_sptes, i;
+	int nr_sptes, i, ret;
 	gpa_t gpa;
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 
+	ret = handle_mmio_page_fault_common(vcpu, gpa, true);
+	if (likely(ret == 1))
+		return x86_emulate_instruction(vcpu, gpa, 0, NULL, 0) ==
+					      EMULATE_DONE;
+	if (unlikely(!ret))
+		return kvm_mmu_page_fault(vcpu, gpa, 0, NULL, 0);
+
+	/* It is the real ept misconfig */
 	printk(KERN_ERR "EPT: Misconfiguration.\n");
 	printk(KERN_ERR "EPT: GPA: 0x%llx\n", gpa);
 
-- 
1.7.5.4

