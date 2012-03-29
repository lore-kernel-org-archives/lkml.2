Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab2C2J1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:27:13 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33114 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2C2J1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:27:08 -0400
Message-ID: <4F742AC1.3010205@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 17:26:25 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 10/13] KVM: MMU: store vcpu id in spte to notify page write-protect
 path
References: <4F742951.7080003@linux.vnet.ibm.com>
In-Reply-To: <4F742951.7080003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032909-5564-0000-0000-000002034F48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last byte of spte can be modified freely since cpu does not touch it
and no pfn mapping is in the area, but NX bit (if it exists) is in this
area, we always set it to reduce access

On the PAE shadow mode, vcpu id spte can cause the #PF with RSV = 1, it will
be treated as a mmio spte, we need filter it out in mmio path and clear the
vcpu id in spte to avoid generating the same fault again

It is used as a hit to notify page wirte-protect path that the spte is being
fetched by fast page fault path and it should be been reset

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |  120 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 102 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c029185..a7f7aea 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -147,7 +147,17 @@ module_param(dbg, bool, 0644);
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"

-#define SPTE_HOST_WRITEABLE (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+
+/*
+ * On the fast page fault path, we will store vcpu id in the last byte
+ * of spte out of mmu-lock, it is safe since cpu does not set these bits
+ * and no pfn mapping is in this area. But NX bit (if it exists) is in
+ * this area, we always set it to reduce access.
+ */
+#define VCPU_ID_SHIFT		56
+#define VCPU_ID_MASK		((1ull << (63 - VCPU_ID_SHIFT + 1)) - 1)
+#define SPTE_VCPU_ID_MASK	(VCPU_ID_MASK << VCPU_ID_SHIFT)

 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)

@@ -228,6 +238,49 @@ static bool set_mmio_spte(u64 *sptep, gfn_t gfn, pfn_t pfn, unsigned access)
 	return false;
 }

+static u64 spte_vcpu_id_mask(void)
+{
+	return SPTE_VCPU_ID_MASK & (~shadow_nx_mask);
+}
+
+static u64 mark_vcpu_id_spte(u64 *sptep, u64 spte, int vcpu_id)
+{
+	u64 mask = spte_vcpu_id_mask();
+	char *set = (char *)sptep + 7;
+
+	spte &= ~mask;
+	spte |= ((u64)(vcpu_id + 1) << VCPU_ID_SHIFT) | shadow_nx_mask;
+	*set = spte >> VCPU_ID_SHIFT;
+
+	return spte;
+}
+
+static bool is_vcpu_id_spte(u64 spte)
+{
+	return !!(spte & spte_vcpu_id_mask());
+}
+
+/*
+ * The NX bit can be lazily cleared since the executable mapping is hardly
+ * written in guest.
+ */
+static void clear_vcpu_id_spte(u64 *sptep)
+{
+	u64 mask = spte_vcpu_id_mask() >> VCPU_ID_SHIFT;
+	char *set = (char *)sptep + 7;
+
+	*set &= ~mask;
+}
+
+static int max_vcpu_spte(void)
+{
+	int max_vcpu;
+
+	max_vcpu = spte_vcpu_id_mask() >> VCPU_ID_SHIFT;
+
+	return max_vcpu - 1;
+}
+
 static inline u64 rsvd_bits(int s, int e)
 {
 	return ((1ULL << (e - s + 1)) - 1) << s;
@@ -1068,25 +1121,43 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)

 /* Return true if the spte is dropped. */
 static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
-			       int *flush)
+			       int *flush, bool page_table_protect)
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
+		goto reset_spte;
+	}

-		drop_spte(kvm, sptep);
-		--kvm->stat.lpages;
-		return true;
+	/*
+	 * Reset the spte to notify fast page fault path that the spte
+	 * has been changed.
+	 */
+	if (page_table_protect && is_vcpu_id_spte(spte)) {
+		/* The spte is fetched by the fast page fault path which
+		 * fixes the page fault out of mmu-lock, so we can safely
+		 * mask accssed bit here, it lets the spte to be updated
+		 * fast.
+		 */
+		spte |= shadow_accessed_mask;
+		clear_vcpu_id_spte(&spte);
+		goto reset_spte;
 	}

+	return false;
+
+reset_spte:
 	rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
 	spte = spte & ~PT_WRITABLE_MASK;
 	mmu_spte_update(sptep, spte);
@@ -1094,14 +1165,15 @@ static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
 	return false;
 }

-static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
+static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
+				int level, bool page_table_protect)
 {
 	u64 *spte = NULL;
 	int write_protected = 0;

 	while ((spte = rmap_next(rmapp, spte))) {
 		if (spte_write_protect(kvm, spte, level > PT_PAGE_TABLE_LEVEL,
-		      &write_protected))
+		      &write_protected, page_table_protect))
 			spte = NULL;
 	}

@@ -1126,7 +1198,7 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,

 	while (mask) {
 		rmapp = &slot->rmap[gfn_offset + __ffs(mask)];
-		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL);
+		__rmap_write_protect(kvm, rmapp, PT_PAGE_TABLE_LEVEL, false);

 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -1155,12 +1227,12 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 	smp_mb();

 	write_protected |= __rmap_write_protect(kvm, rmapp,
-						PT_PAGE_TABLE_LEVEL);
+						PT_PAGE_TABLE_LEVEL, true);

 	for (i = PT_DIRECTORY_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		rmapp = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmapp, i);
+		write_protected |= __rmap_write_protect(kvm, rmapp, i, true);
 	}

 	return write_protected;
@@ -3034,6 +3106,18 @@ static u64 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr)
 	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte)
 		if (!is_shadow_present_pte(spte))
 			break;
+
+	/*
+	 * On the PAE shadow mode, vcpu id spte can cause the #PF with
+	 * RSV = 1, we need clean the vcpu id to avoid generating the
+	 * same fault again.
+	 */
+	if ((vcpu->arch.mmu.shadow_root_level == PT32E_ROOT_LEVEL) &&
+	      is_vcpu_id_spte(spte)) {
+		clear_vcpu_id_spte(iterator.sptep);
+		spte = 0ull;
+	}
+
 	walk_shadow_page_lockless_end(vcpu);

 	return spte;
@@ -3971,7 +4055,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 				continue;

 			spte_write_protect(kvm, &pt[i],
-					   is_large_pte(pt[i]), &flush);
+					   is_large_pte(pt[i]), &flush, false);
 		}
 	}
 	kvm_flush_remote_tlbs(kvm);
-- 
1.7.7.6

