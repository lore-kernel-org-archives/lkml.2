Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1LPKOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:14:06 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33608 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1LPKN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:13:59 -0500
Message-ID: <4EEB19D6.60101@linux.vnet.ibm.com>
Date: Fri, 16 Dec 2011 18:13:42 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/8] KVM: MMU: combine unsync and unsync_children
References: <4EEB19AF.5070501@linux.vnet.ibm.com>
In-Reply-To: <4EEB19AF.5070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121610-8878-0000-0000-00000098BF23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsync is only used for the page of level == 1 and unsync_children is only
used in the upper page, so combine them to reduce the size of shadow page
structure

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/mmu.txt |    5 ++-
 arch/x86/include/asm/kvm_host.h   |   14 +++++++++++-
 arch/x86/kvm/mmu.c                |   39 +++++++++++++++++++++++++-----------
 arch/x86/kvm/mmu_audit.c          |    6 ++--
 arch/x86/kvm/mmutrace.h           |    3 +-
 arch/x86/kvm/paging_tmpl.h        |    2 +-
 6 files changed, 48 insertions(+), 21 deletions(-)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index 5dc972c..4a5fedd 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -205,14 +205,15 @@ Shadow pages contain the following information:
     this page's spt.  Otherwise, parent_ptes points at a data structure
     with a list of parent_ptes.
   unsync:
+    It is used when role.level == 1, only level 1 shadow pages can be unsync.
     If true, then the translations in this page may not match the guest's
     translation.  This is equivalent to the state of the tlb when a pte is
     changed but before the tlb entry is flushed.  Accordingly, unsync ptes
     are synchronized when the guest executes invlpg or flushes its tlb by
     other means.  Valid for leaf pages.
   unsync_children:
-    How many sptes in the page point at pages that are unsync (or have
-    unsynchronized children).
+    It is used when role.level > 1 and indicates how many sptes in the page
+    point at unsync pages or unsynchronized children.
   unsync_child_bitmap:
     A bitmap indicating which sptes in spt point (directly or indirectly) at
     pages that may be unsynchronized.  Used to quickly locate all unsychronized
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 52d6640..c0a89cd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -233,9 +233,19 @@ struct kvm_mmu_page {
 	 * in this shadow page.
 	 */
 	DECLARE_BITMAP(slot_bitmap, KVM_MEM_SLOTS_NUM);
-	bool unsync;
 	int root_count;          /* Currently serving as active root */
-	unsigned int unsync_children;
+
+	/*
+	 * If role.level == 1, unsync indicates whether the sp is
+	 * unsync, otherwise unsync_children indicates the number
+	 * of sptes which point at unsync sp or unsychronized children.
+	 * See sp_is_unsync() / sp_unsync_children_num.
+	 */
+	union {
+		bool unsync;
+		unsigned int unsync_children;
+	};
+
 	unsigned long parent_ptes;	/* Reverse mapping for parent_pte */
 	DECLARE_BITMAP(unsync_child_bitmap, 512);

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2a2a9b4..6913a16 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -151,6 +151,21 @@ module_param(dbg, bool, 0644);

 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)

+static bool sp_is_unsync(struct kvm_mmu_page *sp)
+{
+	return sp->role.level == PT_PAGE_TABLE_LEVEL && sp->unsync;
+}
+
+static unsigned int sp_unsync_children_num(struct kvm_mmu_page *sp)
+{
+	unsigned int num = 0;
+
+	if (sp->role.level != PT_PAGE_TABLE_LEVEL)
+		num = sp->unsync_children;
+
+	return num;
+}
+
 struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
 	struct pte_list_desc *more;
