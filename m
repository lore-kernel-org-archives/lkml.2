Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031228Ab2HGWq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:46:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60358 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031215Ab2HGWqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:46:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zongyun Lai <zlai@vmware.com>, Jeffrey Huang <huangjw@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 28/49] bnx2: Fix bug in bnx2_free_tx_skbs().
Date: Tue,  7 Aug 2012 15:44:46 -0700
Message-Id: <20120807222029.403713301@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bnx2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -5310,7 +5310,7 @@ bnx2_free_tx_skbs(struct bnx2 *bp)
 			int k, last;
 
 			if (skb == NULL) {
-				j++;
+				j = NEXT_TX_BD(j);
 				continue;
 			}
 
@@ -5322,8 +5322,8 @@ bnx2_free_tx_skbs(struct bnx2 *bp)
 			tx_buf->skb = NULL;
 
 			last = tx_buf->nr_frags;
-			j++;
-			for (k = 0; k < last; k++, j++) {
+			j = NEXT_TX_BD(j);
+			for (k = 0; k < last; k++, j = NEXT_TX_BD(j)) {
 				tx_buf = &txr->tx_buf_ring[TX_RING_IDX(j)];
 				dma_unmap_page(&bp->pdev->dev,
 					dma_unmap_addr(tx_buf, mapping),


