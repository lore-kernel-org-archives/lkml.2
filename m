Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2IHUuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:50:05 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57653 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2IHUuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:50:03 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 02/10] mm, slob: Use NUMA_NO_NODE instead of -1
Date: Sat,  8 Sep 2012 17:47:51 -0300
Message-Id: <1347137279-17568-2-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 include/linux/slob_def.h |    6 ++++--
 mm/slob.c                |    6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/slob_def.h b/include/linux/slob_def.h
index 0ec00b3..f28e14a 100644
--- a/include/linux/slob_def.h
+++ b/include/linux/slob_def.h
@@ -1,12 +1,14 @@
 #ifndef __LINUX_SLOB_DEF_H
 #define __LINUX_SLOB_DEF_H
 
+#include <linux/numa.h>
+
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
 static __always_inline void *kmem_cache_alloc(struct kmem_cache *cachep,
 					      gfp_t flags)
 {
-	return kmem_cache_alloc_node(cachep, flags, -1);
+	return kmem_cache_alloc_node(cachep, flags, NUMA_NO_NODE);
 }
 
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
@@ -26,7 +28,7 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
  */
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
-	return __kmalloc_node(size, flags, -1);
+	return __kmalloc_node(size, flags, NUMA_NO_NODE);
 }
 
 static __always_inline void *__kmalloc(size_t size, gfp_t flags)
diff --git a/mm/slob.c b/mm/slob.c
index ae46edc..c0c1a93 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -193,7 +193,7 @@ static void *slob_new_pages(gfp_t gfp, int order, int node)
 	void *page;
 
 #ifdef CONFIG_NUMA
-	if (node != -1)
+	if (node != NUMA_NO_NODE)
 		page = alloc_pages_exact_node(node, gfp, order);
 	else
 #endif
@@ -289,7 +289,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
 		 * If there's a node specification, search for a partial
 		 * page with a matching node id in the freelist.
 		 */
-		if (node != -1 && page_to_nid(sp) != node)
+		if (node != NUMA_NO_NODE && page_to_nid(sp) != node)
 			continue;
 #endif
 		/* Enough room on this page? */
@@ -510,7 +510,7 @@ struct kmem_cache *__kmem_cache_create(const char *name, size_t size,
 	struct kmem_cache *c;
 
 	c = slob_alloc(sizeof(struct kmem_cache),
-		GFP_KERNEL, ARCH_KMALLOC_MINALIGN, -1);
+		GFP_KERNEL, ARCH_KMALLOC_MINALIGN, NUMA_NO_NODE);
 
 	if (c) {
 		c->name = name;
-- 
1.7.8.6

