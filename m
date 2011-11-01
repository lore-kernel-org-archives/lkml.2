Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1KATCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:02:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31677 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1KATCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:02:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, thellstrom@vmware.com, thomas@shipmail.org,
        airlied@redhat.com, jglisse@redhat.com, bskeggs@redhat.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 09/11] ttm: Add 'no_dma' parameter to turn the TTM DMA pool off during runtime.
Date: Tue,  1 Nov 2011 14:47:30 -0400
Message-Id: <1320173252-2812-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
References: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4EB04233.00C1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TTM DMA only gets turned on when the SWIOTLB is enabled - but
we might also want to turn it off when SWIOTLB is on to
use the non-DMA TTM pool code.

In the future this parameter can be removed.

Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/ttm/ttm_memory.c         |    7 +++++--
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    6 +++++-
 include/drm/ttm/ttm_page_alloc.h         |    2 ++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
index 6d24fe2..f883a28 100644
--- a/drivers/gpu/drm/ttm/ttm_memory.c
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -395,7 +395,9 @@ int ttm_mem_global_init(struct ttm_mem_global *glob)
 		       zone->name, (unsigned long long) zone->max_mem >> 10);
 	}
 	ttm_page_alloc_init(glob, glob->zone_kernel->max_mem/(2*PAGE_SIZE));
-	ttm_dma_page_alloc_init(glob, glob->zone_kernel->max_mem/(2*PAGE_SIZE));
+	if (!ttm_dma_disable)
+		ttm_dma_page_alloc_init(glob, glob->zone_kernel->max_mem /
+					(2*PAGE_SIZE));
 	return 0;
 out_no_zone:
 	ttm_mem_global_release(glob);
@@ -411,7 +413,8 @@ void ttm_mem_global_release(struct ttm_mem_global *glob)
 	/* let the page allocator first stop the shrink work. */
 	ttm_page_alloc_fini();
 
-	ttm_dma_page_alloc_fini();
+	if (!ttm_dma_disable)
+		ttm_dma_page_alloc_fini();
 	flush_workqueue(glob->swap_queue);
 	destroy_workqueue(glob->swap_queue);
 	glob->swap_queue = NULL;
diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
index 5a2d362..cfc8d9f 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
@@ -51,6 +51,10 @@
 #include <asm/agp.h>
 #endif
 
+int __read_mostly ttm_dma_disable;
+MODULE_PARM_DESC(no_dma, "Disable TTM DMA pool");
+module_param_named(no_dma, ttm_dma_disable, bool, S_IRUGO);
+
 #define NUM_PAGES_TO_ALLOC		(PAGE_SIZE/sizeof(struct page *))
 #define SMALL_ALLOCATION		16
 #define FREE_ALL_PAGES			(~0U)
@@ -1395,7 +1399,7 @@ int ttm_dma_page_alloc_debugfs(struct seq_file *m, void *data)
 EXPORT_SYMBOL_GPL(ttm_dma_page_alloc_debugfs);
 bool ttm_dma_override(struct ttm_backend_func *be)
 {
-	if (swiotlb_nr_tbl() && be) {
+	if (swiotlb_nr_tbl() && be && !ttm_dma_disable) {
 		be->get_pages = &ttm_dma_get_pages;
 		be->put_pages = &ttm_dma_put_pages;
 		return true;
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index 9c52fb7..daf5db6 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -32,6 +32,7 @@
 #ifdef CONFIG_SWIOTLB
 extern bool ttm_dma_override(struct ttm_backend_func *be);
 
+extern int ttm_dma_disable;
 /**
  * Initialize pool allocator.
  */
@@ -45,6 +46,7 @@ void ttm_dma_page_alloc_fini(void);
  */
 extern int ttm_dma_page_alloc_debugfs(struct seq_file *m, void *data);
 #else
+#define ttm_dma_disable (1)
 static inline bool ttm_dma_override(struct ttm_backend_func *be)
 {
 	return false;
-- 
1.7.6.4

