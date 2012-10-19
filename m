Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab2JSWIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:08:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53545 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab2JSWIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:08:36 -0400
From: Mark Einon <mark.einon@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/3] staging: et131x: Remove USE_FBR0 define and #ifdefs
Date: Fri, 19 Oct 2012 23:08:16 +0100
Message-Id: <1350684496-14384-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350684496-14384-1-git-send-email-mark.einon@gmail.com>
References: <1350684496-14384-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USE_FBR0 has always been defined, even in the original driver code.
Remove the define and #ifdef code to leave the code in the same state.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   58 +++++----------------------------------
 1 file changed, 7 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 32f909a..c33cafd 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -176,20 +176,13 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver for the ET1310 by Agere S
 #define PARM_DMA_CACHE_DEF      0
 
 /* RX defines */
-#define USE_FBR0 1
 #define FBR_CHUNKS 32
 #define MAX_DESC_PER_RING_RX         1024
 
 /* number of RFDs - default and min */
-#ifdef USE_FBR0
 #define RFD_LOW_WATER_MARK	40
 #define NIC_DEFAULT_NUM_RFD	1024
 #define NUM_FBRS		2
-#else
-#define RFD_LOW_WATER_MARK	20
-#define NIC_DEFAULT_NUM_RFD	256
-#define NUM_FBRS		1
-#endif
 
 #define NIC_MIN_NUM_RFD		64
 #define NUM_PACKETS_HANDLED	256
@@ -871,7 +864,7 @@ static void et131x_rx_dma_enable(struct et131x_adapter *adapter)
 		csr |= 0x1000;
 	else if (adapter->rx_ring.fbr[0]->buffsize == 16384)
 		csr |= 0x1800;
-#ifdef USE_FBR0
+
 	csr |= 0x0400;		/* FBR0 enable */
 	if (adapter->rx_ring.fbr[1]->buffsize == 256)
 		csr |= 0x0100;
@@ -879,7 +872,6 @@ static void et131x_rx_dma_enable(struct et131x_adapter *adapter)
 		csr |= 0x0200;
 	else if (adapter->rx_ring.fbr[1]->buffsize == 1024)
 		csr |= 0x0300;
-#endif
 	writel(csr, &adapter->regs->rxdma.csr);
 
 	csr = readl(&adapter->regs->rxdma.csr);
@@ -1909,7 +1901,6 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	   ((rx_local->fbr[0]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
 	   &rx_dma->fbr1_min_des);
 
-#ifdef USE_FBR0
 	/* Now's the best time to initialize FBR0 contents */
 	fbr_entry = (struct fbr_desc *) rx_local->fbr[1]->ring_virtaddr;
 	for (entry = 0; entry < rx_local->fbr[1]->num_entries; entry++) {
@@ -1933,7 +1924,6 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	writel(
 	   ((rx_local->fbr[1]->num_entries * LO_MARK_PERCENT_FOR_RX) / 100) - 1,
 	   &rx_dma->fbr0_min_des);
-#endif
 
 	/* Program the number of packets we will receive before generating an
 	 * interrupt.
@@ -2305,9 +2295,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	rx_ring = &adapter->rx_ring;
 
 	/* Alloc memory for the lookup table */
-#ifdef USE_FBR0
 	rx_ring->fbr[1] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
-#endif
 	rx_ring->fbr[0] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
 
 	/* The first thing we will do is configure the sizes of the buffer
@@ -2329,35 +2317,25 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	 */
 
 	if (adapter->registry_jumbo_packet < 2048) {
-#ifdef USE_FBR0
 		rx_ring->fbr[1]->buffsize = 256;
 		rx_ring->fbr[1]->num_entries = 512;
-#endif
 		rx_ring->fbr[0]->buffsize = 2048;
 		rx_ring->fbr[0]->num_entries = 512;
 	} else if (adapter->registry_jumbo_packet < 4096) {
-#ifdef USE_FBR0
 		rx_ring->fbr[1]->buffsize = 512;
 		rx_ring->fbr[1]->num_entries = 1024;
-#endif
 		rx_ring->fbr[0]->buffsize = 4096;
 		rx_ring->fbr[0]->num_entries = 512;
 	} else {
-#ifdef USE_FBR0
 		rx_ring->fbr[1]->buffsize = 1024;
 		rx_ring->fbr[1]->num_entries = 768;
-#endif
 		rx_ring->fbr[0]->buffsize = 16384;
 		rx_ring->fbr[0]->num_entries = 128;
 	}
 
-#ifdef USE_FBR0
 	adapter->rx_ring.psr_num_entries =
 				adapter->rx_ring.fbr[1]->num_entries +
 				adapter->rx_ring.fbr[0]->num_entries;
-#else
-	adapter->rx_ring.psr_num_entries = adapter->rx_ring.fbr[0]->num_entries;
-#endif
 
 	/* Allocate an area of memory for Free Buffer Ring 1 */
 	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[0]->num_entries) +
@@ -2381,7 +2359,6 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			(void *)((u8 *) rx_ring->fbr[0]->ring_virtaddr +
 			rx_ring->fbr[0]->offset);
 
-#ifdef USE_FBR0
 	/* Allocate an area of memory for Free Buffer Ring 0 */
 	bufsize = (sizeof(struct fbr_desc) * rx_ring->fbr[1]->num_entries) +
 									0xfff;
@@ -2403,7 +2380,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 	rx_ring->fbr[1]->ring_virtaddr =
 			(void *)((u8 *) rx_ring->fbr[1]->ring_virtaddr +
 			rx_ring->fbr[1]->offset);
-#endif
+
 	for (i = 0; i < (rx_ring->fbr[0]->num_entries / FBR_CHUNKS); i++) {
 		u64 fbr1_tmp_physaddr;
 		u64 fbr1_offset;
@@ -2468,7 +2445,6 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		}
 	}
 
