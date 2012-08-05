Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2HEOuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 10:50:18 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35610 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2HEOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 10:50:13 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-can@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Baltieri <fabio.baltieri@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        AnilKumar Ch <anilkumar@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH can-next 3/5] can: c_can: add LED trigger support
Date: Sun,  5 Aug 2012 16:51:48 +0200
Message-Id: <1344178310-2898-3-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1344178310-2898-1-git-send-email-fabio.baltieri@gmail.com>
References: <20120805144814.GA2804@gmail.com>
 <1344178310-2898-1-git-send-email-fabio.baltieri@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for canbus activity led indicators on c_can devices by
calling appropriate can_led functions.

These are only enabled when CONFIG_CAN_LEDS is Y, becomes no-op
otherwise.

Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
Cc: AnilKumar Ch <anilkumar@ti.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 drivers/net/can/c_can/c_can.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 4c538e3..a8c5807 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -38,6 +38,7 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
+#include <linux/can/led.h>
 
 #include "c_can.h"
 
@@ -439,6 +440,8 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, int ctrl)
 	stats->rx_packets++;
 	stats->rx_bytes += frame->can_dlc;
 
+	can_led_event(dev, CAN_LED_EVENT_RX);
+
 	return 0;
 }
 
@@ -709,6 +712,7 @@ static void c_can_do_tx(struct net_device *dev)
 					C_CAN_IFACE(MSGCTRL_REG, 0))
 					& IF_MCONT_DLC_MASK;
 			stats->tx_packets++;
+			can_led_event(dev, CAN_LED_EVENT_TX);
 			c_can_inval_msg_object(dev, 0, msg_obj_no);
 		} else {
 			break;
@@ -1070,6 +1074,8 @@ static int c_can_open(struct net_device *dev)
 
 	napi_enable(&priv->napi);
 
+	can_led_event(dev, CAN_LED_EVENT_OPEN);
+
 	/* start the c_can controller */
 	c_can_start(dev);
 
@@ -1092,6 +1098,8 @@ static int c_can_close(struct net_device *dev)
 	free_irq(dev->irq, dev);
 	close_candev(dev);
 
+	can_led_event(dev, CAN_LED_EVENT_STOP);
+
 	return 0;
 }
 
@@ -1133,10 +1141,17 @@ static const struct net_device_ops c_can_netdev_ops = {
 
 int register_c_can_dev(struct net_device *dev)
 {
+	int ret;
+
 	dev->flags |= IFF_ECHO;	/* we support local echo */
 	dev->netdev_ops = &c_can_netdev_ops;
 
-	return register_candev(dev);
+	ret = register_candev(dev);
+
+	if (!ret)
+		devm_can_led_init(dev);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(register_c_can_dev);
 
-- 
1.7.11.rc1.9.gf623ca1.dirty

