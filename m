Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2HEOuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 10:50:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58632 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2HEOuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 10:50:19 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-can@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Baltieri <fabio.baltieri@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH can-next 5/5] can: sja1000: add LED trigger support
Date: Sun,  5 Aug 2012 16:51:50 +0200
Message-Id: <1344178310-2898-5-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1344178310-2898-1-git-send-email-fabio.baltieri@gmail.com>
References: <20120805144814.GA2804@gmail.com>
 <1344178310-2898-1-git-send-email-fabio.baltieri@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for canbus activity led indicators on sja1000 devices by
calling appropriate can_led functions.

These are only enabled when CONFIG_CAN_LEDS is Y, becomes no-op
otherwise.

Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 drivers/net/can/sja1000/sja1000.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 4c4f33d..bf2721c 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -60,6 +60,7 @@
 
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
+#include <linux/can/led.h>
 
 #include "sja1000.h"
 
@@ -365,6 +366,8 @@ static void sja1000_rx(struct net_device *dev)
 
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
+
+	can_led_event(dev, CAN_LED_EVENT_RX);
 }
 
 static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
@@ -510,6 +513,7 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 			stats->tx_packets++;
 			can_get_echo_skb(dev, 0);
 			netif_wake_queue(dev);
+			can_led_event(dev, CAN_LED_EVENT_TX);
 		}
 		if (isrc & IRQ_RI) {
 			/* receive interrupt */
@@ -565,6 +569,8 @@ static int sja1000_open(struct net_device *dev)
 	sja1000_start(dev);
 	priv->open_time = jiffies;
 
+	can_led_event(dev, CAN_LED_EVENT_OPEN);
+
 	netif_start_queue(dev);
 
 	return 0;
@@ -584,6 +590,8 @@ static int sja1000_close(struct net_device *dev)
 
 	priv->open_time = 0;
 
+	can_led_event(dev, CAN_LED_EVENT_STOP);
+
 	return 0;
 }
 
@@ -630,6 +638,8 @@ static const struct net_device_ops sja1000_netdev_ops = {
 
 int register_sja1000dev(struct net_device *dev)
 {
+	int ret;
+
 	if (!sja1000_probe_chip(dev))
 		return -ENODEV;
 
@@ -639,7 +649,12 @@ int register_sja1000dev(struct net_device *dev)
 	set_reset_mode(dev);
 	chipset_init(dev);
 
-	return register_candev(dev);
+	ret =  register_candev(dev);
+
+	if (!ret)
+		devm_can_led_init(dev);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(register_sja1000dev);
 
-- 
1.7.11.rc1.9.gf623ca1.dirty

