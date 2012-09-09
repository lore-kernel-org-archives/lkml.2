Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab2IIQSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 12:18:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40446 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2IIQSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 12:18:22 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Kurt Van Dijck <kurt.van.dijck@eia.be>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH v2] can: rename LED trigger name on netdev renames
Date: Sun,  9 Sep 2012 18:17:44 +0200
Message-Id: <1347207464-2002-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <20120907071934.GB37685@macbook.local>
References: <20120907071934.GB37685@macbook.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kurt Van Dijck <kurt.van.dijck@eia.be>

The LED trigger name for CAN devices is based on the initial
CAN device name, but does never change. The LED trigger name
is not guaranteed to be unique in case of hotplugging CAN devices.

This patch tries to address this problem by modifying the
LED trigger name according to the CAN device name when
the latter changes.

This patch is meant as illustration only.
In case of VCAN device rename, a segmentation fault will occur.

v1 - Kurt Van Dijck
v2 - Fabio Baltieri
- remove rename blocking if trigger is bound
- use led-subsystem function for the actual rename (still WiP)
- call init/exit functions from dev.c

Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---

Hi Kurt,

I like the can_priv_safe() idea, so I allowed myself to write a v2 of your
patch (hope you are ok with that - let me know if you think I should just post
a diff) to address the other issues I found and bring back the discussion.

So, that's what I changed:

- remove device rename blocking if trigger is bound: I don't think it's needed
  as we can just rename the trigger and everyone should be happy.  Besides that
  I don't like the idea of using list lock outside led-triggers.

- use led_trigger_rename_static to rename the LED: the actual implementation is
  a locked strcpy to prevent races, I just posted the patch in the linux-leds
  mailing list, so this patch depends on wether that would be accepted.
  Link: http://marc.info/?l=linux-kernel&m=134720454513067&w=2

- call init/exit functions from dev.c: that fixes builds as a module.  I also
  renamed functions to can_led_notifier_{init,exit} to avoid confusion with
  devm_can_led_init.

- left a TODO marker for you for a candev-safe v3 version :-)

As this is starting to look like a jam of patches, I pushed my working branch,
based upon Marc's can-next/led-trigger on:

git://github.com/fabiobaltieri/linux.git can-leds-devel

Let me know what you think of it.

Fabio

 drivers/net/can/dev.c   |  5 +++++
 drivers/net/can/led.c   | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/can/led.h |  9 +++++++++
 3 files changed, 60 insertions(+)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 963e2cc..f738841 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -25,6 +25,7 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/netlink.h>
+#include <linux/can/led.h>
 #include <net/rtnetlink.h>
 
 #define MOD_DESC "CAN device driver interface"
@@ -799,6 +800,8 @@ static __init int can_dev_init(void)
 {
 	int err;
 
+	can_led_notifier_init();
+
 	err = rtnl_link_register(&can_link_ops);
 	if (!err)
 		printk(KERN_INFO MOD_DESC "\n");
@@ -810,6 +813,8 @@ module_init(can_dev_init);
 static __exit void can_dev_exit(void)
 {
 	rtnl_link_unregister(&can_link_ops);
+
+	can_led_notifier_exit();
 }
 module_exit(can_dev_exit);
 
diff --git a/drivers/net/can/led.c b/drivers/net/can/led.c
index eaa14ac..43ebd47 100644
--- a/drivers/net/can/led.c
+++ b/drivers/net/can/led.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/can/dev.h>
+#include <linux/if_arp.h>
 
 #include <linux/can/led.h>
 
@@ -87,3 +88,48 @@ void devm_can_led_init(struct net_device *netdev)
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
+	char name[CAN_LED_NAME_SZ];
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
+	/* TODO: make sure we are can-dev safe */
+
+	snprintf(name, sizeof(name), "%s-tx", netdev->name);
+	led_trigger_rename_static(name, priv->tx_led_trig);
+
+	snprintf(name, sizeof(name), "%s-rx", netdev->name);
+	led_trigger_rename_static(name, priv->rx_led_trig);
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
 
-- 
1.7.11.rc1.9.gf623ca1.dirty

