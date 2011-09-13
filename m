Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1IMOOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:14:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25825 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab1IMOOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:14:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: thellstrom@vmware.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, dri-devel@lists.freedesktop.org,
        thomas@shipmail.org
Cc: Pekka Paalanen <pq@iki.fi>, bskeggs@redhat.com, j.glisse@redhat.com,
        airlied@redhat.com, airlied@linux.ie, alexdeucher@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/7] ttm: Introduce ttm_page_alloc_func structure.
Date: Tue, 13 Sep 2011 10:12:45 -0400
Message-Id: <1315923170-25568-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315923170-25568-1-git-send-email-konrad.wilk@oracle.com>
References: <1315923170-25568-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4E6F64F6.0078,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which has the function members for all of the current page pool
operations defined. The old calls (ttm_put_pages, ttm_get_pages, etc)
are plumbed through little functions which lookup in the ttm_page_alloc_func
the appropiate implementation and call it.

There is currently only one page pool code so the default registration
goes to 'ttm_page_alloc_default'. The subsequent patch
"ttm: Provide a DMA aware TTM page pool code." introduces the one
to be used when the SWIOTLB code is turned on (that implementation
is a union of the default TTM pool code with the DMA pool code).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_memory.c     |    3 ++
 drivers/gpu/drm/ttm/ttm_page_alloc.c |   58 ++++++++++++++++++++++++++++----
 include/drm/ttm/ttm_page_alloc.h     |   60 ++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
index e70ddd8..c7d97a5 100644
--- a/drivers/gpu/drm/ttm/ttm_memory.c
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -356,6 +356,8 @@ static int ttm_mem_init_dma32_zone(struct ttm_mem_global *glob,
 }
 #endif
 
+struct ttm_page_alloc_func *ttm_page_alloc;
+
 int ttm_mem_global_init(struct ttm_mem_global *glob)
 {
 	struct sysinfo si;
@@ -394,6 +396,7 @@ int ttm_mem_global_init(struct ttm_mem_global *glob)
 		       "Zone %7s: Available graphics memory: %llu kiB.\n",
 		       zone->name, (unsigned long long) zone->max_mem >> 10);
 	}
+	ttm_page_alloc = &ttm_page_alloc_default;
 	ttm_page_alloc_init(glob, glob->zone_kernel->max_mem/(2*PAGE_SIZE));
 	return 0;
 out_no_zone:
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index d948575..6a888f8 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -664,9 +664,9 @@ out:
  * On success pages list will hold count number of correctly
  * cached pages.
  */
-int ttm_get_pages(struct list_head *pages, int flags,
-		  enum ttm_caching_state cstate, unsigned count,
-		  dma_addr_t *dma_address)
+int __ttm_get_pages(struct list_head *pages, int flags,
+		    enum ttm_caching_state cstate, unsigned count,
+		    dma_addr_t *dma_address)
 {
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
 	struct page *p = NULL;
@@ -734,8 +734,8 @@ int ttm_get_pages(struct list_head *pages, int flags,
 }
 
 /* Put all pages in pages list to correct pool to wait for reuse */
-void ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
-		   enum ttm_caching_state cstate, dma_addr_t *dma_address)
+void __ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
+		     enum ttm_caching_state cstate, dma_addr_t *dma_address)
 {
 	unsigned long irq_flags;
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
@@ -785,7 +785,7 @@ static void ttm_page_pool_init_locked(struct ttm_page_pool *pool, int flags,
 	pool->name = name;
 }
 
-int ttm_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
+int __ttm_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
 {
 	int ret;
 
@@ -822,7 +822,7 @@ int ttm_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
 	return 0;
 }
 
-void ttm_page_alloc_fini(void)
+void __ttm_page_alloc_fini(void)
 {
 	int i;
 
@@ -836,7 +836,7 @@ void ttm_page_alloc_fini(void)
 	_manager = NULL;
 }
 
-int ttm_page_alloc_debugfs(struct seq_file *m, void *data)
+int __ttm_page_alloc_debugfs(struct seq_file *m, void *data)
 {
 	struct ttm_page_pool *p;
 	unsigned i;
@@ -856,4 +856,46 @@ int ttm_page_alloc_debugfs(struct seq_file *m, void *data)
 	}
 	return 0;
 }
