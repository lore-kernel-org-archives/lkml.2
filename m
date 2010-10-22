Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab0JVSrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:47:37 -0400
Received: from kroah.org ([198.145.64.141]:45790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758165Ab0JVSix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:53 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:36:00 2010
Message-Id: <20101022183600.385346831@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [47/66] r8169: allocate with GFP_KERNEL flag when able to sleep
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit aeb19f6052b5e5c8a24aa444fbff73b84341beac upstream.

We have fedora bug report where driver fail to initialize after
suspend/resume because of memory allocation errors:
https://bugzilla.redhat.com/show_bug.cgi?id=629158

To fix use GFP_KERNEL allocation where possible.

Tested-by: Neal Becker <ndbecker2@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3999,7 +3999,7 @@ static inline void rtl8169_map_to_asic(s
 static struct sk_buff *rtl8169_alloc_rx_skb(struct pci_dev *pdev,
 					    struct net_device *dev,
 					    struct RxDesc *desc, int rx_buf_sz,
-					    unsigned int align)
+					    unsigned int align, gfp_t gfp)
 {
 	struct sk_buff *skb;
 	dma_addr_t mapping;
@@ -4007,7 +4007,7 @@ static struct sk_buff *rtl8169_alloc_rx_
 
 	pad = align ? align : NET_IP_ALIGN;
 
-	skb = netdev_alloc_skb(dev, rx_buf_sz + pad);
+	skb = __netdev_alloc_skb(dev, rx_buf_sz + pad, gfp);
 	if (!skb)
 		goto err_out;
 
@@ -4038,7 +4038,7 @@ static void rtl8169_rx_clear(struct rtl8
 }
 
 static u32 rtl8169_rx_fill(struct rtl8169_private *tp, struct net_device *dev,
-			   u32 start, u32 end)
+			   u32 start, u32 end, gfp_t gfp)
 {
 	u32 cur;
 
@@ -4053,7 +4053,7 @@ static u32 rtl8169_rx_fill(struct rtl816
 
 		skb = rtl8169_alloc_rx_skb(tp->pci_dev, dev,
 					   tp->RxDescArray + i,
-					   tp->rx_buf_sz, tp->align);
+					   tp->rx_buf_sz, tp->align, gfp);
 		if (!skb)
 			break;
 
@@ -4081,7 +4081,7 @@ static int rtl8169_init_ring(struct net_
 	memset(tp->tx_skb, 0x0, NUM_TX_DESC * sizeof(struct ring_info));
 	memset(tp->Rx_skbuff, 0x0, NUM_RX_DESC * sizeof(struct sk_buff *));
 
-	if (rtl8169_rx_fill(tp, dev, 0, NUM_RX_DESC) != NUM_RX_DESC)
+	if (rtl8169_rx_fill(tp, dev, 0, NUM_RX_DESC, GFP_KERNEL) != NUM_RX_DESC)
 		goto err_out;
 
 	rtl8169_mark_as_last_descriptor(tp->RxDescArray + NUM_RX_DESC - 1);
@@ -4584,7 +4584,7 @@ static int rtl8169_rx_interrupt(struct n
 	count = cur_rx - tp->cur_rx;
 	tp->cur_rx = cur_rx;
 
-	delta = rtl8169_rx_fill(tp, dev, tp->dirty_rx, tp->cur_rx);
+	delta = rtl8169_rx_fill(tp, dev, tp->dirty_rx, tp->cur_rx, GFP_ATOMIC);
 	if (!delta && count && netif_msg_intr(tp))
 		printk(KERN_INFO "%s: no Rx buffer allocated\n", dev->name);
 	tp->dirty_rx += delta;


