Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1GCRJJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 13:09:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34801 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab1GCRJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 13:09:06 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/2] staging: et131x: Remove some unecessary packet accounting code
Date: Sun,  3 Jul 2011 18:08:23 +0100
Message-Id: <1309712903-11570-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309712903-11570-1-git-send-email-mark.einon@gmail.com>
References: <1309712903-11570-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ce_stats ipackets and opackets members are only used to update
the net_device_stats->[r,t]x_packets counters, so get rid of them.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_rx.c      |    2 +-
 drivers/staging/et131x/et1310_tx.c      |    2 +-
 drivers/staging/et131x/et131x_adapter.h |    5 -----
 drivers/staging/et131x/et131x_netdev.c  |    6 +-----
 4 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 6c0a64b..fc90096 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -1131,7 +1131,7 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 			continue;
 
 		/* Increment the number of packets we received */
-		etdev->stats.ipackets++;
+		etdev->net_stats.rx_packets++;
 
 		/* Set the status on the packet, either resources or success */
 		if (etdev->rx_ring.nReadyRecv < RFD_LOW_WATER_MARK) {
diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index b8f8dae..bb67192 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -673,7 +673,7 @@ inline void et131x_free_send_packet(struct et131x_adapter *etdev,
 	/* Add the TCB to the Ready Q */
 	spin_lock_irqsave(&etdev->TCBReadyQLock, flags);
 
-	etdev->stats.opackets++;
+	etdev->net_stats.tx_packets++;
 
 	if (etdev->tx_ring.tcb_qtail)
 		etdev->tx_ring.tcb_qtail->next = tcb;
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index c6657f4..99c2ef6 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -99,10 +99,6 @@ struct rfd {
 
 /* Struct to define some device statistics */
 struct ce_stats {
-	/* Link Input/Output stats */
-	uint64_t ipackets;	/* # of in packets */
-	uint64_t opackets;	/* # of out packets */
-
 	/* MIB II variables
 	 *
 	 * NOTE: atomic_t types are only guaranteed to store 24-bits; if we
@@ -242,7 +238,6 @@ struct et131x_adapter {
 	struct ce_stats stats;
 
 	struct net_device_stats net_stats;
-	struct net_device_stats net_stats_prev;
 };
 
 #endif /* __ET131X_ADAPTER_H__ */
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index c890d09..6bcddf1 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -88,22 +88,18 @@
 #include "et131x_adapter.h"
 #include "et131x.h"
 
-struct net_device_stats *et131x_stats(struct net_device *netdev);
-
 /**
  * et131x_stats - Return the current device statistics.
  * @netdev: device whose stats are being queried
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-struct net_device_stats *et131x_stats(struct net_device *netdev)
+static struct net_device_stats *et131x_stats(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 	struct net_device_stats *stats = &adapter->net_stats;
 	struct ce_stats *devstat = &adapter->stats;
 
-	stats->rx_packets = devstat->ipackets;
-	stats->tx_packets = devstat->opackets;
 	stats->rx_errors = devstat->length_err + devstat->alignment_err +
 	    devstat->crc_err + devstat->code_violations + devstat->other_errors;
 	stats->tx_errors = devstat->max_pkt_error;
-- 
1.7.4.4

