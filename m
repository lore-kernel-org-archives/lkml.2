Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148Ab2DMKPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:15:33 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53723 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934935Ab2DMKPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:15:30 -0400
Message-ID: <4F87FCBB.6040200@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:15:23 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 12/16] KVM: MMU: introduce SPTE_WRITE_PROTECT bit
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041300-7014-0000-0000-000000E5DC5F
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
index 1a06776..578a1e2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -147,6 +147,7 @@ module_param(dbg, bool, 0644);

 #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 #define SPTE_ALLOW_WRITE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
+#define SPTE_WRITE_PROTECT	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 2))

 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)

@@ -1108,33 +1109,49 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

+static bool spte_wp_by_dirty_log(u64 spte)
+{
+	WARN_ON(is_writable_pte(spte));
+
+	return (spte & SPTE_ALLOW_WRITE) && !(spte & SPTE_WRITE_PROTECT);
+}
+
 static void spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
-			       bool *flush)
+			       bool *flush, bool page_table_protect)
 {
 	u64 spte = *sptep;

-	if (!is_writable_pte(spte))
-		return;
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
+			return;
+		}

-		drop_spte(kvm, sptep);
-		--kvm->stat.lpages;
-		return;
+		goto reset_spte;
 	}

+	if (page_table_protect && spte_wp_by_dirty_log(spte))
+		goto reset_spte;
+
+	return;
+
+reset_spte:
 	rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
 	spte = spte & ~PT_WRITABLE_MASK;
+	if (page_table_protect)
+		spte |= SPTE_WRITE_PROTECT;
 	mmu_spte_update(sptep, spte);
 }

-static bool
-__rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
+static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
+				 int level, bool page_table_protect)
 {
 	u64 *sptep;
 	struct spte_iterator iter;
@@ -1142,7 +1159,7 @@ __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)

 	for_each_rmap_spte(rmapp, &iter, sptep)
 		spte_write_protect(kvm, sptep, level > PT_PAGE_TABLE_LEVEL,
-			  &write_protected);
+			  &write_protected, page_table_protect);

 	return write_protected;
 }
@@ -1165,7 +1182,7 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,

 	while (mask) {
 		rmapp = &slot->rmap[gfn_offset + __ffs(mask)];
-		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL);
+		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL, false);

 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1186,7 +1203,7 @@ static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
 		return false;

 	do {
-		write_protected |= __rmap_write_protect(kvm, rmapp, i++);
+		write_protected |= __rmap_write_protect(kvm, rmapp, i++, true);

 		if (i >= PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES)
 			break;
@@ -1239,7 +1256,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			new_spte |= (u64)new_pfn << PAGE_SHIFT;

 			new_spte &= ~(PT_WRITABLE_MASK | SPTE_HOST_WRITEABLE |
-				      shadow_accessed_mask | SPTE_ALLOW_WRITE);
+				      shadow_accessed_mask | SPTE_ALLOW_WRITE |
+				      SPTE_WRITE_PROTECT);

 			mmu_spte_clear_track_bits(sptep);
 			mmu_spte_set(sptep, new_spte);
@@ -2416,6 +2434,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			ret = 1;
 			pte_access &= ~ACC_WRITE_MASK;
 			spte &= ~PT_WRITABLE_MASK;
+			spte |= SPTE_WRITE_PROTECT;
 		}
 	}

@@ -3992,7 +4011,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 				continue;

 			spte_write_protect(kvm, &pt[i],
-					   is_large_pte(pt[i]), &flush);
+					   is_large_pte(pt[i]), &flush, false);
 		}
 	}
 	kvm_flush_remote_tlbs(kvm);
-- 
1.7.7.6

