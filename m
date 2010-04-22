Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0DVGQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 02:16:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54797 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab0DVGQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 02:16:12 -0400
Message-ID: <4BCFE8F0.7010509@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 14:13:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/10] KVM MMU: don't write-protect if have new mapping to
 unsync page
References: <4BCFE581.8050305@cn.fujitsu.com>
In-Reply-To: <4BCFE581.8050305@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If have new mapping to the unsync page(i.e, add a new parent), just
update the page from sp->gfn but not write-protect gfn, and if need
create new shadow page form sp->gfn, we should sync it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index fd027a6..8607a64 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1196,16 +1196,20 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
-static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			 bool clear_unsync)
 {
 	if (sp->role.cr4_pae != !!is_pae(vcpu)) {
 		kvm_mmu_zap_page(vcpu->kvm, sp);
 		return 1;
 	}
 
-	if (rmap_write_protect(vcpu->kvm, sp->gfn))
-		kvm_flush_remote_tlbs(vcpu->kvm);
-	kvm_unlink_unsync_page(vcpu->kvm, sp);
+	if (clear_unsync) {
+		if (rmap_write_protect(vcpu->kvm, sp->gfn))
+			kvm_flush_remote_tlbs(vcpu->kvm);
+		kvm_unlink_unsync_page(vcpu->kvm, sp);
+	}
+
 	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
 		kvm_mmu_zap_page(vcpu->kvm, sp);
 		return 1;
@@ -1293,7 +1297,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 			kvm_flush_remote_tlbs(vcpu->kvm);
 
 		for_each_sp(pages, sp, parents, i) {
-			kvm_sync_page(vcpu, sp);
+			kvm_sync_page(vcpu, sp, true);
 			mmu_pages_clear_parents(&parents);
 		}
 		cond_resched_lock(&vcpu->kvm->mmu_lock);
@@ -1313,7 +1317,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	unsigned index;
 	unsigned quadrant;
 	struct hlist_head *bucket;
-	struct kvm_mmu_page *sp;
+	struct kvm_mmu_page *sp, *unsync_sp = NULL;
 	struct hlist_node *node, *tmp;
 
 	role = vcpu->arch.mmu.base_role;
@@ -1332,12 +1336,16 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	hlist_for_each_entry_safe(sp, node, tmp, bucket, hash_link)
 		if (sp->gfn == gfn) {
 			if (sp->unsync)
-				if (kvm_sync_page(vcpu, sp))
-					continue;
+				unsync_sp = sp;
 
 			if (sp->role.word != role.word)
 				continue;
 
+			if (unsync_sp && kvm_sync_page(vcpu, unsync_sp, false)) {
+				unsync_sp = NULL;
+				continue;
+			}
+
 			mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 			if (sp->unsync_children) {
 				set_bit(KVM_REQ_MMU_SYNC, &vcpu->requests);
@@ -1346,6 +1354,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			trace_kvm_mmu_get_page(sp, false);
 			return sp;
 		}
+	if (unsync_sp)
+		kvm_sync_page(vcpu, unsync_sp, true);
+
 	++vcpu->kvm->stat.mmu_cache_miss;
 	sp = kvm_mmu_alloc_page(vcpu, parent_pte);
 	if (!sp)
-- 
1.6.1.2


