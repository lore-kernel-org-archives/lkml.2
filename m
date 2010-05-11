Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab0EKC5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 22:57:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:46175 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269Ab0EKC5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 22:57:10 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -mm 3/3] Documentation: move the error handling to the better place in DMA-API-HOWTO
Date: Tue, 11 May 2010 11:55:29 +0900
Message-Id: <1273546529-16846-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1273546529-16846-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1273546529-16846-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 11 May 2010 11:56:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handing DMA mapping errors is essential. Let's put it in the more
appropriate place rather than the end of the doc.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/DMA-API-HOWTO.txt |   60 +++++++++++++++++++-------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index c3ab456..bfd94e9 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -639,6 +639,36 @@ is planned to completely remove virt_to_bus() and bus_to_virt() as
 they are entirely deprecated.  Some ports already do not provide these
 as it is impossible to correctly support them.
 
+			Handling Errors
+
+DMA address space is limited on some architectures and an allocation
+failure can be determined by:
+
+- checking if dma_alloc_coherent returns NULL or dma_map_sg returns 0
+
+- checking the returned dma_addr_t of dma_map_single and dma_map_page
+  by using dma_mapping_error():
+
+	dma_addr_t dma_handle;
+
+	dma_handle = dma_map_single(dev, addr, size, direction);
+	if (dma_mapping_error(dev, dma_handle)) {
+		/*
+		 * reduce current DMA mapping usage,
+		 * delay and try again later or
+		 * reset driver.
+		 */
+	}
+
+Networking drivers must call dev_kfree_skb to free the socket buffer
+and return NETDEV_TX_OK if the DMA mapping fails on the transmit hook
+(ndo_start_xmit). This means that the socket buffer is just dropped in
+the failure case.
+
+SCSI drivers must return SCSI_MLQUEUE_HOST_BUSY if the DMA mapping
+fails in the queuecommand hook. This means that the SCSI subsystem
+passes the command to the driver again later.
+
 		Optimizing Unmap State Space Consumption
 
 On many platforms, dma_unmap_{single,page}() is simply a nop.
@@ -710,36 +740,6 @@ to "Closing".
 
 2) More to come...
 
-			Handling Errors
-
-DMA address space is limited on some architectures and an allocation
-failure can be determined by:
-
-- checking if dma_alloc_coherent returns NULL or dma_map_sg returns 0
-
-- checking the returned dma_addr_t of dma_map_single and dma_map_page
-  by using dma_mapping_error():
-
-	dma_addr_t dma_handle;
-
-	dma_handle = dma_map_single(dev, addr, size, direction);
-	if (dma_mapping_error(dev, dma_handle)) {
-		/*
-		 * reduce current DMA mapping usage,
-		 * delay and try again later or
-		 * reset driver.
-		 */
-	}
-
-Networking drivers must call dev_kfree_skb to free the socket buffer
-and return NETDEV_TX_OK if the DMA mapping fails on the transmit hook
-(ndo_start_xmit). This means that the socket buffer is just dropped in
-the failure case.
-
-SCSI drivers must return SCSI_MLQUEUE_HOST_BUSY if the DMA mapping
-fails in the queuecommand hook. This means that the SCSI subsystem
-passes the command to the driver again later.
-
 			   Closing
 
 This document, and the API itself, would not be in its current
-- 
1.6.5

