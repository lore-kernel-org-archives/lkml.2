Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab2EJPNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:13:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36822 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749Ab2EJPNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:13:06 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Jiri Pirko <jpirko@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH] net: device - added support of clearing device statistics
Date: Thu, 10 May 2012 20:46:01 +0530
Message-Id: <1336662961-15033-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support of clearing device statistics. Added new 
entry ndo_clear_stats to net_device_ops for device drivers to provide
there own method to clear stats otherwise internal statistics structure
is cleared.

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 include/linux/netdevice.h |    3 +++
 net/core/dev.c            |   23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbaa20..3366bd6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -935,6 +935,8 @@ struct net_device_ops {
 						     struct rtnl_link_stats64 *storage);
 	struct net_device_stats* (*ndo_get_stats)(struct net_device *dev);
 
+	void			(*ndo_clear_stats) (struct net_device *dev);
+
 	int			(*ndo_vlan_rx_add_vid)(struct net_device *dev,
 						       unsigned short vid);
 	int			(*ndo_vlan_rx_kill_vid)(struct net_device *dev,
@@ -2576,6 +2578,7 @@ extern void		dev_load(struct net *net, const char *name);
 extern void		dev_mcast_init(void);
 extern struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 					       struct rtnl_link_stats64 *storage);
+extern void dev_clear_stats(struct net_device *dev);
 extern void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 				    const struct net_device_stats *netdev_stats);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 9bb8f87..fc29ea4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5870,6 +5870,29 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 }
 EXPORT_SYMBOL(dev_get_stats);
 
+/**
+ *	dev_clear_stats	- Clear network device statistics
+ *	@dev: device to clear statistics from
+ *
+ *	Clears network statistics of device.
+ *	The device driver may provide its own method by setting
+ *	dev->netdev_ops->ndo_clear_stats;
+ *	otherwise the internal statistics structure is used.
+ */
+void dev_clear_stats(struct net_device *dev)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (ops->ndo_clear_stats)
+		ops->ndo_clear_stats(dev);
+	else
+		memset(&dev->stats, 0, sizeof(dev->stats));
+
+	atomic_long_set(&dev->rx_dropped, 0);
+	return;
+}
+EXPORT_SYMBOL(dev_clear_stats);
+
 struct netdev_queue *dev_ingress_queue_create(struct net_device *dev)
 {
 	struct netdev_queue *queue = dev_ingress_queue(dev);
-- 
1.7.3.4

