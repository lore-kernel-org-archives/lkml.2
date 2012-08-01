Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab2HALsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 07:48:20 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55379 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab2HALsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 07:48:15 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-can@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Baltieri <fabio.baltieri@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH can-next v5 2/2] can: flexcan: add LED trigger support
Date: Wed,  1 Aug 2012 13:49:42 +0200
Message-Id: <1343821782-1346-2-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1343821782-1346-1-git-send-email-fabio.baltieri@gmail.com>
References: <5018F8B3.6080404@pengutronix.de>
 <1343821782-1346-1-git-send-email-fabio.baltieri@gmail.com>
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
index c5f1431..6467fc1 100644
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
@@ -547,6 +548,8 @@ static int flexcan_read_frame(struct net_device *dev)
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
 
+	can_led_event(dev, CAN_LED_EVENT_RX);
+
 	return 1;
 }
 
@@ -635,6 +638,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev_id)
 	if (reg_iflag1 & (1 << FLEXCAN_TX_BUF_ID)) {
 		stats->tx_bytes += can_get_echo_skb(dev, 0);
 		stats->tx_packets++;
+		can_led_event(dev, CAN_LED_EVENT_TX);
 		flexcan_write((1 << FLEXCAN_TX_BUF_ID), &regs->iflag1);
 		netif_wake_queue(dev);
 	}
@@ -844,6 +848,9 @@ static int flexcan_open(struct net_device *dev)
 	err = flexcan_chip_start(dev);
 	if (err)
 		goto out_close;
+
+	can_led_event(dev, CAN_LED_EVENT_OPEN);
+
 	napi_enable(&priv->napi);
 	netif_start_queue(dev);
 
@@ -872,6 +879,8 @@ static int flexcan_close(struct net_device *dev)
 
 	close_candev(dev);
 
+	can_led_event(dev, CAN_LED_EVENT_STOP);
+
 	return 0;
 }
 
@@ -1068,6 +1077,8 @@ static int __devinit flexcan_probe(struct platform_device *pdev)
 		goto failed_register;
 	}
 
+	devm_can_led_init(dev);
+
 	dev_info(&pdev->dev, "device registered (reg_base=%p, irq=%d)\n",
 		 priv->base, dev->irq);
 
-- 
1.7.11.rc1.9.gf623ca1.dirty

