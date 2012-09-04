Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab2IDJ3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:29:34 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:58919 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178Ab2IDJ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:29:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EALvJRVBtggBP/2dsb2JhbABFuyeBCIIhAQUnLyMQUTkeBgESiBG6QJI/A6VzgmU
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Fabio Baltieri <fabio.baltieri@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc: linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Kurt Van Dijck <kurt.van.dijck@eia.be>
Subject: [PATCH] can: rename LED trigger name on netdev renames
Date: Tue,  4 Sep 2012 11:29:11 +0200
Message-Id: <1346750951-10451-1-git-send-email-kurt.van.dijck@eia.be>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120904071128.GB416@vandijck-laurijssen.be>
References: <20120904071128.GB416@vandijck-laurijssen.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LED trigger name for CAN devices is based on the initial
CAN device name, but does never change. The LED trigger name
is not guaranteed to be unique in case of hotplugging CAN devices.

This patch tries to address this problem by modifying the
LED trigger name according to the CAN device name when
the latter changes.

This patch is meant as illustration only.
In case of VCAN device rename, a segmentation fault will occur.

Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
---
 drivers/net/can/led.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/net/can/led.c b/drivers/net/can/led.c
index eaa14ac..f62f908 100644
--- a/drivers/net/can/led.c
+++ b/drivers/net/can/led.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/can/dev.h>
+#include <linux/if_arp.h>
 
 #include <linux/can/led.h>
 
@@ -87,3 +88,59 @@ void devm_can_led_init(struct net_device *netdev)
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
+	struct net_device *netdev = (struct net_device *)data;
+	struct can_priv *priv = netdev_priv(netdev);
+	int busy = 0;
+
+	if (!net_eq(dev_net(netdev), &init_net))
+		return NOTIFY_DONE;
+
+	if (netdev->type != ARPHRD_CAN)
+		return NOTIFY_DONE;
+
+	if (msg != NETDEV_CHANGENAME)
+		return NOTIFY_DONE;
+
+	read_lock(&priv->tx_led_trig->leddev_list_lock);
+	if (!list_empty(&priv->tx_led_trig->led_cdevs))
+		++busy;
+	read_unlock(&priv->tx_led_trig->leddev_list_lock);
+	read_lock(&priv->rx_led_trig->leddev_list_lock);
+	if (!list_empty(&priv->rx_led_trig->led_cdevs))
+		++busy;
+	read_unlock(&priv->rx_led_trig->leddev_list_lock);
+
+	if (busy)
+		return notifier_from_errno(-EBUSY);
+
+	snprintf(priv->tx_led_trig_name, sizeof(priv->tx_led_trig_name),
+		 "%s-tx", netdev->name);
+	snprintf(priv->rx_led_trig_name, sizeof(priv->rx_led_trig_name),
+		 "%s-rx", netdev->name);
+	return NOTIFY_DONE;
+}
+
+/* notifier block for netdevice event */
+static struct notifier_block can_netdev_notifier __read_mostly = {
+	.notifier_call = can_led_notifier,
+};
+
+static __init int can_led_init(void)
+{
+	return register_netdevice_notifier(&can_netdev_notifier);
+}
+
+static __exit void can_led_exit(void)
+{
+	unregister_netdevice_notifier(&can_netdev_notifier);
+}
+
+module_init(can_led_init);
+module_exit(can_led_exit);
-- 
1.7.10.4

