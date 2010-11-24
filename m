Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0KXV1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 16:27:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47842 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0KXV1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 16:27:19 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=_2Z3wvtyEzcA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=iShrPDjN9fLwiOc2SbsA:9 a=dvFJIe9aMbgCwNZqYx0A:7 a=KF1HMx_XO-OBxTOrnKo28sue3_wA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101124212717.468748477@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 24 Nov 2010 16:23:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [RFC][PATCH 2/2] [PATCH 2/2] tracing/slub: Move kmalloc tracepoint out of inline code
References: <20101124212333.808256210@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-slub-Move-kmalloc-tracepoint-out-of-inline-c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The tracepoint for kmalloc is in the slub inlined code which causes
every instance of kmalloc to have the tracepoint.

This patch moves the tracepoint out of the inline code to the
slub C file (and to page_alloc), which removes a large number of
inlined trace points.

  objdump -dr vmlinux.slub| grep 'jmpq.*<trace_kmalloc' |wc -l
375
  objdump -dr vmlinux.slub.patched| grep 'jmpq.*<trace_kmalloc' |wc -l
2

This also has a nice impact on size.
   text	   data	    bss	    dec	    hex	filename
7050424	1961068	2482688	11494180	 af6324	vmlinux.slub
6979599	1944620	2482688	11406907	 ae0e3b	vmlinux.slub.patched

Siged-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/slub_def.h |   46 +++++++++++++++++++++-------------------------
 mm/page_alloc.c          |   14 ++++++++++++++
 mm/slub.c                |   27 +++++++++++++++++++--------
 3 files changed, 54 insertions(+), 33 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index e4f5ed1..d390b18 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -217,30 +217,35 @@ void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
 #ifdef CONFIG_TRACING
-extern void *kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags);
+extern void *kmem_cache_alloc_trace(size_t size,
+				    struct kmem_cache *s, gfp_t gfpflags);
+unsigned long __get_free_pages_trace(size_t size,
+				     gfp_t gfp_mask, unsigned int order);
 #else
 static __always_inline void *
-kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags)
+kmem_cache_alloc_trace(size_t size, struct kmem_cache *s, gfp_t gfpflags)
 {
 	return kmem_cache_alloc(s, gfpflags);
 }
+static __always_inline unsigned long
+__get_free_pages_trace(size_t size, gfp_t gfp_mask, unsigned int order)
+{
+	return __get_free_pages(gfp_mask, order);
+}
 #endif
 
 static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
 {
 	unsigned int order = get_order(size);
-	void *ret = (void *) __get_free_pages(flags | __GFP_COMP, order);
+	void *ret = __get_free_pages_trace(size, flags | __GFP_COMP, order);
 
 	kmemleak_alloc(ret, size, 1, flags);
-	trace_kmalloc(_THIS_IP_, ret, size, PAGE_SIZE << order, flags);
 
 	return ret;
 }
 
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
-	void *ret;
-
 	if (__builtin_constant_p(size)) {
 		if (size > SLUB_MAX_SIZE)
 			return kmalloc_large(size, flags);
@@ -251,11 +256,7 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 			if (!s)
 				return ZERO_SIZE_PTR;
 
-			ret = kmem_cache_alloc_notrace(s, flags);
-
-			trace_kmalloc(_THIS_IP_, ret, size, s->size, flags);
-
-			return ret;
+			return kmem_cache_alloc_trace(size, s, flags);
 		}
 	}
 	return __kmalloc(size, flags);
@@ -266,14 +267,16 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node);
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 
 #ifdef CONFIG_TRACING
-extern void *kmem_cache_alloc_node_notrace(struct kmem_cache *s,
-					   gfp_t gfpflags,
-					   int node);
+extern void *kmem_cache_alloc_node_trace(size_t size,
+					 struct kmem_cache *s,
+					 gfp_t gfpflags,
+					 int node);
 #else
 static __always_inline void *
-kmem_cache_alloc_node_notrace(struct kmem_cache *s,
-			      gfp_t gfpflags,
-			      int node)
+kmem_cache_alloc_node_trace(struct size_t size,
+			    struct kmem_cache *s,
+			    gfp_t gfpflags,
+			    int node)
 {
 	return kmem_cache_alloc_node(s, gfpflags, node);
 }
@@ -281,8 +284,6 @@ kmem_cache_alloc_node_notrace(struct kmem_cache *s,
 
 static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
-	void *ret;
-
 	if (__builtin_constant_p(size) &&
 		size <= SLUB_MAX_SIZE && !(flags & SLUB_DMA)) {
 			struct kmem_cache *s = kmalloc_slab(size);
@@ -290,12 +291,7 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 		if (!s)
 			return ZERO_SIZE_PTR;
 
-		ret = kmem_cache_alloc_node_notrace(s, flags, node);
-
-		trace_kmalloc_node(_THIS_IP_, ret,
-				   size, s->size, flags, node);
-
-		return ret;
+		return kmem_cache_alloc_node_trace(size, s, flags, node);
 	}
 	return __kmalloc_node(size, flags, node);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 07a6544..c65e891 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2187,6 +2187,20 @@ unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
 }
 EXPORT_SYMBOL(__get_free_pages);
 
+#ifdef CONFIG_TRACING
+unsigned long
+__get_free_pages_trace(size_t size, gfp_t gfp_mask, unsigned int order)
+{
+	unsigned long ret;
+
+	ret = __get_free_pages(gfp_mask, order);
+	trace_kmalloc(_RET_IP_, (void *)ret, size,
+		      PAGE_SIZE << order, gfp_mask);
+	return ret;
+}
+EXPORT_SYMBOL(__get_free_pages_trace);
+#endif
+
 unsigned long get_zeroed_page(gfp_t gfp_mask)
 {
 	return __get_free_pages(gfp_mask | __GFP_ZERO, 0);
diff --git a/mm/slub.c b/mm/slub.c
index 981fb73..35d0eb4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1774,11 +1774,16 @@ void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 #ifdef CONFIG_TRACING
-void *kmem_cache_alloc_notrace(struct kmem_cache *s, gfp_t gfpflags)
+void *kmem_cache_alloc_trace(size_t size, struct kmem_cache *s, gfp_t gfpflags)
 {
-	return slab_alloc(s, gfpflags, NUMA_NO_NODE, _RET_IP_);
+	void *ret;
+
+	ret = slab_alloc(s, gfpflags, NUMA_NO_NODE, _RET_IP_);
+	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags);
+
+	return ret;
 }
-EXPORT_SYMBOL(kmem_cache_alloc_notrace);
+EXPORT_SYMBOL(kmem_cache_alloc_trace);
 #endif
 
 #ifdef CONFIG_NUMA
@@ -1794,13 +1799,19 @@ void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 
 #ifdef CONFIG_TRACING
-void *kmem_cache_alloc_node_notrace(struct kmem_cache *s,
-				    gfp_t gfpflags,
-				    int node)
+void *kmem_cache_alloc_node_trace(size_t size,
+				  struct kmem_cache *s,
+				  gfp_t gfpflags,
+				  int node)
 {
-	return slab_alloc(s, gfpflags, node, _RET_IP_);
+	void *ret;
+
+	ret = slab_alloc(s, gfpflags, node, _RET_IP_);
+	trace_kmalloc_node(_RET_IP_, ret,
+			   size, s->size, gfpflags, node);
+	return ret;
 }
-EXPORT_SYMBOL(kmem_cache_alloc_node_notrace);
+EXPORT_SYMBOL(kmem_cache_alloc_node_trace);
 #endif
 #endif
 
-- 
1.7.1