-#ifdef USE_FBR0
 	/* Same for FBR0 (if in use) */
 	for (i = 0; i < (rx_ring->fbr[1]->num_entries / FBR_CHUNKS); i++) {
 		u64 fbr0_tmp_physaddr;
@@ -2515,7 +2491,6 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 					rx_ring->fbr[1]->virt[index] - 4;
 		}
 	}
-#endif
 
 	/* Allocate an area of memory for FIFO of Packet Status ring entries */
 	pktstat_ringsize =
@@ -2644,7 +2619,6 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 		rx_ring->fbr[0]->ring_virtaddr = NULL;
 	}
 
-#ifdef USE_FBR0
 	/* Now the same for Free Buffer Ring 0 */
 	if (rx_ring->fbr[1]->ring_virtaddr) {
 		/* First the packet memory */
@@ -2679,7 +2653,6 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 
 		rx_ring->fbr[1]->ring_virtaddr = NULL;
 	}
-#endif
 
 	/* Free Packet Status Ring */
 	if (rx_ring->ps_ring_virtaddr) {
@@ -2709,10 +2682,7 @@ static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	}
 
 	/* Free the FBR Lookup Table */
-#ifdef USE_FBR0
 	kfree(rx_ring->fbr[1]);
-#endif
-
 	kfree(rx_ring->fbr[0]);
 
 	/* Reset Counters */
@@ -2808,9 +2778,7 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 	 * need to clean up OOB data
 	 */
 	if (
-#ifdef USE_FBR0
 	    (ring_index == 0 && buff_index < rx_local->fbr[1]->num_entries) ||
-#endif
 	    (ring_index == 1 && buff_index < rx_local->fbr[0]->num_entries)) {
 		spin_lock_irqsave(&adapter->fbr_lock, flags);
 
@@ -2831,9 +2799,7 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 					&rx_local->fbr[0]->local_full,
 					rx_local->fbr[0]->num_entries - 1),
 					&rx_dma->fbr1_full_offset);
-		}
-#ifdef USE_FBR0
-		else {
+		} else {
 			struct fbr_desc *next = (struct fbr_desc *)
 				rx_local->fbr[1]->ring_virtaddr +
 				    INDEX10(rx_local->fbr[1]->local_full);
@@ -2851,7 +2817,6 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 					rx_local->fbr[1]->num_entries - 1),
 			       &rx_dma->fbr0_full_offset);
 		}
-#endif
 		spin_unlock_irqrestore(&adapter->fbr_lock, flags);
 	} else {
 		dev_err(&adapter->pdev->dev,
@@ -2934,20 +2899,11 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 	writel(rx_local->local_psr_full,
 	       &adapter->regs->rxdma.psr_full_offset);
 
-#ifndef USE_FBR0
-	if (ring_index != 1)
-		return NULL;
-#endif
-
-#ifdef USE_FBR0
 	if (ring_index > 1 ||
-		(ring_index == 0 &&
-		buff_index > rx_local->fbr[1]->num_entries - 1) ||
-		(ring_index == 1 &&
-		buff_index > rx_local->fbr[0]->num_entries - 1)) {
-#else
-	if (ring_index != 1 || buff_index > rx_local->fbr[0]->num_entries - 1) {
-#endif
+			(ring_index == 0 &&
+			buff_index > rx_local->fbr[1]->num_entries - 1) ||
+			(ring_index == 1 &&
+			buff_index > rx_local->fbr[0]->num_entries - 1)) {
 		/* Illegal buffer or ring index cannot be used by S/W*/
 		dev_err(&adapter->pdev->dev,
 			  "NICRxPkts PSR Entry %d indicates "
-- 
1.7.9.5

