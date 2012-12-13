Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab2LMOFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:05:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44329 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab2LMOFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:33 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 078/241] iwlwifi: handle DMA mapping failures
Date: Thu, 13 Dec 2012 11:57:23 -0200
Message-Id: <1355407206-17100-79-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: adapt for 3.5:
  * code to patch is on iwl-trans-pcie-rx.c
  * first function patched was named iwlagn_rx_allocate
  * adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   23 ++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 5e18ff9..f774778 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -318,6 +318,14 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 		rxb->page_dma = dma_map_page(trans->dev, page, 0,
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
@@ -467,8 +475,19 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
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
-- 
1.7.9.5

