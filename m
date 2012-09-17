Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2IQBRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:17:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33645 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502Ab2IQAuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:19 -0400
Message-Id: <20120917003641.721250035@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Santiago Leon <santil@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 112/135] ibmveth: Fix alignment of rx queue bug
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santiago Leon <santil@linux.vnet.ibm.com>

commit d90c92fee89ccd75ef2646f3bde0b4c0450666c3 upstream.

This patch fixes a bug found by Nish Aravamudan
(https://lkml.org/lkml/2012/5/15/220) where the driver is not following
the spec (it is not aligning the rx buffer on a 16-byte boundary) and the
hypervisor aborts the registration, making the device unusable.

The fix follows BenH's recommendation (https://lkml.org/lkml/2012/7/20/461)
to replace the kmalloc+map for a single call to dma_alloc_coherent()
because that function always aligns to a 16-byte boundary.

The stable trees will run into this bug whenever the rx buffer kmalloc call
returns something not aligned on a 16-byte boundary.

Signed-off-by: Santiago Leon <santil@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/ibm/ibmveth.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 9010cea..b68d28a 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -472,14 +472,9 @@ static void ibmveth_cleanup(struct ibmveth_adapter *adapter)
 	}
 
 	if (adapter->rx_queue.queue_addr != NULL) {
-		if (!dma_mapping_error(dev, adapter->rx_queue.queue_dma)) {
-			dma_unmap_single(dev,
-					adapter->rx_queue.queue_dma,
-					adapter->rx_queue.queue_len,
-					DMA_BIDIRECTIONAL);
-			adapter->rx_queue.queue_dma = DMA_ERROR_CODE;
-		}
-		kfree(adapter->rx_queue.queue_addr);
+		dma_free_coherent(dev, adapter->rx_queue.queue_len,
+				  adapter->rx_queue.queue_addr,
+				  adapter->rx_queue.queue_dma);
 		adapter->rx_queue.queue_addr = NULL;
 	}
 
@@ -556,10 +551,13 @@ static int ibmveth_open(struct net_device *netdev)
 		goto err_out;
 	}
 
+	dev = &adapter->vdev->dev;
+
 	adapter->rx_queue.queue_len = sizeof(struct ibmveth_rx_q_entry) *
 						rxq_entries;
-	adapter->rx_queue.queue_addr = kmalloc(adapter->rx_queue.queue_len,
-						GFP_KERNEL);
+	adapter->rx_queue.queue_addr =
+	    dma_alloc_coherent(dev, adapter->rx_queue.queue_len,
+			       &adapter->rx_queue.queue_dma, GFP_KERNEL);
 
 	if (!adapter->rx_queue.queue_addr) {
 		netdev_err(netdev, "unable to allocate rx queue pages\n");
@@ -567,19 +565,13 @@ static int ibmveth_open(struct net_device *netdev)
 		goto err_out;
 	}
 
-	dev = &adapter->vdev->dev;
-
 	adapter->buffer_list_dma = dma_map_single(dev,
 			adapter->buffer_list_addr, 4096, DMA_BIDIRECTIONAL);
 	adapter->filter_list_dma = dma_map_single(dev,
 			adapter->filter_list_addr, 4096, DMA_BIDIRECTIONAL);
-	adapter->rx_queue.queue_dma = dma_map_single(dev,
-			adapter->rx_queue.queue_addr,
-			adapter->rx_queue.queue_len, DMA_BIDIRECTIONAL);
 
 	if ((dma_mapping_error(dev, adapter->buffer_list_dma)) ||
-	    (dma_mapping_error(dev, adapter->filter_list_dma)) ||
-	    (dma_mapping_error(dev, adapter->rx_queue.queue_dma))) {
+	    (dma_mapping_error(dev, adapter->filter_list_dma))) {
 		netdev_err(netdev, "unable to map filter or buffer list "
 			   "pages\n");
 		rc = -ENOMEM;


