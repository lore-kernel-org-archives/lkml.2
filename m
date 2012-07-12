Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162362Ab2GLWwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:52:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162235Ab2GLWpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes@sipsolutions.net>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 164/187] mwifiex: fix wrong return values in add_virtual_intf() error cases
Date: Thu, 12 Jul 2012 15:35:20 -0700
Message-Id: <20120712191538.538370098@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 858faa57dd9e2b91f3f870fbb1185982e42f5a2b upstream

add_virtual_intf() needs to return an ERR_PTR(), instead of NULL,
on errors, otherwise cfg80211 will crash.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/cfg80211.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1214,11 +1214,11 @@ struct net_device *mwifiex_add_virtual_i
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
@@ -1227,7 +1227,7 @@ struct net_device *mwifiex_add_virtual_i
 		if (priv->bss_mode) {
 			wiphy_err(wiphy, "cannot create multiple"
 					" station/adhoc interfaces\n");
-			return NULL;
+			return ERR_PTR(-EINVAL);
 		}
 
 		if (type == NL80211_IFTYPE_UNSPECIFIED)
@@ -1244,14 +1244,15 @@ struct net_device *mwifiex_add_virtual_i
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
@@ -1276,7 +1277,9 @@ struct net_device *mwifiex_add_virtual_i
 	/* Register network device */
 	if (register_netdevice(dev)) {
 		wiphy_err(wiphy, "cannot register virtual network device\n");
-		goto error;
+		free_netdev(dev);
+		priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
+		return ERR_PTR(-EFAULT);
 	}
 
 	sema_init(&priv->async_sem, 1);
@@ -1288,12 +1291,6 @@ struct net_device *mwifiex_add_virtual_i
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
 


