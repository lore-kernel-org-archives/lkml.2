Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858Ab1F3IXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:23:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58491 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab1F3IXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:23:47 -0400
Message-ID: <4E0C32FE.2020805@cn.fujitsu.com>
Date: Thu, 30 Jun 2011 16:25:34 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 14/19] KVM: MMU: clean up spte updating and clearing
References: <4E0C3178.2080603@cn.fujitsu.com>
In-Reply-To: <4E0C3178.2080603@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:23:06,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-30 16:23:06,
	Serialize complete at 2011-06-30 16:23:06
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the code between mmu_spte_clear_* and mmu_spte_update

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   75 +++++++++++++++++++++++++++-------------------------
 1 files changed, 39 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 48c0a45..857d0d6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -279,24 +279,51 @@ static u64 __xchg_spte(u64 *sptep, u64 new_spte)
 #endif
 }
 
-static bool spte_has_volatile_bits(u64 spte)
+static bool spte_is_bit_cleared(u64 old_spte, u64 new_spte, u64 bit_mask)
+{
+	return (old_spte & bit_mask) && !(new_spte & bit_mask);
+}
+
+static bool spte_has_volatile_bits(u64 spte, u64 keep_bits)
 {
+	bool access_nonvolatile = false, dirty_nonvolatile = false;
+
 	if (!shadow_accessed_mask)
 		return false;
 
-	if (!is_shadow_present_pte(spte))
-		return false;
+	if ((spte | keep_bits) & shadow_accessed_mask)
+		access_nonvolatile = true;
+
+	if (!is_writable_pte(spte) || ((spte | keep_bits) & shadow_dirty_mask))
+		dirty_nonvolatile = true;
 
-	if ((spte & shadow_accessed_mask) &&
-	      (!is_writable_pte(spte) || (spte & shadow_dirty_mask)))
+	if (access_nonvolatile && dirty_nonvolatile)
 		return false;
 
 	return true;
 }
 
-static bool spte_is_bit_cleared(u64 old_spte, u64 new_spte, u64 bit_mask)
+static void track_spte_bits(u64 old_spte, u64 keep_bits, bool always_track)
 {
-	return (old_spte & bit_mask) && !(new_spte & bit_mask);
+	if (always_track ||
+	      (spte_is_bit_cleared(old_spte, keep_bits, shadow_accessed_mask)))
+		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+
+	if (always_track ||
+	      (spte_is_bit_cleared(old_spte, keep_bits, shadow_dirty_mask)))
+		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+}
+
+static u64 spte_get_and_update_clear(u64 *sptep, u64 new_spte)
+{
+	u64 old_spte = *sptep;
+
+	if (!spte_has_volatile_bits(old_spte, new_spte))
+		__set_spte(sptep, new_spte);
+	else
+		old_spte = __xchg_spte(sptep, new_spte);
+
+	return old_spte;
 }
 
 /* Rules for using mmu_spte_set:
@@ -316,7 +343,7 @@ static void mmu_spte_set(u64 *sptep, u64 new_spte)
  */
 static void mmu_spte_update(u64 *sptep, u64 new_spte)
 {
-	u64 mask, old_spte = *sptep;
+	u64 old_spte = *sptep;
 
 	WARN_ON(!is_rmap_spte(new_spte));
 
@@ -324,23 +351,8 @@ static void mmu_spte_update(u64 *sptep, u64 new_spte)
 		return mmu_spte_set(sptep, new_spte);
 
 	new_spte |= old_spte & shadow_dirty_mask;
-
-	mask = shadow_accessed_mask;
-	if (is_writable_pte(old_spte))
-		mask |= shadow_dirty_mask;
-
-	if (!spte_has_volatile_bits(old_spte) || (new_spte & mask) == mask)
-		__set_spte(sptep, new_spte);
-	else
-		old_spte = __xchg_spte(sptep, new_spte);
-
-	if (!shadow_accessed_mask)
-		return;
-
-	if (spte_is_bit_cleared(old_spte, new_spte, shadow_accessed_mask))
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
-	if (spte_is_bit_cleared(old_spte, new_spte, shadow_dirty_mask))
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+	old_spte = spte_get_and_update_clear(sptep, new_spte);
+	track_spte_bits(old_spte, new_spte, false);
 }
 
 /*
@@ -350,22 +362,13 @@ static void mmu_spte_update(u64 *sptep, u64 new_spte)
  */
 static int mmu_spte_clear_track_bits(u64 *sptep)
 {
-	pfn_t pfn;
 	u64 old_spte = *sptep;
 
-	if (!spte_has_volatile_bits(old_spte))
-		__set_spte(sptep, 0ull);
-	else
-		old_spte = __xchg_spte(sptep, 0ull);
-
 	if (!is_rmap_spte(old_spte))
 		return 0;
 
-	pfn = spte_to_pfn(old_spte);
-	if (!shadow_accessed_mask || old_spte & shadow_accessed_mask)
-		kvm_set_pfn_accessed(pfn);
-	if (!shadow_dirty_mask || (old_spte & shadow_dirty_mask))
-		kvm_set_pfn_dirty(pfn);
+	old_spte = spte_get_and_update_clear(sptep, 0ull);
+	track_spte_bits(old_spte, 0ull, !shadow_accessed_mask);
 	return 1;
 }
 
-- 
1.7.5.4

