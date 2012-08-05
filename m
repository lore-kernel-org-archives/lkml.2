Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2HEOux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 10:50:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38011 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab2HEOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 10:50:17 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-can@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Baltieri <fabio.baltieri@gmail.com>,
        Christian Pellegrin <chripell@fsfe.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH can-next 4/5] can: mcp251x: add LED trigger support
Date: Sun,  5 Aug 2012 16:51:49 +0200
Message-Id: <1344178310-2898-4-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1344178310-2898-1-git-send-email-fabio.baltieri@gmail.com>
References: <20120805144814.GA2804@gmail.com>
 <1344178310-2898-1-git-send-email-fabio.baltieri@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for canbus activity led indicators on mcp251x devices by
calling appropriate can_led functions.

These are only enabled when CONFIG_CAN_LEDS is Y, becomes no-op
otherwise.

Cc: Christian Pellegrin <chripell@fsfe.org>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 drivers/net/can/mcp251x.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/mcp251x.c b/drivers/net/can/mcp251x.c
index a580db2..128235e 100644
--- a/drivers/net/can/mcp251x.c
+++ b/drivers/net/can/mcp251x.c
@@ -60,6 +60,7 @@
 
 #include <linux/can/core.h>
 #include <linux/can/dev.h>
+#include <linux/can/led.h>
 #include <linux/can/platform/mcp251x.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -485,6 +486,9 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
 
 	priv->net->stats.rx_packets++;
 	priv->net->stats.rx_bytes += frame->can_dlc;
+
+	can_led_event(priv->net, CAN_LED_EVENT_RX);
+
 	netif_rx_ni(skb);
 }
 
@@ -698,6 +702,8 @@ static int mcp251x_stop(struct net_device *net)
 
 	mutex_unlock(&priv->mcp_lock);
 
+	can_led_event(net, CAN_LED_EVENT_STOP);
+
 	return 0;
 }
 
@@ -896,6 +902,7 @@ static irqreturn_t mcp251x_can_ist(int irq, void *dev_id)
 		if (intf & CANINTF_TX) {
 			net->stats.tx_packets++;
 			net->stats.tx_bytes += priv->tx_len - 1;
+			can_led_event(net, CAN_LED_EVENT_TX);
 			if (priv->tx_len) {
 				can_get_echo_skb(net, 0);
 				priv->tx_len = 0;
@@ -959,6 +966,9 @@ static int mcp251x_open(struct net_device *net)
 		mcp251x_open_clean(net);
 		goto open_unlock;
 	}
+
+	can_led_event(net, CAN_LED_EVENT_OPEN);
+
 	netif_wake_queue(net);
 
 open_unlock:
@@ -1068,10 +1078,15 @@ static int __devinit mcp251x_can_probe(struct spi_device *spi)
 		pdata->transceiver_enable(0);
 
 	ret = register_candev(net);
-	if (!ret) {
-		dev_info(&spi->dev, "probed\n");
-		return ret;
-	}
+	if (ret)
+		goto error_probe;
+
+	devm_can_led_init(net);
+
+	dev_info(&spi->dev, "probed\n");
+
+	return ret;
+
 error_probe:
 	if (!mcp251x_enable_dma)
 		kfree(priv->spi_rx_buf);
-- 
1.7.11.rc1.9.gf623ca1.dirty

