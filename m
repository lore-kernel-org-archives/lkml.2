Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030988Ab2ERXWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:22:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946511Ab2ERXFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:09 -0400
Message-Id: <20120518211604.027709476@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 50/54] pch_gbe: fixed the issue which receives an unnecessary packet.
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

commit 5229d87edcd80a3bceb0708ebd767faff2e589a9 upstream.

This patch fixed the issue which receives an unnecessary packet before link

When using PHY of GMII, an unnecessary packet is received,
And it becomes impossible to receive a packet after link up.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/pch_gbe/pch_gbe_main.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/net/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/pch_gbe/pch_gbe_main.c
@@ -717,13 +717,6 @@ static void pch_gbe_configure_rx(struct
 	iowrite32(rdba, &hw->reg->RX_DSC_BASE);
 	iowrite32(rdlen, &hw->reg->RX_DSC_SIZE);
 	iowrite32((rdba + rdlen), &hw->reg->RX_DSC_SW_P);
-
-	/* Enables Receive DMA */
-	rxdma = ioread32(&hw->reg->DMA_CTRL);
-	rxdma |= PCH_GBE_RX_DMA_EN;
-	iowrite32(rxdma, &hw->reg->DMA_CTRL);
-	/* Enables Receive */
-	iowrite32(PCH_GBE_MRE_MAC_RX_EN, &hw->reg->MAC_RX_EN);
 }
 
 /**
@@ -1097,6 +1090,19 @@ void pch_gbe_update_stats(struct pch_gbe
 	spin_unlock_irqrestore(&adapter->stats_lock, flags);
 }
 
+static void pch_gbe_start_receive(struct pch_gbe_hw *hw)
+{
+	u32 rxdma;
+
+	/* Enables Receive DMA */
+	rxdma = ioread32(&hw->reg->DMA_CTRL);
+	rxdma |= PCH_GBE_RX_DMA_EN;
+	iowrite32(rxdma, &hw->reg->DMA_CTRL);
+	/* Enables Receive */
+	iowrite32(PCH_GBE_MRE_MAC_RX_EN, &hw->reg->MAC_RX_EN);
+	return;
+}
+
 /**
  * pch_gbe_intr - Interrupt Handler
  * @irq:   Interrupt number
@@ -1717,6 +1723,7 @@ int pch_gbe_up(struct pch_gbe_adapter *a
 	pch_gbe_alloc_tx_buffers(adapter, tx_ring);
 	pch_gbe_alloc_rx_buffers(adapter, rx_ring, rx_ring->count);
 	adapter->tx_queue_len = netdev->tx_queue_len;
+	pch_gbe_start_receive(&adapter->hw);
 
 	mod_timer(&adapter->watchdog_timer, jiffies);
 


