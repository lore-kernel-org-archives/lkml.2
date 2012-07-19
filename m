Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2GSRrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:47:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59760 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab2GSRrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:47:51 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <broonie@sirena.org.uk>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] spi: omap2-mcspi: Fix the below warning
Date: Thu, 19 Jul 2012 23:16:52 +0530
Message-ID: <1342720012-3709-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_map and dma_unmap should have same parameter
passed otherwise we get the below warn.

ks8851 spi1.0: DMA-API: device driver tries to free DMA memory it has not allocated [device address=0x000000009f22]

[    2.066925] Modules linked in:
[    2.070312]
[    2.071929] [<c001c250>] (unwind_backtrace+0x0/0x130) from [<c0043d84>] (warn_slowpath_common+0x4c/0x64)
[    2.081909] [<c0043d84>] (warn_slowpath_common+0x4c/0x64) from [<c0043e30>] (warn_slowpath_fmt+0x30/0x40)
[    2.091949] [<c0043e30>] (warn_slowpath_fmt+0x30/0x40) from [<c0293824>] (check_unmap+0x6d0/0x7b0)
[    2.101348] [<c0293824>] (check_unmap+0x6d0/0x7b0) from [<c02939cc>] (debug_dma_unmap_page+0x64/0x70)
[    2.111053] [<c02939cc>] (debug_dma_unmap_page+0x64/0x70) from [<c03519a4>] (omap2_mcspi_txrx_dma+0x2d8/0x4fc)
[    2.121582] [<c03519a4>] (omap2_mcspi_txrx_dma+0x2d8/0x4fc) from [<c03524d8>] (omap2_mcspi_work.clone.4+0xf0/0x290)
[    2.132537] [<c03524d8>] (omap2_mcspi_work.clone.4+0xf0/0x290) from [<c0352900>] (omap2_mcspi_transfer_one_message+0x288/0x438)
[    2.144592] [<c0352900>] (omap2_mcspi_transfer_one_message+0x288/0x438) from [<c03503bc>] (spi_pump_messages+0x100/0x160)
[    2.156127] [<c03503bc>] (spi_pump_messages+0x100/0x160) from [<c006635c>] (kthread_worker_fn+0xac/0x180)
[    2.166168] [<c006635c>] (kthread_worker_fn+0xac/0x180) from [<c0066578>] (kthread+0x90/0x9c)
[    2.175140] [<c0066578>] (kthread+0x90/0x9c) from [<c00157fc>] (kernel_thread_exit+0x0/0x8)
[    2.183898] ---[ end trace d1830ce6e44292f2 ]---

Fix the warn by changing the unmap parameter.

Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 0c73dd4..37ccdb7 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -388,7 +388,8 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 
 	if (tx != NULL) {
 		wait_for_completion(&mcspi_dma->dma_tx_completion);
-		dma_unmap_single(&spi->dev, xfer->tx_dma, count, DMA_TO_DEVICE);
+		dma_unmap_single(mcspi->dev, xfer->tx_dma, count,
+				 DMA_TO_DEVICE);
 
 		/* for TX_ONLY mode, be sure all words have shifted out */
 		if (rx == NULL) {
@@ -403,7 +404,8 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 
 	if (rx != NULL) {
 		wait_for_completion(&mcspi_dma->dma_rx_completion);
-		dma_unmap_single(&spi->dev, xfer->rx_dma, count, DMA_FROM_DEVICE);
+		dma_unmap_single(mcspi->dev, xfer->rx_dma, count,
+				 DMA_FROM_DEVICE);
 		omap2_mcspi_set_enable(spi, 0);
 
 		if (l & OMAP2_MCSPI_CHCONF_TURBO) {
-- 
1.7.5.4

