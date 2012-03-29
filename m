Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab2C2J12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:27:28 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:51251 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2C2J1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:27:17 -0400
Message-ID: <4F742AE8.9020201@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 17:27:04 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 11/13] KVM: MMU: fast path of handling guest page fault
References: <4F742951.7080003@linux.vnet.ibm.com>
In-Reply-To: <4F742951.7080003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032909-4790-0000-0000-000001FDC6FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the the present bit of page fault error code is set, it indicates
the shadow page is populated on all levels, it means what we do is only
modify the access bit which can be done out of mmu-lock

The tricks in this patch is avoiding the race between fast page fault
path and write-protect path, write-protect path is a read-check-modify
path:
read spte, check W bit, then clear W bit. What we do is populating a
identification in spte, if write-protect meets it, it modify the spte
even if the spte is readonly. See the comment in the code to get more
information

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |  265 +++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/paging_tmpl.h |   41 +++++++
 2 files changed, 302 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a7f7aea..4a01be4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2767,18 +2767,267 @@ exit:
 	return ret;
 }

+static u32 page_fault_expected_access(u32 error_code)
+{
+	u32 access = 0;
+
+	if (error_code & PFERR_WRITE_MASK)
+		access |= ACC_WRITE_MASK;
+
+	if (error_code & PFERR_USER_MASK)
+		access |= ACC_USER_MASK;
+
+	if (error_code & PFERR_FETCH_MASK)
+		access |= ACC_EXEC_MASK;
+
+	return access;
+}
+
+static u32 spte_access(u64 spte)
+{
+	u32 access;
+
+	access = spte & PT_WRITABLE_MASK;
+
+	if (spte & shadow_user_mask)
+		access |= ACC_USER_MASK;
+
+	if (shadow_x_mask) {
+		if (spte & shadow_x_mask)
+			access |= ACC_EXEC_MASK;
+
+		return access;
+	}
+
+	if (!(spte & shadow_nx_mask))
+		access |= ACC_EXEC_MASK;
+
+	return access;
+}
+
+static bool spte_satisfied(u64 spte, u32 access)
+{
+	return (spte_access(spte) & access) == access;
+}
+
+static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, gfn_t gfn,
+				   u32 error_code)
+{
+	unsigned long *rmap;
+	bool write = error_code & PFERR_WRITE_MASK;
+
+	/*
+	 * #PF can be fast only if the shadow page table is present, that
+	 * means we just need change the access bits (e.g: R/W, U/S...)
+	 * which can be done out of mmu-lock.
+	 */
+	if (!(error_code & PFERR_PRESENT_MASK))
+		return false;
+
+	if (unlikely(vcpu->vcpu_id > max_vcpu_spte()))
+		return false;
+
+	rmap = gfn_to_rmap(vcpu->kvm, gfn, PT_PAGE_TABLE_LEVEL);
+
+	/* Quickly check the page can be writable. */
+	if (write && (ACCESS_ONCE(*rmap) & PTE_LIST_WRITE_PROTECT))
+		return false;
+
+	return true;
+}
+
+typedef bool (*fast_pf_fetch_spte)(struct kvm_vcpu *vcpu, u64 *sptep,
+				   u64 *new_spte, gfn_t gfn, u32 expect_access,
+				   u64 spte);
+
+static bool
+fast_pf_fetch_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 *new_spte,
+			  gfn_t gfn, u32 expect_access, u64 spte)
+{
+	struct kvm_mmu_page *sp = page_header(__pa(sptep));
+
+	WARN_ON(!sp->role.direct);
+
+	if (kvm_mmu_page_get_gfn(sp, sptep - sp->spt) != gfn)
+		return false;
+
+	set_spte(vcpu, new_spte, sp->role.access,
+		 expect_access & ACC_USER_MASK, expect_access & ACC_WRITE_MASK,
+		 sp->role.level, gfn, spte_to_pfn(spte), false, false,
+		 spte & SPTE_HOST_WRITEABLE, true);
+
+	return true;
+}
+
+static bool
+fast_page_fault_fix_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 spte,
+			 gfn_t gfn, u32 expect_access,
+			 fast_pf_fetch_spte fn)
+{
+	u64 new_spte = 0ull;
+	int vcpu_id = vcpu->vcpu_id;
+
+	spte = mark_vcpu_id_spte(sptep, spte, vcpu_id);
+
+	/*
+	 * Storing vcpu id into spte should be before read
+	 * PTE_LIST_WRITABLE bit.
+	 */
+	smp_mb();
+
+	/*
+	 * In most case, cmpxchg is enough to set access bits but we
+	 * should pay more attention to page write-protect path, it is
+	 * a read-check-modify path: read spte, check W bit, then clear
+	 * W bit. In order to avoid marking spte writable after/during
+	 * page write-protect, we do the trick like below:
+	 *
+	 *      fast page fault path:
+	 *            lock RCU
+	 *            set identification in the spte
+	 *            smp_mb()
+	 *            if (!rmap.PTE_LIST_WRITE_PROTECT)
+	 *                 cmpxchg + w - vcpu-id
+	 *            unlock RCU
+	 *
+	 *      write protect path:
+	 *            lock mmu-lock
+	 *            set rmap.PTE_LIST_WRITE_PROTECT
+	 *                 smp_mb()
+	 *            if (spte.w || spte has identification)
+	 *                 clear w bit and identification
+	 *            unlock mmu-lock
+	 *
+	 * Setting identification in the spte is used to notify
+	 * page-protect path to modify the spte, then we can see the
+	 * change in the cmpxchg.
+	 *
+	 * Setting identification is also a trick: it only set the last
+	 * bit of spte that does not change the mapping and lose cpu
+	 * status bits.
+	 *
+	 * The identification should be unique to avoid the below race:
+	 *
+	 *      VCPU 0                VCPU 1            VCPU 2
+	 *      lock RCU
+	 *   spte + identification
+	 *   check conditions
+	 *                       do write-protect, clear
+	 *                          identification
+	 *                                              lock RCU
+	 *                                        set identification
+	 *     cmpxchg + w - identification
+	 *        OOPS!!!
+	 *
+	 * We choose the vcpu id as the unique value.
+	 */
+
+	new_spte = 0ull;
+	if (!fn(vcpu, sptep, &new_spte, gfn, expect_access, spte))
+		return false;
+
+	if (!spte_satisfied(new_spte, expect_access))
+		return false;
+
+	/*
+	 * We can not remap a spte from writable to read-only out of
+	 * mmu-lock, since it need flush tlbs to sync guest page
+	 * write-protect.
+	 * See the comment in set_spte().
+	 */
+	if (unlikely(is_writable_pte(spte) && !is_writable_pte(new_spte)))
+		return false;
+
+	cmpxchg(sptep, spte, new_spte);
+
+	return true;
+}
+
+/*
+ * Return value:
+ * - true: let the vcpu to access on the same address again.
+ * - false: let the real page fault path to fix it.
+ */
+static bool
+fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn, int level,
+		u32 error_code, fast_pf_fetch_spte fn)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_mmu_page *sp;
+	u32 expected_access;
+	bool ret = false;
+	u64 spte = 0ull;
+
+	if (!page_fault_can_be_fast(vcpu, gfn, error_code))
+		return false;
+
+	walk_shadow_page_lockless_begin(vcpu);
+	for_each_shadow_entry_lockless(vcpu, gva, iterator, spte)
+		if (!is_shadow_present_pte(spte) || iterator.level < level)
+			break;
+
+	/*
+	 * If the mapping has been changed, let the vcpu fault on the
+	 * same address again.
+	 */
+	if (!is_rmap_spte(spte)) {
+		ret = true;
+		goto exit;
+	}
+
+	/*
+	 * Check if it is a spurious fault caused by TLB lazily flushed.
+	 *
+	 * Need not check the access of upper level table entries since
+	 * they are always ACC_ALL.
+	 */
+	expected_access = page_fault_expected_access(error_code);
+	if (spte_satisfied(spte, expected_access)) {
+		ret = true;
+		goto exit;
+	}
+
+	sp = page_header(__pa(iterator.sptep));
+	if (sp->role.level != level || !is_last_spte(spte, level))
+		goto exit;
+
+	/*
+	 * If the page fault is caused by write but host do not allow
+	 * to write the page, we need cow the host page.
+	 */
+	if ((error_code & PFERR_WRITE_MASK) && !(spte & SPTE_HOST_WRITEABLE))
+		goto exit;
+
+	/*
+	 * Do not expand the access of sp.
+	 *
+	 * Checking sp->role.access here is safe since it is never
+	 * changed after it is linked into shadow page table.
+	 */
+	if ((sp->role.access & expected_access) != expected_access)
+		goto exit;
+
+	ret = fast_page_fault_fix_spte(vcpu, iterator.sptep, spte, gfn,
+				       expected_access, fn);
+
+exit:
+	walk_shadow_page_lockless_end(vcpu);
+
+	return ret;
+}
+
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gva_t gva, pfn_t *pfn, bool write, bool *writable);