@@ -1401,7 +1416,7 @@ static int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
 {
 	int i;

-	if (sp->unsync)
+	if (sp_is_unsync(sp))
 		for (i=0; i < pvec->nr; i++)
 			if (pvec->page[i].sp == sp)
 				return 0;
@@ -1426,7 +1441,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,

 		child = page_header(ent & PT64_BASE_ADDR_MASK);

-		if (child->unsync_children) {
+		if (sp_unsync_children_num(child)) {
 			if (mmu_pages_add(pvec, child, i))
 				return -ENOSPC;

@@ -1437,7 +1452,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 				nr_unsync_leaf += ret;
 			else
 				return ret;
-		} else if (child->unsync) {
+		} else if (sp_is_unsync(child)) {
 			nr_unsync_leaf++;
 			if (mmu_pages_add(pvec, child, i))
 				return -ENOSPC;
@@ -1468,7 +1483,7 @@ static int mmu_unsync_walk(struct kvm_mmu_page *sp,

 static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	WARN_ON(!sp->unsync);
+	WARN_ON(!sp_is_unsync(sp));
 	trace_kvm_mmu_sync_page(sp);
 	sp->unsync = 0;
 	--kvm->stat.mmu_unsync;
@@ -1546,7 +1561,7 @@ static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 	bool flush = false;

 	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
-		if (!s->unsync)
+		if (!sp_is_unsync(s))
 			continue;

 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
@@ -1699,20 +1714,20 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		role.quadrant = quadrant;
 	}
 	for_each_gfn_sp(vcpu->kvm, sp, gfn, node) {
-		if (!need_sync && sp->unsync)
+		if (!need_sync && sp_is_unsync(sp))
 			need_sync = true;

 		if (sp->role.word != role.word)
 			continue;

-		if (sp->unsync && kvm_sync_page_transient(vcpu, sp))
+		if (sp_is_unsync(sp) && kvm_sync_page_transient(vcpu, sp))
 			break;

 		mmu_page_add_parent_pte(vcpu, sp, parent_pte);
-		if (sp->unsync_children) {
+		if (sp_unsync_children_num(sp)) {
 			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
 			kvm_mmu_mark_parents_unsync(sp);
-		} else if (sp->unsync)
+		} else if (sp_is_unsync(sp))
 			kvm_mmu_mark_parents_unsync(sp);

 		__clear_sp_write_flooding_count(sp);
@@ -1914,7 +1929,7 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	kvm_mmu_unlink_parents(kvm, sp);
 	if (!sp->role.invalid && !sp->role.direct)
 		unaccount_shadowed(kvm, sp->gfn);
-	if (sp->unsync)
+	if (sp_is_unsync(sp))
 		kvm_unlink_unsync_page(kvm, sp);
 	if (!sp->root_count) {
 		/* Count self */
@@ -2163,7 +2178,7 @@ static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 	struct hlist_node *node;

 	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
-		if (s->unsync)
+		if (sp_is_unsync(s))
 			continue;
 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
 		__kvm_unsync_page(vcpu, s);
@@ -2184,7 +2199,7 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 		if (s->role.level != PT_PAGE_TABLE_LEVEL)
 			return 1;

-		if (!need_unsync && !s->unsync) {
+		if (!need_unsync && !sp_is_unsync(s)) {
 			need_unsync = true;
 		}
 	}
diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
index fe15dcc..2106910 100644
--- a/arch/x86/kvm/mmu_audit.c
+++ b/arch/x86/kvm/mmu_audit.c
@@ -102,7 +102,7 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)

 	sp = page_header(__pa(sptep));

-	if (sp->unsync) {
+	if (sp_is_unsync(sp)) {
 		if (level != PT_PAGE_TABLE_LEVEL) {
 			audit_printk(vcpu->kvm, "unsync sp: %p "
 				     "level = %d\n", sp, level);
@@ -168,7 +168,7 @@ static void audit_spte_after_sync(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 {
 	struct kvm_mmu_page *sp = page_header(__pa(sptep));

-	if (vcpu->kvm->arch.audit_point == AUDIT_POST_SYNC && sp->unsync)
+	if (vcpu->kvm->arch.audit_point == AUDIT_POST_SYNC && sp_is_unsync(sp))
 		audit_printk(vcpu->kvm, "meet unsync sp(%p) after sync "
 			     "root.\n", sp);
 }
@@ -194,7 +194,7 @@ static void audit_write_protection(struct kvm *kvm, struct kvm_mmu_page *sp)
 	unsigned long *rmapp;
 	u64 *spte;

-	if (sp->role.direct || sp->unsync || sp->role.invalid)
+	if (sp->role.direct || sp_is_unsync(sp) || sp->role.invalid)
 		return;

 	slot = gfn_to_memslot(kvm, sp->gfn);
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 89fb0e8..7fe9562 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -38,7 +38,8 @@
 			 role.invalid ? " invalid" : "",		\
 			 role.nxe ? "" : "!",				\
 			 __entry->root_count,				\
-			 __entry->unsync ? "unsync" : "sync", 0);	\
+			 role.level == 1 && __entry->unsync ?		\
+			 "unsync" : "sync", 0);				\
 	ret;								\
 		})

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 1561028..7dacc80 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -691,7 +691,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 			pt_element_t gpte;
 			gpa_t pte_gpa;

-			if (!sp->unsync)
+			if (!sp_is_unsync(sp))
 				break;

 			pte_gpa = FNAME(get_level1_sp_gpa)(sp);
-- 
1.7.7.4

