Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab2JQVPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 17:15:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39479 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853Ab2JQVPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 17:15:22 -0400
From: Mark Einon <mark.einon@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/2] staging: et131x: Use skb_headlen() where appropriate
Date: Wed, 17 Oct 2012 22:15:11 +0100
Message-Id: <1350508512-15562-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(skb->len - skb->data_len) is used in several places in the et131x
driver code. Converted all instances of this to use skb_headlen()
which is more readable.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 029725c..f0fe4bd 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3313,12 +3313,11 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 			 * This will work until we determine why the hardware
 			 * doesn't seem to like large fragments.
 			 */
-			if ((skb->len - skb->data_len) <= 1514) {
+			if (skb_headlen(skb) <= 1514) {
 				desc[frag].addr_hi = 0;
 				/* Low 16bits are length, high is vlan and
 				   unused currently so zero */
-				desc[frag].len_vlan =
-					skb->len - skb->data_len;
+				desc[frag].len_vlan = skb_headlen(skb);
 
 				/* NOTE: Here, the dma_addr_t returned from
 				 * dma_map_single() is implicitly cast as a
@@ -3331,13 +3330,11 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 				desc[frag++].addr_lo =
 				    dma_map_single(&adapter->pdev->dev,
 						   skb->data,
-						   skb->len -
-						   skb->data_len,
+						   skb_headlen(skb),
 						   DMA_TO_DEVICE);
 			} else {
 				desc[frag].addr_hi = 0;
-				desc[frag].len_vlan =
-				    (skb->len - skb->data_len) / 2;
+				desc[frag].len_vlan = skb_headlen(skb) / 2;
 
 				/* NOTE: Here, the dma_addr_t returned from
 				 * dma_map_single() is implicitly cast as a
@@ -3350,13 +3347,11 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 				desc[frag++].addr_lo =
 				    dma_map_single(&adapter->pdev->dev,
 						   skb->data,
-						   ((skb->len -
-						     skb->data_len) / 2),
+						   (skb_headlen(skb) / 2),
 						   DMA_TO_DEVICE);
 				desc[frag].addr_hi = 0;
 
-				desc[frag].len_vlan =
-				    (skb->len - skb->data_len) / 2;
+				desc[frag].len_vlan = skb_headlen(skb) / 2;
 
 				/* NOTE: Here, the dma_addr_t returned from
 				 * dma_map_single() is implicitly cast as a
@@ -3369,10 +3364,8 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 				desc[frag++].addr_lo =
 				    dma_map_single(&adapter->pdev->dev,
 						   skb->data +
-						   ((skb->len -
-						     skb->data_len) / 2),
-						   ((skb->len -
-						     skb->data_len) / 2),
+							 (skb_headlen(skb) / 2),
+						   (skb_headlen(skb) / 2),
 						   DMA_TO_DEVICE);
 			}
 		} else {
@@ -3521,7 +3514,7 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *adapter)
 
 	tcb->skb = skb;
 
-	if (skb->data != NULL && skb->len - skb->data_len >= 6) {
+	if (skb->data != NULL && skb_headlen(skb) >= 6) {
 		shbufva = (u16 *) skb->data;
 
 		if ((shbufva[0] == 0xffff) &&
-- 
1.7.9.5

