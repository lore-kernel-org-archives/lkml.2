Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab0GJUpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 16:45:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:52893 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab0GJUpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 16:45:23 -0400
Date: Sat, 10 Jul 2010 20:45:10 +0000
From: Denis Kirjanov <dkirjanov@hera.kernel.org>
To: gregkh@suse.de
Cc: davem@davemloft.net, liodot@gmail.com, charrer@alacritech.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH -staging] slicoss: Remove net_device_stats from the
	driver's private
Message-ID: <20100710204510.GA18748@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 10 Jul 2010 20:45:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove net_device_stats from the driver's private.

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---
 drivers/staging/slicoss/slic.h    |    1 -
 drivers/staging/slicoss/slicoss.c |   41 +++++++++++++++++++------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/slicoss/slic.h b/drivers/staging/slicoss/slic.h
index cab1a61..beab400 100644
--- a/drivers/staging/slicoss/slic.h
+++ b/drivers/staging/slicoss/slic.h
@@ -499,7 +499,6 @@ struct adapter {
     struct slic_ifevents  if_events;
     struct slic_stats        inicstats_prev;
     struct slicnet_stats     slic_stats;
-    struct net_device_stats stats;
 };
 
 
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index d442e3b..0c8c4ad 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -860,6 +860,7 @@ static void slic_config_clear(struct adapter *adapter)
 static bool slic_mac_filter(struct adapter *adapter,
 			struct ether_header *ether_frame)
 {
+	struct net_device *netdev = adapter->netdev;
 	u32 opts = adapter->macopts;
 	u32 *dhost4 = (u32 *)&ether_frame->ether_dhost[0];
 	u16 *dhost2 = (u16 *)&ether_frame->ether_dhost[4];
@@ -879,7 +880,7 @@ static bool slic_mac_filter(struct adapter *adapter,
 	if (ether_frame->ether_dhost[0] & 0x01) {
 		if (opts & MAC_ALLMCAST) {
 			adapter->rcv_multicasts++;
-			adapter->stats.multicast++;
+			netdev->stats.multicast++;
 			return true;
 		}
 		if (opts & MAC_MCAST) {
@@ -889,7 +890,7 @@ static bool slic_mac_filter(struct adapter *adapter,
 				if (!compare_ether_addr(mcaddr->address,
 							ether_frame->ether_dhost)) {
 					adapter->rcv_multicasts++;
-					adapter->stats.multicast++;
+					netdev->stats.multicast++;
 					return true;
 				}
 				mcaddr = mcaddr->next;
@@ -2198,12 +2199,11 @@ static int slic_debug_card_show(struct seq_file *seq, void *v)
 
 static int slic_debug_adapter_show(struct seq_file *seq, void *v)
 {
+	struct net_device *netdev = adapter->netdev;
 	struct adapter *adapter = seq->private;
 
-	if ((adapter->netdev) && (adapter->netdev->name)) {
-		seq_printf(seq, "info: interface          : %s\n",
+	seq_printf(seq, "info: interface          : %s\n",
 			    adapter->netdev->name);
-	}
 	seq_printf(seq, "info: status             : %s\n",
 		SLIC_LINKSTATE(adapter->linkstate));
 	seq_printf(seq, "info: port               : %d\n",
@@ -2221,9 +2221,9 @@ static int slic_debug_adapter_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "info: RcvQ current       : %4.4X\n",
 		    adapter->rcvqueue.count);
 	seq_printf(seq, "rx stats: packets                  : %8.8lX\n",
-		    adapter->stats.rx_packets);
+		    netdev->stats.rx_packets);
 	seq_printf(seq, "rx stats: bytes                    : %8.8lX\n",
-		    adapter->stats.rx_bytes);
+		    netdev->stats.rx_bytes);
 	seq_printf(seq, "rx stats: broadcasts               : %8.8X\n",
 		    adapter->rcv_broadcasts);
 	seq_printf(seq, "rx stats: multicasts               : %8.8X\n",
@@ -2237,13 +2237,13 @@ static int slic_debug_adapter_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "rx stats: drops                    : %8.8X\n",
 			(u32) adapter->rcv_drops);
 	seq_printf(seq, "tx stats: packets                  : %8.8lX\n",
-			adapter->stats.tx_packets);
+			netdev->stats.tx_packets);
 	seq_printf(seq, "tx stats: bytes                    : %8.8lX\n",
-			adapter->stats.tx_bytes);
+			netdev->stats.tx_bytes);
 	seq_printf(seq, "tx stats: errors                   : %8.8X\n",
 			(u32) adapter->slic_stats.iface.xmt_errors);
 	seq_printf(seq, "rx stats: multicasts               : %8.8lX\n",
-			adapter->stats.multicast);
+			netdev->stats.multicast);
 	seq_printf(seq, "tx stats: collision errors         : %8.8X\n",
 			(u32) adapter->slic_stats.iface.xmit_collisions);
 	seq_printf(seq, "perf: Max rcv frames/isr           : %8.8X\n",
@@ -2620,13 +2620,14 @@ static void slic_xmit_fail(struct adapter *adapter,
 		}
 	}
 	dev_kfree_skb(skb);
-	adapter->stats.tx_dropped++;
+	adapter->netdev->stats.tx_dropped++;
 }
 
 static void slic_rcv_handle_error(struct adapter *adapter,
 					struct slic_rcvbuf *rcvbuf)
 {
 	struct slic_hddr_wds *hdr = (struct slic_hddr_wds *)rcvbuf->data;
+	struct net_device *netdev = adapter->netdev;
 
 	if (adapter->devid != SLIC_1GB_DEVICE_ID) {
 		if (hdr->frame_status14 & VRHSTAT_802OE)
@@ -2637,15 +2638,15 @@ static void slic_rcv_handle_error(struct adapter *adapter,
 			adapter->if_events.uflow802++;
 		if (hdr->frame_status_b14 & VRHSTATB_RCVE) {
 			adapter->if_events.rcvearly++;
-			adapter->stats.rx_fifo_errors++;
+			netdev->stats.rx_fifo_errors++;
 		}
 		if (hdr->frame_status_b14 & VRHSTATB_BUFF) {
 			adapter->if_events.Bufov++;
-			adapter->stats.rx_over_errors++;
+			netdev->stats.rx_over_errors++;
 		}
 		if (hdr->frame_status_b14 & VRHSTATB_CARRE) {
 			adapter->if_events.Carre++;
-			adapter->stats.tx_carrier_errors++;
+			netdev->stats.tx_carrier_errors++;
 		}
 		if (hdr->frame_status_b14 & VRHSTATB_LONGE)
 			adapter->if_events.Longe++;
@@ -2653,7 +2654,7 @@ static void slic_rcv_handle_error(struct adapter *adapter,
 			adapter->if_events.Invp++;
 		if (hdr->frame_status_b14 & VRHSTATB_CRC) {
 			adapter->if_events.Crc++;
-			adapter->stats.rx_crc_errors++;
+			netdev->stats.rx_crc_errors++;
 		}
 		if (hdr->frame_status_b14 & VRHSTATB_DRBL)
 			adapter->if_events.Drbl++;
@@ -2719,6 +2720,7 @@ static void slic_rcv_handle_error(struct adapter *adapter,
 
 static void slic_rcv_handler(struct adapter *adapter)
 {
+	struct net_device *netdev = adapter->netdev;
 	struct sk_buff *skb;
 	struct slic_rcvbuf *rcvbuf;
 	u32 frames = 0;
@@ -2744,8 +2746,8 @@ static void slic_rcv_handler(struct adapter *adapter)
 		skb_pull(skb, SLIC_RCVBUF_HEADSIZE);
 		rx_bytes = (rcvbuf->length & IRHDDR_FLEN_MSK);
 		skb_put(skb, rx_bytes);
-		adapter->stats.rx_packets++;
-		adapter->stats.rx_bytes += rx_bytes;
+		netdev->stats.rx_packets++;
+		netdev->stats.rx_bytes += rx_bytes;
 #if SLIC_OFFLOAD_IP_CHECKSUM
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 #endif
@@ -2939,8 +2941,8 @@ static netdev_tx_t slic_xmit_start(struct sk_buff *skb, struct net_device *dev)
 		if (skbtype == NORMAL_ETHFRAME)
 			slic_xmit_build_request(adapter, hcmd, skb);
 	}
-	adapter->stats.tx_packets++;
-	adapter->stats.tx_bytes += skb->len;
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
 
 #ifdef DEBUG_DUMP
 	if (adapter->kill_card) {
@@ -2972,7 +2974,6 @@ xmit_fail:
 static void slic_adapter_freeresources(struct adapter *adapter)
 {
 	slic_init_cleanup(adapter);
-	memset(&adapter->stats, 0, sizeof(struct net_device_stats));
 	adapter->error_interrupts = 0;
 	adapter->rcv_interrupts = 0;
 	adapter->xmit_interrupts = 0;
