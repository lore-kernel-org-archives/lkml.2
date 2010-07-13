Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0GMJt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:49:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64923 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab0GMJt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:49:26 -0400
Message-ID: <4C3C35B7.50101@cn.fujitsu.com>
Date: Tue, 13 Jul 2010 17:45:27 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 3/4] KVM: MMU: track dirty page in speculative path properly
References: <4C3C3518.7080505@cn.fujitsu.com>
In-Reply-To: <4C3C3518.7080505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In speculative path, the page is not real write-access, no need mark it
dirty, so clear dirty bit in this path and later examine this bit when
we release the page

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 67dbafa..5e9d4a0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -315,21 +315,19 @@ static void set_spte_atomic(u64 *sptep, u64 new_spte)
 	pfn = spte_to_pfn(old_spte);
 	if (old_spte & shadow_accessed_mask)
 		kvm_set_pfn_accessed(pfn);
-	if (is_writable_pte(old_spte))
+
+	if ((shadow_dirty_mask && (old_spte & shadow_dirty_mask)) ||
+	      (!shadow_dirty_mask && is_writable_pte(old_spte)))
 		kvm_set_pfn_dirty(pfn);
 }
 
 static void update_spte(u64 *sptep, u64 new_spte)
 {
-	u64 old_spte;
-
-	if (!shadow_accessed_mask || (new_spte & shadow_accessed_mask)) {
+	if ((!shadow_accessed_mask || (new_spte & shadow_accessed_mask)) &&
+	      (!shadow_dirty_mask || (new_spte & shadow_dirty_mask)))
 		__set_spte(sptep, new_spte);
-	} else {
-		old_spte = __xchg_spte(sptep, new_spte);
-		if (old_spte & shadow_accessed_mask)
-			mark_page_accessed(pfn_to_page(spte_to_pfn(old_spte)));
-	}
+	else
+		set_spte_atomic(sptep, new_spte);
 }
 
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
@@ -745,7 +743,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 		}
 		spte = rmap_next(kvm, rmapp, spte);
 	}
-	if (write_protected) {
+	if (!shadow_dirty_mask && write_protected) {
 		pfn_t pfn;
 
 		spte = rmap_next(kvm, rmapp, NULL);
@@ -1879,9 +1877,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	 * whether the guest actually used the pte (in order to detect
 	 * demand paging).
 	 */
-	spte = shadow_base_present_pte | shadow_dirty_mask;
+	spte = shadow_base_present_pte;
 	if (!speculative)
-		spte |= shadow_accessed_mask;
+		spte |= shadow_accessed_mask | shadow_dirty_mask;
 	if (!dirty)
 		pte_access &= ~ACC_WRITE_MASK;
 	if (pte_access & ACC_EXEC_MASK)
@@ -2007,7 +2005,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
 			rmap_recycle(vcpu, sptep, gfn);
 	} else {
-		if (was_writable)
+		if (!shadow_dirty_mask && was_writable)
 			kvm_release_pfn_dirty(pfn);
 		else
 			kvm_release_pfn_clean(pfn);
-- 
1.6.1.2


