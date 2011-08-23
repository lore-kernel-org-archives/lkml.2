Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1HWWm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:42:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35482 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab1HWWmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:42:09 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/8] [RESEND] staging: et131x: Converting et1310_tx.c function and local names from CamelCase
Date: Tue, 23 Aug 2011 23:40:34 +0100
Message-Id: <1314139240-869-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314139240-869-1-git-send-email-mark.einon@gmail.com>
References: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
 <1314139240-869-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also some minor code clean-ups.
Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_tx.c      |  268 +++++++++++++++----------------
 drivers/staging/et131x/et131x.h         |    2 +-
 drivers/staging/et131x/et131x_initpci.c |    2 +-
 3 files changed, 132 insertions(+), 140 deletions(-)

diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index 8fb3051..da9b4af 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -88,12 +88,6 @@
 #include "et1310_tx.h"
 #include "et131x.h"
 
-static inline void et131x_free_send_packet(struct et131x_adapter *etdev,
-					   struct tcb *tcb);
-static int et131x_send_packet(struct sk_buff *skb,
-			      struct et131x_adapter *etdev);
-static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb);
-
 /**
  * et131x_tx_dma_memory_alloc
  * @adapter: pointer to our private adapter structure
@@ -186,13 +180,13 @@ void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 }
 
 /**
- * ConfigTxDmaRegs - Set up the tx dma section of the JAGCore.
+ * et131x_config_tx_dma_regs - Set up the tx dma section of the JAGCore.
  * @etdev: pointer to our private adapter structure
  *
  * Configure the transmit engine with the ring buffers we have created
  * and prepare it for use.
  */
