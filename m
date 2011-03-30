Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605Ab1C3VlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:41:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:24256 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933576Ab1C3VIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735435"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: chunkeey@googlemail.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [144/275] p54pci: update receive dma buffers before and after processing
Message-Id: <20110330210625.51AF83E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Christian Lamparter <chunkeey@googlemail.com>

commit 0bf719dfdecc5552155cbec78e49fa06e531e35c upstream.

Documentation/DMA-API-HOWTO.txt states:

"DMA transfers need to be synced properly in order for
the cpu and device to see the most uptodate and correct
copy of the DMA buffer."

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/p54/p54pci.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/drivers/net/wireless/p54/p54pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/p54/p54pci.c	2011-03-29 22:51:09.343484092 -0700
+++ linux-2.6.35.y/drivers/net/wireless/p54/p54pci.c	2011-03-29 23:03:01.264267821 -0700
@@ -199,6 +199,7 @@
 	while (i != idx) {
 		u16 len;
 		struct sk_buff *skb;
+		dma_addr_t dma_addr;
 		desc = &ring[i];
 		len = le16_to_cpu(desc->len);
 		skb = rx_buf[i];
@@ -216,17 +217,20 @@
 
 			len = priv->common.rx_mtu;
 		}
+		dma_addr = le32_to_cpu(desc->host_addr);
+		pci_dma_sync_single_for_cpu(priv->pdev, dma_addr,
+			priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
 		skb_put(skb, len);
 
 		if (p54_rx(dev, skb)) {
-			pci_unmap_single(priv->pdev,
-					 le32_to_cpu(desc->host_addr),
-					 priv->common.rx_mtu + 32,
-					 PCI_DMA_FROMDEVICE);
+			pci_unmap_single(priv->pdev, dma_addr,
+				priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
 			rx_buf[i] = NULL;
-			desc->host_addr = 0;
+			desc->host_addr = cpu_to_le32(0);
 		} else {
 			skb_trim(skb, 0);
+			pci_dma_sync_single_for_device(priv->pdev, dma_addr,
+				priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
 			desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
 		}
 
