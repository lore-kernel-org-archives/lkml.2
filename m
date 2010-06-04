Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab0FDN7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 09:59:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51612 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756220Ab0FDN7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 09:59:45 -0400
Message-ID: <4C0905FB.1020408@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 21:56:11 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 6/7] KVM: MMU: traverse sp hlish safely
References: <4C090511.60206@cn.fujitsu.com>
In-Reply-To: <4C090511.60206@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we can safely to traverse sp hlish

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   51 +++++++++++++++++++++++----------------------------
 1 files changed, 23 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6544d8e..845cba2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1205,13 +1205,13 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 				    struct list_head *invalid_list);
 
-#define for_each_gfn_sp(kvm, sp, gfn, pos, n)				\
-  hlist_for_each_entry_safe(sp, pos, n,					\
+#define for_each_gfn_sp(kvm, sp, gfn, pos)				\
+  hlist_for_each_entry(sp, pos,						\
    &(kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)	\
 	if ((sp)->gfn != (gfn)) {} else
 
-#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn, pos, n)		\
-  hlist_for_each_entry_safe(sp, pos, n,					\
+#define for_each_gfn_indirect_valid_sp(kvm, sp, gfn, pos)		\
+  hlist_for_each_entry(sp, pos,						\
    &(kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)], hash_link)	\
 		if ((sp)->gfn != (gfn) || (sp)->role.direct ||		\
 			(sp)->role.invalid) {} else
@@ -1265,11 +1265,11 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 {
 	struct kvm_mmu_page *s;
-	struct hlist_node *node, *n;
+	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
 	bool flush = false;
 
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node, n) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
 		if (!s->unsync)
 			continue;
 
@@ -1387,7 +1387,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	union kvm_mmu_page_role role;
 	unsigned quadrant;
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node, *tmp;
+	struct hlist_node *node;
 	bool need_sync = false;
 
 	role = vcpu->arch.mmu.base_role;
@@ -1401,7 +1401,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
-	for_each_gfn_sp(vcpu->kvm, sp, gfn, node, tmp) {
+	for_each_gfn_sp(vcpu->kvm, sp, gfn, node) {
 		if (!need_sync && sp->unsync)
 			need_sync = true;
 
@@ -1656,19 +1656,18 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
 static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node, *n;
+	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
 	int r;
 
 	pgprintk("%s: looking for gfn %lx\n", __func__, gfn);
 	r = 0;
-restart:
-	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node, n) {
+
+	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node) {
 		pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
 			 sp->role.word);
 		r = 1;
-		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
-			goto restart;
+		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 	}
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 	return r;
@@ -1677,15 +1676,13 @@ restart:
 static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node, *nn;
+	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
 
-restart:
-	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node, nn) {
+	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node) {
 		pgprintk("%s: zap %lx %x\n",
 			 __func__, gfn, sp->role.word);
-		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
-			goto restart;
+		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 	}
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 }
@@ -1830,9 +1827,9 @@ static void __kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
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
@@ -1844,10 +1841,10 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
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
 
@@ -2722,7 +2719,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *sp;
-	struct hlist_node *node, *n;
+	struct hlist_node *node;
 	LIST_HEAD(invalid_list);
 	u64 entry, gentry;
 	u64 *spte;
@@ -2792,8 +2789,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		}
 	}
 
-restart:
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node, n) {
+	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
 		pte_size = sp->role.cr4_pae ? 8 : 4;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
 		misaligned |= bytes < 4;
@@ -2810,9 +2806,8 @@ restart:
 			 */
 			pgprintk("misaligned: gpa %llx bytes %d role %x\n",
 				 gpa, bytes, sp->role.word);
-			if (kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
-						     &invalid_list))
-				goto restart;
+			kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
+						     &invalid_list);
 			++vcpu->kvm->stat.mmu_flooded;
 			continue;
 		}
-- 
1.6.1.2


