Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab0E3Mk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 08:40:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52541 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab0E3MkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 08:40:25 -0400
Message-ID: <4C025BDC.1020304@cn.fujitsu.com>
Date: Sun, 30 May 2010 20:36:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 1/5] KVM: MMU: introduce some macros to cleanup hlist traverseing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce for_each_gfn_sp(), for_each_gfn_indirect_sp() and
for_each_gfn_indirect_valid_sp() to cleanup hlist traverseing

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |  129 ++++++++++++++++++++++------------------------------
 1 files changed, 54 insertions(+), 75 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 56f8c3c..84c705e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1200,6 +1200,22 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+#define for_each_gfn_sp(kvm, sp, gfn, pos, n)				\
+  hlist_for_each_entry_safe(sp, pos, n,					\
+	&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
+		if (sp->gfn == gfn)
+
+#define for_each_gfn_indirect_sp(kvm, sp, gfn, pos, n)			\
+  hlist_for_each_entry_safe(sp, pos, n,					\
+	&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
+		if (sp->gfn == gfn && !sp->role.direct)
+
+#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn, pos, n)		\
+  hlist_for_each_entry_safe(sp, pos, n,					\
+	&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
+		if (sp->gfn == gfn && !sp->role.direct &&		\
+			!sp->role.invalid)
+
 static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			   bool clear_unsync)
 {
@@ -1243,16 +1259,12 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 /* @gfn should be write-protected at the call site */
 static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 {
-	struct hlist_head *bucket;
 	struct kvm_mmu_page *s;
 	struct hlist_node *node, *n;
-	unsigned index;
 	bool flush = false;
 
-	index = kvm_page_table_hashfn(gfn);
-	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
-	hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
-		if (s->gfn != gfn || !s->unsync || s->role.invalid)
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node, n) {
+		if (!s->unsync)
 			continue;
 
 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
@@ -1364,9 +1376,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     u64 *parent_pte)
 {
 	union kvm_mmu_page_role role;
-	unsigned index;
 	unsigned quadrant;
-	struct hlist_head *bucket;
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node, *tmp;
 	bool need_sync = false;
@@ -1382,36 +1392,36 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
-	index = kvm_page_table_hashfn(gfn);
-	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
-	hlist_for_each_entry_safe(sp, node, tmp, bucket, hash_link)
-		if (sp->gfn == gfn) {
-			if (!need_sync && sp->unsync)
-				need_sync = true;
 
-			if (sp->role.word != role.word)
-				continue;
+	for_each_gfn_sp(vcpu->kvm, sp, gfn, node, tmp) {
+		if (!need_sync && sp->unsync)
+			need_sync = true;
 
-			if (sp->unsync && kvm_sync_page_transient(vcpu, sp))
-				break;
+		if (sp->role.word != role.word)
+			continue;
 
-			mmu_page_add_parent_pte(vcpu, sp, parent_pte);
-			if (sp->unsync_children) {
-				set_bit(KVM_REQ_MMU_SYNC, &vcpu->requests);
-				kvm_mmu_mark_parents_unsync(sp);
-			} else if (sp->unsync)
-				kvm_mmu_mark_parents_unsync(sp);
+		if (sp->unsync && kvm_sync_page_transient(vcpu, sp))
+			break;
 
-			trace_kvm_mmu_get_page(sp, false);
-			return sp;
-		}
+		mmu_page_add_parent_pte(vcpu, sp, parent_pte);
+		if (sp->unsync_children) {
+			set_bit(KVM_REQ_MMU_SYNC, &vcpu->requests);
+			kvm_mmu_mark_parents_unsync(sp);
+		} else if (sp->unsync)
+			kvm_mmu_mark_parents_unsync(sp);
+
+		trace_kvm_mmu_get_page(sp, false);
+		return sp;
+	}
 	++vcpu->kvm->stat.mmu_cache_miss;
 	sp = kvm_mmu_alloc_page(vcpu, parent_pte, direct);
 	if (!sp)
 		return sp;
 	sp->gfn = gfn;
 	sp->role = role;
-	hlist_add_head(&sp->hash_link, bucket);
+	hlist_add_head(&sp->hash_link,
+		&vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)]);
+
 	if (!direct) {
 		if (rmap_write_protect(vcpu->kvm, gfn))
 			kvm_flush_remote_tlbs(vcpu->kvm);
@@ -1616,46 +1626,34 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 
 static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 {
-	unsigned index;
-	struct hlist_head *bucket;
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node, *n;
 	int r;
 
 	pgprintk("%s: looking for gfn %lx\n", __func__, gfn);
 	r = 0;
-	index = kvm_page_table_hashfn(gfn);
-	bucket = &kvm->arch.mmu_page_hash[index];
 restart:
-	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link)
-		if (sp->gfn == gfn && !sp->role.direct) {
-			pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
-				 sp->role.word);
-			r = 1;
-			if (kvm_mmu_zap_page(kvm, sp))
-				goto restart;
-		}
+	for_each_gfn_indirect_sp(kvm, sp, gfn, node, n) {
+		pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
+			 sp->role.word);
+		r = 1;
+		if (kvm_mmu_zap_page(kvm, sp))
+			goto restart;
+	}
 	return r;
 }
 
 static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 {
-	unsigned index;
-	struct hlist_head *bucket;
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node, *nn;
 
-	index = kvm_page_table_hashfn(gfn);
-	bucket = &kvm->arch.mmu_page_hash[index];
 restart:
-	hlist_for_each_entry_safe(sp, node, nn, bucket, hash_link) {
-		if (sp->gfn == gfn && !sp->role.direct
-		    && !sp->role.invalid) {
-			pgprintk("%s: zap %lx %x\n",
-				 __func__, gfn, sp->role.word);
-			if (kvm_mmu_zap_page(kvm, sp))
-				goto restart;
-		}
+	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node, nn) {
+		pgprintk("%s: zap %lx %x\n",
+			 __func__, gfn, sp->role.word);
+		if (kvm_mmu_zap_page(kvm, sp))
+			goto restart;
 	}
 }
 
