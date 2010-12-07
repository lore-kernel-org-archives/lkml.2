Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0LGCIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:08:44 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47202 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab0LGCIk (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 21:08:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/7] nouveau/ttm/PCIe: Use dma_addr if TTM has set it.
Date: Mon,  6 Dec 2010 21:07:24 -0500
Message-Id: <1291687646-31994-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
References: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the TTM layer has used the DMA API to setup pages that are
TTM_PAGE_FLAG_DMA32 (look at patch titled: "ttm: Utilize the dma_addr_t
array for pages that are to in DMA32 pool."), lets use it
when programming the GART in the PCIe type cards.

This patch skips doing the pci_map_page (and pci_unmap_page) if
there is a DMA addresses passed in for that page. If the dma_address
is zero (or DMA_ERROR_CODE), then we continue on with our old
behaviour.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c |   28 +++++++++++++++++++++-------
 1 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
index edc140a..bbdd982 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -12,6 +12,7 @@ struct nouveau_sgdma_be {
 	struct drm_device *dev;
 
 	dma_addr_t *pages;
+	bool *ttm_alloced;
 	unsigned nr_pages;
 
 	unsigned pte_start;
@@ -35,15 +36,25 @@ nouveau_sgdma_populate(struct ttm_backend *be, unsigned long num_pages,
 	if (!nvbe->pages)
 		return -ENOMEM;
 
+	nvbe->ttm_alloced = kmalloc(sizeof(bool) * num_pages, GFP_KERNEL);
+	if (!nvbe->ttm_alloced)
+		return -ENOMEM;
+
 	nvbe->nr_pages = 0;
 	while (num_pages--) {
-		nvbe->pages[nvbe->nr_pages] =
-			pci_map_page(dev->pdev, pages[nvbe->nr_pages], 0,
+		if (dma_addrs[nvbe->nr_pages] != DMA_ERROR_CODE) {
+			nvbe->pages[nvbe->nr_pages] =
+					dma_addrs[nvbe->nr_pages];
+		 	nvbe->ttm_alloced[nvbe->nr_pages] = true;
+		} else {
+			nvbe->pages[nvbe->nr_pages] =
+				pci_map_page(dev->pdev, pages[nvbe->nr_pages], 0,
 				     PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
-		if (pci_dma_mapping_error(dev->pdev,
-					  nvbe->pages[nvbe->nr_pages])) {
-			be->func->clear(be);
-			return -EFAULT;
+			if (pci_dma_mapping_error(dev->pdev,
+						  nvbe->pages[nvbe->nr_pages])) {
+				be->func->clear(be);
+				return -EFAULT;
+			}
 		}
 
 		nvbe->nr_pages++;
@@ -66,11 +77,14 @@ nouveau_sgdma_clear(struct ttm_backend *be)
 			be->func->unbind(be);
 
 		while (nvbe->nr_pages--) {
-			pci_unmap_page(dev->pdev, nvbe->pages[nvbe->nr_pages],
+			if (!nvbe->ttm_alloced[nvbe->nr_pages])
+				pci_unmap_page(dev->pdev, nvbe->pages[nvbe->nr_pages],
 				       PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
 		}
 		kfree(nvbe->pages);
+		kfree(nvbe->ttm_alloced);
 		nvbe->pages = NULL;
+		nvbe->ttm_alloced = NULL;
 		nvbe->nr_pages = 0;
 	}
 }
-- 
1.7.1

