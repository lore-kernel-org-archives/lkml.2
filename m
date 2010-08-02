Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab0HBITY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:19:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62948 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab0HBITX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:19:23 -0400
Message-ID: <4C567E8C.3090305@cn.fujitsu.com>
Date: Mon, 02 Aug 2010 16:15:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 3/3] KVM: MMU: mark page dirty only when page is really
 written
References: <4C4E5313.1080308@cn.fujitsu.com> <4C4E536E.7030109@cn.fujitsu.com> <4C4E53F7.7050108@cn.fujitsu.com>
In-Reply-To: <4C4E53F7.7050108@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark page dirty only when this page is really written, it's more exacter,
and also can fix dirty page marking in speculation path

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   47 ++++++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e18834c..9c69725 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -311,24 +311,42 @@ static bool spte_has_volatile_bits(u64 spte)
 	if (!is_shadow_present_pte(spte))
 		return false;
 
-	if (spte & shadow_accessed_mask)
+	if ((spte & shadow_accessed_mask) &&
+	      (!is_writable_pte(spte) || (spte & shadow_dirty_mask)))
 		return false;
 
 	return true;
 }
 
+static bool spte_is_bit_cleared(u64 old_spte, u64 new_spte, u64 bit_mask)
+{
+	return (old_spte & bit_mask) && !(new_spte & bit_mask);
+}
+
 static void update_spte(u64 *sptep, u64 new_spte)
 {
-	u64 old_spte;
+	u64 mask, old_spte = *sptep;
+
+	WARN_ON(!is_rmap_spte(new_spte));
 
-	if (!shadow_accessed_mask || (new_spte & shadow_accessed_mask) ||
-	      !is_rmap_spte(*sptep))
+	new_spte |= old_spte & shadow_dirty_mask;
+
+	mask = shadow_accessed_mask;
+	if (is_writable_pte(old_spte))
+		mask |= shadow_dirty_mask;
+
+	if (!spte_has_volatile_bits(old_spte) || (new_spte & mask) == mask)
 		__set_spte(sptep, new_spte);
-	else {
+	else
 		old_spte = __xchg_spte(sptep, new_spte);
-		if (old_spte & shadow_accessed_mask)
-			kvm_set_pfn_accessed(spte_to_pfn(old_spte));
-	}
+
+	if (!shadow_accessed_mask)
+		return;
+
+	if (spte_is_bit_cleared(old_spte, new_spte, shadow_accessed_mask))
+		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+	if (spte_is_bit_cleared(old_spte, new_spte, shadow_dirty_mask))
+		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
 }
 
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
@@ -708,7 +726,7 @@ static void set_spte_track_bits(u64 *sptep, u64 new_spte)
 	pfn = spte_to_pfn(old_spte);
 	if (!shadow_accessed_mask || old_spte & shadow_accessed_mask)
 		kvm_set_pfn_accessed(pfn);
-	if (is_writable_pte(old_spte))
+	if (!shadow_dirty_mask || (old_spte & shadow_dirty_mask))
 		kvm_set_pfn_dirty(pfn);
 }
 
@@ -763,13 +781,6 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 		}
 		spte = rmap_next(kvm, rmapp, spte);
 	}
-	if (write_protected) {
-		pfn_t pfn;
-
-		spte = rmap_next(kvm, rmapp, NULL);
-		pfn = spte_to_pfn(*spte);
-		kvm_set_pfn_dirty(pfn);
-	}
 
 	/* check for huge page mappings */
 	for (i = PT_DIRECTORY_LEVEL;
@@ -1942,7 +1953,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	 * whether the guest actually used the pte (in order to detect
 	 * demand paging).
 	 */
-	spte = shadow_base_present_pte | shadow_dirty_mask;
+	spte = shadow_base_present_pte;
 	if (!speculative)
 		spte |= shadow_accessed_mask;
 	if (!dirty)
@@ -2003,8 +2014,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		mark_page_dirty(vcpu->kvm, gfn);
 
 set_pte:
-	if (is_writable_pte(*sptep) && !is_writable_pte(spte))
-		kvm_set_pfn_dirty(pfn);
 	update_spte(sptep, spte);
 done:
 	return ret;
-- 
1.6.1.2


