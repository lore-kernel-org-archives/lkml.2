Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1JWROp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 13:14:45 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:60824 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1JWROn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 13:14:43 -0400
Date: Sun, 23 Oct 2011 19:11:19 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH staging 2/6] et131x: uintxy_t removal.
Message-ID: <20111023171119.GB28657@electric-eye.fr.zoreil.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com> <20111023093651.GA22285@kroah.com> <20111023094231.GA3409@msilap.einon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023094231.GA3409@msilap.einon>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/staging/et131x/et131x.c |   53 ++++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 06960f3..2ae7819 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -303,8 +303,8 @@ struct fbr_lookup {
 	dma_addr_t	 ring_physaddr;
 	void		*mem_virtaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
 	dma_addr_t	 mem_physaddrs[MAX_DESC_PER_RING_RX / FBR_CHUNKS];
-	uint64_t	 real_physaddr;
-	uint64_t	 offset;
+	dma_addr_t	 real_physaddr;
+	u32		 offset;
 	u32		 local_full;
 	u32		 num_entries;
 	u32		 buffsize;
@@ -1117,12 +1117,10 @@ static int et1310_in_phy_coma(struct et131x_adapter *adapter)
 static void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
 {
 	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
-	uint32_t nIndex;
-	uint32_t result;
-	uint32_t hash1 = 0;
-	uint32_t hash2 = 0;
-	uint32_t hash3 = 0;
-	uint32_t hash4 = 0;
+	u32 hash1 = 0;
+	u32 hash2 = 0;
+	u32 hash3 = 0;
+	u32 hash4 = 0;
 	u32 pm_csr;
 
 	/* If ET131X_PACKET_TYPE_MULTICAST is specified, then we provision
@@ -1131,10 +1129,13 @@ static void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
 	 * driver.
 	 */
 	if (adapter->packet_filter & ET131X_PACKET_TYPE_MULTICAST) {
+		int i;
+
 		/* Loop through our multicast array and set up the device */
-		for (nIndex = 0; nIndex < adapter->multicast_addr_count;
-		     nIndex++) {
-			result = ether_crc(6, adapter->multicast_list[nIndex]);
+		for (i = 0; i < adapter->multicast_addr_count; i++) {
+			u32 result;
+
+			result = ether_crc(6, adapter->multicast_list[i]);
 
 			result = (result & 0x3F800000) >> 23;
 
@@ -1925,9 +1926,10 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 	/* Set the address and parameters of Free buffer ring 1 (and 0 if
 	 * required) into the 1310's registers
 	 */
-	writel((u32) (rx_local->fbr[0]->real_physaddr >> 32),
+	writel(((u64) rx_local->fbr[0]->real_physaddr) >> 32,
 	       &rx_dma->fbr1_base_hi);
-	writel((u32) rx_local->fbr[0]->real_physaddr, &rx_dma->fbr1_base_lo);
+	writel(((u64) rx_local->fbr[0]->real_physaddr) & DMA_BIT_MASK(32),
+	       &rx_dma->fbr1_base_lo);
 	writel(rx_local->fbr[0]->num_entries - 1, &rx_dma->fbr1_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr1_full_offset);
 
@@ -1949,9 +1951,10 @@ static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 		fbr_entry++;
 	}
 
-	writel((u32) (rx_local->fbr[1]->real_physaddr >> 32),
+	writel(((u64) rx_local->fbr[1]->real_physaddr) >> 32,
 	       &rx_dma->fbr0_base_hi);
-	writel((u32) rx_local->fbr[1]->real_physaddr, &rx_dma->fbr0_base_lo);
+	writel(((u64) rx_local->fbr[1]->real_physaddr) & DMA_BIT_MASK(32),
+	       &rx_dma->fbr0_base_lo);
 	writel(rx_local->fbr[1]->num_entries - 1, &rx_dma->fbr0_num_des);
 	writel(ET_DMA10_WRAP, &rx_dma->fbr0_full_offset);
 
@@ -2298,15 +2301,13 @@ static inline u32 bump_free_buff_ring(u32 *free_buff_ring, u32 limit)
  * @mask: correct mask
  */
 static void et131x_align_allocated_memory(struct et131x_adapter *adapter,
-				   uint64_t *phys_addr,
-				   uint64_t *offset, uint64_t mask)
+					  dma_addr_t *phys_addr, u32 *offset,
+					  u32 mask)
 {
-	uint64_t new_addr;
+	dma_addr_t new_addr = *phys_addr & ~mask;
 
 	*offset = 0;
 
-	new_addr = *phys_addr & ~mask;
-
 	if (new_addr != *phys_addr) {
 		/* Move to next aligned block */
 		new_addr += mask + 1;
@@ -2455,8 +2456,8 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			rx_ring->fbr[1]->offset);
 #endif
 	for (i = 0; i < (rx_ring->fbr[0]->num_entries / FBR_CHUNKS); i++) {
-		u64 fbr1_offset;
-		u64 fbr1_tmp_physaddr;
+		dma_addr_t fbr1_tmp_physaddr;
+		u32 fbr1_offset;
 		u32 fbr1_align;
 
 		/* This code allocates an area of memory big enough for N
@@ -2521,8 +2522,8 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 #ifdef USE_FBR0
 	/* Same for FBR0 (if in use) */
 	for (i = 0; i < (rx_ring->fbr[1]->num_entries / FBR_CHUNKS); i++) {
-		u64 fbr0_offset;
-		u64 fbr0_tmp_physaddr;
+		dma_addr_t fbr0_tmp_physaddr;
+		u32 fbr0_offset;
 
 		fbr_chunksize =
 		    ((FBR_CHUNKS + 1) * rx_ring->fbr[1]->buffsize) - 1;
@@ -4900,8 +4901,8 @@ static int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf,
  */
 static int et131x_set_packet_filter(struct et131x_adapter *adapter)
 {
+	int filter = adapter->packet_filter;
 	int status = 0;
-	uint32_t filter = adapter->packet_filter;
 	u32 ctrl;
 	u32 pf_ctrl;
 
@@ -4963,7 +4964,7 @@ static int et131x_set_packet_filter(struct et131x_adapter *adapter)
 static void et131x_multicast(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
-	uint32_t packet_filter = 0;
+	int packet_filter;
 	unsigned long flags;
 	struct netdev_hw_addr *ha;
 	int i;
-- 
1.7.6.4