-void ConfigTxDmaRegs(struct et131x_adapter *etdev)
+void et131x_config_tx_dma_regs(struct et131x_adapter *etdev)
 {
 	struct txdma_regs __iomem *txdma = &etdev->regs->txdma;
 
@@ -277,131 +271,6 @@ void et131x_init_send(struct et131x_adapter *adapter)
 }
 
 /**
- * et131x_send_packets - This function is called by the OS to send packets
- * @skb: the packet(s) to send
- * @netdev:device on which to TX the above packet(s)
- *
- * Return 0 in almost all cases; non-zero value in extreme hard failure only
- */
-int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
-{
-	int status = 0;
-	struct et131x_adapter *etdev = NULL;
-
-	etdev = netdev_priv(netdev);
-
-	/* Send these packets
-	 *
-	 * NOTE: The Linux Tx entry point is only given one packet at a time
-	 * to Tx, so the PacketCount and it's array used makes no sense here
-	 */
-
-	/* TCB is not available */
-	if (etdev->tx_ring.used >= NUM_TCB) {
-		/* NOTE: If there's an error on send, no need to queue the
-		 * packet under Linux; if we just send an error up to the
-		 * netif layer, it will resend the skb to us.
-		 */
-		status = -ENOMEM;
-	} else {
-		/* We need to see if the link is up; if it's not, make the
-		 * netif layer think we're good and drop the packet
-		 */
-		if ((etdev->flags & fMP_ADAPTER_FAIL_SEND_MASK) ||
-					!netif_carrier_ok(netdev)) {
-			dev_kfree_skb_any(skb);
-			skb = NULL;
-
-			etdev->net_stats.tx_dropped++;
-		} else {
-			status = et131x_send_packet(skb, etdev);
-			if (status != 0 && status != -ENOMEM) {
-				/* On any other error, make netif think we're
-				 * OK and drop the packet
-				 */
-				dev_kfree_skb_any(skb);
-				skb = NULL;
-				etdev->net_stats.tx_dropped++;
-			}
-		}
-	}
-	return status;
-}
-
-/**
- * et131x_send_packet - Do the work to send a packet
- * @skb: the packet(s) to send
- * @etdev: a pointer to the device's private adapter structure
- *
- * Return 0 in almost all cases; non-zero value in extreme hard failure only.
- *
- * Assumption: Send spinlock has been acquired
- */
-static int et131x_send_packet(struct sk_buff *skb,
-			      struct et131x_adapter *etdev)
-{
-	int status;
-	struct tcb *tcb = NULL;
-	u16 *shbufva;
-	unsigned long flags;
-
-	/* All packets must have at least a MAC address and a protocol type */
-	if (skb->len < ETH_HLEN)
-		return -EIO;
-
-	/* Get a TCB for this packet */
-	spin_lock_irqsave(&etdev->TCBReadyQLock, flags);
-
-	tcb = etdev->tx_ring.tcb_qhead;
-
-	if (tcb == NULL) {
-		spin_unlock_irqrestore(&etdev->TCBReadyQLock, flags);
-		return -ENOMEM;
-	}
-
-	etdev->tx_ring.tcb_qhead = tcb->next;
-
-	if (etdev->tx_ring.tcb_qhead == NULL)
-		etdev->tx_ring.tcb_qtail = NULL;
-
-	spin_unlock_irqrestore(&etdev->TCBReadyQLock, flags);
-
-	tcb->skb = skb;
-
-	if (skb->data != NULL && skb->len - skb->data_len >= 6) {
-		shbufva = (u16 *) skb->data;
-
-		if ((shbufva[0] == 0xffff) &&
-		    (shbufva[1] == 0xffff) && (shbufva[2] == 0xffff)) {
-			tcb->flags |= fMP_DEST_BROAD;
-		} else if ((shbufva[0] & 0x3) == 0x0001) {
-			tcb->flags |=  fMP_DEST_MULTI;
-		}
-	}
-
-	tcb->next = NULL;
-
-	/* Call the NIC specific send handler. */
-	status = nic_send_packet(etdev, tcb);
-
-	if (status != 0) {
-		spin_lock_irqsave(&etdev->TCBReadyQLock, flags);
-
-		if (etdev->tx_ring.tcb_qtail)
-			etdev->tx_ring.tcb_qtail->next = tcb;
-		else
-			/* Apparently ready Q is empty. */
-			etdev->tx_ring.tcb_qhead = tcb;
-
-		etdev->tx_ring.tcb_qtail = tcb;
-		spin_unlock_irqrestore(&etdev->TCBReadyQLock, flags);
-		return status;
-	}
-	WARN_ON(etdev->tx_ring.used > NUM_TCB);
-	return 0;
-}
-
-/**
  * nic_send_packet - NIC specific send handler for version B silicon.
  * @etdev: pointer to our adapter
  * @tcb: pointer to struct tcb
@@ -618,16 +487,139 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 	return 0;
 }
 
+/**
+ * send_packet - Do the work to send a packet
+ * @skb: the packet(s) to send
+ * @etdev: a pointer to the device's private adapter structure
+ *
+ * Return 0 in almost all cases; non-zero value in extreme hard failure only.
+ *
+ * Assumption: Send spinlock has been acquired
+ */
+static int send_packet(struct sk_buff *skb, struct et131x_adapter *etdev)
+{
+	int status;
+	struct tcb *tcb = NULL;
+	u16 *shbufva;
+	unsigned long flags;
+
+	/* All packets must have at least a MAC address and a protocol type */
+	if (skb->len < ETH_HLEN)
+		return -EIO;
+
+	/* Get a TCB for this packet */
+	spin_lock_irqsave(&etdev->TCBReadyQLock, flags);
+
+	tcb = etdev->tx_ring.tcb_qhead;
+
+	if (tcb == NULL) {
+		spin_unlock_irqrestore(&etdev->TCBReadyQLock, flags);
+		return -ENOMEM;
+	}
+
+	etdev->tx_ring.tcb_qhead = tcb->next;
+
+	if (etdev->tx_ring.tcb_qhead == NULL)
+		etdev->tx_ring.tcb_qtail = NULL;
+
+	spin_unlock_irqrestore(&etdev->TCBReadyQLock, flags);
+
+	tcb->skb = skb;
+
+	if (skb->data != NULL && skb->len - skb->data_len >= 6) {
+		shbufva = (u16 *) skb->data;
+
+		if ((shbufva[0] == 0xffff) &&
+		    (shbufva[1] == 0xffff) && (shbufva[2] == 0xffff)) {
+			tcb->flags |= fMP_DEST_BROAD;
+		} else if ((shbufva[0] & 0x3) == 0x0001) {
+			tcb->flags |=  fMP_DEST_MULTI;
+		}
+	}
+
+	tcb->next = NULL;
+
+	/* Call the NIC specific send handler. */
+	status = nic_send_packet(etdev, tcb);
+
+	if (status != 0) {
+		spin_lock_irqsave(&etdev->TCBReadyQLock, flags);
+
+		if (etdev->tx_ring.tcb_qtail)
+			etdev->tx_ring.tcb_qtail->next = tcb;
+		else
+			/* Apparently ready Q is empty. */
+			etdev->tx_ring.tcb_qhead = tcb;
+
+		etdev->tx_ring.tcb_qtail = tcb;
+		spin_unlock_irqrestore(&etdev->TCBReadyQLock, flags);
+		return status;
+	}
+	WARN_ON(etdev->tx_ring.used > NUM_TCB);
+	return 0;
+}
+
+/**
+ * et131x_send_packets - This function is called by the OS to send packets
+ * @skb: the packet(s) to send
+ * @netdev:device on which to TX the above packet(s)
+ *
+ * Return 0 in almost all cases; non-zero value in extreme hard failure only
+ */
+int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
+{
+	int status = 0;
+	struct et131x_adapter *etdev = NULL;
+
+	etdev = netdev_priv(netdev);
+
+	/* Send these packets
+	 *
+	 * NOTE: The Linux Tx entry point is only given one packet at a time
+	 * to Tx, so the PacketCount and it's array used makes no sense here
+	 */
+
+	/* TCB is not available */
+	if (etdev->tx_ring.used >= NUM_TCB) {
+		/* NOTE: If there's an error on send, no need to queue the
+		 * packet under Linux; if we just send an error up to the
+		 * netif layer, it will resend the skb to us.
+		 */
+		status = -ENOMEM;
+	} else {
+		/* We need to see if the link is up; if it's not, make the
+		 * netif layer think we're good and drop the packet
+		 */
+		if ((etdev->flags & fMP_ADAPTER_FAIL_SEND_MASK) ||
+					!netif_carrier_ok(netdev)) {
+			dev_kfree_skb_any(skb);
+			skb = NULL;
+
+			etdev->net_stats.tx_dropped++;
+		} else {
+			status = send_packet(skb, etdev);
+			if (status != 0 && status != -ENOMEM) {
+				/* On any other error, make netif think we're
+				 * OK and drop the packet
+				 */
+				dev_kfree_skb_any(skb);
+				skb = NULL;
+				etdev->net_stats.tx_dropped++;
+			}
+		}
+	}
+	return status;
+}
 
 /**
- * et131x_free_send_packet - Recycle a struct tcb
+ * free_send_packet - Recycle a struct tcb
  * @etdev: pointer to our adapter
  * @tcb: pointer to struct tcb
  *
  * Complete the packet if necessary
  * Assumption - Send spinlock has been acquired
  */
