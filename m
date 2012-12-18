Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2LRR54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:57:56 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37383 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRR5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:57:55 -0500
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Bernd Krumboeck <b.krumboeck@gmail.com>, linux-kernel@vger.kernel.org,
        Bernd Krumboeck <krumboeck@universalnet.at>,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH 10/10] can: usb_8dev: add LED trigger support
Date: Tue, 18 Dec 2012 18:51:04 +0100
Message-Id: <1355853064-18144-11-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355853064-18144-1-git-send-email-fabio.baltieri@gmail.com>
References: <1355853064-18144-1-git-send-email-fabio.baltieri@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Krumboeck <b.krumboeck@gmail.com>

Add support for canbus activity led indicators on usb_8dev devices by
calling appropriate can_led functions.

These are only enabled when CONFIG_CAN_LEDS is Y, becomes no-op
otherwise.

Signed-off-by: Bernd Krumboeck <krumboeck@universalnet.at>
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 drivers/net/can/usb/usb_8dev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index 660b4f87..b4bb1a6 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -33,6 +33,7 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
+#include <linux/can/led.h>
 
 /* driver constants */
 #define MAX_RX_URBS			10
@@ -504,6 +505,8 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
 
 		stats->rx_packets++;
 		stats->rx_bytes += cf->can_dlc;
+
+		can_led_event(priv->netdev, CAN_LED_EVENT_RX);
 	} else {
 		netdev_warn(priv->netdev, "frame type %d unknown",
 			 msg->type);
@@ -606,6 +609,8 @@ static void usb_8dev_write_bulk_callback(struct urb *urb)
 
 	can_get_echo_skb(netdev, context->echo_index);
 
+	can_led_event(netdev, CAN_LED_EVENT_TX);
+
 	/* Release context */
 	context->echo_index = MAX_TX_URBS;
 
@@ -830,6 +835,8 @@ static int usb_8dev_open(struct net_device *netdev)
 	if (err)
 		return err;
 
+	can_led_event(netdev, CAN_LED_EVENT_OPEN);
+
 	/* finally start device */
 	err = usb_8dev_start(priv);
 	if (err) {
@@ -882,6 +889,8 @@ static int usb_8dev_close(struct net_device *netdev)
 
 	close_candev(netdev);
 
+	can_led_event(netdev, CAN_LED_EVENT_STOP);
+
 	return err;
 }
 
@@ -990,6 +999,8 @@ static int usb_8dev_probe(struct usb_interface *intf,
 			 (version>>8) & 0xff, version & 0xff);
 	}
 
+	devm_can_led_init(netdev);
+
 	return 0;
 
 cleanup_cmd_msg_buffer:
-- 
1.7.12.1

