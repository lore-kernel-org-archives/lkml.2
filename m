Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab0EFJef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:34:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56565 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757025Ab0EFJec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:34:32 -0400
Message-ID: <4BE28C6B.8010505@cn.fujitsu.com>
Date: Thu, 06 May 2010 17:31:23 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 6/9] KVM MMU: support keeping sp live while it's out of
 protection
References: <4BE2818A.5000301@cn.fujitsu.com>
In-Reply-To: <4BE2818A.5000301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want to keep sp live while it it's out of kvm->mmu_lock protection,
we can increase sp->active_count.

Then, the invalid page is not only for active root but also unsync sp, we
should filter those out when we make a page to unsync.

And move 'hlist_del(&sp->hash_link)' into kvm_mmu_free_page() then we can
free the invalid unsync page to call kvm_mmu_free_page directly.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 58cf0f1..8ab1a49 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -894,6 +894,7 @@ static int is_empty_shadow_page(u64 *spt)
 static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	ASSERT(is_empty_shadow_page(sp->spt));
+	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	__free_page(virt_to_page(sp->spt));
 	__free_page(virt_to_page(sp->gfns));
@@ -1539,13 +1540,14 @@ static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 		unaccount_shadowed(kvm, sp->gfn);
 	if (sp->unsync)
 		kvm_unlink_unsync_page(kvm, sp);
-	if (!sp->active_count) {
-		hlist_del(&sp->hash_link);
+	if (!sp->active_count)
 		kvm_mmu_free_page(kvm, sp);
-	} else {
+	else {
 		sp->role.invalid = 1;
 		list_move(&sp->link, &kvm->arch.active_mmu_pages);
-		kvm_reload_remote_mmus(kvm);
+		/* No need reload mmu if it's unsync page zapped */
+		if (sp->role.level != PT_PAGE_TABLE_LEVEL)
+			kvm_reload_remote_mmus(kvm);
 	}
 	kvm_mmu_reset_last_pte_updated(kvm);
 	return ret;
@@ -1781,7 +1783,8 @@ static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 
 	hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
-		if (s->gfn != gfn || s->role.direct || s->unsync)
+		if (s->gfn != gfn || s->role.direct || s->unsync ||
+		      s->role.invalid)
 			continue;
 		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
 		__kvm_unsync_page(vcpu, s);
@@ -1806,7 +1809,7 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 		if (s->role.level != PT_PAGE_TABLE_LEVEL)
 			return 1;
 
-		if (!need_unsync && !s->unsync) {
+		if (!need_unsync && !s->unsync && !s->role.invalid) {
 			if (!can_unsync || !oos_shadow)
 				return 1;
 			need_unsync = true;
-- 
1.6.1.2






