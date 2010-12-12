Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0LLXsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36910 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab0LLXso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:44 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: eric.dumazet@gmail.com, romieu@fr.zoreil.com, davem@davemloft.net,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [215/223] r8169: fix rx checksum offload
Message-Id: <20101212234842.CAF03B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit adea1ac7effbddbe60a9de6d63462bfe79289e59 upstream.

While porting GRO to r8169, I found this driver has a bug in its rx
path.

All skbs given to network stack had their ip_summed set to
CHECKSUM_NONE, while hardware said they had correct TCP/UDP checksums.

The reason is driver sets skb->ip_summed on the original skb before the
copy eventually done by copybreak. The fresh skb gets the ip_summed =
CHECKSUM_NONE value, forcing network stack to recompute checksum, and
preventing my GRO patch to work.

Fix is to make the ip_summed setting after skb copy.

Note : rx_copybreak current value is 16383, so all frames are copied...

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/r8169.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/drivers/net/r8169.c
===================================================================
--- linux.orig/drivers/net/r8169.c
+++ linux/drivers/net/r8169.c
@@ -4458,9 +4458,8 @@ static inline int rtl8169_fragmented_fra
 	return (status & (FirstFrag | LastFrag)) != (FirstFrag | LastFrag);
 }
 
-static inline void rtl8169_rx_csum(struct sk_buff *skb, struct RxDesc *desc)
+static inline void rtl8169_rx_csum(struct sk_buff *skb, u32 opts1)
 {
-	u32 opts1 = le32_to_cpu(desc->opts1);
 	u32 status = opts1 & RxProtoMask;
 
 	if (((status == RxProtoTCP) && !(opts1 & TCPFail)) ||
@@ -4554,8 +4553,6 @@ static int rtl8169_rx_interrupt(struct n
 				continue;
 			}
 
-			rtl8169_rx_csum(skb, desc);
-
 			if (rtl8169_try_rx_copy(&skb, tp, pkt_size, addr)) {
 				pci_dma_sync_single_for_device(pdev, addr,
 					pkt_size, PCI_DMA_FROMDEVICE);
@@ -4566,6 +4563,7 @@ static int rtl8169_rx_interrupt(struct n
 				tp->Rx_skbuff[entry] = NULL;
 			}
 
+			rtl8169_rx_csum(skb, status);
 			skb_put(skb, pkt_size);
 			skb->protocol = eth_type_trans(skb, dev);
 
