Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab1ENVgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 17:36:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56641 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab1ENVgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 17:36:46 -0400
Message-ID: <4DCEF659.4010101@cn.fujitsu.com>
Date: Sun, 15 May 2011 05:38:33 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/7] KVM: MMU: abstract the operation of rmap
References: <4DCEF5B1.3050706@cn.fujitsu.com>
In-Reply-To: <4DCEF5B1.3050706@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 05:36:56,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 05:36:56,
	Serialize complete at 2011-05-15 05:36:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abstract the operation of rmap, then we can use it for the reverse mapping
of parent pte in the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |  142 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 79 insertions(+), 63 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 971e2d2..8da77b3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -590,28 +590,9 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 }
 
 /*
- * Take gfn and return the reverse mapping to it.
- */
-
-static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int level)
-{
-	struct kvm_memory_slot *slot;
-	struct kvm_lpage_info *linfo;
-
-	slot = gfn_to_memslot(kvm, gfn);
-	if (likely(level == PT_PAGE_TABLE_LEVEL))
-		return &slot->rmap[gfn - slot->base_gfn];
-
-	linfo = lpage_info_slot(gfn, slot, level);
-
-	return &linfo->rmap_pde;
-}
-
-/*
  * Reverse mapping data structures:
  *
- * If rmapp bit zero is zero, then rmapp point to the shadw page table entry
- * that points to page_address(page).
+ * If rmapp bit zero is zero, then rmapp point to the spte.
  *
  * If rmapp bit zero is one, (then rmap & ~1) points to a struct kvm_rmap_desc
  * containing more mappings.
@@ -620,18 +601,11 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int level)
  * the spte was not added.
  *
  */
-static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
+static int __rmap_add(struct kvm_vcpu *vcpu, u64 *spte, unsigned long *rmapp)
 {
-	struct kvm_mmu_page *sp;
 	struct kvm_rmap_desc *desc;
-	unsigned long *rmapp;
 	int i, count = 0;
 
-	if (!is_rmap_spte(*spte))
-		return count;
-	sp = page_header(__pa(spte));
-	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
-	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
 	if (!*rmapp) {
 		rmap_printk("rmap_add: %p %llx 0->1\n", spte, *spte);
 		*rmapp = (unsigned long)spte;
@@ -660,7 +634,33 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 	return count;
 }
 
-static void rmap_desc_remove_entry(unsigned long *rmapp,
+static u64 *__rmap_next(unsigned long *rmapp, u64 *spte)
+{
+	struct kvm_rmap_desc *desc;
+	u64 *prev_spte;
+	int i;
+
+	if (!*rmapp)
+		return NULL;
+	else if (!(*rmapp & 1)) {
+		if (!spte)
+			return (u64 *)*rmapp;
+		return NULL;
+	}
+	desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
+	prev_spte = NULL;
+	while (desc) {
+		for (i = 0; i < RMAP_EXT && desc->sptes[i]; ++i) {
+			if (prev_spte == spte)
+				return desc->sptes[i];
+			prev_spte = desc->sptes[i];
+		}
+		desc = desc->more;
+	}
+	return NULL;
+}
+
+static void __rmap_desc_remove_entry(unsigned long *rmapp,
 				   struct kvm_rmap_desc *desc,
 				   int i,
 				   struct kvm_rmap_desc *prev_desc)
@@ -683,18 +683,12 @@ static void rmap_desc_remove_entry(unsigned long *rmapp,
 	mmu_free_rmap_desc(desc);
 }
 
-static void rmap_remove(struct kvm *kvm, u64 *spte)
+static void __rmap_remove(u64 *spte, unsigned long *rmapp)
 {
 	struct kvm_rmap_desc *desc;
 	struct kvm_rmap_desc *prev_desc;
-	struct kvm_mmu_page *sp;
-	gfn_t gfn;
-	unsigned long *rmapp;
 	int i;
 
-	sp = page_header(__pa(spte));
-	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
-	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p 0->BUG\n", spte);
 		BUG();
@@ -712,7 +706,7 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		while (desc) {
 			for (i = 0; i < RMAP_EXT && desc->sptes[i]; ++i)
 				if (desc->sptes[i] == spte) {
-					rmap_desc_remove_entry(rmapp,
+					__rmap_desc_remove_entry(rmapp,
 							       desc, i,
 							       prev_desc);
 					return;
@@ -725,6 +719,54 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	}
 }
 
+/*
+ * Take gfn and return the reverse mapping to it.
+ */
+static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int level)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_lpage_info *linfo;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (likely(level == PT_PAGE_TABLE_LEVEL))
+		return &slot->rmap[gfn - slot->base_gfn];
+
+	linfo = lpage_info_slot(gfn, slot, level);
+
+	return &linfo->rmap_pde;
+}
+
+static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
+{
+	struct kvm_mmu_page *sp;
+	unsigned long *rmapp;
+
+	if (!is_rmap_spte(*spte))
+		return 0;
+
+	sp = page_header(__pa(spte));
+	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
+	return __rmap_add(vcpu, spte, rmapp);
+}
+
+static u64 *rmap_next(struct kvm *kvm, unsigned long *rmapp, u64 *spte)
+{
+	return __rmap_next(rmapp, spte);
+}
+
+static void rmap_remove(struct kvm *kvm, u64 *spte)
+{
+	struct kvm_mmu_page *sp;
+	gfn_t gfn;
+	unsigned long *rmapp;
+
+	sp = page_header(__pa(spte));
+	gfn = kvm_mmu_page_get_gfn(sp, spte - sp->spt);
+	rmapp = gfn_to_rmap(kvm, gfn, sp->role.level);
+	__rmap_remove(spte, rmapp);
+}
+
 static int set_spte_track_bits(u64 *sptep, u64 new_spte)
 {
 	pfn_t pfn;
@@ -752,32 +794,6 @@ static void drop_spte(struct kvm *kvm, u64 *sptep, u64 new_spte)
 		rmap_remove(kvm, sptep);
 }
 
-static u64 *rmap_next(struct kvm *kvm, unsigned long *rmapp, u64 *spte)
-{
-	struct kvm_rmap_desc *desc;
-	u64 *prev_spte;
-	int i;
-
-	if (!*rmapp)
-		return NULL;
-	else if (!(*rmapp & 1)) {
-		if (!spte)
-			return (u64 *)*rmapp;
-		return NULL;
-	}
-	desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
-	prev_spte = NULL;
-	while (desc) {
-		for (i = 0; i < RMAP_EXT && desc->sptes[i]; ++i) {
-			if (prev_spte == spte)
-				return desc->sptes[i];
-			prev_spte = desc->sptes[i];
-		}
-		desc = desc->more;
-	}
-	return NULL;
-}
-
 static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 {
 	unsigned long *rmapp;
-- 
1.7.4.4

