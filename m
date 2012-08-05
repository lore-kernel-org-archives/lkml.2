Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab2HEOt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 10:49:57 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62438 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2HEOt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 10:49:56 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-can@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Baltieri <fabio.baltieri@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH can-next 1/5] can: at91_can: add LED trigger support
Date: Sun,  5 Aug 2012 16:51:46 +0200
Message-Id: <1344178310-2898-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <20120805144814.GA2804@gmail.com>
References: <20120805144814.GA2804@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for canbus activity led indicators on at91_can devices by
calling appropriate can_led functions.

These are only enabled when CONFIG_CAN_LEDS is Y, becomes no-op
otherwise.

Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 drivers/net/can/at91_can.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index fcff73a..b496bff 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -36,6 +36,7 @@
 
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
+#include <linux/can/led.h>
 
 #include <mach/board.h>
 
@@ -642,6 +643,8 @@ static void at91_read_msg(struct net_device *dev, unsigned int mb)
 
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
+
+	can_led_event(dev, CAN_LED_EVENT_RX);
 }
 
 /**
@@ -876,6 +879,7 @@ static void at91_irq_tx(struct net_device *dev, u32 reg_sr)
 			/* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
 			can_get_echo_skb(dev, mb - get_mb_tx_first(priv));
 			dev->stats.tx_packets++;
+			can_led_event(dev, CAN_LED_EVENT_TX);
 		}
 	}
 
@@ -1129,6 +1133,8 @@ static int at91_open(struct net_device *dev)
 		goto out_close;
 	}
 
+	can_led_event(dev, CAN_LED_EVENT_OPEN);
+
 	/* start chip and queuing */
 	at91_chip_start(dev);
 	napi_enable(&priv->napi);
@@ -1160,6 +1166,8 @@ static int at91_close(struct net_device *dev)
 
 	close_candev(dev);
 
+	can_led_event(dev, CAN_LED_EVENT_STOP);
+
 	return 0;
 }
 
@@ -1322,6 +1330,8 @@ static int __devinit at91_can_probe(struct platform_device *pdev)
 		goto exit_free;
 	}
 
+	devm_can_led_init(dev);
+
 	dev_info(&pdev->dev, "device registered (reg_base=%p, irq=%d)\n",
 		 priv->reg_base, dev->irq);
 
-- 
1.7.11.rc1.9.gf623ca1.dirty

