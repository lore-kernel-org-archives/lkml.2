Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2L0ToB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 14:44:01 -0500
Received: from norkia.v3.sk ([91.210.183.14]:55437 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab2L0Tn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 14:43:56 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Dan Williams <djbw@fb.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 2/2] dma: mv_xor: do not sync the DMA buffer after being deallocated
Date: Thu, 27 Dec 2012 20:23:48 +0100
Message-Id: <1356636228-23096-2-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1356636228-23096-1-git-send-email-lkundrak@v3.sk>
References: <1356636228-23096-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA_CHECK was unhappy:
mv_xor mv_xor.0: DMA-API: device driver tries to sync DMA memory it has not

Also, the xor test was causing the mv_xor_slot_cleanup() to incorrectly
dealocate the destination buffer. This is fixed as well, since the deallocation
is done in mv_xor_probe() (with correct flags) now:
mv_xor mv_xor.0: DMA-API: device driver frees DMA memory with different direction [device address=0x000000001dea4000] [size=4096 bytes] [mapped with DMA_FROM_DEVICE] [unmapped with DMA_BIDIRECTIONAL]

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/dma/mv_xor.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 39387df..f642d8b 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -946,7 +946,7 @@ static int mv_xor_memcpy_self_test(struct mv_xor_chan *mv_chan)
 	tx = mv_xor_prep_dma_memcpy(dma_chan, dest_dma, src_dma,
 				    MV_XOR_TEST_SIZE,
 				    DMA_COMPL_SRC_UNMAP_SINGLE |
-				    DMA_COMPL_DEST_UNMAP_SINGLE);
+				    DMA_COMPL_SKIP_DEST_UNMAP);
 	cookie = mv_xor_tx_submit(tx);
 	mv_xor_issue_pending(dma_chan);
 	async_tx_ack(tx);
@@ -962,6 +962,8 @@ static int mv_xor_memcpy_self_test(struct mv_xor_chan *mv_chan)
 
 	dma_sync_single_for_cpu(dma_chan->device->dev, dest_dma,
 				MV_XOR_TEST_SIZE, DMA_FROM_DEVICE);
+	dma_unmap_single(dma_chan->device->dev, dest_dma, MV_XOR_TEST_SIZE,
+			 DMA_FROM_DEVICE);
 	if (memcmp(src, dest, MV_XOR_TEST_SIZE)) {
 		dev_err(dma_chan->device->dev,
 			"Self-test copy failed compare, disabling\n");
@@ -1039,7 +1041,8 @@ mv_xor_xor_self_test(struct mv_xor_chan *mv_chan)
 					   0, PAGE_SIZE, DMA_TO_DEVICE);
 
 	tx = mv_xor_prep_dma_xor(dma_chan, dest_dma, dma_srcs,
-				 MV_XOR_NUM_SRC_TEST, PAGE_SIZE, 0);
+				 MV_XOR_NUM_SRC_TEST, PAGE_SIZE,
+				 DMA_COMPL_SKIP_DEST_UNMAP);
 
 	cookie = mv_xor_tx_submit(tx);
 	mv_xor_issue_pending(dma_chan);
@@ -1056,6 +1059,8 @@ mv_xor_xor_self_test(struct mv_xor_chan *mv_chan)
 
 	dma_sync_single_for_cpu(dma_chan->device->dev, dest_dma,
 				PAGE_SIZE, DMA_FROM_DEVICE);
+	dma_unmap_page(dma_chan->device->dev, dest_dma, PAGE_SIZE,
+		       DMA_FROM_DEVICE);
 	for (i = 0; i < (PAGE_SIZE / sizeof(u32)); i++) {
 		u32 *ptr = page_address(dest);
 		if (ptr[i] != cmp_word) {
-- 
1.7.1

