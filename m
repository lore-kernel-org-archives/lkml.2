Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab2AYUQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:16:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58696 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab2AYUQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:16:47 -0500
Message-ID: <1327522599.2605.14.camel@edumazet-laptop>
Subject: Re: [PATCH net] amd/lance.c: dev_alloc_skb to netdev_alloc_skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jan 2012 21:16:39 +0100
In-Reply-To: <CA+Dx6Ha4dnqnkR_Pc+dFZ+Ef_mxRNN_Jk44vJ_R0viuHd0JGHw@mail.gmail.com>
References: <1327517188-14088-1-git-send-email-netdev@pradeepdalvi.com>
	 <1327517706.2605.7.camel@edumazet-laptop>
	 <CA+Dx6Ha4dnqnkR_Pc+dFZ+Ef_mxRNN_Jk44vJ_R0viuHd0JGHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 janvier 2012 à 01:31 +0530, Pradeep A. Dalvi a écrit :

> Thanks Eric! Even if we try to skip NET_SKB_PAD i.e. max of 32 or
> L1_CACHE_BYTES, SKB_DATA_ALIGN is anyway going to add some additional
> bytes for the same reason.
> 
> And towards the end, as from my current understanding regarding skb
> allocations, for MTU including alignments < 2048, there is not much to
> worry about. As long as, it doesn't cross the boundary.
> 
> (And in fact, this driver doesn't even get compiled with current
> configs, even after forcefully adding CONFIG_ISA & CONFIG_LANCE, of
> course along with CONFIG_ISA_DMA_API. Had to change the Makefile)

Point is we dont need skbs at all, and we dont need NET_SKB_PAD padding
either.

Also a big blob of DMA memory (rx_buffs) is allocated but never used.

Best is to not touch this, since this driver is probably not anymore
used. 

Dont bother.

diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index a6e2e84..aa2c6cd 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -240,9 +240,8 @@ struct lance_private {
 	const char *name;
 	/* The saved address of a sent-in-place packet/buffer, for skfree(). */
 	struct sk_buff* tx_skbuff[TX_RING_SIZE];
-	/* The addresses of receive-in-place skbuffs. */
-	struct sk_buff* rx_skbuff[RX_RING_SIZE];
-	unsigned long rx_buffs;		/* Address of Rx and Tx buffers. */
+	/* The addresses of receive-in-place buffers. */
+	void		*rx_buff[RX_RING_SIZE];
 	/* Tx low-memory "bounce buffer" address. */
 	char (*tx_bounce_buffs)[PKT_BUF_SZ];
 	int cur_rx, cur_tx;			/* The next free ring entry */
@@ -364,7 +363,6 @@ static void cleanup_card(struct net_device *dev)
 		free_dma(dev->dma);
 	release_region(dev->base_addr, LANCE_TOTAL_SIZE);
 	kfree(lp->tx_bounce_buffs);
-	kfree((void*)lp->rx_buffs);
 	kfree(lp);
 }
 
@@ -552,10 +550,6 @@ static int __init lance_probe1(struct net_device *dev, int ioaddr, int irq, int
 	if (lance_debug > 6) printk(" (#0x%05lx)", (unsigned long)lp);
 	dev->ml_priv = lp;
 	lp->name = chipname;
-	lp->rx_buffs = (unsigned long)kmalloc(PKT_BUF_SZ*RX_RING_SIZE,
-						  GFP_DMA | GFP_KERNEL);
-	if (!lp->rx_buffs)
-		goto out_lp;
 	if (lance_need_isa_bounce_buffers) {
 		lp->tx_bounce_buffs = kmalloc(PKT_BUF_SZ*TX_RING_SIZE,
 						  GFP_DMA | GFP_KERNEL);
@@ -739,8 +733,6 @@ out_dma:
 out_tx:
 	kfree(lp->tx_bounce_buffs);
 out_rx:
-	kfree((void*)lp->rx_buffs);
-out_lp:
 	kfree(lp);
 	return err;
 }
@@ -842,11 +834,9 @@ lance_purge_ring(struct net_device *dev)
 
 	/* Free all the skbuffs in the Rx and Tx queues. */
 	for (i = 0; i < RX_RING_SIZE; i++) {
-		struct sk_buff *skb = lp->rx_skbuff[i];
-		lp->rx_skbuff[i] = NULL;
+		kfree(lp->rx_buff[i]);
+		lp->rx_buff[i] = NULL;
 		lp->rx_ring[i].base = 0;		/* Not owned by LANCE chip. */
-		if (skb)
-			dev_kfree_skb_any(skb);
 	}
 	for (i = 0; i < TX_RING_SIZE; i++) {
 		if (lp->tx_skbuff[i]) {
@@ -868,16 +858,9 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
 	lp->dirty_rx = lp->dirty_tx = 0;
 
 	for (i = 0; i < RX_RING_SIZE; i++) {
-		struct sk_buff *skb;
-		void *rx_buff;
-
-		skb = alloc_skb(PKT_BUF_SZ, GFP_DMA | gfp);
-		lp->rx_skbuff[i] = skb;
-		if (skb) {
-			skb->dev = dev;
-			rx_buff = skb->data;
-		} else
-			rx_buff = kmalloc(PKT_BUF_SZ, GFP_DMA | gfp);
+		void *rx_buff = kmalloc(PKT_BUF_SZ, GFP_DMA | gfp);
+
+		lp->rx_buff[i] = rx_buff;
 		if (rx_buff == NULL)
 			lp->rx_ring[i].base = 0;
 		else


