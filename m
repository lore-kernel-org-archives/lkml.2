Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2LPLJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 06:09:50 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60666 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab2LPLJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 06:09:47 -0500
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH 3/9] can: at91_can: add LED trigger support
Date: Sun, 16 Dec 2012 12:08:27 +0100
Message-Id: <1355656113-9562-4-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
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
index 81baefd..44f3637 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -37,6 +37,7 @@
 
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
+#include <linux/can/led.h>
 
 #define AT91_MB_MASK(i)		((1 << (i)) - 1)
 
@@ -641,6 +642,8 @@ static void at91_read_msg(struct net_device *dev, unsigned int mb)
 
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
+
+	can_led_event(dev, CAN_LED_EVENT_RX);
 }
 
 /**
@@ -875,6 +878,7 @@ static void at91_irq_tx(struct net_device *dev, u32 reg_sr)
 			/* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
 			can_get_echo_skb(dev, mb - get_mb_tx_first(priv));
 			dev->stats.tx_packets++;
+			can_led_event(dev, CAN_LED_EVENT_TX);
 		}
 	}
 
@@ -1128,6 +1132,8 @@ static int at91_open(struct net_device *dev)
 		goto out_close;
 	}
 
+	can_led_event(dev, CAN_LED_EVENT_OPEN);
+
 	/* start chip and queuing */
 	at91_chip_start(dev);
 	napi_enable(&priv->napi);
@@ -1159,6 +1165,8 @@ static int at91_close(struct net_device *dev)
 
 	close_candev(dev);
 
+	can_led_event(dev, CAN_LED_EVENT_STOP);
+
 	return 0;
 }
 
@@ -1321,6 +1329,8 @@ static int at91_can_probe(struct platform_device *pdev)
 		goto exit_free;
 	}
 
+	devm_can_led_init(dev);
+
 	dev_info(&pdev->dev, "device registered (reg_base=%p, irq=%d)\n",
 		 priv->reg_base, dev->irq);
 
-- 
1.7.12.1