-static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
-			 bool prefault)
+static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
+			 gfn_t gfn, bool prefault)
 {
 	int r;
 	int level;
 	int force_pt_level;
 	pfn_t pfn;
 	unsigned long mmu_seq;
-	bool map_writable;
+	bool map_writable, write = error_code & PFERR_WRITE_MASK;

 	force_pt_level = mapping_level_dirty_bitmap(vcpu, gfn);
 	if (likely(!force_pt_level)) {
@@ -2795,6 +3044,10 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
 	} else
 		level = PT_PAGE_TABLE_LEVEL;

+	if (fast_page_fault(vcpu, v, gfn, level, error_code,
+			    fast_pf_fetch_direct_spte))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

@@ -3195,7 +3448,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	gfn = gva >> PAGE_SHIFT;

 	return nonpaging_map(vcpu, gva & PAGE_MASK,
-			     error_code & PFERR_WRITE_MASK, gfn, prefault);
+			     error_code, gfn, prefault);
 }

 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
@@ -3275,6 +3528,10 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	} else
 		level = PT_PAGE_TABLE_LEVEL;

+	if (fast_page_fault(vcpu, gpa, gfn, level, error_code,
+			    fast_pf_fetch_direct_spte))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index e2af5a5..e1694e8 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -568,6 +568,43 @@ static gpa_t FNAME(get_sp_gpa)(struct kvm_mmu_page *sp)
 	return gfn_to_gpa(sp->gfn) + offset;
 }

