Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0EFJd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:33:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57630 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab0EFJdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:33:55 -0400
Message-ID: <4BE28C45.1020109@cn.fujitsu.com>
Date: Thu, 06 May 2010 17:30:45 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 3/9] KVM MMU: allow more page become unsync at gfn mapping
 time
References: <4BE2818A.5000301@cn.fujitsu.com>
In-Reply-To: <4BE2818A.5000301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, shadow page can become asynchronous only if one
shadow page for a gfn, this rule is too strict, in fact, we can
let all last mapping page(i.e, it's the pte page) become unsync,
and sync them at invlpg or flush tlb time.

This patch allow more page become asynchronous at gfn mapping time 

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   81 +++++++++++++++++++++++----------------------------
 1 files changed, 37 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1dbb96e..ae8c43b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1166,26 +1166,6 @@ static int mmu_unsync_walk(struct kvm_mmu_page *sp,
 	return __mmu_unsync_walk(sp, pvec);
 }
 
-static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
-{
-	unsigned index;
-	struct hlist_head *bucket;
-	struct kvm_mmu_page *sp;
-	struct hlist_node *node;
-
-	pgprintk("%s: looking for gfn %lx\n", __func__, gfn);
-	index = kvm_page_table_hashfn(gfn);
-	bucket = &kvm->arch.mmu_page_hash[index];
-	hlist_for_each_entry(sp, node, bucket, hash_link)
-		if (sp->gfn == gfn && !sp->role.direct
-		    && !sp->role.invalid) {
-			pgprintk("%s: found role %x\n",
-				 __func__, sp->role.word);
-			return sp;
-		}
-	return NULL;
-}
-
 static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	WARN_ON(!sp->unsync);
@@ -1753,47 +1733,60 @@ u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_get_guest_memory_type);
 
-static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+static void __kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+{
+	trace_kvm_mmu_unsync_page(sp);
+	++vcpu->kvm->stat.mmu_unsync;
+	sp->unsync = 1;
+
+	kvm_mmu_mark_parents_unsync(sp);
+	mmu_convert_notrap(sp);
+}
+
+static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 {
-	unsigned index;
 	struct hlist_head *bucket;
 	struct kvm_mmu_page *s;
 	struct hlist_node *node, *n;
+	unsigned index;
 
-	index = kvm_page_table_hashfn(sp->gfn);
+	index = kvm_page_table_hashfn(gfn);
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
-	/* don't unsync if pagetable is shadowed with multiple roles */
+
 	hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
-		if (s->gfn != sp->gfn || s->role.direct)
+		if (s->gfn != gfn || s->role.direct || s->unsync)
 			continue;
-		if (s->role.word != sp->role.word)
-			return 1;
+		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
+		__kvm_unsync_page(vcpu, s);
 	}
-	trace_kvm_mmu_unsync_page(sp);
-	++vcpu->kvm->stat.mmu_unsync;
-	sp->unsync = 1;
-
-	kvm_mmu_mark_parents_unsync(sp);
-
-	mmu_convert_notrap(sp);
-	return 0;
 }
 
 static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 				  bool can_unsync)
 {
-	struct kvm_mmu_page *shadow;
+	unsigned index;
+	struct hlist_head *bucket;
+	struct kvm_mmu_page *s;
+	struct hlist_node *node, *n;
+	bool need_unsync = false;
+
+	index = kvm_page_table_hashfn(gfn);
+	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
+	hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
+		if (s->gfn != gfn || s->role.direct)
+			continue;
 
-	shadow = kvm_mmu_lookup_page(vcpu->kvm, gfn);
-	if (shadow) {
-		if (shadow->role.level != PT_PAGE_TABLE_LEVEL)
+		if (s->role.level != PT_PAGE_TABLE_LEVEL)
 			return 1;
-		if (shadow->unsync)
-			return 0;
-		if (can_unsync && oos_shadow)
-			return kvm_unsync_page(vcpu, shadow);
-		return 1;
+
+		if (!need_unsync && !s->unsync) {
+			if (!can_unsync || !oos_shadow)
+				return 1;
+			need_unsync = true;
+		}
 	}
+	if (need_unsync)
+		kvm_unsync_pages(vcpu, gfn);
 	return 0;
 }
 
-- 
1.6.1.2





