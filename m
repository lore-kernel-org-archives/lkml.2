Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2LPLJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 06:09:58 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58420 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2LPLJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 06:09:54 -0500
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH 5/9] can: c_can: add LED trigger support
Date: Sun, 16 Dec 2012 12:08:29 +0100
Message-Id: <1355656113-9562-6-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
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
 drivers/net/can/c_can/c_can.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 5233b8f..57eb1e7 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -39,6 +39,7 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
+#include <linux/can/led.h>
 
 #include "c_can.h"
 
@@ -477,6 +478,8 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, int ctrl)
 	stats->rx_packets++;
 	stats->rx_bytes += frame->can_dlc;
 
+	can_led_event(dev, CAN_LED_EVENT_RX);
+
 	return 0;
 }
 
@@ -751,6 +754,7 @@ static void c_can_do_tx(struct net_device *dev)
 					C_CAN_IFACE(MSGCTRL_REG, 0))
 					& IF_MCONT_DLC_MASK;
 			stats->tx_packets++;
+			can_led_event(dev, CAN_LED_EVENT_TX);
 			c_can_inval_msg_object(dev, 0, msg_obj_no);
 		} else {
 			break;
@@ -1115,6 +1119,8 @@ static int c_can_open(struct net_device *dev)
 
 	napi_enable(&priv->napi);
 
+	can_led_event(dev, CAN_LED_EVENT_OPEN);
+
 	/* start the c_can controller */
 	c_can_start(dev);
 
@@ -1143,6 +1149,8 @@ static int c_can_close(struct net_device *dev)
 	c_can_reset_ram(priv, false);
 	c_can_pm_runtime_put_sync(priv);
 
+	can_led_event(dev, CAN_LED_EVENT_STOP);
+
 	return 0;
 }
 
@@ -1268,6 +1276,8 @@ int register_c_can_dev(struct net_device *dev)
 	err = register_candev(dev);
 	if (err)
 		c_can_pm_runtime_disable(priv);
+	else
+		devm_can_led_init(dev);
 
 	return err;
 }
-- 
1.7.12.1

