Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab2DYED3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 00:03:29 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44926 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2DYED1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 00:03:27 -0400
Message-ID: <4F97777D.1080707@linux.vnet.ibm.com>
Date: Wed, 25 Apr 2012 12:03:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 05/10] KVM: MMU: introduce SPTE_WRITE_PROTECT bit
References: <4F9776D2.7020506@linux.vnet.ibm.com>
In-Reply-To: <4F9776D2.7020506@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042418-3568-0000-0000-00000199B54D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this bit is set, it means the W bit of the spte is cleared due
to shadow page table protection

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   55 +++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 46bde3f..e7d8ffe 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -147,6 +147,7 @@ module_param(dbg, bool, 0644);

 #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
+#define SPTE_WRITE_PROTECT	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 2))

 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)

@@ -1042,36 +1043,53 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

+static bool spte_wp_by_dirty_log(u64 spte)
+{
+	u64 mask = SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE;
+
+	WARN_ON(is_writable_pte(spte));
+
+	return ((spte & mask) == mask) && !(spte & SPTE_WRITE_PROTECT);
+}
+
 /* Return true if the spte is dropped. */
 static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
-			       bool *flush)
+			       bool *flush, bool page_table_protect)
 {
 	u64 spte = *sptep;

-	if (!is_writable_pte(spte))
-		return false;
+	if (is_writable_pte(spte)) {
+		*flush |= true;

-	*flush |= true;
+		if (large) {
+			pgprintk("rmap_write_protect(large): spte %p %llx\n",
+				 spte, *spte);
+			BUG_ON(!is_large_pte(spte));

-	if (large) {
-		pgprintk("rmap_write_protect(large): spte %p %llx\n",
-			 spte, *spte);
-		BUG_ON(!is_large_pte(spte));
+			drop_spte(kvm, sptep);
+			--kvm->stat.lpages;
+			return true;
+		}

-		drop_spte(kvm, sptep);
-		--kvm->stat.lpages;
-		return true;
+		goto reset_spte;
 	}

+	if (page_table_protect && spte_wp_by_dirty_log(spte))
+		goto reset_spte;
+
+	return false;
+
+reset_spte:
 	rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
 	spte = spte & ~PT_WRITABLE_MASK;
+	if (page_table_protect)
+		spte |= SPTE_WRITE_PROTECT;
 	mmu_spte_update(sptep, spte);
-
 	return false;
 }

-static bool
-__rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
+static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
+				 int level, bool page_table_protect)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1080,7 +1098,7 @@ __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
 		BUG_ON(!(*sptep & PT_PRESENT_MASK));
 		if (spte_write_protect(kvm, sptep, level > PT_PAGE_TABLE_LEVEL,
-			  &write_protected)) {
+			  &write_protected, page_table_protect)) {
 			sptep = rmap_get_first(*rmapp, &iter);
 			continue;
 		}
@@ -1109,7 +1127,7 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,

 	while (mask) {
 		rmapp = &slot->rmap[gfn_offset + __ffs(mask)];
-		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL);
+		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL, false);

 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1128,7 +1146,7 @@ static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
 	for (i = PT_PAGE_TABLE_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		rmapp = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmapp, i);
+		write_protected |= __rmap_write_protect(kvm, rmapp, i, true);
 	}

 	return write_protected;
@@ -2352,6 +2370,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			ret = 1;
 			pte_access &= ~ACC_WRITE_MASK;
 			spte &= ~PT_WRITABLE_MASK;
+			spte |= SPTE_WRITE_PROTECT;
 		}
 	}

@@ -3940,7 +3959,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 				continue;

 			spte_write_protect(kvm, &pt[i],
-					   is_large_pte(pt[i]), &flush);
+					   is_large_pte(pt[i]), &flush, false);
 		}
 	}
 	kvm_flush_remote_tlbs(kvm);
-- 
1.7.7.6

