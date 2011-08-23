Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1HWWmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:42:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46846 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab1HWWmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:42:21 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 8/8] staging: et131x: Update tx trans_start on device close to prevent tx_timeout
Date: Tue, 23 Aug 2011 23:40:40 +0100
Message-Id: <1314139240-869-9-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314139240-869-1-git-send-email-mark.einon@gmail.com>
References: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
 <1314139240-869-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating the tx trans_start before closing the device prevents a possible tx_timeout occuring during the closing process.
Tested on an ET1310 device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_netdev.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 70a0da3..7555a24 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -153,7 +153,7 @@ int et131x_open(struct net_device *netdev)
 	result = request_irq(netdev->irq, et131x_isr, IRQF_SHARED,
 					netdev->name, netdev);
 	if (result) {
-		dev_err(&adapter->pdev->dev, "c ould not register IRQ %d\n",
+		dev_err(&adapter->pdev->dev, "could not register IRQ %d\n",
 			netdev->irq);
 		return result;
 	}
@@ -182,6 +182,9 @@ int et131x_close(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
+	/* Save the timestamp for the TX watchdog, prevent a timeout */
+	netdev->trans_start = jiffies;
+
 	/* First thing is to stop the queue */
 	netif_stop_queue(netdev);
 
@@ -449,6 +452,10 @@ void et131x_tx_timeout(struct net_device *netdev)
 	struct tcb *tcb;
 	unsigned long flags;
 
+	/* If the device is closed, ignore the timeout */
+	if (~(adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE));
+		return;
+
 	/* Any nonrecoverable hardware error?
 	 * Checks adapter->flags for any failure in phy reading
 	 */
@@ -685,12 +692,12 @@ struct net_device *et131x_device_alloc(void)
 		return NULL;
 	}
 
-	/* Setup the function registration table (and other data) for a
+	/*
+	 * Setup the function registration table (and other data) for a
 	 * net_device
 	 */
-
 	netdev->watchdog_timeo = ET131X_TX_TIMEOUT;
-	netdev->netdev_ops = &et131x_netdev_ops;
+	netdev->netdev_ops     = &et131x_netdev_ops;
 
 	/* netdev->ethtool_ops        = &et131x_ethtool_ops; */
 
-- 
1.7.6

