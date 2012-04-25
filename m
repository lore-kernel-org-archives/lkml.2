Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab2DYEEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 00:04:12 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44987 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2DYEEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 00:04:09 -0400
Message-ID: <4F9777A4.208@linux.vnet.ibm.com>
Date: Wed, 25 Apr 2012 12:03:48 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
References: <4F9776D2.7020506@linux.vnet.ibm.com>
In-Reply-To: <4F9776D2.7020506@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042418-3568-0000-0000-00000199B588
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the the present bit of page fault error code is set, it indicates
the shadow page is populated on all levels, it means what we do is
only modify the access bit which can be done out of mmu-lock

Currently, in order to simplify the code, we only fix the page fault
caused by write-protect on the fast path

In order to better review, we hold mmu-lock to update spte in this
patch, the concurrent update will be introduced in the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |  113 ++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/paging_tmpl.h |    3 +
 2 files changed, 112 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e7d8ffe..96a9d5b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2683,18 +2683,117 @@ exit:
 	return ret;
 }

+static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, gfn_t gfn,
+				   u32 error_code)
+{
+	/*
+	 * #PF can be fast only if the shadow page table is present and it
+	 * is caused by write-protect, that means we just need change the
+	 * W bit of the spte which can be done out of mmu-lock.
+	 */
+	if (!(error_code & PFERR_PRESENT_MASK) ||
+	      !(error_code & PFERR_WRITE_MASK))
+		return false;
+
+	return true;
+}
+
+static bool
+fast_pf_fix_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+		  u64 *sptep, u64 spte)
+{
+	gfn_t gfn;
+
+	spin_lock(&vcpu->kvm->mmu_lock);
+
+	/* The spte has been changed. */
+	if (*sptep != spte)
+		goto exit;
+
+	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+
+	*sptep = spte | PT_WRITABLE_MASK;
+	mark_page_dirty(vcpu->kvm, gfn);
+
+exit:
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	return true;
+}
+
+/*
+ * Return value:
+ * - true: let the vcpu to access on the same address again.
+ * - false: let the real page fault path to fix it.
+ */
+static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
+			    int level, u32 error_code)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_mmu_page *sp;
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
+	if (!is_last_spte(spte, level))
+		goto exit;
+
+	/*
+	 * Check if it is a spurious fault caused by TLB lazily flushed.
+	 *
+	 * Need not check the access of upper level table entries since
+	 * they are always ACC_ALL.
+	 */
+	 if (is_writable_pte(spte)) {
+		ret = true;
+		goto exit;
+	}
+
+	/*
+	 * Currently, to simplify the code, only the spte write-protected
+	 * by dirty-log can be fast fixed.
+	 */
+	if (!spte_wp_by_dirty_log(spte))
+		goto exit;
+
+	sp = page_header(__pa(iterator.sptep));
+
+	ret = fast_pf_fix_spte(vcpu, sp, iterator.sptep, spte);
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
@@ -2711,6 +2810,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
 	} else
 		level = PT_PAGE_TABLE_LEVEL;

+	if (fast_page_fault(vcpu, v, gfn, level, error_code))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

@@ -3099,7 +3201,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	gfn = gva >> PAGE_SHIFT;

 	return nonpaging_map(vcpu, gva & PAGE_MASK,
-			     error_code & PFERR_WRITE_MASK, gfn, prefault);
+			     error_code, gfn, prefault);
 }

 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
@@ -3179,6 +3281,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	} else
 		level = PT_PAGE_TABLE_LEVEL;

+	if (fast_page_fault(vcpu, gpa, gfn, level, error_code))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index df5a703..80493fb 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -617,6 +617,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		walker.gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}

+	if (fast_page_fault(vcpu, addr, walker.gfn, level, error_code))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

-- 
1.7.7.6

