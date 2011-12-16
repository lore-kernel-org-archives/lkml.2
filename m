Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab1LPKQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:16:34 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59858 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1LPKQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:16:26 -0500
Message-ID: <4EEB1A71.4040503@linux.vnet.ibm.com>
Date: Fri, 16 Dec 2011 18:16:17 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/8] KVM: MMU: drop unsync_child_bitmap
References: <4EEB19AF.5070501@linux.vnet.ibm.com>
In-Reply-To: <4EEB19AF.5070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121610-3864-0000-0000-00000088A72C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsync_child_bitmap is used to record which spte has unsync page or unsync
children, we can set a free bit in the spte instead of it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/mmu.txt |    4 --
 arch/x86/include/asm/kvm_host.h   |    1 -
 arch/x86/kvm/mmu.c                |   77 +++++++++++++++++++++++++------------
 3 files changed, 52 insertions(+), 30 deletions(-)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index 4a5fedd..6d70a6e 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -214,10 +214,6 @@ Shadow pages contain the following information:
   unsync_children:
     It is used when role.level > 1 and indicates how many sptes in the page
     point at unsync pages or unsynchronized children.
-  unsync_child_bitmap:
-    A bitmap indicating which sptes in spt point (directly or indirectly) at
-    pages that may be unsynchronized.  Used to quickly locate all unsychronized
-    pages reachable from a given page.

 Reverse map
 ===========
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c0a89cd..601c7f6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -247,7 +247,6 @@ struct kvm_mmu_page {
 	};

 	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
-	DECLARE_BITMAP(unsync_child_bitmap, 512);

 #ifdef CONFIG_X86_32
 	int clear_spte_count;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 89202f4..9bd2084 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -147,7 +147,8 @@ module_param(dbg, bool, 0644);
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"

-#define SPTE_HOST_WRITEABLE (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_UNSYNC_CHILD	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))

 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 #define SHADOW_PAGE_TABLE						\
@@ -561,6 +562,40 @@ static void mmu_spte_clear_no_track(u64 *sptep)
 	__update_clear_spte_fast(sptep, 0ull);
 }

+static bool mmu_spte_mark_unsync_child(struct kvm_mmu_page *sp, u64 *sptep)
+{
+	u64 new_spte = *sptep;
+	bool unsync_child = new_spte & SPTE_UNSYNC_CHILD;
+
+	if (unsync_child)
+		return true;
+
+	new_spte |= SPTE_UNSYNC_CHILD;
+	__set_spte(sptep, new_spte);
+	return sp->unsync_children++;
+}
+
+static bool mmu_spte_is_unsync_child(u64 *sptep)
+{
+	return *sptep & SPTE_UNSYNC_CHILD;
+}
+
+static void __mmu_spte_clear_unsync_child(u64 *sptep)
+{
+	page_header(__pa(sptep))->unsync_children--;
+	WARN_ON((int)page_header(__pa(sptep))->unsync_children < 0);
+}
+
+static void mmu_spte_clear_unsync_child(u64 *sptep)
+{
+	u64 new_spte = *sptep;
+
+	if (new_spte & SPTE_UNSYNC_CHILD) {
+		__set_spte(sptep, new_spte & ~SPTE_UNSYNC_CHILD);
+		__mmu_spte_clear_unsync_child(sptep);
+	}
+}
+
 static u64 mmu_spte_get_lockless(u64 *sptep)
 {
 	return __get_spte_lockless(sptep);
@@ -1342,6 +1377,10 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 			    u64 *parent_pte)
 {
 	mmu_page_remove_parent_pte(sp, parent_pte);
+
+	if (*parent_pte & SPTE_UNSYNC_CHILD)
+		__mmu_spte_clear_unsync_child(parent_pte);
+
 	mmu_spte_clear_no_track(parent_pte);
 }

@@ -1372,16 +1411,10 @@ static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)

 static void mark_unsync(u64 *spte)
 {
-	struct kvm_mmu_page *sp;
-	unsigned int index;
+	struct kvm_mmu_page *sp = page_header(__pa(spte));

-	sp = page_header(__pa(spte));
-	index = spte - sp->spt;
-	if (__test_and_set_bit(index, sp->unsync_child_bitmap))
-		return;
-	if (sp->unsync_children++)
-		return;
-	kvm_mmu_mark_parents_unsync(sp);
+	if (!mmu_spte_mark_unsync_child(sp, spte))
+		kvm_mmu_mark_parents_unsync(sp);
 }

 static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
@@ -1411,10 +1444,9 @@ struct kvm_mmu_pages {
 	unsigned int nr;
 };

-#define for_each_unsync_children(bitmap, idx)		\
-	for (idx = find_first_bit(bitmap, 512);		\
-	     idx < 512;					\
-	     idx = find_next_bit(bitmap, 512, idx+1))
+#define for_each_unsync_children(sp, sptep, idx)			\
+	for (idx = 0; idx < 512 && ((sptep) = (sp)->spt + idx); idx++)	\
+		if (!mmu_spte_is_unsync_child(sptep)) {} else

 static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
 			 int idx)
@@ -1435,14 +1467,14 @@ static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
 static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 			   struct kvm_mmu_pages *pvec)
 {
+	u64 *spte;
 	int i, ret, nr_unsync_leaf = 0;

-	for_each_unsync_children(sp->unsync_child_bitmap, i) {
+	for_each_unsync_children(sp, spte, i) {
 		struct kvm_mmu_page *child;
-		u64 ent = sp->spt[i];
+		u64 ent = *spte;

-		if (!is_shadow_present_pte(ent) || is_large_pte(ent))
-			goto clear_child_bitmap;
+		WARN_ON(!is_shadow_present_pte(ent) || is_large_pte(ent));

 		child = page_header(ent & PT64_BASE_ADDR_MASK);

@@ -1467,12 +1499,9 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 		continue;

 clear_child_bitmap:
-		__clear_bit(i, sp->unsync_child_bitmap);
-		sp->unsync_children--;
-		WARN_ON((int)sp->unsync_children < 0);
+		mmu_spte_clear_unsync_child(spte);
 	}

-
 	return nr_unsync_leaf;
 }

@@ -1628,9 +1657,7 @@ static void mmu_pages_clear_parents(struct mmu_page_path *parents)
 		if (!sp)
 			return;

-		--sp->unsync_children;
-		WARN_ON((int)sp->unsync_children < 0);
-		__clear_bit(idx, sp->unsync_child_bitmap);
+		mmu_spte_clear_unsync_child(sp->spt + idx);
 		level++;
 	} while (level < PT64_ROOT_LEVEL-1 && !sp->unsync_children);
 }
-- 
1.7.7.4

