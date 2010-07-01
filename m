Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0GAN6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:58:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64436 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab0GAN6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:58:20 -0400
Message-ID: <4C2C9E14.4070501@cn.fujitsu.com>
Date: Thu, 01 Jul 2010 21:54:28 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v4 3/6] KVM: MMU: introduce pte_prefetch_topup_memory_cache()
References: <4C2C9DC0.8050607@cn.fujitsu.com>
In-Reply-To: <4C2C9DC0.8050607@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce this function to topup prefetch cache

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a0c5c31..6673484 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -89,6 +89,8 @@ module_param(oos_shadow, bool, 0644);
 	}
 #endif
 
+#define PTE_PREFETCH_NUM	16
+
 #define PT_FIRST_AVAIL_BITS_SHIFT 9
 #define PT64_SECOND_AVAIL_BITS_SHIFT 52
 
@@ -290,15 +292,16 @@ static void __set_spte(u64 *sptep, u64 spte)
 #endif
 }
 
-static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				  struct kmem_cache *base_cache, int min)
+static int __mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+				    struct kmem_cache *base_cache, int min,
+				    int max, gfp_t flags)
 {
 	void *obj;
 
 	if (cache->nobjs >= min)
 		return 0;
-	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL);
+	while (cache->nobjs < max) {
+		obj = kmem_cache_zalloc(base_cache, flags);
 		if (!obj)
 			return -ENOMEM;
 		cache->objects[cache->nobjs++] = obj;
@@ -306,6 +309,20 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 	return 0;
 }
 
+static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+				  struct kmem_cache *base_cache, int min)
+{
+	return __mmu_topup_memory_cache(cache, base_cache, min,
+				ARRAY_SIZE(cache->objects), GFP_KERNEL);
+}
+
+static int pte_prefetch_topup_memory_cache(struct kvm_vcpu *vcpu)
+{
+	return __mmu_topup_memory_cache(&vcpu->arch.mmu_rmap_desc_cache,
+					rmap_desc_cache, PTE_PREFETCH_NUM,
+					PTE_PREFETCH_NUM, GFP_ATOMIC);
+}
+
 static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
 				  struct kmem_cache *cache)
 {
-- 
1.6.1.2