+static bool
+FNAME(fast_pf_fetch_indirect_spte)(struct kvm_vcpu *vcpu, u64 *sptep,
+				   u64 *new_spte, gfn_t gfn,
+				   u32 expect_access, u64 spte)
+
+{
+	struct kvm_mmu_page *sp = page_header(__pa(sptep));
+	pt_element_t gpte;
+	gpa_t pte_gpa;
+	unsigned pte_access;
+
+	if (sp->role.direct)
+		return fast_pf_fetch_direct_spte(vcpu, sptep, new_spte,
+						 gfn, expect_access, spte);
+
+	pte_gpa = FNAME(get_sp_gpa)(sp);
+	pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
+
+	if (kvm_read_guest_atomic(vcpu->kvm, pte_gpa, &gpte,
+				      sizeof(pt_element_t)))
+		return false;
+
+	if (FNAME(invalid_gpte)(vcpu, gpte))
+		return false;
+
+	if (gpte_to_gfn(gpte) != gfn)
+		return false;
+
+	pte_access = sp->role.access & FNAME(gpte_access)(vcpu, gpte, true);
+	set_spte(vcpu, new_spte, pte_access, expect_access & ACC_USER_MASK,
+		 expect_access & ACC_WRITE_MASK, sp->role.level, gfn,
+		 spte_to_pfn(spte), false, false,
+		 spte & SPTE_HOST_WRITEABLE, true);
+
+	return true;
+}
+
 /*
  * Page fault handler.  There are several causes for a page fault:
  *   - there is no shadow pte for the guest pte
@@ -632,6 +669,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		walker.gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}

+	if (fast_page_fault(vcpu, addr, walker.gfn, level,
+			    error_code, FNAME(fast_pf_fetch_indirect_spte)))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

-- 
1.7.7.6

