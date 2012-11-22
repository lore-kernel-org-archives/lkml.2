Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2KVSkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:40:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:49626 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab2KVSke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Shuah Khan <shuah.khan@hp.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 50/83] iwlwifi: handle DMA mapping failures
Date: Wed, 21 Nov 2012 16:42:12 -0800
Message-Id: <20121122004218.087463925@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 7c34158231b2eda8dcbd297be2bb1559e69cb433 upstream.

The RX replenish code doesn't handle DMA mapping failures,
which will cause issues if there actually is a failure. This
was reported by Shuah Khan who found a DMA mapping framework
warning ("device driver failed to check map error").

Reported-by: Shuah Khan <shuah.khan@hp.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/rx.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -314,6 +314,14 @@ static void iwlagn_rx_allocate(struct iw
 			dma_map_page(trans->dev, page, 0,
 				     PAGE_SIZE << trans_pcie->rx_page_order,
 				     DMA_FROM_DEVICE);
+		if (dma_mapping_error(trans->dev, rxb->page_dma)) {
+			rxb->page = NULL;
+			spin_lock_irqsave(&rxq->lock, flags);
+			list_add(&rxb->list, &rxq->rx_used);
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			__free_pages(page, trans_pcie->rx_page_order);
+			return;
+		}
 		/* dma address must be no more than 36 bits */
 		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
 		/* and also 256 byte aligned! */
@@ -463,8 +471,19 @@ static void iwl_rx_handle_rxbuf(struct i
 			dma_map_page(trans->dev, rxb->page, 0,
 				     PAGE_SIZE << trans_pcie->rx_page_order,
 				     DMA_FROM_DEVICE);
-		list_add_tail(&rxb->list, &rxq->rx_free);
-		rxq->free_count++;
+		if (dma_mapping_error(trans->dev, rxb->page_dma)) {
+			/*
+			 * free the page(s) as well to not break
+			 * the invariant that the items on the used
+			 * list have no page(s)
+			 */
+			__free_pages(rxb->page, trans_pcie->rx_page_order);
+			rxb->page = NULL;
+			list_add_tail(&rxb->list, &rxq->rx_used);
+		} else {
+			list_add_tail(&rxb->list, &rxq->rx_free);
+			rxq->free_count++;
+		}
 	} else
 		list_add_tail(&rxb->list, &rxq->rx_used);
 	spin_unlock_irqrestore(&rxq->lock, flags);


