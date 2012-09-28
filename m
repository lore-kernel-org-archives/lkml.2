Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032466Ab2I1U0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:26:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032450Ab2I1U0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Santiago Leon <santil@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 091/218] ibmveth: Fix alignment of rx queue bug
Date: Fri, 28 Sep 2012 13:15:08 -0700
Message-Id: <20120928201511.988981681@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ibm/ibmveth.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -472,14 +472,9 @@ static void ibmveth_cleanup(struct ibmve
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
 
@@ -556,10 +551,13 @@ static int ibmveth_open(struct net_devic
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
@@ -567,19 +565,13 @@ static int ibmveth_open(struct net_devic
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


