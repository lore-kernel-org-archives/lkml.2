Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1KFAjN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 20:39:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61800 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1KFAjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 20:39:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization:x-system-of-record;
	b=xY1RHI7nVU1i1xlUhaQ2S++py7Yv/LT378zAPqmmV7d4HHmRwyxtO+uBsDyC5NrAD
	r+GaNbdoMifuiOCwWa5tg==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net v5 3/5] forcedeth: remove unneeded stats updates
Date: Sat,  5 Nov 2011 17:38:22 -0700
Message-Id: <c4254dc55ace14d870a03a18f349103ea5ce27e6.1320539724.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320539724.git.david.decotigny@google.com>
References: <cover.1320539724.git.david.decotigny@google.com>
In-Reply-To: <cover.1320539724.git.david.decotigny@google.com>
References: <cover.1320539724.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function ndo_get_stats() updates most of the stats from hardware
registers, making the manual updates un-needed. This change removes
these manual updates. Main exception is rx_missed_errors which needs
manual update.

Another exception is rx_packets, still updated manually in this commit
to make sure this patch doesn't change behavior of driver. This will
be addressed by a future patch.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |   35 +------------------------------
 1 files changed, 1 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index b7cf4b6..2f1eaee 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -2374,16 +2374,8 @@ static int nv_tx_done(struct net_device *dev, int limit)
 		if (np->desc_ver == DESC_VER_1) {
 			if (flags & NV_TX_LASTPACKET) {
 				if (flags & NV_TX_ERROR) {
-					if (flags & NV_TX_UNDERFLOW)
-						dev->stats.tx_fifo_errors++;
-					if (flags & NV_TX_CARRIERLOST)
-						dev->stats.tx_carrier_errors++;
 					if ((flags & NV_TX_RETRYERROR) && !(flags & NV_TX_RETRYCOUNT_MASK))
 						nv_legacybackoff_reseed(dev);
-					dev->stats.tx_errors++;
-				} else {
-					dev->stats.tx_packets++;
-					dev->stats.tx_bytes += np->get_tx_ctx->skb->len;
 				}
 				dev_kfree_skb_any(np->get_tx_ctx->skb);
 				np->get_tx_ctx->skb = NULL;
@@ -2392,16 +2384,8 @@ static int nv_tx_done(struct net_device *dev, int limit)
 		} else {
 			if (flags & NV_TX2_LASTPACKET) {
 				if (flags & NV_TX2_ERROR) {
-					if (flags & NV_TX2_UNDERFLOW)
-						dev->stats.tx_fifo_errors++;
-					if (flags & NV_TX2_CARRIERLOST)
-						dev->stats.tx_carrier_errors++;
 					if ((flags & NV_TX2_RETRYERROR) && !(flags & NV_TX2_RETRYCOUNT_MASK))
 						nv_legacybackoff_reseed(dev);
-					dev->stats.tx_errors++;
-				} else {
-					dev->stats.tx_packets++;
-					dev->stats.tx_bytes += np->get_tx_ctx->skb->len;
 				}
 				dev_kfree_skb_any(np->get_tx_ctx->skb);
 				np->get_tx_ctx->skb = NULL;
@@ -2434,9 +2418,7 @@ static int nv_tx_done_optimized(struct net_device *dev, int limit)
 		nv_unmap_txskb(np, np->get_tx_ctx);
 
 		if (flags & NV_TX2_LASTPACKET) {
-			if (!(flags & NV_TX2_ERROR))
-				dev->stats.tx_packets++;
-			else {
+			if (flags & NV_TX2_ERROR) {
 				if ((flags & NV_TX2_RETRYERROR) && !(flags & NV_TX2_RETRYCOUNT_MASK)) {
 					if (np->driver_data & DEV_HAS_GEAR_MODE)
 						nv_gear_backoff_reseed(dev);
@@ -2636,7 +2618,6 @@ static int nv_rx_process(struct net_device *dev, int limit)
 					if ((flags & NV_RX_ERROR_MASK) == NV_RX_ERROR4) {
 						len = nv_getlen(dev, skb->data, len);
 						if (len < 0) {
-							dev->stats.rx_errors++;
 							dev_kfree_skb(skb);
 							goto next_pkt;
 						}
@@ -2650,11 +2631,6 @@ static int nv_rx_process(struct net_device *dev, int limit)
 					else {
 						if (flags & NV_RX_MISSEDFRAME)
 							dev->stats.rx_missed_errors++;
-						if (flags & NV_RX_CRCERR)
-							dev->stats.rx_crc_errors++;
-						if (flags & NV_RX_OVERFLOW)
-							dev->stats.rx_over_errors++;
-						dev->stats.rx_errors++;
 						dev_kfree_skb(skb);
 						goto next_pkt;
 					}
@@ -2670,7 +2646,6 @@ static int nv_rx_process(struct net_device *dev, int limit)
 					if ((flags & NV_RX2_ERROR_MASK) == NV_RX2_ERROR4) {
 						len = nv_getlen(dev, skb->data, len);
 						if (len < 0) {
-							dev->stats.rx_errors++;
 							dev_kfree_skb(skb);
 							goto next_pkt;
 						}
@@ -2682,11 +2657,6 @@ static int nv_rx_process(struct net_device *dev, int limit)
 					}
 					/* the rest are hard errors */
 					else {
-						if (flags & NV_RX2_CRCERR)
-							dev->stats.rx_crc_errors++;
-						if (flags & NV_RX2_OVERFLOW)
-							dev->stats.rx_over_errors++;
-						dev->stats.rx_errors++;
 						dev_kfree_skb(skb);
 						goto next_pkt;
 					}
@@ -2704,7 +2674,6 @@ static int nv_rx_process(struct net_device *dev, int limit)
 		skb->protocol = eth_type_trans(skb, dev);
 		napi_gro_receive(&np->napi, skb);
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += len;
 next_pkt:
 		if (unlikely(np->get_rx.orig++ == np->last_rx.orig))
 			np->get_rx.orig = np->first_rx.orig;
@@ -2787,9 +2756,7 @@ static int nv_rx_process_optimized(struct net_device *dev, int limit)
 				__vlan_hwaccel_put_tag(skb, vid);
 			}
 			napi_gro_receive(&np->napi, skb);
-
 			dev->stats.rx_packets++;
-			dev->stats.rx_bytes += len;
 		} else {
 			dev_kfree_skb(skb);
 		}
-- 
1.7.3.1

