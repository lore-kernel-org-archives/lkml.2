Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2GFWq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:46:26 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37447 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab2GFWpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:45:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        "Theodore Ts'o" <tytso@mit.edu>, David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org
Subject: [PATCH 06/12] net: feed /dev/random with the MAC address when registering a device
Date: Fri,  6 Jul 2012 18:44:58 -0400
Message-Id: <1341614704-24965-7-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341614704-24965-1-git-send-email-tytso@mit.edu>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: David Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 net/core/dev.c       | 3 +++
 net/core/rtnetlink.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6df2140..bdd1e88 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1172,6 +1172,7 @@ static int __dev_open(struct net_device *dev)
 		net_dmaengine_get();
 		dev_set_rx_mode(dev);
 		dev_activate(dev);
+		add_device_randomness(dev->dev_addr, dev->addr_len);
 	}
 
 	return ret;
@@ -4763,6 +4764,7 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa)
 	err = ops->ndo_set_mac_address(dev, sa);
 	if (!err)
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
+	add_device_randomness(dev->dev_addr, dev->addr_len);
 	return err;
 }
 EXPORT_SYMBOL(dev_set_mac_address);
@@ -5541,6 +5543,7 @@ int register_netdevice(struct net_device *dev)
 	dev_init_scheduler(dev);
 	dev_hold(dev);
 	list_netdevice(dev);
+	add_device_randomness(dev->dev_addr, dev->addr_len);
 
 	/* Notify protocols, that a new device appeared. */
 	ret = call_netdevice_notifiers(NETDEV_REGISTER, dev);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 21318d1..f058e59 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1378,6 +1378,7 @@ static int do_setlink(struct net_device *dev, struct ifinfomsg *ifm,
 			goto errout;
 		send_addr_notify = 1;
 		modified = 1;
+		add_device_randomness(dev->dev_addr, dev->addr_len);
 	}
 
 	if (tb[IFLA_MTU]) {
-- 
1.7.11.1.108.gb129051

