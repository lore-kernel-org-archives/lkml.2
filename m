Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2GIOkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:40:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38292 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754486Ab2GIOiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:24 -0400
Message-Id: <20120709143120.195236088@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bing Zhao <bzhao@marvell.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 24/48] mwifiex: fix wrong return values in  add_virtual_intf() error cases
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 858faa57dd9e2b91f3f870fbb1185982e42f5a2b upstream

backported for linux-3.2.y, linux-3.3.y, linux-3.4.y

add_virtual_intf() needs to return an ERR_PTR(), instead of NULL,
on errors, otherwise cfg80211 will crash.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6505038..baf6919 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1214,11 +1214,11 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	void *mdev_priv;
 
 	if (!priv)
-		return NULL;
+		return ERR_PTR(-EFAULT);
 
 	adapter = priv->adapter;
 	if (!adapter)
-		return NULL;
+		return ERR_PTR(-EFAULT);
 
 	switch (type) {
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -1227,7 +1227,7 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		if (priv->bss_mode) {
 			wiphy_err(wiphy, "cannot create multiple"
 					" station/adhoc interfaces\n");
-			return NULL;
+			return ERR_PTR(-EINVAL);
 		}
 
 		if (type == NL80211_IFTYPE_UNSPECIFIED)
@@ -1244,14 +1244,15 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		break;
 	default:
 		wiphy_err(wiphy, "type not supported\n");
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), name,
 			      ether_setup, 1);
 	if (!dev) {
 		wiphy_err(wiphy, "no memory available for netdevice\n");
-		goto error;
+		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	dev_net_set(dev, wiphy_net(wiphy));
@@ -1276,7 +1277,9 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	/* Register network device */
 	if (register_netdevice(dev)) {
 		wiphy_err(wiphy, "cannot register virtual network device\n");
-		goto error;
+		free_netdev(dev);
+		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
+		return ERR_PTR(-EFAULT);
 	}
 
 	sema_init(&priv->async_sem, 1);
@@ -1288,12 +1291,6 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	mwifiex_dev_debugfs_init(priv);
 #endif
 	return dev;
-error:
-	if (dev && (dev->reg_state == NETREG_UNREGISTERED))
-		free_netdev(dev);
-	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
-
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(mwifiex_add_virtual_intf);
 


