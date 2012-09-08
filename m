Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2IHUvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:51:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37179 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab2IHUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:50:16 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH 07/10] mm, slab: Match SLAB and SLUB kmem_cache_alloc_xxx_trace() prototype
Date: Sat,  8 Sep 2012 17:47:56 -0300
Message-Id: <1347137279-17568-7-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This long (seemingly unnecessary) patch does not fix anything and
its only goal is to produce common code between SLAB and SLUB.

Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 include/linux/slab_def.h |    7 +++----
 mm/slab.c                |   10 +++++-----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 604ebc8..e98caeb 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -111,11 +111,10 @@ void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
 #ifdef CONFIG_TRACING
-extern void *kmem_cache_alloc_trace(size_t size,
-				    struct kmem_cache *cachep, gfp_t flags);
+extern void *kmem_cache_alloc_trace(struct kmem_cache *, gfp_t, size_t);
 #else
 static __always_inline void *
-kmem_cache_alloc_trace(size_t size, struct kmem_cache *cachep, gfp_t flags)
+kmem_cache_alloc_trace(struct kmem_cache *cachep, gfp_t flags, size_t size)
 {
 	return kmem_cache_alloc(cachep, flags);
 }
@@ -148,7 +147,7 @@ found:
 #endif
 			cachep = malloc_sizes[i].cs_cachep;
 
-		ret = kmem_cache_alloc_trace(size, cachep, flags);
+		ret = kmem_cache_alloc_trace(cachep, flags, size);
 
 		return ret;
 	}
diff --git a/mm/slab.c b/mm/slab.c
index bc342d1..47cb03c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3834,7 +3834,7 @@ EXPORT_SYMBOL(kmem_cache_alloc);
 
 #ifdef CONFIG_TRACING
 void *
-kmem_cache_alloc_trace(size_t size, struct kmem_cache *cachep, gfp_t flags)
+kmem_cache_alloc_trace(struct kmem_cache *cachep, gfp_t flags, size_t size)
 {
 	void *ret;
 
@@ -3861,10 +3861,10 @@ void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 
 #ifdef CONFIG_TRACING
-void *kmem_cache_alloc_node_trace(size_t size,
-				  struct kmem_cache *cachep,
+void *kmem_cache_alloc_node_trace(struct kmem_cache *cachep,
 				  gfp_t flags,
-				  int nodeid)
+				  int nodeid,
+				  size_t size)
 {
 	void *ret;
 
@@ -3886,7 +3886,7 @@ __do_kmalloc_node(size_t size, gfp_t flags, int node, unsigned long caller)
 	cachep = kmem_find_general_cachep(size, flags);
 	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
 		return cachep;
-	return kmem_cache_alloc_node_trace(size, cachep, flags, node);
+	return kmem_cache_alloc_node_trace(cachep, flags, node, size);
 }
 
 #if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_TRACING)
-- 
1.7.8.6

