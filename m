Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab0LHBGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:06:11 -0500
Received: from kroah.org ([198.145.64.141]:33932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885Ab0LHBEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:04:14 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:49 2010
Message-Id: <20101208005749.641726825@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [282/289] r8169: fix rx checksum offload
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/net/r8169.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -4455,9 +4455,8 @@ static inline int rtl8169_fragmented_fra
 	return (status & (FirstFrag | LastFrag)) != (FirstFrag | LastFrag);
 }
 
-static inline void rtl8169_rx_csum(struct sk_buff *skb, struct RxDesc *desc)
+static inline void rtl8169_rx_csum(struct sk_buff *skb, u32 opts1)
 {
-	u32 opts1 = le32_to_cpu(desc->opts1);
 	u32 status = opts1 & RxProtoMask;
 
 	if (((status == RxProtoTCP) && !(opts1 & TCPFail)) ||
@@ -4551,8 +4550,6 @@ static int rtl8169_rx_interrupt(struct n
 				continue;
 			}
 
-			rtl8169_rx_csum(skb, desc);
-
 			if (rtl8169_try_rx_copy(&skb, tp, pkt_size, addr)) {
 				dma_sync_single_for_device(&pdev->dev, addr,
 					pkt_size, PCI_DMA_FROMDEVICE);
@@ -4563,6 +4560,7 @@ static int rtl8169_rx_interrupt(struct n
 				tp->Rx_skbuff[entry] = NULL;
 			}
 
+			rtl8169_rx_csum(skb, status);
 			skb_put(skb, pkt_size);
 			skb->protocol = eth_type_trans(skb, dev);
 


