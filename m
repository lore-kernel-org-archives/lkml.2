Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1JJWKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:10:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:35748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab1JJWKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:10:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,519,1312182000"; 
   d="scan'208";a="72131962"
From: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH] ioat: workaround for silicon bug WRT RAID and legacy mix ops
To: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 15:12:12 -0700
Message-ID: <20111010221212.13938.8143.stgit@djiang5-linux.ch.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discovered silicon bug where when RAID and legacy descriptors are mixed,
the legacy operation alignment must be cache aligned to avoid hang.
Alignment check for DMA copy operations have been added. This will impact
NET_DMA operations as it calls those functions directly. async_tx already
check alignments for copy.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

 drivers/dma/dmaengine.c   |   11 +++++++++++
 drivers/dma/ioat/dma_v3.c |   22 ++++++++++++++++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 8bcb15f..bd39c6b 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -856,6 +856,10 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 	dma_cookie_t cookie;
 	unsigned long flags;
 
+	if (!is_dma_copy_aligned(dev, (unsigned long)src & (PAGE_SIZE-1),
+				 (unsigned long)dest & (PAGE_SIZE-1), len))
+		return -EIO;
+
 	dma_src = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_single(dev->dev, dest, len, DMA_FROM_DEVICE);
 	flags = DMA_CTRL_ACK |
@@ -904,6 +908,10 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 	dma_cookie_t cookie;
 	unsigned long flags;
 
+	if (!is_dma_copy_aligned(dev, (unsigned long)kdata & (PAGE_SIZE-1),
+				 offset, len))
+		return -EIO;
+
 	dma_src = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_page(dev->dev, page, offset, len, DMA_FROM_DEVICE);
 	flags = DMA_CTRL_ACK | DMA_COMPL_SRC_UNMAP_SINGLE;
@@ -952,6 +960,9 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 	dma_cookie_t cookie;
 	unsigned long flags;
 
+	if (!is_dma_copy_aligned(dev, src_off, dest_off, len))
+		return -EIO;
+
 	dma_src = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_page(dev->dev, dest_pg, dest_off, len,
 				DMA_FROM_DEVICE);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index d845dc4..cabd4c3 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1147,6 +1147,25 @@ static int ioat3_reset_hw(struct ioat_chan_common *chan)
 	return ioat2_reset_sync(chan, msecs_to_jiffies(200));
 }
 
+static bool is_snb_ioat(struct pci_dev *pdev)
+{
+	switch (pdev->device) {
+		case PCI_DEVICE_ID_INTEL_IOAT_SNB0:
+		case PCI_DEVICE_ID_INTEL_IOAT_SNB1:
+		case PCI_DEVICE_ID_INTEL_IOAT_SNB2:
+		case PCI_DEVICE_ID_INTEL_IOAT_SNB3:
+		case PCI_DEVICE_ID_INTEL_IOAT_SNB4:
+		case PCI_DEVICE_ID_INTEL_IOAT_SNB5:
+		case PCI_DEVICE_ID_INTEL_IOAT_SNB6:
+		case PCI_DEVICE_ID_INTEL_IOAT_SNB7:
+		case PCI_DEVICE_ID_INTEL_IOAT_SNB8:
+		case PCI_DEVICE_ID_INTEL_IOAT_SNB9:
+			return true;
+		default:
+			return false;
+	}
+}
+
 int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
@@ -1167,6 +1186,9 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
 
+	if (is_snb_ioat(pdev))
+		dma->copy_align = 6;
+
 	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
 	dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
 

