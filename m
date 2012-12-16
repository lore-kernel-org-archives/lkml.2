Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2LPLKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 06:10:03 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40100 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2LPLKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 06:10:00 -0500
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH 7/9] can: sja1000: add LED trigger support
Date: Sun, 16 Dec 2012 12:08:31 +0100
Message-Id: <1355656113-9562-8-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
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
index 83ee11e..daf4013 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -60,6 +60,7 @@
 
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
+#include <linux/can/led.h>
 
 #include "sja1000.h"
 
@@ -368,6 +369,8 @@ static void sja1000_rx(struct net_device *dev)
 
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
+
+	can_led_event(dev, CAN_LED_EVENT_RX);
 }
 
 static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
@@ -521,6 +524,7 @@ irqreturn_t sja1000_interrupt(int irq, void *dev_id)
 				can_get_echo_skb(dev, 0);
 			}
 			netif_wake_queue(dev);
+			can_led_event(dev, CAN_LED_EVENT_TX);
 		}
 		if (isrc & IRQ_RI) {
 			/* receive interrupt */
@@ -575,6 +579,8 @@ static int sja1000_open(struct net_device *dev)
 	/* init and start chi */
 	sja1000_start(dev);
 
+	can_led_event(dev, CAN_LED_EVENT_OPEN);
+
 	netif_start_queue(dev);
 
 	return 0;
@@ -592,6 +598,8 @@ static int sja1000_close(struct net_device *dev)
 
 	close_candev(dev);
 
+	can_led_event(dev, CAN_LED_EVENT_STOP);
+
 	return 0;
 }
 
@@ -639,6 +647,8 @@ static const struct net_device_ops sja1000_netdev_ops = {
 
 int register_sja1000dev(struct net_device *dev)
 {
+	int ret;
+
 	if (!sja1000_probe_chip(dev))
 		return -ENODEV;
 
@@ -648,7 +658,12 @@ int register_sja1000dev(struct net_device *dev)
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
1.7.12.1

