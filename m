Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2KEMLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:11:16 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59302 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab2KEMLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:11:14 -0500
Message-ID: <5097ACD7.5030201@linux.vnet.ibm.com>
Date: Mon, 05 Nov 2012 20:11:03 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/5] KVM: MMU: simplify set_spte
References: <5097AC70.1080904@linux.vnet.ibm.com>
In-Reply-To: <5097AC70.1080904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12110512-5140-0000-0000-00000251E66C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is more cleaner if we can update pte_access fist then set spte according
to pte_access, also introduce gfn_need_write_protect to check whether the
gfn need to be write-protected

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |  109 ++++++++++++++++++++++++++++++++--------------------
 1 files changed, 67 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4ea731e..49957df 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2329,6 +2329,63 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return 0;
 }

+static bool gfn_need_write_protect(struct kvm_vcpu *vcpu, u64 *sptep,
+				   int level,  gfn_t gfn, bool can_unsync)
+{
+	/*
+	 * Optimization: for pte sync, if spte was writable the hash
+	 * lookup is unnecessary (and expensive). Write protection
+	 * is responsibility of mmu_get_page / kvm_sync_page.
+	 * Same reasoning can be applied to dirty page accounting.
+	 */
+	if (!can_unsync && is_writable_pte(*sptep))
+		return false;
+
+	if ((level > PT_PAGE_TABLE_LEVEL &&
+	   has_wrprotected_page(vcpu->kvm, gfn, level)) ||
+	      mmu_need_write_protect(vcpu, gfn, can_unsync))
+		return true;
+
+	return false;
+}
+
+/* The return value indicates whether the @gfn need to be write protected. */
+static bool vcpu_adjust_access(struct kvm_vcpu *vcpu, u64 *sptep,
+			       unsigned *pte_access, int user_fault,
+			       int write_fault, int level, gfn_t gfn,
+			       bool can_unsync, bool host_writable)
+{
+	bool ret = false;
+	unsigned access = *pte_access;
+
+	if (!host_writable)
+		access &= ~ACC_WRITE_MASK;
+
+	if (!(access & ACC_WRITE_MASK) && (!vcpu->arch.mmu.direct_map &&
+	      write_fault && !is_write_protection(vcpu) && !user_fault)) {
+		access |= ACC_WRITE_MASK;
+		access &= ~ACC_USER_MASK;
+
+		/*
+		 * If we converted a user page to a kernel page,
+		 * so that the kernel can write to it when cr0.wp=0,
+		 * then we should prevent the kernel from executing it
+		 * if SMEP is enabled.
+		 */
+		if (kvm_read_cr4_bits(vcpu, X86_CR4_SMEP))
+			access &= ~ACC_EXEC_MASK;
+	}
+
+	if ((access & ACC_WRITE_MASK) &&
+		  gfn_need_write_protect(vcpu, sptep, level, gfn, can_unsync)) {
+		access &= ~ACC_WRITE_MASK;
+		ret = true;
+	}
+
+	*pte_access = access;
+	return ret;
+}
+
 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned pte_access, int user_fault,
 		    int write_fault, int level,
@@ -2341,6 +2398,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
 		return 0;

+	ret = vcpu_adjust_access(vcpu, sptep, &pte_access, user_fault,
+		      write_fault, level, gfn, can_unsync, host_writable);
+
 	spte = PT_PRESENT_MASK;
 	if (!speculative)
 		spte |= shadow_accessed_mask;
@@ -2353,61 +2413,26 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;

+	if (pte_access & ACC_WRITE_MASK) {
+		spte |= PT_WRITABLE_MASK;
+		spte |= SPTE_MMU_WRITEABLE;
+	}
+
 	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
+
 	if (tdp_enabled)
 		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));

 	if (host_writable)
 		spte |= SPTE_HOST_WRITEABLE;
-	else
-		pte_access &= ~ACC_WRITE_MASK;

 	spte |= (u64)pfn << PAGE_SHIFT;

-	if ((pte_access & ACC_WRITE_MASK)
-	    || (!vcpu->arch.mmu.direct_map && write_fault
-		&& !is_write_protection(vcpu) && !user_fault)) {
-		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
-
-		if (!vcpu->arch.mmu.direct_map
-		    && !(pte_access & ACC_WRITE_MASK)) {
-			spte &= ~PT_USER_MASK;
-			/*
-			 * If we converted a user page to a kernel page,
-			 * so that the kernel can write to it when cr0.wp=0,
-			 * then we should prevent the kernel from executing it
-			 * if SMEP is enabled.
-			 */
-			if (kvm_read_cr4_bits(vcpu, X86_CR4_SMEP))
-				spte |= PT64_NX_MASK;
-		}
-
-		/*
-		 * Optimization: for pte sync, if spte was writable the hash
-		 * lookup is unnecessary (and expensive). Write protection
-		 * is responsibility of mmu_get_page / kvm_sync_page.
-		 * Same reasoning can be applied to dirty page accounting.
-		 */
-		if (!can_unsync && is_writable_pte(*sptep))
-			goto set_pte;
-
-		if ((level > PT_PAGE_TABLE_LEVEL &&
-		   has_wrprotected_page(vcpu->kvm, gfn, level)) ||
-		      mmu_need_write_protect(vcpu, gfn, can_unsync)) {
-			pgprintk("%s: found shadow page for %llx, marking ro\n",
-				 __func__, gfn);
-			ret = 1;
-			pte_access &= ~ACC_WRITE_MASK;
-			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
-		}
-	}
-
-	if (pte_access & ACC_WRITE_MASK)
+	if (is_writable_pte(spte))
 		mark_page_dirty(vcpu->kvm, gfn);

-set_pte:
 	if (mmu_spte_update(sptep, spte))
 		kvm_flush_remote_tlbs(vcpu->kvm);
 	return ret;
-- 
1.7.7.6

