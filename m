Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2LPLJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 06:09:47 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38531 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2LPLJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 06:09:44 -0500
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH 2/9] can: flexcan: add LED trigger support
Date: Sun, 16 Dec 2012 12:08:26 +0100
Message-Id: <1355656113-9562-3-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for canbus activity led indicators on flexcan devices by
calling appropriate can_led_* functions.

These are only enabled when CONFIG_CAN_LEDS is Y, becomes no-op
otherwise.

Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 drivers/net/can/flexcan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 0289a6d..769d29e 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -23,6 +23,7 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
+#include <linux/can/led.h>
 #include <linux/can/platform/flexcan.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
@@ -564,6 +565,8 @@ static int flexcan_read_frame(struct net_device *dev)
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
 
+	can_led_event(dev, CAN_LED_EVENT_RX);
+
 	return 1;
 }
 
@@ -652,6 +655,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 	if (reg_iflag1 & (1 << FLEXCAN_TX_BUF_ID)) {
 		stats->tx_bytes += can_get_echo_skb(dev, 0);
 		stats->tx_packets++;
+		can_led_event(dev, CAN_LED_EVENT_TX);
 		flexcan_write((1 << FLEXCAN_TX_BUF_ID), &regs->iflag1);
 		netif_wake_queue(dev);
 	}
@@ -865,6 +869,9 @@ static int flexcan_open(struct net_device *dev)
 	err = flexcan_chip_start(dev);
 	if (err)
 		goto out_close;
+
+	can_led_event(dev, CAN_LED_EVENT_OPEN);
+
 	napi_enable(&priv->napi);
 	netif_start_queue(dev);
 
@@ -893,6 +900,8 @@ static int flexcan_close(struct net_device *dev)
 
 	close_candev(dev);
 
+	can_led_event(dev, CAN_LED_EVENT_STOP);
+
 	return 0;
 }
 
@@ -1092,6 +1101,8 @@ static int flexcan_probe(struct platform_device *pdev)
 		goto failed_register;
 	}
 
+	devm_can_led_init(dev);
+
 	dev_info(&pdev->dev, "device registered (reg_base=%p, irq=%d)\n",
 		 priv->base, dev->irq);
 
-- 
1.7.12.1

