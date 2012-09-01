Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2IAP6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 11:58:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60424 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083Ab2IAP5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 11:57:19 -0400
X-Sasl-enc: h/NaTAEXzc4q9DflIwIz2EcTFp43HY6oIQvkIXmimCBW 1346515038
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Cheneau <tony.cheneau@amnesiak.org>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH v3 2/2] 6lowpan: handle NETDEV_UNREGISTER event
Date: Sat,  1 Sep 2012 11:57:07 -0400
Message-Id: <1346515027-5237-3-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1346294341-26808-1-git-send-email-alan@signal11.us>
References: <1346294341-26808-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before, it was impossible to remove a wpan device which had lowpan
attached to it.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/ieee802154/6lowpan.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index b28ec79..d529111 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1063,12 +1063,6 @@ out:
 	return (err < 0 ? NETDEV_TX_BUSY : NETDEV_TX_OK);
 }
 
-static void lowpan_dev_free(struct net_device *dev)
-{
-	dev_put(lowpan_dev_info(dev)->real_dev);
-	free_netdev(dev);
-}
-
 static struct wpan_phy *lowpan_get_phy(const struct net_device *dev)
 {
 	struct net_device *real_dev = lowpan_dev_info(dev)->real_dev;
@@ -1118,7 +1112,7 @@ static void lowpan_setup(struct net_device *dev)
 	dev->netdev_ops		= &lowpan_netdev_ops;
 	dev->header_ops		= &lowpan_header_ops;
 	dev->ml_priv		= &lowpan_mlme;
-	dev->destructor		= lowpan_dev_free;
+	dev->destructor		= free_netdev;
 }
 
 static int lowpan_validate(struct nlattr *tb[], struct nlattr *data[])
@@ -1244,6 +1238,34 @@ static inline void __init lowpan_netlink_fini(void)
 	rtnl_link_unregister(&lowpan_link_ops);
 }
 
+static int lowpan_device_event(struct notifier_block *unused,
+				unsigned long event,
+				void *ptr)
+{
+	struct net_device *dev = ptr;
+	LIST_HEAD(del_list);
+	struct lowpan_dev_record *entry, *tmp;
+
+	if (dev->type != ARPHRD_IEEE802154)
+		goto out;
+
+	if (event == NETDEV_UNREGISTER) {
+		list_for_each_entry_safe(entry, tmp, &lowpan_devices, list) {
+			if (lowpan_dev_info(entry->ldev)->real_dev == dev)
+				lowpan_dellink(entry->ldev, &del_list);
+		}
+
+		unregister_netdevice_many(&del_list);
+	};
+
+out:
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block lowpan_dev_notifier = {
+	.notifier_call = lowpan_device_event,
+};
+
 static struct packet_type lowpan_packet_type = {
 	.type = __constant_htons(ETH_P_IEEE802154),
 	.func = lowpan_rcv,
@@ -1258,6 +1280,12 @@ static int __init lowpan_init_module(void)
 		goto out;
 
 	dev_add_pack(&lowpan_packet_type);
+
+	err = register_netdevice_notifier(&lowpan_dev_notifier);
+	if (err < 0) {
+		dev_remove_pack(&lowpan_packet_type);
+		lowpan_netlink_fini();
+	}
 out:
 	return err;
 }
@@ -1270,6 +1298,8 @@ static void __exit lowpan_cleanup_module(void)
 
 	dev_remove_pack(&lowpan_packet_type);
 
+	unregister_netdevice_notifier(&lowpan_dev_notifier);
+
 	/* Now 6lowpan packet_type is removed, so no new fragments are
 	 * expected on RX, therefore that's the time to clean incomplete
 	 * fragments.
-- 
1.7.0.4

