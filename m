Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1IMOPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:15:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27241 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab1IMOO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:14:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: thellstrom@vmware.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, dri-devel@lists.freedesktop.org,
        thomas@shipmail.org
Cc: Pekka Paalanen <pq@iki.fi>, bskeggs@redhat.com, j.glisse@redhat.com,
        airlied@redhat.com, airlied@linux.ie, alexdeucher@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/7] ttm/radeon/nouveau: Check the DMA address from TTM against known value.
Date: Tue, 13 Sep 2011 10:12:44 -0400
Message-Id: <1315923170-25568-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315923170-25568-1-git-send-email-konrad.wilk@oracle.com>
References: <1315923170-25568-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E6F64F3.0091:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. instead of checking against the DMA_ERROR_CODE value which is
per-platform specific. The zero value is a known invalid value
that the TTM layer sets on the dma_address array if it is not
used (ttm_tt_alloc_page_directory calls drm_calloc_large which
creates a page with GFP_ZERO).

We can't use pci_dma_mapping_error as that is IOMMU
specific (some check for a specific physical address, some
for ranges, some just do a check against zero).

Also update the comments in the header about the true state
of that parameter.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c |    3 +--
 drivers/gpu/drm/radeon/radeon_gart.c    |    4 +---
 include/drm/ttm/ttm_page_alloc.h        |    4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
index 82fad91..9b570c3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -42,8 +42,7 @@ nouveau_sgdma_populate(struct ttm_backend *be, unsigned long num_pages,
 
 	nvbe->nr_pages = 0;
 	while (num_pages--) {
-		/* this code path isn't called and is incorrect anyways */
-		if (0) { /*dma_addrs[nvbe->nr_pages] != DMA_ERROR_CODE)*/
+		if (dma_addrs[nvbe->nr_pages] != 0) {
 			nvbe->pages[nvbe->nr_pages] =
 					dma_addrs[nvbe->nr_pages];
 		 	nvbe->ttm_alloced[nvbe->nr_pages] = true;
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index a533f52..068ba09 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -181,9 +181,7 @@ int radeon_gart_bind(struct radeon_device *rdev, unsigned offset,
 	p = t / (PAGE_SIZE / RADEON_GPU_PAGE_SIZE);
 
 	for (i = 0; i < pages; i++, p++) {
-		/* we reverted the patch using dma_addr in TTM for now but this
-		 * code stops building on alpha so just comment it out for now */
-		if (0) { /*dma_addr[i] != DMA_ERROR_CODE) */
+		if (dma_addr[i] != 0) {
 			rdev->gart.ttm_alloced[p] = true;
 			rdev->gart.pages_addr[p] = dma_addr[i];
 		} else {
diff --git a/include/drm/ttm/ttm_page_alloc.h b/include/drm/ttm/ttm_page_alloc.h
index 8062890..0017b17 100644
--- a/include/drm/ttm/ttm_page_alloc.h
+++ b/include/drm/ttm/ttm_page_alloc.h
@@ -36,7 +36,7 @@
  * @flags: ttm flags for page allocation.
  * @cstate: ttm caching state for the page.
  * @count: number of pages to allocate.
- * @dma_address: The DMA (bus) address of pages (if TTM_PAGE_FLAG_DMA32 set).
+ * @dma_address: The DMA (bus) address of pages - (by default zero).
  */
 int ttm_get_pages(struct list_head *pages,
 		  int flags,
@@ -51,7 +51,7 @@ int ttm_get_pages(struct list_head *pages,
  * count.
  * @flags: ttm flags for page allocation.
  * @cstate: ttm caching state.
- * @dma_address: The DMA (bus) address of pages (if TTM_PAGE_FLAG_DMA32 set).
+ * @dma_address: The DMA (bus) address of pages (by default zero).
  */
 void ttm_put_pages(struct list_head *pages,
 		   unsigned page_count,
-- 
1.7.4.1

