Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab2CTKQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:16:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29844 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758993Ab2CTKQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:16:24 -0400
X-IronPort-AV: E=Sophos;i="4.73,617,1325433600"; 
   d="scan'208";a="4579993"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH 4/6] slob: don't couple the header size with the alignment
Date: Tue, 20 Mar 2012 18:21:22 +0800
Message-Id: <1332238884-6237-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-20 18:14:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-20 18:14:13,
	Serialize complete at 2012-03-20 18:14:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc-ed objects are prepended with a 4-byte header with the kmalloc size,
but in the code, the code of this head is coupled with the alignment code,
so we separate them.

The argument "int align" in slob_page_alloc() and slob_alloc() is split
as "size_t hsize" and "int align" for decoupling.

before patched: prepended header size is always as the same as align.
after patched: prepended header size is always
		max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/slob.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index 8105be4..266e518 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -267,7 +267,8 @@ static void slob_free_pages(void *b, int order)
 /*
  * Allocate a slob block within a given slob_page sp.
  */
-static void *slob_page_alloc(struct slob_page *sp, size_t size, int align)
+static void *slob_page_alloc(struct slob_page *sp, size_t size, size_t hsize,
+		int align)
 {
 	slob_t *prev, *cur, *aligned = NULL;
 	int delta = 0, units = SLOB_UNITS(size);
@@ -276,7 +277,8 @@ static void *slob_page_alloc(struct slob_page *sp, size_t size, int align)
 		slobidx_t avail = slob_units(cur);
 
 		if (align) {
-			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
+			aligned = (slob_t *)(ALIGN((unsigned long)cur + hsize,
+					align) - hsize);
 			delta = aligned - cur;
 		}
 		if (avail >= units + delta) { /* room enough? */
@@ -318,7 +320,7 @@ static void *slob_page_alloc(struct slob_page *sp, size_t size, int align)
 /*
  * slob_alloc: entry point into the slob allocator.
  */
-static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
+static void *slob_alloc(size_t size, gfp_t gfp, size_t hsize, int align, int node)
 {
 	struct slob_page *sp;
 	struct list_head *prev;
@@ -350,7 +352,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
 
 		/* Attempt to alloc */
 		prev = sp->list.prev;
-		b = slob_page_alloc(sp, size, align);
+		b = slob_page_alloc(sp, size, hsize, align);
 		if (!b)
 			continue;
 
@@ -378,7 +380,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
 		INIT_LIST_HEAD(&sp->list);
 		set_slob(b, SLOB_UNITS(PAGE_SIZE), b + SLOB_UNITS(PAGE_SIZE));
 		set_slob_page_free(sp, slob_list);
-		b = slob_page_alloc(sp, size, align);
+		b = slob_page_alloc(sp, size, hsize, align);
 		BUG_ON(!b);
 		spin_unlock_irqrestore(&slob_lock, flags);
 	}
@@ -479,26 +481,28 @@ out:
 void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 {
 	unsigned int *m;
-	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+	int hsize = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+	int align;
 	void *ret;
 
 	gfp &= gfp_allowed_mask;
+	align = hsize;
 
 	lockdep_trace_alloc(gfp);
 
-	if (size < PAGE_SIZE - align) {
+	if (size < PAGE_SIZE - hsize) {
 		if (!size)
 			return ZERO_SIZE_PTR;
 
-		m = slob_alloc(size + align, gfp, align, node);
+		m = slob_alloc(size + hsize, gfp, hsize, align, node);
 
 		if (!m)
 			return NULL;
 		*m = size;
-		ret = (void *)m + align;
+		ret = (void *)m + hsize;
 
 		trace_kmalloc_node(_RET_IP_, ret,
-				   size, size + align, gfp, node);
+				   size, size + hsize, gfp, node);
 	} else {
 		unsigned int order = get_order(size);
 
@@ -532,9 +536,9 @@ void kfree(const void *block)
 
 	sp = slob_page(block);
 	if (is_slob_page(sp)) {
-		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
-		unsigned int *m = (unsigned int *)(block - align);
-		slob_free(m, *m + align);
+		int hsize = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+		unsigned int *m = (unsigned int *)(block - hsize);
+		slob_free(m, *m + hsize);
 	} else
 		put_page(&sp->page);
 }
@@ -572,7 +576,7 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	struct kmem_cache *c;
 
 	c = slob_alloc(sizeof(struct kmem_cache),
-		GFP_KERNEL, ARCH_KMALLOC_MINALIGN, -1);
+		GFP_KERNEL, 0, ARCH_KMALLOC_MINALIGN, -1);
 
 	if (c) {
 		c->name = name;
@@ -615,7 +619,7 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 	lockdep_trace_alloc(flags);
 
 	if (c->size < PAGE_SIZE) {
-		b = slob_alloc(c->size, flags, c->align, node);
+		b = slob_alloc(c->size, flags, 0, c->align, node);
 		trace_kmem_cache_alloc_node(_RET_IP_, b, c->size,
 					    SLOB_UNITS(c->size) * SLOB_UNIT,
 					    flags, node);
-- 
1.7.4.4

