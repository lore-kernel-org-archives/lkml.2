Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2FTH7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:59:12 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57387 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab2FTH7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:59:06 -0400
Message-ID: <4FE182C2.60307@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 15:58:58 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v7 06/10] KVM: MMU: introduce SPTE_MMU_WRITEABLE bit
References: <4FE1822D.8010002@linux.vnet.ibm.com>
In-Reply-To: <4FE1822D.8010002@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062007-9574-0000-0000-0000033C0FA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bit indicates whether the spte can be writable on MMU, that means
the corresponding gpte is writable and the corresponding gfn is not
protected by shadow page protection

In the later path, SPTE_MMU_WRITEABLE will indicates whether the spte
can be locklessly updated

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   57 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6ebbb7a..c3ca6e8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -145,7 +145,8 @@ module_param(dbg, bool, 0644);
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"

-#define SPTE_HOST_WRITEABLE (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))

 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)

@@ -1085,34 +1086,51 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 		kvm_flush_remote_tlbs(vcpu->kvm);
 }

+static bool spte_is_locklessly_modifiable(u64 spte)
+{
+	return !(~spte & (SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE));
+}
+
 /*
- * Write-protect on the specified @sptep due to dirty page logging or
- * protecting shadow page table. @flush indicates whether tlb need be
- * flushed.
+ * Write-protect on the specified @sptep, @pt_protect indicates whether
+ * spte writ-protection is caused by protecting shadow page table.
+ * @flush indicates whether tlb need be flushed.
+ *
+ * Note: write protection is difference between drity logging and spte
+ * protection:
+ * - for dirty logging, the spte can be set to writable at anytime if
+ *   its dirty bitmap is properly set.
+ * - for spte protection, the spte can be writable only after unsync-ing
+ *   shadow page.
  *
  * Return true if the spte is dropped.
  */
-static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush)
+static bool
+spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
 {
 	u64 spte = *sptep;

-	if (!is_writable_pte(spte))
+	if (!is_writable_pte(spte) &&
+	      !(pt_protect && spte_is_locklessly_modifiable(spte)))
 		return false;

 	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);

-	*flush |= true;
-
-	if (__drop_large_spte(kvm, sptep))
+	if (__drop_large_spte(kvm, sptep)) {
+		*flush |= true;
 		return true;
+	}

+	if (pt_protect)
+		spte &= ~SPTE_MMU_WRITEABLE;
 	spte = spte & ~PT_WRITABLE_MASK;
-	mmu_spte_update(sptep, spte);
+
+	*flush |= mmu_spte_update(sptep, spte);
 	return false;
 }

-static bool
-__rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
+static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
+				 int level, bool pt_protect)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1120,7 +1138,7 @@ __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)

 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
 		BUG_ON(!(*sptep & PT_PRESENT_MASK));
-		if (spte_write_protect(kvm, sptep, &flush)) {
+		if (spte_write_protect(kvm, sptep, &flush, pt_protect)) {
 			sptep = rmap_get_first(*rmapp, &iter);
 			continue;
 		}
@@ -1149,7 +1167,7 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,

 	while (mask) {
 		rmapp = &slot->rmap[gfn_offset + __ffs(mask)];
-		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL);
+		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL, false);

 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1168,7 +1186,7 @@ static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		rmapp = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmapp, i);
+		write_protected |= __rmap_write_protect(kvm, rmapp, i, true);
 	}

 	return write_protected;
@@ -2299,8 +2317,10 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte |= shadow_x_mask;
 	else
 		spte |= shadow_nx_mask;
+
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;
+
 	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
@@ -2325,7 +2345,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			goto done;
 		}

-		spte |= PT_WRITABLE_MASK;
+		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;

 		if (!vcpu->arch.mmu.direct_map
 		    && !(pte_access & ACC_WRITE_MASK)) {
@@ -2354,8 +2374,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				 __func__, gfn);
 			ret = 1;
 			pte_access &= ~ACC_WRITE_MASK;
-			if (is_writable_pte(spte))
-				spte &= ~PT_WRITABLE_MASK;
+			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
 		}
 	}

@@ -3935,7 +3954,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 			      !is_last_spte(pt[i], sp->role.level))
 				continue;

-			spte_write_protect(kvm, &pt[i], &flush);
+			spte_write_protect(kvm, &pt[i], &flush, false);
 		}
 	}
 	kvm_flush_remote_tlbs(kvm);
-- 
1.7.7.6

