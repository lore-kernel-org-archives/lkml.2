Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2BVMhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:37:03 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:44652 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994Ab2BVMg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:36:56 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Sergey Lapin <slapin@ossfans.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net/ieee802154/6lowpan.c: reuse eth_mac_addr()
Date: Wed, 22 Feb 2012 13:36:39 +0100
Message-Id: <1329914199-30862-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1329914199-30862-1-git-send-email-danny.kukawka@bisect.de>
References: <1329914199-30862-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329914216;b046ad00;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use eth_mac_addr() for .ndo_set_mac_address, remove
lowpan_set_address since it do currently the same as
eth_mac_addr(). Additional advantage: eth_mac_addr() already
checks if the given address is valid

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 net/ieee802154/6lowpan.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index e4ecc1e..3685158 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -55,6 +55,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <net/af_ieee802154.h>
 #include <net/ieee802154.h>
 #include <net/ieee802154_netdev.h>
@@ -924,19 +925,6 @@ drop:
 	return -EINVAL;
 }
 
-static int lowpan_set_address(struct net_device *dev, void *p)
-{
-	struct sockaddr *sa = p;
-
-	if (netif_running(dev))
-		return -EBUSY;
-
-	/* TODO: validate addr */
-	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len);
-
-	return 0;
-}
-
 static int lowpan_get_mac_header_length(struct sk_buff *skb)
 {
 	/*
@@ -1062,7 +1050,7 @@ static struct header_ops lowpan_header_ops = {
 
 static const struct net_device_ops lowpan_netdev_ops = {
 	.ndo_start_xmit		= lowpan_xmit,
-	.ndo_set_mac_address	= lowpan_set_address,
+	.ndo_set_mac_address	= eth_mac_addr,
 };
 
 static void lowpan_setup(struct net_device *dev)
-- 
1.7.8.3

