Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0LGCII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:08:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45959 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab0LGCIG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 21:08:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/7] ttm: Expand (*populate) to support an array of DMA addresses.
Date: Mon,  6 Dec 2010 21:07:22 -0500
Message-Id: <1291687646-31994-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
References: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We pass in the array of ttm pages to be populated in the GART/MM
of the card (or AGP). Patch titled: "ttm: Utilize the dma_addr_t array
for pages that are to in DMA32 pool." uses the DMA API to make those
pages have a proper DMA addresses (in the situation where
page_to_phys or virt_to_phys do not give use the DMA (bus) address).

Since we are using the DMA API on those pages, we should pass in the
DMA address to this function so it can save it in its proper fields
(later patches use it).

This fixes the issues on AGP hardware with Xen where when
we call (*populate), the code ends up calling agp_allocate_memory
with AGP_USER_MEMORY, which allocates a GART but no pages.
We then hook up the pages we want the GART to know about, but we
do not fill the DMA address. This allows us to do so.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c |    3 ++-
 drivers/gpu/drm/radeon/radeon_ttm.c     |    3 ++-
 drivers/gpu/drm/ttm/ttm_agp_backend.c   |    3 ++-
 drivers/gpu/drm/ttm/ttm_tt.c            |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c  |    3 ++-
 include/drm/ttm/ttm_bo_driver.h         |    4 +++-
 6 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
index 288baca..edc140a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -20,7 +20,8 @@ struct nouveau_sgdma_be {
 
 static int
 nouveau_sgdma_populate(struct ttm_backend *be, unsigned long num_pages,
-		       struct page **pages, struct page *dummy_read_page)
+		       struct page **pages, struct page *dummy_read_page,
+		       dma_addr_t *dma_addrs)
 {
 	struct nouveau_sgdma_be *nvbe = (struct nouveau_sgdma_be *)be;
 	struct drm_device *dev = nvbe->dev;
diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 01c2c73..6f156e9 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -655,7 +655,8 @@ struct radeon_ttm_backend {
 static int radeon_ttm_backend_populate(struct ttm_backend *backend,
 				       unsigned long num_pages,
 				       struct page **pages,
-				       struct page *dummy_read_page)
+				       struct page *dummy_read_page,
+				       dma_addr_t *dma_addrs)
 {
 	struct radeon_ttm_backend *gtt;
 
diff --git a/drivers/gpu/drm/ttm/ttm_agp_backend.c b/drivers/gpu/drm/ttm/ttm_agp_backend.c
index f999e36..1c4a72f 100644
--- a/drivers/gpu/drm/ttm/ttm_agp_backend.c
+++ b/drivers/gpu/drm/ttm/ttm_agp_backend.c
@@ -47,7 +47,8 @@ struct ttm_agp_backend {
 
 static int ttm_agp_populate(struct ttm_backend *backend,
 			    unsigned long num_pages, struct page **pages,
-			    struct page *dummy_read_page)
+			    struct page *dummy_read_page,
+			    dma_addr_t *dma_addrs)
 {
 	struct ttm_agp_backend *agp_be =
 	    container_of(backend, struct ttm_agp_backend, backend);
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 0d39001..86d5b17 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -169,7 +169,7 @@ int ttm_tt_populate(struct ttm_tt *ttm)
 	}
 
 	be->func->populate(be, ttm->num_pages, ttm->pages,
-			   ttm->dummy_read_page);
+			   ttm->dummy_read_page, ttm->dma_address);
 	ttm->state = tt_unbound;
 	return 0;
 }
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
index 80bc37b..87e43e0 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c
@@ -102,7 +102,8 @@ struct vmw_ttm_backend {
 
 static int vmw_ttm_populate(struct ttm_backend *backend,
 			    unsigned long num_pages, struct page **pages,
-			    struct page *dummy_read_page)
+			    struct page *dummy_read_page,
+			    dma_addr_t *dma_addrs)
 {
 	struct vmw_ttm_backend *vmw_be =
 	    container_of(backend, struct vmw_ttm_backend, backend);
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 6dc4fcc..ebcd3dd 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -50,13 +50,15 @@ struct ttm_backend_func {
 	 * @pages: Array of pointers to ttm pages.
 	 * @dummy_read_page: Page to be used instead of NULL pages in the
 	 * array @pages.
+	 * @dma_addrs: Array of DMA (bus) address of the ttm pages.
 	 *
 	 * Populate the backend with ttm pages. Depending on the backend,
 	 * it may or may not copy the @pages array.
 	 */
 	int (*populate) (struct ttm_backend *backend,
 			 unsigned long num_pages, struct page **pages,
-			 struct page *dummy_read_page);
+			 struct page *dummy_read_page,
+			 dma_addr_t *dma_addrs);
 	/**
 	 * struct ttm_backend_func member clear
 	 *
-- 
1.7.1

