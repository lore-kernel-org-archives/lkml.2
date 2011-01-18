Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1ARALR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 19:11:17 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:36989 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab1ARALQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 19:11:16 -0500
Date: Mon, 17 Jan 2011 16:11:12 -0800
From: Andres Salomon <dilinger@queued.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Subject: [PATCH resend] staging: fix build failure in bcm driver
Message-ID: <20110117161112.5ec5991a@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While building latest Linus git, I hit the following:

  CC [M]  drivers/staging/bcm/Qos.o
drivers/staging/bcm/Qos.c: In function ‘PruneQueue’:
drivers/staging/bcm/Qos.c:367: error: ‘struct netdev_queue’ has no member named ‘tx_dropped’
drivers/staging/bcm/Qos.c: In function ‘flush_all_queues’:
drivers/staging/bcm/Qos.c:416: error: ‘struct netdev_queue’ has no member named ‘tx_dropped’
make[5]: *** [drivers/staging/bcm/Qos.o] Error 1
make[4]: *** [drivers/staging/bcm] Error 2
make[3]: *** [drivers/staging] Error 2

As well as:

  CC [M]  drivers/staging/bcm/Transmit.o
drivers/staging/bcm/Transmit.c: In function ‘SetupNextSend’:
drivers/staging/bcm/Transmit.c:163: error: ‘struct netdev_queue’ has no member named ‘tx_bytes’
drivers/staging/bcm/Transmit.c:164: error: ‘struct netdev_queue’ has no member named ‘tx_packets’
make[2]: *** [drivers/staging/bcm/Transmit.o] Error 1


tx_dropped/tx_bytes_tx_packets were removed in commit 1ac9ad13.  This patch
converts bcm to use net_device_stats instead of netdev_queue.

Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/bcm/Qos.c      |    7 +++----
 drivers/staging/bcm/Transmit.c |    6 +++---
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index 8ce4536..feade94 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -359,12 +359,11 @@ static VOID PruneQueue(PMINI_ADAPTER Adapter, INT iIndex)
 
 		if(PacketToDrop)
 		{
-			struct netdev_queue *txq = netdev_get_tx_queue(Adapter->dev, iIndex);
 			if (netif_msg_tx_err(Adapter))
 				pr_info(PFX "%s: tx queue %d overlimit\n", 
 					Adapter->dev->name, iIndex);
 
-			txq->tx_dropped++;
+			netstats->tx_dropped++;
 
 			DEQUEUEPACKET(Adapter->PackInfo[iIndex].FirstTxQueue,
 						Adapter->PackInfo[iIndex].LastTxQueue);
@@ -404,7 +403,7 @@ VOID flush_all_queues(PMINI_ADAPTER Adapter)
 //	down(&Adapter->data_packet_queue_lock);
 	for(iQIndex=LowPriority; iQIndex<HiPriority; iQIndex++)
 	{
-		struct netdev_queue *txq = netdev_get_tx_queue(Adapter->dev, iQIndex);
+		struct net_device_stats *netstats = &Adapter->dev->stats;
 
 		spin_lock_bh(&Adapter->PackInfo[iQIndex].SFQueueLock);
 		while(Adapter->PackInfo[iQIndex].FirstTxQueue)
@@ -413,7 +412,7 @@ VOID flush_all_queues(PMINI_ADAPTER Adapter)
 			if(PacketToDrop)
 			{
 				uiTotalPacketLength = PacketToDrop->len;
-				txq->tx_dropped++;
+				netstats->tx_dropped++;
 			}
 			else
 				uiTotalPacketLength = 0;
diff --git a/drivers/staging/bcm/Transmit.c b/drivers/staging/bcm/Transmit.c
index 0f70009..d5e4a74 100644
--- a/drivers/staging/bcm/Transmit.c
+++ b/drivers/staging/bcm/Transmit.c
@@ -157,11 +157,11 @@ INT SetupNextSend(PMINI_ADAPTER Adapter,  struct sk_buff *Packet, USHORT Vcid)
 	}
 	else
 	{
-		struct netdev_queue *txq = netdev_get_tx_queue(Adapter->dev, QueueIndex);
+		struct net_device_stats *netstats = &Adapter->dev->stats;
 		Adapter->PackInfo[QueueIndex].uiTotalTxBytes += Leader.PLength;
 
-		txq->tx_bytes += Leader.PLength;
-		++txq->tx_packets;
+		netstats->tx_bytes += Leader.PLength;
+		++netstats->tx_packets;
 
 		Adapter->PackInfo[QueueIndex].uiCurrentTokenCount -= Leader.PLength << 3;
 		Adapter->PackInfo[QueueIndex].uiSentBytes += (Packet->len);
-- 
1.7.2.3

