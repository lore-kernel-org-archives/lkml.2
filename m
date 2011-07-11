Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab1GKTbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:31:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49365 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab1GKTbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:31:47 -0400
Message-ID: <4E1B5018.7070008@cn.fujitsu.com>
Date: Tue, 12 Jul 2011 03:33:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 17/18] KVM: MMU: mmio page fault support
References: <4E1B4CF8.605@cn.fujitsu.com>
In-Reply-To: <4E1B4CF8.605@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-12 03:31:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-12 03:31:04,
	Serialize complete at 2011-07-12 03:31:04
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
 arch/x86/kvm/mmu.c         |  192 ++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu.h         |    2 +
 arch/x86/kvm/paging_tmpl.h |   21 ++++--
 arch/x86/kvm/vmx.c         |   22 +++++-
 arch/x86/kvm/x86.c         |   25 ++++++
 virt/kvm/kvm_main.c        |    7 ++
 6 files changed, 255 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4b1aa67..6748f1b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -197,6 +197,47 @@ static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
 static u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
+static u64 __read_mostly shadow_mmio_mask;
+
+static void mmu_spte_set(u64 *sptep, u64 spte);
+
+void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask)
+{
+	shadow_mmio_mask = mmio_mask;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
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
+	if (unlikely(is_noslot_pfn(pfn))) {
+		mark_mmio_spte(sptep, gfn, access);
+		return true;
+	}
+
+	return false;
+}
 
 static inline u64 rsvd_bits(int s, int e)
 {
@@ -226,7 +267,7 @@ static int is_nx(struct kvm_vcpu *vcpu)
 
 static int is_shadow_present_pte(u64 pte)
 {
-	return pte & PT_PRESENT_MASK;
+	return pte & PT_PRESENT_MASK && !is_mmio_spte(pte);
 }
 
 static int is_large_pte(u64 pte)
@@ -285,6 +326,12 @@ static u64 __get_spte_lockless(u64 *sptep)
 {
 	return ACCESS_ONCE(*sptep);
 }
+
+static bool __check_direct_spte_mmio_pf(u64 spte)
+{
+	/* It is valid if the spte is zapped. */
+	return spte == 0ull;
+}
 #else
 union split_spte {
 	struct {
@@ -388,6 +435,23 @@ retry:
 
 	return spte.spte;
 }
+
+static bool __check_direct_spte_mmio_pf(u64 spte)
+{
+	union split_spte sspte = (union split_spte)spte;
+	u32 high_mmio_mask = shadow_mmio_mask >> 32;
+
+	/* It is valid if the spte is zapped. */
+	if (spte == 0ull)
+		return true;
+
+	/* It is valid if the spte is being zapped. */
+	if (sspte.spte_low == 0ull &&
+	      sspte.spte_high & high_mmio_mask == high_mmio_mask)
+		return true;
+
+	return false;
+}
 #endif
 
 static bool spte_has_volatile_bits(u64 spte)
@@ -1745,7 +1809,8 @@ static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
 		}
-	}
+	} else if (is_mmio_spte(pte))
+		mmu_spte_clear_no_track(spte);
 
 	if (is_large_pte(pte))
 		--kvm->stat.lpages;
@@ -2120,6 +2185,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	u64 spte, entry = *sptep;
 	int ret = 0;
 
