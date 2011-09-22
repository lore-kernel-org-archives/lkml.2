Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1IVIvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:51:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54810 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab1IVIvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:51:09 -0400
Message-ID: <4E7AF77D.5000409@cn.fujitsu.com>
Date: Thu, 22 Sep 2011 16:53:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 01/11] KVM: MMU: avoid pte_list_desc running out in kvm_mmu_pte_write
References: <4E7AF758.7060900@cn.fujitsu.com>
In-Reply-To: <4E7AF758.7060900@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:49:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:49:42,
	Serialize complete at 2011-09-22 16:49:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_mmu_pte_write is unsafe since we need to alloc pte_list_desc in the
function when spte is prefetched, unfortunately, we can not know how many
spte need to be prefetched on this path, that means we can use out of the
free  pte_list_desc object in the cache, and BUG_ON() is triggered, also some
path does not fill the cache, such as INS instruction emulated that does not
trigger page fault

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5d7fbf0..b01afee 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -592,6 +592,11 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 	return 0;
 }
 
+static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
+{
+	return cache->nobjs;
+}
+
 static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
 				  struct kmem_cache *cache)
 {
@@ -969,6 +974,14 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int level)
 	return &linfo->rmap_pde;
 }
 
+static bool rmap_can_add(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu_memory_cache *cache;
+
+	cache = &vcpu->arch.mmu_pte_list_desc_cache;
+	return mmu_memory_cache_free_objects(cache);
+}
+
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
@@ -3585,6 +3598,12 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		break;
 	}
 
+	/*
+	 * No need to care whether allocation memory is successful
+	 * or not since pte prefetch is skiped if it does not have
+	 * enough objects in the cache.
+	 */
+	mmu_topup_memory_caches(vcpu);
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
 		gentry = 0;
@@ -3655,7 +3674,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			mmu_page_zap_pte(vcpu->kvm, sp, spte);
 			if (gentry &&
 			      !((sp->role.word ^ vcpu->arch.mmu.base_role.word)
-			      & mask.word))
+			      & mask.word) && rmap_can_add(vcpu))
 				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
 			if (!remote_flush && need_remote_flush(entry, *spte))
 				remote_flush = true;
@@ -3716,10 +3735,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
 		goto out;
 	}
 
-	r = mmu_topup_memory_caches(vcpu);
-	if (r)
-		goto out;
-
 	er = x86_emulate_instruction(vcpu, cr2, 0, insn, insn_len);
 
 	switch (er) {
-- 
1.7.5.4

