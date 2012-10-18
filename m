Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2JRUf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:35:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55550 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2JRUf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:35:27 -0400
From: Mark Einon <mark.einon@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/2 v2] staging: et131x: Fix 64bit tx dma address handling
Date: Thu, 18 Oct 2012 21:34:22 +0100
Message-Id: <1350592462-23644-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350508512-15562-2-git-send-email-mark.einon@gmail.com>
References: <1350508512-15562-2-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver checks that the device can handle 64bit DMA addressing in
et131x_pci_setup(), but then assumes that the top dword of a tx dma
address is always zero when creating a dma mapping in nic_send_packet().
Fix the mapping to use the higher dword of the dma_addr_t returned by
dma_map_single() and skb_frag_dma_map().

Also remove incorrect comments stating that dma_map_single() only returns
a 32 bit address.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |  102 +++++++++++++++------------------------
 1 file changed, 39 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 9d258a3..23d166b 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3285,6 +3285,7 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 	struct skb_frag_struct *frags = &skb_shinfo(skb)->frags[0];
 	unsigned long flags;
 	struct phy_device *phydev = adapter->phydev;
+	dma_addr_t dma_addr;
 
 	/* Part of the optimizations of this send routine restrict us to
 	 * sending 24 fragments at a pass.  In practice we should never see
@@ -3314,77 +3315,46 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 			 * doesn't seem to like large fragments.
 			 */
 			if (skb_headlen(skb) <= 1514) {
-				desc[frag].addr_hi = 0;
 				/* Low 16bits are length, high is vlan and
 				   unused currently so zero */
 				desc[frag].len_vlan = skb_headlen(skb);
-
-				/* NOTE: Here, the dma_addr_t returned from
-				 * dma_map_single() is implicitly cast as a
-				 * u32. Although dma_addr_t can be
-				 * 64-bit, the address returned by
-				 * dma_map_single() is always 32-bit
-				 * addressable (as defined by the pci/dma
-				 * subsystem)
-				 */
-				desc[frag++].addr_lo =
-				    dma_map_single(&adapter->pdev->dev,
-						   skb->data,
-						   skb_headlen(skb),
-						   DMA_TO_DEVICE);
+				dma_addr = dma_map_single(&adapter->pdev->dev,
+							  skb->data,
+							  skb_headlen(skb),
+							  DMA_TO_DEVICE);
+				desc[frag].addr_lo = lower_32_bits(dma_addr);
+				desc[frag].addr_hi = upper_32_bits(dma_addr);
+				frag++;
 			} else {
-				desc[frag].addr_hi = 0;
 				desc[frag].len_vlan = skb_headlen(skb) / 2;
-
-				/* NOTE: Here, the dma_addr_t returned from
-				 * dma_map_single() is implicitly cast as a
-				 * u32. Although dma_addr_t can be
-				 * 64-bit, the address returned by
-				 * dma_map_single() is always 32-bit
-				 * addressable (as defined by the pci/dma
-				 * subsystem)
-				 */
-				desc[frag++].addr_lo =
-				    dma_map_single(&adapter->pdev->dev,
-						   skb->data,
-						   (skb_headlen(skb) / 2),
-						   DMA_TO_DEVICE);
-				desc[frag].addr_hi = 0;
+				dma_addr = dma_map_single(&adapter->pdev->dev,
+							  skb->data,
+							  (skb_headlen(skb) / 2),
+							  DMA_TO_DEVICE);
+				desc[frag].addr_lo = lower_32_bits(dma_addr);
+				desc[frag].addr_hi = upper_32_bits(dma_addr);
+				frag++;
 
 				desc[frag].len_vlan = skb_headlen(skb) / 2;
-
-				/* NOTE: Here, the dma_addr_t returned from
-				 * dma_map_single() is implicitly cast as a
-				 * u32. Although dma_addr_t can be
-				 * 64-bit, the address returned by
-				 * dma_map_single() is always 32-bit
-				 * addressable (as defined by the pci/dma
-				 * subsystem)
-				 */
-				desc[frag++].addr_lo =
-				    dma_map_single(&adapter->pdev->dev,
-						   skb->data +
-							 (skb_headlen(skb) / 2),
-						   (skb_headlen(skb) / 2),
-						   DMA_TO_DEVICE);
+				dma_addr = dma_map_single(&adapter->pdev->dev,
+							  skb->data +
+							  (skb_headlen(skb) / 2),
+							  (skb_headlen(skb) / 2),
+							  DMA_TO_DEVICE);
+				desc[frag].addr_lo = lower_32_bits(dma_addr);
+				desc[frag].addr_hi = upper_32_bits(dma_addr);
+				frag++;
 			}
 		} else {
-			desc[frag].addr_hi = 0;
-			desc[frag].len_vlan =
-					frags[i - 1].size;
-
-			/* NOTE: Here, the dma_addr_t returned from
-			 * dma_map_page() is implicitly cast as a u32.
-			 * Although dma_addr_t can be 64-bit, the address
-			 * returned by dma_map_page() is always 32-bit
-			 * addressable (as defined by the pci/dma subsystem)
-			 */
-			desc[frag++].addr_lo = skb_frag_dma_map(
-							&adapter->pdev->dev,
-							&frags[i - 1],
-							0,
-							frags[i - 1].size,
-							DMA_TO_DEVICE);
+			desc[frag].len_vlan = frags[i - 1].size;
+			dma_addr = skb_frag_dma_map(&adapter->pdev->dev,
+						    &frags[i - 1],
+						    0,
+						    frags[i - 1].size,
+						    DMA_TO_DEVICE);
+			desc[frag].addr_lo = lower_32_bits(dma_addr);
+			desc[frag].addr_hi = upper_32_bits(dma_addr);
+			frag++;
 		}
 	}
 
@@ -3611,6 +3581,7 @@ static inline void free_send_packet(struct et131x_adapter *adapter,
 	unsigned long flags;
 	struct tx_desc *desc = NULL;
 	struct net_device_stats *stats = &adapter->net_stats;
+	dma_addr_t dma_addr;
 
 	if (tcb->flags & fMP_DEST_BROAD)
 		atomic_inc(&adapter->stats.broadcast_pkts_xmtd);
@@ -3631,8 +3602,13 @@ static inline void free_send_packet(struct et131x_adapter *adapter,
 				    (adapter->tx_ring.tx_desc_ring +
 						INDEX10(tcb->index_start));
 
+			dma_addr = desc->addr_lo;
+
+			if (sizeof(dma_addr_t) == sizeof(u64))
+				dma_addr |= ((dma_addr_t)desc->addr_hi) << 32;
+
 			dma_unmap_single(&adapter->pdev->dev,
-					 desc->addr_lo,
+					 dma_addr,
 					 desc->len_vlan, DMA_TO_DEVICE);
 
 			add_10bit(&tcb->index_start, 1);
-- 
1.7.9.5

