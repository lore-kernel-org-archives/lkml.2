Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0GITPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:15:47 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:33212 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab0GITPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:15:41 -0400
Message-Id: <20100709190856.096469965@quilx.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 14:07:17 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q2 11/19] slub: Remove static kmem_cache_cpu array for boot
References: <20100709190706.938177313@quilx.com>
Content-Disposition: inline; filename=maybe_remove_static
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The percpu allocator can now handle allocations in early boot.
So drop the static kmem_cache_cpu array.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-06 15:15:42.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-06 15:15:52.000000000 -0500
@@ -2068,23 +2068,14 @@ init_kmem_cache_node(struct kmem_cache_n
 #endif
 }
 
-static DEFINE_PER_CPU(struct kmem_cache_cpu, kmalloc_percpu[KMALLOC_CACHES]);
-
 static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 {
-	if (s < kmalloc_caches + KMALLOC_CACHES && s >= kmalloc_caches)
-		/*
-		 * Boot time creation of the kmalloc array. Use static per cpu data
-		 * since the per cpu allocator is not available yet.
-		 */
-		s->cpu_slab = kmalloc_percpu + (s - kmalloc_caches);
-	else
-		s->cpu_slab =  alloc_percpu(struct kmem_cache_cpu);
+	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
+			SLUB_PAGE_SHIFT * sizeof(struct kmem_cache));
 
-	if (!s->cpu_slab)
-		return 0;
+	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);
 
-	return 1;
+	return s->cpu_slab != NULL;
 }
 
 #ifdef CONFIG_NUMA


