Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab0C3Mle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:41:34 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44486 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0C3Mlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:41:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ERvI8dxBPNkXGOhnAWIFVqoFdqZhM+vuKEhf8Fm4d7dRWo4StZbEdhhbH437p9q6X6
         IKAuLTRsUvonHzwSxwDsF7r7NOJkG4VVcnOLHloZ/T/Mdz1CGPGw+8ZBbZBucHWzqmjN
         d4NW81Hj2f4gfhiuqY0WgoHb1y/A4q1e0fYfE=
Subject: Re: Network performance - iperf
From: Eric Dumazet <eric.dumazet@gmail.com>
To: michal.simek@petalogix.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>, netdev@vger.kernel.org,
       Grant Likely <grant.likely@secretlab.ca>,
       John Linn <John.Linn@xilinx.com>,
       "Steven J. Magnani" <steve@digidescorp.com>,
       Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org
In-Reply-To: <4BB1C5A5.5070202@petalogix.com>
References: <4BB09021.6020202@petalogix.com>
	 <1269864994.2164.21.camel@edumazet-laptop> <4BB0BF28.5090505@petalogix.com>
	 <4BB0C6E1.2090606@petalogix.com> <1269884717.1958.2.camel@edumazet-laptop>
	 <4BB1C5A5.5070202@petalogix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 14:41:25 +0200
Message-ID: <1269952885.2012.58.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 mars 2010 à 11:34 +0200, Michal Simek a écrit :

>      2233 packets pruned from receive queue because of socket buffer overrun
>      TCPRcvCollapsed: 207654

Thats a problem. A big one :(

If I remember, you use LL_TEMAC driver.

This drivers allocates big skbs for RX ring (more than 9000 bytes each
skb). Given your 32 Mbytes kernel size, this seems plain wrong.

You might try to copybreak them before giving skb to network stack,
consuming the minimum space.

This would also help this driver to survive in low memory conditions,
avoiding death if high order pages are not available.

I cannot even compile this driver on my x86 platform, but here is a
preliminar patch to give you the idea :


[PATCH] ll_temac: Fix some memory allocation problems

Driver use high order allocations that might fail after a while.
When receiving a buffer from card, try to copy it to keep a pool of
pre-allocated high order buffers.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
Please please please note I did not test this patch.

 drivers/net/ll_temac_main.c |   48 +++++++++++++++-------------------
 1 file changed, 22 insertions(+), 26 deletions(-)
diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index a18e348..412b72e 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -155,8 +155,8 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		lp->rx_bd_v[i].next = lp->rx_bd_p +
 				sizeof(*lp->rx_bd_v) * ((i + 1) % RX_BD_NUM);
 
-		skb = alloc_skb(XTE_MAX_JUMBO_FRAME_SIZE
-				+ XTE_ALIGN, GFP_ATOMIC);
+		skb = alloc_skb(XTE_MAX_JUMBO_FRAME_SIZE + XTE_ALIGN,
+				GFP_KERNEL);
 		if (skb == 0) {
 			dev_err(&ndev->dev, "alloc_skb error %d\n", i);
 			return -1;
@@ -625,34 +625,30 @@ static void ll_temac_recv(struct net_device *ndev)
 		skb = lp->rx_skb[lp->rx_bd_ci];
 		length = cur_p->app4 & 0x3FFF;
 
-		skb_vaddr = virt_to_bus(skb->data);
+		new_skb = netdev_alloc_skb_ip_align(length);
+		if (new_skb) {
+			skb_copy_to_linear_data(new_skb, skb->data, length);
+			skb_put(new_skb, length);
+			skb_vaddr = virt_to_bus(skb->data);
+			dma_sync_single_for_device(ndev->dev.parent,
+						   skb_vaddr,
+						   XTE_MAX_JUMBO_FRAME_SIZE,
+						   PCI_DMA_FROMDEVICE);
+			new_skb->dev = ndev;
+			new_skb->protocol = eth_type_trans(new_skb, ndev);
+			new_skb->ip_summed = CHECKSUM_NONE;
+
+			netif_rx(new_skb);
+
+			ndev->stats.rx_packets++;
+			ndev->stats.rx_bytes += length;
+		} else
+			ndev->stats.rx_dropped++;
+
 		dma_unmap_single(ndev->dev.parent, skb_vaddr, length,
 				 DMA_FROM_DEVICE);
 
-		skb_put(skb, length);
-		skb->dev = ndev;
-		skb->protocol = eth_type_trans(skb, ndev);
-		skb->ip_summed = CHECKSUM_NONE;
-
-		netif_rx(skb);
-
-		ndev->stats.rx_packets++;
-		ndev->stats.rx_bytes += length;
-
-		new_skb = alloc_skb(XTE_MAX_JUMBO_FRAME_SIZE + XTE_ALIGN,
-				GFP_ATOMIC);
-		if (new_skb == 0) {
-			dev_err(&ndev->dev, "no memory for new sk_buff\n");
-			spin_unlock_irqrestore(&lp->rx_lock, flags);
-			return;
-		}
-
-		skb_reserve(new_skb, BUFFER_ALIGN(new_skb->data));
-
 		cur_p->app0 = STS_CTRL_APP0_IRQONEND;
-		cur_p->phys = dma_map_single(ndev->dev.parent, new_skb->data,
-					     XTE_MAX_JUMBO_FRAME_SIZE,
-					     DMA_FROM_DEVICE);
 		cur_p->len = XTE_MAX_JUMBO_FRAME_SIZE;
 		lp->rx_skb[lp->rx_bd_ci] = new_skb;
 