+	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
+		return 0;
+
 	/*
 	 * We don't set the accessed bit, since we sometimes want to see
 	 * whether the guest actually used the pte (in order to detect
@@ -2255,6 +2323,9 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		kvm_mmu_flush_tlb(vcpu);
 	}
 
+	if (unlikely(is_mmio_spte(*sptep) && emulate))
+		*emulate = 1;
+
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 	pgprintk("instantiating %s PTE (%s) at %llx (%llx) addr %p\n",
 		 is_large_pte(*sptep)? "2MB" : "4kB",
@@ -2481,7 +2552,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 
 static bool mmu_invalid_pfn(pfn_t pfn)
 {
-	return unlikely(is_invalid_pfn(pfn) || is_noslot_pfn(pfn));
+	return unlikely(is_invalid_pfn(pfn));
 }
 
 static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
@@ -2495,11 +2566,8 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
 		goto exit;
 	}
 
-	if (unlikely(is_noslot_pfn(pfn))) {
+	if (unlikely(is_noslot_pfn(pfn)))
 		vcpu_cache_mmio_info(vcpu, gva, gfn, access);
-		*ret_val = 1;
-		goto exit;
-	}
 
 	ret = false;
 exit:
@@ -2813,6 +2881,92 @@ static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
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
+
+/*
+ * On direct hosts, the last spte is only allows two states
+ * for mmio page fault:
+ *   - It is the mmio spte
+ *   - It is zapped or it is being zapped.
+ *
+ * This function completely checks the spte when the last spte
+ * is not the mmio spte.
+ */
+static bool check_direct_spte_mmio_pf(u64 spte)
+{
+	return __check_direct_spte_mmio_pf(spte);
+}
+
+static u64 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	u64 spte = 0ull;
+
+	walk_shadow_page_lockless_begin(vcpu);
+	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte)
+		if (!is_shadow_present_pte(spte))
+			break;
+	walk_shadow_page_lockless_end(vcpu);
+
+	return spte;
+}
+
+/*
+ * If it is a real mmio page fault, return 1 and emulat the instruction
+ * directly, return 0 to let CPU fault again on the address, -1 is
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
+	if (direct && !check_direct_spte_mmio_pf(spte))
+		return -1;
+
+	/*
+	 * If the page table is zapped by other cpus, let CPU fault again on
+	 * the address.
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
+	ret = handle_mmio_page_fault_common(vcpu, addr, direct);
+	WARN_ON(ret < 0);
+	return ret;
+}
+
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				u32 error_code, bool prefault)
 {
@@ -2820,6 +2974,10 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	int r;
 
 	pgprintk("%s: gva %lx error %x\n", __func__, gva, error_code);
+
+	if (unlikely(error_code & PFERR_RSVD_MASK))
+		return handle_mmio_page_fault(vcpu, gva, error_code, true);
+
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
@@ -2896,6 +3054,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	ASSERT(vcpu);
 	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
+	if (unlikely(error_code & PFERR_RSVD_MASK))
+		return handle_mmio_page_fault(vcpu, gpa, error_code, true);
+
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
@@ -2993,6 +3154,23 @@ static bool is_rsvd_bits_set(struct kvm_mmu *mmu, u64 gpte, int level)
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
index 05310b1..e374db9 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -49,6 +49,8 @@
 #define PFERR_FETCH_MASK (1U << 4)
 
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
+void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
+int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
 int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
 static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 67998d3..507e2b8 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -577,6 +577,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
+	if (unlikely(error_code & PFERR_RSVD_MASK))
+		return handle_mmio_page_fault(vcpu, addr, error_code,
+					      mmu_is_nested(vcpu));
+
 	r = mmu_topup_memory_caches(vcpu);
 	if (r)
 		return r;
@@ -684,7 +688,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 					--vcpu->kvm->stat.lpages;
 				drop_spte(vcpu->kvm, sptep);
 				need_flush = 1;
-			}
+			} else if (is_mmio_spte(*sptep))
+				mmu_spte_clear_no_track(sptep);
 
 			break;
 		}
@@ -780,7 +785,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!is_shadow_present_pte(sp->spt[i]))
+		if (!sp->spt[i])
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
@@ -789,13 +794,18 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
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
@@ -803,8 +813,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		}
 
 		nr_present++;
-		pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte,
-								  true);
+
 		host_writable = sp->spt[i] & SPTE_HOST_WRITEABLE;
 
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a644acb..e65a158 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3594,6 +3594,17 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	return exec_control;
 }
 
+static void ept_set_mmio_spte_mask(void)
+{
+	/*
+	 * EPT Misconfigurations can be generated if the value of bits 2:0
+	 * of an EPT paging-structure entry is 110b (write/execute).
+	 * Also, magic bits (0xffull << 49) is set to quickly identify mmio
+	 * spte.
+	 */
+	kvm_mmu_set_mmio_spte_mask(0xffull << 49 | 0x6ull);
+}
+
 /*
  * Sets up the vmcs for emulated real mode.
  */
@@ -4671,11 +4682,19 @@ static void ept_misconfig_inspect_spte(struct kvm_vcpu *vcpu, u64 spte,
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
+		return 1;
+
+	/* It is the real ept misconfig */
 	printk(KERN_ERR "EPT: Misconfiguration.\n");
 	printk(KERN_ERR "EPT: GPA: 0x%llx\n", gpa);
 
@@ -7102,6 +7121,7 @@ static int __init vmx_init(void)
 	if (enable_ept) {
 		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
 				VMX_EPT_EXECUTABLE_MASK);
+		ept_set_mmio_spte_mask();
 		kvm_enable_tdp();
 	} else
 		kvm_disable_tdp();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1811f0c..84bfffb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4996,6 +4996,30 @@ void kvm_after_handle_nmi(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_after_handle_nmi);
 
+static void kvm_set_mmio_spte_mask(void)
+{
+	u64 mask;
+	int maxphyaddr = boot_cpu_data.x86_phys_bits;
+
+	/*
+	 * Set the reserved bits and the present bit of an paging-structure
+	 * entry to generate page fault with PFER.RSV = 1.
+	 */
+	mask = ((1ull << (62 - maxphyaddr + 1)) - 1) << maxphyaddr;
+	mask |= 1ull;
+
+#ifdef CONFIG_X86_64
+	/*
+	 * If reserved bit is not supported, clear the present bit to disable
+	 * mmio page fault.
+	 */
+	if (maxphyaddr == 52)
+		mask &= ~1ull;
+#endif
+
+	kvm_mmu_set_mmio_spte_mask(mask);
+}
+
 int kvm_arch_init(void *opaque)
 {
 	int r;
@@ -5022,6 +5046,7 @@ int kvm_arch_init(void *opaque)
 	if (r)
 		goto out;
 
+	kvm_set_mmio_spte_mask();
 	kvm_init_msr_list();
 
 	kvm_x86_ops = ops;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 59406cf..5413be9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -831,6 +831,13 @@ skip_lpage:
 
 	kvm_arch_commit_memory_region(kvm, mem, old, user_alloc);
 
+	/*
+	 * If the new memory slot is created, we need to clear all
+	 * mmio sptes.
+	 */
+	if (npages && old.base_gfn != mem->guest_phys_addr >> PAGE_SHIFT)
+		kvm_arch_flush_shadow(kvm);
+
 	kvm_free_physmem_slot(&old, &new);
 	kfree(old_memslots);
 
-- 
1.7.5.4

