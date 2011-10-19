Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1JSWV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:21:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:57227 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab1JSWUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:20:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        thellstrom@vmware.com, thomas@shipmail.org, airlied@redhat.com
Cc: xen-devel@lists.xensource.com, j.glisse@redhat.com, bskeggs@redhat.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 09/11] ttm: Add 'no_dma' parameter to turn the TTM DMA pool off during runtime.
Date: Wed, 19 Oct 2011 18:19:30 -0400
Message-Id: <1319062772-2793-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020209.4E9F4D09.0108:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TTM DMA only gets turned on when the SWIOTLB is enabled - but
we might also want to turn it off when SWIOTLB is on to
use the non-DMA TTM pool code.

In the future this parameter can be removed.

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
index d6d8240..a5be62e 100644
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
@@ -1384,7 +1388,7 @@ int ttm_dma_page_alloc_debugfs(struct seq_file *m, void *data)
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

