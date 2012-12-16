Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2LPLKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 06:10:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57247 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2LPLKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 06:10:03 -0500
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] can: export a safe netdev_priv wrapper for candev
Date: Sun, 16 Dec 2012 12:08:32 +0100
Message-Id: <1355656113-9562-9-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kurt Van Dijck <kurt.van.dijck@eia.be>

In net_device notifier calls, it was impossible to determine
if a CAN device is based on candev in a safe way.
This patch adds such test in order to access candev storage
from within those notifiers.

Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 drivers/net/can/dev.c   | 13 +++++++++++++
 include/linux/can/dev.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 8233e5e..13e7380 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -794,6 +794,19 @@ void unregister_candev(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(unregister_candev);
 
+/*
+ * Test if a network device is a candev based device
+ * and return the can_priv* if so.
+ */
+struct can_priv *safe_candev_priv(struct net_device *dev)
+{
+	if ((dev->type != ARPHRD_CAN) || (dev->rtnl_link_ops != &can_link_ops))
+		return NULL;
+
+	return netdev_priv(dev);
+}
+EXPORT_SYMBOL_GPL(safe_candev_priv);
+
 static __init int can_dev_init(void)
 {
 	int err;
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 7747d9b..fb0ab65 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -106,6 +106,9 @@ u8 can_len2dlc(u8 len);
 struct net_device *alloc_candev(int sizeof_priv, unsigned int echo_skb_max);
 void free_candev(struct net_device *dev);
 
+/* a candev safe wrapper around netdev_priv */
+struct can_priv *safe_candev_priv(struct net_device *dev);
+
 int open_candev(struct net_device *dev);
 void close_candev(struct net_device *dev);
 
-- 
1.7.12.1

