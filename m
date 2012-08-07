Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab2HGXX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:23:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030335Ab2HGWcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:32:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        Josh Boyer <jwboyer@redhat.com>, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20101/122=5D=20r8169=3A=20revert=20=22add=20byte=20queue=20limit=20support=22=2E?=
Date: Tue,  7 Aug 2012 15:26:29 -0700
Message-Id: <20120807221958.645834097@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Francois Romieu <romieu@fr.zoreil.com>

[ Upstream commit 17bcb684f08649a2ab6a7dcd8288332e72d208f1 ]

This reverts commit 036dafa28da1e2565a8529de2ae663c37b7a0060.

First it appears in bisection, then reverting it solves the usual
netdev watchdog problem for different people. I don't have a proper
fix yet so get rid of it.

Bisected-and-reported-by: Alex Villacís Lasso <a_villacis@palosanto.com>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |   27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5380,7 +5380,6 @@ static void rtl8169_tx_clear(struct rtl8
 {
 	rtl8169_tx_clear_range(tp, tp->dirty_tx, NUM_TX_DESC);
 	tp->cur_tx = tp->dirty_tx = 0;
-	netdev_reset_queue(tp->dev);
 }
 
 static void rtl_reset_work(struct rtl8169_private *tp)
@@ -5535,8 +5534,6 @@ static netdev_tx_t rtl8169_start_xmit(st
 
 	txd->opts2 = cpu_to_le32(opts[1]);
 
-	netdev_sent_queue(dev, skb->len);
-
 	skb_tx_timestamp(skb);
 
 	wmb();
@@ -5633,16 +5630,9 @@ static void rtl8169_pcierr_interrupt(str
 	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 }
 
-struct rtl_txc {
-	int packets;
-	int bytes;
-};
-
 static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp)
 {
-	struct rtl8169_stats *tx_stats = &tp->tx_stats;
 	unsigned int dirty_tx, tx_left;
-	struct rtl_txc txc = { 0, 0 };
 
 	dirty_tx = tp->dirty_tx;
 	smp_rmb();
@@ -5661,24 +5651,17 @@ static void rtl_tx(struct net_device *de
 		rtl8169_unmap_tx_skb(&tp->pci_dev->dev, tx_skb,
 				     tp->TxDescArray + entry);
 		if (status & LastFrag) {
-			struct sk_buff *skb = tx_skb->skb;
-
-			txc.packets++;
-			txc.bytes += skb->len;
-			dev_kfree_skb(skb);
+			u64_stats_update_begin(&tp->tx_stats.syncp);
+			tp->tx_stats.packets++;
+			tp->tx_stats.bytes += tx_skb->skb->len;
+			u64_stats_update_end(&tp->tx_stats.syncp);
+			dev_kfree_skb(tx_skb->skb);
 			tx_skb->skb = NULL;
 		}
 		dirty_tx++;
 		tx_left--;
 	}
 
-	u64_stats_update_begin(&tx_stats->syncp);
-	tx_stats->packets += txc.packets;
-	tx_stats->bytes += txc.bytes;
-	u64_stats_update_end(&tx_stats->syncp);
-
-	netdev_completed_queue(dev, txc.packets, txc.bytes);
-
 	if (tp->dirty_tx != dirty_tx) {
 		tp->dirty_tx = dirty_tx;
 		/* Sync with rtl8169_start_xmit:


