Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2FTH6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:58:42 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:33423 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab2FTH6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:58:40 -0400
Message-ID: <4FE182A9.5080101@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 15:58:33 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v7 05/10] KVM: MMU: fold tlb flush judgement into mmu_spte_update
References: <4FE1822D.8010002@linux.vnet.ibm.com>
In-Reply-To: <4FE1822D.8010002@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062007-8256-0000-0000-000002FC10E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmu_spte_update() is the common function, we can easily audit the path

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   33 ++++++++++++++++++++-------------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a0ea746..6ebbb7a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -478,15 +478,24 @@ static void mmu_spte_set(u64 *sptep, u64 new_spte)

 /* Rules for using mmu_spte_update:
  * Update the state bits, it means the mapped pfn is not changged.
+ *
+ * Whenever we overwrite a writable spte with a read-only one we
+ * should flush remote TLBs. Otherwise rmap_write_protect
+ * will find a read-only spte, even though the writable spte
+ * might be cached on a CPU's TLB, the return value indicates this
+ * case.
  */
-static void mmu_spte_update(u64 *sptep, u64 new_spte)
+static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 {
 	u64 mask, old_spte = *sptep;
+	bool ret = false;

 	WARN_ON(!is_rmap_spte(new_spte));

-	if (!is_shadow_present_pte(old_spte))
-		return mmu_spte_set(sptep, new_spte);
+	if (!is_shadow_present_pte(old_spte)) {
+		mmu_spte_set(sptep, new_spte);
+		return ret;
+	}

 	new_spte |= old_spte & shadow_dirty_mask;

@@ -499,13 +508,18 @@ static void mmu_spte_update(u64 *sptep, u64 new_spte)
 	else
 		old_spte = __update_clear_spte_slow(sptep, new_spte);

+	if (is_writable_pte(old_spte) && !is_writable_pte(new_spte))
+		ret = true;
+
 	if (!shadow_accessed_mask)
-		return;
+		return ret;

 	if (spte_is_bit_cleared(old_spte, new_spte, shadow_accessed_mask))
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 	if (spte_is_bit_cleared(old_spte, new_spte, shadow_dirty_mask))
 		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+
+	return ret;
 }

 /*
@@ -2271,7 +2285,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    gfn_t gfn, pfn_t pfn, bool speculative,
 		    bool can_unsync, bool host_writable)
 {
-	u64 spte, entry = *sptep;
+	u64 spte;
 	int ret = 0;

 	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
@@ -2349,14 +2363,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		mark_page_dirty(vcpu->kvm, gfn);

 set_pte:
-	mmu_spte_update(sptep, spte);
-	/*
-	 * If we overwrite a writable spte with a read-only one we
-	 * should flush remote TLBs. Otherwise rmap_write_protect
-	 * will find a read-only spte, even though the writable spte
-	 * might be cached on a CPU's TLB.
-	 */
-	if (is_writable_pte(entry) && !is_writable_pte(*sptep))
+	if (mmu_spte_update(sptep, spte))
 		kvm_flush_remote_tlbs(vcpu->kvm);
 done:
 	return ret;
-- 
1.7.7.6

