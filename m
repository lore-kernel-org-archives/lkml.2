Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0FYMKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:10:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60378 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab0FYMKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:10:39 -0400
Message-ID: <4C249BDE.9050701@cn.fujitsu.com>
Date: Fri, 25 Jun 2010 20:06:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v2 7/10] KVM: MMU: introduce mmu_topup_memory_cache_atomic()
References: <4C2498EC.2010006@cn.fujitsu.com>
In-Reply-To: <4C2498EC.2010006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce mmu_topup_memory_cache_atomic(), it support topup memory
cache in atomic context

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f151540..6c06666 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -291,15 +291,16 @@ static void __set_spte(u64 *sptep, u64 spte)
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
@@ -307,6 +308,26 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
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
+static int pte_prefetch_topup_memory_cache(struct kvm_vcpu *vcpu, int num)
+{
+	return mmu_topup_memory_cache_atomic(&vcpu->arch.mmu_rmap_desc_cache,
+					     rmap_desc_cache, num);
+}
+
 static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
 				  struct kmem_cache *cache)
 {
-- 
1.6.1.2