+
+struct ttm_page_alloc_func ttm_page_alloc_default = {
+	.get_pages	= __ttm_get_pages,
+	.put_pages	= __ttm_put_pages,
+	.alloc_init	= __ttm_page_alloc_init,
+	.alloc_fini	= __ttm_page_alloc_fini,
+	.debugfs	= __ttm_page_alloc_debugfs,
+};
+
+int ttm_get_pages(struct list_head *pages, int flags,
+		  enum ttm_caching_state cstate, unsigned count,
+		  dma_addr_t *dma_address)
+{
+	if (ttm_page_alloc && ttm_page_alloc->get_pages)
+		return ttm_page_alloc->get_pages(pages, flags, cstate, count,
+						 dma_address);
+	return -1;
+}
+void ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
+		   enum ttm_caching_state cstate, dma_addr_t *dma_address)
+{
+	if (ttm_page_alloc && ttm_page_alloc->put_pages)
+		ttm_page_alloc->put_pages(pages, page_count, flags, cstate,
+					  dma_address);
+}
+int ttm_page_alloc_init(struct ttm_mem_global *glob, unsigned max_pages)
+{
+	if (ttm_page_alloc && ttm_page_alloc->alloc_init)
+		return ttm_page_alloc->alloc_init(glob, max_pages);
+	return -1;
+}
+void ttm_page_alloc_fini(void)
+{
+	if (ttm_page_alloc && ttm_page_alloc->alloc_fini)
+		ttm_page_alloc->alloc_fini();
+}
+int ttm_page_alloc_debugfs(struct seq_file *m, void *data)
+{
+	if (ttm_page_alloc && ttm_page_alloc->debugfs)
+		return ttm_page_alloc->debugfs(m, data);
+	return -1;
+}
 EXPORT_SYMBOL(ttm_page_alloc_debugfs);
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index 0017b17..6e8d73a 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -29,6 +29,66 @@
 #include "ttm_bo_driver.h"
 #include "ttm_memory.h"
 
+struct ttm_page_alloc_func {
+	/**
+	 * struct ttm_page_alloc_func member get_pages
+	 * Get count number of pages from pool to pages list.
+	 *
+	 * @pages: head of empty linked list where pages are filled.
+	 * @flags: ttm flags for page allocation.
+	 * @cstate: ttm caching state for the page.
+	 * @count: number of pages to allocate.
+	 * @dma_address: The DMA (bus) address of pages (by default zero).
+	 */
+	int (*get_pages) (struct list_head *pages,
+			  int flags,
+			  enum ttm_caching_state cstate,
+			  unsigned count,
+			  dma_addr_t *dma_address);
+	/**
+	 * struct ttm_page_alloc_func member put_pages.
+	 *
+	 * Put linked list of pages to pool.
+	 *
+	 * @pages: list of pages to free.
+	 * @page_count: number of pages in the list. Zero can be passed for
+	 * unknown count.
+	 * @flags: ttm flags for page allocation.
+	 * @cstate: ttm caching state.
+	 * @dma_address: The DMA (bus) address of pages (by default zero).
+	 */
+	void (*put_pages)(struct list_head *pages,
+			  unsigned page_count,
+			  int flags,
+			  enum ttm_caching_state cstate,
+			  dma_addr_t *dma_address);
+	/**
+	 * struct ttm_page_alloc_func member alloc_init.
+	 *
+	 * Initialize pool allocator.
+	 */
+	int (*alloc_init)(struct ttm_mem_global *glob, unsigned max_pages);
+
+	/**
+	 * struct ttm_page_alloc_func member alloc_fini.
+	 *
+	 * Free pool allocator.
+	 */
+	void (*alloc_fini)(void);
+
+	/**
+	 * struct ttm_page_alloc_func member debugfs.
+	 *
+	 * Output the state of pools to debugfs file
+	 */
+	int (*debugfs)(struct seq_file *m, void *data);
+};
+
+extern struct ttm_page_alloc_func *ttm_page_alloc;
+
+/* Defined in ttm_page_alloc.c */
+extern struct ttm_page_alloc_func ttm_page_alloc_default;
+
 /**
  * Get count number of pages from pool to pages list.
  *
-- 
1.7.4.1

