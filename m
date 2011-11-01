Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1KATEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:04:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28355 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1KATCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:02:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thellstrom@vmware.com, thomas@shipmail.org,
        airlied@redhat.com, jglisse@redhat.com, bskeggs@redhat.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 04/11] ttm: Wrap ttm_[put|get]_pages and extract GFP_* and caching states from 'struct ttm_tt'
Date: Tue,  1 Nov 2011 14:47:25 -0400
Message-Id: <1320173252-2812-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
References: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4EB04232.008D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of passing the 'int flags' and 'enum caching_state caching_state'
as parameters, pass in the 'struct ttm_tt' and let the ttm_[put|get]_pages
extract those parameters.

We also wrap the ttm_[put|get]_pages so that we can extract those two
parameters from the 'struct ttm_tt'. The reason for wrapping instead
of just changing the two functions declerations outright is to
support the next set of patches which will provide an
override mechanism for 'ttm_[put|get]_pages' functions.

Temporarily we put in a function declerations for the __ttm_put_pages,
which later on we will remove (by moving the __ttm_put_pages).

Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |   29 +++++++++++++++++++++++------
 drivers/gpu/drm/ttm/ttm_tt.c         |    6 ++----
 include/drm/ttm/ttm_page_alloc.h     |   16 ++++++----------
 3 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index d948575..c30d62b 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -660,13 +660,16 @@ out:
 	return count;
 }
 
+static void __ttm_put_pages(struct list_head *pages, unsigned page_count,
+			    int flags, enum ttm_caching_state cstate,
+			    dma_addr_t *dma_address);
 /*
  * On success pages list will hold count number of correctly
  * cached pages.
  */
-int ttm_get_pages(struct list_head *pages, int flags,
-		  enum ttm_caching_state cstate, unsigned count,
-		  dma_addr_t *dma_address)
+static int __ttm_get_pages(struct list_head *pages, int flags,
+			   enum ttm_caching_state cstate, unsigned count,
+			   dma_addr_t *dma_address)
 {
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
 	struct page *p = NULL;
@@ -724,7 +727,7 @@ int ttm_get_pages(struct list_head *pages, int flags,
 			printk(KERN_ERR TTM_PFX
 			       "Failed to allocate extra pages "
 			       "for large request.");
-			ttm_put_pages(pages, 0, flags, cstate, NULL);
+			__ttm_put_pages(pages, 0, flags, cstate, NULL);
 			return r;
 		}
 	}
@@ -734,8 +737,9 @@ int ttm_get_pages(struct list_head *pages, int flags,
 }
 
 /* Put all pages in pages list to correct pool to wait for reuse */
-void ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
-		   enum ttm_caching_state cstate, dma_addr_t *dma_address)
+static void __ttm_put_pages(struct list_head *pages, unsigned page_count,
+			    int flags, enum ttm_caching_state cstate,
+			    dma_addr_t *dma_address)
 {
 	unsigned long irq_flags;
 	struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
@@ -857,3 +861,16 @@ int ttm_page_alloc_debugfs(struct seq_file *m, void *data)
 	return 0;
 }
 EXPORT_SYMBOL(ttm_page_alloc_debugfs);
+int ttm_get_pages(struct ttm_tt *ttm, struct list_head *pages,
+		  unsigned count, dma_addr_t *dma_address)
+{
+	return __ttm_get_pages(pages, ttm->page_flags, ttm->caching_state,
+				count, dma_address);
+}
+{
+void ttm_put_pages(struct ttm_tt *ttm, struct list_head *pages,
+		   unsigned page_count, dma_addr_t *dma_address)
+{
+	__ttm_put_pages(pages, page_count, ttm->page_flags, ttm->caching_state,
+			dma_address);
+}
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 58c271e..76c982f 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -110,8 +110,7 @@ static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
 
 		INIT_LIST_HEAD(&h);
 
-		ret = ttm_get_pages(&h, ttm->page_flags, ttm->caching_state, 1,
-				    &ttm->dma_address[index]);
+		ret = ttm_get_pages(ttm, &h, 1, &ttm->dma_address[index]);
 
 		if (ret != 0)
 			return NULL;
@@ -304,8 +303,7 @@ static void ttm_tt_free_alloced_pages(struct ttm_tt *ttm)
 			count++;
 		}
 	}
-	ttm_put_pages(&h, count, ttm->page_flags, ttm->caching_state,
-		      ttm->dma_address);
+	ttm_put_pages(ttm, &h, count, ttm->dma_address);
 	ttm->state = tt_unpopulated;
 	ttm->first_himem_page = ttm->num_pages;
 	ttm->last_lomem_page = -1;
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index 0017b17..0aaac39 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -32,31 +32,27 @@
 /**
  * Get count number of pages from pool to pages list.
  *
+ * @ttm: ttm which contains flags for page allocation and caching state.
  * @pages: heado of empty linked list where pages are filled.
- * @flags: ttm flags for page allocation.
- * @cstate: ttm caching state for the page.
  * @count: number of pages to allocate.
  * @dma_address: The DMA (bus) address of pages - (by default zero).
  */
-int ttm_get_pages(struct list_head *pages,
-		  int flags,
-		  enum ttm_caching_state cstate,
+int ttm_get_pages(struct ttm_tt *ttm,
+		  struct list_head *pages,
 		  unsigned count,
 		  dma_addr_t *dma_address);
 /**
  * Put linked list of pages to pool.
  *
+ * @ttm: ttm which contains flags for page allocation and caching state.
  * @pages: list of pages to free.
  * @page_count: number of pages in the list. Zero can be passed for unknown
  * count.
- * @flags: ttm flags for page allocation.
- * @cstate: ttm caching state.
  * @dma_address: The DMA (bus) address of pages (by default zero).
  */
-void ttm_put_pages(struct list_head *pages,
+void ttm_put_pages(struct ttm_tt *ttm,
+		   struct list_head *pages,
 		   unsigned page_count,
-		   int flags,
-		   enum ttm_caching_state cstate,
 		   dma_addr_t *dma_address);
 /**
  * Initialize pool allocator.
-- 
1.7.6.4

