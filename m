Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2L1T4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:56:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54982 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345Ab2L1TRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:09 -0500
Message-Id: <20121228190401.136910932@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:06:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        Shuah Khan <shuah.khan@hp.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [ 159/173] iwlwifi: handle DMA mapping failures
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust filename, context, indentation
 - Use bus(trans) instead of trans where necessary
 - Use hw_params(trans).rx_page_order instead of trans_pcie->rx_page_order]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -311,6 +311,14 @@ static void iwlagn_rx_allocate(struct iw
 		rxb->page_dma = dma_map_page(bus(trans)->dev, page, 0,
 				PAGE_SIZE << hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
+		if (dma_mapping_error(bus(trans)->dev, rxb->page_dma)) {
+			rxb->page = NULL;
+			spin_lock_irqsave(&rxq->lock, flags);
+			list_add(&rxb->list, &rxq->rx_used);
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			__free_pages(page, hw_params(trans).rx_page_order);
+			return;
+		}
 		/* dma address must be no more than 36 bits */
 		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
 		/* and also 256 byte aligned! */
@@ -489,8 +497,19 @@ static void iwl_rx_handle(struct iwl_tra
 				0, PAGE_SIZE <<
 				    hw_params(trans).rx_page_order,
 				DMA_FROM_DEVICE);
-			list_add_tail(&rxb->list, &rxq->rx_free);
-			rxq->free_count++;
+			if (dma_mapping_error(bus(trans)->dev, rxb->page_dma)) {
+				/*
+				 * free the page(s) as well to not break
+				 * the invariant that the items on the used
+				 * list have no page(s)
+				 */
+				__free_pages(rxb->page, hw_params(trans).rx_page_order);
+				rxb->page = NULL;
+				list_add_tail(&rxb->list, &rxq->rx_used);
+			} else {
+				list_add_tail(&rxb->list, &rxq->rx_free);
+				rxq->free_count++;
+			}
 		} else
 			list_add_tail(&rxb->list, &rxq->rx_used);
 


