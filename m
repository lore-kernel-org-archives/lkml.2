Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2BQPpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:45:55 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:42960 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942Ab2BQPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:45:53 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Jeff Dike <jdike@addtoit.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] UML net: set addr_assign_type if random_ether_addr() used
Date: Fri, 17 Feb 2012 16:43:31 +0100
Message-Id: <1329493411-25750-11-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329493553;67bc8f7c;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set addr_assign_type correctly to NET_ADDR_RANDOM in case
a random MAC address was generated and assigned to the netdevice.

Return state from setup_etheraddr() about returning a random
MAC address or not and check this state in eth_configure().

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/um/drivers/net_kern.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index a492e59..d299618 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -293,7 +293,7 @@ static void uml_net_user_timer_expire(unsigned long _conn)
 #endif
 }
 
-static void setup_etheraddr(char *str, unsigned char *addr, char *name)
+static int setup_etheraddr(char *str, unsigned char *addr, char *name)
 {
 	char *end;
 	int i;
@@ -334,12 +334,13 @@ static void setup_etheraddr(char *str, unsigned char *addr, char *name)
 		       addr[0] | 0x02, addr[1], addr[2], addr[3], addr[4],
 		       addr[5]);
 	}
-	return;
+	return 0;
 
 random:
 	printk(KERN_INFO
 	       "Choosing a random ethernet address for device %s\n", name);
 	random_ether_addr(addr);
+	return 1;
 }
 
 static DEFINE_SPINLOCK(devices_lock);
@@ -391,6 +392,7 @@ static void eth_configure(int n, void *init, char *mac,
 	struct net_device *dev;
 	struct uml_net_private *lp;
 	int err, size;
+	int random_mac;
 
 	size = transport->private_size + sizeof(struct uml_net_private);
 
@@ -417,7 +419,7 @@ static void eth_configure(int n, void *init, char *mac,
 	 */
 	snprintf(dev->name, sizeof(dev->name), "eth%d", n);
 
-	setup_etheraddr(mac, device->mac, dev->name);
+	random_mac = setup_etheraddr(mac, device->mac, dev->name);
 
 	printk(KERN_INFO "Netdevice %d (%pM) : ", n, device->mac);
 
@@ -474,6 +476,9 @@ static void eth_configure(int n, void *init, char *mac,
 
 	/* don't use eth_mac_addr, it will not work here */
 	memcpy(dev->dev_addr, device->mac, ETH_ALEN);
+	if (random_mac)
+		dev->addr_assign_type |= NET_ADDR_RANDOM;
+
 	dev->mtu = transport->user->mtu;
 	dev->netdev_ops = &uml_netdev_ops;
 	dev->ethtool_ops = &uml_net_ethtool_ops;
-- 
1.7.8.3

