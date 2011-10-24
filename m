Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1JXR2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 13:28:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28838 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1JXR2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 13:28:17 -0400
Date: Mon, 24 Oct 2011 13:27:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        thellstrom@vmware.com, airlied@redhat.com,
        xen-devel@lists.xensource.com, j.glisse@redhat.com, bskeggs@redhat.com
Subject: Re: [PATCH 06/11] ttm/driver: Expand ttm_backend_func to include two
 overrides for TTM page pool.
Message-ID: <20111024172728.GD2320@phenom.dumpdata.com>
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
 <1319062772-2793-7-git-send-email-konrad.wilk@oracle.com>
 <4EA28FA6.7000006@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA28FA6.7000006@shipmail.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4EA5A00B.0098,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 11:40:54AM +0200, Thomas Hellstrom wrote:
> Konrad,
> 
> I was hoping that we could get rid of the dma_address shuffling into
> core TTM,
> like I mentioned in the review. From what I can tell it's now only
> used in the backend and
> core ttm doesn't care about it.
> 
> Is there a particular reason we're still passing it around?

Yes - and I should have addressed that in the writeup but forgot, sorry about that.

So initially I thought you meant this:

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index 360afb3..06ef048 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -662,8 +662,7 @@ out:
 
 /* Put all pages in pages list to correct pool to wait for reuse */
 static void __ttm_put_pages(struct list_head *pages, unsigned page_count,
-			    int flags, enum ttm_caching_state cstate,
-			    dma_addr_t *dma_address)
+			    int flags, enum ttm_caching_state cstate)
 {
 	unsigned long irq_flags;
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
@@ -707,8 +706,7 @@ static void __ttm_put_pages(struct list_head *pages, unsigned page_count,
  * cached pages.
  */
 static int __ttm_get_pages(struct list_head *pages, int flags,
-			   enum ttm_caching_state cstate, unsigned count,
-			   dma_addr_t *dma_address)
+			   enum ttm_caching_state cstate, unsigned count)
 {
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
 	struct page *p = NULL;
@@ -864,7 +862,7 @@ int ttm_get_pages(struct ttm_tt *ttm, struct list_head *pages,
 	if (ttm->be && ttm->be->func && ttm->be->func->get_pages)
 		return ttm->be->func->get_pages(ttm, pages, count, dma_address);
 	return __ttm_get_pages(pages, ttm->page_flags, ttm->caching_state,
-				count, dma_address);
+				count)
 }
 void ttm_put_pages(struct ttm_tt *ttm, struct list_head *pages,
 		   unsigned page_count, dma_addr_t *dma_address)
@@ -873,5 +871,5 @@ void ttm_put_pages(struct ttm_tt *ttm, struct list_head *pages,
 		ttm->be->func->put_pages(ttm, pages, page_count, dma_address);
 	else
 		__ttm_put_pages(pages, page_count, ttm->page_flags,
-				ttm->caching_state, dma_address);
+				ttm->caching_state)
 }
which is trivial (thought I have not compile tested it), but it should do it.

But I think you mean eliminate the dma_address handling completly in
ttm_page_alloc.c and ttm_tt.c.

For that there are couple of architectural issues I am not sure how to solve. 

There has to be some form of TTM<->[Radeon|Nouveau] lookup mechanism
to say: "here is a 'struct page *', give me the bus address". Currently
this is solved by keeping an array of DMA addresses along with the list
of pages. And passing the list and DMA address up the stack (and down)
from TTM up to the driver (when ttm->be->func->populate is called and they
are handed off) does it. It does not break any API layering .. and the internal
TTM pool (non-DMA) can just ignore the dma_address altogether (see patch above).

