Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2JTPtb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 11:49:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56614 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2JTPta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 11:49:30 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Christoph Lameter <cl@linux.com>
Subject: [PATCH for-v3.7 1/2] slub: optimize poorly inlined kmalloc* functions
Date: Sun, 21 Oct 2012 00:48:12 +0900
Message-Id: <1350748093-7868-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Yes>
References: <Yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() and kmalloc_node() is always inlined into generic code.
However, there is a mistake in implemention of the SLUB.

In kmalloc() and kmalloc_node() of the SLUB,
we try to compare kmalloc_caches[index] with NULL.
As it cannot be known at compile time,
this comparison is inserted into generic code invoking kmalloc*.
This may decrease system performance, so we should fix it.

Below is the result of "size vmlinux"
text size is decreased roughly 20KB

Before:
   text	   data	    bss	    dec	    hex	filename
10044177        1443168 5722112 17209457        1069871 vmlinux
After:
   text	   data	    bss	    dec	    hex	filename
10022627        1443136 5722112 17187875        1064423 vmlinux

Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <js1304@gmail.com>
---
With Christoph's patchset(common kmalloc caches:
'[15/15] Common Kmalloc cache determination') which is not merged into mainline yet,
this issue will be fixed.
As it takes some time, I send this patch for v3.7

This patch is based on v3.7-rc1

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index df448ad..4c75f2b 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -271,9 +271,10 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 			return kmalloc_large(size, flags);
 
 		if (!(flags & SLUB_DMA)) {
-			struct kmem_cache *s = kmalloc_slab(size);
+			int index = kmalloc_index(size);
+			struct kmem_cache *s = kmalloc_caches[index];
 
-			if (!s)
+			if (!index)
 				return ZERO_SIZE_PTR;
 
 			return kmem_cache_alloc_trace(s, flags, size);
@@ -304,9 +305,10 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	if (__builtin_constant_p(size) &&
 		size <= SLUB_MAX_SIZE && !(flags & SLUB_DMA)) {
-			struct kmem_cache *s = kmalloc_slab(size);
+		int index = kmalloc_index(size);
+		struct kmem_cache *s = kmalloc_caches[index];
 
-		if (!s)
+		if (!index)
 			return ZERO_SIZE_PTR;
 
 		return kmem_cache_alloc_node_trace(s, flags, node, size);
-- 
1.7.9.5

