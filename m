Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1LFXZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 18:25:01 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35663 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab1LFXZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 18:25:00 -0500
From: Mark Einon <mark.einon@gmail.com>
To: linux-next@vger.kernel.org
Cc: romieu@fr.zoreil.com, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH] linux-next:et131x: Revert changes from previous commit
Date: Tue,  6 Dec 2011 23:23:10 +0000
Message-Id: <1323213790-22039-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 834d0ee317b (uintxy_t removal) not all changes were trival text replacements, some converted u64 -> dma_addr_t.
In some configurations dma_addr_t is a u32, meaning that some bit operations cause build warnings. From Randy Dunlap:

----------------
on i386 (X86_32) builds:

drivers/staging/et131x/et131x.c:2483:8: warning: right shift count >= width of type
drivers/staging/et131x/et131x.c:2531:8: warning: right shift count >= width of type
----------------

Removed these by reverting dma_addr_t back to u64 types, as well as reverting some other non-trivial changes from the aforementioned commit.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 7ae3e53..2c4069f 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -299,8 +299,8 @@ struct fbr_lookup {
 	dma_addr_t	 ring_physaddr;
 	void		*mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
 	dma_addr_t	 mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	dma_addr_t	 real_physaddr;
-	u32		 offset;
+	u64		 real_physaddr;
+	u64		 offset;
 	u32		 local_full;
 	u32		 num_entries;
 	u32		 buffsize;
@@ -1902,10 +1902,9 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	/* Set the address and parameters of Free buffer ring 1 (and 0 if
 	 * required) into the 1310's registers
 	 */
-	writel(((u64) rx_local->fbr[0]->real_physaddr) >> 32,
+	writel((u32) (rx_local->fbr[0]->real_physaddr >> 32),
 	       &rx_dma->fbr1_base_hi);
-	writel(((u64) rx_local->fbr[0]->real_physaddr) & DMA_BIT_MASK(32),
-	       &rx_dma->fbr1_base_lo);
+	writel((u32) rx_local->fbr[0]->real_physaddr, &rx_dma->fbr1_base_lo);
 	writel(rx_local->fbr[0]->num_entries - 1, &rx_dma->fbr1_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr1_full_offset);
 
@@ -1927,10 +1926,9 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 		fbr_entry++;
 	}
 
-	writel(((u64) rx_local->fbr[1]->real_physaddr) >> 32,
+	writel((u32) (rx_local->fbr[1]->real_physaddr >> 32),
 	       &rx_dma->fbr0_base_hi);
-	writel(((u64) rx_local->fbr[1]->real_physaddr) & DMA_BIT_MASK(32),
-	       &rx_dma->fbr0_base_lo);
+	writel((u32) rx_local->fbr[1]->real_physaddr, &rx_dma->fbr0_base_lo);
 	writel(rx_local->fbr[1]->num_entries - 1, &rx_dma->fbr0_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr0_full_offset);
 
@@ -2275,10 +2273,10 @@ static inline u32 bump_free_buff_ring(u32 *free_buff_ring, u32 limit)
  * @mask: correct mask
  */
 static void et131x_align_allocated_memory(struct et131x_adapter *adapter,
-					  dma_addr_t *phys_addr, u32 *offset,
-					  u32 mask)
+					  u64 *phys_addr, u64 *offset,
+					  u64 mask)
 {
-	dma_addr_t new_addr = *phys_addr & ~mask;
+	u64 new_addr = *phys_addr & ~mask;
 
 	*offset = 0;
 
@@ -2430,8 +2428,8 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			rx_ring->fbr[1]->offset);
 #endif
 	for (i = 0; i < (rx_ring->fbr[0]->num_entries / FBR_CHUNKS); i++) {
-		dma_addr_t fbr1_tmp_physaddr;
-		u32 fbr1_offset;
+		u64 fbr1_tmp_physaddr;
+		u64 fbr1_offset;
 		u32 fbr1_align;
 
 		/* This code allocates an area of memory big enough for N
@@ -2496,8 +2494,8 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 #ifdef USE_FBR0
 	/* Same for FBR0 (if in use) */
 	for (i = 0; i < (rx_ring->fbr[1]->num_entries / FBR_CHUNKS); i++) {
-		dma_addr_t fbr0_tmp_physaddr;
-		u32 fbr0_offset;
+		u64 fbr0_tmp_physaddr;
+		u64 fbr0_offset;
 
 		fbr_chunksize =
 		    ((FBR_CHUNKS + 1) * rx_ring->fbr[1]->buffsize) - 1;
-- 
1.7.7.3