But if we wanted to rip all mention of dma_addr from TTM, one immediate way
that comes to my mind is:

 1). Provide a new function in the ttm->be->func that would be called 'get_dma' of:
     (int)( *get_dma)(struct list_head *pages, unsigned page_count, dma_addr_t *dma_address)

     which would call the TTM DMA to search the internal list and find 'pages*'
     (which were just a microsecond ago allocated by calling ttm->be->func->get_pages)
     and stick the bus address on the 'dma_address' array.

 2). The radeon|nouveau driver would both call this if they decided to use the
     TTM DMA API. They would need to provide the newly allocated dma_address for this
     call.
 3). Not sure how to wrap this in macros though - it looks as if both drivers will
     be riddled with 'if (ttm->be->func->get_pages) { private->dma_addr=kzalloc(...) } else {}'.
     But that is more an implemention problem..

.. While this idea looks correct, I am struck that it looks like it is breaking the layering
of APIs, where the driver is reaching behind the TTM API and calling this extra function?

Another idea is to transform the 'struct dma_addr *dma_addr' to a 'void *override_p' in 
the 'struct ttm_tt'. That means still keeping the TTM API layers seperate, and "passing"
the array of DMA address through the 'override_p' array (which would be allocated by TTM DMA
code). Something along these lines (not tested):


I like this more, but I haven't actually tested it so not sure if it works right?

diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
index e0d4474..8760a04 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -23,7 +23,7 @@ struct nouveau_sgdma_be {
 static int
 nouveau_sgdma_populate(struct ttm_backend *be, unsigned long num_pages,
 		       struct page **pages, struct page *dummy_read_page,
-		       dma_addr_t *dma_addrs)
+		       void *override_p)
 {
 	struct nouveau_sgdma_be *nvbe = (struct nouveau_sgdma_be *)be;
 	struct drm_device *dev = nvbe->dev;
@@ -43,9 +43,9 @@ nouveau_sgdma_populate(struct ttm_backend *be, unsigned long num_pages,
 
 	nvbe->nr_pages = 0;
 	while (num_pages--) {
-		if (dma_addrs[nvbe->nr_pages] != 0) {
-			nvbe->pages[nvbe->nr_pages] =
-					dma_addrs[nvbe->nr_pages];
+		dma_addr_t *ttm_dma = (dma_addr_t *)override_p;
+		if (ttm_dma && ttm_dma[nvbe->nr_pages] != 0) {
+			nvbe->pages[nvbe->nr_pages] = ttm_dma[nvbe->nr_pages];
 		 	nvbe->ttm_alloced[nvbe->nr_pages] = true;
 		} else {
 			nvbe->pages[nvbe->nr_pages] =
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index 068ba09..dc700f4 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -181,7 +181,7 @@ int radeon_gart_bind(struct radeon_device *rdev, unsigned offset,
 	p = t / (PAGE_SIZE / RADEON_GPU_PAGE_SIZE);
 
 	for (i = 0; i < pages; i++, p++) {
-		if (dma_addr[i] != 0) {
+		if (dma_addr && dma_addr[i] != 0) {
 			rdev->gart.ttm_alloced[p] = true;
 			rdev->gart.pages_addr[p] = dma_addr[i];
 		} else {
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 2e7419f..690545d 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -661,7 +661,7 @@ struct radeon_ttm_backend {
 	unsigned long			num_pages;
 	struct page			**pages;
 	struct page			*dummy_read_page;
-	dma_addr_t			*dma_addrs;
+	dma_addr_t			*dma_addrs; /* Can be NULL */
 	bool				populated;
 	bool				bound;
 	unsigned			offset;
@@ -671,13 +671,13 @@ static int radeon_ttm_backend_populate(struct ttm_backend *backend,
 				       unsigned long num_pages,
 				       struct page **pages,
 				       struct page *dummy_read_page,
-				       dma_addr_t *dma_addrs)
+				       void *override_p)
 {
 	struct radeon_ttm_backend *gtt;
 
 	gtt = container_of(backend, struct radeon_ttm_backend, backend);
 	gtt->pages = pages;
-	gtt->dma_addrs = dma_addrs;
+	gtt->dma_addrs = (dma_addr_t *)override_p;
 	gtt->num_pages = num_pages;
 	gtt->dummy_read_page = dummy_read_page;
 	gtt->populated = true;
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index 360afb3..458727a 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -662,8 +662,7 @@ out:
 
 /* Put all pages in pages list to correct pool to wait for reuse */
 static void __ttm_put_pages(struct list_head *pages, unsigned page_count,
-			    int flags, enum ttm_caching_state cstate,
-			    dma_addr_t *dma_address)
+			    int flags, enum ttm_caching_state cstate)
 {
 	unsigned long irq_flags;
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
@@ -707,8 +706,7 @@ static void __ttm_put_pages(struct list_head *pages, unsigned page_count,
  * cached pages.
  */
 static int __ttm_get_pages(struct list_head *pages, int flags,
-			   enum ttm_caching_state cstate, unsigned count,
-			   dma_addr_t *dma_address)
+			   enum ttm_caching_state cstate, unsigned count)
 {
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
 	struct page *p = NULL;
@@ -766,7 +764,7 @@ static int __ttm_get_pages(struct list_head *pages, int flags,
 			printk(KERN_ERR TTM_PFX
 			       "Failed to allocate extra pages "
 			       "for large request.");
-			__ttm_put_pages(pages, 0, flags, cstate, NULL);
+			__ttm_put_pages(pages, 0, flags, cstate);
 			return r;
 		}
 	}
@@ -859,19 +857,19 @@ int ttm_page_alloc_debugfs(struct seq_file *m, void *data)
 }
 EXPORT_SYMBOL(ttm_page_alloc_debugfs);
 int ttm_get_pages(struct ttm_tt *ttm, struct list_head *pages,
-		  unsigned count, dma_addr_t *dma_address)
+		  unsigned count, int index)
 {
 	if (ttm->be && ttm->be->func && ttm->be->func->get_pages)
-		return ttm->be->func->get_pages(ttm, pages, count, dma_address);
+		return ttm->be->func->get_pages(ttm, pages, count, index);
 	return __ttm_get_pages(pages, ttm->page_flags, ttm->caching_state,
-				count, dma_address);
+				count);
 }
 void ttm_put_pages(struct ttm_tt *ttm, struct list_head *pages,
-		   unsigned page_count, dma_addr_t *dma_address)
+		   unsigned page_count, int index)
 {
 	if (ttm->be && ttm->be->func && ttm->be->func->put_pages)
-		ttm->be->func->put_pages(ttm, pages, page_count, dma_address);
+		ttm->be->func->put_pages(ttm, pages, page_count, index);
 	else
 		__ttm_put_pages(pages, page_count, ttm->page_flags,
-				ttm->caching_state, dma_address);
+				ttm->caching_state);
 }
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index a5be62e..08e182f 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -45,6 +45,7 @@
 #include <linux/atomic.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <drm/drm_mem_util.h>
 #include "ttm/ttm_bo_driver.h"
 #include "ttm/ttm_page_alloc.h"
 #ifdef TTM_HAS_AGP
@@ -1097,7 +1098,7 @@ out:
  * cached pages. On failure will hold the negative return value (-ENOMEM, etc).
  */
 int ttm_dma_get_pages(struct ttm_tt *ttm, struct list_head *pages,
-		      unsigned count, dma_addr_t *dma_address)
+		      unsigned count, int idx)
 
 {
 	int r = -ENOMEM;
@@ -1105,6 +1106,11 @@ int ttm_dma_get_pages(struct ttm_tt *ttm, struct list_head *pages,
 	gfp_t gfp_flags;
 	enum pool_type type;
 	struct device *dev = ttm->be->dev;
+	dma_addr_t *dma_address;
+
+	/* We _MUST_ have a proper index value. */
+	if (WARN_ON(idx < 0));
+		return -EINVAL;
 
 	type = ttm_to_type(ttm->page_flags, ttm->caching_state);
 
@@ -1129,6 +1135,7 @@ int ttm_dma_get_pages(struct ttm_tt *ttm, struct list_head *pages,
 			cstate);
 	}
 #endif
+ 	dma_address = &((dma_addr_t *)ttm->override_p)[idx];
 	/* Take pages out of a pool (if applicable) */
 	r = ttm_dma_pool_get_pages(pool, pages, dma_address, count);
 	/* clear the pages coming from the pool if requested */
@@ -1201,7 +1208,7 @@ static int ttm_dma_pool_get_num_unused_pages(void)
 
 /* Put all pages in pages list to correct pool to wait for reuse */
 void ttm_dma_put_pages(struct ttm_tt *ttm, struct list_head *pages,
-		       unsigned page_count, dma_addr_t *dma_address)
+		       unsigned page_count, int idx)
 {
 	struct dma_pool *pool;
 	enum pool_type type;
@@ -1230,9 +1237,12 @@ void ttm_dma_put_pages(struct ttm_tt *ttm, struct list_head *pages,
 
 	count = ttm_dma_put_pages_in_pool(pool, pages, page_count, is_cached);
 
-	for (i = 0; i < count; i++)
-		dma_address[i] = 0;
-
+	/* Optional. */
+	if (idx >= 0) {
+ 		dma_addr_t *dma_address = &((dma_addr_t *)ttm->override_p)[idx];
+		for (i = 0; i < count; i++)
+			dma_address[i] = 0;
+	}
 	spin_lock_irqsave(&pool->lock, irq_flags);
 	pool->npages_in_use -= count;
 	if (is_cached)
@@ -1386,11 +1396,27 @@ int ttm_dma_page_alloc_debugfs(struct seq_file *m, void *data)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ttm_dma_page_alloc_debugfs);
+
+static int ttm_dma_alloc_priv(struct ttm_tt *ttm)
+{
+	ttm->override_p = drm_calloc_large(ttm->num_pages, sizeof(dma_addr_t *));
+	if (WARN_ON(!ttm->override_p))
+		return -ENOMEM;
+	return 0;
+
+}
+static void ttm_dma_free_priv(struct ttm_tt *ttm)
+{
+	drm_free_large(ttm->override_p);
+	ttm->override_p = NULL;
+}
 bool ttm_dma_override(struct ttm_backend_func *be)
 {
 	if (swiotlb_nr_tbl() && be && !ttm_dma_disable) {
 		be->get_pages = &ttm_dma_get_pages;
 		be->put_pages = &ttm_dma_put_pages;
+		be->alloc_priv = &ttm_dma_alloc_priv;
+		be->free_priv = &ttm_dma_free_priv;
 		return true;
 	}
 	return false;
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 31ae359..0f0d57f 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -50,16 +50,16 @@ static int ttm_tt_swapin(struct ttm_tt *ttm);
 static void ttm_tt_alloc_page_directory(struct ttm_tt *ttm)
 {
 	ttm->pages = drm_calloc_large(ttm->num_pages, sizeof(*ttm->pages));
-	ttm->dma_address = drm_calloc_large(ttm->num_pages,
-					    sizeof(*ttm->dma_address));
+	if (ttm->be && ttm->be->func && ttm->be->func->alloc_priv)
+		ttm->be->func->alloc_priv(ttm);
 }
 
 static void ttm_tt_free_page_directory(struct ttm_tt *ttm)
 {
 	drm_free_large(ttm->pages);
 	ttm->pages = NULL;
-	drm_free_large(ttm->dma_address);
-	ttm->dma_address = NULL;
+	if (ttm->be && ttm->be->func && ttm->be->func->free_priv)
+		ttm->be->func->free_priv(ttm);
 }
 
 static void ttm_tt_free_user_pages(struct ttm_tt *ttm)
@@ -110,7 +110,7 @@ static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
 
 		INIT_LIST_HEAD(&h);
 
-		ret = ttm_get_pages(ttm, &h, 1, &ttm->dma_address[index]);
+		ret = ttm_get_pages(ttm, &h, 1, index);
 
 		if (ret != 0)
 			return NULL;
@@ -169,7 +169,7 @@ int ttm_tt_populate(struct ttm_tt *ttm)
 	}
 
 	be->func->populate(be, ttm->num_pages, ttm->pages,
-			   ttm->dummy_read_page, ttm->dma_address);
+			   ttm->dummy_read_page, ttm->override_p);
 	ttm->state = tt_unbound;
 	return 0;
 }
@@ -303,7 +303,7 @@ static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm, bool call_clear)
 			count++;
 		}
 	}
