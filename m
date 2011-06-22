Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab1FVOci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:32:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55007 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758136Ab1FVOch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:32:37 -0400
Message-ID: <4E01FD7B.1030505@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:34:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 16/22] KVM: MMU: introduce the rules to modify shadow page
 table
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:32:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:32:10,
	Serialize complete at 2011-06-22 22:32:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce some interfaces to modify spte as linux kernel does:
- mmu_spte_clear_track_bits, it set the spte from present to nonpresent, and
  track the stat bits(accessed/dirty) of spte
- mmu_spte_clear_no_track, the same as mmu_spte_clear_track_bits except
  tracking the stat bits
- mmu_spte_set, set spte from nonpresent to present
- mmu_spte_update, only update the stat bits

Now, it does not allowed to set spte from present to present, later, we can
drop the atomicly opration for X86_32 host, and it is the preparing work to
get spte on X86_32 host out of the mmu lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |  103 +++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 69 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4fe1cb3..5ceb64a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -299,12 +299,30 @@ static bool spte_is_bit_cleared(u64 old_spte, u64 new_spte, u64 bit_mask)
 	return (old_spte & bit_mask) && !(new_spte & bit_mask);
 }
 
-static void update_spte(u64 *sptep, u64 new_spte)
+/* Rules for using mmu_spte_set:
+ * Set the sptep from nonpresent to present.
+ * Note: the sptep being assigned *must* be either not present
+ * or in a state where the hardware will not attempt to update
+ * the spte.
+ */
+static void mmu_spte_set(u64 *sptep, u64 new_spte)
+{
+	WARN_ON(is_shadow_present_pte(*sptep));
+	__set_spte(sptep, new_spte);
+}
+
+/* Rules for using mmu_spte_update:
+ * Update the state bits, it means the mapped pfn is not changged.
+ */
+static void mmu_spte_update(u64 *sptep, u64 new_spte)
 {
 	u64 mask, old_spte = *sptep;
 
 	WARN_ON(!is_rmap_spte(new_spte));
 
+	if (!is_shadow_present_pte(old_spte))
+		return mmu_spte_set(sptep, new_spte);
+
 	new_spte |= old_spte & shadow_dirty_mask;
 
 	mask = shadow_accessed_mask;
@@ -325,6 +343,42 @@ static void update_spte(u64 *sptep, u64 new_spte)
 		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
 }
 
+/*
+ * Rules for using mmu_spte_clear_track_bits:
+ * It sets the sptep from present to nonpresent, and track the
+ * state bits, it is used to clear the last level sptep.
+ */
+static int mmu_spte_clear_track_bits(u64 *sptep)
+{
+	pfn_t pfn;
+	u64 old_spte = *sptep;
+
+	if (!spte_has_volatile_bits(old_spte))
+		__set_spte(sptep, 0ull);
+	else
+		old_spte = __xchg_spte(sptep, 0ull);
+
+	if (!is_rmap_spte(old_spte))
+		return 0;
+
+	pfn = spte_to_pfn(old_spte);
+	if (!shadow_accessed_mask || old_spte & shadow_accessed_mask)
+		kvm_set_pfn_accessed(pfn);
+	if (!shadow_dirty_mask || (old_spte & shadow_dirty_mask))
+		kvm_set_pfn_dirty(pfn);
+	return 1;
+}
+
+/*
+ * Rules for using mmu_spte_clear_no_track:
+ * Directly clear spte without caring the state bits of sptep,
+ * it is used to set the upper level spte.
+ */
+static void mmu_spte_clear_no_track(u64 *sptep)
+{
+	__set_spte(sptep, 0ull);
+}
+
 static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 				  struct kmem_cache *base_cache, int min)
 {
@@ -746,30 +800,9 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	pte_list_remove(spte, rmapp);
 }
 
-static int set_spte_track_bits(u64 *sptep, u64 new_spte)
-{
-	pfn_t pfn;
-	u64 old_spte = *sptep;
-
-	if (!spte_has_volatile_bits(old_spte))
-		__set_spte(sptep, new_spte);
-	else
-		old_spte = __xchg_spte(sptep, new_spte);
-
-	if (!is_rmap_spte(old_spte))
-		return 0;
-
-	pfn = spte_to_pfn(old_spte);
-	if (!shadow_accessed_mask || old_spte & shadow_accessed_mask)
-		kvm_set_pfn_accessed(pfn);
-	if (!shadow_dirty_mask || (old_spte & shadow_dirty_mask))
-		kvm_set_pfn_dirty(pfn);
-	return 1;
-}
-
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
-	if (set_spte_track_bits(sptep, 0ull))
+	if (mmu_spte_clear_track_bits(sptep))
 		rmap_remove(kvm, sptep);
 }
 
@@ -787,7 +820,7 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
 		if (is_writable_pte(*spte)) {
-			update_spte(spte, *spte & ~PT_WRITABLE_MASK);
+			mmu_spte_update(spte, *spte & ~PT_WRITABLE_MASK);
 			write_protected = 1;
 		}
 		spte = rmap_next(kvm, rmapp, spte);
@@ -856,7 +889,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			new_spte &= ~PT_WRITABLE_MASK;
 			new_spte &= ~SPTE_HOST_WRITEABLE;
 			new_spte &= ~shadow_accessed_mask;
-			set_spte_track_bits(spte, new_spte);
+			mmu_spte_clear_track_bits(spte);
+			mmu_spte_set(spte, new_spte);
 			spte = rmap_next(kvm, rmapp, spte);
 		}
 	}
@@ -1077,7 +1111,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 			    u64 *parent_pte)
 {
 	mmu_page_remove_parent_pte(sp, parent_pte);
-	__set_spte(parent_pte, 0ull);
+	mmu_spte_clear_no_track(parent_pte);
 }
 
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
@@ -1525,7 +1559,7 @@ static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
 	spte = __pa(sp->spt)
 		| PT_PRESENT_MASK | PT_ACCESSED_MASK
 		| PT_WRITABLE_MASK | PT_USER_MASK;
-	__set_spte(sptep, spte);
+	mmu_spte_set(sptep, spte);
 }
 
 static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
@@ -1992,7 +2026,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		mark_page_dirty(vcpu->kvm, gfn);
 
 set_pte:
-	update_spte(sptep, spte);
+	mmu_spte_update(sptep, spte);
 	/*
 	 * If we overwrite a writable spte with a read-only one we
 	 * should flush remote TLBs. Otherwise rmap_write_protect
@@ -2198,11 +2232,11 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 				return -ENOMEM;
 			}
 
-			__set_spte(iterator.sptep,
-				   __pa(sp->spt)
-				   | PT_PRESENT_MASK | PT_WRITABLE_MASK
-				   | shadow_user_mask | shadow_x_mask
-				   | shadow_accessed_mask);
+			mmu_spte_set(iterator.sptep,
+				     __pa(sp->spt)
+				     | PT_PRESENT_MASK | PT_WRITABLE_MASK
+				     | shadow_user_mask | shadow_x_mask
+				     | shadow_accessed_mask);
 		}
 	}
 	return emulate;
@@ -3449,7 +3483,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 
 			/* avoid RMW */
 			if (is_writable_pte(pt[i]))
-				update_spte(&pt[i], pt[i] & ~PT_WRITABLE_MASK);
+				mmu_spte_update(&pt[i],
+						pt[i] & ~PT_WRITABLE_MASK);
 		}
 	}
 	kvm_flush_remote_tlbs(kvm);
-- 
1.7.5.4

