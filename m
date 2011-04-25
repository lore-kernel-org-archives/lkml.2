Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab1DYRqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:46:53 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:43595 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695Ab1DYRqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:46:52 -0400
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC/PATCH 1/2] slub: Break out alloc_kmem_cache_cpus() from kmem_cache_open()
Date: Mon, 25 Apr 2011 20:46:47 +0300
Message-Id: <1303753608-19248-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for sharing per-CPU structures between merged caches, break out
alloc_kmem_cache_cpus() from kmem_cache_open() function.

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 mm/slub.c |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 94d2a33..cb61024 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2638,11 +2638,7 @@ static int kmem_cache_open(struct kmem_cache *s,
 #endif
 	if (!init_kmem_cache_nodes(s))
 		goto error;
-
-	if (alloc_kmem_cache_cpus(s))
-		return 1;
-
-	free_kmem_cache_nodes(s);
+	return 1;
 error:
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slab %s size=%lu realsize=%u "
@@ -2818,6 +2814,9 @@ static struct kmem_cache *__init create_kmalloc_cache(const char *name,
 								flags, NULL))
 		goto panic;
 
+	if (!alloc_kmem_cache_cpus(s))
+		goto panic;
+
 	list_add(&s->list, &slab_caches);
 	return s;
 
@@ -3239,6 +3238,8 @@ void __init kmem_cache_init(void)
 		sizeof(struct kmem_cache_node),
 		0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 
+	alloc_kmem_cache_cpus(kmem_cache_node);
+
 	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 
 	/* Able to allocate the per node structures */
@@ -3247,6 +3248,8 @@ void __init kmem_cache_init(void)
 	temp_kmem_cache = kmem_cache;
 	kmem_cache_open(kmem_cache, "kmem_cache", kmem_size,
 		0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+	alloc_kmem_cache_cpus(kmem_cache);
+
 	kmem_cache = kmem_cache_alloc(kmem_cache, GFP_NOWAIT);
 	memcpy(kmem_cache, temp_kmem_cache, kmem_size);
 
@@ -3469,18 +3472,20 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 
 	s = kmalloc(kmem_size, GFP_KERNEL);
 	if (s) {
-		if (kmem_cache_open(s, n,
-				size, align, flags, ctor)) {
-			list_add(&s->list, &slab_caches);
-			if (sysfs_slab_add(s)) {
-				list_del(&s->list);
-				kfree(n);
-				kfree(s);
-				goto err;
-			}
-			up_write(&slub_lock);
-			return s;
+		if (!kmem_cache_open(s, n, size, align, flags, ctor))
+			goto err_free;
+
+		if (!alloc_kmem_cache_cpus(s))
+			goto err_free;	
+
+		list_add(&s->list, &slab_caches);
+		if (sysfs_slab_add(s)) {
+			list_del(&s->list);
+			goto err_free;
 		}
+		up_write(&slub_lock);
+		return s;
+err_free:
 		kfree(n);
 		kfree(s);
 	}
-- 
1.7.0.4

