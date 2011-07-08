Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1GHFAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:00:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab1GHFAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:00:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:53 2011
Message-Id: <20110708001652.949702720@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Micha=A9=A9=20Miros=A9=A9aw?= 
	<mirq-linux@rere.qmqm.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: [002/107] net: fix ETHTOOL_SFEATURES compatibility with old ethtool_ops.set_flags
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>

[ Upstream commit fd0daf9d58f6b3342d07c5f6bbfb304dbe5db4ec ]

Current code squashes flags to bool - this makes set_flags fail whenever
some ETH_FLAG_* equivalent features are set. Fix this.

Signed-off-by: Micha©© Miros©©aw <mirq-linux@rere.qmqm.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/ethtool.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -231,6 +231,29 @@ static int ethtool_set_feature_compat(st
 	return 1;
 }
 
+static int ethtool_set_flags_compat(struct net_device *dev,
+	int (*legacy_set)(struct net_device *, u32),
+	struct ethtool_set_features_block *features, u32 mask)
+{
+	u32 value;
+
+	if (!legacy_set)
+		return 0;
+
+	if (!(features[0].valid & mask))
+		return 0;
+
+	value = dev->features & ~features[0].valid;
+	value |= features[0].requested;
+
+	features[0].valid &= ~mask;
+
+	if (legacy_set(dev, value & mask) < 0)
+		netdev_info(dev, "Legacy flags change failed\n");
+
+	return 1;
+}
+
 static int ethtool_set_features_compat(struct net_device *dev,
 	struct ethtool_set_features_block *features)
 {
@@ -247,7 +270,7 @@ static int ethtool_set_features_compat(s
 		features, NETIF_F_ALL_TSO);
 	compat |= ethtool_set_feature_compat(dev, dev->ethtool_ops->set_rx_csum,
 		features, NETIF_F_RXCSUM);
-	compat |= ethtool_set_feature_compat(dev, dev->ethtool_ops->set_flags,
+	compat |= ethtool_set_flags_compat(dev, dev->ethtool_ops->set_flags,
 		features, flags_dup_features);
 
 	return compat;


