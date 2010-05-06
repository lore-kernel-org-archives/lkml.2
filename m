Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab0EFJeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:34:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49580 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756571Ab0EFJeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:34:02 -0400
Message-ID: <4BE28C4D.9020101@cn.fujitsu.com>
Date: Thu, 06 May 2010 17:30:53 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 4/9] KVM MMU: allow more page become unsync at getting
 sp time
References: <4BE2818A.5000301@cn.fujitsu.com>
In-Reply-To: <4BE2818A.5000301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow more page become asynchronous at getting sp time, if need create new
shadow page for gfn but it not allow unsync(level > 1), we should unsync all
gfn's unsync page

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   47 +++++++++++++++++++++++++++++++++++++----------
 1 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ae8c43b..26edc11 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1215,6 +1215,35 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	return __kvm_sync_page(vcpu, sp, true);
 }
 
+/* @gfn should be write-protected at the call site */
+static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
+{
+	struct hlist_head *bucket;
+	struct kvm_mmu_page *s;
+	struct hlist_node *node, *n;
+	unsigned index;
+	bool flush = false;
+
+	index = kvm_page_table_hashfn(gfn);
+	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
+	hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
+		if (s->gfn != gfn || !s->unsync)
+			continue;
+
+		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
+		if ((s->role.cr4_pae != !!is_pae(vcpu)) ||
+			(vcpu->arch.mmu.sync_page(vcpu, s))) {
+			kvm_mmu_zap_page(vcpu->kvm, s);
+			continue;
+		}
+		kvm_unlink_unsync_page(vcpu->kvm, s);
+		flush = true;
+	}
+
+	if (flush)
+		kvm_mmu_flush_tlb(vcpu);
+}
+
 struct mmu_page_path {
 	struct kvm_mmu_page *parent[PT64_ROOT_LEVEL-1];
 	unsigned int idx[PT64_ROOT_LEVEL-1];
@@ -1313,8 +1342,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	unsigned index;
 	unsigned quadrant;
 	struct hlist_head *bucket;
-	struct kvm_mmu_page *sp, *unsync_sp = NULL;
+	struct kvm_mmu_page *sp;
 	struct hlist_node *node, *tmp;
+	bool need_sync = false;
 
 	role = vcpu->arch.mmu.base_role;
 	role.level = level;
@@ -1331,17 +1361,14 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry_safe(sp, node, tmp, bucket, hash_link)
 		if (sp->gfn == gfn) {
-			if (sp->unsync)
-				unsync_sp = sp;
+			if (!need_sync && sp->unsync)
+				need_sync = true;
 
 			if (sp->role.word != role.word)
 				continue;
 
-			if (!direct && unsync_sp &&
-			      kvm_sync_page_transient(vcpu, unsync_sp)) {
-				unsync_sp = NULL;
+			if (sp->unsync && kvm_sync_page_transient(vcpu, sp))
 				break;
-			}
 
 			mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 			if (sp->unsync_children) {
@@ -1353,9 +1380,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			trace_kvm_mmu_get_page(sp, false);
 			return sp;
 		}
-	if (!direct && unsync_sp)
-		kvm_sync_page(vcpu, unsync_sp);
-
 	++vcpu->kvm->stat.mmu_cache_miss;
 	sp = kvm_mmu_alloc_page(vcpu, parent_pte);
 	if (!sp)
@@ -1366,6 +1390,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	if (!direct) {
 		if (rmap_write_protect(vcpu->kvm, gfn))
 			kvm_flush_remote_tlbs(vcpu->kvm);
+		if (level > PT_PAGE_TABLE_LEVEL && need_sync)
+			kvm_sync_pages(vcpu, gfn);
+
 		account_shadowed(vcpu->kvm, gfn);
 	}
 	if (shadow_trap_nonpresent_pte != shadow_notrap_nonpresent_pte)
-- 
1.6.1.2





