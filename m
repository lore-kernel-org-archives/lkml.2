Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0JES7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:59:08 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:39463 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754851Ab0JES6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:58:22 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5LlIfjMVM1mYvfETM7UpNWICcwRx7.WkUaVhDK9C_Ho_b0F
 FGFm5KONTiP3z0fwnyMXDNFk3rcjgdcRfMDKyTwOgCU3IUGc3Jz5JtlIwvDT
 0GGHqvvDQztFMK5k_oNM27p1VkR2nHJhEdQoYQqnWpS9UhShMdSQLc6mzxv5
 OyZIC_e_9AU5if4dLL3ynDFDn6OO0hP0wMvUwPV.8XbRVsbU5NWQpMwVroID
 iMjZWm3T22afTS1JqO_1icX996b7smyhW9g--
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101005185819.929054093@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 05 Oct 2010 13:57:39 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>
Subject: [UnifiedV4 14/16] slub: Reduce size of not performance critical slabs
References: <20101005185725.088808842@linux.com>
Content-Disposition: inline; filename=unified_reduce
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some slab caches around that are rarely used and which are not
performance critical. Add a new SLAB_LOWMEM option to reduce the memory
requirements of such slabs. SLAB_LOWMEM caches will keep no empty slabs
around, have no shared or alien caches and will have a small per cpu
queue of 5 objects.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/slab.h |    2 ++
 mm/slub.c            |   25 ++++++++++++++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/slab.h
===================================================================
--- linux-2.6.orig/include/linux/slab.h	2010-10-05 13:40:04.000000000 -0500
+++ linux-2.6/include/linux/slab.h	2010-10-05 13:40:08.000000000 -0500
@@ -17,12 +17,14 @@
  * The ones marked DEBUG are only valid if CONFIG_SLAB_DEBUG is set.
  */
 #define SLAB_DEBUG_FREE		0x00000100UL	/* DEBUG: Perform (expensive) checks on free */
+#define SLAB_LOWMEM		0x00000200UL	/* Reduce memory usage of this slab */
 #define SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone objs in a cache */
 #define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
 #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
 #define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
 #define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
 #define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
+
 /*
  * SLAB_DESTROY_BY_RCU - **WARNING** READ THIS!
  *
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-10-05 13:40:04.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-10-05 13:40:08.000000000 -0500
@@ -2829,12 +2829,20 @@ static int kmem_cache_open(struct kmem_c
 	 * The larger the object size is, the more pages we want on the partial
 	 * list to avoid pounding the page allocator excessively.
 	 */
-	set_min_partial(s, ilog2(s->size));
+	if (flags & SLAB_LOWMEM)
+		set_min_partial(s, 0);
+	else
+		set_min_partial(s, ilog2(s->size));
+
 	s->refcount = 1;
 	if (!init_kmem_cache_nodes(s))
 		goto error;
 
-	s->queue = initial_queue_size(s->size);
+	if (flags & SLAB_LOWMEM)
+		s->queue = 5;
+	else
+		s->queue = initial_queue_size(s->size);
+
 	s->batch = (s->queue + 1) / 2;
 
 #ifdef CONFIG_NUMA
@@ -2879,7 +2887,9 @@ static int kmem_cache_open(struct kmem_c
 
 	if (alloc_kmem_cache_cpus(s)) {
 		s->shared_queue_sysfs = 0;
-		if (nr_cpu_ids > 1 && s->size < PAGE_SIZE) {
+		if (!(flags & SLAB_LOWMEM) &&
+				nr_cpu_ids > 1 &&
+				s->size < PAGE_SIZE) {
 			s->shared_queue_sysfs = 10 * s->batch;
 			alloc_shared_caches(s);
 		}
@@ -3788,7 +3798,7 @@ void __init kmem_cache_init(void)
 
 	kmem_cache_open(kmem_cache_node, "kmem_cache_node",
 		sizeof(struct kmem_cache_node),
-		0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+		0, SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_LOWMEM, NULL);
 
 	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 
@@ -3797,7 +3807,7 @@ void __init kmem_cache_init(void)
 
 	temp_kmem_cache = kmem_cache;
 	kmem_cache_open(kmem_cache, "kmem_cache", kmem_size,
-		0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+		0, SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_LOWMEM, NULL);
 	kmem_cache = kmem_cache_alloc(kmem_cache, GFP_NOWAIT);
 	memcpy(kmem_cache, temp_kmem_cache, kmem_size);
 
@@ -3906,12 +3916,9 @@ void __init kmem_cache_init(void)
 		if (s && s->size) {
 			char *name = kasprintf(GFP_NOWAIT,
 				 "dma-kmalloc-%d", s->objsize);
-
 			BUG_ON(!name);
 			kmalloc_dma_caches[i] = create_kmalloc_cache(name,
-				s->objsize, SLAB_CACHE_DMA);
-			 /* DMA caches are rarely used. Reduce memory consumption */
-			kmalloc_dma_caches[i]->shared_queue_sysfs = 0;
+				s->objsize, SLAB_CACHE_DMA | SLAB_LOWMEM);
 		}
 	}
 #endif

