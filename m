Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2LRSAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:00:17 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:59234 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2LRSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:00:15 -0500
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Bernd Krumboeck <b.krumboeck@gmail.com>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>,
        Anant Gole <anantgole@ti.com>
Subject: [PATCH 06/10] can: ti_hecc: add LED trigger support
Date: Tue, 18 Dec 2012 18:51:00 +0100
Message-Id: <1355853064-18144-7-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355853064-18144-1-git-send-email-fabio.baltieri@gmail.com>
References: <1355853064-18144-1-git-send-email-fabio.baltieri@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for canbus activity led indicators on ti_hecc devices by
calling appropriate can_led functions.

These are only enabled when CONFIG_CAN_LEDS is Y, becomes no-op
otherwise.

Cc: Anant Gole <anantgole@ti.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 drivers/net/can/ti_hecc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index f898c63..f52a975 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -50,6 +50,7 @@
 
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
+#include <linux/can/led.h>
 #include <linux/can/platform/ti_hecc.h>
 
 #define DRV_NAME "ti_hecc"
@@ -593,6 +594,7 @@ static int ti_hecc_rx_pkt(struct ti_hecc_priv *priv, int mbxno)
 	spin_unlock_irqrestore(&priv->mbx_lock, flags);
 
 	stats->rx_bytes += cf->can_dlc;
+	can_led_event(priv->ndev, CAN_LED_EVENT_RX);
 	netif_receive_skb(skb);
 	stats->rx_packets++;
 
@@ -796,6 +798,7 @@ static irqreturn_t ti_hecc_interrupt(int irq, void *dev_id)
 			stats->tx_bytes += hecc_read_mbx(priv, mbxno,
 						HECC_CANMCF) & 0xF;
 			stats->tx_packets++;
+			can_led_event(ndev, CAN_LED_EVENT_TX);
 			can_get_echo_skb(ndev, mbxno);
 			--priv->tx_tail;
 		}
@@ -851,6 +854,8 @@ static int ti_hecc_open(struct net_device *ndev)
 		return err;
 	}
 
+	can_led_event(ndev, CAN_LED_EVENT_OPEN);
+
 	ti_hecc_start(ndev);
 	napi_enable(&priv->napi);
 	netif_start_queue(ndev);
@@ -869,6 +874,8 @@ static int ti_hecc_close(struct net_device *ndev)
 	close_candev(ndev);
 	ti_hecc_transceiver_switch(priv, 0);
 
+	can_led_event(ndev, CAN_LED_EVENT_STOP);
+
 	return 0;
 }
 
@@ -961,6 +968,9 @@ static int ti_hecc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "register_candev() failed\n");
 		goto probe_exit_clk;
 	}
+
+	devm_can_led_init(ndev);
+
 	dev_info(&pdev->dev, "device registered (reg_base=%p, irq=%u)\n",
 		priv->base, (u32) ndev->irq);
 
-- 
1.7.12.1

