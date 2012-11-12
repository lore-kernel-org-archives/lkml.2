Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2KLVQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:16:36 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55622 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2KLVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:16:34 -0500
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/2] staging: et131x: Avoid unnecessary calculations in for loop
Date: Mon, 12 Nov 2012 21:16:28 +0000
Message-Id: <1352754989-15603-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In et131x_rx_dma_memory_alloc(), we loop over fbr_entries - the values of
fbr_align and fbr_chunksize calculated in the loop do not depend on the
loop counter and are the same for all loop iterations.

Take the calculations of these values out of the loop, as we only
need to calculate them once per loop, not once per loop iteration.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 69a0729..4f68646 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -2266,7 +2266,9 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	u8 id;
 	u32 i, j;
 	u32 bufsize;
-	u32 pktstat_ringsize, fbr_chunksize;
+	u32 pktstat_ringsize;
+	u32 fbr_chunksize;
+	u32 fbr_align;
 	struct rx_ring *rx_ring;
 
 	/* Setup some convenience pointers */
@@ -2341,10 +2343,17 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	}
 
 	for (id = 0; id < NUM_FBRS; id++) {
+		if (id == 0 && rx_ring->fbr[id]->buffsize > 4096)
+				fbr_align = 4096;
+		else
+				fbr_align = rx_ring->fbr[id]->buffsize;
+
+		fbr_chunksize = (FBR_CHUNKS *
+				 rx_ring->fbr[id]->buffsize) + fbr_align - 1;
+
 		for (i = 0; i < (rx_ring->fbr[id]->num_entries / FBR_CHUNKS); i++) {
 			dma_addr_t fbr_tmp_physaddr;
 			dma_addr_t fbr_offset;
-			u32 fbr_align;
 
 			/* This code allocates an area of memory big enough for
 			 * N free buffers + (buffer_size - 1) so that the
@@ -2353,13 +2362,6 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			 * effect would be to double the size of FBR0. By
 			 * allocating N buffers at once, we reduce this overhead
 			 */
-			if (id == 0 && rx_ring->fbr[id]->buffsize > 4096)
-					fbr_align = 4096;
-			else
-					fbr_align = rx_ring->fbr[id]->buffsize;
-
-			fbr_chunksize = (FBR_CHUNKS *
-				rx_ring->fbr[id]->buffsize) + fbr_align - 1;
 			rx_ring->fbr[id]->mem_virtaddrs[i] = dma_alloc_coherent(
 					&adapter->pdev->dev, fbr_chunksize,
 					&rx_ring->fbr[id]->mem_physaddrs[i],
-- 
1.7.9.5

