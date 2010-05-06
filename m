Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab0EFJe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:34:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54114 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756840Ab0EFJex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:34:53 -0400
Message-ID: <4BE28C7C.3060806@cn.fujitsu.com>
Date: Thu, 06 May 2010 17:31:40 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 8/9] KVM MMU: no need atomic operation for 'invlpg_counter'
References: <4BE2818A.5000301@cn.fujitsu.com>
In-Reply-To: <4BE2818A.5000301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'invlpg_counter' is protected by 'kvm->mmu_lock', no need atomic
operation anymore

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/paging_tmpl.h      |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 86a8550..f4e8973 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -387,7 +387,7 @@ struct kvm_arch {
 	unsigned int n_free_mmu_pages;
 	unsigned int n_requested_mmu_pages;
 	unsigned int n_alloc_mmu_pages;
-	atomic_t invlpg_counter;
+	unsigned int invlpg_counter;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 93ee2d9..ceaac55 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -466,7 +466,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 	struct kvm_shadow_walk_iterator iterator;
 	gfn_t gfn = -1;
 	u64 *sptep = NULL, gentry;
-	int invlpg_counter, level, offset = 0, need_flush = 0;
+	unsigned int invlpg_counter;
+	int level, offset = 0, need_flush = 0;
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
@@ -502,7 +503,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 	if (need_flush)
 		kvm_flush_remote_tlbs(vcpu->kvm);
 
-	invlpg_counter = atomic_add_return(1, &vcpu->kvm->arch.invlpg_counter);
+	invlpg_counter = ++vcpu->kvm->arch.invlpg_counter;
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
 	if (gfn == -1)
@@ -522,7 +523,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 			kvm_mmu_free_page(vcpu->kvm, sp);
 		goto unlock_exit;
 	}
-	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) == invlpg_counter &&
+	if (vcpu->kvm->arch.invlpg_counter == invlpg_counter &&
 			sp->role.level == PT_PAGE_TABLE_LEVEL) {
 		++vcpu->kvm->stat.mmu_pte_updated;
 		FNAME(update_pte)(vcpu, sp, sptep, &gentry);
-- 
1.6.1.2





