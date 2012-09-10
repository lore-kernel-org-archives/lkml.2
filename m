Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2IJT4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:56:10 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:41131 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070Ab2IJT4G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:56:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAFFFTlBtgrJV/2dsb2JhbABFhge1ToEIgiEBBSMELyMQJQImAgIUJSQTiBSobJJ+gSGKC4UEMmADlVyJNIZqgmiBWQ
Date: Mon, 10 Sep 2012 21:55:58 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: [PATCH v2] can: export a safe netdev_priv wrapper for candev
Message-ID: <20120910195558.GA546@vandijck-laurijssen.be>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	linux-kernel@vger.kernel.org, linux-can@vger.kernel.org
References: <20120907071934.GB37685@macbook.local>
 <1347207464-2002-1-git-send-email-fabio.baltieri@gmail.com>
 <20120910142507.GA11000@vandijck-laurijssen.be>
 <20120910182929.GC2006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20120910182929.GC2006@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can: export a safe netdev_priv wrapper for candev

In net_device notifier calls, it was impossible to determine
if a CAN device is based on candev in a safe way.
This patch adds such test in order to access candev storage
from within those notifiers.

Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 963e2cc..5112cf3 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -795,6 +795,19 @@ void unregister_candev(struct net_device *dev)
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
 
