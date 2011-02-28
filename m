Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1B1QmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:42:01 -0500
Received: from kroah.org ([198.145.64.141]:48217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab1B1QiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:38:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:11 2011
Message-Id: <20110228162411.229083926@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:23:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [55/68] p54pci: update receive dma buffers before and after processing
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/net/wireless/p54/p54pci.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -198,6 +198,7 @@ static void p54p_check_rx_ring(struct ie
 	while (i != idx) {
 		u16 len;
 		struct sk_buff *skb;
+		dma_addr_t dma_addr;
 		desc = &ring[i];
 		len = le16_to_cpu(desc->len);
 		skb = rx_buf[i];
@@ -215,17 +216,20 @@ static void p54p_check_rx_ring(struct ie
 
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
 


