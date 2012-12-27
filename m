Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab2L0Tn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 14:43:58 -0500
Received: from norkia.v3.sk ([91.210.183.14]:55439 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab2L0Tn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 14:43:56 -0500
X-Greylist: delayed 1196 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2012 14:43:56 EST
From: Lubomir Rintel <lkundrak@v3.sk>
To: Dan Williams <djbw@fb.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH 1/2] dma: mv_xor: use proper dma memory management functions
Date: Thu, 27 Dec 2012 20:23:47 +0100
Message-Id: <1356636228-23096-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caught by self-check with DMA_API_DEBUG:
WARNING: at lib/dma-debug.c:878 check_unmap+0x37c/0x748()
mv_xor mv_xor.0: DMA-API: device driver frees DMA memory with wrong function [device address=0x000000001f3a1a40] [size=2000 bytes] [mapped as single] [unmapped as page]

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/dma/mv_xor.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index ac71f55..39387df 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -306,9 +306,7 @@ mv_xor_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
 			desc->async_tx.callback(
 				desc->async_tx.callback_param);
 
-		/* unmap dma addresses
-		 * (unmap_single vs unmap_page?)
-		 */
+		/* unmap dma addresses */
 		if (desc->group_head && desc->unmap_len) {
 			struct mv_xor_desc_slot *unmap = desc->group_head;
 			struct device *dev = mv_chan_to_devp(mv_chan);
@@ -327,7 +325,11 @@ mv_xor_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
 					dir = DMA_BIDIRECTIONAL;
 				else
 					dir = DMA_FROM_DEVICE;
-				dma_unmap_page(dev, dest, len, dir);
+
+				if (flags & DMA_COMPL_DEST_UNMAP_SINGLE)
+					dma_unmap_single(dev, dest, len, dir);
+				else
+					dma_unmap_page(dev, dest, len, dir);
 			}
 
 			if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
@@ -336,8 +338,12 @@ mv_xor_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
 								    src_cnt);
 					if (addr == dest)
 						continue;
-					dma_unmap_page(dev, addr, len,
-						       DMA_TO_DEVICE);
+					if (flags & DMA_COMPL_SRC_UNMAP_SINGLE)
+						dma_unmap_single(dev, addr, len,
+							       DMA_TO_DEVICE);
+					else
+						dma_unmap_page(dev, addr, len,
+							       DMA_TO_DEVICE);
 				}
 			}
 			desc->group_head = NULL;
@@ -938,7 +944,9 @@ static int mv_xor_memcpy_self_test(struct mv_xor_chan *mv_chan)
 				 MV_XOR_TEST_SIZE, DMA_TO_DEVICE);
 
 	tx = mv_xor_prep_dma_memcpy(dma_chan, dest_dma, src_dma,
-				    MV_XOR_TEST_SIZE, 0);
+				    MV_XOR_TEST_SIZE,
+				    DMA_COMPL_SRC_UNMAP_SINGLE |
+				    DMA_COMPL_DEST_UNMAP_SINGLE);
 	cookie = mv_xor_tx_submit(tx);
 	mv_xor_issue_pending(dma_chan);
 	async_tx_ack(tx);
-- 
1.7.1

