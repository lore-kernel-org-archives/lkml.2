Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1GZLXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 07:23:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57620 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab1GZLXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 07:23:16 -0400
Message-ID: <4E2EA41A.3080606@cn.fujitsu.com>
Date: Tue, 26 Jul 2011 19:25:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 01/11] KVM: MMU: avoid pte_list_desc run out in kvm_mmu_pte_write
References: <4E2EA3DB.7040403@cn.fujitsu.com>
In-Reply-To: <4E2EA3DB.7040403@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 19:22:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 19:22:21,
	Serialize complete at 2011-07-26 19:22:21
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
 arch/x86/kvm/mmu.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9335e1b..587695b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -593,6 +593,11 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 	return 0;
 }
 
+static int mmu_memory_cache_free_object(struct kvm_mmu_memory_cache *cache)
+{
+	return cache->nobjs;
+}
+
 static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
 				  struct kmem_cache *cache)
 {
@@ -3526,6 +3531,14 @@ static void kvm_mmu_access_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 		set_bit(PT_ACCESSED_SHIFT, (unsigned long *)spte);
 }
 
+static int get_free_pte_list_desc_nr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu_memory_cache *cache;
+
+	cache = &vcpu->arch.mmu_pte_list_desc_cache;
+	return mmu_memory_cache_free_object(cache);
+}
+
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes,
 		       bool guest_initiated)
@@ -3583,6 +3596,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		break;
 	}
 
+	mmu_topup_memory_caches(vcpu);
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
 		gentry = 0;
@@ -3653,7 +3667,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 			mmu_page_zap_pte(vcpu->kvm, sp, spte);
 			if (gentry &&
 			      !((sp->role.word ^ vcpu->arch.mmu.base_role.word)
-			      & mask.word))
+			      & mask.word) && get_free_pte_list_desc_nr(vcpu))
 				mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);
 			if (!remote_flush && need_remote_flush(entry, *spte))
 				remote_flush = true;
@@ -3714,10 +3728,6 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
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

