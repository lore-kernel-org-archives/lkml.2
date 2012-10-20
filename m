Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2JTPti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 11:49:38 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63103 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab2JTPtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 11:49:33 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Christoph Lameter <cl@linux.com>
Subject: [PATCH for-v3.7 2/2] slub: optimize kmalloc* inlining for GFP_DMA
Date: Sun, 21 Oct 2012 00:48:13 +0900
Message-Id: <1350748093-7868-2-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350748093-7868-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1350748093-7868-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() and kmalloc_node() of the SLUB isn't inlined when @flags = __GFP_DMA.
This patch optimize this case,
so when @flags = __GFP_DMA, it will be inlined into generic code.

Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 4c75f2b..4adf50b 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -147,6 +147,7 @@ struct kmem_cache {
  * 2^x bytes of allocations.
  */
 extern struct kmem_cache *kmalloc_caches[SLUB_PAGE_SHIFT];
+extern struct kmem_cache *kmalloc_dma_caches[SLUB_PAGE_SHIFT];
 
 /*
  * Sorry that the following has to be that ugly but some versions of GCC
@@ -266,19 +267,24 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
+	struct kmem_cache *s;
+	int index;
+
 	if (__builtin_constant_p(size)) {
 		if (size > SLUB_MAX_SIZE)
 			return kmalloc_large(size, flags);
 
-		if (!(flags & SLUB_DMA)) {
-			int index = kmalloc_index(size);
-			struct kmem_cache *s = kmalloc_caches[index];
-
-			if (!index)
-				return ZERO_SIZE_PTR;
+		index = kmalloc_index(size);
+		if (!index)
+			return ZERO_SIZE_PTR;
+#ifdef CONFIG_ZONE_DMA
+		if (unlikely(flags & SLUB_DMA)) {
+			s = kmalloc_dma_caches[index];
+		} else
+#endif
+			s = kmalloc_caches[index];
 
-			return kmem_cache_alloc_trace(s, flags, size);
-		}
+		return kmem_cache_alloc_trace(s, flags, size);
 	}
 	return __kmalloc(size, flags);
 }
@@ -303,13 +309,19 @@ kmem_cache_alloc_node_trace(struct kmem_cache *s,
 
 static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
-	if (__builtin_constant_p(size) &&
-		size <= SLUB_MAX_SIZE && !(flags & SLUB_DMA)) {
-		int index = kmalloc_index(size);
-		struct kmem_cache *s = kmalloc_caches[index];
+	struct kmem_cache *s;
+	int index;
 
+	if (__builtin_constant_p(size) && size <= SLUB_MAX_SIZE) {
+		index = kmalloc_index(size);
 		if (!index)
 			return ZERO_SIZE_PTR;
+#ifdef CONFIG_ZONE_DMA
+		if (unlikely(flags & SLUB_DMA)) {
+			s = kmalloc_dma_caches[index];
+		} else
+#endif
+			s = kmalloc_caches[index];
 
 		return kmem_cache_alloc_node_trace(s, flags, node, size);
 	}
diff --git a/mm/slub.c b/mm/slub.c
index a0d6984..a94533c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3222,7 +3222,8 @@ struct kmem_cache *kmalloc_caches[SLUB_PAGE_SHIFT];
 EXPORT_SYMBOL(kmalloc_caches);
 
 #ifdef CONFIG_ZONE_DMA
-static struct kmem_cache *kmalloc_dma_caches[SLUB_PAGE_SHIFT];
+struct kmem_cache *kmalloc_dma_caches[SLUB_PAGE_SHIFT];
+EXPORT_SYMBOL(kmalloc_dma_caches);
 #endif
 
 static int __init setup_slub_min_order(char *str)
-- 
1.7.9.5