@@ -1798,17 +1796,11 @@ static void __kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 {
-	struct hlist_head *bucket;
 	struct kvm_mmu_page *s;
 	struct hlist_node *node, *n;
-	unsigned index;
-
-	index = kvm_page_table_hashfn(gfn);
-	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 
-	hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
-		if (s->gfn != gfn || s->role.direct || s->unsync ||
-		      s->role.invalid)
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node, n) {
+		if (s->unsync)
 			continue;
 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
 		__kvm_unsync_page(vcpu, s);
@@ -1818,18 +1810,11 @@ static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 				  bool can_unsync)
 {
-	unsigned index;
-	struct hlist_head *bucket;
 	struct kvm_mmu_page *s;
 	struct hlist_node *node, *n;
 	bool need_unsync = false;
 
-	index = kvm_page_table_hashfn(gfn);
-	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
-	hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
-		if (s->gfn != gfn || s->role.direct || s->role.invalid)
-			continue;
-
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node, n) {
 		if (s->role.level != PT_PAGE_TABLE_LEVEL)
 			return 1;
 
@@ -2681,8 +2666,6 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node, *n;
-	struct hlist_head *bucket;
-	unsigned index;
 	u64 entry, gentry;
 	u64 *spte;
 	unsigned offset = offset_in_page(gpa);
@@ -2750,13 +2733,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			vcpu->arch.last_pte_updated = NULL;
 		}
 	}
-	index = kvm_page_table_hashfn(gfn);
-	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 
 restart:
-	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link) {
-		if (sp->gfn != gfn || sp->role.direct || sp->role.invalid)
-			continue;
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node, n) {
 		pte_size = sp->role.cr4_pae ? 8 : 4;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
 		misaligned |= bytes < 4;
-- 
1.6.1.2

