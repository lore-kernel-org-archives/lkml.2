Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab1GCRJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 13:09:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37576 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1GCRJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 13:09:02 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/2] staging: et131x: Fix stats->rx_packets accounting
Date: Sun,  3 Jul 2011 18:08:22 +0100
Message-Id: <1309712903-11570-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The net_device_stats->rx_packets counter is not getting updated.
This is due to checking a fMP_ADAPTER_LINK_DETECTION flag prior to
updating which is never set.

Solved by using netif_carrier_ok() to test for a link, and removing
the fMP_ADAPTER_LINK_DETECTION flag, which looks to be a broken
mechanism.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |    4 +---
 drivers/staging/et131x/et1310_rx.c      |    5 ++---
 drivers/staging/et131x/et131x_defs.h    |    1 -
 drivers/staging/et131x/et131x_initpci.c |    1 -
 drivers/staging/et131x/et131x_netdev.c  |    4 ----
 5 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 1df0d05..f88b204 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -750,7 +750,6 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 			spin_lock_irqsave(&etdev->Lock, flags);
 
 			etdev->MediaState = NETIF_STATUS_MEDIA_CONNECT;
-			etdev->Flags &= ~fMP_ADAPTER_LINK_DETECTION;
 
 			spin_unlock_irqrestore(&etdev->Lock, flags);
 
@@ -780,8 +779,7 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 			 * Timer expires, we can report disconnected (handled
 			 * in the LinkDetectionDPC).
 			 */
-			if (!(etdev->Flags & fMP_ADAPTER_LINK_DETECTION) ||
-			 (etdev->MediaState == NETIF_STATUS_MEDIA_DISCONNECT)) {
+			if ((etdev->MediaState == NETIF_STATUS_MEDIA_DISCONNECT)) {
 				spin_lock_irqsave(&etdev->Lock, flags);
 				etdev->MediaState =
 				    NETIF_STATUS_MEDIA_DISCONNECT;
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 100ee9b4..6c0a64b 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -1126,10 +1126,9 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 		 * Free buffer ring.
 		 */
 		if (!etdev->PacketFilter ||
-		    !(etdev->Flags & fMP_ADAPTER_LINK_DETECTION) ||
-		    rfd->len == 0) {
+		    !netif_carrier_ok(etdev->netdev) ||
+		    rfd->len == 0)
 			continue;
-		}
 
 		/* Increment the number of packets we received */
 		etdev->stats.ipackets++;
diff --git a/drivers/staging/et131x/et131x_defs.h b/drivers/staging/et131x/et131x_defs.h
index d81fc77..3d5193f 100644
--- a/drivers/staging/et131x/et131x_defs.h
+++ b/drivers/staging/et131x/et131x_defs.h
@@ -95,7 +95,6 @@
 #define fMP_ADAPTER_HARDWARE_ERROR	0x04000000
 #define fMP_ADAPTER_REMOVE_IN_PROGRESS	0x08000000
 #define fMP_ADAPTER_HALT_IN_PROGRESS	0x10000000
-#define fMP_ADAPTER_LINK_DETECTION	0x20000000
 
 #define fMP_ADAPTER_FAIL_SEND_MASK	0x3ff00000
 #define fMP_ADAPTER_NOT_READY_MASK	0x3ff00000
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 1dd2e5e..a9d2521 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -312,7 +312,6 @@ void et131x_link_detection_handler(unsigned long data)
 		spin_lock_irqsave(&etdev->Lock, flags);
 
 		etdev->MediaState = NETIF_STATUS_MEDIA_DISCONNECT;
-		etdev->Flags &= ~fMP_ADAPTER_LINK_DETECTION;
 
 		spin_unlock_irqrestore(&etdev->Lock, flags);
 
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 2da5828..c890d09 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -450,10 +450,6 @@ void et131x_tx_timeout(struct net_device *netdev)
 	struct tcb *tcb;
 	unsigned long flags;
 
-	/* Just skip this part if the adapter is doing link detection */
-	if (etdev->Flags & fMP_ADAPTER_LINK_DETECTION)
-		return;
-
 	/* Any nonrecoverable hardware error?
 	 * Checks adapter->flags for any failure in phy reading
 	 */
-- 
1.7.4.4

