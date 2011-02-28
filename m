Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1B1Qrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:47:53 -0500
Received: from kroah.org ([198.145.64.141]:48040 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415Ab1B1Qh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:37:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:08 2011
Message-Id: <20110228162408.638954070@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ajit Khaparde <ajitk@serverengines.com>,
        "David S. Miller" <davem@davemloft.net>,
        maximilian attems <max@stro.at>
Subject: [29/68] be2net: Maintain tx and rx counters in driver
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ajit Khaparde <ajitkhaparde@gmail.com>

commit 91992e446cadbbde1a304de6954afd715af5121e upstream.

For certain skews of the BE adapter, H/W Tx and Rx
counters could be common for more than one interface.
Add Tx and Rx counters in the adapter structure
(to maintain stats on a per interfae basis).

Signed-off-by: Ajit Khaparde <ajitk@serverengines.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/benet/be.h      |    2 ++
 drivers/net/benet/be_main.c |   18 +++++++++---------
 2 files changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/net/benet/be.h
+++ b/drivers/net/benet/be.h
@@ -165,6 +165,7 @@ struct be_drvr_stats {
 	ulong be_tx_jiffies;
 	u64 be_tx_bytes;
 	u64 be_tx_bytes_prev;
+	u64 be_tx_pkts;
 	u32 be_tx_rate;
 
 	u32 cache_barrier[16];
@@ -176,6 +177,7 @@ struct be_drvr_stats {
 	ulong be_rx_jiffies;
 	u64 be_rx_bytes;
 	u64 be_rx_bytes_prev;
+	u64 be_rx_pkts;
 	u32 be_rx_rate;
 	/* number of non ether type II frames dropped where
 	 * frame len > length field of Mac Hdr */
--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -146,13 +146,10 @@ void netdev_stats_update(struct be_adapt
 	struct net_device_stats *dev_stats = &adapter->stats.net_stats;
 	struct be_erx_stats *erx_stats = &hw_stats->erx;
 
-	dev_stats->rx_packets = port_stats->rx_total_frames;
-	dev_stats->tx_packets = port_stats->tx_unicastframes +
-		port_stats->tx_multicastframes + port_stats->tx_broadcastframes;
-	dev_stats->rx_bytes = (u64) port_stats->rx_bytes_msd << 32 |
-				(u64) port_stats->rx_bytes_lsd;
-	dev_stats->tx_bytes = (u64) port_stats->tx_bytes_msd << 32 |
-				(u64) port_stats->tx_bytes_lsd;
+	dev_stats->rx_packets = drvr_stats(adapter)->be_rx_pkts;
+	dev_stats->tx_packets = drvr_stats(adapter)->be_tx_pkts;
+	dev_stats->rx_bytes = drvr_stats(adapter)->be_rx_bytes;
+	dev_stats->tx_bytes = drvr_stats(adapter)->be_tx_bytes;
 
 	/* bad pkts received */
 	dev_stats->rx_errors = port_stats->rx_crc_errors +
@@ -309,12 +306,13 @@ static void be_tx_rate_update(struct be_
 }
 
 static void be_tx_stats_update(struct be_adapter *adapter,
-			u32 wrb_cnt, u32 copied, bool stopped)
+			u32 wrb_cnt, u32 copied, u32 gso_segs, bool stopped)
 {
 	struct be_drvr_stats *stats = drvr_stats(adapter);
 	stats->be_tx_reqs++;
 	stats->be_tx_wrbs += wrb_cnt;
 	stats->be_tx_bytes += copied;
+	stats->be_tx_pkts += (gso_segs ? gso_segs : 1);
 	if (stopped)
 		stats->be_tx_stops++;
 }
@@ -462,7 +460,8 @@ static netdev_tx_t be_xmit(struct sk_buf
 
 		be_txq_notify(adapter, txq->id, wrb_cnt);
 
-		be_tx_stats_update(adapter, wrb_cnt, copied, stopped);
+		be_tx_stats_update(adapter, wrb_cnt, copied,
+				skb_shinfo(skb)->gso_segs, stopped);
 	} else {
 		txq->head = start;
 		dev_kfree_skb_any(skb);
@@ -605,6 +604,7 @@ static void be_rx_stats_update(struct be
 	stats->be_rx_compl++;
 	stats->be_rx_frags += numfrags;
 	stats->be_rx_bytes += pktsize;
+	stats->be_rx_pkts++;
 }
 
 static inline bool do_pkt_csum(struct be_eth_rx_compl *rxcp, bool cso)


