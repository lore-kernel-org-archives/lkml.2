Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab0FOCuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:50:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60387 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756369Ab0FOCub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:50:31 -0400
Message-ID: <4C16E9A0.9080808@cn.fujitsu.com>
Date: Tue, 15 Jun 2010 10:46:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 4/6] KVM: MMU: introduce mmu_topup_memory_cache_atomic()
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com> <4C16E7AD.1060101@cn.fujitsu.com> <4C16E7F4.5060801@cn.fujitsu.com>
In-Reply-To: <4C16E7F4.5060801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce mmu_topup_memory_cache_atomic(), it support topup memory
cache in atomic context.

And, when we prefetch pte, we need topup the rmap's cache

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 734b106..92ff099 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -290,15 +290,16 @@ static void __set_spte(u64 *sptep, u64 spte)
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
@@ -306,6 +307,26 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 	return 0;
 }
 
+static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+				  struct kmem_cache *base_cache, int min)
+{
+	return __mmu_topup_memory_cache(cache, base_cache, min,
+				ARRAY_SIZE(cache->objects), GFP_KERNEL);
+}
+
+static int mmu_topup_memory_cache_atomic(struct kvm_mmu_memory_cache *cache,
+				  struct kmem_cache *base_cache, int min)
+{
+	return __mmu_topup_memory_cache(cache, base_cache, min, min,
+					GFP_ATOMIC);
+}
+
+static int pte_prefetch_topup_memory_cache(struct kvm_vcpu *vcpu)
+{
+	return mmu_topup_memory_cache_atomic(&vcpu->arch.mmu_rmap_desc_cache,
+					     rmap_desc_cache, 1);
+}
+
 static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
 				  struct kmem_cache *cache)
 {
-- 
1.6.1.2