-inline void et131x_free_send_packet(struct et131x_adapter *etdev,
+static inline void free_send_packet(struct et131x_adapter *etdev,
 						struct tcb *tcb)
 {
 	unsigned long flags;
@@ -717,7 +709,7 @@ void et131x_free_busy_send_packets(struct et131x_adapter *etdev)
 		spin_unlock_irqrestore(&etdev->TCBSendQLock, flags);
 
 		freed++;
-		et131x_free_send_packet(etdev, tcb);
+		free_send_packet(etdev, tcb);
 
 		spin_lock_irqsave(&etdev->TCBSendQLock, flags);
 
@@ -766,7 +758,7 @@ void et131x_handle_send_interrupt(struct et131x_adapter *etdev)
 			etdev->tx_ring.send_tail = NULL;
 
 		spin_unlock_irqrestore(&etdev->TCBSendQLock, flags);
-		et131x_free_send_packet(etdev, tcb);
+		free_send_packet(etdev, tcb);
 		spin_lock_irqsave(&etdev->TCBSendQLock, flags);
 
 		/* Goto the next packet */
@@ -781,7 +773,7 @@ void et131x_handle_send_interrupt(struct et131x_adapter *etdev)
 			etdev->tx_ring.send_tail = NULL;
 
 		spin_unlock_irqrestore(&etdev->TCBSendQLock, flags);
-		et131x_free_send_packet(etdev, tcb);
+		free_send_packet(etdev, tcb);
 		spin_lock_irqsave(&etdev->TCBSendQLock, flags);
 
 		/* Goto the next packet */
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index fa42d94..91fafc0 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -137,7 +137,7 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *adapter);
 /* et131x_tx.c */
 int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter);
 void et131x_tx_dma_memory_free(struct et131x_adapter *adapter);
-void ConfigTxDmaRegs(struct et131x_adapter *adapter);
+void et131x_config_tx_dma_regs(struct et131x_adapter *adapter);
 void et131x_init_send(struct et131x_adapter *adapter);
 void et131x_tx_dma_disable(struct et131x_adapter *adapter);
 void et131x_tx_dma_enable(struct et131x_adapter *adapter);
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 09285b9..c217a05 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -389,7 +389,7 @@ int et131x_adapter_setup(struct et131x_adapter *etdev)
 	et1310_config_txmac_regs(etdev);
 
 	et131x_config_rx_dma_regs(etdev);
-	ConfigTxDmaRegs(etdev);
+	et131x_config_tx_dma_regs(etdev);
 
 	et1310_config_macstat_regs(etdev);
 
-- 
1.7.6