-	ttm_put_pages(ttm, &h, count, ttm->dma_address);
+	ttm_put_pages(ttm, &h, count, 0 /* start at zero and go up to count */);
 	ttm->state = tt_unpopulated;
 	ttm->first_himem_page = ttm->num_pages;
 	ttm->last_lomem_page = -1;
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 1826c3b..771697a 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -58,7 +58,7 @@ struct ttm_backend_func {
 	int (*populate) (struct ttm_backend *backend,
 			 unsigned long num_pages, struct page **pages,
 			 struct page *dummy_read_page,
-			 dma_addr_t *dma_addrs);
+			 void *override_p);
 	/**
 	 * struct ttm_backend_func member clear
 	 *
@@ -109,10 +109,11 @@ struct ttm_backend_func {
 	 *
 	 * @ttm: ttm which contains flags for page allocation and caching state.
 	 * @pages: head of empty linked list where pages are filled.
-	 * @dma_address: The DMA (bus) address of pages
+	 * @idx: The current index in ttm->pages[] array. Negative means
+	 * don't assume ttm->pages[idx] order matches the order in *pages.
 	 */
 	int (*get_pages) (struct ttm_tt *ttm, struct list_head *pages,
-			  unsigned count, dma_addr_t *dma_address);
+			  unsigned count, int idx);
 
 	/**
 	 * ttm_put_pages override. The backend can override the default
@@ -124,10 +125,17 @@ struct ttm_backend_func {
 	 * @pages: list of pages to free.
 	 * @page_count: number of pages in the list. Zero can be passed for
 	 * unknown count.
-	 * @dma_address: The DMA (bus) address of pages
+	 * @idx: The current index in the ttm->pages[] array. Negative means
+	 * don't assume ttm->pages[idx] order matches the order in *pages.
 	 */
 	void (*put_pages) (struct ttm_tt *ttm, struct list_head *pages,
-			   unsigned page_count, dma_addr_t *dma_address);
+			   unsigned page_count, int idx);
+
+	/**
+	 * TODO: Flesh this out.
+	 */
+	int (*alloc_priv) (struct ttm_tt *ttm);
+	void (*free_priv) (struct ttm_tt *ttm);
 };
 
 /**
@@ -207,7 +215,7 @@ struct ttm_tt {
 		tt_unbound,
 		tt_unpopulated,
 	} state;
-	dma_addr_t *dma_address;
+	void *override_p;
 };
 
 #define TTM_MEMTYPE_FLAG_FIXED         (1 << 0)	/* Fixed (on-card) PCI memory */
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index daf5db6..31e6079 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -68,12 +68,12 @@ static inline int ttm_dma_page_alloc_debugfs(struct seq_file *m, void *data)
  * @ttm: ttm which contains flags for page allocation and caching state.
  * @pages: heado of empty linked list where pages are filled.
  * @count: number of pages to allocate.
- * @dma_address: The DMA (bus) address of pages - (by default zero).
+ * @idx: The current index in ttm->pages[idx]. Negative means ignore.
  */
 int ttm_get_pages(struct ttm_tt *ttm,
 		  struct list_head *pages,
 		  unsigned count,
-		  dma_addr_t *dma_address);
+		  int idx);
 /**
  * Put linked list of pages to pool.
  *
@@ -81,12 +81,12 @@ int ttm_get_pages(struct ttm_tt *ttm,
  * @pages: list of pages to free.
  * @page_count: number of pages in the list. Zero can be passed for unknown
  * count.
- * @dma_address: The DMA (bus) address of pages (by default zero).
+ * @idx: The current index in ttm->pages[idx]. Negative means ignore.
  */
 void ttm_put_pages(struct ttm_tt *ttm,
 		   struct list_head *pages,
 		   unsigned page_count,
-		   dma_addr_t *dma_address);
+		   int idx);
 /**
  * Initialize pool allocator.
  */
