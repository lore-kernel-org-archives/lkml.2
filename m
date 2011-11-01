Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab1KATDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:03:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31930 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab1KATCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:02:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thellstrom@vmware.com, thomas@shipmail.org,
        airlied@redhat.com, jglisse@redhat.com, bskeggs@redhat.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 06/11] ttm/driver: Expand ttm_backend_func to include two overrides for TTM page pool.
Date: Tue,  1 Nov 2011 14:47:27 -0400
Message-Id: <1320173252-2812-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
References: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4EB04235.00C8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two overrides will be choosen by the backends whether they
want to use a different TTM page pool than the default.

If the backend does not choose a new override, the default one
will be used.

Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |   10 +++++++---
 include/drm/ttm/ttm_bo_driver.h      |   31 +++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index 24c0340..360afb3 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -861,13 +861,17 @@ EXPORT_SYMBOL(ttm_page_alloc_debugfs);
 int ttm_get_pages(struct ttm_tt *ttm, struct list_head *pages,
 		  unsigned count, dma_addr_t *dma_address)
 {
+	if (ttm->be && ttm->be->func && ttm->be->func->get_pages)
+		return ttm->be->func->get_pages(ttm, pages, count, dma_address);
 	return __ttm_get_pages(pages, ttm->page_flags, ttm->caching_state,
 				count, dma_address);
 }
-{
 void ttm_put_pages(struct ttm_tt *ttm, struct list_head *pages,
 		   unsigned page_count, dma_addr_t *dma_address)
 {
-	__ttm_put_pages(pages, page_count, ttm->page_flags, ttm->caching_state,
-			dma_address);
+	if (ttm->be && ttm->be->func && ttm->be->func->put_pages)
+		ttm->be->func->put_pages(ttm, pages, page_count, dma_address);
+	else
+		__ttm_put_pages(pages, page_count, ttm->page_flags,
+				ttm->caching_state, dma_address);
 }
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 09af2d7..1826c3b 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -100,6 +100,34 @@ struct ttm_backend_func {
 	 * Destroy the backend.
 	 */
 	void (*destroy) (struct ttm_backend *backend);
+
+	/**
+	 * ttm_get_pages override. The backend can override the default
+	 * TTM page pool code with a different one.
+	 *
+	 * Get count number of pages from pool to pages list.
+	 *
+	 * @ttm: ttm which contains flags for page allocation and caching state.
+	 * @pages: head of empty linked list where pages are filled.
+	 * @dma_address: The DMA (bus) address of pages
+	 */
+	int (*get_pages) (struct ttm_tt *ttm, struct list_head *pages,
+			  unsigned count, dma_addr_t *dma_address);
+
+	/**
+	 * ttm_put_pages override. The backend can override the default
+	 * TTM page pool code with a different implementation.
+	 *
+	 * Put linked list of pages to pool.
+	 *
+	 * @ttm: ttm which contains flags for page allocation and caching state.
+	 * @pages: list of pages to free.
+	 * @page_count: number of pages in the list. Zero can be passed for
+	 * unknown count.
+	 * @dma_address: The DMA (bus) address of pages
+	 */
+	void (*put_pages) (struct ttm_tt *ttm, struct list_head *pages,
+			   unsigned page_count, dma_addr_t *dma_address);
 };
 
 /**
@@ -109,6 +137,8 @@ struct ttm_backend_func {
  * @flags: For driver use.
  * @func: Pointer to a struct ttm_backend_func that describes
  * the backend methods.
+ * @dev: Pointer to a struct device which can be used by the TTM
+ *  [get|put)_pages overrides in 'struct ttm_backend_func'.
  *
  */
 
@@ -116,6 +146,7 @@ struct ttm_backend {
 	struct ttm_bo_device *bdev;
 	uint32_t flags;
 	struct ttm_backend_func *func;
+	struct device *dev;
 };
 
 #define TTM_PAGE_FLAG_USER            (1 << 1)
-- 
1.7.6.4

