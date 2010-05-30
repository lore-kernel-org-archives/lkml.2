Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0E3Mof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 08:44:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59454 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab0E3Mod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 08:44:33 -0400
Message-ID: <4C025CD7.4030905@cn.fujitsu.com>
Date: Sun, 30 May 2010 20:40:55 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 4/5] KVM: MMU: traverse sp hlish safely
References: <4C025BDC.1020304@cn.fujitsu.com>
In-Reply-To: <4C025BDC.1020304@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we can safely to traverse sp hlish

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   53 +++++++++++++++++++++++----------------------------
 1 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e2b1020..be75cba 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1202,18 +1202,18 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 static void kvm_mmu_commit_zap_page(struct kvm *kvm);
 
-#define for_each_gfn_sp(kvm, sp, gfn, pos, n)				\
-  hlist_for_each_entry_safe(sp, pos, n,					\
+#define for_each_gfn_sp(kvm, sp, gfn, pos)				\
+  hlist_for_each_entry(sp, pos,						\
 	&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
 		if (sp->gfn == gfn)
 
-#define for_each_gfn_indirect_sp(kvm, sp, gfn, pos, n)			\
-  hlist_for_each_entry_safe(sp, pos, n,					\
+#define for_each_gfn_indirect_sp(kvm, sp, gfn, pos)			\
+  hlist_for_each_entry(sp, pos,						\
 	&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
 		if (sp->gfn == gfn && !sp->role.direct)
 
-#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn, pos, n)		\
-  hlist_for_each_entry_safe(sp, pos, n,					\
+#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn, pos)		\
+  hlist_for_each_entry(sp, pos,						\
 	&kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)\
 		if (sp->gfn == gfn && !sp->role.direct &&		\
 			!sp->role.invalid)
@@ -1263,10 +1263,10 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 {
 	struct kvm_mmu_page *s;
-	struct hlist_node *node, *n;
+	struct hlist_node *node;
 	bool flush = false;
 
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node, n) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
 		if (!s->unsync)
 			continue;
 
@@ -1382,7 +1382,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	union kvm_mmu_page_role role;
 	unsigned quadrant;
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *node;
 	bool need_sync = false;
 
 	role = vcpu->arch.mmu.base_role;
@@ -1397,7 +1397,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		role.quadrant = quadrant;
 	}
 
-	for_each_gfn_sp(vcpu->kvm, sp, gfn, node, tmp) {
+	for_each_gfn_sp(vcpu->kvm, sp, gfn, node) {
 		if (!need_sync && sp->unsync)
 			need_sync = true;
 
@@ -1644,18 +1644,17 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node, *n;
+	struct hlist_node *node;
 	int r;
 
 	pgprintk("%s: looking for gfn %lx\n", __func__, gfn);
 	r = 0;
-restart:
-	for_each_gfn_indirect_sp(kvm, sp, gfn, node, n) {
+
+	for_each_gfn_indirect_sp(kvm, sp, gfn, node) {
 		pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
 			 sp->role.word);
 		r = 1;
-		if (kvm_mmu_prepare_zap_page(kvm, sp))
-			goto restart;
+		kvm_mmu_prepare_zap_page(kvm, sp);
 	}
 	kvm_mmu_commit_zap_page(kvm);
 	return r;
@@ -1664,14 +1663,12 @@ restart:
 static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node, *nn;
+	struct hlist_node *node;
 
-restart:
-	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node, nn) {
+	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node) {
 		pgprintk("%s: zap %lx %x\n",
 			 __func__, gfn, sp->role.word);
-		if (kvm_mmu_prepare_zap_page(kvm, sp))
-			goto restart;
+		kvm_mmu_prepare_zap_page(kvm, sp);
 	}
 	kvm_mmu_commit_zap_page(kvm);
 }
@@ -1816,9 +1813,9 @@ static void __kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 {
 	struct kvm_mmu_page *s;
-	struct hlist_node *node, *n;
+	struct hlist_node *node;
 
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node, n) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
 		if (s->unsync)
 			continue;
 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
@@ -1830,10 +1827,10 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 				  bool can_unsync)
 {
 	struct kvm_mmu_page *s;
-	struct hlist_node *node, *n;
+	struct hlist_node *node;
 	bool need_unsync = false;
 
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node, n) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
 		if (s->role.level != PT_PAGE_TABLE_LEVEL)
 			return 1;
 
@@ -2687,7 +2684,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node, *n;
+	struct hlist_node *node;
 	u64 entry, gentry;
 	u64 *spte;
 	unsigned offset = offset_in_page(gpa);
@@ -2756,8 +2753,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		}
 	}
 
-restart:
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node, n) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
 		pte_size = sp->role.cr4_pae ? 8 : 4;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
 		misaligned |= bytes < 4;
@@ -2774,8 +2770,7 @@ restart:
 			 */
 			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
 				 gpa, bytes, sp->role.word);
-			if (kvm_mmu_prepare_zap_page(vcpu->kvm, sp))
-				goto restart;
+			kvm_mmu_prepare_zap_page(vcpu->kvm, sp);
 			++vcpu->kvm->stat.mmu_flooded;
 			continue;
 		}
-- 
1.6.1.2


