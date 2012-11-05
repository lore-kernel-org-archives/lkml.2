Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2KEJ7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:59:36 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:50074 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab2KEJ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:59:34 -0500
Message-ID: <50978DFE.1000005@linux.vnet.ibm.com>
Date: Mon, 05 Nov 2012 17:59:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: MMU: lazily drop large spte
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12110509-2674-0000-0000-0000069D9360
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not drop large spte until it can be insteaded by small pages so that
the guest can happliy read memory through it

The idea is from Avi:
| As I mentioned before, write-protecting a large spte is a good idea,
| since it moves some work from protect-time to fault-time, so it reduces
| jitter.  This removes the need for the return value.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   34 +++++++++-------------------------
 1 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b875a9e..1d8869c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1105,7 +1105,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)

 /*
  * Write-protect on the specified @sptep, @pt_protect indicates whether
- * spte writ-protection is caused by protecting shadow page table.
+ * spte write-protection is caused by protecting shadow page table.
  * @flush indicates whether tlb need be flushed.
  *
  * Note: write protection is difference between drity logging and spte
@@ -1114,31 +1114,23 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
  *   its dirty bitmap is properly set.
  * - for spte protection, the spte can be writable only after unsync-ing
  *   shadow page.
- *
- * Return true if the spte is dropped.
  */
-static bool
+static void
 spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush, bool pt_protect)
 {
 	u64 spte = *sptep;

 	if (!is_writable_pte(spte) &&
 	      !(pt_protect && spte_is_locklessly_modifiable(spte)))
-		return false;
+		return;

 	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);

-	if (__drop_large_spte(kvm, sptep)) {
-		*flush |= true;
-		return true;
-	}
-
 	if (pt_protect)
 		spte &= ~SPTE_MMU_WRITEABLE;
 	spte = spte & ~PT_WRITABLE_MASK;

 	*flush |= mmu_spte_update(sptep, spte);
-	return false;
 }

 static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,
@@ -1150,11 +1142,8 @@ static bool __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp,

 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
 		BUG_ON(!(*sptep & PT_PRESENT_MASK));
-		if (spte_write_protect(kvm, sptep, &flush, pt_protect)) {
-			sptep = rmap_get_first(*rmapp, &iter);
-			continue;
-		}

+		spte_write_protect(kvm, sptep, &flush, pt_protect);
 		sptep = rmap_get_next(&iter);
 	}

@@ -2381,14 +2370,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if ((pte_access & ACC_WRITE_MASK)
 	    || (!vcpu->arch.mmu.direct_map && write_fault
 		&& !is_write_protection(vcpu) && !user_fault)) {
-
-		if (level > PT_PAGE_TABLE_LEVEL &&
-		    has_wrprotected_page(vcpu->kvm, gfn, level)) {
-			ret = 1;
-			drop_spte(vcpu->kvm, sptep);
-			goto done;
-		}
-
 		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;

 		if (!vcpu->arch.mmu.direct_map
@@ -2413,7 +2394,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (!can_unsync && is_writable_pte(*sptep))
 			goto set_pte;

-		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
+		if ((level > PT_PAGE_TABLE_LEVEL &&
+		   has_wrprotected_page(vcpu->kvm, gfn, level)) ||
+		      mmu_need_write_protect(vcpu, gfn, can_unsync)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			ret = 1;
@@ -2428,7 +2411,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 set_pte:
 	if (mmu_spte_update(sptep, spte))
 		kvm_flush_remote_tlbs(vcpu->kvm);
-done:
 	return ret;
 }

@@ -2635,6 +2617,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 			break;
 		}

+		drop_large_spte(vcpu, iterator.sptep);
+
 		if (!is_shadow_present_pte(*iterator.sptep)) {
 			u64 base_addr = iterator.addr;

-- 
1.7.7.6

