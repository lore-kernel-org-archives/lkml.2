Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2IJUHC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:07:02 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:33815 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741Ab2IJUHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:07:00 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAMZHTlBtgrJV/2dsb2JhbABFhge1ToEIgiEBBSMELyMQJQImAgIUDRgkE4d+AxOoc4kdDYlTgSGJCGOFJDJgA5QIgVSLFoUIgmg
Date: Mon, 10 Sep 2012 22:06:48 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: [PATCH v4] can: rename LED trigger name on netdev renames
Message-ID: <20120910200648.GB546@vandijck-laurijssen.be>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	linux-kernel@vger.kernel.org, linux-can@vger.kernel.org
References: <20120907071934.GB37685@macbook.local>
 <1347207464-2002-1-git-send-email-fabio.baltieri@gmail.com>
 <20120910142827.GB11000@vandijck-laurijssen.be>
 <504E30AE.50201@hartkopp.net>
 <20120910184049.GD2006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120910184049.GD2006@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can: rename LED trigger name on netdev renames

The LED trigger name for CAN devices is based on the initial
CAN device name, but does never change. The LED trigger name
is not guaranteed to be unique in case of hotplugging CAN devices.

This patch tries to address this problem by modifying the
LED trigger name according to the CAN device name when
the latter changes.

v1 - Kurt Van Dijck
v2 - Fabio Baltieri
- remove rename blocking if trigger is bound
- use led-subsystem function for the actual rename (still WiP)
- call init/exit functions from dev.c
v3 - Kurt Van Dijck
- safe operation for non-candev based devices (vcan, slcan)
	based on earlier patch
v4 - Kurt Van Dijck
- trivial patch mistakes fixed

Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 5112cf3..df87c28 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -25,6 +25,7 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/netlink.h>
+#include <linux/can/led.h>
 #include <net/rtnetlink.h>
 
 #define MOD_DESC "CAN device driver interface"
@@ -812,6 +813,8 @@ static __init int can_dev_init(void)
 {
 	int err;
 
+	can_led_notifier_init();
+
 	err = rtnl_link_register(&can_link_ops);
 	if (!err)
 		printk(KERN_INFO MOD_DESC "\n");
@@ -823,6 +826,8 @@ module_init(can_dev_init);
 static __exit void can_dev_exit(void)
 {
 	rtnl_link_unregister(&can_link_ops);
+
+	can_led_notifier_exit();
 }
 module_exit(can_dev_exit);
 
diff --git a/drivers/net/can/led.c b/drivers/net/can/led.c
index eaa14ac..227d359 100644
--- a/drivers/net/can/led.c
+++ b/drivers/net/can/led.c
@@ -1,5 +1,6 @@
 /*
  * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
+ * Copyright 2012, Kurt Van Dijck <kurt.van.dijck@eia.be>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -87,3 +88,42 @@ void devm_can_led_init(struct net_device *netdev)
 	devres_add(&netdev->dev, res);
 }
 EXPORT_SYMBOL_GPL(devm_can_led_init);
+
+/*
+ * NETDEV rename notifier to rename the associated led triggers too
+ */
+static int can_led_notifier(struct notifier_block *nb, unsigned long msg,
+			void *data)
+{
+	struct net_device *netdev = data;
+	struct can_priv *priv = safe_candev_priv(netdev);
+	char name[CAN_LED_NAME_SZ];
+
+	if (!priv)
+		return NOTIFY_DONE;
+
+	if (msg == NETDEV_CHANGENAME) {
+		snprintf(name, sizeof(name), "%s-tx", netdev->name);
+		led_trigger_rename_static(name, priv->tx_led_trig);
+
+		snprintf(name, sizeof(name), "%s-rx", netdev->name);
+		led_trigger_rename_static(name, priv->rx_led_trig);
+	}
+
+	return NOTIFY_DONE;
+}
+
+/* notifier block for netdevice event */
+static struct notifier_block can_netdev_notifier __read_mostly = {
+	.notifier_call = can_led_notifier,
+};
+
+int __init can_led_notifier_init(void)
+{
+	return register_netdevice_notifier(&can_netdev_notifier);
+}
+
+void __exit can_led_notifier_exit(void)
+{
+	unregister_netdevice_notifier(&can_netdev_notifier);
+}
diff --git a/include/linux/can/led.h b/include/linux/can/led.h
index 12d5549..9c1167b 100644
--- a/include/linux/can/led.h
+++ b/include/linux/can/led.h
@@ -26,6 +26,8 @@ enum can_led_event {
 
 void can_led_event(struct net_device *netdev, enum can_led_event event);
 void devm_can_led_init(struct net_device *netdev);
+int __init can_led_notifier_init(void);
+void __exit can_led_notifier_exit(void);
 
 #else
 
@@ -36,6 +38,13 @@ static inline void can_led_event(struct net_device *netdev,
 static inline void devm_can_led_init(struct net_device *netdev)
 {
 }
+static inline int can_led_notifier_init(void)
+{
+	return 0;
+}
+static inline void can_led_notifier_exit(void)
+{
+}
 
 #endif
 
