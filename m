Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2E2Gt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:49:28 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55716 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2E2Gt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:49:26 -0400
Message-ID: <4FC4716A.8030304@linux.vnet.ibm.com>
Date: Tue, 29 May 2012 14:49:14 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 5/9] KVM: MMU: introduce SPTE_MMU_WRITEABLE bit
References: <4FC470C7.5040700@linux.vnet.ibm.com>
In-Reply-To: <4FC470C7.5040700@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052820-6102-0000-0000-00000196D5C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bit indicates whether the spte can be writable on MMU, that means
the corresponding gpte is writable and the corresponding gfn is not
protected by shadow page protection

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   41 +++++++++++++++++++++++++++--------------
 1 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4810992..150c5ad 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -145,7 +145,8 @@ module_param(dbg, bool, 0644);
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"

-#define SPTE_HOST_WRITEABLE (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))

 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)

@@ -1065,32 +1066,43 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

+static bool spte_can_be_writable(u64 spte)
+{
+	return !(~spte & (SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE));
+}
+
 /* Return true if the spte is dropped. */
-static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush)
+static bool
+spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
 {
 	u64 spte = *sptep;

-	if (!is_writable_pte(spte))
+	if (!is_writable_pte(spte) &&
+	      !(pt_protect && spte_can_be_writable(spte)))
 		return false;

 	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);

-	*flush |= true;
 	if (is_large_pte(spte)) {
 		WARN_ON(page_header(__pa(sptep))->role.level ==
 		       PT_PAGE_TABLE_LEVEL);
+
+		*flush |= true;
 		drop_spte(kvm, sptep);
 		--kvm->stat.lpages;
 		return true;
 	}

+	if (pt_protect)
+		spte &= ~SPTE_MMU_WRITEABLE;
 	spte = spte & ~PT_WRITABLE_MASK;
-	mmu_spte_update(sptep, spte);
+
+	*flush = mmu_spte_update(sptep, spte);
 	return false;
 }

-static bool
-__rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
+static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
+				 int level, bool pt_protect)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1098,7 +1110,7 @@ __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)

 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
 		BUG_ON(!(*sptep & PT_PRESENT_MASK));
-		if (spte_write_protect(kvm, sptep, &flush)) {
+		if (spte_write_protect(kvm, sptep, &flush, pt_protect)) {
 			sptep = rmap_get_first(*rmapp, &iter);
 			continue;
 		}
@@ -1127,7 +1139,7 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,

 	while (mask) {
 		rmapp = &slot->rmap[gfn_offset + __ffs(mask)];
-		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL);
+		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL, false);

 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1146,7 +1158,7 @@ static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		rmapp = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmapp, i);
+		write_protected |= __rmap_write_protect(kvm, rmapp, i, true);
 	}

 	return write_protected;
@@ -2284,8 +2296,10 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
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
@@ -2310,7 +2324,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			goto done;
 		}

-		spte |= PT_WRITABLE_MASK;
+		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;

 		if (!vcpu->arch.mmu.direct_map
 		    && !(pte_access & ACC_WRITE_MASK)) {
@@ -2339,8 +2353,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				 __func__, gfn);
 			ret = 1;
 			pte_access &= ~ACC_WRITE_MASK;
-			if (is_writable_pte(spte))
-				spte &= ~PT_WRITABLE_MASK;
+			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
 		}
 	}

@@ -3921,7 +3934,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 			      !is_last_spte(pt[i], sp->role.level))
 				continue;

-			spte_write_protect(kvm, &pt[i], &flush);
+			spte_write_protect(kvm, &pt[i], &flush, false);
 		}
 	}
 	kvm_flush_remote_tlbs(kvm);
-- 
1.7.7.6

