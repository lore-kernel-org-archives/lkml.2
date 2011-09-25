Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1IYSTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 14:19:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37691 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1IYST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 14:19:28 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 4/6] staging: et131x: Create et131x_[dis|en]able_txrx() calls
Date: Sun, 25 Sep 2011 19:17:55 +0100
Message-Id: <1316974677-17108-4-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316974677-17108-1-git-send-email-mark.einon@gmail.com>
References: <1316974677-17108-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In et131x_netdev.c, a series of calls to enable and diasble the rx/tx engine and queue are being used in several different places.
Create two functions to encapsulate these calls, and replace many calls with just the one.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.h        |    2 +
 drivers/staging/et131x/et131x_netdev.c |  126 ++++++++++++--------------------
 2 files changed, 50 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index f52fa18..6f8fef6 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -83,6 +83,8 @@ void et1310_setup_device_for_unicast(struct et131x_adapter *adapter);
 
 /* et131x_netdev.c */
 struct net_device *et131x_device_alloc(void);
+void et131x_enable_txrx(struct net_device *netdev);
+void et131x_disable_txrx(struct net_device *netdev);
 
 /* et1310_pm.c */
 void et1310_enable_phy_coma(struct et131x_adapter *adapter);
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 5fb4056..6ec4a0f 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -137,6 +137,45 @@ static struct net_device_stats *et131x_stats(struct net_device *netdev)
 }
 
 /**
+ * et131x_enable_txrx - Enable tx/rx queues
+ * @netdev: device to be enabled
+ */
+void et131x_enable_txrx(struct net_device *netdev)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	/* Enable the Tx and Rx DMA engines (if not already enabled) */
+	et131x_rx_dma_enable(adapter);
+	et131x_tx_dma_enable(adapter);
+
+	/* Enable device interrupts */
+	if (adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE)
+		et131x_enable_interrupts(adapter);
+
+	/* We're ready to move some data, so start the queue */
+	netif_start_queue(netdev);
+}
+
+/**
+ * et131x_disable_txrx - Disable tx/rx queues
+ * @netdev: device to be disabled
+ */
+void et131x_disable_txrx(struct net_device *netdev)
+{
+	struct et131x_adapter *adapter = netdev_priv(netdev);
+
+	/* First thing is to stop the queue */
+	netif_stop_queue(netdev);
+
+	/* Stop the Tx and Rx DMA engines */
+	et131x_rx_dma_disable(adapter);
+	et131x_tx_dma_disable(adapter);
+
+	/* Disable device interrupts */
+	et131x_disable_interrupts(adapter);
+}
+
+/**
  * et131x_open - Open the device for use.
  * @netdev: device to be opened
  *
@@ -159,19 +198,10 @@ int et131x_open(struct net_device *netdev)
 		return result;
 	}
 
-	/* Enable the Tx and Rx DMA engines (if not already enabled) */
-	et131x_rx_dma_enable(adapter);
-	et131x_tx_dma_enable(adapter);
-
-	/* Enable device interrupts */
-	et131x_enable_interrupts(adapter);
-
 	adapter->flags |= fMP_ADAPTER_INTERRUPT_IN_USE;
-
+	et131x_enable_txrx(netdev);
 	phy_start(adapter->phydev);
 
-	/* We're ready to move some data, so start the queue */
-	netif_start_queue(netdev);
 	return result;
 }
 
@@ -188,15 +218,7 @@ int et131x_close(struct net_device *netdev)
 	/* Save the timestamp for the TX watchdog, prevent a timeout */
 	netdev->trans_start = jiffies;
 
-	/* First thing is to stop the queue */
-	netif_stop_queue(netdev);
-
-	/* Stop the Tx and Rx DMA engines */
-	et131x_rx_dma_disable(adapter);
-	et131x_tx_dma_disable(adapter);
-
-	/* Disable device interrupts */
-	et131x_disable_interrupts(adapter);
+	et131x_disable_txrx(netdev);
 
 	/* Deregistering ISR */
 	adapter->flags &= ~fMP_ADAPTER_INTERRUPT_IN_USE;
@@ -442,29 +464,9 @@ void et131x_tx_timeout(struct net_device *netdev)
 
 			adapter->net_stats.tx_errors++;
 
-			/* perform reset */
-			/* First thing is to stop the queue */
-			netif_stop_queue(netdev);
-
-			/* Stop the Tx and Rx DMA engines */
-			et131x_rx_dma_disable(adapter);
-			et131x_tx_dma_disable(adapter);
-
-			/* Disable device interrupts */
-			et131x_disable_interrupts(adapter);
-
-			/*
-			 * Enable the Tx and Rx DMA engines
-			 * (if not already enabled)
-			 */
-			et131x_rx_dma_enable(adapter);
-			et131x_tx_dma_enable(adapter);
-
-			/* Enable device interrupts */
-			et131x_enable_interrupts(adapter);
-
-			/* We're ready to move some data, so start the queue */
-			netif_start_queue(netdev);
+			/* perform reset of tx/rx */
+			et131x_disable_txrx(netdev);
+			et131x_enable_txrx(netdev);
 			return;
 		}
 	}
@@ -488,15 +490,7 @@ int et131x_change_mtu(struct net_device *netdev, int new_mtu)
 	if (new_mtu < 64 || new_mtu > 9216)
 		return -EINVAL;
 
-	/* Stop the netif queue */
-	netif_stop_queue(netdev);
-
-	/* Stop the Tx and Rx DMA engines */
-	et131x_rx_dma_disable(adapter);
-	et131x_tx_dma_disable(adapter);
-
-	/* Disable device interrupts */
-	et131x_disable_interrupts(adapter);
+	et131x_disable_txrx(netdev);
 	et131x_handle_send_interrupt(adapter);
 	et131x_handle_recv_interrupt(adapter);
 
@@ -526,16 +520,8 @@ int et131x_change_mtu(struct net_device *netdev, int new_mtu)
 	/* Init the device with the new settings */
 	et131x_adapter_setup(adapter);
 
-	/* Enable interrupts */
-	if (adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE)
-		et131x_enable_interrupts(adapter);
+	et131x_enable_txrx(netdev);
 
-	/* Restart the Tx and Rx DMA engines */
-	et131x_rx_dma_enable(adapter);
-	et131x_tx_dma_enable(adapter);
-
-	/* Restart the netif queue */
-	netif_wake_queue(netdev);
 	return result;
 }
 
@@ -563,15 +549,7 @@ int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
 	if (!is_valid_ether_addr(address->sa_data))
 		return -EINVAL;
 
-	/* Stop the netif queue */
-	netif_stop_queue(netdev);
-
-	/* Stop the Tx and Rx DMA engines */
-	et131x_rx_dma_disable(adapter);
-	et131x_tx_dma_disable(adapter);
-
-	/* Disable device interrupts */
-	et131x_disable_interrupts(adapter);
+	et131x_disable_txrx(netdev);
 	et131x_handle_send_interrupt(adapter);
 	et131x_handle_recv_interrupt(adapter);
 
@@ -603,16 +581,8 @@ int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
 	/* Init the device with the new settings */
 	et131x_adapter_setup(adapter);
 
-	/* Enable interrupts */
-	if (adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE)
-		et131x_enable_interrupts(adapter);
-
-	/* Restart the Tx and Rx DMA engines */
-	et131x_rx_dma_enable(adapter);
-	et131x_tx_dma_enable(adapter);
+	et131x_enable_txrx(netdev);
 
-	/* Restart the netif queue */
-	netif_wake_queue(netdev);
 	return result;
 }
 
-- 
1.7.6

