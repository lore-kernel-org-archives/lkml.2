Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030814Ab2HQDgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:36:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46725 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030615Ab2HQD0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:53 -0400
Message-Id: <20120817030243.998833263@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Chan <mchan@broadcom.com>,
        Zongyun Lai <zlai@vmware.com>, Jeffrey Huang <huangjw@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 01/37] bnx2: Fix bug in bnx2_free_tx_skbs().
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <mchan@broadcom.com>

[ Upstream commit c1f5163de417dab01fa9daaf09a74bbb19303f3c ]

In rare cases, bnx2x_free_tx_skbs() can unmap the wrong DMA address
when it gets to the last entry of the tx ring.  We were not using
the proper macro to skip the last entry when advancing the tx index.

Reported-by: Zongyun Lai <zlai@vmware.com>
Reviewed-by: Jeffrey Huang <huangjw@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/bnx2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 965c723..721adfd 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -5378,7 +5378,7 @@ bnx2_free_tx_skbs(struct bnx2 *bp)
 			int k, last;
 
 			if (skb == NULL) {
-				j++;
+				j = NEXT_TX_BD(j);
 				continue;
 			}
 
@@ -5390,8 +5390,8 @@ bnx2_free_tx_skbs(struct bnx2 *bp)
 			tx_buf->skb = NULL;
 
 			last = tx_buf->nr_frags;
-			j++;
-			for (k = 0; k < last; k++, j++) {
+			j = NEXT_TX_BD(j);
+			for (k = 0; k < last; k++, j = NEXT_TX_BD(j)) {
 				tx_buf = &txr->tx_buf_ring[TX_RING_IDX(j)];
 				dma_unmap_page(&bp->pdev->dev,
 					dma_unmap_addr(tx_buf, mapping),


