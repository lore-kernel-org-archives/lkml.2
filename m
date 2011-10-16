Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1JPMHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 08:07:45 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63172 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1JPMHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 08:07:41 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/4] staging: et131x: on transmit, stop the queue if the next packet will fail
Date: Sun, 16 Oct 2011 13:06:13 +0100
Message-Id: <1318766775-2517-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318766775-2517-1-git-send-email-mark.einon@gmail.com>
References: <1318766775-2517-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Currently the tx queue is only stopped when the current packet fails.
Check if the next packet will fail, and stop the queue if so.

* Removed associated item from TODO list in the README.

* Also minor fixup as adapter was being declared as null and immediately set
to a value.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/README   |    1 -
 drivers/staging/et131x/et131x.c |   13 ++++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/et131x/README b/drivers/staging/et131x/README
index 0928eb5..3458aa7 100644
--- a/drivers/staging/et131x/README
+++ b/drivers/staging/et131x/README
@@ -9,7 +9,6 @@ driver as they did not build properly at the time.
 
 TODO:
 	- Use of kmem_cache seems a bit unusual
-	- It's too late stopping the tx queue when there is no room for the current packet. The condition should be detected for the next packet.
 
 Please send patches to:
 	Greg Kroah-Hartman <gregkh@suse.de>
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index cc41111..993f93a 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3448,9 +3448,7 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *adapter)
 int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
 {
 	int status = 0;
-	struct et131x_adapter *adapter = NULL;
-
-	adapter = netdev_priv(netdev);
+	struct et131x_adapter *adapter = netdev_priv(netdev);
 
 	/* Send these packets
 	 *
@@ -5347,6 +5345,11 @@ static void et131x_multicast(struct net_device *netdev)
 static int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
 {
 	int status = 0;
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	/* stop the queue if it's getting full */
+	if(adapter->tx_ring.used >= NUM_TCB - 1 && !netif_queue_stopped(netdev))
+		netif_stop_queue(netdev);
 
 	/* Save the timestamp for the TX timeout watchdog */
 	netdev->trans_start = jiffies;
@@ -5357,10 +5360,6 @@ static int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
 	/* Check status and manage the netif queue if necessary */
 	if (status != 0) {
 		if (status == -ENOMEM) {
-			/* Put the queue to sleep until resources are
-			 * available
-			 */
-			netif_stop_queue(netdev);
 			status = NETDEV_TX_BUSY;
 		} else {
 			status = NETDEV_TX_OK;
-- 
1.7.6.4

