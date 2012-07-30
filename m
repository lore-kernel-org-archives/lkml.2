Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2G3TTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:19:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34522 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2G3TTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:19:38 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-can@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH can-next v3 2/2] can: flexcan: add LED trigger support
Date: Mon, 30 Jul 2012 21:20:41 +0200
Message-Id: <1343676041-29572-2-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1343676041-29572-1-git-send-email-fabio.baltieri@gmail.com>
References: <1343676041-29572-1-git-send-email-fabio.baltieri@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for canbus activity led indicators on flexcan devices by
calling appropriate can_led_* functions.

These are only enabled when CONFIG_CAN_LEDS is Y, becomes no-op
otherwise.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 drivers/net/can/flexcan.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index c5f1431..4816ed0 100644
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
 
+	can_led_init(dev);
+
 	dev_info(&pdev->dev, "device registered (reg_base=%p, irq=%d)\n",
 		 priv->base, dev->irq);
 
@@ -1091,6 +1102,8 @@ static int __devexit flexcan_remove(struct platform_device *pdev)
 	struct flexcan_priv *priv = netdev_priv(dev);
 	struct resource *mem;
 
+	can_led_exit(dev);
+
 	unregister_flexcandev(dev);
 	platform_set_drvdata(pdev, NULL);
 	iounmap(priv->base);
-- 
1.7.11.rc1.9.gf623ca1.dirty

