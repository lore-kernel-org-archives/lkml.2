Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab1JSXEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:04:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38637 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab1JSXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:02:55 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: staging: et131x: use dma_alloc... instead of pci_alloc...
Date: Thu, 20 Oct 2011 00:01:03 +0100
Message-Id: <1319065268-2863-13-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
References: <1319065268-2863-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dma_allocs instead of pci_allocs, so we can use GFP_KERNEL
allocations.

Also removed this item from the TODO list

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README   |    1 -
 drivers/staging/et131x/et131x.c |   39 ++++++++++++++++++++++-----------------
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index 1e0fcf4..87b9360 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -9,7 +9,6 @@ driver as they did not build properly at the time.
 
 TODO:
 	- Use of kmem_cache seems a bit unusual
-	- Use dma_alloc_... in place of pci_alloc_...
 	- It's too late stopping the tx queue when there is no room for the current packet. The condition should be detected for the next packet.
 	- PCI_VDEVICE ?
 
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 0fbb77d..06ba4a9 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1965,9 +1965,10 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 
 	/* Allocate an area of memory for Free Buffer Ring 1 */
 	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries) + 0xfff;
-	rx_ring->fbr[0]->ring_virtaddr = pci_alloc_consistent(adapter->pdev,
-						bufsize,
-						&rx_ring->fbr[0]->ring_physaddr);
+	rx_ring->fbr[0]->ring_virtaddr = dma_alloc_coherent(&adapter->pdev->dev,
+					bufsize,
+					&rx_ring->fbr[0]->ring_physaddr,
+					GFP_KERNEL);
 	if (!rx_ring->fbr[0]->ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
 			  "Cannot alloc memory for Free Buffer Ring 1\n");
@@ -1995,9 +1996,10 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 #ifdef USE_FBR0
 	/* Allocate an area of memory for Free Buffer Ring 0 */
 	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries) + 0xfff;
-	rx_ring->fbr[1]->ring_virtaddr = pci_alloc_consistent(adapter->pdev,
+	rx_ring->fbr[1]->ring_virtaddr = dma_alloc_coherent(&adapter->pdev->dev,
 						bufsize,
-						&rx_ring->fbr[1]->ring_physaddr);
+						&rx_ring->fbr[1]->ring_physaddr,
+						GFP_KERNEL);
 	if (!rx_ring->fbr[1]->ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
 			  "Cannot alloc memory for Free Buffer Ring 0\n");
@@ -2042,8 +2044,8 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		fbr_chunksize =
 		    (FBR_CHUNKS * rx_ring->fbr[0]->buffsize) + fbr1_align - 1;
 		rx_ring->fbr[0]->mem_virtaddrs[i] =
-		    pci_alloc_consistent(adapter->pdev, fbr_chunksize,
-					 &rx_ring->fbr[0]->mem_physaddrs[i]);
+		    dma_alloc_coherent(&adapter->pdev->dev, fbr_chunksize,
+					 &rx_ring->fbr[0]->mem_physaddrs[i], GFP_KERNEL);
 
 		if (!rx_ring->fbr[0]->mem_virtaddrs[i]) {
 			dev_err(&adapter->pdev->dev,
@@ -2094,8 +2096,8 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		fbr_chunksize =
 		    ((FBR_CHUNKS + 1) * rx_ring->fbr[1]->buffsize) - 1;
 		rx_ring->fbr[1]->mem_virtaddrs[i] =
-		    pci_alloc_consistent(adapter->pdev, fbr_chunksize,
-					 &rx_ring->fbr[1]->mem_physaddrs[i]);
+		    dma_alloc_coherent(&adapter->pdev->dev, fbr_chunksize,
+					 &rx_ring->fbr[1]->mem_physaddrs[i], GFP_KERNEL);
 
 		if (!rx_ring->fbr[1]->mem_virtaddrs[i]) {
 			dev_err(&adapter->pdev->dev,
@@ -2137,9 +2139,10 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	pktstat_ringsize =
 	    sizeof(struct pkt_stat_desc) * adapter->rx_ring.psr_num_entries;
 
-	rx_ring->ps_ring_virtaddr = pci_alloc_consistent(adapter->pdev,
+	rx_ring->ps_ring_virtaddr = dma_alloc_coherent(&adapter->pdev->dev,
 						  pktstat_ringsize,
-						  &rx_ring->ps_ring_physaddr);
+						  &rx_ring->ps_ring_physaddr,
+						  GFP_KERNEL);
 
 	if (!rx_ring->ps_ring_virtaddr) {
 		dev_err(&adapter->pdev->dev,
@@ -2157,9 +2160,10 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 */
 
 	/* Allocate an area of memory for writeback of status information */
-	rx_ring->rx_status_block = pci_alloc_consistent(adapter->pdev,
+	rx_ring->rx_status_block = dma_alloc_coherent(&adapter->pdev->dev,
 					    sizeof(struct rx_status_block),
-					    &rx_ring->rx_status_bus);
+					    &rx_ring->rx_status_bus,
+					    GFP_KERNEL);
 	if (!rx_ring->rx_status_block) {
 		dev_err(&adapter->pdev->dev,
 			  "Cannot alloc memory for Status Block\n");
@@ -2992,8 +2996,8 @@ int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 */
 	desc_size = (sizeof(struct tx_desc) * NUM_DESC_PER_RING_TX) + 4096 - 1;
 	tx_ring->tx_desc_ring =
-	    (struct tx_desc *) pci_alloc_consistent(adapter->pdev, desc_size,
-						    &tx_ring->tx_desc_ring_pa);
+	    (struct tx_desc *) dma_alloc_coherent(&adapter->pdev->dev, desc_size,
+						    &tx_ring->tx_desc_ring_pa, GFP_KERNEL);
 	if (!adapter->tx_ring.tx_desc_ring) {
 		dev_err(&adapter->pdev->dev,
 					"Cannot alloc memory for Tx Ring\n");
@@ -3008,9 +3012,10 @@ int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 * storing the adjusted address.
 	 */
 	/* Allocate memory for the Tx status block */
-	tx_ring->tx_status = pci_alloc_consistent(adapter->pdev,
+	tx_ring->tx_status = dma_alloc_coherent(&adapter->pdev->dev,
 						    sizeof(u32),
-						    &tx_ring->tx_status_pa);
+						    &tx_ring->tx_status_pa,
+						    GFP_KERNEL);
 	if (!adapter->tx_ring.tx_status_pa) {
 		dev_err(&adapter->pdev->dev,
 				  "Cannot alloc memory for Tx status block\n");
-- 
1.7.6.4

