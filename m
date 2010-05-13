Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab0EMCJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:09:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57814 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab0EMCJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:09:17 -0400
Message-ID: <4BEB5E8A.7030606@cn.fujitsu.com>
Date: Thu, 13 May 2010 10:06:02 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] KVM MMU: fix objects free
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where to alloc, where to free

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 604eb3f..67da751 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -304,10 +304,11 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 	return 0;
 }
 
-static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
+static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
+				  struct kmem_cache *cache)
 {
 	while (mc->nobjs)
-		kfree(mc->objects[--mc->nobjs]);
+		kmem_cache_free(cache, mc->objects[--mc->nobjs]);
 }
 
 static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
@@ -355,10 +356,11 @@ out:
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_pte_chain_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_rmap_desc_cache);
+	mmu_free_memory_cache(&vcpu->arch.mmu_pte_chain_cache, pte_chain_cache);
+	mmu_free_memory_cache(&vcpu->arch.mmu_rmap_desc_cache, rmap_desc_cache);
 	mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
+	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache,
+				mmu_page_header_cache);
 }
 
 static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc,
@@ -379,7 +381,7 @@ static struct kvm_pte_chain *mmu_alloc_pte_chain(struct kvm_vcpu *vcpu)
 
 static void mmu_free_pte_chain(struct kvm_pte_chain *pc)
 {
-	kfree(pc);
+	kmem_cache_free(pte_chain_cache, pc);
 }
 
 static struct kvm_rmap_desc *mmu_alloc_rmap_desc(struct kvm_vcpu *vcpu)
@@ -390,7 +392,7 @@ static struct kvm_rmap_desc *mmu_alloc_rmap_desc(struct kvm_vcpu *vcpu)
 
 static void mmu_free_rmap_desc(struct kvm_rmap_desc *rd)
 {
-	kfree(rd);
+	kmem_cache_free(rmap_desc_cache, rd);
 }
 
 /*
@@ -897,7 +899,7 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	list_del(&sp->link);
 	__free_page(virt_to_page(sp->spt));
 	__free_page(virt_to_page(sp->gfns));
-	kfree(sp);
+	kmem_cache_free(mmu_page_header_cache, sp);
 	++kvm->arch.n_free_mmu_pages;
 }
 
-- 
1.6.1.2

